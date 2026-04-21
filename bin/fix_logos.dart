import 'dart:convert';
import 'dart:io';

import 'env.dart';

void main() async {
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
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
            // Update the icon URL
            updates.add({
              'id': tool['id'],
              'icon_url': 'https://logo.clearbit.com/$cleanDomain',
            });
          }
        }
      }

      // Send batch updates
      if (updates.isNotEmpty) {
        final updateUrl = '$supabaseUrl/rest/v1/ai_tools';
        final req = await client.putUrl(Uri.parse(updateUrl));
        req.headers.set('apikey', anonKey);
        req.headers.set('Authorization', 'Bearer $anonKey');
        req.headers.set('Content-Type', 'application/json');
        req.write(jsonEncode(updates));
        final resp = await req.close();
        if (resp.statusCode == 200) {
          fixedCount += updates.length;
          print('Updated ${updates.length} logos.');
        } else {
          print('Failed to update logos. Status: ${resp.statusCode}');
        }
      }

      offset += limit;
    } catch (e) {
      print('Error processing batch: $e');
      hasMore = false;
    }
  }

  print('--- Logo Fix Complete: $fixedCount logos updated ---');
  client.close();
}
