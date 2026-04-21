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
    // ━━━ AI FOR ADVERTISING & BRANDING (Heavy hitters) ━━━
    t('wpp-ai-pro','WPP (AI Tools)','marketing','World\'s largest advertising group using AI for global creative production.','https://wpp.com',false,true,150000, freeTier:'Institutional only', price:0, tips:'Partner of NVIDIA and Google | AI-powered "Creative Studio" | Massive global reach'),
    t('publicis-ai-sapient','Publicis Sapient','marketing','Leading digital transformation partner using AI for large-scale retail and web.','https://publicissapient.com',false,true,84000, freeTier:'Institutional only', price:0, tips:'AI-powered consumer insights | Enterprise gold standard | Strategic data focus'),
    t('omnicom-ai-pro','Omnicom (Omni)','marketing','High-end marketing orchestration platform using AI for audience precision.','https://omnicomgroup.com',false,true,58000, freeTier:'Institutional only', price:0, tips:'AI-powered "Omni" data engine | Precision marketing at scale | Trusted by top brands'),
    t('interpublic-ai','Interpublic Group (IPG)','marketing','Leading global marketing solutions with AI-powered audience intelligence.','https://interpublic.com',false,true,45000, freeTier:'Institutional only', price:0, tips:'AI-powered "Acxiom" data | Creative and media excellence | Global presence'),
    t('dentsu-ai-pro','Dentsu (Digital)','marketing','Leading Japanese advertising giant with AI-powered creative and data labs.','https://dentsu.com',false,true,35000, freeTier:'Institutional only', price:0, tips:'Asian market leader | AI-powered "Merkle" data | Innovative ad tech'),
    t('akqa-ai-pro','AKQA','design','Award-winning design and innovation agency using AI for future experiences.','https://akqa.com',false,true,28000, freeTier:'Institutional only', price:0, tips:'Part of WPP | AI-powered design prototypes | World class aesthetic'),
    t('frog-design-ai','frog (Capgemini)','design','Global design and strategy firm using AI for product and retail innovation.','https://frogdesign.com',false,true,25000, freeTier:'Institutional only', price:0, tips:'Industry legend in design | AI-powered user research | High-end consulting'),
    t('ideo-ai-pro','IDEO','design','The pioneer of "Design Thinking" using AI for human-centered innovation.','https://ideo.com',false,true,58000, freeTier:'Free articles and toolkits', price:0, tips:'Most famous design firm | AI-powered prototyping workshops | Thought leader'),
    t('designit-ai-pro','Designit (Wipro)','design','Global strategic design firm using AI to build sustainable businesses.','https://designit.com',false,false,12000, freeTier:'Institutional only', price:0, tips:'Part of Wipro | AI-powered service design | European roots'),
    t('rga-ai-pro','R/GA','design','The company for the "Connected Age" using AI for brand transformation.','https://rga.com',false,true,18000, freeTier:'Institutional only', price:0, tips:'Best for tech-integrated branding | AI-powered media innovation | Part of IPG'),

    // ━━━ AI FOR LOGISTICS & WAREHOUSING v2 ━━━
    t('flexport-ai-pro','Flexport','business','The modern global logistics platform using AI for supply chain tracking.','https://flexport.com',false,true,150000, freeTier:'Free to sign up and browse', price:0, tips:'AI-powered real-time tracking | Best for e-commerce brands | Modern and clean'),
    t('project44-ai-pro','project44','business','The world\'s leading supply chain visibility platform with AI insights.','https://project44.com',false,true,45000, freeTier:'Demo available', price:0, tips:'AI-powered "Movement" platform | Track Every shipment globally | High precision'),
    t('fourkites-ai-pro','FourKites','business','Leading real-time supply chain visibility for global enterprises with AI.','https://fourkites.com',false,false,25000, freeTier:'Demo available', price:0, tips:'Predictive ETAs using AI | Largest carrier network | Trusted by Coca-Cola'),
    t('convoy-ai-pro','Convoy (Flexport)','business','AI-powered digital freight network that automates trucking and logistics.','https://convoy.com',true,true,58000, freeTier:'Free app for carriers', price:0, tips:'Acquired by Flexport | AI-powered loads and routing | Zero-waste logistics'),
    t('uber-freight-ai','Uber Freight','business','Leading logistics platform that connects shippers and carriers with AI.','https://uberfreight.com',true,true,120000, freeTier:'Free app for carriers', price:0, tips:'Massive marketplace scale | AI-powered pricing and booking | Reliable and fast'),
    t('ch-robinson-ai','C.H. Robinson (Navisphere)','business','The world\'s largest freight broker using AI for global shipping data.','https://chrobinson.com',false,true,84000, freeTier:'Institutional only', price:0, tips:'Industry gold standard | AI-powered "Navisphere" platform | 100+ years of data'),
    t('xpo-logistics-ai','XPO (Connect)','business','Leading provider of asset-based transportation with AI-powered platform.','https://xpo.com',true,true,45000, freeTier:'Free app for carriers', price:0, tips:'Best for LTL shipping | AI-powered "XPO Connect" | Massive physical scale'),
    t('lineage-ai-pro','Lineage Logistics','business','The world\'s largest cold storage and logistics company using AI.','https://lineagelogistics.com',false,false,15000, freeTier:'Institutional only', price:0, tips:'AI-powered thermal modeling | Reduce energy and waste | Food safety leader'),
    t('locus-robotics-ai','Locus Robotics','business','Leading warehouse automation using AI-powered collaborative robots.','https://locusrobotics.com',false,true,28000, freeTier:'Demo available', price:0, tips:'Increase pick rates by 300% | AI-powered swarm intelligence | Best for RaaS'),
    t('6-river-systems','6 River Systems (Ocado)','business','Collaborative warehouse robots and AI using "Chuck" for fulfillment.','https://6river.com',false,false,12000, freeTier:'Demo available', price:0, tips:'Acquired by Ocado (formerly Shopify) | AI-powered "Wall" sorting | Reliable'),

    // ━━━ AI FOR ARCHITECTURE & BIM v2 ━━━
    t('revit-ai-pro','Revit (Autodesk)','design','Leading BIM software with AI-powered generative design for architects.','https://autodesk.com/revit',false,true,150000, freeTier:'Free student version', price:335, priceTier:'Monthly subscription', tips:'Industry standard for architects | AI-powered structural analysis | Massive plugins'),
    t('archicad-ai-pro','Archicad','design','Leading BIM software focused on architectural design with AI help.','https://graphisoft.com',true,true,45000, freeTier:'Free for students/personal', price:240, priceTier:'Monthly subscription', tips:'Best for creative architects | AI-powered "AI Visualizer" | High performance'),
    t('sketchup-ai-pro','SketchUp (Lab)','design','Easy to use 3D modeling with new AI-powered "Diffusion" for rendering.','https://sketchup.com',true,true,250000, freeTier:'Free web version', price:29, priceTier:'Go plan monthly', tips:'The most popular 3D app | AI-powered text-to-render | Huge "3D Warehouse"'),
    t('vray-ai-render','V-Ray (Chaos)','design','World-class rendering engine with AI-powered "Enscape" and noise reduction.','https://chaos.com/vray',true,true,120000, freeTier:'Free trial available', price:77, priceTier:'Monthly subscription', tips:'Photorealistic gold standard | AI-powered denoising | Best for high-end visualization'),
    t('lumion-ai-pro','Lumion','design','The easiest and fastest architectural rendering software with AI tools.','https://lumion.com',false,true,84000, freeTier:'Free trial for 14 days', price:62, priceTier:'Standard monthly billed annual', tips:'Real-time rendering for architects | AI-powered "Ray Tracing" | Beautiful nature assets'),
    t('twinmotion-ai-pro','Twinmotion (Epic)','design','Real-time 3D visualization using Unreal Engine 5 with AI-powered lighting.','https://twinmotion.com',true,true,58000, freeTier:'Free for personal/education', price:0, tips:'Owned by Unreal | AI-powered people and cars | Best for landscape architects'),
    t('spacemaker-ai-pro','Spacemaker (Autodesk)','design','AI-powered site analysis and generative design for urban planners.','https://autodesk.com/spacemaker',false,true,25000, freeTier:'Forma (new name) free trial', price:0, tips:'Optimize for wind and sun with AI | Best for early stage design | High precision'),
    t('testfit-ai-pro','TestFit','design','Leading building configurator and site analysis tool using AI.','https://testfit.io',false,true,15000, freeTier:'Demo available', price:0, tips:'Fastest feasibility studies | AI-powered car parking and units | High performance'),
    t('giraffe-ai-pro','Giraffe','design','Collaborative urban design and feasibility platform with AI data.','https://giraffe.build',true,false,9200, freeTier:'Free basic version', price:0, tips:'Fastest site plans in the browser | AI-powered financial modeling | clean UI'),
    t('cove-tool-ai','cove.tool','design','AI-powered platform for sustainable building design and cost analysis.','https://cove.tools',false,true,12000, freeTier:'Demo available', price:0, tips:'Best for LEED and ESG projects | AI-powered energy modeling | Data-driven'),

    // ━━━ AI FOR LUXURY & FASHION v3 ━━━
    t('farfetch-ai-pro','FARFETCH','fashion','The global platform for luxury fashion with AI-powered visual search.','https://farfetch.com',true,true,500000, freeTier:'Free app for users', price:0, tips:'World\'s largest luxury selection | AI-powered "Complete the Look" | High end app'),
    t('net-a-porter-ai','NET-A-PORTER','fashion','Premier luxury fashion destination with AI-powered personal shopping.','https://net-a-porter.com',true,true,250000, freeTier:'Free app for users', price:0, tips:'Curated luxury experience | AI-powered guest styling | Best for high-end fashion'),
    t('saks-ai-pro','Saks Fifth Avenue','fashion','Leading luxury retailer using AI for personalized shopping and data.','https://saks.com',true,true,180000, freeTier:'Free app for users', price:0, tips:'Personalized by your style | AI-powered recommendation engine | Iconic luxury'),
    t('neiman-marcus-ai','Neiman Marcus','fashion','Luxury retail leader using AI for customer engagement and digital styling.','https://neimanmarcus.com',true,true,150000, freeTier:'Free app for users', price:0, tips:'AI-powered "NM Assist" | High-end personal service | Robust data integration'),
    t('the-realreal-ai','The RealReal','fashion','The world\'s largest online luxury resale using AI for authentication.','https://therealreal.com',true,true,120000, freeTier:'Free app for users', price:0, tips:'AI-powered "Vision" for spotting fakes | Best for circular fashion | High trust'),
    t('vestiaire-ai-pro','Vestiaire Collective','fashion','Leading global marketplace for pre-loved luxury with AI authentication.','https://vestiairecollective.com',true,true,84000, freeTier:'Free app for users', price:0, tips:'European luxury leader | AI-powered price predictor | Global community'),
    t('stock-x-ai-pro','StockX','fashion','Secondary marketplace for sneakers and apparel with AI market data.','https://stockx.com',true,true,999999, freeTier:'Free app for users', price:0, tips:'Real-time market pricing like a stock exchange | AI-powered authentication | Fast'),
    t('goat-ai-pro','GOAT','fashion','The global platform for the greatest products with AI-powered verify tech.','https://goat.com',true,true,500000, freeTier:'Free app for users', price:0, tips:'Highly curated sneakers and luxury | AI-powered "GOAT Clean" | Top tier UI'),
    t('poshmark-ai-pro','Poshmark','fashion','Social marketplace for new and used fashion with AI-powered Posh Lens.','https://poshmark.com',true,true,999999, freeTier:'Free app for users', price:0, tips:'Largest social fashion community | AI-powered image search | Easy to sell'),
    t('depop-ai-pro','Depop','fashion','The fashion marketplace where the next generation buys and sells with AI.','https://depop.com',true,true,250000, freeTier:'Free app for users', price:0, tips:'Owned by Etsy | Best for vintage and street wear | AI-powered "For You"'),

    // ━━━ FINAL GEMS v5 (Rising Stars) ━━━
    t('heygen-ai-pro','HeyGen','video','Leading AI video generator for creating professional spokespeople.','https://heygen.com',true,true,150000, freeTier:'1 free credit for trial', price:24, priceTier:'Creator monthly', tips:'Best for corporate training and ads | AI-powered video translation | Realistic avatars'),
    t('synthesia-ai-pro','Synthesia','video','The #1 AI video creation platform for enterprise teams.','https://synthesia.io',true,true,180000, freeTier:'Free basic video online', price:22, priceTier:'Starter monthly', tips:'100+ AI avatars | AI-powered video templates | World class performance'),
    t('runway-gen-3','Runway Gen-3 (Alpha)','video','High-end generative video model for creators and artists from Runway.','https://runwayml.com',true,true,250000, freeTier:'Free basic credits to start', price:12, priceTier:'Standard monthly', tips:'Best for visual effects and art | AI-powered motion brush | Industry leader'),
    t('pika-labs-video','Pika Labs','video','Fast AI video generation platform for creators and social-first workflows.','https://pika.art',true,true,180000, freeTier:'Free starter generations', price:10, priceTier:'Standard monthly', tips:'Quick text-to-video generation | Strong creator community | Reliable brand assets'),
    t('pi-ai-assistant','Pi (Inflection)','productivity','An AI with personality - designed to be your personal, caring assistant.','https://pi.ai',true,true,500000, freeTier:'Completely free for everyone', price:0, tips:'Best for long conversations | High EQ and empathy | Built by Google/MS experts'),
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
      final respBody = await utf8.decodeStream(resp);
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        uploaded += batch.length;
        print('OK $uploaded/${tools.length}');
      } else {
        print('FAIL at $i [${resp.statusCode}]: $respBody');
      }
    } catch (e) {
      print('ERR at $i: $e');
    }
  }

  client.close();
  print('DONE! Uploaded $uploaded tools with full pricing data');
}
