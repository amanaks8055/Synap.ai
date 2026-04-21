import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  static String get _url => dotenv.env['SUPABASE_URL'] ?? '';
  static String get _anonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: _url,
        anonKey: _anonKey,
        realtimeClientOptions:
            const RealtimeClientOptions(logLevel: RealtimeLogLevel.info),
      );
    } catch (e) {
      debugPrint('[SupabaseService] ❌ Init failed: $e — app will run in offline mode');
    }
  }
}
