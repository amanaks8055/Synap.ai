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
    // ━━━ AI FOR MUSIC PRODUCTION v2 ━━━
    t('izotope-ai-pro','iZotope (Ozone)','audio','The industry standard for AI-powered mastering and mixing tools.','https://izotope.com',true,true,120000, freeTier:'Free basic plugins available', price:20, priceTier:'Subscription monthly', tips:'AI-powered "Master Assistant" | Best for professional sound | Trusted by top artists'),
    t('landr-ai-pro','LANDR','audio','The world\'s #1 AI mastering service with additional distribution and labs.','https://landr.com',true,true,180000, freeTier:'Free basic account and samples', price:12, priceTier:'Studio monthly annual', tips:'Master your tracks in seconds with AI | Includes distribution to Spotify | reliable'),
    t('splice-ai-pro','Splice','audio','Leading cloud-based sample library with AI-powered "Co-Stack" and search.','https://splice.com',true,true,250000, freeTier:'Free basic account to browse', price:10, priceTier:'Creator monthly', tips:'AI-powered "Bridge" for your DAW | Millions of royalty-free samples | Industry standard'),
    t('native-instruments-ai','Native Instruments','audio','Leading music technology company using AI for high-end virtual instruments.','https://native-instruments.com',true,true,150000, freeTier:'免费 basic software bundle', price:0, tips:'Industry standard for VSTs | AI-powered "Kontakt" engine | Professional grade'),
    t('waves-ai-pro','Waves Audio','audio','Leading provider of high-end audio plugins with AI-powered mixing.','https://waves.com',true,false,84000, freeTier:'Free demo for all plugins', price:15, priceTier:'Essential monthly subscription', tips:'Industry standard for studios | AI-powered "Clarity Vx" | Used on 100k+ hits'),
    t('fab-filter-ai-pro','FabFilter','audio','Leading developer of visual and high-quality audio plugins for pros.','https://fabfilter.com',true,false,45000, freeTier:'30-day free trial on all', price:0, tips:'Best for visual EQ and compression | AI-powered "Learning" | High accuracy'),
    t('sound-stack-ai','Soundstack','audio','Leading platform for audio streaming and delivery using AI.','https://soundstack.com',false,false,12000, freeTier:'Institutional only', price:0, tips:'Scale your radio or podcast with AI | High performance delivery | Strategic'),
    t('audius-ai-pro','Audius','audio','Decentralized music streaming platform using AI for discovery and rights.','https://audius.co',true,true,58000, freeTier:'Completely free to use', price:0, tips:'Best for indie artists | AI-powered "Trending" | Web3 integrated'),
    t('tune-core-ai','TuneCore','audio','Leading music distribution platform with AI-powered "Social" tools.','https://tunecore.com',true,true,120000, freeTier:'Free to join and learn', price:20, priceTier:'Rising Artist yearly', tips:'Owned by Believe | AI-powered "Breakout" reports | Reach all platforms'),
    t('distro-kid-ai','DistroKid','audio','The easiest way for musicians to get music onto Spotify and Apple with AI.','https://distrokid.com',true,true,250000, freeTier:'No free tier', price:22, priceTier:'Musician yearly', tips:'Most popular distrubutor | AI-powered "Sync" | Fast and simple'),

    // ━━━ AI FOR AVIATION & PILOTS ━━━
    t('fore-flight-ai','ForeFlight (Boeing)','business','Leading flight planning and navigation for pilots with AI-powered weather.','https://foreflight.com',false,true,150000, freeTier:'30-day free trial for students', price:100, priceTier:'Basic Plus yearly', tips:'Owned by Boeing | AI-powered "Meteorology" | The gold standard for iPad pilots'),
    t('garmin-pilot-ai','Garmin Pilot','business','Leading aviation app with AI-powered flight routing and data.','https://garmin.com/aviation',false,true,120000, freeTier:'30-day free trial', price:80, priceTier:'Standard yearly starting', tips:'Integrated with Garmin hardware | AI-powered fuel planning | Reliable'),
    t('flight-radar-ai','Flightradar24','business','The world\'s most popular flight tracker using AI to predict arrivals.','https://flightradar24.com',true,true,999999, freeTier:'Completely free basic version', price:10, priceTier:'Silver monthly', tips:'Track Every plane in real-time | AI-powered "Alerts" | Huge global network'),
    t('flight-aware-ai','FlightAware (Collins)','business','Global flight tracking and intelligence platform with high-end AI labs.','https://flightaware.com',true,true,500000, freeTier:'Free basic version for public', price:0, tips:'Owned by Raytheon | AI-powered "Predicter" for delays | Industry leader'),
    t('claire-ai-flight','Claire (Astro)','business','AI-powered personal pilot and flight planning assistant for light aircraft.','https://astro.claire.ai',false,false,5600, freeTier:'Beta access only', price:0, tips:'AI-powered safety checklists | Voice control in cockpit | Innovative'),
    t('wing-ai-pro','Wing (Google)','business','Google\'s autonomous drone delivery platform with AI-powered routing.','https://wing.com',true,true,84000, freeTier:'Free app for users', price:0, tips:'Get food/coffee delivered by drone | AI-powered safety | Operating in 3 countries'),
    t('zipline-ai-pro','Zipline','health','Leading drone delivery for healthcare using AI for long-range autonomous.','https://flyzipline.com',false,true,58000, freeTier:'Institutional only', price:0, tips:'Saves lives in Rwanda/Ghana with AI | Global leader in drone logistics | scale'),
    t('joby-aviation-ai','Joby Aviation','business','Leading electric vertical takeoff and landing (eVTOL) with AI pilot.','https://jobyaviation.com',false,true,45000, freeTier:'Institutional only', price:0, tips:'The future of urban flight with AI | Quiet and electric | Strategic partner of Uber'),
    t('archer-aviation-ai','Archer Aviation','business','Leading electric flight company using AI for urban air mobility (UAM).','https://archer.com',false,false,25000, freeTier:'Institutional only', price:0, tips:'Partner of United Airlines | AI-powered "Midnight" aircraft | Silicon Valley base'),
    t('lilium-ai-pro','Lilium','business','German electric jet company using AI for vertical flight and city travel.','https://lilium.com',false,false,15000, freeTier:'Institutional only', price:0, tips:'First electric jet with AI control | High-end luxury focus | European leader'),

    // ━━━ AI FOR JOURNALISM & MEDIA v2 ━━━
    t('reuters-ai-pro','Reuters (Professional)','marketing','Leading global news agency using AI for visual verification and speed.','https://reuters.com',true,true,999999, freeTier:'Free to browse public news', price:35, priceTier:'Professional monthly base', tips:'The world\'s most trusted news source | AI-powered "Agency" feed | Reliable'),
    t('bloomberg-ai-pro','Bloomberg (Terminal)','business','The gold standard for financial news and data using high-end AI.','https://bloomberg.com',false,true,250000, freeTier:'Limited free articles online', price:2000, priceTier:'Terminal monthly starting', tips:'AI-powered "B-Pipe" data | Industry legend | Best for professional traders'),
    t('wsj-ai-pro','The Wall Street Journal','business','Leading business news with AI-powered "Market Watch" and summaries.','https://wsj.com',true,true,500000, freeTier:'Occasional free articles', price:5, priceTier:'Digital monthly (promo)', tips:'Best for market news | AI-powered "Personalized" feed | Iconic and reliable'),
    t('ft-ai-pro','Financial Times','business','Leading global business newspaper using AI for high-end data analysis.','https://ft.com',true,true,350000, freeTier:'Limited free articles', price:15, priceTier:'Digital monthly starting', tips:'European business leader | AI-powered "Charts" | High intellectual rigor'),
    t('economist-ai-pro','The Economist','business','Leading global magazine using AI for trend prediction and narrations.','https://economist.com',true,true,250000, freeTier:'Limited free articles', price:20, priceTier:'Digital monthly starting', tips:'Award-winning data journalism | AI-powered "Audio" edition | Strategic'),
    t('new-york-times-ai','The New York Times','marketing','Leading news platform with AI-powered "Audio" and personalization.','https://nytimes.com',true,true,999999, freeTier:'Limited free articles monthly', price:4, priceTier:'Digital monthly (promo)', tips:'Most awarded journalism | AI-powered "Games" and "Cooking" | Global scale'),
    t('guardian-ai-news','The Guardian','marketing','Leading independent news organization with AI-powered app and feed.','https://theguardian.com',true,true,500000, freeTier:'Completely free online', price:0, tips:'Supported by readers | AI-powered "Topic" search | high quality coverage'),
    t('ap-news-ai','AP News','marketing','Leading news agency using AI to automate local sports and data reports.','https://apnews.com',true,true,500000, freeTier:'Completely free for everyone', price:0, tips:'The power behind the news | AI-powered "Fact Check" | Global presence'),
    t('news-api-pro','News API','code','Leading developer tool for searching and tracking live news across the web with AI.','https://newsapi.org',true,true,84000, freeTier:'Free for personal/dev work', price:449, priceTier:'Business monthly', tips:'Best for building news apps | AI-powered "Sentiment" and "Source" filters | Fast'),
    t('gdelt-project-ai','GDELT Project','science','The largest open database of human society using AI to track global events.','https://gdeltproject.org',true,true,42000, freeTier:'Completely free forever', price:0, tips:'Backed by Google | AI tracks 100+ languages | Most powerful for researchers'),

    // ━━━ AI FOR RELIGION & SPIRITUALITY v2 ━━━
    t('you-version-ai','YouVersion (Bible App)','education','The world\'s most popular Bible app with AI-powered reading plans.','https://bible.com',true,true,999999, freeTier:'Completely free forever', price:0, tips:'AI-powered "Verse of the Day" | Millions of users | Community of faith'),
    t('abide-ai-prayer','Abide','health','Leading Christian meditation and prayer app with AI-powered guides.','https://abide.co',true,true,150000, freeTier:'Free basic meditations', price:10, priceTier:'Premium monthly', tips:'Best for restful sleep | AI-powered "Bible" stories | High engagement'),
    t('hallow-ai-pro','Hallow','health','Leading Catholic prayer and meditation app with AI-powered sessions.','https://hallow.com',true,true,250000, freeTier:'Free basic sessions', price:9, priceTier:'Premium monthly', tips:'Best for daily rituals | AI-powered "Bible in a Year" | High quality audio'),
    t('muslim-pro-ai','Muslim Pro','health','Leading app for Muslims with AI-powered accurate prayer times and Quran.','https://muslimpro.com',true,true,999999, freeTier:'Free basic version with ads', price:0, tips:'Most trusted in the world | AI-powered "Qibla" finder | Community centric'),
    t('chabad-ai-search','Chabad.org','education','Leading Jewish knowledge hub using AI for vast text search and learning.','https://chabad.org',true,true,350000, freeTier:'Completely free forever', price:0, tips:'Access thousands of articles | AI-powered "Ask the Rabbi" database | Global'),
    t('sikh-it-ai','SikhNet','education','Leading platform for Sikh news and music with AI-powered translations.','https://sikhnet.com',true,false,58000, freeTier:'Completely free forever', price:0, tips:'Best for devotional music | AI-powered "Guru Granth" search | Global reach'),
    t('tao-ai-pro','Tao-AI','health','AI-powered meditation and wisdom guide based on ancient Taoist texts.','https://tao-ai.info',true,false,12000, freeTier:'Free basic version', price:0, tips:'Find balance with AI | Personalized wisdom daily | Minimalist design'),
    t('dhamma-ai-pro','Dhamma.org (Vipassana)','health','The world library of Vipassana meditation with AI-powered course finder.','https://dhamma.org',true,true,250000, freeTier:'Completely free (Donation only)', price:0, tips:'Pure non-commercial meditation | AI-powered "Location" search | 100+ centers'),
    t('plum-village-ai','Plum Village','health','Mindfulness app from the tradition of Thich Nhat Hanh with AI support.','https://plumvillage.app',true,true,120000, freeTier:'Completely free forever', price:0, tips:'Beautiful bell of mindfulness | AI-powered "Deep Relaxation" | High quality'),
    t('zen-ai-pro','Zen AI','health','Modern Zen meditation and koan search engine using AI for wisdom.','https://zen-ai.com',true,false,45000, freeTier:'Free to browse', price:0, tips:'Find silence in a noisy world | AI-powered "Koan" helper | Philosophical'),

    // ━━━ FINAL GEMS v15 (Cloud Foundations) ━━━
    t('aws-lambda-ai','AWS Lambda','code','Leading serverless compute platform for running AI and data functions.','https://aws.amazon.com/lambda',true,true,999999, freeTier:'Free for up to 1M requests/month', price:0, tips:'The industry standard for serverless | AI-powered "Compute" | Part of Amazon'),
    t('gcp-functions-ai','Google Cloud Functions','code','Scalable serverless platform for building AI-driven event workflows.','https://cloud.google.com/functions',true,true,500000, freeTier:'Free for up to 2M requests/month', price:0, tips:'Deeply integrated with AI APIs | Best for Google ecosystem | High performance'),
    t('azure-functions-ai','Azure Functions','code','Microsoft\'s event-driven serverless platform for AI and backend.','https://azure.microsoft.com/functions',true,true,350000, freeTier:'Free for up to 1M requests/month', price:0, tips:'Best for enterprise apps | AI-powered "Durable Functions" | Robust'),
    t('supabase-edge-ai','Supabase Edge Functions','code','Scalable TypeScript functions close to your users with AI support.','https://supabase.com/edge-functions',true,true,180000, freeTier:'Free tier for developers', price:0, tips:'Built on Deno (fast) | Native TypeScript | Best for Supabase apps'),
    t('cloudflare-workers-ai','Cloudflare Workers AI','code','Run AI models directly on the edge across 300+ cities globally.','https://workers.ai',true,true,250000, freeTier:'Free basic daily requests', price:0, tips:'Lowest latency in the world | AI-powered "Inference" on edge | Game changer'),
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
