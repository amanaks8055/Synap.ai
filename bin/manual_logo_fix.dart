import 'dart:convert';
import 'dart:io';

void main() async {
  const supabaseUrl = 'https://ssemwzmwhlcfmzmrweuw.supabase.co';
  const anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNzZW13em13aGxjZm16bXJ3ZXV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIxNzkxMTcsImV4cCI6MjA4Nzc1NTExN30.QF9G86V2HxzMrnN37ENQkrY7L_m7LBuxa56tC5MoywA';
  final client = HttpClient();

  final fixes = {
    'gamma': 'https://logo.clearbit.com/gamma.app',
  };

  for (var entry in fixes.entries) {
     final patchUrl = '$supabaseUrl/rest/v1/ai_tools?id=eq.${entry.key}';
      try {
        final req = await client.patchUrl(Uri.parse(patchUrl));
        req.headers.set('apikey', anonKey);
        req.headers.set('Authorization', 'Bearer $anonKey');
        req.headers.set('Content-Type', 'application/json');
        req.add(utf8.encode(jsonEncode({'icon_url': entry.value})));
        final resp = await req.close();
        if (resp.statusCode >= 200 && resp.statusCode < 300) {
          print('Fixed logo: ${entry.key}');
        }
      } catch (e) {
        print('ERR: $e');
      }
  }
  client.close();
}
