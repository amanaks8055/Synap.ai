import 'dart:convert';
import 'dart:io';
import 'env.dart';

void main() async {
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
  final client = HttpClient();

  int offset = 0;
  const int fetchLimit = 1000;
  bool hasMore = true;

  print('--- Smart Parallel Logo Reset (Batch of 50) ---');

  while (hasMore) {
    final queryUrl = '$supabaseUrl/rest/v1/ai_tools?select=id,website_url&order=id&offset=$offset&limit=$fetchLimit';
    try {
      final req = await client.getUrl(Uri.parse(queryUrl));
      req.headers.set('apikey', anonKey);
      req.headers.set('Authorization', 'Bearer $anonKey');
      final resp = await req.close();
      if (resp.statusCode != 200) {
        print('Fetch Error: ${resp.statusCode}');
        break;
      }
      final List<dynamic> batch = jsonDecode(await utf8.decodeStream(resp));
      if (batch.isEmpty) break;

      // Process in smaller sub-batches of 50 to avoid rate limits
      for (int i = 0; i < batch.length; i += 50) {
        int end = (i + 50 > batch.length) ? batch.length : i + 50;
        final subBatch = batch.sublist(i, end);
        
        final futures = subBatch.map((tool) async {
          String id = tool['id'];
          String url = tool['website_url'];
          String domain = '';
          try {
            domain = Uri.parse(url).host;
            if (domain.isEmpty) domain = url.replaceAll('https://', '').split('/').first;
          } catch (_) {
            domain = url.replaceAll('https://', '').split('/').first;
          }
          String logoUrl = 'https://logo.clearbit.com/$domain';

          final patchUrl = '$supabaseUrl/rest/v1/ai_tools?id=eq.$id';
          try {
            final pReq = await client.patchUrl(Uri.parse(patchUrl));
            pReq.headers.set('apikey', anonKey);
            pReq.headers.set('Authorization', 'Bearer $anonKey');
            pReq.headers.set('Content-Type', 'application/json');
            pReq.add(utf8.encode(jsonEncode({'icon_url': logoUrl})));
            final pResp = await pReq.close();
            await pResp.drain();
          } catch (_) {}
        }).toList();

        await Future.wait(futures);
        stdout.write('.'); // Progress dot
      }

      offset += batch.length;
      print('\nProcessed $offset tools...');
      if (batch.length < fetchLimit) hasMore = false;
    } catch (e) {
      print('ERR at $offset: $e');
      hasMore = false;
    }
  }

  print('DONE! Smart reset complete.');
  client.close();
}
