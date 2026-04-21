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
    // ━━━ AI FOR SOCIAL MEDIA & MARKETING (Iconic) ━━━
    t('buffer-ai-pro-post','Buffer','marketing','Leading social media scheduler with AI-powered "Buffer AI" for content.','https://buffer.com',true,true,999999, freeTier:'Free for up to 3 social accounts', price:6, priceTier:'Essentials monthly per channel', tips:'Best for simple and clean scheduling | AI-powered "Ideas" | Industry legend'),
    t('hoot-suite-ai-pro','Hootsuite','marketing','Leading enterprise social management with AI-powered "OwlyWriter".','https://hootsuite.com',true,true,500000, freeTier:'30-day free trial on site', price:99, priceTier:'Professional monthly starting', tips:'Best for large teams and brands | AI-powered "Captions" | Robust data'),
    t('sprout-social-ai','Sprout Social','marketing','Leading social listening and management with high-end AI insights.','https://sproutsocial.com',true,true,350000, freeTier:'30-day free trial on site', price:249, priceTier:'Standard monthly starting', tips:'Best for social listening and ROI | AI-powered "Sentiment" | High end'),
    t('later-ai-pro-post','Later','marketing','Leading visual social scheduler for Instagram and TikTok with AI.','https://later.com',true,true,500000, freeTier:'Free basic version available', price:18, priceTier:'Starter monthly annual', tips:'Best for influencers | AI-powered "Best Time to Post" | visual focus'),
    t('planoly-ai-pro','Planoly','marketing','Leading visual planner for Instagram using AI for captions and grids.','https://planoly.com',true,true,250000, freeTier:'Free forever basic version', price:11, priceTier:'Starter monthly', tips:'Best for aesthetic feeds | AI-powered "Content" helper | clean UI'),
    t('loomly-ai-pro-post','Loomly','marketing','Leading brand success platform with AI-powered post ideas and tips.','https://loomly.com',true,true,180000, freeTier:'15-day free trial on site', price:32, priceTier:'Base monthly annual', tips:'Best for small/medium teams | AI-powered "Approval" workflow | Reliable'),
    t('tailwind-ai-pro-pin','Tailwind','marketing','Leading tool for Pinterest and Instagram with AI-powered ghostwriter.','https://tailwindapp.com',true,true,150000, freeTier:'Free forever basic version', price:15, priceTier:'Pro monthly', tips:'Best for Pinterest growth | AI-powered "SmartLoop" | High efficiency'),
    t('social-bee-ai-pro','SocialBee','marketing','Leading social media management with AI-powered "Co-pilot" and recycling.','https://socialbee.com',true,true,120000, freeTier:'14-day free trial on site', price:24, priceTier:'Bootstrap monthly', tips:'Best for content recycling | AI-powered "Automation" | robust'),
    t('meet-edgar-ai-pro','MeetEdgar','marketing','Leading social automation tool that writes and schedules with AI.','https://meetedgar.com',true,false,84000, freeTier:'7-day free trial on site', price:30, priceTier:'Eddie monthly', tips:'Best for small biz evergreen content | AI-powered "Variations" | Fun brand'),
    t('co-schedule-ai-pro','CoSchedule','marketing','Leading marketing calendar with AI-powered "Marketing Intelligence".','https://coschedule.com',true,true,150000, freeTier:'Free forever marketing calendar', price:29, priceTier:'Pro monthly annual', tips:'Best for content teams | AI-powered "Headline" analyzer | high quality'),

    // ━━━ AI FOR GOLF & SPORTS TECH ━━━
    t('18-birdies-ai-golf','18Birdies','lifestyle','The world\'s #1 golf app with AI-powered "Swing" analysis and GPS.','https://18birdies.com',true,true,150000, freeTier:'Free basic version available', price:10, priceTier:'Premium monthly', tips:'AI-powered "Swing Coach" is magic | Best for improving your game | Huge community'),
    t('the-grint-ai-golf','TheGrint','lifestyle','Leading golf handicap and social app with AI-powered GPS and stats.','https://thegrint.com',true,true,120000, freeTier:'Free basic version', price:5, priceTier:'Pro monthly', tips:'Official USGA handicap link | AI-powered "Insights" | robust social features'),
    t('swing-id-ai-pro','SwingID','lifestyle','Leading Apple Watch golf app using AI for swing speed and metrics.','https://golfshot.com',true,true,84000, freeTier:'Free trial available', price:5, priceTier:'Pro monthly', tips:'Best for Apple Watch users | AI-powered "Track" | High accuracy'),
    t('arcco-ai-pro-golf','Arccos Golf','lifestyle','Leading golf tracking system using AI-powered "Caddie" advice.','https://arccosgolf.com',false,true,58000, freeTier:'Hardware purchase required', price:155, priceTier:'Yearly subscription', tips:'Used by pro golfers | AI-powered "Adjusted" distances | High tech sensors'),
    t('golf-shot-ai-gps','Golfshot','lifestyle','Leading golf GPS with AI-powered "Auto Shot" tracking and Siri.','https://golfshot.com',true,true,150000, freeTier:'Free basic version', price:5, priceTier:'Pro monthly', tips:'Award winning GPS | AI-powered "Voice" commands | Reliable and fast'),

    // ━━━ AI FOR MOBILITY & POSTURE ━━━
    t('go-wov-ai-stretch','GOWOD','health','Leading mobility and stretching app for athletes with AI-powered tests.','https://gowod.app',true,true,120000, freeTier:'Free limited version', price:10, priceTier:'Premium monthly', tips:'Best for CrossFit and gymnastics | AI-powered "Mobility" score | High quality'),
    t('rom-wad-ai-pro','Pliability (ROMWAD)','health','The original mobility app with AI-powered daily routines and plans.','https://pliability.com',true,true,150000, freeTier:'7-day free trial on site', price:18, priceTier:'Monthly membership', tips:'Best for long-form stretching | AI-powered "Body" checks | Trusted brand'),
    t('posture-360-ai','Posture360','health','Wearable and app using AI to correct and track posture in real-time.','https://posture360.com',false,false,15000, freeTier:'Institutional only', price:0, tips:'AI-powered "Haptic" feedback | Best for office workers | Clinical focus'),
    t('upright-ai-pro-pos','Upright','health','Leading smart posture trainer using AI to build back health.','https://uprightpose.com',false,true,84000, freeTier:'Hardware purchase required', price:0, tips:'AI-powered "Training" plans | Best for back pain | high social engagement'),
    t('k-force-ai-pro','K-FORCE (Kinesia)','health','Professional kinesiology platform using AI and sensors for rehab data.','https://k-invent.com',false,false,12000, freeTier:'Institutional only', price:0, tips:'Best for physiotherapists | AI-powered "Force" plates | European tech'),

    // ━━━ AI FOR PALEONTOLOGY & ARCHAEOLOGY v2 ━━━
    t('dino-map-ai-pro','Dinosaur Picture (AI)','science','The world\'s most popular dinosaur database with AI-powered "Street" maps.','https://dinosaurpictures.org',true,true,999999, freeTier:'Completely free to use', price:0, tips:'Find fossils near your city | AI-powered 3D visualization | Educational jewel'),
    t('dino-checker-ai','DinoChecker','science','Leading search for dinosaur facts and discoveries using AI analytics.','https://dinochecker.com',true,true,84000, freeTier:'Completely free for the public', price:0, tips:'Access 1k+ species data | AI-powered "Compare" | reliable and fast'),
    t('archeo-data-ai','Archaeology Data (AI)','science','Leading portal for archaeological archives using AI for digitization.','https://archaeologydataservice.ac.uk',true,true,15000, freeTier:'Completely free for research', price:0, tips:'Based in UK | AI-powered "Site" locator | high intellectual focus'),
    t('lidar-ai-pro-arch','Lidar Archaeology','science','Using satellite and ground Lidar with AI to find hidden ancient sites.','https://lidar-archaeology.com',false,true,12000, freeTier:'Institutional only', price:0, tips:'See through jungle/forest | AI-powered "Anomaly" detection | Revolutionary'),
    t('palaeo-cast-ai','Palaeocast','science','Leading podcast and data platform for paleontology with AI help.','https://palaeocast.com',true,false,25000, freeTier:'Completely free content', price:0, tips:'Learn from real scientists | AI-powered "Search" | Best for students'),

    // ━━━ AI FOR CALLIGRAPHY & HANDWRITING ━━━
    t('calli-graphy-ai-pro','Calligraphr','lifestyle','Leading tool for turning your own handwriting into a font with AI.','https://calligraphr.com',true,true,120000, freeTier:'Free basic version (75 characters)', price:8, priceTier:'Pro monthly', tips:'Best for custom fonts | AI-powered "Smoothing" | Fast and easy to use'),
    t('write-pro-ai-hand','Write (Digital)','lifestyle','Handwriting and note taking app with AI-powered organization and search.','https://styluslabs.com',true,true,84000, freeTier:'Free basic version available', price:5, priceTier:'Pro one-time', tips:'Best for tablet users | AI-powered "Scroll" | Cleanest note experience'),
    t('nebo-ai-pro-pad','Nebo (MyScript)','productivity','The world\'s #1 handwriting recognition app using high-end AI labs.','https://nebo.app',true,true,250000, freeTier:'Free basic version', price:10, priceTier:'Full version one-time', tips:'Best for handwriting to text | AI-powered "Interactive" ink | Industry standard'),
    t('remarkable-ai-pro','reMarkable (Cloud)','productivity','The paper tablet company with AI-powered handwriting sync and help.','https://remarkable.com',false,true,150000, freeTier:'Hardware and subscription', price:3, priceTier:'Connect monthly annual', tips:'Best distraction-free tool | AI-powered "Convert" | High end design'),
    t('good-notes-ai-pro','Goodnotes (AI)','productivity','Leading digital notebook with new AI-powered "Spellcheck" and math help.','https://goodnotes.com',true,true,999999, freeTier:'Free for up to 3 notebooks', price:10, priceTier:'Subscription yearly annual', tips:'AI-powered "Math" help is incredible | Best for students | Apple Design winner'),

    // ━━━ FINAL GEMS v28 (Modern Vector Design) ━━━
    t('figma-ai-pro-design','Figma (AI)','design','The world\'s #1 design tool with new AI-powered "Figma AI" and FigJam.','https://figma.com',true,true,999999, freeTier:'Free forever for up to 3 files', price:12, priceTier:'Professional monthly starting', tips:'AI-powered "Make Design" tool | Built for teams | Industry standard'),
    t('sketch-ai-pro-design','Sketch','design','The original modern design tool with AI-powered plugins and symbols.','https://sketch.com',true,true,350000, freeTier:'30-day free trial on site', price:10, priceTier:'Standard monthly annual', tips:'Mac exclusive king | AI-powered "Icons" | Clean and robust'),
    t('framer-ai-pro-web','Framer (AI)','design','Build professional websites with AI-powered "Framer AI" from prompts.','https://framer.com',true,true,250000, freeTier:'Free forever for hobby sites', price:15, priceTier:'Mini monthly starting', tips:'AI-powered "Layout" generation | Best for interactive sites | Premium UI'),
    t('web-flow-ai-pro','Webflow (AI)','design','Leading visual web design with AI-powered "SEO" and code generation.','https://webflow.com',true,true,500000, freeTier:'Free for up to 2 sites', price:14, priceTier:'Basic monthly annual', tips:'Best for high-end client sites | AI-powered "Styling" | Robust hosting'),
    t('canva-ai-pro-web','Canva Websites','design','Create simple and beautiful websites with AI-powered "Magic" design.','https://canva.com/websites',true,true,999999, freeTier:'Free basic version available', price:15, priceTier:'Pro monthly', tips:'Best for small/personal sites | AI-powered "Images" | Easy drag and drop'),
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
