import 'dart:convert';
import 'dart:io';

void main() async {
  const supabaseUrl = 'https://ssemwzmwhlcfmzmrweuw.supabase.co';
  const anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNzZW13em13aGxjZm16bXJ3ZXV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIxNzkxMTcsImV4cCI6MjA4Nzc1NTExN30.QF9G86V2HxzMrnN37ENQkrY7L_m7LBuxa56tC5MoywA';
  final client = HttpClient();

  final queryUrl = '$supabaseUrl/rest/v1/ai_tools?select=id,name,website_url&icon_url=is.null';
  
  try {
    final req = await client.getUrl(Uri.parse(queryUrl));
    req.headers.set('apikey', anonKey);
    req.headers.set('Authorization', 'Bearer $anonKey');
    final resp = await req.close();
    final body = await utf8.decodeStream(resp);
    final List<dynamic> missing = jsonDecode(body);
    for (var t in missing) {
      print('ID: ${t['id']} | Name: ${t['name']} | URL: ${t['website_url']}');
    }
  } catch (e) {
    print('ERR: $e');
  }
  client.close();
}
