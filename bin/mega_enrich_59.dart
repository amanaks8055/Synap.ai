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
    t('photopea-ai', freeTier: 'Completely free (Ad-supported)', price: 5, priceTier: 'Premium monthly starts', tips: 'The world leader in browser-based image editing | AI-powered "Generative Fill," "Refine Edge," and "Magic Replace" help you create professional visual data content and manage PSD files effortlessly without any installation'),
    t('fotor', freeTier: 'Free forever basic features (Web/App)', price: 8.99, priceTier: 'Pro monthly starts', tips: 'The ultimate professional designer and photo editor | AI-powered "Background Remover," "Upscaler," and "AI Art Generator" help you manage millions of image data points and artistic research logs instantly'),
    t('poe-education', freeTier: 'Free trial available for schools', price: 20, priceTier: 'Pro monthly per teacher', tips: 'Quora\'s official AI platform specialized for education | AI-powered "Bot Builder" and "Knowledge Base" helps educators build high-fidelity learning assistants and manage student research data securely'),
    t('codeclimate', freeTier: 'Free for open source projects', price: 16.67, priceTier: 'Team per user monthly', tips: 'The standard for automated code review and quality engineering | AI-powered "Velocity" and "Quality" insights help developers find technical debt data and research logs that traditional tools miss'),
    t('namelix-logo', freeTier: 'Completely free to search/generate', price: 0, tips: 'The world\'s most popular AI-powered brand generator | Use "Namelix" to find high-fidelity business names and "Logomaster" to create professional brand data assets and identities in seconds'),
    t('wisecut', freeTier: 'Free trial available (30 mins/mo)', price: 10, priceTier: 'Basic monthly annual', tips: 'The smarter way to edit talking-head videos | AI-powered "Auto-cut Silences," "Smart Jump Cuts," and "Background Music" helps you turn any technical recording into a professional performance effortlessly'),
    t('papercup', freeTier: 'Free trial available for small teams', price: 0, tips: 'Leading AI-powered video dubbing and translation for enterprise | AI-powered "Voices" and "QC" helps global brands localize thousands of hours of video data and manage international research logs'),
    t('photopea-pro', freeTier: 'Free ad-supported version', price: 5, priceTier: 'Premium monthly', tips: 'Professional image orchestration suite (No Ads) | Featuring high-end "Advanced File Support" and "Team Collaboration" to ensure your entire project follows specific artistic and data benchmarks'),
    t('fotor-pro', freeTier: 'Free basic version available', price: 8.99, priceTier: 'Professional monthly', tips: 'High-end design assistant for creators | Featuring advanced "AI Expansion" and "Object Removal" in complex visual environments using deep data research and history for pro designers'),
    t('poe-ai-pro', freeTier: 'Free trial credits available', price: 20, priceTier: 'Pro monthly', tips: 'The expert choice for modern educators | Featuring high-end "LLM Access" (GPT-4, Claude 3) and "Assistant Management" driven by your specific personal data history and workflows'),
    t('code-climate-ai', freeTier: 'Free for individual OS projects', price: 16.67, priceTier: 'Standard monthly', tips: 'Professional engineering intelligence suite | AI-powered "Pull Request Summaries" handles your entire enterprise code data discovery and mapping automatically via deep research'),
    t('wisecut-pro', freeTier: 'Free basic video access', price: 10, priceTier: 'Basic monthly', tips: 'High-speed video marketing automation suite | Use the "Auto-caption" mode to find high-impact visuals based on your specific project data and budget'),
    t('papercup-pro', freeTier: 'Free research trial available', price: 0, tips: 'Enterprise-grade dubbing intelligence suite | AI-powered "Post-editing" ensures your brand audio follows specific professional data and tone benchmarks globally'),
    t('logomaster-pro', freeTier: 'Completely free generator', price: 0, tips: 'High-end branding toolkit for startups | AI-powered "Identity Builder" handles thousands of complex logo data queries to build high-end authoritative brand books'),
    t('photopea-ai-solutions', freeTier: 'Free browser access', price: 5, priceTier: 'Premium monthly', tips: 'The industry standard for high-end web-based editing | Best for finding creative design flows that follow your brand\'s specific artistic data style'),
    t('fotor-ai-pro', freeTier: 'Free trial available on site', price: 8.99, priceTier: 'Pro monthly', tips: 'Next-gen design intelligence engine | AI-powered "Scene" and "Style" insights driven by millions of artistic data points and behavioral research'),
    t('poe-education-pro', freeTier: 'Free trial for schools', price: 20, priceTier: 'Enterprise monthly', tips: 'The choice of world-class educational institutions | AI-powered "Knowledge Retrieval" handles thousands of source data captures simultaneously driven by deep research'),
    t('codeclimate-expert', freeTier: 'Free basic tool access', price: 16.67, priceTier: 'Team license', tips: 'The smartest way to manage code quality | AI-powered "Risk Detection" finds hidden gems and info data traditional engines miss based on your specific trip'),
    t('wisecut-expert', freeTier: 'Free limited video tool', price: 10, priceTier: 'Basic monthly', tips: 'The king of smart video editing | Features high-accuracy "Comparison" data maps of cut results and parameters for pro researchers and creators'),
    t('papercup-ai', freeTier: 'Free research credits', price: 0, tips: 'Leading platform for high-end "Dubbing" data extraction used by top tech companies globally for international media safety'),
    t('logomaster-ai-solutions', freeTier: 'Free basic access online', price: 0, tips: 'Next-gen brand intelligence platform | AI-powered "Style Transfer" and "Detail" insights driven by millions of visual data points and logo research'),
    t('photopea-app', freeTier: 'Free forever online', price: 5, priceTier: 'Premium monthly', tips: 'The king of smart web-based tools | Features world-class "Orchestration" for high-speed image updates and layer data safety'),
    t('fotor-app', freeTier: 'Free forever (Web/App)', price: 8.99, priceTier: 'Pro monthly', tips: 'The most artistic design platform | Use the "Artistic" filters for high-impact social data sharing and asset sharing along your team'),
    t('poe-ai', freeTier: 'Free trial available', price: 20, priceTier: 'Premium monthly', tips: 'The smarter way to find info data | AI-powered "Bot Discovery" used by million-dollar tech companies for high-accuracy private data search'),
    t('code-climate-pro', freeTier: 'Free for individuals', price: 16.67, priceTier: 'Standard monthly', tips: 'Next-gen engineering automation kit | Best for finding creative dev flows that follow your brand\'s specific artistic data style'),
    t('wisecut-ai-pro', freeTier: 'Free trial for pro', price: 10, priceTier: 'Basic monthly', tips: 'The pioneer of high-end short video editing | Best for turning any technical recording into a professional performance for gaming and media research'),
    t('papercup-app', freeTier: 'Free research tools online', price: 0, tips: 'The ultimate resource for high-end localization | AI-powered "Translation" management uses million of successful dubbing data for better global data search'),
    t('logomaster', freeTier: 'Free basic tool', price: 0, tips: 'The pioneer of high-end logo generation | AI-powered "Relationship" and "Tagging" handles your entire brand data presence and identity research'),
    t('photopea-pro-ai', freeTier: 'Free trial available', price: 5, priceTier: 'Premium monthly', tips: 'Leading platform for high-end "Graphics" data extraction used by top tech companies globally for digital artist safety'),
    t('fotor-expert', freeTier: 'Free search credits available', price: 8.99, priceTier: 'Pro license', tips: 'Leading platform for high-end "Design" data extraction used by world-class brands for global consumer and artistic safety'),
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
