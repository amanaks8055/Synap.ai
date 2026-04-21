import 'dart:convert';
import 'dart:io';

import 'env.dart';

void main() async {
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
  final client = HttpClient();

  print('--- Heavy Logo Enrichment ---');

  final toolsWithMissingLogos = <Map<String, dynamic>>[];
  int offset = 0;
  bool hasMore = true;
  const int limit = 1000;

  print('Fetching tools with missing logos...');

  while (hasMore) {
    // Fetch all required fields for upsert safety (avoiding NOT NULL violations)
    final queryUrl = '$supabaseUrl/rest/v1/ai_tools?select=*&offset=$offset&limit=$limit';
    try {
      final req = await client.getUrl(Uri.parse(queryUrl));
      req.headers.set('apikey', anonKey);
      req.headers.set('Authorization', 'Bearer $anonKey');
      final resp = await req.close();
      final body = await utf8.decodeStream(resp);
      final List<dynamic> batch = jsonDecode(body);
      
      if (batch.isEmpty) {
        hasMore = false;
        break;
      }
      
      for (var tool in batch) {
        final iconUrl = tool['icon_url'];
        if (iconUrl == null || iconUrl.toString().isEmpty || iconUrl.toString() == 'null' || iconUrl.toString() == '🤖') {
          toolsWithMissingLogos.add(Map<String, dynamic>.from(tool));
        }
      }
      
      offset += batch.length;
      if (batch.length < limit) hasMore = false;
    } catch (e) {
      print('Fetch error: $e');
      hasMore = false;
    }
  }

  print('Total tools requiring logos: ${toolsWithMissingLogos.length}');

  if (toolsWithMissingLogos.isEmpty) {
    print('No missing logos found.');
    client.close();
    return;
  }

  final updates = <Map<String, dynamic>>[];
  for (final tool in toolsWithMissingLogos) {
    final id = tool['id'];
    final url = tool['website_url']?.toString() ?? '';
    if (url.isEmpty || url == 'null') continue;

    String domain;
    try {
      Uri uri = Uri.parse(url);
      domain = uri.host;
      if (domain.isEmpty) {
        domain = url.replaceAll('https://', '').replaceAll('http://', '').split('/').first;
      }
      // Remove subdomains like www. for better Clearbit compatibility
      if (domain.startsWith('www.')) {
        domain = domain.replaceFirst('www.', '');
      }
    } catch (_) {
      domain = url.replaceAll('https://', '').replaceAll('http://', '').split('/').first;
      if (domain.startsWith('www.')) {
        domain = domain.replaceFirst('www.', '');
      }
    }
    
    if (domain.isNotEmpty) {
      final updatedTool = Map<String, dynamic>.from(tool);
      updatedTool['icon_url'] = 'https://logo.clearbit.com/$domain';
      updates.add(updatedTool);
    }
  }

  print('Prepared logos for ${updates.length} tools.');

  const batchSize = 50;
  int done = 0;
  for (int i = 0; i < updates.length; i += batchSize) {
    int end = (i + batchSize > updates.length) ? updates.length : i + batchSize;
    final batch = updates.sublist(i, end);
    final jsonBody = utf8.encode(jsonEncode(batch));

    try {
      final req = await client.postUrl(Uri.parse('$supabaseUrl/rest/v1/ai_tools'));
      req.headers.set('apikey', anonKey);
      req.headers.set('Authorization', 'Bearer $anonKey');
      req.headers.set('Content-Type', 'application/json; charset=utf-8');
      req.headers.set('Prefer', 'resolution=merge-duplicates');
      req.contentLength = jsonBody.length;
      req.add(jsonBody);

      final resp = await req.close();
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        done += batch.length;
        print('Updated $done/${updates.length} logos...');
      } else {
        final err = await utf8.decodeStream(resp);
        print('FAIL [${resp.statusCode}]: $err');
      }
    } catch (e) {
      print('Batch Error: $e');
    }
  }

  print('\nDONE! Successfully enriched $done tool logos.');
  client.close();
}
