import 'dart:convert';
import 'dart:io';

import 'env.dart';

void main() async {
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
  final client = HttpClient();

  final queryUrl = '$supabaseUrl/rest/v1/ai_tools?select=id,name,icon_url&order=id';
  
  try {
    final req = await client.getUrl(Uri.parse(queryUrl));
    req.headers.set('apikey', anonKey);
    req.headers.set('Authorization', 'Bearer $anonKey');
    final resp = await req.close();
    final body = await utf8.decodeStream(resp);
    final List<dynamic> all = jsonDecode(body);
    for (var tool in all) {
      String? icon = tool['icon_url']?.toString();
      if (icon == null || icon.isEmpty || icon == 'null' || !icon.startsWith('http')) {
         print('BAD_LOGO: ID=${tool['id']} Name=${tool['name']} icon_url=$icon');
      }
    }
  } catch (e) {
    print('ERR: $e');
  }
  client.close();
}
