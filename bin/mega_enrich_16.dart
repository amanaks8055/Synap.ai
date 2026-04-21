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
    t('veed', freeTier:'Free basic exports (with watermark)', price:18, priceTier:'Basic monthly annual', tips:'The world leader in browser-based video editing | AI-powered "Auto Subtitles" and "Eye Contact" correction used by top creators'),
    t('uizard', freeTier:'Free forever basic version', price:12, priceTier:'Pro monthly annual', tips:'The "Canva" of UI/UX design | AI-powered "Screenshot to Design" turns any app image into an editable mockup in seconds'),
    t('wix-ai', freeTier:'Free to build and host on Wix domain', price:16, priceTier:'Light monthly annual', tips:'Leading website builder giant | AI-powered "ADI" creates a unique business site based on your specific requirements'),
    t('scholarai', freeTier:'Free forever basic version', price:0, tips:'Leading AI assistant for academic research | Best for finding peer-reviewed papers and extracting verified data logs'),
    t('explainpaper', freeTier:'Free and unlimited basic version', price:12, priceTier:'Plus monthly annual', tips:'Best for students and researchers | AI-powered "Paragraph Explainer" simplifies complex academic jargon instantly'),
    t('paperdigest', freeTier:'Free basic highlights available', price:0, tips:'Best for keeping up with new research | AI-powered "One-minute Summary" for any academic paper link'),
    t('txyz', freeTier:'Free forever basic version', price:0, tips:'Next-gen AI research platform | Best for building and searching massive libraries of technical and scientific documents'),
    t('elai-io', freeTier:'Free 1-minute trial video', price:23, priceTier:'Basic monthly annual', tips:'Leading platform for AI avatars and video dubbing | Best for high-accuracy localized corporate training videos'),
    t('deepbrain', freeTier:'Free trial available on site', price:30, priceTier:'Starter monthly annual', tips:'Best for ultra-realistic AI news anchors and avatars | AI-powered "Text to Video" is extremely fast and high fidelity'),
    t('relume', freeTier:'Free basic sitemap creation', price:32, priceTier:'Starter monthly annual', tips:'Leading platform for building sitemaps and wireframes | AI-powered "Sitemap" to multi-page UI generation for web agencies'),
    t('visily', freeTier:'Free forever basic version', price:0, tips:'Leading AI wireframing tool for teams | Best for non-designers building professional UI mockups from scratch'),
    t('aiva', freeTier:'Free for non-commercial use', price:11, priceTier:'Standard monthly annual', tips:'The world\'s first AI-composed soundtrack generator | Best for unique and royalty-free orchestral and ambient music'),
    t('loudly', freeTier:'Free basic version available', price:11, priceTier:'Personal monthly annual', tips:'Leading AI music platform for social media | Best for finding the perfect "Vibe" and "Style" for social content'),
    t('stable-video', freeTier:'Completely free open source', price:0, tips:'Stability AI\'s gold standard for video gen | Best for local high-end "Image to Video" transformations and data'),
    t('wanvideo', freeTier:'Free beta access available', price:0, tips:'Next-gen Chinese AI video model | Best for high-complexity motion and realistic human physics in short clips'),
    t('patterned', freeTier:'Free trial for 20 patterns', price:10, priceTier:'Basic monthly credits', tips:'Best for designers and brands | AI-powered "Seamless" pattern generation from text for textiles and wallpaper'),
    t('stockai', freeTier:'Free forever basic version', price:0, tips:'Leading platform for high-quality generated stock images | Best for finding unique visuals that don\'t exist elsewhere'),
    t('rendernet', freeTier:'Free basic credits monthly', price:19, priceTier:'Pro monthly annual', tips:'Leading AI character generator for gaming and 3D | Best for consistent "Persona" rendering across various poses'),
    t('khroma', freeTier:'Completely free online tool', price:0, tips:'The AI color tool for designers | Learns your color preferences to generate infinite personalized palettes and gradients'),
    t('colormind', freeTier:'Completely free online tool', price:0, tips:'Leading AI color scheme generator | Extracts palettes from photos and predicts aesthetic combinations for UI designs'),
    t('prisma-db', freeTier:'Free forever open source base', price:29, priceTier:'Optimize monthly starting', tips:'Leading modern database toolkit | AI-powered "Schema" and "Query" help for developers used by 1M+ teams'),
    t('veed-io', freeTier:'Free basic exports', price:18, priceTier:'Basic monthly', tips:'The all-in-one AI video suite | Best for automated subtitling, translations, and social media repurposing'),
    t('relume-ai', freeTier:'Free sitemap builder', price:32, priceTier:'Starter monthly', tips:'Best for designing complex website structures | AI-powered "Wireframe" generation for Figma and Webflow'),
    t('uizard-ai', freeTier:'Free forever basic access', price:12, priceTier:'Pro monthly', tips:'The fastest way to build app mockups | AI-powered "Design Assistant" follows your branding and style'),
    t('deepbrain-ai', freeTier:'Free trial available', price:30, priceTier:'Starter monthly', tips:'Leading platform for high-end AI personas | Best for automated customer service and news broadcasting'),
    t('elai-io-pro', freeTier:'Free video trial', price:23, priceTier:'Basic monthly', tips:'Advanced AI video generation for enterprises | Best for multi-lingual corporate communications'),
    t('stable-video-diffusion', freeTier:'Completely free (Open Source)', price:0, tips:'The leader in high-fidelity AI video | Best for local research and custom high-end video training'),
    t('wix-adi-ai', freeTier:'Free build and host', price:16, priceTier:'Base monthly', tips:'The industry standard for automated web design | AI-powered "Industry" specific research and layout'),
    t('visily-ai', freeTier:'Free basic version', price:0, tips:'Leading AI-powered wireframe builder | Best for early-stage startup prototyping and ideation'),
    t('aiva-audio', freeTier:'Free forever (Personal)', price:11, priceTier:'Standard monthly', tips:'Pioneer of AI-powered music composition | Best for high-end game and film soundtracks'),
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
