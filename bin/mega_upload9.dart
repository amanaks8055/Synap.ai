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
    // ━━━ ENTERTAINMENT & STREAMING (Advanced) ━━━
    t('netflix-ai','Netflix','entertainment','The world\'s leading streaming service with AI-powered content personalization.','https://netflix.com',false,true,1000000, freeTier:'No free trial', price:7, priceTier:'Standard with ads monthly', tips:'Best recommendation engine | Offline downloads | Profiles for all family'),
    t('disney-plus-ai','Disney+','entertainment','Streaming home for Disney, Marvel, Star Wars, and Pixar with AI curation.','https://disneyplus.com',false,true,850000, freeTier:'No free trial', price:8, priceTier:'Basic with ads monthly', tips:'4K streaming included in many plans | Download for offline | GroupWatch feature'),
    t('amazon-prime-video','Prime Video','entertainment','Amazon\'s streaming service with AI-powered X-Ray for actor and music info.','https://amazon.com/prime-video',true,true,750000, freeTier:'30-day free trial', price:15, priceTier:'Included in Prime membership', tips:'X-Ray feature is unmatched | Watch parties included | Integrated with shopping'),
    t('spotify-ai-dj','Spotify AI DJ','audio','Personalized AI DJ that talks to you and plays music based on your taste.','https://spotify.com',true,true,500000, freeTier:'Free with ads', price:11, priceTier:'Individual Premium monthly', tips:'Personalized DJ voice | Curated daily mixes | Higher quality audio for Premium'),
    t('apple-music-ai','Apple Music','audio','High-quality music streaming with AI-powered lyrics and discovery.','https://music.apple.com',false,true,400000, freeTier:'1-month free trial', price:11, priceTier:'Individual monthly', tips:'Lossless and Spatial audio | Human-curated playlists | Native Apple ecosystem'),

    // ━━━ GAMING (Tools & Mods) ━━━
    t('nexus-mods-ai','Nexus Mods','gaming','The largest community for game mods with AI-powered search and curation.','https://nexusmods.com',true,true,92000, freeTier:'Free to download and use', price:0, tips:'Best for Skyrim/Fallout modding | Vortex mod manager | Support creators directly'),
    t('curseforge-ai','CurseForge','gaming','Official platform for Minecraft, WoW, and Sims mods with AI safety.','https://curseforge.com',true,true,84000, freeTier:'Completely free for users', price:0, tips:'One-click modpack installation | Automatic updates | Trusted by millions'),
    t('overwolf-ai','Overwolf','gaming','App platform for gamers to build and use in-game overlays with AI integrations.','https://overwolf.com',true,false,45000, freeTier:'Free with ads', price:0, tips:'Best for LoL/Valorant/CoD stats | Real-time game data | Many community mods'),
    t('faceit-ai','FACEIT','gaming','Leading platform for competitive gaming with AI-powered anti-cheat.','https://faceit.com',true,true,38000, freeTier:'Free basic matchmaking', price:10, priceTier:'Premium: priority and stats', tips:'Best for competitive CS2 | Advanced anti-cheat | Earn real prizes'),
    t('roblox-studio-ai','Roblox Studio AI','gaming','AI-powered creation environment for building Roblox experiences.','https://create.roblox.com',true,true,54000, freeTier:'Completely free to build', price:0, tips:'Generate Luau code with AI | Fast asset creation | Global multiplayer hosting built-in'),

    // ━━━ FOOD & LIFESTYLE ━━━
    t('hellofresh-ai','HelloFresh','food','Meal kit delivery service using AI to predict and manage inventory.','https://hellofresh.com',false,true,15000, freeTier:'Trial discount for new users', price:8, priceTier:'Per serving starting price', tips:'Fresh ingredients and easy recipes | Flexible delivery | No food waste'),
    t('blue-apron-ai','Blue Apron','food','Premium meal kit service with AI-curated chef-designed recipes.','https://blueapron.com',false,false,12000, freeTier:'Trial discount available', price:9, priceTier:'Per serving starting price', tips:'High-quality ingredients | Wine pairing options | Great for beginners'),
    t('instacart-ai','Instacart','food','AI-powered grocery delivery service with smart replacement suggestions.','https://instacart.com',true,true,45000, freeTier:'Free delivery on first order', price:0, tips:'AI suggests replacements for out-of-stock items | Shop multiple stores at once | Real-time shopper chat'),
    t('doordash-ai','DoorDash','food','Food delivery platform with AI for route optimization and discovery.','https://doordash.com',true,true,78000, freeTier:'Free app for users', price:10, priceTier:'DashPass for free delivery', tips:'AI recommends local favorites | Group order feature | DashPass often pays for itself'),
    t('ubereats-ai','Uber Eats','food','AI-powered food and grocery delivery from local restaurants.','https://ubereats.com',true,true,82000, freeTier:'Free app for users', price:10, priceTier:'Uber One for free delivery and discounts', tips:'Integrated with Uber app | Real-time tracking | Large restaurant selection'),

    // ━━━ ECOMMERCE & SHOPPING ━━━
    t('amazon-shopping','Amazon AI Shopping','ecommerce','The world\'s largest online retailer with AI-powered recommendations.','https://amazon.com',true,true,2000000, freeTier:'Free to browse', price:15, priceTier:'Prime membership benefits', tips:'AI product summaries | "Buy again" predictions | Prime for fast delivery'),
    t('ebay-ai','eBay','ecommerce','Online auction and shopping platform with AI-powered image search.','https://ebay.com',true,true,150000, freeTier:'Free to browse', price:0, tips:'Best for used items and collectibles | AI helps price listings | Image search for deals'),
    t('etsy-ai','Etsy','ecommerce','Marketplace for handmade and vintage items with AI personalization.','https://etsy.com',true,true,120000, freeTier:'Free to browse', price:0, tips:'Support small creators | AI helps find unique gifts | Large vintage collection'),
    t('temu-ai','Temu','ecommerce','Fast-growing global retail platform with AI-driven inventory management.','https://temu.com',true,false,450000, freeTier:'Free app for all', price:0, tips:'Ultra-cheap prices | Free shipping on most items | Huge variety of products'),
    t('aliexpress-ai','AliExpress','ecommerce','Global online retail service with AI-driven translation and logistics.','https://aliexpress.com',true,false,380000, freeTier:'Free to browse', price:0, tips:'Factory prices on small items | Coins for discounts | Global shipping on everything'),

    // ━━━ TRAVEL & HOTELS (Niche) ━━━
    t('hotels-com-ai','Hotels.com','travel','Hotel booking platform with AI-powered loyalty reward system.','https://hotels.com',true,true,15000, freeTier:'Free to use', price:0, tips:'Earn one night free for every 10 | One Key rewards across Expedia | Best for recurring travelers'),
    t('agoda-ai','Agoda','travel','Travel platform specialized in Asian markets with AI for flight/hotel combos.','https://agoda.com',true,true,12000, freeTier:'Free to use', price:0, tips:'Lowest prices in SE Asia | PointsMAX loyalty | Great app deals'),
    t('skyscanner-ai','Skyscanner','travel','Global flight and hotel meta-search engine with AI price alerts.','https://skyscanner.com',true,true,18000, freeTier:'Free search engine', price:0, tips:'"Everywhere" search for inspiration | Best for multi-city trips | Price alerts experts'),
    t('hopper-ai','Hopper','travel','AI-powered travel app that predicts flight and hotel prices with 95% accuracy.','https://hopper.com',true,true,7200, freeTier:'Free app for all', price:0, tips:'Price predictions (wait vs buy) | "Price Freeze" feature | Mobile-only deals'),
    t('rome2rio-ai','Rome2Rio','travel','AI multi-modal travel search engine for air, train, bus, and ferry.','https://rome2rio.com',true,false,3600, freeTier:'Free search engine', price:0, tips:'See every way to get from A to B | Includes local buses and ferries | Estimated costs included'),

    // ━━━ PRODUCTIVITY (Misc) ━━━
    t('evernote-ai','Evernote (Ai Edit)','productivity','The original note-taking app with new AI-powered editing and cleanup.','https://evernote.com',true,true,18000, freeTier:'Free for up to 50 notes', price:14, priceTier:'Personal monthly unlimited', tips:'Best for scanning paper | AI clean up notes | Powerful cross-device sync'),
    t('zoho-ai','Zoho One (Zia)','productivity','Unified operating system for business with Zia AI assistant.','https://zoho.com',true,true,15000, freeTier:'Free for up to 10 users basic', price:37, priceTier:'All-in-one per employee monthly', tips:'Zia AI handles data and Q&A | 40+ apps in one suite | Best for established SMBs'),
    t('canva-magic','Canva Magic Studio','design','AI-powered design suite within Canva for instant image/video creation.','https://canva.com',true,true,250000, freeTier:'Free forever basic', price:12, priceTier:'Pro: all premium content and AI', tips:'Magic Eraser and Expand | Text to Image generator | Best for non-designers'),
    t('figma-ai','Figma AI','design','Collaborative design tool with AI for prototyping and component generation.','https://figma.com',true,true,120000, freeTier:'Free for 3 files', price:12, priceTier:'Professional per editor monthly', tips:'The industry standard for UI/UX | AI Dev Mode | Real-time collaboration'),
    t('miro-ai','Miro Assist','design','Visual collaboration platform with AI for mind maps and brainstorming.','https://miro.com',true,true,84000, freeTier:'Free for 3 boards', price:8, priceTier:'Starter per member monthly', tips:'AI summarizes sticky notes | Generate mind maps instantly | Best for remote workshops'),

    // ━━━ CYBER SECURITY (Tools) ━━━
    t('norton-ai','Norton 360 AI','security','Leading antivirus with AI-powered threat detection and VPN.','https://norton.com',false,true,15000, freeTier:'30-day free trial', price:30, priceTier:'Standard annual price', tips:'Real-time malware protection | Identity theft insurance | Cloud backup included'),
    t('mcafee-ai','McAfee+ AI','security','Personalised protection for your digital life with AI scam detection.','https://mcafee.com',false,false,12000, freeTier:'30-day free trial', price:40, priceTier:'Individual annual price', tips:'AI Text Scam Detector | VPN included | Multi-device protection'),
    t('bitdefender-ai','Bitdefender','security','High-performance security software with advanced AI threat defense.','https://bitdefender.com',true,true,9200, freeTier:'Free basic antivirus for Windows', price:30, priceTier:'Total Security annual', tips:'Consistently top rated for protection | Minimal impact on performance | Privacy focus'),
    t('kaspersky-ai','Kaspersky AI','security','Advanced endpoint protection using machine learning for threat detection.','https://kaspersky.com',true,false,8400, freeTier:'Free basic tools', price:25, priceTier:'Standard annual price', tips:'Excellent ransomware protection | Low resource usage | Global threat net'),
    t('malwarebytes-ai','Malwarebytes','security','AI-driven malware removal and protection for home and business.','https://malwarebytes.com',true,true,15000, freeTier:'Free for cleanup/scanning', price:5, priceTier:'Premium: real-time protection', tips:'Best for removing existing infections | Simple and fast | Browser Guard is free'),

    // ━━━ FINANCE & BANKING (Tools) ━━━
    t('revolut-ai','Revolut','finance','Global neobank with AI-powered fraud detection and budgeting tools.','https://revolut.com',true,true,120000, freeTier:'Free basic account', price:0, tips:'Instant currency exchange | AI handles fraud in real-time | Great for travel'),
    t('wise-ai','Wise','finance','The cheapest way to send money internationally using AI for mid-market rates.','https://wise.com',true,true,150000, freeTier:'Free to join', price:0, tips:'Real mid-market exchange rates | Fastest international transfers | Multi-currency card'),
    t('chime-ai','Chime','finance','Fee-free banking app with AI-powered direct deposit and savings.','https://chime.com',true,true,84000, freeTier:'Completely fee-free', price:0, tips:'Get paid up to 2 days early | SpotMe overdraft protection | No hidden fees'),
    t('sofi-ai','SoFi','finance','All-in-one personal finance platform with AI-powered financial planning.','https://sofi.com',true,true,62000, freeTier:'Free to join', price:0, tips:'High yield savings | Investing and loans in one app | Member benefits like career coaching'),
    t('robinhood-ai','Robinhood','finance','Commission-free stock and crypto trading with AI-powered insights.','https://robinhood.com',true,true,150000, freeTier:'Completely fee-free trading', price:5, priceTier:'Gold: higher interest on cash', tips:'Simplest trading UI | IRA match available | 24/5 market access'),
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
