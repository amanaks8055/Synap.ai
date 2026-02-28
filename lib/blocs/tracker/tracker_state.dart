import 'package:equatable/equatable.dart';
import '../../models/tracker_tool.dart';

enum TrackerStatus { initial, loading, loaded, error }

class TrackerState extends Equatable {
  final TrackerStatus status;
  final List<TrackerTool> tools;
  final DateTime? lastSync;
  final bool isLive;
  final String? alertToolId;
  final String? errorMessage;

  const TrackerState({
    this.status = TrackerStatus.initial,
    this.tools = const [],
    this.lastSync,
    this.isLive = false,
    this.alertToolId,
    this.errorMessage,
  });

  // ── Filtered getters (screen use karta hai) ──────────────
  List<TrackerTool> get activeTools =>
      tools.where((t) => t.isEnabled).toList()
        ..sort((a, b) {
          if (a.isPinned && !b.isPinned) return -1;
          if (!a.isPinned && b.isPinned) return 1;
          return b.usagePct.compareTo(a.usagePct);
        });

  List<TrackerTool> get catalogTools =>
      tools.where((t) => !t.isEnabled).toList();

  List<TrackerTool> get exhaustedTools =>
      activeTools.where((t) => t.isExhausted).toList();

  List<TrackerTool> get lowTools =>
      activeTools.where((t) => t.isLow).toList();

  List<TrackerTool> get healthyTools =>
      activeTools.where((t) => t.isHealthy).toList();

  // Best tool to use right now (least usage %)
  TrackerTool? get bestToolNow {
    final available = activeTools.where((t) => !t.isExhausted).toList();
    if (available.isEmpty) return null;
    return available.reduce(
        (a, b) => a.usagePct <= b.usagePct ? a : b);
  }

  TrackerState copyWith({
    TrackerStatus? status,
    List<TrackerTool>? tools,
    DateTime? lastSync,
    bool? isLive,
    String? alertToolId,
    String? errorMessage,
  }) {
    return TrackerState(
      status: status ?? this.status,
      tools: tools ?? this.tools,
      lastSync: lastSync ?? this.lastSync,
      isLive: isLive ?? this.isLive,
      alertToolId: alertToolId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, tools, lastSync, isLive, alertToolId, errorMessage];
}
