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
    // ━━━ SPORTS & PERFORMANCE AI ━━━
    t('home-court-ai','HomeCourt','health','AI-powered basketball training app that tracks your shots, speed, and vertical.','https://homecourt.ai',true,true,28000, freeTier:'Free basic workouts', price:6, priceTier:'Plus per month billed annually', tips:'Best for aspiring basketball players | Real-time AR feedback | Used by NBA teams'),
    t('golf-shot-ai','Golfshot-AI','health','Leading golf GPS app with AI-powered club recommendations and tracking.','https://golfshot.com',true,true,35000, freeTier:'Free basic GPS', price:30, priceTier:'Pro annual price', tips:'Apple Watch integration | Personalized club suggestions | Detailed round stats'),
    t('whoop-coach-v2','Whoop Coach','health','AI-powered personal coach built into whoop using your body data.','https://whoop.com/coach',false,true,45000, freeTier:'Included in Whoop membership', price:30, priceTier:'Monthly membership', tips:'Professional athlete grade data | AI explains your recovery | Daily strain targets'),
    t('peloton-ai','Peloton Guide','health','AI-powered strength training camera that tracks your reps and form.','https://onepeloton.com/guide',false,true,58000, freeTier:'Hardware purchase required', price:24, priceTier:'All-access membership', tips:'Rep counting with AI | Form feedback | Massive strength library'),
    t('swingvision-ai','SwingVision','health','AI-powered tennis app that calls lines and tracks your performance.','https://swing.tennis',true,true,18000, freeTier:'Free limited sessions', price:15, priceTier:'Pro monthly', tips:'Shot tracking and heatmaps | Video highlights with AI | Used by ATP coaches'),

    // ━━━ MUSIC & INSTRUMENTS AI ━━━
    t('yousician-ai','Yousician','education','The personal music tutor for guitar, piano, and singing with AI feedback.','https://yousician.com',true,true,120000, freeTier:'Free for limited play time', price:10, priceTier:'Premium monthly', tips:'Gamified learning | Thousands of songs | AI listens to your playing'),
    t('simply-piano-ai','Simply Piano','education','Fast and fun way to learn piano from scratch with AI listening technology.','https://joytunes.com',true,true,84000, freeTier:'Free introductory courses', price:15, priceTier:'Monthly subscription', tips:'Best for children and beginners | Works with any piano | Instant feedback on notes'),
    t('ultimate-guitar-ai','Ultimate Guitar','education','Largest catalogue of guitar tabs and chords with AI-powered tools.','https://ultimate-guitar.com',true,true,250000, freeTier:'Free access to many tabs', price:3, priceTier:'Pro annual price', tips:'AI-powered "Tab Pro" | Official artist tabs | Massive community'),
    t('tonestack-ai','ToneStack','audio','AI-powered virtual guitar amp and effects processor for mobile.','https://yonac.com',true,false,15000, freeTier:'Free basic amps', price:10, priceTier:'Full version unlock', tips:'Studio quality sound on iPhone | AI-modeled circuits | MIDI support'),
    t('fender-play-ai','Fender Play','education','Learn guitar, bass, and ukulele from the masters with AI tracking.','https://fender.com/play',true,true,58000, freeTier:'Free 14-day trial', price:10, priceTier:'Monthly subscription', tips:'High quality video lessons | Progress tracking | Song-based method'),

    // ━━━ HOME & GARDEN AI ━━━
    t('picture-this-ai','PictureThis','social','AI-powered plant identifier that can diagnose diseases and give care tips.','https://picturethisai.com',true,true,150000, freeTier:'Free limited identify', price:30, priceTier:'Premium annual', tips:'98% accuracy on 1M+ species | Care reminders | Expert botanist chats'),
    t('re-design-ai','RE-Design','design','AI tool to virtually stage and redesign your home from a photo.','https://re-design.ai',true,true,45000, freeTier:'Free for basic renders', price:20, priceTier:'Pro monthly', tips:'Turn empty rooms into furnished ones | Change styles instantly | Best for real estate'),
    t('planta-ai','Planta','social','AI-powered companion for keeping your plants alive with reminders.','https://getplanta.com',true,true,58000, freeTier:'Free basic reminders', price:10, priceTier:'Premium: light meter and more monthly', tips:'Light meter with AI | Watering schedules | Identifying disease with photos'),
    t('houzz-ai','Houzz','design','The all-in-one app for home renovation with AI-powered visualization.','https://houzz.com',true,true,120000, freeTier:'Completely free to use', price:0, tips:'View products in your room with AR | Find local pros | Visual search'),
    t('inaturalist-ai','iNaturalist','science','Contribute to science by sharing your nature observations with AI.','https://inaturalist.org',true,true,150000, freeTier:'Completely free forever', price:0, tips:'Joint project of Nat Geo and Cal Academy | AI-powered identification | Global data'),

    // ━━━ PARENTHOOD & BABIES AI ━━━
    t('huckleberry-ai','Huckleberry','health','AI-powered sleep expert for parents of babies and toddlers.','https://huckleberrycare.com',true,true,84000, freeTier:'Free basic tracking', price:10, priceTier:'Plus monthly', tips:'AI predicts the "Sweet Spot" for naps | Personalized sleep plans | Track feeds and growth'),
    t('the-bump-ai','The Bump','health','Leading pregnancy and baby tracker with AI-powered content.','https://thebump.com',true,true,120000, freeTier:'Completely free app', price:0, tips:'3D baby visualization | Daily pregnancy news | Best registry tools'),
    t('baby-center-ai','BabyCenter','health','The world\'s #1 pregnancy and parenting resource with AI.','https://babycenter.com',true,true,250000, freeTier:'Completely free app', price:0, tips:'Community groups for every month | AI-powered fetal development | Scientific advice'),
    t('baby-connect-ai','Baby Connect','health','Comprehensive baby tracking with AI-powered data visualization.','https://babyconnect.com',false,false,15000, freeTier:'7-day free trial', price:5, priceTier:'Monthly subscription', tips:'Sync across all family members | Detailed reports and charts | Secure data'),
    t('wonder-weeks-ai','The Wonder Weeks','health','Bestselling baby app that tracks mental leaps with AI indicators.','https://thewonderweeks.com',false,true,92000, freeTier:'One-time purchase required', price:5, priceTier:'One-time purchase', tips:'Understand why your baby is fussy | Science-based leaps | Progress tracking'),

    // ━━━ GOVERNMENT & CIVIC AI ━━━
    t('vote411-ai','VOTE411','business','AI-powered non-partisan election information and polling place finder.','https://vote411.org',true,true,58000, freeTier:'Completely free non-profit', price:0, tips:'Launched by League of Women Voters | Personalized ballot info | Safe and secure'),
    t('usa-gov-ai','USA.gov','business','The official guide to government information and services with AI search.','https://usa.gov',true,true,150000, freeTier:'Completely free forever', price:0, tips:'Official government portal | AI-powered help desk | Access all federal info'),
    t('turbotax-ai-pro','TurboTax','finance','The most popular AI-powered tax preparation software in the US.','https://turbotax.com',true,true,250000, freeTier:'Free for simple returns', price:40, priceTier:'Deluxe plan starting', tips:'AI finds every deduction | Expert review available | Industry standard'),
    t('h-r-block-ai','H&R Block','finance','Professional tax preparation with AI helper and guaranteed max refund.','https://hrblock.com',true,true,120000, freeTier:'Free for simple returns', price:35, priceTier:'Deluxe plan starting', tips:'In-person or online | AI-powered "Tax Pro" | Audit representation'),
    t('id-me-ai','ID.me','productivity','Next-generation digital identity with AI-powered verification.','https://id.me',true,true,150000, freeTier:'Free for users', price:0, tips:'Official US government partner | Secure and private | One identity for hundreds of sites'),

    // ━━━ NON-PROFIT & VOLUNTEER AI ━━━
    t('volunteer-match-ai','VolunteerMatch','social','Largest network in the nonprofit world with AI-powered matching.','https://volunteermatch.org',true,true,84000, freeTier:'Free to join and apply', price:0, tips:'Find opportunities by location/cause | AI-powered recommendations | Virtual options'),
    t('donors-choose-ai','DonorsChoose','social','Empower public school teachers by funding classroom projects with AI.','https://donorschoose.org',true,true,45000, freeTier:'Free to join and search', price:0, tips:'Direct impact on students | AI-verified teachers | High transparency'),
    t('catchafire-ai','Catchafire','social','AI-powered platform that matches expert volunteers with non-profits.','https://catchafire.org',true,true,12000, freeTier:'Free for volunteers', price:0, tips:'Best for high-skilled volunteering | Professional development | Huge impact'),
    t('benevity-ai','Benevity','social','Leading platform for corporate purpose and social impact with AI.','https://benevity.com',false,false,5600, freeTier:'Institutional only', price:0, tips:'Used by Google and Apple | AI-powered matching for grants | Global scale'),
    t('idealist-ai','Idealist','social','Leading platform for social impact jobs, internships, and volunteering.','https://idealist.org',true,true,92000, freeTier:'Free for individuals', price:0, tips:'Best for non-profit jobs | Global network | AI-powered career alerts'),

    // ━━━ MARINE & OCEAN AI ━━━
    t('marine-traffic-ai','MarineTraffic','travel','Real-time AIS position tracking of ships globally with AI analytics.','https://marinetraffic.com',true,true,120000, freeTier:'Free basic fleet tracking', price:15, priceTier:'Essential monthly', tips:'Track any ship globally | AI predicts arrivals | Professional AIS data'),
    t('fishbrain-ai','Fishbrain','social','The #1 fishing app with AI-powered "Catch Forecasts" and social.','https://fishbrain.com',true,true,84000, freeTier:'Free basic logs', price:10, priceTier:'Pro monthly', tips:'Best for anglers | AI identifies 1000+ fish | Find the best local spots'),
    t('surfline-ai','Surfline','travel','World leader in surf reports and forecasts with AI-powered cams.','https://surfline.com',true,true,150000, freeTier:'Free basic forecasts', price:8, priceTier:'Premium: ad-free and longer forecasts monthly', tips:'Live HD surf cams | AI-powered wave heights | Expert human forecasters'),
    t('navionics-ai','Navionics (Garmin)','travel','The #1 boating app for navigation and charts with AI-powered sonar.','https://navionics.com',true,true,58000, freeTier:'Free trial available', price:50, priceTier:'Annual subscription', tips:'Best marine charts | AI-powered "Community Edits" | Dock-to-dock routing'),
    t('tides-near-me-ai','Tides Near Me','travel','Simple and accurate tide forecasts with AI for coastal areas.','https://tidesnearme.com',true,true,120000, freeTier:'Completely free app', price:0, tips:'Fast and reliable | Offline support | Used by sailors and surfers'),

    // ━━━ RELIGIOUS & SPIRITUAL GEMS ━━━
    t('bible-app-ai','YouVersion Bible','spiritual','The world\'s #1 Bible app with AI-powered plans and daily verses.','https://bible.com',true,true,250000, freeTier:'Completely free forever', price:0, tips:'Thousands of translations | AI-powered plans | Massive global community'),
    t('hallow-ai-pro','Hallow','spiritual','The #1 Catholic prayer and meditation app with AI voice guides.','https://hallow.com',true,true,150000, freeTier:'Free basic sessions', price:10, priceTier:'Premium monthly', tips:'Celebrity-led prayers | AI-powered habits | Faith-based focus'),
    t('muslim-pro-ai','Muslim Pro','spiritual','The world\'s most popular Muslim app with AI-powered Quran and prayer.','https://muslimpro.com',true,true,180000, freeTier:'Free basic version', price:4, priceTier:'Premium: no ads and more features', tips:'Most accurate Qibla and prayer times | AI-powered Quran tutor | 160M+ users'),
    t('sadhguru-ai-app','Sadhguru App','spiritual','Leading yoga and meditation app from Isha Foundation with AI content.','https://isha.sadhguru.org/app',true,true,84000, freeTier:'Free meditations and videos', price:0, tips:'Learn Yoga from source | AI-powered daily insights | High quality production'),
    t('calm-radio-ai','Calm Radio','entertainment','World\'s largest selection of relaxing music curated by AI and experts.','https://calmradio.com',true,false,45000, freeTier:'Free with ads', price:8, priceTier:'Premium: ad-free monthly', tips:'500+ channels | AI specializes in sleep/focus | Multi-platform support'),

    // ━━━ GEOLOGY & NATURE ━━━
    t('rock-identifier-ai','Rock Identifier','science','AI-powered app to identify any rock, crystal, or gemstone.','https://rockidentifier.com',true,true,45000, freeTier:'Free limited identify', price:30, priceTier:'Premium annual', tips:'95% accuracy | Geological database | Chemical properties included'),
    t('mushroom-identify-ai','Mushroom Identify','science','AI-powered mushroom identifier for foragers and nature lovers.','https://mushroom.id',true,false,35000, freeTier:'Free limited identify', price:20, priceTier:'Premium annual', tips:'Identify toxic mushrooms | Foraging maps | Safety-first focus'),
    t('all-trails-ai','AllTrails','travel','Leading hiking app with AI-powered navigation and community reviews.','https://alltrails.com',true,true,250000, freeTier:'Free basic version', price:3, priceTier:'Pro: offline maps and more', tips:'400k+ trail maps | AI-powered difficulty analyzer | Live GPS tracking'),
    t('star-walk-ai','Star Walk','science','Interactive sky guide and star map with AI-powered identification.','https://vitotechnology.com',true,true,120000, freeTier:'Free version available', price:5, priceTier:'One-time purchase', tips:'Identify constellations in AR | Real-time sky map | Beautiful 3D models'),
    t('peakvisor-ai','PeakVisor','travel','Identify any mountain peak in the world with AI and 3D terrain.','https://peakvisor.com',true,true,58000, freeTier:'Free basic identify', price:5, priceTier:'Pro monthly', tips:'Offline 3D maps | Telephoto lens support | Accurate altitude data'),
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
