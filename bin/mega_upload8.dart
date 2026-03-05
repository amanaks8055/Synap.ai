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
    // ━━━ SOCIAL MEDIA (Advanced) ━━━
    t('later-ai','Later','marketing','Social media scheduler with AI captions and visual planning for Instagram.','https://later.com',true,true,6800, freeTier:'Free for 1 account', price:18, priceTier:'Starter: 30 posts per profile', tips:'Best visual planner for IG | AI caption generator | Linkin.bio feature'),
    t('sprout-social-ai','Sprout Social','marketing','Enterprise social media management with AI-powered listening and analytics.','https://sproutsocial.com',false,true,4200, freeTier:'30-day free trial', price:249, priceTier:'Standard per user monthly', tips:'Best-in-class analytics | Team collaborative workflows | AI sentiment analysis'),
    t('hootsuite-ai','Hootsuite (OwlyWriter)','marketing','Leading social media manager with OwlyWriter AI for post creation.','https://hootsuite.com',false,false,5600, freeTier:'30-day free trial', price:99, priceTier:'Professional per month', tips:'Manage 20+ social networks | AI suggests content ideas | Detailed reporting'),
    t('buffer-ai','Buffer','marketing','Simple social media scheduling with AI assistant for repurposing content.','https://buffer.com',true,true,8400, freeTier:'Free for up to 3 channels', price:6, priceTier:'Essentials: unlimited posts', tips:'Cleanest UI in social management | AI helps rewrite posts | Link-in-bio page'),
    t('prowly-ai','Prowly (SEMrush)','marketing','AI PR platform for media relations and press release distribution.','https://prowly.com',true,false,1800, freeTier:'7-day free trial', price:189, priceTier:'Pro: 1000 emails per month', tips:'Identify journalists with AI | PR metrics tracking | Integrated with SEMrush'),

    // ━━━ VIDEO MEETINGS AI ━━━
    t('zoom-ai-companion','Zoom AI Companion','support','AI assistant for Zoom that summarizes meetings and drafts chats.','https://zoom.us',true,true,45000, freeTier:'Included in paid Zoom plans', price:15, priceTier:'Pro plan starting price', tips:'Catch up during meetings | Smart chapter markers | Draft email follow-ups'),
    t('google-meet-duet','Google Meet (Duet)','support','AI-powered enhancements for Google Meet (lighting, sound, notes).','https://meet.google.com',true,true,38000, freeTier:'Standard Meet is free', price:18, priceTier:'Google Workspace add-on', tips:'AI studio lighting and sound | Automatic meeting notes | Translation in real-time'),
    t('microsoft-teams-premium','Teams Premium','support','Microsoft AI for meetings with intelligent recap and live translation.','https://microsoft.com/teams',false,true,32000, freeTier:'Standard Teams available', price:7, priceTier:'Premium add-on per user', tips:'AI-generated tasks from meetings | Personalized timeline markers | Advanced security'),
    t('around-ai','Around','support','AI-powered video calls designed for hybrid teams with anti-fatigue UI.','https://around.co',true,false,4800, freeTier:'Free for up to 45 min calls', price:15, priceTier:'Pro: unlimited calls', tips:'Circle video frames | AI background noise removal | High performance web app'),
    t('gather-town-ai','Gather','social','Virtual office for remote teams with AI interactions and spatial audio.','https://gather.town',true,false,6200, freeTier:'Free for up to 10 users', price:7, priceTier:'Per user for larger teams', tips:'Gamified office experience | Spatial audio for natural convos | "Private areas" for meetings'),

    // ━━━ REVIEW & REPUTATION ━━━
    t('trustpilot-ai','Trustpilot AI','marketing','Leading review platform with AI for fraud detection and sentiment.','https://trustpilot.com',true,true,84000, freeTier:'Free profile for businesses', price:0, tips:'Industry standard for trust | AI detects fake reviews | Review widgets for web'),
    t('g2-crowd-ai','G2','marketing','Leading B2B software review site with AI-powered comparisons.','https://g2.com',true,true,56000, freeTier:'Free for users', price:0, tips:'Verified user reviews | Grid reports compare competitors | Best for enterprise software'),
    t('capterra-ai','Capterra','marketing','Directory for software reviews with AI filtering and suggestions.','https://capterra.com',true,false,42000, freeTier:'Free for users', price:0, tips:'Owned by Gartner | Good for SMB software | Guided search filters'),
    t('yelp-ai','Yelp AI','marketing','Local business reviews with AI-powered summaries and search.','https://yelp.com',true,false,120000, freeTier:'Free for users', price:0, tips:'Best for restaurants in US | AI highlights popular dishes | Local service quotes'),
    t('app-store-ai','Apple App Store','social','AI-powered app discovery and review sentiment analysis.','https://apple.com/app-store',true,true,200000, freeTier:'Free to browse', price:0, tips:'Curation by Apple editors | Personalized "For You" | High quality standard'),

    // ━━━ HR & PAYROLL (Advanced) ━━━
    t('rippling-ai','Rippling','hr','Unified Workforce Platform for HR, IT, and Finance with AI automation.','https://rippling.com',false,true,5800, freeTier:'Demo available', price:8, priceTier:'Per user per month', tips:'Automate employee onboarding | Manage IT and HR in one | Global payroll built-in'),
    t('gusto-ai','Gusto','hr','HR and payroll platform for small businesses with AI tax filing.','https://gusto.com',false,true,4200, freeTier:'Demo available', price:40, priceTier:'Standard monthly + \$6/person', tips:'Easiest payroll for startups | Automatic tax filing | Employee benefits management'),
    t('bamboo-hr-ai','BambooHR','hr','Human resources software with AI reporting and performance tools.','https://bamboohr.com',false,false,3400, freeTier:'Free trial available', price:0, tips:'Beautiful employee database | Goal tracking | Employee satisfaction surveys (eNPS)'),
    t('hi-bob-ai','HiBob','hr','Modern HR platform for mid-sized companies with AI-powered insights.','https://hibob.com',false,false,2800, freeTier:'Demo available', price:0, tips:'"Social media style" feed | Global culture focus | Advanced people analytics'),
    t('deel-ai','Deel','hr','Global payroll and compliance platform with AI-powered contract generation.','https://deel.com',true,true,8400, freeTier:'Free starting tools', price:49, priceTier:'Per contractor per month', tips:'Hire anyone globally in minutes | Built-in compliance | Local currency payouts'),

    // ━━━ SPACE & WEATHER (Advanced) ━━━
    t('spacex-ai','SpaceX Starlink AI','science','Satellite constellation management with AI for collision avoidance.','https://starlink.com',false,true,18000, freeTier:'Hardware purchase required', price:120, priceTier:'Monthly service', tips:'Global high-speed internet | AI manages 5000+ satellites | Essential for remote areas'),
    t('nasa-earth-ai','NASA Earth Data','science','Access to NASA\'s satellite data with AI for climate and ocean research.','https://earthdata.nasa.gov',true,true,12000, freeTier:'Completely free open access', price:0, tips:'25PB+ of satellite data | Use for climate research | Global fire and flood monitoring'),
    t('accuweather-ai','AccuWeather','science','High-precision weather forecasting with AI for extreme weather alerts.','https://accuweather.com',true,false,45000, freeTier:'Free with ads', price:1, priceTier:'Premium: ad-free and hourly stats', tips:'Realfeel temperature | MinuteCast minute-by-minute stats | Accurate local alerts'),
    t('windy-ai','Windy.com','science','Visual weather forecasting with AI for pilots and sailors.','https://windy.com',true,true,15000, freeTier:'Free high-res maps', price:2, priceTier:'Premium: 1-hour intervals and more data', tips:'Best visual weather maps | Professional flight planning | Global storm tracking'),
    t('weather-company-ai','The Weather Channel (IBM)','science','The world\'s most accurate weather forecaster powered by IBM Watson.','https://weather.com',true,true,38000, freeTier:'Free with ads', price:0, tips:'IBM Watson-powered hyper-local data | Severe weather warnings | Health and allergy alerts'),

    // ━━━ ALTERNATIVE SEARCH ENGINES ━━━
    t('duckduckgo-ai','DuckDuckGo DuckAssist','search','Privacy-focused search engine with AI-generated answer summaries.','https://duckduckgo.com',true,true,45000, freeTier:'Completely free forever', price:0, tips:'No tracking or ads | DuckAssist summarizes Wiki | Best for privacy'),
    t('brave-search-ai','Brave Leo','search','Privacy search engine with native Leo AI assistant.','https://search.brave.com',true,true,15000, freeTier:'Completely free', price:0, tips:'Independent search index | Leo AI in browser | No personalized tracking'),
    t('you-search-ai','You.com','search','The AI search engine with specialized modes for coding and writing.','https://you.com',true,true,12000, freeTier:'Free daily AI queries', price:10, priceTier:'Pro: unlimited fast GPT-4/Claude', tips:'Write entire papers with AI | Specialized coding mode | Privacy-first approach'),
    t('neva-search-ai','Neeva (Snowflake)','search','Privacy-first ad-free search engine acquired by Snowflake for AI.','https://neva.com',false,false,3400, freeTier:'Retired (now Enterprise AI)', price:0, tips:'Ad-free experience | Connected personal accounts | Now part of Snowflake Cortex'),
    t('consensus-ai','Consensus','research','AI search engine for scientific research that answers via peer-reviewed papers.','https://consensus.app',true,true,8400, freeTier:'Free unlimited basic search', price:10, priceTier:'Premium: GPT-4 summaries', tips:'Evidence-based answers | Cite sources automatically | Best for science and health'),

    // ━━━ NEWS AGGREGATORS (Advanced) ━━━
    t('flipboard-ai','Flipboard','news','Personalized magazine with AI curation from 1000s of sources.','https://flipboard.com',true,true,15000, freeTier:'Completely free app', price:0, tips:'Beautiful magazine UI | Follow specific interests | Curation by experts'),
    t('pocket-ai','Pocket (Mozilla)','news','Read-it-later app with AI-powered summaries and reading lists.','https://getpocket.com',true,true,12000, freeTier:'Free basic saving', price:5, priceTier:'Premium: full text search and tag suggestions', tips:'Save anything to read later | AI summaries for long articles | High quality reading time'),
    t('instapaper-ai','Instapaper','news','Simple read-it-later tool with premium AI reading speed features.','https://instapaper.com',true,false,4800, freeTier:'Free basic saving', price:3, priceTier:'Premium: speed reading and search', tips:'Highest legibility focus | Speed reading mode | Highlight and annotate'),
    t('news-minimalist','News Minimalist','news','AI-powered news filter that identifies the top 0.1% of important news.','https://newsminimalist.com',true,false,2600, freeTier:'Free daily newsletter', price:0, tips:'Avoid news noise | Only "Significant" events | AI-powered filter'),
    t('smart-news-ai','SmartNews','news','Breaking news app with AI for local and world headlines.','https://smartnews.com',true,false,15000, freeTier:'Completely free with ads', price:0, tips:'Fastest breaking alerts | Offline mode | Good for local news'),

    // ━━━ MORE ART & CULTURE ━━━
    t('behance-ai','Behance (Adobe)','social','Leading showcase for creative work with AI-powered discovery.','https://behance.net',true,true,35000, freeTier:'Free to join and browse', price:0, tips:'Owned by Adobe | Find inspirations from top designers | Hire creative talent'),
    t('dribbble-ai','Dribbble','social','The world\'s top design community for inspiration and hiring.','https://dribbble.com',true,true,28000, freeTier:'Free basic access', price:0, tips:'Best for UI/UX inspiration | High barrier to entry (invite only for designers) | Pro for hiring'),
    t('artstation-ai','ArtStation','social','Leading community for professional digital artists and game devs.','https://artstation.com',true,true,32000, freeTier:'Free basic portfolio', price:10, priceTier:'Plus: ad-free and better portfolio', tips:'Standard for AAA artists | Epic Games owned | Huge marketplace'),
    t('deviantart-dreamup','DeviantArt DreamUp','social','The world\'s largest art community with native AI art generator.','https://deviantart.com',true,false,45000, freeTier:'Free community access', price:4, priceTier:'Core membership for AI features', tips:'AI generation with credit to artists | Longest running art site | Huge diversity'),
    t('vimeo-ai','Vimeo','video','Professional video hosting platform with AI editing and transcription.','https://vimeo.com',true,false,18000, freeTier:'Free basic hosting', price:12, priceTier:'Starter: 60 videos per year', tips:'Best for professional portfolios | High quality player | Creative tools built-in'),

    // ━━━ MISC LIFESTYLE ━━━
    t('goodreads-ai','Goodreads','social','Leading platform for books and reading with AI recommendations.','https://goodreads.com',true,true,45000, freeTier:'Completely free platform', price:0, tips:'Amazon owned | Track your reading | Best book reviews globally'),
    t('letterboxd-ai','Letterboxd','social','Social network for film lovers with AI-powered personalized lists.','https://letterboxd.com',true,true,28000, freeTier:'Free basic logging', price:1, priceTier:'Pro: ad-free and stats', tips:'Best community for cinephiles | Beautiful UI | Diary for every movie'),
    t('strava-lifestyle','Strava','social','Social network for athletes with AI safety and heatmaps.','https://strava.com',true,true,35000, freeTier:'Free basic tracking', price:6, priceTier:'Subscription for routes and metrics', tips:'Heatmaps for popular routes | Safety tracking Beacon | Best for cycling/running'),
    t('discovery-plus-ai','Discovery+','entertainment','Streaming service with AI-powered content personalization.','https://discoveryplus.com',false,false,15000, freeTier:'7-day free trial', price:5, priceTier:'Monthly with ads', tips:'Best for documentaries and reality | Food Network and HGTV | Multiple devices'),
    t('hulu-ai','Hulu','entertainment','Leading streaming platform with AI-powered viewing recommendations.','https://hulu.com',false,true,45000, freeTier:'30-day free trial', price:8, priceTier:'Ad-supported monthly', tips:'Next-day network TV | Huge library of exclusives | Disney Bundle saving'),
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
