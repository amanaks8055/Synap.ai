import 'dart:convert';
import 'dart:io';

import 'env.dart';

void main() async {
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
  final client = HttpClient();

  // Famous tool names to check
  final famous = [
    'ChatGPT', 'Claude', 'Gemini', 'Midjourney', 'Perplexity',
    'Copilot', 'GitHub Copilot', 'Cursor', 'DALL-E', 'Stable Diffusion',
    'Runway', 'ElevenLabs', 'Jasper', 'Notion AI', 'Grammarly',
    'Canva AI', 'Adobe Firefly', 'Suno', 'Pika', 'v0',
    'Replit', 'Devin AI', 'Windsurf', 'Bolt', 'Copy.ai',
    'Writesonic', 'Synthesia', 'HeyGen', 'Descript', 'Otter.ai',
    'Gamma', 'Beautiful.ai', 'Pitch', 'Murf AI', 'Leonardo AI',
    'Ideogram', 'Runway', 'Sora', 'DeepSeek Chat', 'Meta AI',
    'Opus Clip', 'Udio', 'Tabnine', 'Surfer SEO', 'Semrush AI',
  ];

  print('Checking icon URLs for famous tools...\n');

  for (final name in famous) {
    final encoded = Uri.encodeComponent(name);
    final url = '$supabaseUrl/rest/v1/ai_tools?select=id,name,icon_url,thumbnail_url,website_url&name=ilike.$encoded';
    try {
      final req = await client.getUrl(Uri.parse(url));
      req.headers.set('apikey', anonKey);
      req.headers.set('Authorization', 'Bearer $anonKey');
      req.headers.set('Accept', 'application/json');
      req.headers.set('Prefer', 'return=representation');
      final resp = await req.close();
      final body = await utf8.decodeStream(resp);
      final decoded = jsonDecode(body);
      final list = decoded is List ? decoded : [decoded];
      if (list.isEmpty) {
        print('NOT FOUND: $name');
      } else {
        for (final row in list) {
          final iconUrl = row['icon_url'] ?? '';
          final thumbUrl = row['thumbnail_url'] ?? '';
          final isClearbit = iconUrl.toString().contains('clearbit');
          final hasThumb = thumbUrl.toString().isNotEmpty && thumbUrl.toString() != 'null';
          final status = hasThumb ? 'HAS_THUMB' : (isClearbit ? 'CLEARBIT' : (iconUrl.toString().isNotEmpty ? 'DIRECT' : 'NONE'));
          print('$status: ${row['name']} (${row['id']}) => icon: ${iconUrl.toString().substring(0, iconUrl.toString().length > 60 ? 60 : iconUrl.toString().length)}...');
        }
      }
    } catch (e) {
      print('ERROR: $name => $e');
    }
  }

  // Also count how many tools have non-clearbit direct icon URLs
  print('\n--- Overall icon quality stats ---');
  int clearbit = 0, direct = 0, thumb = 0, none = 0, total = 0;
  int offset = 0;
  while (true) {
    final url = '$supabaseUrl/rest/v1/ai_tools?select=icon_url,thumbnail_url&offset=$offset&limit=1000';
    final req3 = await client.getUrl(Uri.parse(url));
    req3.headers.set('apikey', anonKey);
    req3.headers.set('Authorization', 'Bearer $anonKey');
    req3.headers.set('Accept', 'application/json');
    req3.headers.set('Prefer', 'return=representation');
    final resp3 = await req3.close();
    final body3 = await utf8.decodeStream(resp3);
    final decoded3 = jsonDecode(body3);
    final list3 = decoded3 is List ? decoded3 : [decoded3];
    if (list3.isEmpty) break;
    for (final row in list3) {
      total++;
      final iconUrl = (row['icon_url'] ?? '').toString();
      final thumbUrl = (row['thumbnail_url'] ?? '').toString();
      if (thumbUrl.isNotEmpty && thumbUrl != 'null') { thumb++; }
      else if (iconUrl.contains('clearbit')) { clearbit++; }
      else if (iconUrl.isNotEmpty && iconUrl != 'null') { direct++; }
      else { none++; }
    }
    offset += 1000;
    if (list3.length < 1000) break;
  }
  print('Total: $total');
  print('Has thumbnail: $thumb');
  print('Clearbit icon: $clearbit');
  print('Direct icon URL: $direct');
  print('No icon: $none');

  client.close();
}
