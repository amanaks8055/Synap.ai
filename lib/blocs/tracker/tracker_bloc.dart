import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../models/tracker_tool.dart';
import 'tracker_event.dart';
import 'tracker_state.dart';

class TrackerBloc extends Bloc<TrackerEvent, TrackerState> {
  final FlutterLocalNotificationsPlugin? notifications;

  TrackerBloc({this.notifications}) : super(const TrackerState()) {
    on<TrackerToolUpdated>(_onToolUpdated);
    on<TrackerRefreshRequested>(_onRefreshRequested);
    on<TrackerToolToggled>(_onToolToggled);
    on<TrackerUsageSet>(_onUsageSet);
    on<TrackerUsageLogged>(_onUsageLogged);
    on<TrackerManualReset>(_onManualReset);
    on<TrackerToolPinned>(_onToolPinned);
    on<TrackerCustomToolAdded>(_onCustomToolAdded);
  }

  // ── Tool updated from extension sync ────────────────────
  Future<void> _onToolUpdated(
    TrackerToolUpdated event,
    Emitter<TrackerState> emit,
  ) async {
    final existingTools = List<TrackerTool>.from(state.tools);
    final idx = existingTools.indexWhere((t) => t.id == event.tool.id);

    final wasExhausted =
        idx >= 0 ? existingTools[idx].isExhausted : false;
    final wasLow = idx >= 0 ? existingTools[idx].isLow : false;

    // Preserve isPinned and isEnabled from existing tool
    final updatedTool = idx >= 0
        ? event.tool.copyWith(
            isEnabled: existingTools[idx].isEnabled,
            isPinned: existingTools[idx].isPinned,
          )
        : event.tool;

    if (idx >= 0) {
      existingTools[idx] = updatedTool;
    } else {
      existingTools.add(updatedTool);
    }

    String? alertId;
    if (!wasExhausted && updatedTool.isExhausted) {
      alertId = updatedTool.id;
      await _notify(
        title: '🔴 ${updatedTool.name} limit reached!',
        body: 'Switch to ${state.bestToolNow?.name ?? "another AI"} now.',
      );
    } else if (!wasLow && updatedTool.isLow) {
      alertId = updatedTool.id;
      await _notify(
        title: '⚠️ ${updatedTool.name} at 80%',
        body:
            '${updatedTool.sessionUsed}/${updatedTool.sessionLimit} messages used',
      );
    }

    emit(state.copyWith(
      status: TrackerStatus.loaded,
      tools: existingTools,
      lastSync: DateTime.now(),
      isLive: true,
      alertToolId: alertId,
    ));
  }

  // ── Refresh requested ─────────────────────────────────────
  void _onRefreshRequested(
    TrackerRefreshRequested event,
    Emitter<TrackerState> emit,
  ) {
    emit(state.copyWith(status: TrackerStatus.loading));
  }

  // ── Toggle tool enabled/disabled ─────────────────────────
  void _onToolToggled(
    TrackerToolToggled event,
    Emitter<TrackerState> emit,
  ) {
    final tools = List<TrackerTool>.from(state.tools);
    final idx = tools.indexWhere((t) => t.id == event.toolId);
    if (idx < 0) return;
    tools[idx] = tools[idx].copyWith(isEnabled: !tools[idx].isEnabled);
    emit(state.copyWith(tools: tools));
  }

  // ── Set usage to specific count ────────────────────────
  void _onUsageSet(
    TrackerUsageSet event,
    Emitter<TrackerState> emit,
  ) {
    final tools = List<TrackerTool>.from(state.tools);
    final idx = tools.indexWhere((t) => t.id == event.toolId);
    if (idx < 0) return;
    tools[idx] = tools[idx].copyWith(
      sessionUsed: event.count.clamp(0, tools[idx].sessionLimit + 10),
    );
    emit(state.copyWith(tools: tools, status: TrackerStatus.loaded));
  }

  // ── Log usage increment ───────────────────────────────────
  void _onUsageLogged(
    TrackerUsageLogged event,
    Emitter<TrackerState> emit,
  ) {
    final tools = List<TrackerTool>.from(state.tools);
    final idx = tools.indexWhere((t) => t.id == event.toolId);
    if (idx < 0) return;
    tools[idx] = tools[idx].copyWith(
      sessionUsed:
          (tools[idx].sessionUsed + event.count).clamp(0, tools[idx].sessionLimit + 10),
    );
    emit(state.copyWith(tools: tools));
  }

  // ── Manual reset ──────────────────────────────────────────
  void _onManualReset(
    TrackerManualReset event,
    Emitter<TrackerState> emit,
  ) {
    final tools = List<TrackerTool>.from(state.tools);
    final idx = tools.indexWhere((t) => t.id == event.toolId);
    if (idx < 0) return;
    tools[idx] = tools[idx].copyWith(sessionUsed: 0, resetAt: null);
    emit(state.copyWith(tools: tools, alertToolId: null));
  }

  // ── Pin / Unpin tool ──────────────────────────────────────
  void _onToolPinned(
    TrackerToolPinned event,
    Emitter<TrackerState> emit,
  ) {
    final tools = List<TrackerTool>.from(state.tools);
    final idx = tools.indexWhere((t) => t.id == event.toolId);
    if (idx < 0) return;
    tools[idx] = tools[idx].copyWith(isPinned: !tools[idx].isPinned);
    emit(state.copyWith(tools: tools));
  }

  // ── Add custom tool ───────────────────────────────────────
  void _onCustomToolAdded(
    TrackerCustomToolAdded event,
    Emitter<TrackerState> emit,
  ) {
    final tools = List<TrackerTool>.from(state.tools);
    final id = event.name.toLowerCase().replaceAll(' ', '_');
    if (tools.any((t) => t.id == id)) return;

    tools.add(TrackerTool(
      id: id,
      name: event.name,
      sessionLimit: event.freeLimit > 0 ? event.freeLimit : event.limit,
      isEnabled: true,
    ));
    emit(state.copyWith(tools: tools));
  }

  // ── Notification helper ───────────────────────────────────
  Future<void> _notify({
    required String title,
    required String body,
  }) async {
    try {
      await notifications?.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'synap_tracker',
            'Synap Tracker',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    } catch (_) {}
  }
}
