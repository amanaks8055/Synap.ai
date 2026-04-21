import 'dart:convert';
import 'dart:io';

import 'env.dart';

void main() async {
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
  final client = HttpClient();

  int totalChecked = 0;
  bool hasMore = true;
  int offset = 0;
  const int limit = 1000;

  while (hasMore) {
    final queryUrl = '$supabaseUrl/rest/v1/ai_tools?select=id,name,website_url,icon_url&order=id&offset=$offset&limit=$limit';
    try {
      final req = await client.getUrl(Uri.parse(queryUrl));
      req.headers.set('apikey', anonKey);
      req.headers.set('Authorization', 'Bearer $anonKey');
      final resp = await req.close();
      final body = await utf8.decodeStream(resp);
      final List<dynamic> batch = jsonDecode(body);
      if (batch.isEmpty) break;

      for (var tool in batch) {
        String? icon = tool['icon_url']?.toString();
        if (icon == null || icon.isEmpty || icon == 'null') {
          String id = tool['id'];
          String url = tool['website_url'];
          print('Fixing logo for: $id');
          String domain = Uri.parse(url).host;
          if (domain.isEmpty) domain = url.replaceAll('https://', '').split('/').first;
          String logoUrl = 'https://logo.clearbit.com/$domain';
          
          final patchUrl = '$supabaseUrl/rest/v1/ai_tools?id=eq.$id';
          final patchReq = await client.patchUrl(Uri.parse(patchUrl));
          patchReq.headers.set('apikey', anonKey);
          patchReq.headers.set('Authorization', 'Bearer $anonKey');
          patchReq.headers.set('Content-Type', 'application/json');
          patchReq.add(utf8.encode(jsonEncode({'icon_url': logoUrl})));
          await patchReq.close();
        }
      }
      totalChecked += batch.length;
      offset += batch.length;
      if (batch.length < limit) hasMore = false;
    } catch (e) {
      hasMore = false;
    }
  }
  print('Logo fix scan complete.');
  client.close();
}
