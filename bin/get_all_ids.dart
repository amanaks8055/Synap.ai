import 'dart:io';
import 'dart:convert';

void main() async {
  const supabaseUrl = 'https://ssemwzmwhlcfmzmrweuw.supabase.co';
  const anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNzZW13em13aGxjZm16bXJ3ZXV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIxNzkxMTcsImV4cCI6MjA4Nzc1NTExN30.QF9G86V2HxzMrnN37ENQkrY7L_m7LBuxa56tC5MoywA';
  final client = HttpClient();

  final ids = <String>[];
  int offset = 0;
  bool hasMore = true;

  print('Fetching existing IDs from Supabase...');

  while (hasMore) {
    final url = '$supabaseUrl/rest/v1/ai_tools?select=id&offset=$offset&limit=1000&order=id.asc';
    try {
      final req = await client.getUrl(Uri.parse(url));
      req.headers.set('apikey', anonKey);
      req.headers.set('Authorization', 'Bearer $anonKey');
      final resp = await req.close();
      
      if (resp.statusCode != 200) {
        final errorBody = await utf8.decodeStream(resp);
        print('Error fetching (Status ${resp.statusCode}): $errorBody');
        // Retry logic for potential 525/524 errors
        if (resp.statusCode >= 500) {
           print('Server error, retrying in 2 seconds...');
           await Future.delayed(Duration(seconds: 2));
           continue; 
        }
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
        ids.add(tool['id'].toString());
      }
      
      print('Fetched ${ids.length} IDs (Offset: $offset)...');
      
      offset += batch.length;
      if (batch.length < 1000) hasMore = false;
    } catch (e) {
      print('Exception: $e');
      await Future.delayed(Duration(seconds: 2));
      // Try to continue despite minor network blips
    }
  }

  final file = File('bin/existing_ids.json');
  file.writeAsStringSync(jsonEncode(ids));
  print('SUCCESS: Saved ${ids.length} IDs to bin/existing_ids.json');
  
  client.close();
}
