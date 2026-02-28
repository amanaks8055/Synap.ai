import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String _url = 'https://ssemwzmwhlcfmzmrweuw.supabase.co';
  static const String _anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNzZW13em13aGxjZm16bXJ3ZXV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIxNzkxMTcsImV4cCI6MjA4Nzc1NTExN30.QF9G86V2HxzMrnN37ENQkrY7L_m7LBuxa56tC5MoywA';

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: _url,
      anonKey: _anonKey,
      realtimeClientOptions: const RealtimeClientOptions(logLevel: RealtimeLogLevel.info),
    );
  }
}
