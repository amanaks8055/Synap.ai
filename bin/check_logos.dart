import 'dart:convert';
import 'dart:io';

void main() async {
  const supabaseUrl = 'https://ssemwzmwhlcfmzmrweuw.supabase.co';
  const anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNzZW13em13aGxjZm16bXJ3ZXV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIxNzkxMTcsImV4cCI6MjA4Nzc1NTExN30.QF9G86V2HxzMrnN37ENQkrY7L_m7LBuxa56tC5MoywA';
  final client = HttpClient();

  final names = ['200 Chatgpt Mega Prompts for Solopreneurs', 'Ada CX', 'Adarachatbot'];
  
  for (var name in names) {
    print('Checking: $name');
    final url = '$supabaseUrl/rest/v1/ai_tools?select=name,website_url,icon_url&name=eq.$name';
    try {
      final req = await client.getUrl(Uri.parse(url));
      req.headers.set('apikey', anonKey);
      req.headers.set('Authorization', 'Bearer $anonKey');
      final resp = await req.close();
      final body = await utf8.decodeStream(resp);
      print('Result: $body');
    } catch (e) {
      print('Error: $e');
    }
  }
  client.close();
}
