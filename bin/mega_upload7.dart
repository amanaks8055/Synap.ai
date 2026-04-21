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
    // ━━━ SALES AI ━━━
    t('gong-ai','Gong','sales','Revenue intelligence platform that analyzes customer interactions to improve sales.','https://gong.io',false,true,6200, freeTier:'Demo available', price:0, tips:'Record all calls | AI identifies winning behaviors | Sync with Salesforce'),
    t('chorus-ai','Chorus.ai','sales','Conversation intelligence for sales teams to capture and analyze meetings.','https://chorus.ai',false,false,3400, freeTier:'No free tier', price:0, tips:'Identify objections automatically | Coach reps with real data | Acquired by ZoomInfo'),
    t('apollo-ai','Apollo.io','sales','Sales intelligence platform with lead database and AI outreach tools.','https://apollo.io',true,true,8400, freeTier:'Free basic with 50 credits', price:49, priceTier:'Basic: unlimited email credits', tips:'Best B2B database | AI writes email sequences | High deliverability'),
    t('seamless-ai','Seamless.ai','sales','AI search engine for B2B contact information and lead generation.','https://seamless.ai',true,false,4800, freeTier:'Free trial with limited credits', price:147, priceTier:'Pro: unlimited searching', tips:'Real-time search across the web | Sync with LinkedIn | High accuracy rate'),
    t('lusha-ai','Lusha','sales','B2B prospecting tool providing accurate contact info for sales and HR.','https://lusha.com',true,false,3600, freeTier:'5 free credits per month', price:29, priceTier:'Pro: 40 credits per month', tips:'Best for phone numbers | Browser extension is seamless | Compliant data'),
    t('outreach-ai','Outreach','sales','Sales execution platform with AI for sequence automation and forecasting.','https://outreach.io',false,true,5200, freeTier:'Demo available', price:0, tips:'Complete sales engagement | AI deal scoring | Guided selling for reps'),
    t('salesloft-ai','Salesloft','sales','Revenue orchestration platform for sales teams with AI coaching.','https://salesloft.com',false,false,4400, freeTier:'Demo available', price:0, tips:'Best for enterprise sales | Rhythm AI prioritizes tasks | High adoption rate'),
    t('6sense-ai','6sense','sales','Account-based marketing and sales platform using AI to predict buyers.','https://6sense.com',false,true,3800, freeTier:'Demo available', price:0, tips:'Identifies "Dark Funnel" buyers | Predictive intent scores | Great for ABM'),

    // ━━━ E-LEARNING (more) ━━━
    t('coursera-ai','Coursera Coach','education','AI learning assistant for Coursera students providing guidance and help.','https://coursera.org',true,true,25000, freeTier:'Free to audit most courses', price:59, priceTier:'Coursera Plus monthly', tips:'Guided learning paths | AI summarizes lectures | Real university certificates'),
    t('udemy-ai','Udemy AI','education','Personalized course recommendations and AI learning assistant.','https://udemy.com',true,false,18000, freeTier:'Free courses available', price:12, priceTier:'Personal Plan (Business)', tips:'Largest library of skills | AI suggests learning paths | Great for tech skills'),
    t('edx-ai','edX Xpert','education','AI-powered learning assistant for edX courses from top universities.','https://edx.org',true,false,12000, freeTier:'Free to audit', price:0, tips:'Courses from Harvard and MIT | AI helps with complex concepts | Career certificates'),
    t('masterclass-ai','MasterClass','education','Premium video classes from world-class experts with AI discovery.','https://masterclass.com',false,true,9600, freeTier:'No free trial usually', price:10, priceTier:'Standard monthly billed annually', tips:'Cinematic production quality | Learn from the absolute best | AI helps find lessons'),
    t('skillshare-ai','Skillshare','education','Creative learning community with AI tools for finding workshops.','https://skillshare.com',true,false,8200, freeTier:'7-day free trial', price:14, priceTier:'Annual membership monthly price', tips:'Best for creative skills | Hands-on projects | Community feedback'),
    t('linkedin-learning','LinkedIn Learning','education','Professional courses recommended by AI based on your career interests.','https://linkedin.com/learning',true,true,15000, freeTier:'1-month free trial', price:20, priceTier:'Monthly subscription', tips:'Skill certificates on profile | AI identifies skill gaps | Integrated with jobs'),
    t('pluralsight-ai','Pluralsight Flow','education','Tech learning platform with AI assessments for developer skill paths.','https://pluralsight.com',true,false,5600, freeTier:'10-day free trial', price:29, priceTier:'Individual monthly', tips:'Best for deep tech and cloud | Skill IQ assessments | Hands-on labs'),

    // ━━━ REAL ESTATE AI (more) ━━━
    t('zillow-zestimate','Zillow Zestimate','realestate','AI-powered home value estimation tool using vast historical data.','https://zillow.com',true,true,45000, freeTier:'Completely free for consumers', price:0, tips:'Industry standard for quick value | Updates daily | Includes rental estimates'),
    t('redfin-estimate','Redfin Estimate','realestate','Highly accurate AI home valuation tool based on local MLS data.','https://redfin.com',true,false,38000, freeTier:'Completely free to use', price:0, tips:'Claimed to be most accurate | Direct link to agents | Market trend data'),
    t('realtor-com-ai','Realtor.com','realestate','Property search engine with AI-powered personalized listings.','https://realtor.com',true,false,32000, freeTier:'Completely free search', price:0, tips:'Official source of listings | "Neighborhood" insights | Loan calculators'),
    t('houzz-ai','Houzz','realestate','Leading platform for home remodeling and design with AI visualization.','https://houzz.com',true,true,15000, freeTier:'Free to browse and use', price:0, tips:'AR "View in my room" | Connect with pros | Shop architectural styles'),
    t('compass-ai','Compass','realestate','Modern real estate brokerage using AI to help agents sell faster.','https://compass.com',false,false,8400, freeTier:'Consumer search is free', price:0, tips:'Compass Lens reimagines rooms | Powerful agent CRM | Market analysis tools'),
    t('opendoor-ai','Opendoor','realestate','AI-driven platform for selling your home instantly at a fair price.','https://opendoor.com',false,true,6200, freeTier:'Get a free offer online', price:0, tips:'Sell in days, not months | No showings required | Reliable cash offers'),

    // ━━━ GAMING & STREAMING (more) ━━━
    t('twitch-ai','Twitch Safety','social','AI tools for moderating chat and ensuring streamer safety.','https://twitch.tv',true,true,58000, freeTier:'Completely free for users', price:0, tips:'AI AutoMod detects toxicity | Creator Dashboard tools | Built for live scale'),
    t('streamlabs-ai','Streamlabs Ultra','gaming','Complete streaming suite with AI-powered alerts and tools.','https://streamlabs.com',true,true,12000, freeTier:'Free basic tools', price:19, priceTier:'Ultra monthly', tips:'Best for OBS users | AI overlays and alerts | Multi-stream built-in'),
    t('nightbot-ai','Nightbot','social','AI-powered chat bot for Twitch and YouTube automation.','https://nightbot.tv',true,false,15000, freeTier:'Completely free forever', price:0, tips:'Auto-respond to commands | Filter spam | Song requests system'),
    t('streamelements-ai','StreamElements','social','All-in-one streaming platform with AI chatbots and overlays.','https://streamelements.com',true,false,12000, freeTier:'Completely free for creators', price:0, tips:'Cloud-based alerts | SE.Live plugin for OBS | Loyalty systems'),
    t('obs-studio','OBS Studio','gaming','Open-source software for video recording and live streaming.','https://obsproject.com',true,true,45000, freeTier:'Completely free forever', price:0, tips:'The industry standard | Huge plugin ecosystem | AI noise removal plugin available'),

    // ━━━ CRYPTO & WEB3 AI ━━━
    t('trm-labs-ai','TRM Labs','security','AI-powered blockchain intelligence for fraud detection and compliance monitoring.','https://trmlabs.com',false,true,3400, freeTier:'Institutional only', price:0, tips:'Strong AML workflows | Wallet risk intelligence | Trusted by exchanges'),
    t('elliptic-ai','Elliptic','security','AI blockchain analytics for crypto compliance and risk management.','https://elliptic.co',false,false,2800, freeTier:'Demo available', price:0, tips:'World leading wallet screening | Identify high-risk actors | Used by banks'),
    t('dune-analytics','Dune AI','data','Open blockchain data analytics platform with AI SQL assistant.','https://dune.com',true,true,5600, freeTier:'Free community dashboards', price:39, priceTier:'Pro: private queries and more data', tips:'SQL to crypto insights | Community-driven data | AI helps write queries'),
    t('nansen-ai','Nansen','data','Blockchain analytics platform surfaceing "smart money" movements.','https://nansen.ai',true,true,4800, freeTier:'Free basic access', price:99, priceTier:'Standard monthly', tips:'Follow top wallets | NFT market data | Identify emerging trends'),
    t('arkham-intel','Arkham Intelligence','data','AI blockchain deanonymization platform and intel exchange.','https://arkhamintelligence.com',true,true,6200, freeTier:'Free public platform', price:0, tips:'Visualize crypto flows | Deanonymize addresses | Real-time alerts'),

    // ━━━ CUSTOMER EXPERIENCE ━━━
    t('medallia-ai','Medallia','support','Enterprise AI for customer and employee experience management.','https://medallia.com',false,false,1800, freeTier:'Demo available', price:0, tips:'Analyze text, voice, and video | Real-time sentiment analysis | Actionable insights'),
    t('qualtrics-ai','Qualtrics XM','support','Leading experience management platform with AI-powered analytics.','https://qualtrics.com',false,true,4200, freeTier:'Free account for surveys', price:0, tips:'AI-powered survey design | Text iQ for sentiment | Leading in market research'),
    t('sprinklr-ai','Sprinklr','marketing','Unified customer experience platform for social and messaging.','https://sprinklr.com',false,false,2800, freeTier:'Demo available', price:0, tips:'Unified agent desktop | Social listening at scale | AI customer service'),
    t('birdeye-ai','Birdeye','marketing','AI reputation management and customer review platform for local biz.','https://birdeye.com',false,false,2400, freeTier:'No free tier', price:0, tips:'Auto-reply to reviews | Collect reviews via SMS | Local SEO ranking'),
    t('podium-ai','Podium','marketing','AI messaging platform for local businesses to get reviews and leads.','https://podium.com',true,false,3400, freeTier:'Free 14-day trial', price:0, tips:'SMS marketing for local biz | Unified inbox | Easy review collection'),

    // ━━━ HEALTH & NUTRITION ━━━
    t('myfitnesspal-ai','MyFitnessPal','health','Leading food and exercise logger with AI-powered meal recognition.','https://myfitnesspal.com',true,true,35000, freeTier:'Free basic logging', price:20, priceTier:'Premium: barcode scan and macros', tips:'Largest food database | Connect with 50+ apps | Macro tracking expert'),
    t('chronometer-ai','Cronometer','health','Detailed nutrition tracker with AI for tracking micronutrients.','https://cronometer.com',true,false,8200, freeTier:'Free basic plan', price:8, priceTier:'Gold: ad-free and more charts', tips:'Most accurate nutrition data | Focus on health goals | Fast logging'),
    t('noom-ai','Noom','health','AI-powered weight loss app focused on psychology and coaching.','https://noom.com',false,true,15000, freeTier:'Free trial available', price:60, priceTier:'Monthly billed annually', tips:'Psychology-based approach | Daily color-coded food logs | Human coaching built-in'),
    t('weightwatchers-ai','WW (WeightWatchers)','health','AI-driven weight management with points-based nutrition plans.','https://weightwatchers.com',false,false,12000, freeTier:'30-day free trial', price:22, priceTier:'Monthly subscription', tips:'ZeroPoint foods list | Community support | In-person meetings option'),
    t('fitbit-ai','Fitbit Premium','health','AI health insights based on wearables data (sleep, activity, stress).','https://fitbit.com',true,true,18000, freeTier:'Free app for tracking', price:10, priceTier:'Premium for AI insights', tips:'Daily Readiness Score | Detailed sleep analysis | Stress management score'),

    // ━━━ TRAVEL & HOSPITALITY (more) ━━━
    t('booking-ai','Booking.com','travel','Leading travel platform with AI for personalized hotel deals.','https://booking.com',true,true,150000, freeTier:'Free to use and book', price:0, tips:'Genius loyalty program | Verified reviews | Largest inventory globally'),
    t('expedia-ai','Expedia','travel','Comprehensive travel platform with AI-powered price predictions.','https://expedia.com',true,true,98000, freeTier:'Free to use', price:0, tips:'Price tracking for flights | Package deals save money | Points system'),
    t('airbnb-ai','Airbnb','travel','Global hosting platform with AI for listing optimization and search.','https://airbnb.com',true,true,120000, freeTier:'Free to browse and book', price:0, tips:'Unique "Categories" discovery | Photo tour AI | Best for local stays'),
    t('tripadvisor-ai','TripAdvisor','travel','The world\'s largest travel site with AI-powered review summaries.','https://tripadvisor.com',true,true,84000, freeTier:'Free platform for all', price:0, tips:'AI summarizes 1000s of reviews | Best for restaurant search | Forums are high quality'),
    t('kayak-ai','KAYAK','travel','Travel search engine that compares 100s of sites with AI price alerts.','https://kayak.com',true,false,45000, freeTier:'Free search engine', price:0, tips:'"Hacker Fares" save money | Price forecast (buy vs wait) | Explore feature'),

    // ━━━ PRODUCTIVITY (Tools) ━━━
    t('trello-ai','Trello (Butler)','productivity','Visual project management with AI-powered "Butler" automation.','https://trello.com',true,true,18000, freeTier:'Free for up to 10 boards', price:5, priceTier:'Standard per user', tips:'Easy visual workflows | Huge power-up library | Best for small teams'),
    t('asana-ai','Asana Intelligence','productivity','Enterprise project management with AI for goal tracking and workflows.','https://asana.com',true,true,15000, freeTier:'Free for up to 15 people', price:10, priceTier:'Starter per user', tips:'Superior for large teams | Smart summaries of tasks | Goals integration'),
    t('monday-ai','Monday.com','productivity','Work OS platform with AI-powered automations and dashboards.','https://monday.com',true,true,12000, freeTier:'Free for up to 2 users', price:8, priceTier:'Basic per user', tips:'Most customizable task board | Visual charts and reports | Great templates'),
    t('todoist-ai','Todoist','productivity','Simple and powerful task manager with AI for task prioritization.','https://todoist.com',true,true,15000, freeTier:'Free for up to 5 projects', price:4, priceTier:'Pro: 300 projects and reminders', tips:'"Karma" tracking for habits | Natural language task entry | Cross-platform sync'),
    t('things3-ai','Things 3','productivity','The most beautiful and awards-winning task manager for Apple.','https://culturedcode.com/things',false,true,9200, freeTier:'Free trial for Mac', price:10, priceTier:'One-time purchase (iPhone)', tips:'Cleanest design in class | Excellent "Today" view | Fast and reliable'),
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
