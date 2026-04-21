import 'dart:convert';
import 'dart:io';

import 'env.dart';

void main() async {
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
  final client = HttpClient();

  final names = ['200 Chatgpt Mega Prompts for Solopreneurs', 'Ada CX', 'Adarachatbot'];
  
  for (var name in names) {
    print('Checking: $name');
    final url = '$supabaseUrl/rest/v1/ai_tools?select=name,website_url,icon_url&name=eq.$name';
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
