import 'dart:convert';
import 'dart:io';

void main() async {
  const supabaseUrl = 'https://ssemwzmwhlcfmzmrweuw.supabase.co';
  const anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNzZW13em13aGxjZm16bXJ3ZXV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIxNzkxMTcsImV4cCI6MjA4Nzc1NTExN30.QF9G86V2HxzMrnN37ENQkrY7L_m7LBuxa56tC5MoywA';
  final client = HttpClient();

  try {
    final req = await client.getUrl(Uri.parse('$supabaseUrl/rest/v1/ai_tools?select=count'));
    req.headers.set('apikey', anonKey);
    req.headers.set('Authorization', 'Bearer $anonKey');
    req.headers.set('Range-Unit', 'items');
    // Prefer: count=exact
    req.headers.set('Prefer', 'count=exact');
    
    final resp = await req.close();
    final respBody = await utf8.decodeStream(resp);
    print('Count Response: $respBody');
    print('Status: ${resp.statusCode}');
    print('Content-Range: ${resp.headers.value('content-range')}');
  } catch (e) {
    print('Error: $e');
  } finally {
    client.close();
  }
}
