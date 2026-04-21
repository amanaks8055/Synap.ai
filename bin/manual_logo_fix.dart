import 'dart:convert';
import 'dart:io';

import 'env.dart';

void main() async {
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
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
