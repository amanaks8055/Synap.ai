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
    // ━━━ AI FOR FOCUS & PRODUCTIVITY (Iconic) ━━━
    t('forest-ai-focus','Forest','productivity','Top-rated focus app that plants real trees as you work without distractions.','https://forestapp.cc',true,true,999999, freeTier:'Free basic version available', price:4, priceTier:'Pro one-time purchase', tips:'AI-powered "Focus" algorithm | Plant real trees via partner | addictive gamification'),
    t('freedom-ai-focus','Freedom','productivity','Leading distraction blocker for all devices using AI for custom schedules.','https://freedom.to',true,true,500000, freeTier:'7-day free trial on site', price:9, priceTier:'Premium monthly annual', tips:'Blocks every app and site | AI-powered "Locked Mode" | Used by pro writers'),
    t('rescue-time-ai','RescueTime','productivity','The original automated time tracker using AI to score your focus sessions.','https://rescuetime.com',true,true,350000, freeTier:'Free forever basic version', price:12, priceTier:'Premium monthly annual', tips:'AI-powered "Focus Work" metrics | Automatic tracking | robust and reliable'),
    t('brain-fm-ai-pro','Brain.fm','productivity','Science-backed functional music using AI to improve focus and sleep.','https://brain.fm',true,true,250000, freeTier:'Free for up to 5 sessions', price:10, priceTier:'Premium monthly annual', tips:'Best for flow state | AI-powered "Personalized" audio | High trust'),
    t('endel-ai-sound','Endel','productivity','Personalized soundscapes using AI to help you focus, relax, and sleep.','https://endel.io',true,true,500000, freeTier:'Free basic version available', price:15, priceTier:'Premium monthly annual', tips:'AI-powered "Circadian" rhythm sync | Apple Design winner | High quality'),
    t('focus-mate-ai','Focusmate','productivity','AI-powered virtual coworking to help you get things done with partners.','https://focusmate.com',true,true,180000, freeTier:'3 free sessions per week', price:10, priceTier:'Premium monthly', tips:'Best for accountability | AI-powered "Matching" | High social focus'),
    t('centered-ai-pro','Centered','productivity','Leading flow state app with AI-powered "Coaches" and music for focus.','https://centered.app',true,true,84000, freeTier:'Free forever basic version', price:10, priceTier:'Pro monthly', tips:'AI-powered "Flow" coach | Best for deep work | modern and clean'),
    t('serene-ai-focus','Serene','productivity','Leading macOS focus app that plans your day and blocks distractions with AI.','https://sereneapp.com',true,false,45000, freeTier:'Free trial available', price:4, priceTier:'Monthly membership', tips:'Best for planning deep work sessions | AI-powered "Focus" music | Mac only'),
    t('be-focused-ai','Be Focused','productivity','Leading Pomodoro timer for Apple devices with AI-powered task logs.','https://xwavesoft.com',true,true,120000, freeTier:'Free basic version with ads', price:5, priceTier:'Pro one-time', tips:'Best for simple Pomodoro | AI-powered "Report" | Very popular'),
    t('pomo-done-ai-pro','PomoDoneApp','productivity','The most flexible Pomodoro timer using AI to sync with Trello/Jira.','https://pomodoneapp.com',true,false,84000, freeTier:'Free forever basic version', price:5, priceTier:'Lite monthly', tips:'Best for syncing with task apps | AI-powered "Stats" | reliable'),

    // ━━━ AI FOR SKIING & SNOWSPORTS ━━━
    t('slopes-ai-ski-gps','Slopes','lifestyle','The world\'s #1 ski and snowboard tracker using AI for automatic lifts.','https://getslopes.com',true,true,250000, freeTier:'Free basic GPS tracking', price:30, priceTier:'Premium yearly annual', tips:'AI-powered "Lift" detection is magic | Best for tracking stats | Apple Design winner'),
    t('ski-tracks-ai-pro','Ski Tracks','lifestyle','Leading offline ski tracker using AI for high-accuracy speed and logs.','https://corecoders.com/skitracks',true,true,500000, freeTier:'Free basic version available', price:5, priceTier:'Pro one-time purchase', tips:'Best for zero signal battery life | AI-powered "Gradient" | industry standard'),
    t('snow-w-ai-stats','Snoww','lifestyle','Social ski tracking app with AI-powered leaderboards and friends.','https://snoww.at',true,true,150000, freeTier:'Completely free for users', price:0, tips:'Best for competitive groups | AI-powered "Profile" | Fast and clean'),
    t('carv-ai-ski-coach','Carv','lifestyle','The world\'s first AI-powered ski coach with smart boot sensors.','https://getcarv.com',false,true,84000, freeTier:'No free tier', price:150, priceTier:'Subscription and sensors', tips:'Professional feedback in real-time | AI-powered "Ski IQ" | Best for pro learners'),
    t('snow-fore-ai-ski','Snow-Forecast','lifestyle','Leading snow weather and reports for every resort with AI prediction.','https://snow-forecast.com',true,true,999999, freeTier:'Completely free to check', price:10, priceTier:'Premium yearly', tips:'The global standard for snow weather | AI-powered "Alerts" | highly reliable'),

    // ━━━ AI FOR FORAGING & NATURE v3 ━━━
    t('i-naturalist-ai','iNaturalist','science','Leading citizen science app using AI to identify plants and animals.','https://inaturalist.org',true,true,999999, freeTier:'Completely free forever', price:0, tips:'Joint project of Cal Academy and NatGeo | AI-powered "Identifications" | Global'),
    t('seek-by-inatural','Seek','science','The kid-friendly version of iNaturalist using AI for instant nature ID.','https://inaturalist.org/pages/seek',true,true,500000, freeTier:'Completely free forever', price:0, tips:'Gamified nature identification | AI-powered "Badges" | safe for kids'),
    t('picture-mushroom-ai','Picture Mushroom','science','Identify mushroom species instantly using AI-powered visual recognition.','https://picturemushroom.com',true,true,120000, freeTier:'Free basic identification', price:20, priceTier:'Premium yearly annual', tips:'AI-powered "Edibility" warning | Best for foragers | high accuracy'),
    t('mushroom-id-ai','Mushroom Identificator','science','Community driven mushroom identification using AI and expert check.','https://mushroom-id.com',true,false,45000, freeTier:'Free basic version', price:0, tips:'Best for European species | AI-powered "Morphology" search | reliable'),
    t('forager-ai-pro-eat','Foraged','lifestyle','Leading marketplace for wild and specialty foods with AI discovery.','https://foraged.com',true,true,58000, freeTier:'Completely free to browse', price:0, tips:'Buy wild mushrooms and greens safely | AI-powered "Vetting" | high quality'),

    // ━━━ AI FOR MUSEUMS & ART HISTORY ━━━
    t('google-arts-ai','Google Arts & Culture','entertainment','Explore the world\'s art and culture in high-def with AI-powered labs.','https://artsandculture.google.com',true,true,999999, freeTier:'Completely free forever', price:0, tips:'AI-powered "Art Selfie" and "Visual" search | Massive database | Global jewel'),
    t('moma-ai-pro-guide','MoMA (Digital)','entertainment','Leading museum platform with AI-powered guides and collection data.','https://moma.org',true,true,350000, freeTier:'Completely free basic version', price:0, tips:'Best for modern art | AI-powered "Exhibition" archives | High trust'),
    t('met-museum-ai-pro','The Met (Digital)','entertainment','The Metropolitan Museum of Art with AI-powered open access data.','https://metmuseum.org',true,true,500000, freeTier:'Completely free open data', price:0, tips:'Use 400k+ high def images with AI | Best for art historians | Iconic'),
    t('smartify-ai-pro','Smartify','entertainment','The "Shazam for Art" using AI to identify any painting in museums.','https://smartify.org',true,true,250000, freeTier:'Free basic identification', price:0, tips:'World\'s largest museum guide app | AI-powered "Audio" stories | Essential'),
    t('daily-art-ai-pro','DailyArt','entertainment','Get a daily dose of art history with AI-powered personalized stories.','https://getdailyart.com',true,true,180000, freeTier:'Free basic version with ads', price:5, priceTier:'Premium one-time', tips:'Best for learning daily | AI-powered "Archive" | clean and beautiful UI'),

    // ━━━ AI FOR 3D PRINTING & CAD v2 ━━━
    t('auto-desk-ai-pro','Autodesk (Fusion 360)','design','Leading 3D CAD/CAM platform with high-end generative AI design labs.','https://autodesk.com/fusion-360',true,true,500000, freeTier:'Free for personal hobby use', price:0, tips:'AI-powered "Generative" design | Use to optimize weight/strength | Industry standard'),
    t('thinker-cad-ai','Tinkercad','design','The easiest 3D design and coding tool for kids and hobbyists with AI help.','https://tinkercad.com',true,true,999999, freeTier:'Completely free forever', price:0, tips:'Owned by Autodesk | AI-powered "Sim" blocks | Best for beginners'),
    t('on-shape-ai-pro','Onshape (PTC)','design','Cloud-native professional CAD with AI-powered collaboration and data.','https://onshape.com',true,true,250000, freeTier:'Free for open source projects', price:0, tips:'Founded by SolidWorks team | AI-powered "FeatureScript" | robust'),
    t('bambu-lab-ai-pro','Bambu Lab (Handy)','design','Leading 3D printer app using AI for print monitoring and cloud sync.','https://bambulab.com',true,true,180000, freeTier:'Free app for users', price:0, tips:'AI-powered "Spaghetti" detection | Fastest growing in 3D | High trust'),
    t('octo-print-ai-pro','OctoPrint (Obico)','design','Leading open-source 3D print server with AI-powered failure detect.','https://octoprint.org',true,true,150000, freeTier:'Free forever basic version', price:0, tips:'Best for DIY printers | AI-powered "Obico" plugin is magic | high trust'),

    // ━━━ FINAL GEMS v29 (Modern FinOps) ━━━
    t('brex-ai-pro-spend','Brex','business','Leading corporate card and spend platform with AI-powered receipts.','https://brex.com',true,true,250000, freeTier:'Free for venture startups', price:0, tips:'AI-powered "Expense" memos | Best for growth companies | Silicon Valley favorite'),
    t('ramp-ai-pro-spend','Ramp','business','The "Finance Automation" platform using AI to save companies money.','https://ramp.com',true,true,180000, freeTier:'Completely free to use (for cards)', price:0, tips:'AI-powered "Contract" analysis | Best for saving cash | fast and clean'),
    t('expensify-ai-pro','Expensify','business','Leading expense reporting with AI-powered "SmartScan" and receipt help.','https://expensify.com',true,true,500000, freeTier:'6-week free trial on site', price:5, priceTier:'Individual monthly annual', tips:'The "Concierge" AI is helpful | Best for pro travelers | Industry standard'),
    t('bill-com-ai-pro','Bill.com','business','Leading AP/AR automation with AI-powered invoice and payment logs.','https://bill.com',false,true,120000, freeTier:'No free tier', price:45, priceTier:'Essentials monthly', tips:'Best for medium business | AI-powered "Intelligent" bill pay | robust'),
    t('navan-ai-pro-trip','Navan (TripActions)','business','Leading corporate travel and expense with AI-powered personalized help.','https://navan.com',true,true,150000, freeTier:'Free basic version available', price:0, tips:'Book and track with AI | Best for business travelers | Premium support'),
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
