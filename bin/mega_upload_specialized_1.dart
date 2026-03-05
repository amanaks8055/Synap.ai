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
    // ━━━ E-COMMERCE (Specialized) ━━━
    t('loox-ai','Loox','ecommerce','AI-powered product reviews and photos for Shopify stores.','https://loox.app',true,true,5400, freeTier:'14-day free trial', price:10, priceTier:'Beginner plan monthly', tips:'Best for visual reviews | AI-powered referrals | One-click import'),
    t('pagefly-ai','PageFly','ecommerce','AI-powered page builder for Shopify with conversion optimization.','https://pagefly.io',true,true,8200, freeTier:'Free forever basic', price:24, priceTier:'Pay-as-you-go starting', tips:'Drag-and-drop design | Optimized for speed | Huge library of templates'),
    t('shogun-ai','Shogun','ecommerce','Enterprise grade page builder with AI content generation for e-commerce.','https://getshogun.com',false,false,4200, freeTier:'10-day free trial', price:39, priceTier:'Build plan monthly', tips:'Best for larger stores | AI writing assistant | Comprehensive analytics'),
    t('okendo-ai','Okendo','ecommerce','Customer marketing platform with AI reviews and surveys for Shopify.','https://okendo.io',false,false,3600, freeTier:'Demo available', price:19, priceTier:'Essentials plan monthly', tips:'High conversion review widgets | Reward systems | Deep integration'),
    t('stamped-ai','Stamped','ecommerce','AI reviews and loyalty platform for e-commerce growth.','https://stamped.io',true,false,2800, freeTier:'Free up to 50 orders/month', price:19, priceTier:'Lite monthly', tips:'One platform for loyalty and reviews | AI sentiment analysis | Very fast'),

    // ━━━ EMAIL TECH (Specialized) ━━━
    t('superhuman-ai','Superhuman','productivity','The fastest email experience ever made, now with built-in AI.','https://superhuman.com',false,true,15000, freeTier:'1-month free trial (invite)', price:30, priceTier:'Individual monthly', tips:'Email writing assistant | Automated summaries | Fastest keyboard shortcuts'),
    t('hey-email-ai','HEY Email','productivity','Privacy-first email with AI "Happenings" and focus tools.','https://hey.com',false,false,8400, freeTier:'14-day free trial', price:12, priceTier:'Individual annual price', tips:'The "Imbox" for focus | No tracking pixels | AI organizes news'),
    t('canary-mail-ai','Canary Mail','productivity','Secure email client with AI "Copilot" for writing and managing inbox.','https://canarymail.io',true,true,6200, freeTier:'Free basic version', price:2, priceTier:'Pro: AI features and unlimited', tips:'PGP encryption built-in | AI detects scams | One-click unsubscribe'),
    t('shortwave-ai','Shortwave','productivity','AI-powered email assistant that organizes and summarizes your inbox.','https://shortwave.com',true,true,9200, freeTier:'Free basic version', price:9, priceTier:'Pro: unlimited history and AI', tips:'Best for Gmail power users | AI summarizes threads | Collaborative team inbox'),
    t('spark-email-ai','Spark','productivity','Intelligent email for teams with AI for drafting and prioritizing.','https://sparkmailapp.com',true,true,12000, freeTier:'Free for individuals', price:5, priceTier:'Premium: AI assistant and more', tips:'Cross-platform (Mac/iOS/Android) | Shared team inboxes | AI gatekeeper for spam'),

    // ━━━ DEVELOPER HELPERS (Specialized) ━━━
    t('regex-ai','RegEx AI','code','AI generator for complex regular expressions from natural language.','https://regex.ai',true,false,4800, freeTier:'Completely free online', price:0, tips:'Type what you want to match | Instant regex generation | Visual testing'),
    t('codetoflow-ai','CodeToFlow','code','AI tool that converts logic or code into beautiful flowcharts.','https://codetoflow.com',true,false,3400, freeTier:'Free for basic charts', price:10, priceTier:'Premium: more exports', tips:'Best for visualizing legacy code | One-click flowchart | Multiple formats'),
    t('sqlai-ai','SQLAI','code','AI SQL assistant for generating, optimizing, and explaining queries.','https://sqlai.ai',true,true,5600, freeTier:'Free daily queries', price:5, priceTier:'Pro: unlimited and datasets', tips:'Safe for production queries | Supports Snowflake and BigQuery | Explain feature'),
    t('json-to-gpt','JSON Hero','code','Beautiful JSON viewer with AI for understanding and navigating data.','https://jsonhero.io',true,true,4200, freeTier:'Completely free open source', price:0, tips:'Visualize API responses | Automatic type detection | Search inside JSON'),
    t('gitignore-ai','gitignore.io','code','AI-powered generator for .gitignore files across 100s of stacks.','https://toptal.com/developers/gitignore',true,false,15000, freeTier:'Completely free forever', price:0, tips:'Toptal developer tool | Simple CLI support | Keeps repos clean'),

    // ━━━ AUDIO & VOICE (More) ━━━
    t('murf-ai-more','Murf AI','audio','Leading AI voice generator with studio-quality narrations.','https://murf.ai',true,true,18000, freeTier:'Free trial with 10 mins', price:19, priceTier:'Basic plan monthly', tips:'120+ realistic voices | Sync with video | Commercial usage rights'),
    t('play-ht-more','Play.ht','audio','AI text-to-speech with high-quality voices and voice cloning.','https://play.ht',true,true,15000, freeTier:'Free for non-commercial', price:31, priceTier:'Creator plan monthly', tips:'Best for long-form content | Ultra-realistic voices | API support'),
    t('vocal-remover-ai','Vocal Remover','audio','AI tool that separates vocals from music in any audio file.','https://vocalremover.org',true,true,45000, freeTier:'Free with limits', price:0, tips:'Perfect for karaoke | Includes pitch shifting | Browser based'),
    t('moises-ai','Moises','audio','The musician\'s app with AI for track separation and practice.','https://moises.ai',true,true,25000, freeTier:'Free basic separation', price:4, priceTier:'Premium monthly', tips:'Separate drums, bass, and vocals | AI metronome | Pitch and speed control'),
    t('lalal-ai','LALAL.AI','audio','High-quality AI stem splitter for extracting vocals and instruments.','https://lalal.ai',true,false,18000, freeTier:'Free preview only', price:15, priceTier:'Starter: 90 mins audio', tips:'Professional grade separation | Fast processing | Desktop app available'),

    // ━━━ EDUCATION (Niche) ━━━
    t('anki-ai','Anki (AI Plugins)','education','Flashcard app with AI for automated card creation and scheduling.','https://apps.ankiweb.net',true,true,35000, freeTier:'Completely free desktop', price:0, tips:'Open source and powerful | Best for long-term retention | Huge plugin list'),
    t('memrise-companion','Memrise','education','Language learning with AI for real-world conversation practice.','https://memrise.com',true,false,15000, freeTier:'Free basic courses', price:8, priceTier:'Pro: ad-free and AI features', tips:'Real videos of locals | AI coach MemBot | Best for vocabulary'),
    t('anki-web-ai','AnkiWeb','education','The online companion to Anki for syncing flashcards across devices.','https://ankiweb.net',true,false,12000, freeTier:'Completely free forever', price:0, tips:'Sync all your cards | Browser based study | Very reliable'),
    t('tiny-cards','Tinycards (Duolingo)','education','Simple flashcards by Duolingo with AI for gamified learning.','https://tinycards.duolingo.com',true,false,8400, freeTier:'Retired (now in Duolingo)', price:0, tips:'Gamified study | Huge community decks | Now integrated into main app'),
    t('study-together-ai','Study Together','education','Global study community with AI-powered focus and group rooms.','https://studytogether.com',true,true,9200, freeTier:'Free to join and use', price:5, priceTier:'Support: ad-free and more stats', tips:'Study with thousands of people | AI focus timer | Track your study hours'),

    // ━━━ MARKETING (Niche) ━━━
    t('unbounce-ai','Unbounce (Smart Builder)','marketing','AI-powered landing page builder for maximizing conversions.','https://unbounce.com',false,true,8400, freeTier:'14-day free trial', price:99, priceTier:'Launch plan monthly', tips:'AI writes your copy | Smart Traffic routing | Best for PPC ads'),
    t('instapage-ai','Instapage','marketing','Enterprise grade landing page platform with AI for personalization.','https://instapage.com',false,false,5600, freeTier:'14-day free trial', price:199, priceTier:'Build plan monthly', tips:'Fastest loading pages | Heatmaps built-in | High team collaboration'),
    t('leadpages-ai','Leadpages','marketing','Landing page builder for small businesses with AI design tools.','https://leadpages.com',true,false,9200, freeTier:'14-day free trial', price:37, priceTier:'Standard monthly', tips:'Unlimited leads and traffic | Pop-ups and alert bars | Easy integration'),
    t('carrd-ai','Carrd','marketing','Simple, free, fully responsive one-page sites for anything.','https://carrd.co',true,true,45000, freeTier:'Free for up to 3 sites', price:9, priceTier:'Pro: custom domains per year', tips:'Cheapest way to build a landing page | 100+ templates | Great for bio links'),
    t('linktree-ai','Linktree','marketing','The original link-in-bio platform with AI-powered analytics.','https://linktr.ee',true,true,150000, freeTier:'Free basic links', price:5, priceTier:'Starter monthly', tips:'Industry standard for IG/TikTok | AI suggests link icons | Detailed traffic data'),

    // ━━━ NEWS & READING (Niche) ━━━
    t('daily-ai','Daily.dev','news','The homepage for developers with AI-curated tech news.','https://daily.dev',true,true,25000, freeTier:'Completely free extension', price:0, tips:'Stay updated on all tech | Community-curated | AI-powered personal feed'),
    t('the-browser-ai','The Browser','news','Curated "Best of the Web" with AI-powered deep dives and audio.','https://thebrowser.com',true,false,5800, freeTier:'Free basic newsletter', price:5, priceTier:'Full access monthly', tips:'High quality curation | 5 deep links per day | Audio version of articles'),
    t('curio-ai','Curio','news','AI-powered audio journalism platform narrating the best articles.','https://curio.io',true,true,8400, freeTier:'Free trial available', price:10, priceTier:'Standard monthly', tips:'Listen to The Economist, WSJ, etc. | High quality narration | Great for commuting'),
    t('audm-ai','Audm','news','Premium long-form journalism read by expert voice actors (acquired by NYT).','https://audm.com',false,false,3600, freeTier:'NYT subscription needed', price:0, tips:'Long-form audio focus | Best voice actors | Now part of New York Times App'),
    t('pocket-premium-ai','Pocket Premium','news','Advanced Pocket features with AI search and permanent digital library.','https://getpocket.com',true,false,6200, freeTier:'Free basic available', price:5, priceTier:'Premium monthly', tips:'Permanent library of saved links | Full-text search | AI tag suggestions'),
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
