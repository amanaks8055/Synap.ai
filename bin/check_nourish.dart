import 'dart:io';
import 'dart:convert';

import 'env.dart';

void main() async {
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
  final client = HttpClient();
  final req = await client.getUrl(
    Uri.parse('$supabaseUrl/rest/v1/ai_tools?id=eq.nourish-ai&select=id'),
  );
  req.headers.set('apikey', anonKey);
  req.headers.set('Authorization', 'Bearer $anonKey');
  final resp = await req.close();
  final body = await utf8.decodeStream(resp);
  print(body);
  client.close();
}
