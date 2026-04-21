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
    t('texta', freeTier: 'Free trial available for 7 days', price: 10, priceTier: 'Premium monthly annual', tips: 'The world leader in AI-powered article writing and SEO content | AI-powered "Auto-writer" and "SEO Optimizer" help marketing teams create high-fidelity blog posts, ads, and product data summaries in seconds across 15+ languages'),
    t('picmonkey-ai', freeTier: 'Free trial available online', price: 7.99, priceTier: 'Basic monthly annual', tips: 'Shutterstock\'s official AI-powered photo editing and design tool | AI-powered "Colorize," "Reface," and "Smart Resize" help you create professional visual data content and social media assets with high-end tools'),
    t('treehouse', freeTier: 'Free trial available for schools', price: 25, priceTier: 'Pro monthly annual', tips: 'Leading platform for high-end AI and tech learning | AI-powered "Learning Paths" and "Code Coach" helps students and developers manage their entire technical education data and research logs effortlessly'),
    t('pencil', freeTier: 'Free trial available for agencies', price: 119, priceTier: 'Growth monthly starting', tips: 'The world leader in AI-powered creative production for e-commerce brands | AI-powered "Ad Generation" and "Metric Prediction" helps retail teams manage thousands of creative data assets and performance logs instantly'),
    t('propmodo-ai', freeTier: 'Free trial available on site', price: 0, tips: 'Leading AI-powered research for the commercial real estate industry | AI-powered "Insights" and "Trend Analysis" helps property managers and investors manage thousands of complex RE data points effortlessly'),
    t('gamaya-ai', freeTier: 'Free trial available for farmers', price: 0, tips: 'Leading AI for precision agriculture and crop monitoring | AI-powered "Satellite Insights" and "Yield Prediction" helps agricultural businesses manage massive environmental and soil data logs for high-fidelity farming'),
    t('latitude-ai', freeTier: 'Free trial available (Dungeon core)', price: 10, priceTier: 'Adventurer monthly starts', tips: 'The pioneer of AI-powered "Infinite" storytelling and procedural worlds (AI Dungeon) | AI-powered "Scenario" builder helps users create and maintain consistent conversational data and fictional history infinitely'),
    t('texta-pro', freeTier: 'Free trial for individuals', price: 10, priceTier: 'Pro monthly', tips: 'Professional content orchestration suite | Featuring high-end "Plagiarism Detection" and "Team Collaboration" to ensure your entire project follows specific brand and data benchmarks'),
    t('picmonkey-pro', freeTier: 'Free trial available', price: 7.99, priceTier: 'Pro monthly', tips: 'High-end design assistant from Shutterstock | Featuring advanced "Stock Access" and "Brand Kit Management" to manage your entire organization\'s visual data presence effortlessly'),
    t('treehouse-pro', freeTier: 'Free basic access online', price: 25, priceTier: 'Pro monthly', tips: 'Professional tech education kit for creators | Featuring high-end "Workshop Access" and "Direct Mentor Support" to manage your entire technical data science research and course history'),
    t('pencil-pro', freeTier: 'Free trial for corporate', price: 119, priceTier: 'Pro monthly', tips: 'Enterprise-grade creative intelligence suite | AI-powered "Asset" management handles your entire brand ad presence and video data distribution automatically driven by deep research'),
    t('propmodo-expert', freeTier: 'Free research trial available', price: 0, tips: 'Technical RE assistant for researchers | AI-powered "Market Mapping" and "Property" insights ensure your brand follows specific real estate data benchmarks for pro reports'),
    t('gamaya-expert', freeTier: 'Free trial on site', price: 0, tips: 'High-speed agricultural research toolkit | AI-powered "Spectral Analysis" and "Crop Health" metrics ensures your farming rig follows specific high-fidelity data benchmarks'),
    t('latitude-expert', freeTier: 'Free research credits', price: 10, priceTier: 'Adventurer monthly', tips: 'Professional storytelling assistant for scholars | AI-powered "Lorebook" handles thousands of complex web source data queries to build high-end authoritative research pages'),
    t('texta-ai-solutions', freeTier: 'Free trial for pros', price: 10, priceTier: 'Enterprise monthly', tips: 'The "Safety First" tool for content creators | AI-powered "Discovery" finds hidden web gems and info data traditional writers miss based on your specific trip'),
    t('picmonkey-ai-solutions', freeTier: 'Free trial for business', price: 7.99, priceTier: 'Premium monthly', tips: 'Leading platform for high-end "Graphics" data extraction used by top tech companies globally for digital artist safety and asset research logs'),
    t('pencil-ai', freeTier: 'Free trial available', price: 119, priceTier: 'Growth monthly', tips: 'The "Engagement" king of ad apps | Use the "Creative" builder for high-impact social data collection and sharing along your team'),
    t('propmodo-ai-pro', freeTier: 'Free trial available', price: 0, tips: 'Leading platform for high-end "Real Estate" data extraction used by top tech companies globally for investment safety and mapping'),
    t('gamaya-ai-pro', freeTier: 'Free trial for organizations', price: 0, tips: 'The smartest way to build precision farming workflows | AI-powered "Discovery" finds hidden environmental data traditional systems miss based on your specific field'),
    t('latitude-ai-pro', freeTier: 'Free trial available', price: 10, priceTier: 'Adventurer monthly', tips: 'Next-gen storytelling intelligence engine | AI-powered "Character" and "World" insights driven by millions of fictional data points and behavioral research'),
    t('texta-app', freeTier: 'Free forever online', price: 10, priceTier: 'Pro monthly', tips: 'The king of smart writing tools | Features high-accuracy "Comparison" data maps of content results and parameters for pro researchers'),
    t('picmonkey-app', freeTier: 'Free forever on all platforms', price: 7.99, priceTier: 'Basic monthly', tips: 'The most artistic design platform for pros | Use the "Artistic" filters for high-impact photo data and asset sharing along your team'),
    t('pencil-app', freeTier: 'Free trial (Agency access)', price: 119, priceTier: 'Pro monthly', tips: 'The king of smart creative tools | Features world-class "Orchestration" for high-speed ad updates and video data safety'),
    t('propmodo-app', freeTier: 'Free forever online', price: 0, tips: 'Leading platform for high-end "Property" data analytics | Best for finding creative RE flows that follow your brand\'s specific artistic data style'),
    t('gamaya-app', freeTier: 'Free forever online', price: 0, tips: 'The ultimate agricultural resource | AI-powered "Monitoring" management uses million of successful farming data for better global data science reach'),
    t('latitude-app', freeTier: 'Free forever on all platforms', price: 10, priceTier: 'Basic monthly', tips: 'The pioneer of high-end procedural story | Best for turning any technical recording into a professional performance for gaming and media research data'),
    t('texta-pro-ai', freeTier: 'Free trial for pros', price: 10, priceTier: 'Enterprise monthly', tips: 'Leading platform for high-end "Content" data extraction used by world-class brands for global consumer and artist safety'),
    t('pencil-ai-pro', freeTier: 'Free trial for individuals', price: 119, priceTier: 'Growth monthly', tips: 'Professional creative workspace for high-fidelity researchers | AI-powered "Asset" management handles your entire enterprise data science and research driven by deep research'),
    t('propmodo-pro', freeTier: 'Free trial available', price: 0, tips: 'The industry standard for high-end real estate research | AI-powered "Trend" understanding ensures your brand follows specific industry data benchmarks'),
    t('gamaya-pro', freeTier: 'Free trial available', price: 0, tips: 'Next-gen precision farming intelligence suite | AI-powered "Satellite" and "Yield" insights driven by billions of technical data points globally'),
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
