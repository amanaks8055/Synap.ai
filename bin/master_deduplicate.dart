import 'dart:convert';
import 'dart:io';

void main() async {
  const supabaseUrl = 'https://ssemwzmwhlcfmzmrweuw.supabase.co';
  const anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNzZW13em13aGxjZm16bXJ3ZXV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIxNzkxMTcsImV4cCI6MjA4Nzc1NTExN30.QF9G86V2HxzMrnN37ENQkrY7L_m7LBuxa56tC5MoywA';
  final client = HttpClient();

  print('--- Master Deduplication and Cleanup ---');

  final allTools = <Map<String, dynamic>>[];
  int offset = 0;
  bool hasMore = true;
  const int limit = 1000;

  print('Fetching all tools for deduplication...');

  while (hasMore) {
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
        allTools.add(Map<String, dynamic>.from(tool));
      }
      
      offset += batch.length;
      if (batch.length < limit) hasMore = false;
    } catch (e) {
      print('Fetch error: $e');
      hasMore = false;
    }
  }

  print('Total tools fetched: ${allTools.length}');

  int scoreTool(Map<String, dynamic> tool) {
    int score = 0;
    if (tool['icon_url'] != null && tool['icon_url'].toString().isNotEmpty) score += 5;
    if (tool['paid_price_monthly'] != null) score += 2;
    if (tool['optimization_tips'] != null && tool['optimization_tips'].toString().isNotEmpty) score += 3;
    if (tool['free_limit_description'] != null) score += 2;
    if (tool['description'] != null && tool['description'].toString().length > 50) score += 1;
    return score;
  }

  final idsToDelete = <String>{};

  // 1. Deduplicate by URL
  final urlMap = <String, List<Map<String, dynamic>>>{};
  for (var tool in allTools) {
    String url = tool['website_url']?.toString().toLowerCase().trim() ?? '';
    if (url.isNotEmpty && url != 'null') {
      urlMap.putIfAbsent(url, () => []).add(tool);
    }
  }

  urlMap.forEach((url, tools) {
    if (tools.length > 1) {
      tools.sort((a, b) => scoreTool(b).compareTo(scoreTool(a)));
      for (int i = 1; i < tools.length; i++) {
        idsToDelete.add(tools[i]['id'].toString());
      }
    }
  });

  // 2. Deduplicate by Name (excluding those already marked for deletion)
  final remainingTools = allTools.where((t) => !idsToDelete.contains(t['id'])).toList();
  final nameMap = <String, List<Map<String, dynamic>>>{};
  for (var tool in remainingTools) {
    String name = tool['name']?.toString().toLowerCase().trim() ?? '';
    if (name.isNotEmpty) {
      nameMap.putIfAbsent(name, () => []).add(tool);
    }
  }

  nameMap.forEach((name, tools) {
    if (tools.length > 1) {
      tools.sort((a, b) => scoreTool(b).compareTo(scoreTool(a)));
      for (int i = 1; i < tools.length; i++) {
        idsToDelete.add(tools[i]['id'].toString());
      }
    }
  });

  print('Total entries to delete: ${idsToDelete.length}');

  if (idsToDelete.isEmpty) {
    print('No duplicates found.');
    client.close();
    return;
  }

  final deleteList = idsToDelete.toList();
  int deletedCount = 0;
  const batchSize = 50;

  for (int i = 0; i < deleteList.length; i += batchSize) {
    int end = (i + batchSize > deleteList.length) ? deleteList.length : i + batchSize;
    List<String> batch = deleteList.sublist(i, end);
    final deleteUrl = '$supabaseUrl/rest/v1/ai_tools?id=in.("${batch.join('","')}")';

    try {
      final req = await client.deleteUrl(Uri.parse(deleteUrl));
      req.headers.set('apikey', anonKey);
      req.headers.set('Authorization', 'Bearer $anonKey');
      final resp = await req.close();
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        deletedCount += batch.length;
        print('Deleted $deletedCount/${deleteList.length}');
      } else {
        print('FAILED deletion at status ${resp.statusCode}');
      }
    } catch (e) {
      print('Delete ERR: $e');
    }
  }

  print('\nDONE! Successfully cleaned up $deletedCount duplicate tools.');
  client.close();
}
