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
    // ━━━ DEVELOPER TOOLS (Essential) ━━━
    t('stripe-ai','Stripe','finance','The gold standard for online payments with AI-powered fraud detection.','https://stripe.com',true,true,250000, freeTier:'Pay-as-you-go pricing', price:0, tips:'Best for global e-commerce | "Radar" AI prevents fraud | Industry leading documentation'),
    t('auth0-ai','Auth0 (Okta)','code','Identity platform for developers to secure logins with AI anomaly detection.','https://auth0.com',true,true,58000, freeTier:'Free for up to 7500 users', price:23, priceTier:'B2C plan monthly', tips:'Best for application auth | AI detects leaked credentials | Support for 30+ SDKs'),
    t('firebase-ai-pro','Firebase','code','Google\'s mobile platform that helps you build better apps with AI.','https://firebase.google.com',true,true,180000, freeTier:'No-cost Spark plan', price:0, tips:'Real-time database | AI-powered crashlytics | Integrated auth and hosting'),
    t('mongodb-atlas-ai','MongoDB Atlas','code','Fully managed cloud database with AI-powered vector search and scaling.','https://mongodb.com/atlas',true,true,84000, freeTier:'Free shared cluster forever', price:0, tips:'Best for document data | Built-in vector search for RAG | High availability'),
    t('supabase-ai-pro','Supabase','code','The open-source Firebase alternative with AI vector search and Postgres.','https://supabase.com',true,true,45000, freeTier:'Free tier for hobby projects', price:25, priceTier:'Pro plan monthly', tips:'Auto-generated APIs | PostgreSQL with pgvector | Instant auth and edge functions'),

    // ━━━ DESIGN TOOLS (Essential) ━━━
    t('coolors-ai','Coolors','design','The super fast color palettes generator used by 5M+ designers.','https://coolors.co',true,true,120000, freeTier:'Free basic version', price:3, priceTier:'Pro: no ads and more features', tips:'Generate schemes from photos | AI-powered combinations | Export to any format'),
    t('font-awesome-ai','Font Awesome','design','The web\'s most popular icon set and toolkit with AI-powered search.','https://fontawesome.com',true,true,250000, freeTier:'Free version with 2k+ icons', price:8, priceTier:'Pro annual price', tips:'SVG and icon fonts support | 26k+ icons in Pro | Easy CDN delivery'),
    t('undraw-ai','unDraw','design','Beautiful SVG illustrations with customizable colors for your projects.','https://undraw.co',true,true,84000, freeTier:'Completely free for commercial', price:0, tips:'Open source illustrations | Change color to match your brand | No attribution needed'),
    t('lottie-files-ai','LottieFiles','design','World\'s largest library of Lottie animations with AI-powered editor.','https://lottiefiles.com',true,true,150000, freeTier:'Free for up to 10 animations', price:20, priceTier:'Pro monthly', tips:'Lightweight motion graphics | AI-powered SVG to Lottie | Plugins for Figma/AE'),
    t('behance-ai','Behance (Adobe)','design','The world\'s largest creative network for showcasing and discovering work.','https://behance.net',true,true,250000, freeTier:'Completely free to join', price:0, tips:'Get discovered by agencies | AI-curated moodboards | High quality inspiration'),

    // ━━━ E-COMMERCE (Growth) ━━━
    t('yotpo-ai','Yotpo','ecommerce','Leading e-commerce marketing platform with AI reviews and visual UGC.','https://yotpo.com',true,true,35000, freeTier:'Free basic plan', price:0, tips:'Best for enterprise Shopify | AI sentiment analysis | Integrated SMS marketing'),
    t('gorgias-ai','Gorgias','ecommerce','The #1 helpdesk for e-commerce with AI-powered automated responses.','https://gorgias.com',false,true,18000, freeTier:'7-day free trial', price:10, priceTier:'Starter monthly', tips:'Integrate with Shopify/Magento | AI detects intent | One-click refunds'),
    t('recharge-ai','Recharge','ecommerce','Leading subscription management for high-growth e-commerce brands.','https://rechargepayments.com',true,true,25000, freeTier:'Free for first \$100k revenue', price:99, priceTier:'Standard monthly + transaction fee', tips:'Best for recurring products | AI predicts churn | Powerful analytics portal'),
    t('privy-ai','Privy','ecommerce','The #1 sales platform for Shopify to grow lists and sales with AI.','https://privy.com',true,true,38000, freeTier:'Free for up to 100 contacts', price:30, priceTier:'Starter monthly', tips:'Pop-ups that convert | AI copy suggestions | Automated email marketing'),
    t('smile-io-ai','Smile.io','ecommerce','Loyalty, referrals, and VIP programs for e-commerce stores with AI.','https://smile.io',true,true,45000, freeTier:'Free for up to 200 orders', price:49, priceTier:'Starter monthly', tips:'Easy loyalty points setup | AI-powered rewards suggestions | High engagement'),

    // ━━━ TRAVEL ACCESSORIES ━━━
    t('accuweather-ai','AccuWeather','travel','Leading weather platform with AI-powered "RealFeel" and hyper-local alerts.','https://accuweather.com',true,true,250000, freeTier:'Completely free online/app', price:0, tips:'Minute-by-minute rain forecasts | AI-powered severe weather alerts | Global accuracy'),
    t('windy-ai','Windy','travel','Stunning interactive weather map for pilots, sailors, and adventurers.','https://windy.com',true,true,120000, freeTier:'Free high-res data', price:2, priceTier:'Premium: 1h forecast steps', tips:'Best visual weather app | Professional models (ECMWF, GFS) | No ads in free version'),
    t('seat-geek-ai','SeatGeek','travel','Smart search engine for tickets with AI-powered "Deal Score" analytics.','https://seatgeek.com',true,true,84000, freeTier:'Free to browse', price:0, tips:'Know if a seat is a good deal | Huge inventory for sports and concerts | Simple resale'),
    t('viator-ai','Viator (TripAdvisor)','travel','Leading marketplace for travel experiences and tours globally with AI.','https://viator.com',true,true,150000, freeTier:'Free to browse', price:0, tips:'Book 300k+ activities | Flexible cancellation | AI-powered local guides'),
    t('get-your-guide-ai','GetYourGuide','travel','Discover and book unforgettable travel experiences worldwide with AI.','https://getyourguide.com',true,true,120000, freeTier:'Free to browse', price:0, tips:'Best for European tours | Exclusive "Original" experiences | Easy mobile booking'),

    // ━━━ GAMING & STREAMING ━━━
    t('twitch-ai','Twitch','entertainment','Leading live streaming platform for gamers with AI chat moderation.','https://twitch.tv',true,true,999999, freeTier:'Completely free to use', price:0, tips:'AutoMod AI filters toxicity | Integrated with Prime | Host for global events'),
    t('streamlabs-ai','Streamlabs','entertainment','Leading suite of tools for streamers with AI-powered alerts and themes.','https://streamlabs.com',true,true,150000, freeTier:'Free basic tools', price:19, priceTier:'Ultra monthly', tips:'Best for OBS users | AI Multi-stream support | Professional overlays'),
    t('stream-elements-ai','StreamElements','entertainment','The ultimate platform for streamers with AI-powered cloud bot and tips.','https://streamelements.com',true,true,120000, freeTier:'Free forever for creators', price:0, tips:'Cloud-based overlays | SE.Live plugin for OBS | High quality chatbot AI'),
    t('nexus-gg-ai','Nexus.gg','entertainment','Support creators by buying games directly from their AI-powered stores.','https://nexus.gg',true,false,15000, freeTier:'Free for creators', price:0, tips:'Empower streamers directly | Officially licensed keys | Clean UI'),
    t('medal-tv-ai','Medal.tv','entertainment','Leading platform for sharing gaming clips with AI-powered highlights.','https://medal.tv',true,true,84000, freeTier:'Free for unlimited clips', price:0, tips:'AI-powered automatic clipping | Support for 100+ games | Fast editing tools'),

    // ━━━ OFFICE & ADMIN ━━━
    t('typeform-ai-pro','Typeform','marketing','Conversational forms and surveys with AI-powered writing assistant.','https://typeform.com',true,true,120000, freeTier:'Free for 10 responses/month', price:25, priceTier:'Basic monthly', tips:'The gold standard for UI in forms | AI writes your questions | High completion rates'),
    t('survey-monkey-ai','SurveyMonkey','marketing','The most popular online survey tool with AI-powered "Genius" analyzer.','https://surveymonkey.com',true,true,250000, freeTier:'Free for up to 10 questions', price:25, priceTier:'Standard monthly', tips:'Best for enterprise research | AI predicts survey performance | Robust analytics'),
    t('jotform-ai','Jotform','marketing','Powerful online form builder with AI and integrated app builder.','https://jotform.com',true,true,150000, freeTier:'Free for up to 5 forms', price:34, priceTier:'Bronze monthly', tips:'10k+ templates | No-code app builder | Integrated with 100+ platforms'),
    t('coda-ai-pro','Coda','productivity','The evolution of the doc that brings data and teams together with AI.','https://coda.io',true,true,58000, freeTier:'Free for personal docs', price:10, priceTier:'Pro per user monthly', tips:'Docs that work like apps | AI-powered summaries and tables | Replaces spreadsheets'),
    t('airtable-pro-ai','Airtable','productivity','Low-code platform for building collaborative apps with AI workflows.','https://airtable.com',true,true,180000, freeTier:'Free basic version', price:20, priceTier:'Team plan monthly', tips:'Spreadsheet meets database | AI-powered data types | Massive automation library'),

    // ━━━ COMMUNICATION GEMS ━━━
    t('otter-ai-pro','Otter.ai','productivity','AI-powered meeting notes, transcriptions, and collaboration.','https://otter.ai',true,true,150000, freeTier:'Free for 300 mins/month', price:10, priceTier:'Pro monthly', tips:'Best for real-time transcription | AI-powered meeting summaries | Shared workspaces'),
    t('fireflies-ai-pro','Fireflies.ai','productivity','AI meeting assistant that records, transcribes, and searches meetings.','https://fireflies.ai',true,true,84000, freeTier:'Free for 800 mins storage', price:10, priceTier:'Pro monthly', tips:'Integrates with Zoom/Teams/Google | AI-powered sentiment analysis | Search keywords'),
    t('tldv-ai','tl;dv','productivity','The meeting recorder that transcribes and summarizes with AI.','https://tldv.io',true,true,56000, freeTier:'Free for unlimited recording', price:20, priceTier:'Pro monthly', tips:'Clip best meeting moments | AI handles time-stamps | Great for remote teams'),
    t('grain-ai','Grain','productivity','Connect your team to the voice of the customer with AI meeting notes.','https://grain.com',true,false,35000, freeTier:'Free for up to 20 meetings', price:15, priceTier:'Starter monthly', tips:'Best for sales and product teams | AI-powered highlight clips | Slack integration'),
    t('rewatch-ai','Rewatch','productivity','The video hub for remote teams that organizes and searches with AI.','https://rewatch.com',true,false,18000, freeTier:'Free for small teams', price:15, priceTier:'Standard per user monthly', tips:'Private and secure video host | AI-powered transcriptions | Auto-highlights'),

    // ━━━ UTILITIES & OPTIMIZERS ━━━
    t('tiny-png-ai','TinyPNG','design','The smartest smart PNG and JPEG compression used by millions.','https://tinypng.com',true,true,250000, freeTier:'Free web tool (up to 20 files)', price:0, tips:'Reduce file size by 70% | No visible quality loss | API for developers'),
    t('kraken-ai','Kraken.io','design','Image optimizer and compressor with AI for high-performance websites.','https://kraken.io',true,false,45000, freeTier:'Web interface for small files', price:5, priceTier:'Micro plan monthly', tips:'Lossless and lossy modes | API for bulk optimization | WordPress plugin'),
    t('image-optim-ai','ImageOptim','design','Free open-source Mac app that makes images load faster with AI.','https://imageoptim.com',true,true,58000, freeTier:'Completely free open source', price:0, tips:'Cleans up metadata | Best tool for Mac users | Completely private'),
    t('speedtest-ai','Speedtest by Ookla','productivity','The global leader in internet speed testing with AI for network analysis.','https://speedtest.net',true,true,999999, freeTier:'Completely free online/app', price:0, tips:'Check your ping and jitters | AI-powered video test | National rankings'),
    t('cloudflare-ai-pro','Cloudflare','productivity','The leader in web performance and security with AI-powered WAF.','https://cloudflare.com',true,true,999999, freeTier:'Free forever for individuals', price:20, priceTier:'Pro plan monthly', tips:'Fastest global CDN | Free SSL certificates | "Workers" AI for edge computing'),

    // ━━━ NEWS & DIGEST ━━━
    t('feedly-ai','Feedly','news','AI-powered news aggregator that sorts through the noise for you.','https://feedly.com',true,true,150000, freeTier:'Free for 100 sources', price:6, priceTier:'Pro monthly', tips:'AI "Leo" assistant | Track specific keywords | Ad-free reading'),
    t('nuzzel-ai','Nuzzel','news','The easiest way to consume the news your friends are sharing (now Twitter).','https://nuzzel.com',false,false,35000, freeTier:'Free (now part of X)', price:0, tips:'Identify trending stories | Clean and fast | Now integrated in Twitter Blue'),
    t('google-news-ai','Google News','news','World-class news personalization with AI for real-time coverage.','https://news.google.com',true,true,999999, freeTier:'Completely free forever', price:0, tips:'Full coverage on any story | Local news focus | AI-curated "For You"'),
    t('apple-news-ai','Apple News','news','The best news experience on Apple devices with AI curation.','https://apple.com/apple-news',true,true,250000, freeTier:'Free app for Apple users', price:10, priceTier:'News+ monthly', tips:'Highest quality journalism | AI-powered audio stories | Best layout on iPad'),
    t('news-letters-ai','Newsletter Bridge','news','Read your favorite newsletters in your RSS reader with AI sorting.','https://newsletterbridge.com',true,false,12000, freeTier:'Free for up to 3 newsletters', price:5, priceTier:'Premium monthly', tips:'Avoid inbox clutter | AI-powered summaries | RSS and Atom support'),

    // ━━━ FINANCE (Extra) ━━━
    t('robinhood-ai','Robinhood','finance','The pioneer of commission-free investing with AI-powered insights.','https://robinhood.com',true,true,250000, freeTier:'Free to join and trade', price:5, priceTier:'Gold monthly for 5% APR', tips:'Easiest UI for stocks | 24-hour market access | AI-curated news'),
    t('coinbase-ai-pro','Coinbase','finance','The most trusted crypto exchange with AI-powered fraud monitoring.','https://coinbase.com',true,true,250000, freeTier:'Free to join', price:0, tips:'Safest way to buy crypto | AI security dashboard | Institutional grade safety'),
    t('wise-ai-pro','Wise (TransferWise)','finance','The cheapest way to send money abroad with AI-optimized rates.','https://wise.com',true,true,180000, freeTier:'Free to join', price:0, tips:'Real mid-market rates | AI predicts currency swings | Multi-currency card'),
    t('revolut-ai-pro','Revolut','finance','The global financial super-app with AI-powered budgeting and crypto.','https://revolut.com',true,true,150000, freeTier:'Free basic account', price:10, priceTier:'Premium monthly', tips:'Instant global transfers | AI-powered disposable cards | Best for travel'),
    t('wealthfront-ai','Wealthfront','finance','Automated AI-powered investing and high-yield savings for pioneers.','https://wealthfront.com',false,true,58000, freeTier:'Fee-free first \$5000', price:0.25, priceTier:'Annual advisory fee', tips:'Tax-loss harvesting AI | High interest cash account | Long-term focus'),
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
