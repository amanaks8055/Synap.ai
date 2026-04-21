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
    // ━━━ AI FOR EMAIL MARKETING (Iconic) ━━━
    t('mail-chimp-ai-pro','Mailchimp','marketing','The #1 email marketing platform with AI-powered "Content Optimizer" and help.','https://mailchimp.com',true,true,999999, freeTier:'Free for up to 500 contacts', price:13, priceTier:'Essentials monthly starting', tips:'AI-powered "Intuit Assist" for emails | Best for small biz | Industry standard'),
    t('klaviyo-ai-pro-mar','Klaviyo','marketing','Leading e-commerce marketing platform with AI-powered "Predictive" data.','https://klaviyo.com',true,true,500000, freeTier:'Free for up to 250 contacts', price:20, priceTier:'Email monthly starting', tips:'Best for Shopify brands | AI-powered "SMS" and flows | high ROI data'),
    t('active-camp-ai-pro','ActiveCampaign','marketing','Leading marketing automation with AI-powered "Win Probability" and help.','https://activecampaign.com',true,true,350000, freeTier:'14-day free trial on site', price:29, priceTier:'Lite monthly annual', tips:'Best for complex B2B flows | AI-powered "Content" helper | robust'),
    t('constant-cont-ai','Constant Contact','marketing','Leading email and social marketing with AI-powered "Campaign Builder".','https://constantcontact.com',true,true,350000, freeTier:'60-day free trial on site', price:12, priceTier:'Lite monthly starting', tips:'Best for non-profits and local biz | AI-powered "Copy" | established'),
    t('send-grid-ai-pro','SendGrid (Twilio)','code','Leading transactional email platform using AI for delivery and security.','https://sendgrid.com',true,true,500000, freeTier:'Free for up to 100 emails/day', price:20, priceTier:'Essentials monthly', tips:'Best for developer emails | AI-powered "Insights" | Owned by Twilio'),
    t('hub-spot-email-ai','HubSpot Email','marketing','Leading CRM-integrated email with AI-powered "Smart Content" and data.','https://hubspot.com/email-marketing',true,true,999999, freeTier:'Free basic version available', price:0, tips:'Part of HubSpot CRM | AI-powered "Optimization" | Scale for teams'),
    t('mailer-lite-ai-pro','MailerLite','marketing','Leading simple and powerful marketing with AI-powered "Drag & Drop".','https://mailerlite.com',true,true,250000, freeTier:'Free for up to 1k subscribers', price:10, priceTier:'Growing Business monthly', tips:'Best value for money | AI-powered "Support" | Cleanest UI'),
    t('convert-kit-ai-pro','ConvertKit','marketing','Leading platform for creators with AI-powered "Automation" and landing.','https://convertkit.com',true,true,350000, freeTier:'Free for up to 1k subscribers', price:15, priceTier:'Creator monthly annual', tips:'Best for bloggers and podcasters | AI-powered "Visual" flows | high trust'),
    t('get-resp-ai-pro','GetResponse','marketing','Global marketing giant with AI-powered "Website Builder" and emails.','https://getresponse.com',true,true,180000, freeTier:'Free basic version available', price:19, priceTier:'Email Marketing monthly', tips:'Best for multi-channel sales | AI-powered "Subject" line generator | Robust'),
    t('be-hive-ai-pro-em','beehiiv','marketing','The next-gen newsletter platform with built-in AI for writers and growth.','https://beehiiv.com',true,true,150000, freeTier:'Free for up to 2.5k subscribers', price:39, priceTier:'Grow monthly annual', tips:'Best for paid newsletters | AI-powered "Ad Network" | blazing fast growth'),

    // ━━━ AI FOR GOLF & TENNIS v2 ━━━
    t('golf-dig-ai-learn','Golf Digest (Play)','lifestyle','Leading golf instruction with AI-powered "Lesson" library and pro help.','https://golfdigest.com',true,true,250000, freeTier:'Free basic articles', price:10, priceTier:'Select monthly', tips:'Learn from Tiger Woods and pros | AI-powered "Ranking" | Industry standard'),
    t('swing-tuna-ai-pro','SwingTuna','lifestyle','AI-powered tennis swing analysis and coach for amateur and pro players.','https://swingtuna.com',true,false,25000, freeTier:'Free trial available', price:0, tips:'Best for improving your serve | AI-powered "Skeleton" tracking | precise'),
    t('tennis-stats-ai','Tennis Analytics','entertainment','Leading data platform for tennis using AI to track play and strategy.','https://tennisanalytics.net',false,false,15000, freeTier:'Institutional only', price:0, tips:'Used by ATP/WTA coaches | AI-powered "Match" tagging | High end data'),
    t('swing-vision-ai','SwingVision','lifestyle','The world\'s #1 AI tennis app for line calling, stats, and coaching.','https://swing.tennis',true,true,120000, freeTier:'Free basic version available', price:15, priceTier:'Pro monthly annual', tips:'Best for recording your matches | AI-powered "Line Calling" | Apple favored'),
    t('golf-rival-ai-pro','Golf Rival (Zynga)','entertainment','Leading arcade golf game using AI for physics and global matchmaking.','https://golfrival.com',true,true,500000, freeTier:'Completely free to play', price:0, tips:'Best for casual fun | AI-powered "Clubs" | Millions of players'),

    // ━━━ AI FOR PILLATES & BARRE ━━━
    t('pure-barre-ai-pro','Pure Barre','health','Leading barre studio app with AI-powered workout schedules and logs.','https://purebarre.com',true,true,150000, freeTier:'Free intro class often', price:0, tips:'Largest barre brand in US | AI-powered "Milestones" | High community focus'),
    t('pilates-ai-any-ti','Pilates Anytime','health','The world\'s largest pilates video library with AI-powered expert matching.','https://pilatesanytime.com',true,true,120000, freeTier:'15-day free trial on site', price:18, priceTier:'Monthly membership', tips:'Access 1k+ pilates videos | AI-powered "Level" filter | high quality instructors'),
    t('alo-moves-ai-pro','Alo Moves','health','Leading lifestyle fitness app with AI-powered yoga, pilates, and barre.','https://alomoves.com',true,true,250000, freeTier:'14-day free trial on site', price:20, priceTier:'Monthly membership', tips:'Best for high aesthetic UI | AI-powered "Series" plans | World class teachers'),
    t('glo-ai-health-pro','Glo','health','Leading yoga and pilates platform using AI for personalized session flows.','https://glo.com',true,true,180000, freeTier:'7-day free trial on site', price:24, priceTier:'Monthly membership', tips:'Best for dedicated practitioners | AI-powered "Pathways" | High trust'),
    t('pilates-ology-ai','Pilatesology','health','The source for classical pilates with AI-powered archive search and help.','https://pilatesology.com',true,false,45000, freeTier:'14-day free trial', price:20, priceTier:'Monthly membership', tips:'Best for Joseph Pilates style | AI-powered "Search" | High quality focus'),

    // ━━━ AI FOR SCIENCE (Meteorology & Climatology v3) ━━━
    t('weather-under-ai','Weather Underground','science','Leading hyper-local weather with AI-powered "PWS" network data.','https://wunderground.com',true,true,999999, freeTier:'Completely free for the public', price:0, tips:'Best for local neighborhood data | AI-powered "Charts" | High accuracy'),
    t('accu-weather-ai','AccuWeather','science','The world\'s #1 weather company using high-end AI "RealFeel" and data.','https://accuweather.com',true,true,999999, freeTier:'Completely free for the public', price:0, tips:'AI-powered "MinuteCast" | Global scale | High reliability'),
    t('dark-sky-ai-apple','Apple Weather (Dark Sky)','science','Apple\'s elite weather app using AI for minute-by-minute rain data.','https://weather.com',true,true,999999, freeTier:'Included with Apple devices', price:0, tips:'Best-in-class UI | AI-powered "Hyperlocal" news | Private and fast'),
    t('weather-channel-ai','The Weather Channel','science','The most trusted global weather source with AI-powered "Force" models.','https://weather.com',true,true,999999, freeTier:'Completely free to use', price:0, tips:'Owned by IBM | AI-powered "Forecast" | Billion user data'),
    t('clima-cell-ai-pro','Tomorrow.io (ClimaCell)','science','The world\'s #1 weather intelligence platform for business with AI.','https://tomorrow.io',true,true,180000, freeTier:'Free basic version for users', price:0, tips:'AI-powered "Micro" weather | Best for ops and airlines | Revolutionary'),

    // ━━━ AI FOR LOGO & BRAND DESIGN ━━━
    t('logo-mkr-ai-pro','LogoMaker (AI)','design','Leading AI-powered logo generator for small business and startups.','https://logomaker.com',true,true,150000, freeTier:'Free to design and preview', price:40, priceTier:'One-time high res download', tips:'Best for fast branding | AI-powered "Vibe" labels | Easy to use'),
    t('brand-mark-ai-pro','Brandmark','design','The world\'s most advanced AI logo design system for clean branding.','https://brandmark.io',true,true,120000, freeTier:'Free to generate and see', price:25, priceTier:'Basic one-time', tips:'Best for modern and minimal logos | AI-powered "Brand" color palette'),
    t('looka-ai-design','Looka','design','Leading AI platform for making logos and full brand kits in minutes.','https://looka.com',true,true,250000, freeTier:'Free to design and preview', price:20, priceTier:'Basic logo one-time', tips:'Best for comprehensive brand kits | AI-powered "Business" cards | Clean UI'),
    t('tailor-brands-ai','Tailor Brands','design','All-in-one platform for business with AI-powered logo and LLC help.','https://tailorbrands.com',true,true,350000, freeTier:'Free to design and preview', price:10, priceTier:'Premium monthly annual', tips:'Best for starting a new biz | AI-powered "Digital" tools | high reach'),
    t('logomi-ai-pro-gen','LogoAI','design','Professional AI-powered logo creator with social media brand help.','https://logoai.com',true,false,84000, freeTier:'Free to try and see', price:29, priceTier:'Basic package one-time', tips:'Best for diverse styles | AI-powered "Icon" matching | solid quality'),

    // ━━━ FINAL GEMS v33 (Modern Dev Tools) ━━━
    t('postman-ai-pro-api','Postman','code','The world\'s #1 API platform with new AI-powered "Postman AI" assistant.','https://postman.com',true,true,999999, freeTier:'Free for personal starters', price:12, priceTier:'Basic monthly annual', tips:'AI-powered "Test" generation | Best for API dev and test | Industry standard'),
    t('insom-nia-ai-api','Insomnia (Kong)','code','Leading open-source API client with AI-powered design and test help.','https://insomnia.rest',true,true,350000, freeTier:'Completely free open source', price:0, tips:'Best for GraphQL and REST | AI-powered "Plugin" system | Clean UI'),
    t('hopp-scotch-ai-o','Hoppscotch','code','The lightweight and open-source API development tool with AI sync.','https://hoppscotch.io',true,true,150000, freeTier:'Completely free forever', price:0, tips:'Fastest way to test APIs | AI-powered "Share" | modern and clean'),
    t('rapid-api-ai-pro','RapidAPI (Digital)','code','The world\'s largest API marketplace with AI-powered "Hub" and data help.','https://rapidapi.com',true,true,500000, freeTier:'Free basic version for many APIs', price:0, tips:'Find every API in the world | AI-powered "Testing" | Globally trusted'),
    t('apigee-ai-pro-gg','Apigee (Google)','code','Leading enterprise API management with high-end AI security and logs.','https://apigee.com',true,true,250000, freeTier:'Free trial available on Google Cloud', price:0, tips:'The enterprise standard for APIs | AI-powered "Threat" detect | robust scale'),
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
