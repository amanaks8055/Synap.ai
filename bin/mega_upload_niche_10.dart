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
    // ━━━ AI FOR MORTGAGE & LEASING ━━━
    t('better-mortgage-ai','Better.com','finance','Leading AI-powered mortgage lender that automates the home loan process.','https://better.com',true,true,150000, freeTier:'Free pre-qualification in 3 mins', price:0, tips:'Fastest mortgage approvals with AI | No commissions for loan officers | Completely digital'),
    t('rocket-mortgage-ai','Rocket Mortgage','finance','The world\'s largest mortgage lender using AI for individual loan offers.','https://rocketmortgage.com',true,true,250000, freeTier:'Free credit check and pre-approval', price:0, tips:'Reliable and trusted | AI-powered "MyRocket" dashboard | High end customer support'),
    t('guaranteed-rate-ai','Guaranteed Rate','finance','Leading mortgage platform using AI for rate tracking and fast approvals.','https://rate.com',true,true,120000, freeTier:'Free rate discovery online', price:0, tips:'Digital mortgage pioneer | AI-powered "FlashClose" | Highly rated mobile app'),
    t('loan-depot-ai','loanDepot','finance','Digital mortgage lender using AI to personalize loan options for everyone.','https://loandepot.com',true,true,150000, freeTier:'Free consultation and evaluation', price:0, tips:'Best for first-time buyers | AI-powered expert matching | Nationwide coverage'),
    t('appfolio-ai-pro','AppFolio','business','Leading cloud-based property management software with AI-powered ops.','https://appfolio.com',false,true,45000, freeTier:'Demo available', price:1, priceTier:'Per unit monthly starting', tips:'AI "Smart Maintenance" for tenants | Best for large portfolios | Integrated accounting'),
    t('entrata-ai-pro','Entrata','business','Comprehensive property management platform with AI-powered leasing help.','https://entrata.com',false,true,35000, freeTier:'Demo available', price:0, tips:'Leading in multifamily housing | AI-powered "Entrata Core" | Robust reporting'),
    t('yardi-ai-pro','Yardi','business','The global leader in real estate software with AI-powered asset management.','https://yardi.com',false,true,58000, freeTier:'Institutional only', price:0, tips:'Industry standard for large CRE | AI-powered "Virtuoso" assistant | High security'),
    t('realpage-ai-pro','RealPage','business','Leading software and data analytics platform for real estate with AI.','https://realpage.com',false,true,84000, freeTier:'Institutional only', price:0, tips:'Best for yield optimization | AI-powered "AI Revenue Management" | Huge dataset'),
    t('buildium-ai-pro','Buildium','business','All-in-one property management for small to mid-sized portfolios with AI.','https://buildium.com',true,true,45000, freeTier:'14-day free trial', price:50, priceTier:'Essential monthly', tips:'Most user-friendly for small landlords | AI-powered "Resident Center" | Integrated'),
    t('stessa-ai-pro','Stessa','finance','Free smart accounting for residential real estate investors with AI tracking.','https://stessa.com',true,true,35000, freeTier:'Completely free basic version', price:0, tips:'Owned by Roofstock | AI extracts data from docs | Best for single family rentals'),

    // ━━━ AI FOR LEGAL v2 (E-Discovery & Trial) ━━━
    t('everlaw-ai-pro','Everlaw','business','The most modern e-discovery and litigation platform with AI-powered search.','https://everlaw.com',false,true,15000, freeTier:'Demo available', price:0, tips:'AI-powered "Predictive Coding" | Best for high-stakes litigation | Secure and fast'),
    t('relativity-ai-pro','Relativity','business','The industry standard for e-discovery and legal data analysis with AI.','https://relativity.com',false,true,25000, freeTier:'Institutional only', price:0, tips:'Largest legal tech community | AI-powered "aiR" for generative legal | Enterprise'),
    t('disco-ai-legal','CS DISCO','business','Leader in legal technology for e-discovery using AI and cloud scale.','https://csdisco.com',false,true,12000, freeTier:'Demo available', price:0, tips:'Fastest processing in the industry | AI-powered "Cecilia" chatbot | Developer focused'),
    t('logikcull-ai-pro','Logikcull','business','Instant e-discovery for legal teams of all sizes using AI-powered automation.','https://logikcull.com',true,true,15000, freeTier:'Free trial for 25MB of data', price:395, priceTier:'Pay-as-you-go per project', tips:'Best for small firms | AI automates document categorization | Easy setup'),
    t('page-vance-ai','PageVance','business','AI-powered trial preparation and document management for litigators.','https://pagevance.com',false,false,5600, freeTier:'Demo available', price:0, tips:'Best for boutique law firms | AI identifies key testimony | Secure and private'),
    t('lawgeex-ai-pro','LawGeex','business','Leading AI platform for automated contract review and redlining.','https://lawgeex.com',false,false,8400, freeTier:'Institutional only', price:0, tips:'Automate 80% of contract review | Enterprise focus | Consistent legal logic'),
    t('spellbook-ai-pro','Spellbook','business','AI-powered legal drafting and review directly inside Microsoft Word.','https://spellbook.com',true,true,18000, freeTier:'Free trial available', price:0, tips:'Formerly Rally | AI suggests legal clauses | Built for high-end lawyers'),
    t('lexion-ai-pro','Lexion','business','The smart contract repository for modern legal and sales teams using AI.','https://lexion.ai',false,true,12000, freeTier:'Demo available', price:0, tips:'Find any contract info instantly | AI-powered data extraction | Part of Highspot'),
    t('link-squares-ai','LinkSquares','business','AI-powered contract lifecycle management for in-house legal teams.','https://linksquares.com',false,true,15000, freeTier:'Demo available', price:0, tips:'Best for GCs and legal ops | AI-powered "Finalize" tool | Enterprise grade'),
    t('contract-pod-ai','ContractPodAi','business','Leading AI platform for legal-led transformation and contract management.','https://contractpodai.com',false,false,9200, freeTier:'Institutional only', price:0, tips:'AI-powered "Leah" legal assistant | Best for global enterprises | Robust compliance'),

    // ━━━ AI FOR SPORTS v2 (Scouting & Training) ━━━
    t('hudl-ai-pro','Hudl','entertainment','The world\'s leading sports video analysis and scouting platform with AI.','https://hudl.com',true,true,150000, freeTier:'Free basic viewer app', price:0, tips:'Best for high school and college teams | AI-powered highlights | Global network'),
    t('catapult-ai-pro','Catapult Sports','health','Leading wearable athlete monitoring and video analysis with AI.','https://catapultsports.com',false,true,45000, freeTier:'Institutional only', price:0, tips:'Used by 4000+ elite teams world-wide | AI-powered "Thunder" video | Best for pros'),
    t('stats-perform-ai','Stats Perform','business','Global leader in sports data and AI-powered predictions (Opta).','https://statsperform.com',false,true,58000, freeTier:'Institutional only', price:0, tips:'The power behind Apple Sports and ESPN | AI-powered "Opta" metrics | Industry leader'),
    t('keiser-ai-pro','Keiser (Digital)','health','High-end fitness equipment with AI-powered pneumatic resistance.','https://keiser.com',false,true,12000, freeTier:'Hardware required', price:0, tips:'Used by almost every pro team | AI-powered training intensity | Scientific focus'),
    t('swingvision-ai','SwingVision','health','AI-powered tennis app for automated coaching and line calling.','https://swing.tennis',true,true,84000, freeTier:'Free basic version', price:15, priceTier:'Pro monthly billed annual', tips:'Mount your iPhone on the fence | AI calls lines and tracks score | Best for tennis fans'),
    t('peloton-ai-guide','Peloton Guide','health','AI-powered strength training camera that tracks your reps and form.','https://onepeloton.com/guide',false,true,120000, freeTier:'Hardware purchase required', price:13, priceTier:'All-Access monthly membership', tips:'AI "Rep Tracker" | See your muscles highlighted | Best for home gym'),
    t('tonal-ai-pro','Tonal','health','Leading smart home gym with AI-powered digital weight and coach.','https://tonal.com',false,true,58000, freeTier:'Hardware purchase required', price:60, priceTier:'Monthly membership', tips:'AI-powered "Spotter" mode | Personalized strength training | High end design'),
    t('mirror-ai-lululemon','lululemon Studio (Mirror)','health','Interactive home gym that looks like a mirror with AI classes.','https://mirror.co',false,true,45000, freeTier:'Hardware purchase required', price:39, priceTier:'Monthly membership', tips:'Sleek and minimalist design | AI-powered form feedback | Thousands of classes'),
    t('tempo-ai-pro','Tempo','health','AI-powered home gym using 3D sensors to track your form and reps.','https://tempo.fit',false,true,35000, freeTier:'Hardware purchase required', price:39, priceTier:'Monthly membership', tips:'Best for weightlifting | 3D AI form correction | Integrated equipment'),
    t('fitbod-ai-pro','Fitbod','health','Leading workout tracker that uses AI to build your daily plan.','https://fitbod.me',true,true,150000, freeTier:'3 free workouts for trial', price:13, priceTier:'Monthly subscription', tips:'AI learns your strength levels | Best for gym goers | Personalized routines'),

    // ━━━ AI FOR HOSPITALITY v2 (Feedback & Revenue) ━━━
    t('revinate-ai-pro','Revinate','business','Leading hospitality CRM and guest feedback platform with AI.','https://revinate.com',false,true,18000, freeTier:'Demo available', price:0, tips:'Best for hotel groups | AI-powered sentiment analysis | High ROI for guest data'),
    t('trust-you-ai','TrustYou','business','The world\'s largest guest feedback platform using AI for review scores.','https://trustyou.com',false,true,15000, freeTier:'Demo available', price:0, tips:'The power behind Booking.com scores | AI-powered "Guest Reviews" | Global scale'),
    t('duetto-ai-pro','Duetto','business','Leading revenue management software for hotels powered by high-end AI.','https://duettocloud.com',false,true,12000, freeTier:'Institutional only', price:0, tips:'AI-powered "GameChanger" pricing | Industry standard for hotels | Real-time data'),
    t('ideas-governance','IDeaS (SAS)','business','The gold standard for hotel revenue science using AI and SAS data.','https://ideas.com',false,true,25000, freeTier:'Institutional only', price:0, tips:'Part of SAS | AI-powered inventory and price optimization | Most trusted'),
    t('mews-ai-pro','Mews','business','Modern cloud-based hospitality platform with AI-powered automation.','https://mews.com',false,true,18000, freeTier:'Demo available', price:0, tips:'Best for boutique and modern hotels | AI-powered guest journey | Award-winning'),
    t('cloudbeds-ai-pro','Cloudbeds','business','All-in-one hospitality management for independent properties with AI.','https://cloudbeds.com',false,true,35000, freeTier:'Demo available', price:0, tips:'Largest ecosystem for small hotels | AI-powered pricing help | 100+ countries'),
    t('tablings-ai-pro','TabSling','business','AI-powered platform for restaurant table marketing and bookings.','https://tablings.com',true,false,9200, freeTier:'Free basic version', price:15, priceTier:'Pro monthly', tips:'Best for local food marketing | AI-powered social posts | Fast and clean'),
    t('seven-rooms-ai','SevenRooms','business','Leading guest experience and CRM platform for restaurants with AI.','https://sevenrooms.com',false,true,12000, freeTier:'Demo available', price:0, tips:'Best for high-end dining | AI-powered guest profiles | Direct booking focus'),
    t('toast-ai-pos','Toast (AI)','business','Leading restaurant POS and management platform with AI-powered insights.','https://pos.toasttab.com',true,true,250000, freeTier:'Free basic setup for small biz', price:0, tips:'Industry standard for US restaurants | AI-powered inventory and menu tools | Robust'),
    t('upserve-ai-pro','Upserve (Lightspeed)','business','Restaurant management software with AI-powered server performance help.','https://upserve.com',false,true,84000, freeTier:'Demo available', price:0, tips:'Acquired by Lightspeed | AI identifies top servers | Data-driven guest info'),

    // ━━━ AI FOR RETAIL v3 (Inventory & Store) ━━━
    t('stitch-labs-ai','Stitch Labs (Square)','business','Leading inventory management for multi-channel brands using AI.','https://stitchlabs.com',false,true,12000, freeTier:'Institutional only', price:0, tips:'Acquired by Square | AI-powered order routing | Enterprise scale'),
    t('inventory-planner','Inventory Planner (Sage)','business','The #1 inventory forecasting software for e-commerce with AI.','https://inventory-planner.com',true,true,25000, freeTier:'14-day free trial', price:10, priceTier:'Per unit monthly starting', tips:'Acquired by Sage | AI predicts future sales with 95% accuracy | Best for Shopify'),
    t('criteo-ai-pro','Criteo','marketing','Global leader in commerce media and retargeting using high-end AI.','https://criteo.com',false,true,250000, freeTier:'Demo available', price:0, tips:'World-class AI for ad targeting | Reach billions of users | Performance leader'),
    t('rtb-house-ai','RTB House','marketing','Leading retargeting platform powered by deep learning and AI.','https://rtbhouse.com',false,true,84000, freeTier:'Demo available', price:0, tips:'True deep learning for ads | High conversion rates | Global presence'),
    t('attraqt-ai-pro','Attraqt (Crownpeak)','marketing','AI-powered search and merchandising for luxury e-commerce brands.','https://attraqt.com',false,false,9200, freeTier:'Institutional only', price:0, tips:'Acquired by Crownpeak | Best for high-end fashion | AI-powered curation'),
    t('nosto-ai-pro','Nosto','marketing','Leading personalization platform for e-commerce with AI-powered search.','https://nosto.com',false,true,15000, freeTier:'Demo available', price:0, tips:'One-click personalization | AI-powered content and ads | High conversion ROI'),
    t('dynamic-yield-ai','Dynamic Yield (Mastercard)','marketing','The world\'s most advanced AI personalization platform for enterprise.','https://dynamicyield.com',false,true,25000, freeTier:'Institutional only', price:0, tips:'Owned by Mastercard | AI-powered experience optimization | Trusted by McDonalds'),
    t('e-marketeer-ai','eMarketeer','marketing','Comprehensive marketing automation for SMBs with AI-powered tools.','https://emarketeer.com',true,false,12000, freeTier:'Free trial available', price:25, priceTier:'Standard monthly', tips:'Best for B2B lead generation | AI-powered "Nurture" flows | European leader'),
    t('dot-digital-ai','dotdigital','marketing','Leading customer engagement platform with AI-powered cross-channel.','https://dotdigital.com',false,true,18000, freeTier:'Demo available', price:0, tips:'Best for multi-channel brands | AI-powered "Predictive" search | Enterprise grade'),
    t('sailthru-ai-pro','Sailthru','marketing','Personalized marketing automation for media and retail using high-end AI.','https://sailthru.com',false,true,15000, freeTier:'Institutional only', price:0, tips:'Part of Marigold | Best for large newsletter publishers | High engagement AI'),

    // ━━━ FINAL GEMS v3 ━━━
    t('openai-o1-preview','OpenAI o1','code','New reasoning-focused model from OpenAI for complex logic and math.','https://openai.com/o1',true,true,999999, freeTier:'Limited access for Plus users', price:20, priceTier:'Included in Plus monthly', tips:'Best for intense coding and science | Takes time to "think" | Highest reasoning'),
    t('anthropic-claude-3-5','Claude 3.5 Sonnet','productivity','Anthropic\'s most balanced model for speed and world-class intelligence.','https://claude.ai',true,true,999999, freeTier:'Free basic version available', price:20, priceTier:'Pro monthly for extra limits', tips:'Best coding assistant alongside GPT-4 | High EQ and natural writing | Reliable'),
    t('google-gemini-1-5','Gemini 1.5 Pro','productivity','Google\'s next-gen model with a 2M token context window and native multi-modal.','https://gemini.google.com',true,true,500000, freeTier:'Free version available (Flash)', price:20, priceTier:'Advanced monthly', tips:'Upload entire codebases or videos | Deep Google Workspace integration | Fast'),
    t('meta-llama-3-1','Llama 3.1 (Meta)','code','Meta\'s most powerful open-weights model challenging GPT-4.','https://llama.meta.com',true,true,180000, freeTier:'Completely free open weights', price:0, tips:'Self-host for full privacy | Industry standard for open AI | Best for local devs'),
    t('x-ai-grok-pro','Grok-2 (xAI)','news','Elon Musk\'s xAI model integrated into X with real-time news access.','https://x.ai',false,true,250000, freeTier:'No free tier', price:8, priceTier:'X Premium monthly', tips:'Unfiltered and real-time news | Directly in your X feed | Fast and witty'),
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
