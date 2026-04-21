import 'dart:convert';
import 'dart:io';

import 'env.dart';

void main() async {
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
  final client = HttpClient();

  final queryUrl = '$supabaseUrl/rest/v1/ai_tools?select=id,name,website_url&icon_url=is.null';
  
  try {
    final req = await client.getUrl(Uri.parse(queryUrl));
    req.headers.set('apikey', anonKey);
    req.headers.set('Authorization', 'Bearer $anonKey');
    final resp = await req.close();
    final body = await utf8.decodeStream(resp);
    final List<dynamic> missing = jsonDecode(body);
    for (var t in missing) {
      print('ID: ${t['id']} | Name: ${t['name']} | URL: ${t['website_url']}');
    }
  } catch (e) {
    print('ERR: $e');
  }
  client.close();
}
