import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../blocs/tracker/tracker_bloc.dart';
import '../blocs/tracker/tracker_event.dart';
import '../models/tracker_tool.dart';

class ExtensionSyncService {
  final TrackerBloc trackerBloc;
  StreamSubscription? _subscription;
  Timer? _fallbackTimer;

  ExtensionSyncService({required this.trackerBloc});

  SupabaseClient? get _supabaseOrNull {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  void start(String userId) {
    stop();

    final supabase = _supabaseOrNull;
    if (supabase == null) {
      return;
    }

    _startRealtimeStream(userId);
    _fallbackTimer =
        Timer.periodic(const Duration(seconds: 15), (_) => _fetchOnce(userId));
    _fetchOnce(userId);
  }

  void _startRealtimeStream(String userId) {
    final supabase = _supabaseOrNull;
    if (supabase == null) {
      return;
    }

    _subscription?.cancel();
    _subscription = supabase
        .from('extension_sync')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .listen((rows) {
          if (rows.isEmpty) {
            return;
          }
          _processPayload(rows.first['payload']);
        }, onError: (e) {
          if (e.toString().contains('SocketException') ||
              e.toString().contains('Failed host lookup')) {
            return; // Silent for connectivity issues
          }
        });
  }

  Future<void> _fetchOnce(String userId) async {
    try {
      final supabase = _supabaseOrNull;
      if (supabase == null) {
        return;
      }

      final res = await supabase
          .from('extension_sync')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      if (res != null) {
        _processPayload(res['payload']);
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Failed host lookup')) {
        // Silent error for connectivity issues to avoid log bloating
        return;
      }
    }
  }

  void _processPayload(dynamic payload) {
    if (payload == null) {
      return;
    }
    final Map<String, dynamic> data = Map<String, dynamic>.from(payload);
    for (final provider in ['claude', 'chatgpt', 'gemini', 'perplexity']) {
      if (data.containsKey(provider) && data[provider] is Map) {
        trackerBloc.add(TrackerToolUpdated(TrackerTool.fromPayload(
            provider, Map<String, dynamic>.from(data[provider]))));
      }
    }
  }

  void stop() {
    _subscription?.cancel();
    _fallbackTimer?.cancel();
  }
}
