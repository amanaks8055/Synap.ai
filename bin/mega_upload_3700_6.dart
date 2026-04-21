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
    // ━━━ AI FOR VIDEO EDITING (Iconic) ━━━
    t('da-vinci-ai-pro','DaVinci Resolve','video','The world\'s #1 color grading and editing software with high-end AI "Neural Engine".','https://blackmagicdesign.com',true,true,999999, freeTier:'Free version is incredibly powerful', price:295, priceTier:'Studio one-time purchase', tips:'AI-powered "Magic Mask" and "Voice Isolation" | Best for professional film | PC/Mac/Linux'),
    t('final-cut-ai-pro','Final Cut Pro','video','Apple’s professional video editor with AI-powered "Magnetic" timeline and mask.','https://apple.com/final-cut-pro',true,true,500000, freeTier:'90-day free trial on site', price:299, priceTier:'One-time purchase license', tips:'AI-powered "Smart Conform" | Best for Mac users | blazing fast on M-series chips'),
    t('adobe-premiere-ai','Adobe Premiere Pro','video','Industry standard video editing with AI-powered "Text-Based Editing" and color.','https://adobe.com/premiere',true,true,999999, freeTier:'7-day free trial on site', price:21, priceTier:'Creative Cloud monthly starting', tips:'AI-powered "Enhance Speech" is magic | Best for all workflows | Robust and modular'),
    t('after-effects-ai','Adobe After Effects','video','Leading motion graphics and VFX with AI-powered "Roto Brush" and fill.','https://adobe.com/after-effects',true,true,500000, freeTier:'7-day free trial on site', price:21, priceTier:'Creative Cloud monthly annual', tips:'AI-powered "Generative Fill" for video | Best for SFX artists | Industry standard'),
    t('cap-cut-ai-pro-vid','CapCut','video','The world\'s #1 mobile video editor with AI-powered "Autocut" and templates.','https://capcut.com',true,true,999999, freeTier:'Free basic version available', price:8, priceTier:'Pro monthly starting', tips:'Owned by ByteDance | AI-powered "Subtitles" | Best for TikTok and Reels'),
    t('luma-fusion-ai','LumaFusion','video','Pro-grade video editing for iPad and Android with AI-powered performance.','https://luma-touch.com',false,true,180000, freeTier:'No free tier', price:30, priceTier:'One-time purchase', tips:'Apple App of the Year | AI-powered "Multicam" | Best for mobile pro editors'),
    t('filmora-ai-pro-vid','Filmora','video','Easy and powerful video editor with AI-powered "Copilot" and smart masking.','https://filmora.wondershare.com',true,true,500000, freeTier:'Free version with watermark', price:20, priceTier:'Subscription monthly starting', tips:'AI-powered "Text to Video" | Best for beginners and social | modern UI'),
    t('clip-champ-ai-pro','Clipchamp (Microsoft)','video','Microsoft\'s web-based video editor with AI-powered "Auto-Composer" help.','https://clipchamp.com',true,true,350000, freeTier:'Free forever basic version', price:12, priceTier:'Premium monthly', tips:'Best for Windows users | AI-powered "Text to Speech" | simple and fast'),
    t('vegas-pro-ai-pro','VEGAS Pro','video','Leading PC video editor with AI-powered colorization and upscaling.','https://vegascreativesoftware.com',true,true,120000, freeTier:'30-day free trial on site', price:20, priceTier:'Subscription monthly starting', tips:'Legendary PC editor | AI-powered "Smart Mask" | high performance'),
    t('avid-media-ai-pro','Avid Media Composer','video','The gold standard for Hollywood film and TV editing with AI-powered bin.','https://avid.com',true,true,84000, freeTier:'Free "First" version available', price:24, priceTier:'Subscription monthly starting', tips:'Used by almost every Oscar winner | AI-powered "ScriptSync" | Enterprise scale'),

    // ━━━ AI FOR HOCKEY & SKATING ━━━
    t('nhl-ai-edge-data','NHL Edge','entertainment','Official NHL data platform using AI and sensors for real-time tracking.','https://nhl.com/edge',true,true,350000, freeTier:'Completely free open stats', price:0, tips:'AI-powered "Puck" and "Player" tracking | Best for hockey fans | official'),
    t('hockey-viz-ai-pro','HockeyViz','entertainment','Leading hockey visualization platform using AI for offensive and defensive help.','https://hockeyviz.com',true,true,58000, freeTier:'Free basic visuals online', price:5, priceTier:'Supporter monthly', tips:'Best for analytics nerds | AI-powered "Threat" maps | high trust'),
    t('skate-line-ai-pro','SkateLine','lifestyle','AI-powered app for tracking and improving your skating technique and speed.','https://skateline.com',true,false,12000, freeTier:'Free basic version', price:0, tips:'Best for inline and quad skaters | AI-powered "Form" check | Niche'),
    t('hockey-tracker-ai','HockeyTracker (Apple)','health','Leading Apple Watch app for tracking hockey stats and heart data with AI.','https://hockeytrackerapp.com',true,true,84000, freeTier:'Free trial available', price:5, priceTier:'Pro monthly', tips:'Best for beer league players | AI-powered "Calories" and "Speed" | Reliable'),
    t('skate-dice-ai-pro','Skate Dice','lifestyle','Leading trick generator for skateboarders with AI-powered difficulty.','https://skatedice.com',true,true,45000, freeTier:'Free basic version available', price:2, priceTier:'Pro one-time', tips:'Best for playing SKATE | AI-powered "Trick" picker | huge community focus'),

    // ━━━ AI FOR KETTLEBELL & CALISTHENICS ━━━
    t('then-x-ai-pro-cali','Thenx','health','Leading calisthenics training app with AI-powered daily workouts.','https://thenx.com',true,true,350000, freeTier:'Free basic version available', price:10, priceTier:'Pro monthly', tips:'Founded by Chris Heria | AI-powered "Progression" | Best for bodyweight'),
    t('cali-move-ai-pro','Calimove','health','Professional calisthenics programs using AI-powered "Phase" tracking.','https://calimove.com',false,true,84000, freeTier:'No free tier', price:60, priceTier:'Program one-time', tips:'German engineering for fitness | AI-powered "Skill" tree | high quality'),
    t('free-letics-ai-pro','Freeletics','health','Leading AI-powered fitness coach for bodyweight and equipment training.','https://freeletics.com',true,true,999999, freeTier:'Free basic version available', price:15, priceTier:'Coach monthly', tips:'The pioneer in AI fitness | AI-powered "Coach" adapts mid-session | Huge community'),
    t('kettlebell-ai-pro','Kettlebell Kings (App)','health','Leading kettlebell training platform with AI-powered workout generators.','https://kettlebellkings.com',true,false,45000, freeTier:'Free app and basic tips', price:0, tips:'Best for specific KB skills | AI-powered "Weight" advice | High trust'),
    t('strong-app-ai-pro','Strong (App)','health','The simplest and cleanest workout tracker using AI for plate calculation.','https://strong.app',true,true,500000, freeTier:'Free for up to 3 routines', price:5, priceTier:'Pro monthly annual', tips:'Cleanest UI in fitness | AI-powered "Warm-up" sets | Industry favorite'),

    // ━━━ AI FOR MINUTE SCIENCE (Malacology & Fungi v3) ━━━
    t('mushroom-observer','Mushroom Observer','science','Leading collaborative mycology database with AI-powered sorting.','https://mushroomobserver.org',true,true,84000, freeTier:'Completely free forever', price:0, tips:'Access 500k+ observations | AI-powered "Search" | Best for serious mycology'),
    t('myco-key-ai-pro','MycoKey','science','Leading professional tool for identifying fungi using AI and deep keys.','https://mycokey.org',true,true,12000, freeTier:'Free online version', price:0, tips:'Based in Denmark | AI-powered "Synoptic" keys | Academic standard'),
    t('shell-id-ai-pro-sci','ShellID','science','Identify seashells instantly using AI-powered visual recognition and data.','https://shellid.com',true,false,15000, freeTier:'Free basic identification', price:0, tips:'Best for malacologists | AI-powered "Spiral" analysis | high trust'),
    t('sea-shell-data-ai','SeaShell (Digital)','science','Global database of world seashells with AI-powered geographical maps.','https://seashells.com',true,true,35000, freeTier:'Completely free open data', price:0, tips:'Identify rare shells with AI | Best for collectors | High quality images'),
    t('fungi-finder-ai','Fungi ID (Digital)','science','Leading community driven fungi identification using AI and expert check.','https://fungiid.com',true,false,18000, freeTier:'Free basic version', price:0, tips:'Best for temperate forests | AI-powered "Habitat" alerts | reliable'),

    // ━━━ AI FOR CRAFTS (Bookbinding & Enameling) ━━━
    t('book-binding-ai','Bookbinding (Digital)','lifestyle','Leading resource for hand bookbinders using AI to archive techniques.','https://bookbinding.net',true,false,15000, freeTier:'Completely free forever', price:0, tips:'Best for leather workers | AI-powered "Folder" search | high trust'),
    t('guild-of-binders','Guild of Book Workers','lifestyle','Professional guild for book arts with AI-powered digital archives.','https://guildofbookworkers.org',true,true,12000, freeTier:'Free limited content', price:0, tips:'The American standard for book arts | AI-powered "Newsletter" | High trust'),
    t('glass-blow-ai-pro','Glassblowing (Digital)','lifestyle','Leading resource for glass artists using AI to track kiln cycles.','https://glassblowing.org',true,false,15000, freeTier:'Free community forum', price:0, tips:'Best for studio artists | AI-powered "Annealing" calc | High tech'),
    t('ename-ling-ai-pro','Enameling Soc (Digital)','lifestyle','Leading resource for metal enameling with AI-powered color data.','https://enamelistsociety.org',true,false,8400, freeTier:'Free basic resources', price:0, tips:'The Enamelist Society portal | AI-powered "Workshop" search | Niche'),
    t('stained-glass-pro-id','Stained Glass Assn','lifestyle','Official association for stained glass with AI-powered heritage maps.','https://stainedglass.org',true,true,35000, freeTier:'Completely free public content', price:0, tips:'Access historical glass data | AI-powered "Studio" directory | high trust'),

    // ━━━ FINAL GEMS v32 (Modern AI Agents) ━━━
    t('hyper-write-ai-pro','HyperWrite','productivity','The strongest AI personal assistant that can browse and use apps for you.','https://hyperwriteai.com',true,true,120000, freeTier:'Free basic version available', price:20, priceTier:'Premium monthly', tips:'AI-powered "Personal Assistant" is incredible | Best for web tasks | High tech'),
    t('lind-y-ai-pro-agent','Lindy','productivity','Leading AI agent for work that can handle meetings, emails, and sync.','https://lindy.ai',true,true,84000, freeTier:'Free beta access available', price:0, tips:'Best for busy executives | AI-powered "Executive Assistant" | modern UI'),
    t('multi-on-ai-pro-br','MultiOn','productivity','Leading AI browsing agent that can book flights, shop, and more.','https://multion.ai',true,true,58000, freeTier:'Free developer credits', price:20, priceTier:'Pro monthly', tips:'Best for automated web tasks | AI-powered "Browser" control | Revolutionary'),
    t('induced-ai-pro-ops','Induced AI','business','Leading browser-native AI workers for back-office and operations.','https://induced.ai',false,true,35000, freeTier:'Institutional only', price:0, tips:'Best for high volume data tasks | AI-powered "Workflow" | High security'),
    t('agent-ops-ai-pro','AgentOps','code','Leading platform for building and monitoring AI agents and LLM flows.','https://agentops.ai',true,true,45000, freeTier:'Free for up to 100 sessions', price:0, tips:'Best for engineering teams | AI-powered "Observability" | high reliability'),
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
