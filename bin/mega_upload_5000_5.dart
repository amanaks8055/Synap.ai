// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'env.dart';

Map<String, dynamic> t(String id, String name, String cat, String desc,
    String url, bool free, bool featured, int clicks,
    {String? freeTier, double? price, String? priceTier, String? tips}) {
  String domain;
  try {
    domain = Uri.parse(url).host;
    if (domain.isEmpty) domain = url.replaceAll('https://', '').split('/').first;
  } catch (_) {
    domain = url.replaceAll('https://', '').split('/').first;
  }
  return {
    'id': id,
    'name': name,
    'slug': id,
    'category_id': cat,
    'description': desc,
    'icon_emoji': '🤖',
    'icon_url': 'https://logo.clearbit.com/$domain',
    'website_url': url,
    'has_free_tier': free,
    'is_featured': featured,
    'click_count': clicks,
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
    // ━━━ AI FOR ADVERTISING & MEDIA BUYING (Iconic) ━━━
    t('google-ads-ai','Google Ads (AI)','marketing','The world\'s #1 ad platform using AI for smart bidding and asset generation.','https://ads.google.com',true,true,999999, freeTier:'Free to join, pay per click', price:0, tips:'AI-powered "Performance Max" is elite | Best for global scale | Industry standard'),
    t('meta-ads-ai-pro','Meta Ads (Advantage+)','marketing','Leading social ad platform using AI for automated targeting and creative help.','https://ads.facebook.com',true,true,999999, freeTier:'Free to join, pay per click', price:0, tips:'AI-powered "Advantage+" campaigns | Best for e-com and local biz | Global'),
    t('amazon-ads-ai','Amazon Advertising','marketing','Leading e-commerce ad giant using AI to match products to buyers at scale.','https://advertising.amazon.com',true,true,500000, freeTier:'Free to join, pay per click', price:0, tips:'AI-powered "Sponsored Products" | Best for Amazon sellers | High conversion'),
    t('ad-roll-ai-pro','AdRoll','marketing','Leading retargeting platform using AI to bring customers back to your site.','https://adroll.com',true,true,250000, freeTier:'Free trial for 30 days', price:36, priceTier:'Essential monthly', tips:'Best for retargeting campaigns | AI-powered "Bidding" | clean UI'),
    t('taboola-ai-pro','Taboola','marketing','The world\'s #1 discovery platform for native ads using AI for placements.','https://taboola.com',true,true,180000, freeTier:'Self-service access', price:0, tips:'Best for content distribution | AI-powered "SmartBid" | Massive reach'),

    // ━━━ AI FOR ARCHITECTURE & BIM (Pro) ━━━
    t('auto-desk-revit','Autodesk Revit (AI)','design','The industry standard BIM software with new AI-powered "Generative Design".','https://autodesk.com/revit',true,true,500000, freeTier:'30-day free trial on site', price:350, priceTier:'Monthly membership annual', tips:'AI-powered "Energy Analysis" | Best for serious architecture | Robust'),
    t('rhino-ai-pro-arch','Rhino + Grasshopper','design','Leading 3D modeler using AI nodes for complex generative architecture.','https://rhino3d.com',true,true,250000, freeTier:'90-day free trial on site', price:995, priceTier:'Full license one-time', tips:'Best for organic and parametric design | AI-powered "Compute" | high tech'),
    t('archicad-ai-pro','Archicad (Graphisoft)','design','Leading BIM platform with AI-powered "Algorithmic" design and data logs.','https://graphisoft.com',true,true,180000, freeTier:'Educational version available', price:240, priceTier:'Monthly membership annual', tips:'Best for Mac-based architecture | AI-powered "EcoDesigner" | high end'),
    t('sketch-up-ai-pro','SketchUp (AI)','design','The easiest 3D modeler with new AI-powered "Diffusion" for fast renders.','https://sketchup.com',true,true,999999, freeTier:'Free "Web" version available', price:119, priceTier:'Go monthly annual', tips:'Best for fast architectural POCs | AI-powered "PreDesign" | User favorite'),
    t('lumion-ai-pro-viz','Lumion','design','Leading real-time 3D architectural visualization software with AI help.','https://lumion.com',true,true,150000, freeTier:'Free trial available', price:600, priceTier:'Subscription yearly', tips:'Best for high-end exterior renders | AI-powered "Styles" | Swedish tech'),

    // ━━━ AI FOR MINING & GEOSPATIAL (Iconic) ━━━
    t('esri-arcgis-ai','Esri ArcGIS (AI)','science','The world\'s #1 GIS platform with high-end AI powered spatial analysis.','https://esri.com',true,true,999999, freeTier:'Free trial available on site', price:0, tips:'The gold standard for mapping | AI-powered "Deep Learning" | Industry giant'),
    t('qgis-ai-pro-open','QGIS (Open Source)','science','The world\'s most popular open source GIS with AI-powered plugin apps.','https://qgis.org',true,true,350000, freeTier:'Completely free forever', price:0, tips:'Best for developers and data nerds | AI-powered "SCP" plugin | High reach'),
    t('des-cartes-ai-pro','Descartes Labs','science','Leading satellite data platform using AI for global environmental monitoring.','https://descarteslabs.com',false,true,58000, freeTier:'Institutional only', price:0, tips:'AI-powered "Commodity" tracking | Best for supply chain labs | High end'),
    t('global-map-ai-pro','Global Mapper','science','Leading geospatial data processing with AI-powered lidar and terrain data.','https://bluemarblegeo.com',true,false,45000, freeTier:'Free trial version', price:0, tips:'Best for lidar processing | AI-powered "Feature extraction" | robust'),
    t('planet-ai-pro-sat','Planet (AI)','science','Monitoring the entire Earth daily using high-end AI and satellite data.','https://planet.com',false,true,120000, freeTier:'Institutional only', price:0, tips:'AI-powered "Road" and "Building" detect | Best for change tracking | Iconic'),

    // ━━━ AI FOR GAMING ENGINES (Iconic) ━━━
    t('unreal-ai-pro-epi','Unreal Engine (AI)','entertainment','The world\'s most advanced 3D engine with high-end AI "Mass AI" and tools.','https://unrealengine.com',true,true,999999, freeTier:'Free for personal/small devs', price:0, tips:'AI-powered "Metahumans" are elite | Best for AAA games | High fidelity'),
    t('unity-ai-pro-sent','Unity (Sentis)','entertainment','Leading mobile game engine with new AI-powered "Sentis" and "Muse" tools.','https://unity.com',true,true,999999, freeTier:'Free for personal starters', price:0, tips:'AI-powered "Asset" generation | Best for mobile and VR | Global leader'),
    t('roblox-ai-pro-gen','Roblox (AI)','entertainment','Global gaming platform using AI-powered "Material" and code help for devs.','https://roblox.com',true,true,999999, freeTier:'Completely free for players', price:0, tips:'AI-powered "Text-to-Code" | Best for younger creators | Millions of users'),
    t('godot-ai-pro-open','Godot (AI)','entertainment','Leading open-source game engine with AI-powered plugin and node support.','https://godotengine.org',true,true,250000, freeTier:'Completely free forever', price:0, tips:'Best for 2D and indie 3D | AI-powered "Python" support | Cleanest UI'),
    t('cry-engine-ai-pro','CryEngine','entertainment','High-end 3D engine using AI-powered physics and landscape data labs.','https://cryengine.com',true,false,84000, freeTier:'Free for basic exploration', price:0, tips:'Best for high fidelity environments | AI-powered "AI" systems | German tech'),

    // ━━━ FINAL GEMS v45 (Modern AI Cloud) ━━━
    t('ver-cel-ai-pro','Vercel (AI SDK)','code','The fastest way to deploy AI applications and LLM backends in the cloud.','https://vercel.com',true,true,500000, freeTier:'Free for hobby projects', price:20, priceTier:'Pro monthly', tips:'Best for Next.js AI apps | AI-powered "Middleware" | high speed'),
    t('netli-fy-ai-pro','Netlify','code','Leading web platform for AI apps with built-in "Function" and edge help.','https://netlify.com',true,true,350000, freeTier:'Free forever basic version', price:19, priceTier:'Pro monthly annual', tips:'Best for Jamstack and AI sites | AI-powered "Deploy" previews | high trust'),
    t('kv-store-ai-pro','Upstash (AI)','code','Serverless database for AI apps including Vector, Redis, and Kafka sync.','https://upstash.com',true,true,120000, freeTier:'Free forever with usage caps', price:0, tips:'Best for serverless AI state | AI-powered "Vector" help | extremely fast'),
    t('fly-io-ai-pro-hos','Fly.io','code','Deploy AI applications close to the users with global multi-region Edge.','https://fly.io',true,true,150000, freeTier:'Free tier allowances included', price:5, priceTier:'Monthly base annual', tips:'Best for low-latency AI backends | AI-powered "Deployment" | high tech'),
    t('neon-ai-pro-db','Neon','code','Leading serverless Postgres database built for the AI era and scale.','https://neon.tech',true,true,180000, freeTier:'Free forever basic version', price:19, priceTier:'Launch monthly annual', tips:'Best for AI backends with branching | AI-powered "Autoscale" | high value'),
  ];

  print('Total tools to upload: ${tools.length}');

  const supaPath = '$supabaseUrl/rest/v1/ai_tools';
  const batchSize = 25;
  var uploaded = 0;

  for (var i = 0; i < tools.length; i += batchSize) {
    final end = (i + batchSize > tools.length) ? tools.length : i + batchSize;
    final batch = tools.sublist(i, end);
    final bodyBytes = utf8.encode(jsonEncode(batch));

    try {
      final req = await client.postUrl(Uri.parse(supaPath));
      req.headers.set('apikey', anonKey);
      req.headers.set('Authorization', 'Bearer $anonKey');
      req.headers.set('Content-Type', 'application/json; charset=utf-8');
      req.headers.set('Prefer', 'resolution=merge-duplicates');
      req.contentLength = bodyBytes.length;
      req.add(bodyBytes);
      final resp = await req.close();
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        uploaded += batch.length;
        print('OK $uploaded/${tools.length}');
      } else {
        final respBody = await utf8.decodeStream(resp);
        print('FAIL at $i [${resp.statusCode}]: $respBody');
      }
    } catch (e) {
      print('ERR at $i: $e');
    }
  }

  client.close();
  print('DONE! Uploaded $uploaded tools with full pricing data');
}
