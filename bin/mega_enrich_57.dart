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
    t('fetcher', freeTier: 'Free trial available for 14 days', price: 149, priceTier: 'Custom plan starts', tips: 'The world leader in AI-powered talent sourcing | AI-powered "Candidate Discovery" and "Automated Outreach" helps recruiters find and engage thousands of high-quality candidates and manage recruitment data effortlessly'),
    t('dover-ai', freeTier: 'Free trial available for small teams', price: 99, priceTier: 'Pro monthly starts', tips: 'Leading recruiting automation platform for fast-growing startups | AI-powered "Scorecard" and "Candidate Screening" helps you find high-quality talent and manage hiring data logs matching your specific brand needs'),
    t('followr', freeTier: 'Free trial available for 7 days', price: 19, priceTier: 'Basic monthly annual', tips: 'The ultimate AI social media manager for SMBs | AI-powered "Content Generation" and "Smart Scheduling" help you create and manage thousands of posts across all channels instantly using deep engagement research'),
    t('crello', freeTier: 'Free forever basic features (VistaCreate)', price: 10, priceTier: 'Pro monthly annual', tips: 'VistaCreate is the world leader in simple graphic design | AI-powered "Background Remover," "Resizer," and "Brand Kit" help you create professional visual data content and social media assets in seconds'),
    t('bg-eraser', freeTier: 'Free basic removal (5 credits/day)', price: 5, priceTier: 'Premium monthly starts', tips: 'The smarter way to remove backgrounds from any image | AI-powered "Object Removal" and "Enhancer" helps you identify and clean up technical structural data and pixels in your photos effortlessly'),
    t('ai-color', freeTier: 'Free basic colorization online (Palette.fm)', price: 9, priceTier: 'Pro monthly starts', tips: 'The pioneer of high-end AI colorization | Best for turning any technical site recording or black-and-white photo into a professional performance with realistic colors and data consistency'),
    t('google-translate-ai', freeTier: 'Completely free (Web/App)', price: 0, tips: 'Google\'s official AI-powered translation leader | AI-powered "Neural Machine Translation" handles hundreds of languages and complex text data workflows with world-class accuracy for global research'),
    t('fetcher-pro', freeTier: 'Free trial for corporate', price: 149, priceTier: 'Professional monthly', tips: 'Professional talent orchestration suite | Featuring high-end "Diversity Tracking" and "Advanced Analytics" to ensure your entire team follows specific hiring and data benchmarks'),
    t('dover-pro', freeTier: 'Free trial for individuals', price: 99, priceTier: 'Professional monthly', tips: 'The expert choice for modern recruiting | AI-powered "Automatic Sourcing" handles your entire hiring data discovery flow and candidate mapping automatically'),
    t('followr-pro', freeTier: 'Free trial credits online', price: 19, priceTier: 'Pro monthly', tips: 'High-end social marketing automation suite | Use the "Engagement Optimizer" to find high-impact hashtags based on your specific project data and budget'),
    t('crello-pro', freeTier: 'Free basic account access', price: 10, priceTier: 'Pro monthly', tips: 'Professional graphic design kit from VistaCreate | Featuring high-end "Team Collaboration" and "Premium Assets" to manage your entire organization\'s visual data presence effortlessly'),
    t('bg-eraser-pro', freeTier: 'Free basic removal available', price: 5, priceTier: 'Premium monthly', tips: 'Technical image cleanup assistant for pros | AI-powered "High Res Download" ensures your brand visuals follow specific high-fidelity data benchmarks for pro media'),
    t('palette-pro', freeTier: 'Free online access', price: 9, priceTier: 'Pro monthly', tips: 'High-speed colorization research toolkit | AI-powered "Custom Filters" and "Edit" ensures your final project follow specific artistic data benchmarks for high-impact results'),
    t('google-translate-expert', freeTier: 'Completely free app', price: 0, tips: 'Professional linguistic research assistant | AI-powered "Context" understanding handles thousands of complex text data queries to build high-end authoritative translation logs'),
    t('fetcher-ai-solutions', freeTier: 'Free trial for pros', price: 149, priceTier: 'Enterprise monthly', tips: 'The choice of world-class recruiting teams | AI-powered "Market Insights" handles thousands of candidate data captures simultaneously driven by deep behavioral research'),
    t('dover-ai-solutions', freeTier: 'Free trial available on site', price: 99, priceTier: 'Enterprise monthly', tips: 'Leading platform for high-end "Talent" data extraction used by top tech companies globally for enterprise hiring safety'),
    t('followr-ai', freeTier: 'Free trial available', price: 19, priceTier: 'Basic monthly', tips: 'The "Engagement" king of social apps | Use the "AI Writer" for high-impact social data collection and sharing along your team'),
    t('crello-app', freeTier: 'Free forever (Web/App)', price: 10, priceTier: 'Pro monthly', tips: 'The king of smart design tools | Features high-accuracy "Comparison" data maps of template results and parameters for pro designers'),
    t('bgeraser-expert', freeTier: 'Free research tool access', price: 5, priceTier: 'Pro monthly', tips: 'Next-gen image editing platform | AI-powered "In-painting" and "Restoration" handles your entire dataset discovery flow and behavioral research'),
    t('palette-expert', freeTier: 'Free online access', price: 9, priceTier: 'Pro monthly', tips: 'Leading platform for high-end "Artistic" data archiving used by historians globally to build their own searchable knowledge base of visual history'),
    t('google-translate-app', freeTier: 'Free forever on all platforms', price: 0, tips: 'The king of smart linguistic tools | Features high-accuracy "Comparison" data maps of translation results and parameters for pro researchers'),
    t('fetcher-app', freeTier: 'Free forever online', price: 149, priceTier: 'Standard monthly', tips: 'The smarter way to find talent info | AI-powered "Discovery" finds hidden gems and info data traditional recruiters miss based on your specific trip'),
    t('dover-app', freeTier: 'Free forever (Web/App)', price: 99, priceTier: 'Basic monthly', tips: 'The most artistic hiring platform | Use the "Character" check for high-impact candidate data and model sharing along your team'),
    t('followr-app', freeTier: 'Free forever online', price: 19, priceTier: 'Standard monthly', tips: 'The "Power-user" of social management | AI-powered "Alerting" management uses million of successful post data for better global brand reach'),
    t('crello-ai', freeTier: 'Free search trial available', price: 10, priceTier: 'Pro monthly', tips: 'The pioneer of high-end easy design | Best for turning any technical site recording into a professional performance for social and corporate media data'),
    t('bgeraser-ai-pro', freeTier: 'Free trial for individuals', price: 5, priceTier: 'Premium monthly', tips: 'The smarter way to manage image pixels | AI-powered "Batch Processing" uses million of successful edit data for better global data science reach'),
    t('palette-ai-pro', freeTier: 'Free trial available', price: 9, priceTier: 'Pro monthly', tips: 'High-speed colorization integration suite | AI-powered "Automation" handles thousands of image data queries simultaneously driven by deep data research'),
    t('google-translate-ai-pro', freeTier: 'Completely free app', price: 0, tips: 'The industry standard for high-end translation | AI-powered "Voice" and "Text" handles your entire data presence and security research'),
    t('fetcher-expert', freeTier: 'Free basic tool access', price: 149, priceTier: 'Team license', tips: 'The expert choice for modern talent acquisition | AI-powered "Automation" ensures your entire team follows specific brand and data rules'),
    t('dover-expert', freeTier: 'Free search credits', price: 99, priceTier: 'Pro monthly', tips: 'Leading platform for high-end "Recruitment" data extraction used by world-class brands for global talent safety'),
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
