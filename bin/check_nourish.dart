import 'dart:io';
import 'dart:convert';

void main() async {
  final client = HttpClient();
  final req = await client.getUrl(Uri.parse('https://ssemwzmwhlcfmzmrweuw.supabase.co/rest/v1/ai_tools?id=eq.nourish-ai&select=id'));
  req.headers.set('apikey', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNzZW13em13aGxjZm16bXJ3ZXV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIxNzkxMTcsImV4cCI6MjA4Nzc1NTExN30.QF9G86V2HxzMrnN37ENQkrY7L_m7LBuxa56tC5MoywA');
  final resp = await req.close();
  final body = await utf8.decodeStream(resp);
  print(body);
  client.close();
}
