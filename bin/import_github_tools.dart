import 'dart:convert';
import 'dart:io';

import 'env.dart';

void main() async {
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
  final client = HttpClient();

  try {
    // Load existing IDs
    final existingIdsFile = File('bin/existing_ids.json');
    if (!existingIdsFile.existsSync()) {
      print('existing_ids.json not found. Run get_all_ids.dart first.');
      return;
    }
    final existingIdsJson = existingIdsFile.readAsStringSync();
    final Set<String> existingIds = Set.from(jsonDecode(existingIdsJson));
    print('Loaded ${existingIds.length} existing IDs.');

    // Load GitHub tools with robust decoding
    final githubFile = File('bin/AIToolsList.json');
    if (!githubFile.existsSync()) {
      print('AIToolsList.json not found.');
      return;
    }
    final bytes = githubFile.readAsBytesSync();
    final githubToolsStr = utf8.decode(bytes, allowMalformed: true);
    final List<dynamic> githubTools = jsonDecode(githubToolsStr);
    print('Loaded ${githubTools.length} tools from GitHub list.');

    final List<Map<String, dynamic>> toUpload = [];
    int skippedCount = 0;

    for (var gt in githubTools) {
      if (gt is! Map) continue;
      String? rawHandle = gt['handle']?.toString();
      if (rawHandle == null) continue;
      
      String id = rawHandle;
      if (existingIds.contains(id)) {
        skippedCount++;
        continue;
      }

      String desc = gt['description']?.toString() ?? 'AI tool for productivity and creativity.';
      String website = gt['website']?.toString() ?? '';
      
      String category = 'fun';
      String lowerDesc = desc.toLowerCase();
      if (lowerDesc.contains('write') || lowerDesc.contains('content') || lowerDesc.contains('copy')) category = 'writing';
      else if (lowerDesc.contains('chat') || lowerDesc.contains('convers')) category = 'chat';
      else if (lowerDesc.contains('image') || lowerDesc.contains('art') || lowerDesc.contains('photo') || lowerDesc.contains('generative')) category = 'image';
      else if (lowerDesc.contains('code') || lowerDesc.contains('programm') || lowerDesc.contains('dev')) category = 'code';
      else if (lowerDesc.contains('video') || lowerDesc.contains('mov')) category = 'video';
      else if (lowerDesc.contains('audio') || lowerDesc.contains('voice') || lowerDesc.contains('music')) category = 'audio';
      else if (lowerDesc.contains('marketing') || lowerDesc.contains('seo') || lowerDesc.contains('ad')) category = 'marketing';
      else if (lowerDesc.contains('design') || lowerDesc.contains('uikit')) category = 'design';
      else if (lowerDesc.contains('research') || lowerDesc.contains('search')) category = 'research';
      else if (lowerDesc.contains('automate') || lowerDesc.contains('workflow')) category = 'automation';

      toUpload.add({
        'id': id,
        'name': id.split('-').map((s) => s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : '').join(' '),
        'slug': id,
        'category_id': category,
        'description': desc,
        'icon_emoji': '🤖',
        'website_url': website,
        'has_free_tier': true,
        'is_featured': false,
        'click_count': 0,
      });

      existingIds.add(id);

      if (toUpload.length >= 2000) break; // aim for ~8200 total (6193 + 2000)
    }

    print('Prepared ${toUpload.length} new tools to upload. Skipped $skippedCount duplicates.');

    if (toUpload.isEmpty) {
      print('Nothing to upload.');
      return;
    }

    const batchSize = 100;
    int uploaded = 0;

    for (int i = 0; i < toUpload.length; i += batchSize) {
      int end = (i + batchSize > toUpload.length) ? toUpload.length : i + batchSize;
      final batch = toUpload.sublist(i, end);
      final body = utf8.encode(jsonEncode(batch));

      try {
        // Use ?on_conflict=id for upsert safety
        final req = await client.postUrl(Uri.parse('$supabaseUrl/rest/v1/ai_tools?on_conflict=id'));
        req.headers.set('apikey', anonKey);
        req.headers.set('Authorization', 'Bearer $anonKey');
        req.headers.set('Content-Type', 'application/json; charset=utf-8');
        req.headers.set('Prefer', 'resolution=merge-duplicates');
        req.contentLength = body.length;
        req.add(body);
        
        final resp = await req.close();
        if (resp.statusCode >= 200 && resp.statusCode < 300) {
          uploaded += batch.length;
          print('Uploaded $uploaded / ${toUpload.length}');
        } else {
          final error = await utf8.decodeStream(resp);
          print('FAILED batch: ${resp.statusCode} - $error');
        }
      } catch (e) {
        print('Batch Error: $e');
      }
    }

    print('DONE. Total processed in this session: $uploaded');
    print('Total target reached: ${existingIds.length}');
  } catch (e) {
    print('Critical Error: $e');
  } finally {
    client.close();
  }
}
