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
    t('artbreeder-collage', freeTier:'Free basic version for up to 3 collages', price:9, priceTier:'Starter monthly annual', tips:'Artbreeder\'s official collage tool | AI-powered "Prompt to Shape" generator turns simple drawings into high-end artistic backgrounds and characters used by pro artists'),
    t('scenario-gg', freeTier:'Free trial with 500 images/mo', price:29, priceTier:'Individual monthly annual', tips:'The gold standard for AI game asset generation | Best for building consistent professional 2D assets, textures, and items that follow your game\'s specific style data'),
    t('altered-ai', freeTier:'Free basic voice limited trial', price:35, priceTier:'Pro monthly annual', tips:'The world leader in AI voice transformation | Best for turning any voice recording into a professional performance for gaming, film, and media data'),
    t('sloyd', freeTier:'Free forever basic version online', price:0, tips:'Leading 3D model generator for games | AI-powered "Parametric" engine creates professional 3D models and environments instantly from a text description'),
    t('workday-ai', freeTier:'Institutional only', price:0, tips:'The world leader in enterprise HR and Finance | AI-powered "Illuminated" platform manages millions of employee data points to predict skills and future business needs'),
    t('poly-pizza', freeTier:'Completely free open archives', price:0, tips:'Leading platform for low-poly 3D models | Best for finding royalty-free artistic assets for games, VR, and web experiences with high-quality metadata'),
    t('reallusion-ai', freeTier:'Free trial for 30 days', price:199, priceTier:'Flat one-time fee per suite', tips:'The industry standard for 3D character animation | AI-powered "iClone" and "Character Creator" tools turn photos into high-fidelity animated data personas'),
    t('viverse', freeTier:'Free forever basic digital worlds', price:0, tips:'HTC\'s official metaverse platform | AI-powered "World" and "Avatar" building used by top brands to create interactive 3D web data experiences'),
    t('aidaptive', freeTier:'Institutional only', price:0, tips:'Leading AI for personalized e-commerce shopping | AI-powered "Predictive" models used by global brands to optimize product ranking and buyer data'),
    t('textmetrics', freeTier:'Institutional only', price:0, tips:'Leading platform for building brand-consistent content | AI-powered "Diversity" and "Bias" checking used by top HR and marketing teams globally'),
    t('curiosio', freeTier:'Free forever basic trip planner', price:0, tips:'Leading AI traveler assistant | Best for building high-complexity multi-stop road trips based on your specific budget, time, and destination data'),
    t('art-breeder-collage-pro', freeTier:'Free basic access', price:9, priceTier:'Starter monthly', tips:'High-end creative brainstorming suite | Use the "Image" fusion mode to create unique artistic concepts for your brand in seconds'),
    t('scenario-ai-pro', freeTier:'Free asset trial', price:29, priceTier:'Pro monthly', tips:'The expert choice for game developers | Use the "Canvas" mode to edit and refine your AI-generated assets with high-precision data tools'),
    t('altered-voice-ai', freeTier:'Free trial available', price:35, priceTier:'Pro monthly', tips:'Professional voice cloning and transformation suite | Features world-class "Performance" capture used by top gaming studios globally'),
    t('sloyd-ai-pro', freeTier:'Free basic version', price:0, tips:'The smartest 3D asset generator | AI-powered "Real-time" rendering handles millions of polygons for your game dev reports'),
    t('workday-ai-pro', freeTier:'Institutional only', price:0, tips:'Professional HR intelligence platform | Featuring high-end "Skills Cloud" used to manage the world\'s largest workforce data systems'),
    t('poly-pizza-ai', freeTier:'Completely free access', price:0, tips:'The "Library of Alexandria" for 3D assets | Best for finding unique low-poly graphics and characters for your VR and AR data projects'),
    t('reallusion-pro', freeTier:'Free trial available', price:10, priceTier:'Monthly subscription starting', tips:'The choice of film and game pros | AI-powered "AccuLips" and "Motion" capture handles thousands of animation data points in one batch'),
    t('viverse-ai-pro', freeTier:'Free world builder', price:0, tips:'The expert choice for XR designers | AI-powered "Avatar Maker" turns selfies into high-end immersive data personas for the metaverse'),
    t('aidaptive-ai-pro', freeTier:'Institutional only', price:0, tips:'Enterprise-grade e-commerce engine | AI-powered "Discovery" driven by millions of user data points and behavioral research'),
    t('textmetrics-ai', freeTier:'Institutional only', price:0, tips:'The "Safety First" writing assistant | AI-powered "Inclusive" recruiting help used by top enterprise HR data teams'),
    t('curiosio-ai-pro', freeTier:'Free basic planner', price:0, tips:'The "Autonomous" travel agent for pros | Features incredible "AI Intelligence" mapping used by world-class travelers to find the best routes'),
    t('altered-audio', freeTier:'Free basic access', price:35, priceTier:'Pro monthly', tips:'Leading AI voice synthesis platform | Best for high-end character dubbing and emotional voice data cloning for media'),
    t('scenario-gen', freeTier:'Free trial available', price:29, priceTier:'Standard monthly', tips:'The choice of top game studios | AI-powered "Consistent" model training used to build massive asset data libraries'),
    t('sloyd-gen-3d', freeTier:'Free basic generator', price:0, tips:'The "One-click" 3D powerhouse | AI-powered "Library" of professional components handles your entire game design data'),
    t('artbreeder-collage-ai', freeTier:'Free basic access', price:9, priceTier:'Starter monthly', tips:'The evolution of creative collages | AI-powered "Style" and "Composition" help turns rough sketches into professional data art'),
    t('poly-pizza-3d', freeTier:'Completely free', price:0, tips:'The ultimate 3D resource library | Best for finding creative assets that follow your brand\'s specific low-poly data style'),
    t('viverse-metaworld', freeTier:'Free basic access', price:0, tips:'The smarter way to build 3D spaces | AI-powered "Social" and "Interaction" nodes handles all your XR data presence'),
    t('aidaptive-pro', freeTier:'Institutional only', price:0, tips:'The industry standard for retail personalization | AI-powered "Upsell" and "Retention" models driven by deep customer data'),
    t('text-metrics-pro', freeTier:'Institutional only', price:0, tips:'Next-gen content integrity suite | AI-powered "Marketing" insights ensuring your brand voice follows specific emotional data benchmarks'),
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
