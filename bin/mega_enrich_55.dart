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
    t('black-forest', freeTier: 'Free trial credits available via API', price: 0, tips: 'The world leader in photorealistic image generation (FLUX.1) | AI-powered "Motion" and "Realism" helps artists create high-fidelity visuals and manage complex dataset discovery for marketing and research'),
    t('minimax', freeTier: 'Free trial available on site (Hailuo AI)', price: 0, tips: 'Leading AI video generation platform for high-end cinematic results | AI-powered "Physics" and "Detail" understanding helps creators generate realistic scenes and motion data sequences instantly'),
    t('animaker-ai', freeTier: 'Free forever basic version (Web/App)', price: 10, priceTier: 'Basic monthly annual', tips: 'The world leader in cloud-based animation for businesses | AI-powered "Character Builder" and "Auto-lip-sync" helps you create professional video data content and marketing clips effortlessly'),
    t('hotpot-ai', freeTier: 'Free limited basic version online', price: 10, priceTier: 'Premium monthly starts', tips: 'All-in-one AI platform for graphics and image editing | AI-powered "Photo Restorer," "Colorizer," and "Object Remover" help you manage and enhance thousands of image data points in seconds'),
    t('ai-photo-editor', freeTier: 'Free forever basic features (Mobile/Mac)', price: 3.33, priceTier: 'Subscription monthly annual', tips: 'CyberLink PhotoDirector\'s official AI photo suite | AI-powered "Sky Replacement" and "Body Shaper" help you create professional visual data content and social media posts with high-end tools'),
    t('imgcreator', freeTier: 'Daily free credits (Up to 10 images)', price: 9, priceTier: 'Starter monthly starts', tips: 'Leading AI image generation and design platform | AI-powered "Room Designer" and "Anime" modes help you generate high-quality visual data from simple text prompts and research logs'),
    t('lateral-ai', freeTier: 'Free trial available on site', price: 0, tips: 'Leading AI for academic and professional research | AI-powered "Literature Review" and "Synthesize" helps researchers manage thousands of document data points and build authoritative research pages'),
    t('black-forest-pro', freeTier: 'Free trial for developers', price: 0, tips: 'Professional image orchestration suite | Featuring high-end "Advanced Motion" and "Prompt Adherence" to ensure your entire team follows specific brand and artistic data benchmarks'),
    t('minimax-pro', freeTier: 'Free trial credits online', price: 0, tips: 'High-end video generation assistant | Featuring advanced "Cinematography" in complex visual environments using deep physics data research and history for pro creators'),
    t('animaker-pro', freeTier: 'Free basic version available', price: 10, priceTier: 'Professional monthly', tips: 'Professional corporate animation suite | Featuring high-end "4K Exports" and "Commercial Rights" to manage your entire organization\'s video data presence effortlessly'),
    t('hotpot-pro', freeTier: 'Free basic access online', price: 10, priceTier: 'Individual monthly', tips: 'The "Safety First" tool for graphics designers | AI-powered "Validation" and "Report" generation ensures your entire team follows specific brand and data rules'),
    t('photo-director-pro', freeTier: 'Free basic version available', price: 3.33, priceTier: 'Premium monthly', tips: 'High-end photo editing toolkit | Featuring high-end "Generative Fill" and "Layer Management" driven by your specific personal data history and workflows'),
    t('imgcreator-pro', freeTier: 'Free basic daily access', price: 9, priceTier: 'Professional monthly', tips: 'Technical design assistant for creators | AI-powered "Upscale" and "Speed" metrics ensure your brand visuals follow specific high-fidelity data benchmarks'),
    t('lateral-expert', freeTier: 'Free research trial available', price: 0, tips: 'Professional academic research assistant | AI-powered "Annotation" and "Insight" handles thousands of complex web source data queries to build high-end research logs'),
    t('black-forest-ai-pro', freeTier: 'Free trial available', price: 0, tips: 'Next-gen image intelligence engine | AI-powered "Model" management handles your entire enterprise visual data science and research driven by deep research'),
    t('minimax-ai', freeTier: 'Free basic credits online', price: 0, tips: 'The "Engagement" king of video apps | Use the "Physics" model for high-impact social data clips and video sharing along your team'),
    t('animaker-ai-pro', freeTier: 'Free trial for pro', price: 10, priceTier: 'Plus monthly', tips: 'Next-gen animation intelligence engine | AI-powered "Scene" and "Character" insights driven by millions of corporate data points and behavioral research'),
    t('hotpot-ai-solutions', freeTier: 'Free trial for business', price: 10, priceTier: 'Standard monthly', tips: 'Leading platform for high-end "Graphics" data extraction used by top tech companies globally for digital asset safety'),
    t('photodirector-expert', freeTier: 'Free basic tool access', price: 3.33, priceTier: 'Elite monthly', tips: 'The industry standard for high-end photo editing | AI-powered "Portrait" and "Effects" ensure your brand follows specific data and tone benchmarks'),
    t('img-creator-pro', freeTier: 'Free trial for individuals', price: 9, priceTier: 'Pro monthly', tips: 'Leading platform for high-end "Art" data extraction used by world-class brands for global consumer and artistic safety'),
    t('lateral-ai-pro', freeTier: 'Free trial for pro', price: 0, tips: 'The smartest choice for pro researchers | AI-powered "Discovery" finds hidden web gems and info data traditional engines miss based on your specific trip'),
    t('black-forest-app', freeTier: 'Free forever online', price: 0, tips: 'The king of smart image tools | Features high-accuracy "Comparison" data maps of prompt results and parameters for pro researchers and artists'),
    t('minimax-app', freeTier: 'Free forever on all platforms', price: 0, tips: 'The king of smart mobile video tools | Features world-class "Orchestration" for high-speed video updates and data safety'),
    t('animaker-app', freeTier: 'Free forever (Web/App)', price: 10, priceTier: 'Basic monthly', tips: 'The most artistic animation platform | Use the "Artistic" filters for high-impact video data and asset sharing along your team'),
    t('hotpot-app', freeTier: 'Free forever online', price: 10, priceTier: 'Individual monthly', tips: 'The king of smart graphics tools | Features high-accuracy "Comparison" data maps of visual results and parameters for pro designers'),
    t('photo-director', freeTier: 'Free forever (Mobile/App)', price: 3.33, priceTier: 'Premium monthly', tips: 'The "Engagement" king of photo apps | Use the "AI Object" remover for high-impact visual data collection that converts'),
    t('img-creator', freeTier: 'Free basic version available', price: 9, priceTier: 'Starter monthly', tips: 'The pioneer of high-end AI design | Best for turning any technical site recording into a professional performance for gaming and media research'),
    t('lateral', freeTier: 'Free forever (Solo)', price: 0, tips: 'The ultimate academic resource | Best for finding creative research flows that follow your brand\'s specific artistic data style'),
    t('hotpot-ai-pro', freeTier: 'Free trial available', price: 10, priceTier: 'Premium monthly', tips: 'High-speed graphics automation suite | AI-powered "Batch" processing handles thousands of image data queries simultaneously driven by deep data research'),
    t('animaker-ai-solutions', freeTier: 'Free trial for business', price: 10, priceTier: 'Enterprise monthly', tips: 'Leading platform for high-end "Animation" data extraction used by world-class brands for global consumer and employee safety'),
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
