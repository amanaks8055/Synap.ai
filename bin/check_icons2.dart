import 'dart:convert';
import 'dart:io';

import 'env.dart';

void main() async {
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
  final client = HttpClient();

  // Fetch ALL tools with icon info (paginated)
  final allTools = <Map<String, dynamic>>[];
  int offset = 0;
  while (true) {
    final url = '$supabaseUrl/rest/v1/ai_tools?select=id,name,icon_url,thumbnail_url,website_url&offset=$offset&limit=1000';
    final req = await client.getUrl(Uri.parse(url));
    req.headers.set('apikey', anonKey);
    req.headers.set('Authorization', 'Bearer $anonKey');
    req.headers.set('Accept', 'application/json');
    final resp = await req.close();
    final body = await utf8.decodeStream(resp);
    final decoded = jsonDecode(body);
    final list = decoded is List ? decoded.cast<Map<String, dynamic>>() : <Map<String, dynamic>>[decoded as Map<String, dynamic>];
    if (list.isEmpty || (list.length == 1 && list.first['id'] == null)) break;
    allTools.addAll(list.cast<Map<String, dynamic>>());
    offset += 1000;
    if (list.length < 1000) break;
  }
  print('Total: ${allTools.length}');

  // Famous tool names (lowercase)
  final famous = {
    'chatgpt', 'claude', 'gemini', 'midjourney', 'perplexity',
    'copilot', 'github copilot', 'cursor', 'dall-e', 'dall·e',
    'stable diffusion', 'runway', 'elevenlabs', 'jasper', 'notion ai',
    'grammarly', 'canva ai', 'adobe firefly', 'suno', 'pika',
    'v0', 'replit', 'devin ai', 'windsurf', 'bolt',
    'copy.ai', 'writesonic', 'synthesia', 'heygen', 'descript',
    'otter.ai', 'gamma', 'beautiful.ai', 'pitch', 'murf ai',
    'leonardo ai', 'ideogram', 'runway', 'sora', 'deepseek chat',
    'meta ai', 'opus clip', 'udio', 'tabnine', 'surfer seo', 'semrush ai',
  };

  // Check famous tools
  print('\n=== FAMOUS TOOLS ICON CHECK ===');
  for (final tool in allTools) {
    final name = (tool['name'] ?? '').toString().toLowerCase().trim();
    if (!famous.contains(name)) continue;
    
    final iconUrl = (tool['icon_url'] ?? '').toString();
    final thumbUrl = (tool['thumbnail_url'] ?? '').toString();
    final website = (tool['website_url'] ?? '').toString();
    final isClearbit = iconUrl.contains('clearbit');
    final hasThumb = thumbUrl.isNotEmpty && thumbUrl != 'null';
    final status = hasThumb ? 'THUMB' : (isClearbit ? 'CLEARBIT' : (iconUrl.isNotEmpty && iconUrl != 'null' ? 'DIRECT' : 'NONE'));
    final short = iconUrl.length > 70 ? iconUrl.substring(0, 70) : iconUrl;
    print('[$status] ${tool['name']} (${tool['id']}) => $short');
  }

  // Overall stats
  int clearbit = 0, direct = 0, thumb = 0, none = 0;
  for (final row in allTools) {
    final iconUrl = (row['icon_url'] ?? '').toString();
    final thumbUrl = (row['thumbnail_url'] ?? '').toString();
    if (thumbUrl.isNotEmpty && thumbUrl != 'null') { thumb++; }
    else if (iconUrl.contains('clearbit')) { clearbit++; }
    else if (iconUrl.isNotEmpty && iconUrl != 'null') { direct++; }
    else { none++; }
  }
  print('\n=== OVERALL STATS ===');
  print('Total: ${allTools.length}');
  print('Has thumbnail: $thumb');
  print('Clearbit only: $clearbit');
  print('Direct icon URL: $direct');
  print('No icon: $none');

  client.close();
}
