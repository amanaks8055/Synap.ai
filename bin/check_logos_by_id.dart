import 'dart:convert';
import 'dart:io';

import 'env.dart';

void main() async {
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
  final client = HttpClient();

  final ids = ['200-chatgpt-mega-prompts-for-solopreneurs', 'ada-cx', 'adarachatbot'];
  
  for (var id in ids) {
    print('Checking ID: $id');
    final url = '$supabaseUrl/rest/v1/ai_tools?select=id,name,website_url,icon_url&id=eq.$id';
    try {
      final req = await client.getUrl(Uri.parse(url));
      req.headers.set('apikey', anonKey);
      req.headers.set('Authorization', 'Bearer $anonKey');
      final resp = await req.close();
      final body = await utf8.decodeStream(resp);
      print('Result: $body');
    } catch (e) {
      print('Error: $e');
    }
  }
  client.close();
}
