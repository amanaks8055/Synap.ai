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
    // ━━━ AI FOR FITNESS & WORKOUT v2 ━━━
    t('peloton-ai-pro','Peloton','health','The world\'s #1 connected fitness app with AI-powered "Auto-Resistance".','https://onepeloton.com',true,true,999999, freeTier:'Free basic classes in app', price:13, priceTier:'App One monthly', tips:'AI-powered "Form Assist" for bike | Best instructor variety | Large community'),
    t('strava-ai-pro','Strava','health','Leading platform for runners and cyclists with AI-powered "Beacon" and data.','https://strava.com',true,true,999999, freeTier:'Free basic version', price:12, priceTier:'Subscription monthly', tips:'Best for competitive athletes | AI-powered "Route" builder | Global segments'),
    t('nike-training-ai','Nike Training Club','health','World-class training app with AI-powered personalized workout plans.','https://nike.com/ntc',true,true,500000, freeTier:'Completely free to use', price:0, tips:'Industry standard for free home workouts | AI-powered "Coach" | Clean UI'),
    t('fitbod-ai-workout','Fitbod','health','AI-powered strength training app that builds custom workouts daily.','https://fitbod.me',true,true,250000, freeTier:'3 free workouts to start', price:13, priceTier:'Premium monthly', tips:'AI calculates your relative strength | Best for weight lifters | Fast progress'),
    t('whoop-ai-coach','WHOOP','health','Leading fitness and recovery wearable with AI-powered "Coach" assistant.','https://whoop.com',false,true,180000, freeTier:'Hardware purchase required', price:30, priceTier:'Monthly membership', tips:'AI provides real-time training advice | Best for recovery data | Pro standard'),
    t('future-fitness-ai','Future','health','Personal training app that connects you with real coaches using AI help.','https://future.co',false,true,84000, freeTier:'7-day free trial on site', price:149, priceTier:'Digital monthly', tips:'Best for elite results | Real coach + AI tracking | High motivation'),
    t('my-fitness-pal','MyFitnessPal (AI)','health','Leading nutrition and calorie tracker with AI-powered barcode scan.','https://myfitnesspal.com',true,true,999999, freeTier:'Free basic version for users', price:20, priceTier:'Premium monthly', tips:'Largest food database | AI-powered "Recipe" discovery | Most popular'),
    t('lose-it-ai-pro','Lose It!','health','Simple and effective weight loss app with AI-powered image food logging.','https://loseit.com',true,true,350000, freeTier:'Free basic version', price:4, priceTier:'Premium monthly annual', tips:'Snap a photo to log food with AI | Fast and easy | High success rate'),
    t('noom-ai-pro','Noom','health','Psychology-based weight loss with AI-powered health coaching.','https://noom.com',true,true,250000, freeTier:'Free basic quiz and plan', price:70, priceTier:'Monthly starting', tips:'Focus on habit change with AI | Best for long-term health | Science-based'),
    t('weight-watchers-ai','WeightWatchers (WW)','health','Leading weight management platform with AI-powered "Points" system.','https://weightwatchers.com',true,true,500000, freeTier:'Free basic version for users', price:23, priceTier:'Core monthly starting', tips:'Proven physical/digital system | AI-powered "Sleep" tracker | iconic'),

    // ━━━ AI FOR NUTRITION & RECIPES v2 ━━━
    t('platejoy-ai-pro','PlateJoy','health','Personalized meal planning based on your health goals and data with AI.','https://platejoy.com',true,false,45000, freeTier:'10-day free trial', price:8, priceTier:'Monthly billed semi-annual', tips:'Curated by nutritionists and AI | Reduce food waste | Best for keto/paleo'),
    t('mealime-ai-pro','Mealime','health','Simple and fast meal planning for busy people using AI for recipes.','https://mealime.com',true,true,120000, freeTier:'Free basic version', price:3, priceTier:'Pro monthly', tips:'Shop for groceries in one click | AI-powered "Avoid" filters | Clean design'),
    t('forks-over-knives','Forks Over Knives','health','Plant-based meal planning app using AI for healthy vegan recipes.','https://forksoverknives.com',true,false,84000, freeTier:'7-day free trial', price:10, priceTier:'Monthly billed annual', tips:'Based on the world-famous doc | AI-powered "Shopping List" | High trust'),
    t('samsung-food-ai','Samsung Food','health','The "Next-Gen" food app with AI-powered recipe saving and smart ovens.','https://samsungfood.com',true,true,250000, freeTier:'Completely free for users', price:0, tips:'Formerly Whisk | AI-powered "Nutrition" data | Best for smart families'),
    t('paprika-recipe-ai','Paprika Recipe Manager','lifestyle','Professional recipe organizer with AI-powered web scraping.','https://paprikaapp.com',false,true,58000, freeTier:'No free tier', price:5, priceTier:'One-time purchase mobile', tips:'The gold standard for recipe saving | AI-powered "Cloud Sync" | Robust and fast'),
    t('copy-me-that-ai','Copy Me That','lifestyle','Leading web recipe scraper with AI-powered meal planning and shopping.','https://copymethat.com',true,false,35000, freeTier:'Completely free basic version', price:0, tips:'Unlimited recipe saving | AI-powered "Sync" | Best for home cooks'),
    t('big-oven-ai-pro','BigOven','lifestyle','Massive recipe database with AI-powered meal planning and data.','https://bigoven.com',true,false,150000, freeTier:'Free basic version', price:3, priceTier:'Pro monthly annual', tips:'1M+ recipes | AI-powered "Leftover" search | Established since 2004'),
    t('all-recipes-ai','AllRecipes','lifestyle','The world\'s largest social food community using AI for recommendations.','https://allrecipes.com',true,true,999999, freeTier:'Completely free to use', price:0, tips:'User-reviewed recipes | AI-powered "Personalized" feed | huge database'),
    t('food-network-ai','Food Network (Kitchen)','lifestyle','Cook with your favorite chefs using AI-powered live and on-demand classes.','https://foodnetwork.com',true,true,350000, freeTier:'Free basic recipes', price:5, priceTier:'Premium monthly', tips:'Live cooking classes | AI-powered "Step-by-Step" | Premium production'),
    t('cook-pad-ai-pro','Cookpad','lifestyle','Leading global social recipe sharing platform using AI for discovery.','https://cookpad.com',true,true,180000, freeTier:'Free basic version', price:0, tips:'Best for unique world recipes | AI-powered "Popular" search | Global community'),

    // ━━━ AI FOR PUBLISHING & LIBRARIES ━━━
    t('kindle-ai-reader','Amazon Kindle (AI)','entertainment','Leading e-reader platform with AI-powered "X-Ray" and help.','https://amazon.com/kindle',true,true,999999, freeTier:'Free app for users', price:0, tips:'AI-powered "X-Ray" for characters | Massive ebook library | Seamless sync'),
    t('audible-ai-pro','Audible (AI)','entertainment','World\'s largest audiobook platform using AI for personalized discovery.','https://audible.com',true,true,999999, freeTier:'1-month free trial', price:15, priceTier:'Premium Plus monthly', tips:'AI-powered "Narrator" highlights | Originals and podcasts | Global leader'),
    t('good-reads-ai-pro','Goodreads','entertainment','Leading social network for book fans with AI-powered "For You" lists.','https://goodreads.com',true,true,500000, freeTier:'Completely free to use', price:0, tips:'Track Every book you read | AI-powered "Choice" awards | Owned by Amazon'),
    t('story-graph-ai','The StoryGraph','entertainment','Modern Goodreads alternative using AI for mood and pace matching.','https://thestorygraph.com',true,true,120000, freeTier:'Completely free for the public', price:5, priceTier:'Plus monthly', tips:'AI-powered "Mood" search | Best for serious readers | Data-rich views'),
    t('libby-ai-library','Libby (OverDrive)','lifestyle','The easiest way to borrow ebooks and audiobooks for free using AI.','https://overdrive.com/apps/libby',true,true,250000, freeTier:'Completely free with library card', price:0, tips:'Best for legal free books | AI-powered "Recommend" | Integrated with Kindle'),
    t('scribd-ai-pro','Scribd (Everand)','entertainment','The "Netflix for books" using AI for unlimited reading and data.','https://scribd.com',true,true,180000, freeTier:'30-day free trial on site', price:12, priceTier:'Standard monthly', tips:'Unlimited ebooks and audiobooks | AI-powered "Everand" feed | Robust'),
    t('medium-ai-read','Medium','marketing','Leading platform for high-quality writing with AI-powered "Topic" news.','https://medium.com',true,true,999999, freeTier:'Limited free stories monthly', price:5, priceTier:'Member monthly', tips:'Best for tech and business news | AI-powered personalized feed | Minimalist'),
    t('substack-ai-pro','Substack','marketing','Leading newsletter platform using AI for recommendation and help.','https://substack.com',true,true,500000, freeTier:'Free to join and follow', price:0, tips:'Direct writer support | AI-powered "Notes" | Fast growing community'),
    t('watt-pad-ai-pro','Wattpad','entertainment','Leading social storytelling platform using AI for discovery and data.','https://wattpad.com',true,true,350000, freeTier:'Free basic version with ads', price:6, priceTier:'Premium monthly', tips:'Home of amateur novelists | AI-powered "Story" scoring | Massive Gen Z reach'),
    t('archive-pro-ai','Internet Archive (IA)','science','The non-profit library of everything with AI-powered digitization.','https://archive.org',true,true,999999, freeTier:'Completely free forever', price:0, tips:'Access 40M+ books and files | AI-powered "Wayback Machine" | Essential'),

    // ━━━ AI FOR ESPORTS & PRO GAMING ━━━
    t('mobalytics-ai','Mobalytics','entertainment','Leading AI coach for LoL, Valorant, and other competitive games.','https://mobalytics.gg',true,true,180000, freeTier:'Free basic analytics', price:5, priceTier:'Plus monthly', tips:'AI calculates your "Gamer Identity" | Pro level map insights | High trust'),
    t('blitz-ai-gaming','Blitz.gg','entertainment','Leading game companion app using AI for real-time item and skill builds.','https://blitz.gg',true,true,250000, freeTier:'Completely free with ads', price:4, priceTier:'Pro monthly', tips:'AI-powered auto-import for builds | Best for League of Legends | Fast'),
    t('tracker-net-ai','Tracker Network','entertainment','Leading stats platform for Fortnite, Valorant, and more with AI.','https://tracker.gg',true,true,500000, freeTier:'Completely free for users', price:0, tips:'Real-time leaderboard data | AI-powered "Match" history | Industry leader'),
    t('overwolf-ai-pro','Overwolf','entertainment','Leading framework for building in-game apps using AI and data.','https://overwolf.com',true,true,350000, freeTier:'Completely free to use', price:0, tips:'Powering 100k+ mods and apps | AI-powered overlays | Safe and secure'),
    t('face-it-ai-pro','FACEIT','entertainment','Leading competitive platform for CS2 and more with AI anti-cheat.','https://faceit.com',true,true,180000, freeTier:'Free basic version available', price:10, priceTier:'Premium monthly', tips:'AI-powered "Minerva" anti-toxicity | Best for serious gamers | Global'),
    t('esea-ai-pro','ESEA','entertainment','Professional league for Counter-Strike using AI for high-end play.','https://esea.net',false,false,45000, freeTier:'Institutional only', price:7, priceTier:'Premium monthly', tips:'Industry standard for pros | AI-powered matchmaking | Elite community'),
    t('gosu-ai-coach','GOSU.AI','entertainment','AI-powered coach and assistant for Dota 2 and other MOBA games.','https://gosu.ai',true,false,58000, freeTier:'Free basic analysis', price:0, tips:'Improve your MOBA skills with AI | Data-driven tips | easy to follow'),
    t('senp-ai-coach','Senp.AI','entertainment','Leading AI coach for League of Legends with deep mechanical data.','https://senp.ai',true,false,35000, freeTier:'Free basic version', price:0, tips:'High-end champion specific tips | AI-powered itemization | Pro focus'),
    t('meta-fy-ai-pro','Metafy','entertainment','Learn from the world\'s best pro gamers with AI-powered coaching help.','https://metafy.gg',true,true,84000, freeTier:'Free to browse coaches', price:0, tips:'Direct access to pros | AI-powered "Curriculum" | High quality focus'),
    t('gamers-rdy-ai','GamersRdy','entertainment','Leading marketplace for gaming coaches with AI-powered skill growth.','https://gamersrdy.com',true,false,25000, freeTier:'Free resources online', price:0, tips:'Best for Rocket League and FPS | AI-powered "Playbook" | verified coaches'),

    // ━━━ FINAL GEMS v14 (Modern Web Dev) ━━━
    t('convex-ai-pro','Convex','code','The full-stack TypeScript backend for developers with AI-powered sync.','https://convex.dev',true,true,84000, freeTier:'Free for up to 10k users', price:25, priceTier:'Pro monthly base', tips:'Best for real-time apps | AI-powered "Functions" | Replacement for Firebase'),
    t('neon-ai-pro','Neon','code','Serverless Postgres platform with AI-powered scaling and autosave.','https://neon.tech',true,true,58000, freeTier:'Free forever basic tier', price:0, tips:'Best for Next.js and serverless | AI-powered "Branching" | Scalable'),
    t('p-scale-ai-pro','PlanetScale','code','High-performance serverless MySQL with AI-powered schema management.','https://planetscale.com',true,true,45000, freeTier:'Free trial for new users', price:29, priceTier:'Scaler monthly base', tips:'The gold standard for database scale | AI-powered "Rewind" | Industry leader'),
    t('upstash-ai-pro','Upstash','code','Serverless Redis and Kafka with AI-powered vector capabilities for devs.','https://upstash.com',true,true,35000, freeTier:'Free forever basic tier', price:0, tips:'Best for edge computing | AI-powered "Vector" storage | Very cheap and fast'),
    t('sanity-ai-cms','Sanity','marketing','Leading headless CMS with AI-powered content and image generation.','https://sanity.io',true,true,84000, freeTier:'Free forever for individuals', price:15, priceTier:'Growth monthly per seat', tips:'The industry standard for pros | AI-powered "Content Lake" | Fully customizable'),
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
