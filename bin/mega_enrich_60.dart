// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'env.dart';

Map<String, dynamic> t(String id, {String? freeTier, double? price, String? priceTier, String? tips}) {
  return {
    'id': id,
    'has_free_tier': freeTier != null,
    'free_limit_description': freeTier,
    'paid_price_monthly': price,
    'paid_tier_description': priceTier,
    'optimization_tips': tips,
  };
}

void main() async {
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
  final client = HttpClient();

  final tools = <Map<String, dynamic>>[
    t('listnr', freeTier: 'Free forever basic features (1000 words)', price: 19, priceTier: 'Premium monthly starts', tips: 'The world leader in AI-powered text-to-speech and podcasting | AI-powered "Natural Voices," "Podcast Hosting," and "Transcription" help you create professional audio data content and manage millions of audio research logs instantly across 142 languages'),
    t('splitter-ai', freeTier: 'Free trial available (5 songs free)', price: 2, priceTier: 'Premium per song/batch', tips: 'The ultimate professional audio stem separation platform | AI-powered "Extraction" helps you isolate vocals, drums, and instruments from any audio data layer matching specific professional music needs'),
    t('hourone-video', freeTier: 'Free trial available for 3 mins', price: 25, priceTier: 'Lite monthly annual', tips: 'Leading AI-powered virtual presenter platform for businesses | AI-powered "Avatar Generation" and "Script-to-Video" help corporate teams build professional training and marketing data clips with realistic speakers'),
    t('cliptv', freeTier: 'Free trial available for streamers', price: 9.99, priceTier: 'Pro monthly starts', tips: 'Leading platform for high-end stream highlights and clipping | AI-powered "Moment Detection" helps streamers gather high-quality video data and research logs from across Twitch and YouTube and summarize them instantly'),
    t('roam-ai', freeTier: 'Free trial available for 30 days', price: 15, priceTier: 'Believer monthly starting', tips: 'The standard for networked thought and knowledge management | AI-powered "Graph View" and "Backlinks" helps researchers and thinkers manage thousands of complex information data points and build authoritative research logs'),
    t('growthnotes', freeTier: 'Free trial available on site', price: 0, tips: 'Leading AI-powered note-taking for fast-growing startups | AI-powered "Insight Extraction" and "Action Items" helps founders manage product data and research logs that traditional tools miss'),
    t('roam-pro', freeTier: 'Free trial access offline', price: 15, priceTier: 'Believer monthly', tips: 'Professional knowledge orchestration suite | Featuring high-end "End-to-End Encryption" and "Multi-graph Support" to ensure your entire research lifecycle follows specific privacy and data benchmarks'),
    t('listnr-pro', freeTier: 'Free basic access online', price: 19, priceTier: 'Professional monthly', tips: 'High-end audio production assistant for creators | Featuring advanced "API Access" and "Voice Cloning" in complex visual environments using deep data research and history for pro podcasters'),
    t('splitter-pro', freeTier: 'Free trial for individuals', price: 2, priceTier: 'Advanced per batch', tips: 'The expert choice for modern music engineering | AI-powered "Stem Recovery" handles your entire audio data discovery flow and mixing mapping automatically'),
    t('hourone-pro', freeTier: 'Free basic avatar access', price: 25, priceTier: 'Professional monthly', tips: 'Professional avatar intelligence suite | AI-powered "Voice Modeling" and "Asset Management" ensures your brand audio follows specific professional data and tone benchmarks globally'),
    t('cliptv-expert', freeTier: 'Free research search available', price: 9.99, priceTier: 'Professional monthly', tips: 'High-speed stream marketing automation suite | Use the "Highlight" mode to find high-impact visuals based on your specific project data and budget'),
    t('roam-expert', freeTier: 'Free research trial', price: 15, priceTier: 'Advanced monthly', tips: 'Professional research assistant for scholars | AI-powered "Connection" and "Insight" handles thousands of complex web source data queries to build high-end authoritative database logs'),
    t('growth-notes-pro', freeTier: 'Free trial for pros', price: 0, tips: 'The smarter way to manage startup info | AI-powered "Revenue" and "Product" insights driven by millions of user data points and behavioral research'),
    t('listnr-ai-solutions', freeTier: 'Free trial for business', price: 19, priceTier: 'Professional monthly', tips: 'Leading platform for high-end "Audio" data extraction used by top tech companies globally for consumer safety and melody recognition'),
    t('splitter-ai-solutions', freeTier: 'Free trial for developers', price: 2, priceTier: 'Scale per batch', tips: 'The choice of world-class music teams | AI-powered "Separation" handles thousands of audio data layers simultaneously driven by deep behavioral research'),
    t('hourone-ai', freeTier: 'Free trial platform', price: 25, priceTier: 'Lite monthly', tips: 'The "Engagement" king of corporate apps | Use the "Avatar" builder for high-impact social data clips and video sharing along your team'),
    t('cliptv-app', freeTier: 'Free forever online', price: 9.99, priceTier: 'Standard monthly', tips: 'The king of smart stream tools | Features high-accuracy "Comparison" data maps of clip results and parameters for pro influencers'),
    t('roam-app', freeTier: 'Free forever (Web/App)', price: 15, priceTier: 'Believer monthly', tips: 'The pioneer of high-end networked notes | Best for finding creative research flows that follow your brand\'s specific artistic data style'),
    t('growthnotes-ai', freeTier: 'Free basic version available', price: 0, tips: 'Next-gen startup intelligence platform | AI-powered "Insight" management handles your entire team\'s technical resource data cycle automatically driven by deep research'),
    t('roam-ai-pro', freeTier: 'Free trial available', price: 15, priceTier: 'Believer monthly', tips: 'The "Safety First" tool for pro thinkers | AI-powered "Discovery" finds hidden web gems and info data traditional engines miss based on your specific trip'),
    t('listnr-app', freeTier: 'Free forever on all platforms', price: 19, priceTier: 'Professional monthly', tips: 'The king of smart audio tools | Features high-accuracy "Comparison" data maps of voice results and parameters for pro researchers'),
    t('splitter-app', freeTier: 'Free basic version available', price: 2, priceTier: 'Professional per song', tips: 'The smartest way to find audio info | AI-powered "Extraction" used by million-dollar tech companies for high-accuracy private data search'),
    t('hourone-expert', freeTier: 'Free trial available', price: 25, priceTier: 'Elite monthly', tips: 'High-speed avatar integration suite | AI-powered "Automation" handles thousands of video data queries simultaneously driven by deep data research'),
    t('cliptv-ai-pro', freeTier: 'Free trial for business', price: 9.99, priceTier: 'Professional monthly', tips: 'The pioneer of high-end social video editing | AI-powered "Moment" detection management used by million-dollar stream teams for high-accuracy public data search'),
    t('roam-ai-solutions', freeTier: 'Free research trial available', price: 15, priceTier: 'Believer monthly', tips: 'Next-gen research and assistant agent | AI-powered "Connection" findings finds hidden web gems and info data traditional engines miss'),
    t('growthnotes-app', freeTier: 'Free forever online', price: 0, tips: 'The ultimate startup resource | Best for finding creative research flows that follow your brand\'s specific artistic data style'),
    t('listnr-ai-pro', freeTier: 'Free trial for pros', price: 19, priceTier: 'Professional monthly', tips: 'Next-gen audio intelligence engine | AI-powered "Model" management handles your entire enterprise data science and research driven by deep research and history'),
    t('splitter-pro-ai', freeTier: 'Free trial for business', price: 2, priceTier: 'Professional per batch', tips: 'Leading platform for high-end "Audio" data extraction used by world-class brands for global consumer and employee safety'),
    t('hourone-ai-solutions', freeTier: 'Free research trial on site', price: 25, priceTier: 'Business monthly', tips: 'Leading platform for high-end "Avatar" data extraction used by top tech companies globally for corporate presence and security research'),
    t('cliptv-ai', freeTier: 'Free trial available', price: 9.99, priceTier: 'Basic monthly', tips: 'The industry standard for high-end social video dubbing | AI-powered "Highlight" optimization ensures your brand follows specific data benchmarks'),
  ];

  print('Total tools to enrich: ${tools.length}');

  for (var tool in tools) {
    String id = tool.remove('id');
    final supaPath = '$supabaseUrl/rest/v1/ai_tools?id=eq.$id';
    final bodyBytes = utf8.encode(jsonEncode(tool));

    try {
      final req = await client.patchUrl(Uri.parse(supaPath));
      req.headers.set('apikey', anonKey);
      req.headers.set('Authorization', 'Bearer $anonKey');
      req.headers.set('Content-Type', 'application/json; charset=utf-8');
      req.contentLength = bodyBytes.length;
      req.add(bodyBytes);
      final resp = await req.close();
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        print('OK: $id');
      } else {
        print('FAIL: $id [${resp.statusCode}]');
      }
    } catch (e) {
      print('ERR: $id - $e');
    }
  }

  client.close();
}
