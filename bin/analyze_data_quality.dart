import 'dart:io';
import 'dart:convert';

import 'env.dart';

void main() async {
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
  final client = HttpClient();

  final allTools = <Map<String, dynamic>>[];
  int offset = 0;
  bool hasMore = true;
  const batchSize = 1000;

  print('Starting quality analysis...');

  while (hasMore) {
    final url = '$supabaseUrl/rest/v1/ai_tools?select=id,name,website_url,icon_url&offset=$offset&limit=$batchSize';
    try {
      final req = await client.getUrl(Uri.parse(url));
      req.headers.set('apikey', anonKey);
      req.headers.set('Authorization', 'Bearer $anonKey');
      final resp = await req.close();
      
      if (resp.statusCode != 200) {
        hasMore = false;
        break;
      }

      final body = await utf8.decodeStream(resp);
      final List<dynamic> batch = jsonDecode(body);
      
      if (batch.isEmpty) {
        hasMore = false;
        break;
      }
      
      for (var tool in batch) {
        allTools.add(Map<String, dynamic>.from(tool));
      }
      
      offset += batch.length;
      if (batch.length < batchSize) hasMore = false;
    } catch (e) {
      hasMore = false;
    }
  }

  final urlMap = <String, List<String>>{};
  final nameMap = <String, List<String>>{};
  final missingLogoIds = <String>[];

  for (var tool in allTools) {
    String id = tool['id'];
    String name = tool['name']?.toString().toLowerCase().trim() ?? '';
    String url = tool['website_url']?.toString().toLowerCase().trim() ?? '';
    String? iconUrl = tool['icon_url'];

    if (url.isNotEmpty && url != 'null') {
      urlMap.putIfAbsent(url, () => []).add(id);
    }
    if (name.isNotEmpty) {
      nameMap.putIfAbsent(name, () => []).add(id);
    }
    if (iconUrl == null || iconUrl.isEmpty || iconUrl == 'null') {
      missingLogoIds.add(id);
    }
  }

  final duplicatesByName = nameMap.entries.where((e) => e.value.length > 1).map((e) => {'name': e.key, 'ids': e.value}).toList();
  final duplicatesByUrl = urlMap.entries.where((e) => e.value.length > 1).map((e) => {'url': e.key, 'ids': e.value}).toList();

  final result = {
    'total_count': allTools.length,
    'duplicates_by_name_count': duplicatesByName.length,
    'duplicates_by_url_count': duplicatesByUrl.length,
    'missing_logo_count': missingLogoIds.length,
    'duplicates_by_name': duplicatesByName,
    'duplicates_by_url': duplicatesByUrl,
    'missing_logo_ids': missingLogoIds,
  };

  File('bin/quality_analysis_report.json').writeAsStringSync(jsonEncode(result));
  print('Analysis complete. Report saved to bin/quality_analysis_report.json');
  client.close();
}
