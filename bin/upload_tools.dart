// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'env.dart';

void main() async {
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;

  final client = HttpClient();

  final allTools = <Map<String, dynamic>>[];

  for (var i = 1; i <= 11; i++) {
    final file = File('tools_batch$i.sql');
    if (!file.existsSync()) {
      print('skip tools_batch$i.sql');
      continue;
    }
    final content = file.readAsStringSync();
    final regex = RegExp(
      r"\('((?:''|[^'])+)','((?:''|[^'])+)','((?:''|[^'])+)','((?:''|[^'])+)','((?:''|[^'])+)','((?:''|[^'])*)','((?:''|[^'])*)',(true|false),(true|false),(\d+)\)",
    );
    final matches = regex.allMatches(content);
    print('batch$i: ${matches.length} tools');
    for (final m in matches) {
      allTools.add({
        'id': m.group(1)!.replaceAll("''", "'"),
        'name': m.group(2)!.replaceAll("''", "'"),
        'slug': m.group(3)!.replaceAll("''", "'"),
        'category_id': m.group(4)!.replaceAll("''", "'"),
        'description': m.group(5)!.replaceAll("''", "'"),
        'icon_emoji': m.group(6)!.replaceAll("''", "'"),
        'website_url': m.group(7)!.replaceAll("''", "'"),
        'has_free_tier': m.group(8) == 'true',
        'is_featured': m.group(9) == 'true',
        'click_count': int.parse(m.group(10)!),
      });
    }
  }

  print('Total: ${allTools.length}');

  const batchSize = 25;
  var uploaded = 0;
  var failed = 0;

  for (var i = 0; i < allTools.length; i += batchSize) {
    final end =
        (i + batchSize > allTools.length) ? allTools.length : i + batchSize;
    final batch = allTools.sublist(i, end);
    final bodyBytes = utf8.encode(jsonEncode(batch));

    try {
      final request = await client.postUrl(
        Uri.parse('$supabaseUrl/rest/v1/ai_tools'),
      );
      request.headers.set('apikey', anonKey);
      request.headers.set('Authorization', 'Bearer $anonKey');
      request.headers.set('Content-Type', 'application/json; charset=utf-8');
      request.headers.set('Prefer', 'resolution=merge-duplicates');
      request.contentLength = bodyBytes.length;
      request.add(bodyBytes);

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        uploaded += batch.length;
        print('OK batch ${i ~/ batchSize + 1} ($uploaded done)');
      } else {
        failed += batch.length;
        print('FAIL batch ${i ~/ batchSize + 1} [${response.statusCode}] $responseBody');
      }
    } catch (e) {
      failed += batch.length;
      print('ERR batch ${i ~/ batchSize + 1}: $e');
    }
  }

  client.close();
  print('Done! uploaded=$uploaded failed=$failed');
}
