import 'dart:convert';
import 'dart:io';

import 'env.dart';

void main() async {
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
  final client = HttpClient();

  // Fetch all names from ai_tools (paginated)
  final allNames = <Map<String, dynamic>>[];
  int offset = 0;
  const pageSize = 1000;

  while (true) {
    final url = '$supabaseUrl/rest/v1/ai_tools?select=id,name&order=name&offset=$offset&limit=$pageSize';
    final req = await client.getUrl(Uri.parse(url));
    req.headers.set('apikey', anonKey);
    req.headers.set('Authorization', 'Bearer $anonKey');
    final resp = await req.close();
    final body = await utf8.decodeStream(resp);
    final list = jsonDecode(body) as List;
    if (list.isEmpty) break;
    allNames.addAll(list.cast<Map<String, dynamic>>());
    offset += pageSize;
    if (list.length < pageSize) break;
  }

  print('Total tools in ai_tools: ${allNames.length}');

  // Find duplicate names (case insensitive)
  final counts = <String, List<String>>{};
  for (final row in allNames) {
    final name = (row['name'] as String).toLowerCase().trim();
    counts.putIfAbsent(name, () => []);
    counts[name]!.add(row['id'].toString());
  }

  final dupes = counts.entries.where((e) => e.value.length > 1).toList()
    ..sort((a, b) => b.value.length.compareTo(a.value.length));

  print('Duplicate names: ${dupes.length}');
  for (final d in dupes) {
    print('  ${d.value.length}x: "${d.key}" (ids: ${d.value.join(", ")})');
  }

  // Also check tools table
  print('\n--- tools table ---');
  final toolsUrl = '$supabaseUrl/rest/v1/tools?select=id,name&order=name';
  final treq = await client.getUrl(Uri.parse(toolsUrl));
  treq.headers.set('apikey', anonKey);
  treq.headers.set('Authorization', 'Bearer $anonKey');
  final tresp = await treq.close();
  final tbody = await utf8.decodeStream(tresp);
  final tlist = (jsonDecode(tbody) as List).cast<Map<String, dynamic>>();
  print('Total tools in tools table: ${tlist.length}');

  // Check overlap between tools and ai_tools
  final aiNames = allNames.map((e) => (e['name'] as String).toLowerCase().trim()).toSet();
  final toolNames = tlist.map((e) => (e['name'] as String).toLowerCase().trim()).toList();
  final overlap = toolNames.where((n) => aiNames.contains(n)).toList();
  print('Overlap (same name in both tables): ${overlap.length}');
  for (final o in overlap) {
    print('  "$o"');
  }

  client.close();
}
