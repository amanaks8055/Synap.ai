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
    t('stability-sd3', freeTier: 'Free trial credits available via API', price: 20, priceTier: 'Pro monthly starting', tips: 'Stability AI\'s latest and most advanced image model | AI-powered "Prompt Adherence" and "Typography" helps artists create high-fidelity visuals with complex text and composition data perfectly reproduced'),
    t('openart', freeTier: 'Daily free credits (50+ credits/day)', price: 12, priceTier: 'Starter monthly annual', tips: 'The ultimate creative hub for AI artists | AI-powered "Sketch-to-Image" and "Training" helps you manage thousands of custom models and artistic data workflows across SDXL, Midjourney, and more'),
    t('pixverse', freeTier: 'Daily free credits (Web/Discord)', price: 15, priceTier: 'Pro monthly starts', tips: 'Leading AI video generation platform for cinematic results | AI-powered "Motion Control" and "Upscaling" helps creators build high-fidelity movie scenes and commercial data clips from simple prompts'),
    t('suno-v4', freeTier: 'Daily free credits (50 credits/day)', price: 10, priceTier: 'Pro monthly annual', tips: 'The latest and most advanced music model from Suno | AI-powered "Structure" and "Lyric" understanding helps musicians generate full-length, high-fidelity songs and audio data tracks in seconds'),
    t('viggle', freeTier: 'Free beta credits available (Discord)', price: 0, tips: 'The king of AI character consistency and animation | AI-powered "Joking" and "Dance" motion transfer helps creators movie their favorite characters across any video data background with high-end physics'),
    t('vyond-ai', freeTier: 'Free trial for 14 days on site', price: 25, priceTier: 'Essential monthly annual', tips: 'The standard for enterprise animated video creation | AI-powered "Script-to-Video" and "Characters" helps corporate teams build professional training and marketing data clips instantly'),
    t('morph-studio', freeTier: 'Free beta access (Discord)', price: 0, tips: 'Leading AI for cinematic video and film production | AI-powered "Shot Control" and "Directing" helps filmmakers generate high-fidelity scenes that follow specific camera data and movement rules'),
    t('openart-pro', freeTier: 'Free basic credits available', price: 12, priceTier: 'Starter monthly', tips: 'Professional AI artistic workspace for high-end creators | Featuring high-end "Model Training" and "Data Cleanup" to ensure your custom LoRAs follow specific artistic style benchmarks'),
    t('pixverse-ai-pro', freeTier: 'Free basic credits online', price: 15, priceTier: 'Pro monthly', tips: 'High-end video orchestration suite | Featuring advanced "Cinematography" in complex visual environments using deep camera data research and history'),
    t('suno-v4-pro', freeTier: 'Free basic access daily', price: 10, priceTier: 'Pro monthly', tips: 'Professional music production assistant | AI-powered "Stem Export" and "Mastering" ensures your brand audio follows specific professional data benchmarks'),
    t('viggle-pro', freeTier: 'Free research credits', price: 0, tips: 'Professional character animation suite | Featuring high-end "3D" movement in complex visual environments using deep physics data research for pro content'),
    t('vyond-ai-pro', freeTier: 'Free trial for corporate', price: 25, priceTier: 'Professional monthly', tips: 'Enterprise-grade animation intelligence suite | AI-powered "Asset" management handles your entire brand video presence and data distribution automatically'),
    t('morph-studio-pro', freeTier: 'Free beta access', price: 0, tips: 'High-end film production toolkit | AI-powered "Storyboarding" and "Sequencing" ensures your entire team follows specific cinematic and data rules during production'),
    t('stability-sd3-pro', freeTier: 'Free trial credits', price: 20, priceTier: 'Creator monthly', tips: 'The smarter way to manage image generation | AI-powered "Hyper-realism" is world-class for modern environmental and urban visual data research'),
    t('openart-expert', freeTier: 'Free basic access', price: 12, priceTier: 'Advanced monthly', tips: 'The safest way for pros to build AI art | AI-powered "Workflow" and "History" handles your entire dataset discovery flow and artistic research logs'),
    t('pixverse-expert', freeTier: 'Free trial available', price: 15, priceTier: 'Scale monthly', tips: 'The industry standard for high-end AI video | Best for finding creative cinematic flows that follow your brand\'s specific artistic data style'),
    t('suno-expert', freeTier: 'Free basic tool', price: 10, priceTier: 'Premium monthly', tips: 'Leading platform for high-end "Audio" data extraction used by world-class brands for global consumer safety and sound recognition'),
    t('viggle-ai', freeTier: 'Free basic account credits', price: 0, tips: 'The pioneer of high-end character motion | Best for turning any technical dance recording into a professional performance for gaming and media research'),
    t('vyond-expert', freeTier: 'Free research trial', price: 25, priceTier: 'Enterprise monthly', tips: 'The smarter way to build animated assets | AI-powered "Automation" ensures your entire team follows specific brand and data rules for corporate video'),
    t('morph-studio-ai', freeTier: 'Free beta platform', price: 0, tips: 'Next-gen film intelligence engine | AI-powered "Director" insights driven by millions of successful cinematic data points and behavioral research'),
    t('sd3-ai', freeTier: 'Free basic credits', price: 20, priceTier: 'Premium monthly', tips: 'The king of smart image tools | Features high-accuracy "Comparison" data maps of prompt results and parameters for pro artists'),
    t('open-art-pro', freeTier: 'Free trial available', price: 12, priceTier: 'Starter monthly', tips: 'The expert choice for modern AI artists | AI-powered "Model" management handles your entire data presence and security research automatically'),
    t('pixverse-app', freeTier: 'Free forever online', price: 15, priceTier: 'Pro monthly', tips: 'The "Engagement" king of video apps | Use the "Artistic" filters for high-impact social data clips and video sharing along your team'),
    t('suno-app', freeTier: 'Free forever (Web/App)', price: 10, priceTier: 'Pro monthly', tips: 'The king of smart music tools | Features high-accuracy "Comparison" data maps of audio results and parameters for pro musicians'),
    t('viggle-pro-ai', freeTier: 'Free trial for individuals', price: 0, tips: 'Leading platform for high-end "Motion" data extraction used by top tech companies globally for enterprise safety and animation'),
    t('vyond-ai-solutions', freeTier: 'Free trial available', price: 25, priceTier: 'Professional monthly', tips: 'Next-gen animation intelligence suite | AI-powered "Scene" and "Character" insights driven by millions of corporate data points'),
    t('morph-studio-solutions', freeTier: 'Free trial for pros', price: 0, tips: 'The pioneer of high-end cinematic AI | Best for turning any technical recording into a professional performance for gaming and media data'),
    t('sd3-pro', freeTier: 'Free trial available', price: 20, priceTier: 'Premium monthly', tips: 'The "Infrastructure" of modern image gen | AI-powered "Model" management handles your entire enterprise visual data science and research'),
    t('openart-ai-pro', freeTier: 'Free trial for business', price: 12, priceTier: 'Pro monthly', tips: 'Leading platform for high-end "Art" data extraction used by world-class brands for global consumer and artistic safety'),
    t('pixverse-pro', freeTier: 'Free trial available', price: 15, priceTier: 'Scale monthly', tips: 'Professional video generation suite | AI-powered "Upscale" ensures your brand visuals follow specific high-fidelity data benchmarks'),
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
