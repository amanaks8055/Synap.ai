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
    // ━━━ AI FOR LONGEVITY & BIOHACKING ━━━
    t('inside-tracker-ai','InsideTracker','health','Leading platform that analyzes your blood data using AI for longevity.','https://insidetracker.com',false,true,150000, freeTier:'No free tier', price:189, priceTier:'Blood kit once', tips:'Best for science-based biohacking | AI-powered "InnerAge" | High trust'),
    t('levels-ai-health','Levels Health','health','Metabolic health platform using AI and CGMs to track glucose in real-time.','https://levelshealth.com',false,true,120000, freeTier:'Consult required', price:199, priceTier:'Yearly membership', tips:'Best for metabolic optimization | AI-powered "Food" scores | Silicon Valley favorite'),
    t('viome-ai-health','Viome','health','Leading gut health and microbiome platform using AI for dietary plans.','https://viome.com',false,true,84000, freeTier:'No free tier', price:129, priceTier:'Gut Intelligence kit once', tips:'AI-powered "Precision Supplements" | Best for gut health | Robust data'),
    t('nutri-sense-ai','NutriSense','health','Leading metabolic health assistant with AI-powered CGM tracking and diet.','https://nutrisense.io',false,true,58000, freeTier:'Consult required', price:160, priceTier:'Monthly starting', tips:'Best for weight loss and energy | AI-powered "Nutritionist" help | precise'),
    t('zoe-ai-nutrition','ZOE','health','World\'s largest nutrition study using AI to personalize your eating.','https://joinzoe.com',false,true,150000, freeTier:'14-day free trial', price:35, priceTier:'Monthly membership', tips:'Founded by Tim Spector | AI-powered "Sugar/Fat" tests | Science leader'),
    t('fountain-life-ai','Fountain Life','health','Advanced longevity centers using AI-powered full body scans and data.','https://fountainlife.com',false,true,15000, freeTier:'Institutional only', price:0, tips:'The ultimate longevity experience | AI-powered MRI and diagnostics | Luxury'),
    t('blue-zones-ai','Blue Zones (Digital)','health','Longevity wisdom and courses based on the world\'s oldest people with AI.','https://bluezones.com',true,true,250000, freeTier:'Free basic articles and recipes', price:0, tips:'Learn ancient longevity secrets | AI-powered "Vibe" check | Iconic brand'),
    t('human-longevity-ai','Human Longevity (HLI)','health','Pioneering genomics and longevity platform with high-end AI labs.','https://humanlongevity.com',false,false,12000, freeTier:'No free tier', price:0, tips:'Founded by Craig Venter | AI-powered "Health Nucleus" | Elite focus'),
    t('longevity-vision-ai','Longevity Vision Fund','business','Leading investment fund for longevity tech with AI-powered trend data.','https://lvf.vc',false,false,8400, freeTier:'Institutional only', price:0, tips:'Led by Sergey Young | AI-powered "Future of Aging" data | Strategic'),
    t('rejuvenation-ai','Rejuvenation (Digital)','health','AI-powered platform for tracking your biological clock and longevity.','https://rejuvenation.ai',true,false,12000, freeTier:'Free basic calculator', price:0, tips:'Find your biological age with AI | Evidence based | Fast and clean'),

    // ━━━ AI FOR WINE, SPIRITS & COFFEE ━━━
    t('vivino-ai-wine','Vivino','lifestyle','The world\'s #1 wine app using AI for labeling and personalized ratings.','https://vivino.com',true,true,999999, freeTier:'Completely free for users', price:0, tips:'Snap a photo of any label | AI-powered "Taste Profile" | Largest wine community'),
    t('delectable-ai-wine','Delectable','lifestyle','Leading wine social app with AI-powered label recognition and data.','https://delectable.com',true,true,180000, freeTier:'Completely free to use', price:0, tips:'Best for rare and fine wines | AI-powered "Critic" scores | High trust'),
    t('hello-vino-ai','HelloVino','lifestyle','Leading AI-powered wine recommendation assistant for food pairing.','https://hellovino.com',true,false,58000, freeTier:'Free basic version', price:0, tips:'Best at the grocery store | AI-powered "Pairing" logic | Fast and easy'),
    t('distiller-ai-pro','Distiller','lifestyle','Leading spirits recommendation platform with AI-powered flavor data.','https://distiller.com',true,true,250000, freeTier:'Completely free to use', price:10, priceTier:'Premium monthly', tips:'Best for Whiskey and Gin | AI-powered "Expert" reviews | Global trust'),
    t('untappd-ai-beer','Untappd','lifestyle','The world\'s #1 beer social app with AI-powered "Nearby" and ratings.','https://untappd.com',true,true,500000, freeTier:'Completely free for users', price:0, tips:'Track Every beer you drink | AI-powered "Badges" | Huge global community'),
    t('brew-foundry-ai','Brewfoundry','lifestyle','AI-powered companion for homebrewers and craft beer fans.','https://brewfoundry.com',true,false,12000, freeTier:'Free basic version', price:0, tips:'AI-powered "Recipe" balancing | Best for makers | Clean design'),
    t('coffee-review-ai','Coffee Review','lifestyle','Leading guide to the world\'s best coffees with AI-powered tasting data.','https://coffeereview.com',true,true,84000, freeTier:'Completely free to read', price:0, tips:'The gold standard for coffee scores | AI-powered "Search" | Pro level'),
    t('fellow-ai-coffee','Fellow (Digital)','lifestyle','High-end coffee gear brand with AI-powered brewing guides and data.','https://fellowproducts.com',true,true,58000, freeTier:'Free app for users', price:0, tips:'AI-powered "Grind" settings | Best for specialty coffee | Premium design'),
    t('behmor-ai-roaster','Behmor (Connected)','lifestyle','Smart coffee roaster with AI-powered profiles for home hobbyists.','https://behmor.com',false,false,15000, freeTier:'Hardware purchase required', price:0, tips:'Roast your own beans with AI | Precise temperature control | Pro sumer'),
    t('coffee-guide-ai','Coffee Guide (Specialty)','lifestyle','Leading specialty coffee data platform using AI for sourcing.','https://sca.coffee',true,false,45000, freeTier:'Free to browse basics', price:0, tips:'Official Specialty Coffee Assn | AI-powered "Standards" | Industry leader'),

    // ━━━ AI FOR NICHE SCIENCE (Deep Data) ━━━
    t('ocean-data-ai','Ocean Data Alliance','science','Global platform using AI to monitor ocean health and marine data.','https://oceandataalliance.org',true,true,12000, freeTier:'Completely free for research', price:0, tips:'AI-powered "Marine" mapping | Best for environmentalists | Global'),
    t('global-fishing-watch','Global Fishing Watch (AI)','science','Using satellite data and AI to track global fishing and sustainability.','https://globalfishingwatch.org',true,true,35000, freeTier:'Completely free for the public', price:0, tips:'Backed by Google and Leo DiCaprio | AI-powered vessel tracking | High trust'),
    t('earth-engine-ai','Google Earth Engine','science','A planetary-scale platform for environmental data analysis with AI.','https://earthengine.google.com',true,true,150000, freeTier:'Free for research and education', price:0, tips:'Most powerful earth data tool | AI-powered satellite analysis | Essential for sci'),
    t('planet-ai-pro-sat','Planet (AI)','science','Satellite imagery provider using AI to track daily changes on earth.','https://planet.com',false,true,84000, freeTier:'Limited access for researchers', price:0, tips:'Scan the entire world daily with AI | AI-powered "Object" detection | Pro standard'),
    t('maxar-ai-pro-sat','Maxar (AI)','science','Global leader in high-res satellite imagery and AI geospatial info.','https://maxar.com',false,true,45000, freeTier:'Institutional only', price:0, tips:'Used by military and gov | AI-powered "Deep Intelligence" | Global scale'),
    t('descartes-labs-ai','Descartes Labs','science','Data refinery platform using AI to analyze physical systems on earth.','https://descarteslabs.com',false,false,25000, freeTier:'Institutional only', price:0, tips:'Best for supply chain and ag | AI-powered "Geo" insights | high technology'),
    t('orbital-insight','Orbital Insight','science','Using AI and computer vision to analyze satellite and geodata at scale.','https://orbitalinsight.com',false,false,18000, freeTier:'Institutional only', price:0, tips:'AI-powered "GO" platform | Economic and social indicators | Global focus'),
    t('spire-ai-pro-sat','Spire Global','science','Space-to-cloud data company using AI for weather and sea tracking.','https://spire.com',false,false,15000, freeTier:'Institutional only', price:0, tips:'Best for maritime and aviation | AI-powered "AIS" data | Innovative'),
    t('black-sky-ai-pro','BlackSky','science','Real-time space-based intelligence using AI to track global events.','https://blacksky.com',false,false,12000, freeTier:'Institutional only', price:0, tips:'AI-powered "Spectra" platform | fastest event response | highly secure'),
    t('capella-space-ai','Capella Space','science','SAR (Radar) imagery from space using AI to see through clouds and night.','https://capellaspace.com',false,true,28000, freeTier:'Institutional only', price:0, tips:'Best for all-weather monitoring | AI-powered radar data | revolutionary'),

    // ━━━ AI FOR LUXURY SHOPPING & FASHION ━━━
    t('farfetch-ai-pro','Farfetch (AI)','lifestyle','Leading luxury marketplace with AI-powered "Personal" dressing and data.','https://farfetch.com',true,true,500000, freeTier:'Completely free to use', price:0, tips:'AI-powered "Inspiration" feed | Best for high-end fashion | Global supply'),
    t('mytheresa-ai-pro','Mytheresa','lifestyle','Curated luxury fashion with AI-powered "VIP" notifications and help.','https://mytheresa.com',true,true,350000, freeTier:'Completely free to browse', price:0, tips:'Best for designer edits | AI-powered "Size" recommendations | Premium UI'),
    t('net-a-porter-ai','NET-A-PORTER','lifestyle','The "Incredible" luxury store with AI-powered "Style" advice and data.','https://net-a-porter.com',true,true,250000, freeTier:'Completely free for users', price:0, tips:'Leading editorial fashion | AI-powered "EIP" (Extremely Important Person) tools'),
    t('ssense-ai-pro-shop','SSENSE','lifestyle','Leading multi-brand luxury store with AI-powered mobile search and feed.','https://ssense.com',true,true,180000, freeTier:'Completely free to use', price:0, tips:'Best for street and avant-garde | AI-powered "Trending" | High intellectual UI'),
    t('grailed-ai-pro','Grailed','lifestyle','Leading marketplace for curated secondhand luxury with AI authentication.','https://grailed.com',true,true,250000, freeTier:'Free to join and browse', price:0, tips:'AI-powered "Digital" authentication | Best for hype and luxury | Huge community'),
    t('the-real-real-ai','The RealReal','lifestyle','Leading luxury resale platform with AI-powered valuation and check.','https://therealreal.com',true,true,180000, freeTier:'Completely free to browse', price:0, tips:'AI-powered "Consignment" calculator | Verified luxury only | High trust'),
    t('vestiaire-ai-pro','Vestiaire Collective','lifestyle','Global marketplace for luxury secondhand using AI for authentication.','https://vestiairecollective.com',true,true,120000, freeTier:'Completely free to use', price:0, tips:'Best European luxury resale | AI-powered "Price Match" | High security'),
    t('chrono-24-ai-pro','Chrono24','lifestyle','The world\'s #1 watch marketplace with AI-powered "Watch Scanner".','https://chrono24.com',true,true,250000, freeTier:'Completely free for the public', price:0, tips:'AI-powered "Watch Collection" value | Millions of listings | Best for pro collectors'),
    t('stock-x-ai-pro','StockX','lifestyle','Leading marketplace for sneakers and luxury with AI market data.','https://stockx.com',true,true,500000, freeTier:'Completely free to use', price:0, tips:'AI-powered "Market Value" tracking | 100% authentic focus | Global leader'),
    t('goat-ai-pro-shop','GOAT','lifestyle','Leading global platform for the greatest sneakers with AI verification.','https://goat.com',true,true,350000, freeTier:'Completely free to join', price:0, tips:'Best for rare kicks | AI-powered photo verification | High quality design'),

    // ━━━ FINAL GEMS v20 (Edge AI) ━━━
    t('edge-impulse-ai','Edge Impulse','code','Leading platform for building ML models for edge devices and AI.','https://edgeimpulse.com',true,true,58000, freeTier:'Free for individual developers', price:0, tips:'Best for embedded sensors | AI-powered "AutoML" for edge | Industry standard'),
    t('sima-ai-pro-tech','SiMa.ai','code','Machine learning SoC company focused on effortless AI for edge.','https://sima.ai',false,false,15000, freeTier:'Institutional only', price:0, tips:'Best for robot vision | AI-powered "one-click" deploy | High efficiency'),
    t('hailo-ai-pro-chip','Hailo','code','Leading provider of high-performance AI processors for edge devices.','https://hailo.ai',false,false,12000, freeTier:'Institutional only', price:0, tips:'Best for smart cameras | AI-powered "M.2" modules | European tech'),
    t('coral-ai-google','Coral (Google)','code','Google\'s platform for building on-device AI with specialized hardware.','https://coral.ai',true,true,84000, freeTier:'Free software and tools', price:0, tips:'Powered by Edge TPU | Best for local vision | Robust and easy to use'),
    t('luxonis-ai-pro','Luxonis (OAK)','code','Leading provider of spatial AI cameras and depth-sensing hardware.','https://luxonis.com',true,true,45000, freeTier:'Free SDKs and documentation', price:0, tips:'AI-powered "OAK-D" camera | Best for robotics | Multi-sensor integration'),
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
