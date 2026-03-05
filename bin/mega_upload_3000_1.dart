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
    // ━━━ AI FOR TRAVEL & TOURISM v2 ━━━
    t('tripadvisor-ai-pro','Tripadvisor','lifestyle','Leading travel platform with AI-powered reviews and itinerary help.','https://tripadvisor.com',true,true,999999, freeTier:'Completely free to use', price:0, tips:'AI-powered review summaries | Best for local recommendations | Huge community'),
    t('expedia-ai-travel','Expedia (AI)','lifestyle','Leading travel giant using AI for flight tracking and hotel matching.','https://expedia.com',true,true,500000, freeTier:'Free app for users', price:0, tips:'AI-powered "Price Tracking" | One-stop shop for travel | Reliable and fast'),
    t('booking-ai-travel','Booking.com','lifestyle','The world\'s largest travel site using AI for personalized hotel deals.','https://booking.com',true,true,999999, freeTier:'Free app for users', price:0, tips:'AI-powered "Genius" program | Largest selection of hotels | Global scale'),
    t('kayak-ai-search','KAYAK','lifestyle','Leading travel search engine using AI for flight price prediction.','https://kayak.com',true,true,350000, freeTier:'Completely free to search', price:0, tips:'AI-powered "Price Forecast" | Comparison across hundreds of sites | clean UI'),
    t('skyscanner-ai-pro','Skyscanner','lifestyle','Leading global travel marketplace using AI to find the cheapest flights.','https://skyscanner.net',true,true,250000, freeTier:'Completely free to use', price:0, tips:'AI-powered "Search Everywhere" | Best for budget travelers | Global database'),
    t('hopper-ai-travel','Hopper','lifestyle','The #1 mobile-first travel app using AI to predict and freeze prices.','https://hopper.com',true,true,180000, freeTier:'Free app for users', price:0, tips:'AI-powered price freeze | Best for Gen Z and Millennial travelers | fast'),
    t('traila-ai-travel','Traila','lifestyle','AI-powered travel planning platform that builds custom itineraries in seconds.','https://traila.com',true,false,4500, freeTier:'Free basic plan', price:10, priceTier:'Premium monthly', tips:'Best for unique road trips | AI-powered route optimization | Modern tech'),
    t('roam-around-ai','Roam Around','lifestyle','Interactive AI travel planner that builds full day plans for any city.','https://roamaround.io',true,false,9200, freeTier:'Completely free to use', price:0, tips:'Built on ChatGPT | Fast and simple itineraries | Shared by users'),
    t('guided-ai-travel','Guided.at','lifestyle','AI-powered audio guide and city tour platform for travelers.','https://guided.at',true,false,3500, freeTier:'Free basic guides', price:0, tips:'Listen to history while you walk | AI-powered narratives | Global coverage'),
    t('way-ai-travel','WAY','lifestyle','AI-powered group travel planning and expense tracking for friends.','https://way.io',true,false,5600, freeTier:'Free basic app', price:0, tips:'Split bills with AI | Shared maps and itineraries | Social focus'),

    // ━━━ AI FOR PETS & ANIMALS v2 ━━━
    t('pet-cube-ai-cam','Petcube','lifestyle','Smart cameras for pets with AI-powered bark and vet alerts.','https://petcube.com',false,true,45000, freeTier:'Hardware purchase required', price:5, priceTier:'Care monthly', tips:'AI recognizes cats and dogs | Remote laser toy control | Vet chat built-in'),
    t('furbo-ai-cam','Furbo','lifestyle','The #1 dog camera with AI-powered treat tossing and alerts.','https://furbo.com',false,true,58000, freeTier:'Hardware purchase required', price:7, priceTier:'Nanny monthly', tips:'AI detects dog crying and barking | Best for dog parents | High reliability'),
    t('whistle-ai-pet','Whistle','lifestyle','Leading smart tracker for pets with AI-powered health monitoring.','https://whistle.com',false,true,35000, freeTier:'Hardware purchase required', price:10, priceTier:'Subscription monthly', tips:'AI detects scratching and licking | Track fitness and location | Secure'),
    t('fi-smart-collar','Fi','lifestyle','Leading smart dog collar with AI-powered activity tracking and LTE.','https://tryfi.com',false,true,28000, freeTier:'Hardware purchase required', price:19, priceTier:'Series 3 monthly subscription', tips:'Longest battery life | AI-powered "Escape" alerts | Sleek and durable'),
    t('tractive-ai-pet','Tractive','lifestyle','Global leader in GPS tracking for cats and dogs with AI health data.','https://tractive.com',false,true,84000, freeTier:'Hardware purchase required', price:5, priceTier:'Basic monthly annual', tips:'Real-time GPS tracking | AI-powered sleep tracking | European leader'),
    t('basepaws-ai-pet','Basepaws','health','Leading digital pet health platform with AI-powered DNA testing.','https://basepaws.com',true,true,15000, freeTier:'Free health score quiz', price:99, priceTier:'Breed + Health kit once', tips:'Owned by Zoetis | AI-powered dental health reports | Best for cat parents'),
    t('embark-ai-pet','Embark Vet','health','The world\'s most accurate dog DNA test using AI for breed and health.','https://embarkvet.com',false,true,25000, freeTier:'No free tier', price:129, priceTier:'Breed + Health kit once', tips:'In partnership with Cornell University | AI-powered genetic data | Highly trusted'),
    t('wis-panel-ai','Wisdom Panel','health','Leading pet DNA service with AI-powered ancestry and traits data.','https://wisdompanel.com',false,false,12000, freeTier:'No free tier', price:0, tips:'Part of Mars Petcare | AI-powered "Relative" finders | Huge database'),
    t('pet-coach-ai','PetCoach (Petco)','health','Expert pet advice platform using AI and verified vets online.','https://petcoach.co',true,true,120000, freeTier:'Completely free for users', price:0, tips:'Powered by Petco | AI-powered "Symptom" checker | Reliable and fast'),
    t('vet-ai-pro-care','Joii (Vet-AI)','health','Leading veterinary app using AI to diagnose pet health at home.','https://vet-ai.com',true,false,9200, freeTier:'Free health checks available', price:20, priceTier:'Consultation starting', tips:'UK based and high tech | AI-powered "Symptom" triage | Remote vet clinics'),

    // ━━━ AI FOR REAL ESTATE v3 (Global) ━━━
    t('zillow-ai-pro','Zillow (AI)','business','Leading real estate marketplace with AI-powered "Zestimate" and tours.','https://zillow.com',true,true,999999, freeTier:'Completely free to browse', price:0, tips:'AI-powered 3D home tours | Best for home search in US | Huge data scale'),
    t('redfin-ai-pro','Redfin','business','Modern real estate brokerage using AI to find the best home deals.','https://redfin.com',true,true,500000, freeTier:'Completely free to browse', price:0, tips:'AI-powered "Hot Home" alerts | Verified listing data | Save on commissions'),
    t('realtor-ai-pro','Realtor.com','business','Leading source for real estate listings with AI-powered neighborhoods.','https://realtor.com',true,true,350000, freeTier:'Completely free to use', price:0, tips:'Official site of NAR | AI-powered school data | Reliable and accurate'),
    t('trulia-ai-neighborhood','Trulia','business','Visual neighborhood search with AI-powered local insights and ratings.','https://trulia.com',true,true,250000, freeTier:'Completely free for the public', price:0, tips:'Best for "Vibe" search | AI-powered crime and school heatmaps | Part of Zillow'),
    t('compass-ai-pro','Compass','business','Leading real estate platform for agents with AI-powered "Collections".','https://compass.com',true,true,120000, freeTier:'Free to browse listings', price:0, tips:'Best for high-end luxury | AI-powered price recommendation | Top tier UI'),
    t('rightmove-ai-pro','Rightmove','business','The UK\'s largest property portal with AI-powered valuation tools.','https://rightmove.co.uk',true,true,500000, freeTier:'Completely free to browse', price:0, tips:'The gold standard for UK property | AI-powered location search | Huge database'),
    t('zoopla-ai-pro','Zoopla','business','Leading UK property site with AI-powered "Smart Valuation" and data.','https://zoopla.co.uk',true,true,250000, freeTier:'Completely free to use', price:0, tips:'AI-powered commute time search | Best for house price research | High trust'),
    t('real-estate-jp-ai','Real Estate Japan','business','Leading portal for foreigners in Japan using AI for translation and help.','https://realestate.co.jp',true,false,45000, freeTier:'Completely free for users', price:0, tips:'Best for expats | AI-powered "Gaijin" friendly filters | Reliable'),
    t('99-acres-ai-pro','99acres','business','India\'s leading real estate platform with AI-powered price trends.','https://99acres.com',true,true,180000, freeTier:'Completely free for users', price:0, tips:'Largest database in India | AI-powered "Verified" listings | Global trust'),
    t('magic-bricks-ai','Magicbricks','business','Leading property portal in India with AI-powered home loans and data.','https://magicbricks.com',true,true,150000, freeTier:'Completely free for users', price:0, tips:'Best for new projects | AI-powered "Smart Search" | High social engagement'),

    // ━━━ AI FOR GAMING & METAVERSE v3 ━━━
    t('roblox-ai-pro','Roblox (AI)','entertainment','Leading gaming platform with new AI-powered code and asset help.','https://roblox.com',true,true,999999, freeTier:'Completely free to play', price:0, tips:'AI-powered "Assistant" for devs | Billions of user creations | Social first'),
    t('unity-muse-ai','Unity Muse','code','Leading game engine suite using AI to accelerate 3D development.','https://unity.com/muse',true,true,120000, freeTier:'30-day free trial on site', price:30, priceTier:'Muse plan monthly', tips:'AI generates textures and animations | Integrated into Unity editor | Pro quality'),
    t('unreal-engine-ai','Unreal Engine (AI)','code','World\'s most advanced game engine with AI-powered humanoids and physics.','https://unrealengine.com',true,true,500000, freeTier:'Free until \$1M revenue', price:0, tips:'AI-powered "MetaHumans" | Photorealistic gold standard | Cinematic focus'),
    t('nvidia-ace-ai','NVIDIA ACE','code','Leading platform for AI-powered digital humans with speech and logic.','https://nvidia.com/ace',false,true,84000, freeTier:'Institutional/Dev only', price:0, tips:'AI-powered NPCs that talk back | Built on Audio2Face | Next-gen gaming'),
    t('in-world-ai-pro','Inworld AI','code','Leading platform for AI-powered game characters and narrative design.','https://inworld.ai',true,true,45000, freeTier:'Free basic version for dev', price:20, priceTier:'Pro monthly base', tips:'Best for RPG game devs | AI with memory and emotion | High performance'),
    t('convai-ai-pro','Convai','code','AI-powered platform for conversational NPCs in VR and gaming.','https://convai.com',true,true,35000, freeTier:'Free basic version for dev', price:25, priceTier:'Starter monthly', tips:'Best for VR/AR immersion | Low latency talk | Integrated with Unity/Unreal'),
    t('the-sandbox-ai','The Sandbox','entertainment','Leading decentralized metaverse using AI for voxel building and games.','https://sandbox.game',true,true,120000, freeTier:'Free to join and explore', price:0, tips:'Owned by Animoca | AI-powered "Game Maker" | Vibrant creator economy'),
    t('decentraland-ai','Decentraland','entertainment','Open-source virtual world using AI for decentralized moderation.','https://decentraland.org',true,true,84000, freeTier:'Completely free for the public', price:0, tips:'DAO governed | AI-powered "Scenes" | First major social metaverse'),
    t('ready-player-me','Ready Player Me','entertainment','Cross-game avatar platform with AI-powered photo-to-avatar tech.','https://readyplayer.me',true,true,150000, freeTier:'Completely free for everyone', price:0, tips:'One avatar for 10,000+ apps | AI-powered visual matching | Best for VR'),
    t('v-central-ai-pro','VRChat','entertainment','Leading social VR platform with AI-powered moderation and user tools.','https://vrchat.com',true,true,500000, freeTier:'Completely free to use', price:10, priceTier:'Plus monthly', tips:'Best for virtual social life | Cross-platform (Quest/PC) | Massive community'),

    // ━━━ FINAL GEMS v11 (AI Agents & LLMs) ━━━
    t('agency-sw-ai-pro','Agency Swarm','code','Leading framework for building autonomous AI agent swarms at scale.','https://github.com/VRSEN/agency-swarm',true,true,25000, freeTier:'Completely free open source', price:0, tips:'Best for complex workflows | AI-powered agents talk to each other | Python native'),
    t('auto-gpt-ai-pro','AutoGPT','code','The pioneer in autonomous AI agents that achieve goals without help.','https://autogpt.org',true,true,500000, freeTier:'Completely free open source', price:0, tips:'Most viral AI agent | AI-powered web browsing and memory | Cutting edge'),
    t('baby-agi-ai-pro','BabyAGI','code','Leading minimalist framework for task-driven autonomous AI agents.','https://github.com/yoheinakajima/babyagi',true,true,150000, freeTier:'Completely free open source', price:0, tips:'Best for learning agent logic | AI-powered prioritization | Simple and fast'),
    t('super-agi-ai-pro','SuperAGI','code','Leading enterprise agent infrastructure for building and deploying AI.','https://superagi.com',true,true,45000, freeTier:'Free cloud tier for individuals', price:30, priceTier:'Pro monthly base', tips:'Managed agents for business | AI-powered toolkits | Robust and stable'),
    t('crew-ai-pro-dev','CrewAI','code','Leading framework for orchestrating role-playing AI agents.','https://crewai.com',true,true,58000, freeTier:'Completely free open source', price:0, tips:'Best for multi-agent workflows | AI-powered "Manager" agents | Python native'),
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
