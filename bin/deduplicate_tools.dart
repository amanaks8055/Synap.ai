import 'dart:convert';
import 'dart:io';

import 'env.dart';

void main() async {
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
  final client = HttpClient();

  print('--- Deduplicating Tools ---');

  Map<String, List<Map<String, dynamic>>> nameMap = {};
  int offset = 0;
  bool hasMore = true;
  const int limit = 1000;

  while (hasMore) {
    final queryUrl = '$supabaseUrl/rest/v1/ai_tools?select=id,name,paid_price_monthly,paid_tier_description,optimization_tips,free_limit_description&order=id&offset=$offset&limit=$limit';
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
        String name = tool['name'].toString().trim().toLowerCase();
        if (!nameMap.containsKey(name)) nameMap[name] = [];
        nameMap[name]!.add(tool as Map<String, dynamic>);
      }
      offset += batch.length;
      if (batch.length < limit) hasMore = false;
    } catch (e) {
      hasMore = false;
    }
  }

  int deletedCount = 0;
  List<String> idsToDelete = [];

  nameMap.forEach((name, tools) {
    if (tools.length > 1) {
      // Find the "best" tool to keep (most info)
      tools.sort((a, b) {
        int aScore = 0;
        if (a['paid_price_monthly'] != null) aScore++;
        if (a['paid_tier_description'] != null) aScore++;
        if (a['optimization_tips'] != null) aScore++;
        if (a['free_limit_description'] != null) aScore++;

        int bScore = 0;
        if (b['paid_price_monthly'] != null) bScore++;
        if (b['paid_tier_description'] != null) bScore++;
        if (b['optimization_tips'] != null) bScore++;
        if (b['free_limit_description'] != null) bScore++;

        return bScore.compareTo(aScore);
      });

      // Keep index 0, delete others
      for (int i = 1; i < tools.length; i++) {
        idsToDelete.add(tools[i]['id'].toString());
      }
    }
  });

  print('Total IDs to delete: ${idsToDelete.length}');

  // Delete in batches of 50
  for (int i = 0; i < idsToDelete.length; i += 50) {
    int end = (i + 50 > idsToDelete.length) ? idsToDelete.length : i + 50;
    List<String> batch = idsToDelete.sublist(i, end);
    final deleteUrl = '$supabaseUrl/rest/v1/ai_tools?id=in.("${batch.join('","')}")';

    try {
      final req = await client.deleteUrl(Uri.parse(deleteUrl));
      req.headers.set('apikey', anonKey);
      req.headers.set('Authorization', 'Bearer $anonKey');
      final resp = await req.close();
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        deletedCount += batch.length;
        print('Deleted $deletedCount/${idsToDelete.length}');
      } else {
        print('FAILED at ${resp.statusCode}');
      }
    } catch (e) {
      print('ERR: $e');
    }
  }

  print('\nDONE! Deduplicated and cleaned up $deletedCount tools.');
  client.close();
}
