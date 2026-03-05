// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

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
  const supabaseUrl = 'https://ssemwzmwhlcfmzmrweuw.supabase.co';
  const anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNzZW13em13aGxjZm16bXJ3ZXV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIxNzkxMTcsImV4cCI6MjA4Nzc1NTExN30.QF9G86V2HxzMrnN37ENQkrY7L_m7LBuxa56tC5MoywA';
  final client = HttpClient();

  final tools = <Map<String, dynamic>>[
    // ━━━ AI FOR HOBBIES (Astronomy & Space v2) ━━━
    t('space-id-ai-pro','SpaceID','science','Identify celestial bodies and satellite tracks instantly using AI-powered visual data.','https://spaceid.com',true,false,15000, freeTier:'Free basic version', price:0, tips:'Best for amateur astronomers | AI-powered "Plate" solving | high accuracy'),
    t('astro-bin-ai-pro','AstroBin','science','Leading astrophotography hosting and data platform using AI-powered "Plate" solve.','https://astrobin.com',true,true,120000, freeTier:'Free for limited uploads', price:5, priceTier:'Premium monthly annual', tips:'The industry standard for astro imagers | AI-powered "Equipment" db | Iconic'),
    t('stell-arium-ai','Stellarium (Web AI)','science','The world\'s #1 planetarium software using AI-powered sky mapping and data logs.','https://stellarium-web.org',true,true,999999, freeTier:'Completely free open source', price:0, tips:'Best for learning the night sky | AI-powered "Sat" tracking | High reliability'),
    t('sky-safari-ai-pro','SkySafari','science','Leading star map app with AI-powered "Orbit" logic and telescope control.','https://skysafariastronomy.com',true,true,350000, freeTier:'Free trial for basic sky', price:15, priceTier:'Plus one-time purchase', tips:'Best for telescope control | AI-powered "History" | High trust'),
    t('light-poll-ai-pro','Light Pollution Map','science','Leading resource for dark sky finding using AI-powered "Bortle" and satellite logs.','https://lightpollutionmap.info',true,true,250000, freeTier:'Completely free forever', price:0, tips:'Find dark sky sites for astro | AI-powered "Overlay" | Essential for observers'),

    // ━━━ AI FOR HOBBIES (Wine & Spirits v2) ━━━
    t('vivino-ai-pro-wine','Vivino','lifestyle','The world\'s #1 wine app using AI to scan labels and provide professional ratings.','https://vivino.com',true,true,999999, freeTier:'Completely free app and scan', price:0, tips:'AI-powered "Label Scan" is elite | Best for wine lovers | Global reach'),
    t('de-lectable-ai','Delectable','lifestyle','Leading wine community app using AI for label recognition and expert logs.','https://delectable.com',true,true,350000, freeTier:'Free basic app for users', price:0, tips:'Owned by Vinous | AI-powered "Wine List" scanner | clean UI'),
    t('distiller-ai-pro','Distiller','lifestyle','The world\'s #1 spirits app using AI to recommend whiskey, gin, and rum.','https://distiller.com',true,true,250000, freeTier:'Free forever basic version', price:5, priceTier:'Pro monthly annual', tips:'Best for whiskey nerds | AI-powered "Flavor" profile | high trust'),
    t('cellar-track-ai','CellarTracker','lifestyle','Leading wine cellar management with AI-powered valuation and inventory logs.','https://cellartracker.com',true,true,180000, freeTier:'Free for up to 100 bottles', price:20, priceTier:'Yearly donation suggested', tips:'The pro standard for tracking | AI-powered "Community" data | Highly robust'),
    t('wine-id-ai-pro-sci','WineID','lifestyle','Identify wine regions and vintages using AI-powered visual and climatic data.','https://wineid.com',true,false,15000, freeTier:'Free basic version', price:0, tips:'Best for collectors | AI-powered "Counterfeit" check | niche favorite'),

    // ━━━ AI FOR HOBBIES (Cooking & Recipes v3) ━━━
    t('chef-steps-ai-pro','ChefSteps','lifestyle','Leading molecular gastronomy and cooking tech with AI-powered tool help.','https://chefsteps.com',true,true,150000, freeTier:'Free basic recipes online', price:10, priceTier:'Studio monthly annual', tips:'Created by the Joule team | AI-powered "Visual" guides | High tech cooking'),
    t('pesto-ai-recipes','Pesto (AI)','lifestyle','The minimalist AI recipe manager that extracts ingredients from any URL.','https://pesto.app',true,true,84000, freeTier:'Free forever basic version', price:0, tips:'Fastest way to save recipes | AI-powered "Nutrition" calc | clean UI'),
    t('mobi-dish-ai-pro','MobiDish','lifestyle','Leading AI-powered meal planner focused on speed and ingredient reuse.','https://mobidish.com',true,false,45000, freeTier:'Free trial available', price:0, tips:'Best for busy families | AI-powered "Cart" sync | high quality'),
    t('recipe-id-ai-pro','RecipeID','lifestyle','Identify any dish from a photo and get a professional AI recipe match.','https://recipeid.com',true,false,58000, freeTier:'Free basic version', price:0, tips:'Best for foodies | AI-powered "Plating" help | reliable and fast'),
    t('whisk-ai-pro-sams','Samsung Food (Whisk)','lifestyle','Leading AI-powered food platform with social recipes and shopping lists.','https://samsungfood.com',true,true,500000, freeTier:'Completely free to use', price:0, tips:'Owned by Samsung | AI-powered "Meal Plan" | Global reach'),

    // ━━━ AI FOR NICHES (Paleontology & Geo v5) ━━━
    t('ammonite-id-ai','AmmoniteID','science','Identify ammonite and fossil shell species with AI-powered visual recognition.','https://ammoniteid.com',true,false,12000, freeTier:'Free basic version', price:0, tips:'Best for fossil hunters | AI-powered "Sutures" analysis | niche favorite'),
    t('trilo-bite-id-ai','TriloID','science','Identify trilobite species instantly using AI-powered morphological data.','https://triloid.com',true,false,8400, freeTier:'Free basic version', price:0, tips:'Best for serious collectors | AI-powered "Rarity" check | niche favorite'),
    t('rock-id-expert-ai','RockID (Expert Science)','science','Professional mineral identification using high-end AI labs and spectral data.','https://rockid.expert',true,false,15000, freeTier:'Free for research labs', price:0, tips:'High precision mineralogy | AI-powered "Crystal" search | high trust'),
    t('geo-map-ai-pro-uk','British Geol Survey (AI)','science','The official UK geology database with AI-powered map search and data.','https://bgs.ac.uk',true,true,120000, freeTier:'Completely free open data', price:0, tips:'The gold standard for UK rocks | AI-powered "Borehole" records | Iconic'),
    t('usgs-min-ai-pro','USGS Minerals (AI)','science','Leading global mineral resource database with AI-powered "Critical" data.','https://usgs.gov/minerals',true,true,350000, freeTier:'Completely free open data', price:0, tips:'Best for mining and policy | AI-powered "Cycle" maps | High impact'),

    // ━━━ AI FOR CRAFTS (Pottery & Ceramics v2) ━━━
    t('glaze-id-ai-pro','Glaze ID','lifestyle','Leading resource for potters using AI to predict kiln results and glaze.','https://glazeid.com',true,false,15000, freeTier:'Free basic archive', price:0, tips:'Best for ceramic artists | AI-powered "Recipe" matching | high trust'),
    t('pottery-craft-ai','Pottery Architect','lifestyle','AI-powered design and pattern help for hand-built and wheel pottery.','https://potteryarchitect.com',true,false,12000, freeTier:'Free basic designs', price:0, tips:'Best for studio artists | AI-powered "Coil" generator | creative'),
    t('kiln-ai-pro-logic','Kiln Logic','lifestyle','Professional software for kiln firing logs and AI-powered temperature help.','https://kilnlogic.com',true,false,8400, freeTier:'Free basic tracker', price:0, tips:'Best for consistency | AI-powered "Graph" prediction | high precision'),
    t('ceramic-art-ai','Ceramic Art (Digital)','lifestyle','Leading community and data platform for ceramic art history and data.','https://ceramicart.com',true,true,58000, freeTier:'Free basic resources', price:0, tips:'The official source for ceramic history | AI-powered "Search" | Iconic'),
    t('clay-id-ai-pro-sci','ClayID','lifestyle','Identify clay bodies and firing ranges instantly using AI-powered data.','https://clayid.com',true,false,18000, freeTier:'Free basic identification', price:0, tips:'Best for studio managers | AI-powered "Body" check | reliable'),

    // ━━━ AI FOR SPECIALIZED SPORTS (Fencing & Archery v2) ━━━
    t('fence-stats-ai-pro','Fencing Analytics','lifestyle','Leading data and strategy platform for professional fencing using AI.','https://fencinganalytics.com',false,false,15000, freeTier:'Institutional only', price:0, tips:'Used by Olympic teams | AI-powered "Touch" tracking | High end data'),
    t('archery-id-ai-pro','ArcheryID','lifestyle','Leading archery form and group tracking using AI-powered camera logs.','https://archeryid.com',true,false,12000, freeTier:'Free basic version', price:0, tips:'Best for target archers | AI-powered "Group" analysis | high precision'),
    t('coach-fence-ai-pro','CoachFence','lifestyle','Leading coaching platform for fencing with AI-powered drill generator.','https://coachfence.com',true,false,8400, freeTier:'Free basic version', price:0, tips:'Best for club coaches | AI-powered "Attack" training | Reliable'),
    t('bow-stats-ai-pro','BowStats','lifestyle','Leading archery statistics and world rankings using AI-powered match logs.','https://bowstats.com',true,true,35000, freeTier:'Free basic stats online', price:0, tips:'Best for competitive archers | AI-powered "Season" tracking | niche favorite'),
    t('fencing-world-data','FIE (Official Data)','lifestyle','The global FIE database with AI-powered live scores and world rankings.','https://fie.org',true,true,150000, freeTier:'Completely free open stats', price:0, tips:'The official source for pro fencing | AI-powered "Match Center" | Iconic'),

    // ━━━ FINAL GEMS v44 (Modern AI Research) ━━━
    t('consensus-ai-pro','Consensus','education','Leading AI search engine for scientific research that finds direct answers.','https://consensus.app',true,true,500000, freeTier:'Free trial with limited searches', price:10, priceTier:'Premium monthly annual', tips:'AI-powered "Summary" is high value | Best for evidence-based research'),
    t('elicit-ai-pro-sci','Elicit','education','The AI research assistant that automates literature reviews and data.','https://elicit.com',true,true,350000, freeTier:'Free trial for users', price:10, priceTier:'Plus monthly annual', tips:'Best for meta-analysis | AI-powered "Extraction" of data from PDFs'),
    t('research-rabbit-ai','ResearchRabbit','education','The world\'s #1 tool for mapping research papers and discovery with AI.','https://researchrabbit.ai',true,true,180000, freeTier:'Completely free forever', price:0, tips:'The "Spotify for Research" | AI-powered "Discovery" is incredible | clean UI'),
    t('scite-ai-pro-data','scite (AI)','education','Leading platform for checking if research is supported or challenged.','https://scite.ai',true,true,250000, freeTier:'7-day free trial on site', price:20, priceTier:'Premium monthly annual', tips:'Best for citation context | AI-powered "Smart Citations" | high trust'),
    t('semantic-scholar-ai','Semantic Scholar (AI)','education','The world\'s most cited AI-powered search for scientific literature.','https://semanticscholar.org',true,true,999999, freeTier:'Completely free forever', price:0, tips:'Owned by Allen Institute | AI-powered "TLDRs" | The global gold standard'),
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
