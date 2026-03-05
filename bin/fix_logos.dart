import 'dart:convert';
import 'dart:io';

void main() async {
  const supabaseUrl = 'https://ssemwzmwhlcfmzmrweuw.supabase.co';
  const anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNzZW13em13aGxjZm16bXJ3ZXV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIxNzkxMTcsImV4cCI6MjA4Nzc1NTExN30.QF9G86V2HxzMrnN37ENQkrY7L_m7LBuxa56tC5MoywA';
  final client = HttpClient();

  print('--- Fixing Existing Logos (Domain Cleanup) ---');

  int offset = 0;
  bool hasMore = true;
  const int limit = 1000;
  int fixedCount = 0;

  while (hasMore) {
    final queryUrl = '$supabaseUrl/rest/v1/ai_tools?select=*&icon_url=like.*logo.clearbit.com*&offset=$offset&limit=$limit';
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
      
      final updates = <Map<String, dynamic>>[];
      for (var tool in batch) {
        String iconUrl = tool['icon_url'].toString();
        // Example: https://logo.clearbit.com/www.ada.cx
        if (iconUrl.contains('logo.clearbit.com')) {
          final parts = iconUrl.split('logo.clearbit.com/');
          if (parts.length == 2) {
            String domain = parts[1];
            // Remove www.
            String cleanDomain = domain.replaceFirst('www.', '');
            // Optional: trim protocol if accidentally included
            cleanDomain = cleanDomain.replaceAll('https://', '').replaceAll('http://', '');
            
            final newUrl = 'https://logo.clearbit.com/$cleanDomain';
            if (newUrl != iconUrl) {
              final update = Map<String, dynamic>.from(tool);
              update['icon_url'] = newUrl;
              updates.add(update);
            }
          }
        }
      }

      if (updates.isNotEmpty) {
        final jsonBody = utf8.encode(jsonEncode(updates));
        final updateReq = await client.postUrl(Uri.parse('$supabaseUrl/rest/v1/ai_tools'));
        updateReq.headers.set('apikey', anonKey);
        updateReq.headers.set('Authorization', 'Bearer $anonKey');
        updateReq.headers.set('Content-Type', 'application/json; charset=utf-8');
        updateReq.headers.set('Prefer', 'resolution=merge-duplicates');
        updateReq.contentLength = jsonBody.length;
        updateReq.add(jsonBody);

        final updateResp = await updateReq.close();
        if (updateResp.statusCode >= 200 && updateResp.statusCode < 300) {
          fixedCount += updates.length;
          print('Fixed $fixedCount logos...');
        } else {
          print('Update FAIL [${updateResp.statusCode}]');
        }
      }
      
      offset += batch.length;
      if (batch.length < limit) hasMore = false;
    } catch (e) {
      print('Error: $e');
      hasMore = false;
    }
  }

  print('\nDONE! Successfully fixed $fixedCount tool logos.');
  client.close();
}
