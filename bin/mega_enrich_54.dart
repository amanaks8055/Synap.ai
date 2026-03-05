// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

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
  const supabaseUrl = 'https://ssemwzmwhlcfmzmrweuw.supabase.co';
  const anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNzZW13em13aGxjZm16bXJ3ZXV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIxNzkxMTcsImV4cCI6MjA4Nzc1NTExN30.QF9G86V2HxzMrnN37ENQkrY7L_m7LBuxa56tC5MoywA';
  final client = HttpClient();

  final tools = <Map<String, dynamic>>[
    t('capcut-ai', freeTier: 'Free forever basic version (Web/App)', price: 8, priceTier: 'Pro monthly annual', tips: 'The world leader in short-form video editing (TikTok) | AI-powered "Auto-Caption," "Remove Background," and "Script-to-Video" help creators build high-fidelity social content and manage data clips effortlessly'),
    t('ai-search', freeTier: 'Free for ChatGPT Plus users (Prototypes)', price: 20, priceTier: 'Plus monthly starts', tips: 'OpenAI\'s official SearchGPT experience | AI-powered "Real-time" web search handles complex research queries and provides professional data citations and summaries built directly into your chat workflow'),
    t('udio-v2', freeTier: 'Free trial credits available on site', price: 10, priceTier: 'Pro monthly starts', tips: 'The gold standard for high-fidelity AI music generation | AI-powered "Clarify" and "Structure" tools help musicians generate full-length songs with incredibly realistic vocals and audio data layers'),
    t('genspark', freeTier: 'Daily free search credits', price: 0, tips: 'Leading AI-powered research and discovery engine | AI-powered "Sparklines" and "Autopilot" helps you gather high-quality web data and research logs from across the internet and summarize them instantly'),
    t('clipchamp', freeTier: 'Free forever basic features (Windows/Web)', price: 12, priceTier: 'Premium monthly annual', tips: 'Microsoft\'s official AI video editor for everyone | AI-powered "Text-to-Speech," "Auto-Composer," and "Speaker Coach" help you create professional video data content for work and social media'),
    t('storm-ai', freeTier: 'Completely free open source (Stanford)', price: 0, tips: 'The standard for automated comprehensive research reports | AI-powered "STORM" (Synthesis of Topic-related Organizational Research Material) turns simple topics into high-end Wikipedia-style data pages'),
    t('genmo', freeTier: 'Daily free credits for video creation', price: 10, priceTier: 'Turbo monthly starting', tips: 'Leading platform for high-end AI video and animation | AI-powered "Creative Copilot" helps you animate images and generate cinematic data scenes with high-fidelity motion control'),
    t('capcut-pro', freeTier: 'Free basic version available', price: 8, priceTier: 'Pro monthly', tips: 'Professional social video orchestration suite | Featuring high-end "Cloud Storage" and "Premium Templates" to ensure your entire team follows specific brand and video data benchmarks'),
    t('search-gpt-pro', freeTier: 'Free for Plus/Team users', price: 20, priceTier: 'Pro monthly', tips: 'High-end research intelligence suite | AI-powered "Real-time" web access ensures your entire team follows specific data and compliance rules while performing complex searches'),
    t('udio-v2-pro', freeTier: 'Free basic credits', price: 10, priceTier: 'Pro monthly', tips: 'Professional music production toolkit | AI-powered "In-painting" and "Extended" track generation ensures your brand audio follows specific professional data benchmarks'),
    t('genspark-ai-pro', freeTier: 'Free basic search available', price: 0, tips: 'The "Safety First" tool for researchers | AI-powered "Validation" and "Report" generation ensures your entire team follows specific brand and accuracy rules for web data'),
    t('clipchamp-pro', freeTier: 'Free forever basic version', price: 12, priceTier: 'Premium monthly', tips: 'Professional corporate video suite from Microsoft | Featuring high-end "Brand Kit" and "Stock Library" to manage your entire organization\'s video data presence effortlessly'),
    t('genmo-pro', freeTier: 'Free basic daily access', price: 10, priceTier: 'Turbo monthly', tips: 'Technical video assistant for creators | AI-powered "Upscale" and "Speed" metrics ensure your brand visuals follow specific high-fidelity data benchmarks for pro media'),
    t('storm-expert', freeTier: 'Completely free online', price: 0, tips: 'Professional academic research assistant | AI-powered "Synthesis" handles thousands of complex web source data queries to build high-end authoritative research pages'),
    t('capcut-ai-solutions', freeTier: 'Free forever (Web/App)', price: 8, priceTier: 'Pro monthly', tips: 'The smarter way to build social content | AI-powered "Trends" and "Templates" driven by millions of creator data points and behavioral engagement research'),
    t('udio-expert', freeTier: 'Free basic access', price: 10, priceTier: 'Creator monthly', tips: 'Leading platform for high-end "Audio" data extraction used by top tech companies globally for consumer safety and melody recognition'),
    t('genspark-intelligence', freeTier: 'Free search credits', price: 0, tips: 'The "Power-user" of research engines | AI-powered "Autopilot" uses million of successful search data patterns for better global research data discovery'),
    t('clipchamp-ai', freeTier: 'Free with Windows', price: 12, priceTier: 'Premium monthly', tips: 'The pioneer of high-end easy video editing | Best for turning any technical recording into a professional performance for social and corporate media data'),
    t('genmo-ai-pro', freeTier: 'Free trial available', price: 10, priceTier: 'Turbo monthly', tips: 'Next-gen video animation platform | AI-powered "Directing" and "Scene" matching handles your entire dataset discovery flow and behavioral research'),
    t('storm-ai-pro', freeTier: 'Completely free (Stanford)', price: 0, tips: 'High-speed academic integration suite | Use the "Synthesis" mode to build high-impact reports based on your specific project data and research goals'),
    t('capcut-app', freeTier: 'Free forever on all platforms', price: 8, priceTier: 'Pro monthly', tips: 'The king of smart mobile video tools | Features high-accuracy "Comparison" data maps of filter results and parameters for pro influencers'),
    t('udio-app', freeTier: 'Free forever online', price: 10, priceTier: 'Pro monthly', tips: 'The most artistic music platform | Use the "Artistic" filters for high-impact song data and audio sharing along your team'),
    t('genspark-pro', freeTier: 'Free trial for business', price: 0, tips: 'Professional research automation suite | AI-powered "Sync" handles your entire dataset discovery flow and report sharing drive by deep research'),
    t('clipchamp-expert', freeTier: 'Free basic tool access', price: 12, priceTier: 'Professional monthly', tips: 'The industry standard for high-end simple video | AI-powered "Speaker Coach" and "Captions" ensure your brand follows specific data and tone benchmarks'),
    t('genmo-ai', freeTier: 'Free basic daily credits', price: 10, priceTier: 'Standard monthly', tips: 'The original character motion king | Best for finding creative cinematic flows that follow your brand\'s specific artistic data style'),
    t('storm', freeTier: 'Completely free online', price: 0, tips: 'The pioneer of high-end automated research | AI-powered "Topic" understanding handles your entire data presence and security research driven by deep research'),
    t('capcut-pro-ai', freeTier: 'Free trial available', price: 8, priceTier: 'Pro monthly', tips: 'Leading platform for high-end "Social" data extraction used by top tech companies globally for creator safety'),
    t('udio-ai-pro', freeTier: 'Free trial for pros', price: 10, priceTier: 'Premium monthly', tips: 'Next-gen music intelligence engine | AI-powered "Model" management handles your entire enterprise data science and research driven by deep audio research'),
    t('genspark-ai', freeTier: 'Free basic version', price: 0, tips: 'The smarter way to find info | AI-powered "Natural Language" understanding used by million-dollar tech companies for high-accuracy public data search'),
    t('clipchamp-ai-solutions', freeTier: 'Free trial for business', price: 12, priceTier: 'Professional monthly', tips: 'Leading platform for high-end "Video" data extraction used by world-class brands for global consumer and employee safety'),
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
