import 'dart:convert';
import 'dart:io';

import 'env.dart';

void main() async {
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
  final client = HttpClient();

  try {
    final req = await client.getUrl(Uri.parse('$supabaseUrl/rest/v1/ai_tools?select=count'));
    req.headers.set('apikey', anonKey);
    req.headers.set('Authorization', 'Bearer $anonKey');
    req.headers.set('Range-Unit', 'items');
    // Prefer: count=exact
    req.headers.set('Prefer', 'count=exact');
    
    final resp = await req.close();
    final respBody = await utf8.decodeStream(resp);
    print('Count Response: $respBody');
    print('Status: ${resp.statusCode}');
    print('Content-Range: ${resp.headers.value('content-range')}');
  } catch (e) {
    print('Error: $e');
  } finally {
    client.close();
  }
}
