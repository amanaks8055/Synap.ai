import 'dart:convert';
import 'dart:io';

void main() async {
  const supabaseUrl = 'https://ssemwzmwhlcfmzmrweuw.supabase.co';
  const anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNzZW13em13aGxjZm16bXJ3ZXV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIxNzkxMTcsImV4cCI6MjA4Nzc1NTExN30.QF9G86V2HxzMrnN37ENQkrY7L_m7LBuxa56tC5MoywA';
  final client = HttpClient();

  int offset = 0;
  bool hasMore = true;

  while (hasMore) {
    final queryUrl = '$supabaseUrl/rest/v1/ai_tools?select=id,name,icon_url&order=id&offset=$offset&limit=1000';
    try {
      final req = await client.getUrl(Uri.parse(queryUrl));
      req.headers.set('apikey', anonKey);
      req.headers.set('Authorization', 'Bearer $anonKey');
      final resp = await req.close();
      final List<dynamic> batch = jsonDecode(await utf8.decodeStream(resp));
      if (batch.isEmpty) break;

      for (var tool in batch) {
        String? icon = tool['icon_url']?.toString();
        if (icon == null || icon.isEmpty || icon == 'null' || icon == 'https://logo.clearbit.com/') {
           print('FOUND_ACTUAL_BAD: ${tool['id']} | ${tool['name']}');
        }
      }
      offset += batch.length;
      if (batch.length < 1000) hasMore = false;
    } catch (e) {
      hasMore = false;
    }
  }
  client.close();
}
