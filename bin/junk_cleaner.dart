import 'dart:convert';
import 'dart:io';

void main() async {
  const supabaseUrl = 'https://ssemwzmwhlcfmzmrweuw.supabase.co';
  const anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNzZW13em13aGxjZm16bXJ3ZXV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIxNzkxMTcsImV4cCI6MjA4Nzc1NTExN30.QF9G86V2HxzMrnN37ENQkrY7L_m7LBuxa56tC5MoywA';
  final client = HttpClient();

  final idsToDelete = ['check_rls'];

  for (var id in idsToDelete) {
    final deleteUrl = '$supabaseUrl/rest/v1/ai_tools?id=eq.$id';
    try {
      final req = await client.deleteUrl(Uri.parse(deleteUrl));
      req.headers.set('apikey', anonKey);
      req.headers.set('Authorization', 'Bearer $anonKey');
      final resp = await req.close();
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        print('Deleted junk: $id');
      } else {
        print('Failed to delete $id: Status ${resp.statusCode}');
      }
    } catch (e) {
      print('ERR: $e');
    }
  }
  client.close();
}
