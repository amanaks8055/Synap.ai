// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'env.dart';

void main() async {
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
  final client = HttpClient();
  final allTools = <Map<String, dynamic>>[];

  // Only process batch 6-10 (new tools)
  for (var i = 6; i <= 11; i++) {
    final file = File('tools_batch$i.sql');
    if (!file.existsSync()) { print('skip batch$i'); continue; }
    final content = file.readAsStringSync();
    final regex = RegExp(
      r"\('((?:''|[^'])+)','((?:''|[^'])+)','((?:''|[^'])+)','((?:''|[^'])+)','((?:''|[^'])+)','((?:''|[^'])*)','((?:''|[^'])*)',(true|false),(true|false),(\d+)\)",
    );
    final matches = regex.allMatches(content);
    print('batch$i: ${matches.length} tools');
    for (final m in matches) {
      final websiteUrl = m.group(7)!.replaceAll("''", "'");
      String domain;
      try {
        domain = Uri.parse(websiteUrl).host;
        if (domain.isEmpty) domain = websiteUrl.replaceAll('https://', '').replaceAll('http://', '').split('/').first;
      } catch (_) {
        domain = websiteUrl.replaceAll('https://', '').replaceAll('http://', '').split('/').first;
      }
      allTools.add({
        'id': m.group(1)!.replaceAll("''", "'"),
        'name': m.group(2)!.replaceAll("''", "'"),
        'slug': m.group(3)!.replaceAll("''", "'"),
        'category_id': m.group(4)!.replaceAll("''", "'"),
        'description': m.group(5)!.replaceAll("''", "'"),
        'icon_emoji': m.group(6)!.replaceAll("''", "'"),
        'website_url': websiteUrl,
        'icon_url': 'https://logo.clearbit.com/$domain',
        'has_free_tier': m.group(8) == 'true',
        'is_featured': m.group(9) == 'true',
        'click_count': int.parse(m.group(10)!),
      });
    }
  }

  print('Total new tools: ${allTools.length}');

  const batchSize = 25;
  var uploaded = 0;
  for (var i = 0; i < allTools.length; i += batchSize) {
    final end = (i + batchSize > allTools.length) ? allTools.length : i + batchSize;
    final batch = allTools.sublist(i, end);
    final bodyBytes = utf8.encode(jsonEncode(batch));
    try {
      final req = await client.postUrl(Uri.parse('$supabaseUrl/rest/v1/ai_tools'));
      req.headers.set('apikey', anonKey);
      req.headers.set('Authorization', 'Bearer $anonKey');
      req.headers.set('Content-Type', 'application/json; charset=utf-8');
      req.headers.set('Prefer', 'resolution=merge-duplicates');
      req.contentLength = bodyBytes.length;
      req.add(bodyBytes);
      final resp = await req.close();
      await resp.drain();
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        uploaded += batch.length;
        print('OK $uploaded/${allTools.length}');
      } else {
        print('FAIL batch at $i [${resp.statusCode}]');
      }
    } catch (e) {
      print('ERR at $i: $e');
    }
  }

  client.close();
  print('DONE! Uploaded $uploaded new tools');
}
