import 'dart:convert';
import 'dart:io';

import 'env.dart';

void main() async {
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
  final client = HttpClient();

  int offset = 0;
  bool hasMore = true;

  while (hasMore) {
    final queryUrl = '$supabaseUrl/rest/v1/ai_tools?select=id,name,icon_url&order=id&offset=$offset&limit=1000';
    try {
      final req = await client.getUrl(Uri.parse(queryUrl));
      req.headers.set('apikey', anonKey);
      req.headers.set('Authorization', 'Bearer $anonKey');
      final resp = await req.close();
      final List<dynamic> batch = jsonDecode(await utf8.decodeStream(resp));
      if (batch.isEmpty) break;

      for (var tool in batch) {
        String? icon = tool['icon_url']?.toString();
        if (icon == null || icon.isEmpty || icon == 'null' || icon == 'https://logo.clearbit.com/') {
           print('FOUND_ACTUAL_BAD: ${tool['id']} | ${tool['name']}');
        }
      }
      offset += batch.length;
      if (batch.length < 1000) hasMore = false;
    } catch (e) {
      hasMore = false;
    }
  }
  client.close();
}
