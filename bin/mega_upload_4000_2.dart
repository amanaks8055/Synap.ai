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
    // ━━━ AI FOR AUDIO & MUSIC PRO (Iconic) ━━━
    t('ableton-ai-pro','Ableton Live','entertainment','The world\'s #1 live music production software with AI-powered "Scale Mode" and help.','https://ableton.com',true,true,999999, freeTier:'90-day free trial on site', price:99, priceTier:'Intro one-time purchase', tips:'AI-powered "MIDI" tools are legendary | Best for electronic music | Industry standard'),
    t('fl-studio-ai-pro','FL Studio','entertainment','Leading DAW with AI-powered "Stem Separation" and "Mastering" tools.','https://image-line.com',true,true,999999, freeTier:'Free trial available forever', price:99, priceTier:'Fruity Edition one-time', tips:'Free Lifetime Updates | AI-powered "Sound" search | Best for beatmakers'),
    t('logic-pro-ai-pro','Logic Pro','entertainment','Apple\'s professional DAW with new AI-powered "Session Players" and mastering.','https://apple.com/logic-pro',true,true,999999, freeTier:'90-day free trial on site', price:199, priceTier:'One-time purchase license', tips:'AI-powered "Drummer" and "Keys" | Best for Mac users | High quality plugins'),
    t('studio-one-ai-pro','Studio One','entertainment','Leading modern DAW with AI-powered "Chord Track" and mastering help.','https://presonus.com',true,true,350000, freeTier:'Free "Prime" version available', price:99, priceTier:'Artist one-time purchase', tips:'Best for songwriters | AI-powered "Drag & Drop" | Cleanest workflow'),
    t('pro-tools-ai-pro','Pro Tools (Avid)','entertainment','The Hollywood standard for recording with AI-powered "Melodyne" and cloud.','https://avid.com/pro-tools',true,true,500000, freeTier:'Free "Intro" version with limits', price:30, priceTier:'Artist monthly annual', tips:'The industry gold standard | AI-powered "Audio" editing | Robust and pro'),
    t('audacity-ai-pro','Audacity','entertainment','The world\'s #1 open-source audio editor with AI-powered noise reduction.','https://audacityteam.org',true,true,999999, freeTier:'Completely free forever', price:0, tips:'Best for simple edits and podcasts | AI-powered "Plugin" support | Global leader'),
    t('izotope-ai-pro-mas','iZotope Ozone','entertainment','Leading AI-powered mastering suite with "Master Assistant" for pro sound.','https://izotope.com',true,true,350000, freeTier:'Free trial available on site', price:0, tips:'AI-powered "Master Assistant" is magic | Best for finishing tracks | High end'),
    t('splice-ai-pro-snd','Splice','entertainment','Leading cloud library for samples with AI-powered "Similar" and "Create".','https://splice.com',true,true,999999, freeTier:'Free basic browse and tools', price:13, priceTier:'Sounds+ monthly starting', tips:'AI-powered "Create" stack is insane | Best for modern producers | Massive library'),
    t('serato-ai-pro-vid','Serato DJ','entertainment','The world\'s #1 DJ software with AI-powered "Stems" for real-time remixes.','https://serato.com',true,true,500000, freeTier:'Free "Lite" version available', price:10, priceTier:'Pro monthly annual', tips:'AI-powered "Stems" separation | Best for pro DJs | High performance'),
    t('rekord-box-ai-pro','rekordbox (Pioneer)','entertainment','Pioneer DJ\'s official software with AI-powered track analysis and library.','https://rekordbox.com',true,true,350000, freeTier:'Free "Core" version for users', price:0, tips:'The club standard | AI-powered "Phrase" detection | Reliable and fast'),

    // ━━━ AI FOR NETBALL & GAELIC ━━━
    t('net-ball-ai-pro','Netball Analytics','lifestyle','Leading data and strategy platform for professional netball using AI.','https://netballanalytics.com',false,false,15000, freeTier:'Institutional only', price:0, tips:'Used by pro teams in UK/AU | AI-powered "Court" maps | High end data'),
    t('gaelic-stats-ai','Gaelic Stats (AI)','lifestyle','Leading data platform for Gaelic Football and Hurling with AI match logs.','https://gaelicstats.com',true,false,12000, freeTier:'Free basic stats online', price:0, tips:'Best for club and county teams | AI-powered "Play" tracking | niche favorite'),
    t('gaa-ai-pro-data','GAA (Official Data)','lifestyle','The global GAA database with AI-powered live scores and historical records.','https://gaa.ie',true,true,180000, freeTier:'Completely free open stats', price:0, tips:'The official source for Irish sports | AI-powered "Match Center" | Iconic'),
    t('net-ball-world-ai','World Netball (AI)','lifestyle','Official World Netball platform using AI for world rankings and data logs.','https://worldnetball.sport',true,true,150000, freeTier:'Free open data and stats', price:0, tips:'The gold standard for pro netball | AI-powered "Live" tracking | International'),
    t('coach-net-ball-ai','Coach Netball','lifestyle','Leading coaching platform for netball with AI-powered training drills.','https://coachnetball.com',true,false,18000, freeTier:'Free basic version', price:0, tips:'Best for club coaches | AI-powered "Tactics" | Reliable'),

    // ━━━ AI FOR HYPOPRESSIVES & PELVIC HEALTH ━━━
    t('el-vie-ai-pro-pel','Elvie','health','Leading pelvic health technology using AI-powered biofeedback and apps.','https://elvie.com',false,true,150000, freeTier:'No free tier (hardware)', price:199, priceTier:'Trainer one-time purchase', tips:'AI-powered "Kegel" coach is elite | Best for postpartum | High tech'),
    t('per-ifit-ai-pro','Perifit','health','Leading smart pelvic floor trainer with AI-powered games and tracking.','https://perifit.co',false,true,120000, freeTier:'No free tier (hardware)', price:150, priceTier:'Trainer one-time purchase', tips:'Gamified pelvic floor training | AI-powered "Biofeedback" | High engagement'),
    t('hypo-pro-ai-health','HypoPressives (Digital)','health','Leading platform for learning hypopressive breathing with AI-powered help.','https://hypopressives.com',true,false,35000, freeTier:'Free basic videos and tips', price:30, priceTier:'Class monthly starting', tips:'Best for core and pelvic health | AI-powered "Form" check | Niche'),
    t('pelvic-gym-ai-pro','Pelvic Gym','health','Leading exercise platform for pelvic health with AI-powered routine logs.','https://thepelvicgym.com',true,false,25000, freeTier:'Free trial available', price:20, priceTier:'Monthly membership', tips:'Best for daily pelvic habits | AI-powered "Plans" | high quality'),
    t('core-360-ai-health','Core 360 (AI)','health','Professional core assessment platform using AI for posture and rehab.','https://core360.com',false,false,12000, freeTier:'Institutional only', price:0, tips:'Best for physical therapists | AI-powered "Core" score | Clinical'),

    // ━━━ AI FOR MINUTE SCIENCE (Ichthyology & Herpetology v2) ━━━
    t('fish-base-ai-data','FishBase','science','The world\'s most comprehensive database of fish with AI-powered search.','https://fishbase.org',true,true,500000, freeTier:'Completely free open data', price:0, tips:'Access 30k+ fish species data | AI-powered "Taxonomy" | The global gold standard'),
    t('reptile-db-ai-pro','The Reptile Database','science','Leading database of all living reptile species with AI-powered sorting.','https://reptile-database.org',true,true,150000, freeTier:'Completely free open data', price:0, tips:'Best for herpetologists | AI-powered "Literature" links | Academic standard'),
    t('amphibia-web-ai','AmphibiaWeb','science','Leading source for amphibian biology and conservation using AI data logs.','https://amphibiaweb.org',true,true,120000, freeTier:'Completely free forever', price:0, tips:'Based at UC Berkeley | AI-powered "Decline" tracking | high impact'),
    t('shark-id-ai-pro-sci','SharkID','science','Identify shark species instantly using AI-powered visual recognition.','https://sharkid.com',true,false,15000, freeTier:'Free basic identification', price:0, tips:'Best for divers and researchers | AI-powered "Fin" matching | High trust'),
    t('snake-id-ai-pro-sci','SnakeID','science','Identify snake species with AI-powered visual recognition for safety.','https://snakeid.org',true,true,84000, freeTier:'Free basic identification', price:0, tips:'Identify venomous snakes with AI | Best for hikers | High accuracy'),

    // ━━━ AI FOR SPECIALIZED ART (Encaustic & Tempera) ━━━
    t('encaustic-ai-pro','Encaustic Hub','lifestyle','Leading resource for encaustic artists using AI to archive techniques.','https://encaustichub.com',true,false,15000, freeTier:'Free basic resources', price:0, tips:'Best for wax artists | AI-powered "Pigment" search | niche favorite'),
    t('egg-temp-ai-pro','Egg Tempera (Digital)','lifestyle','Professional resource for egg tempera with AI-powered historical data.','https://eggtempera.org',true,false,12000, freeTier:'Free basic lessons', price:0, tips:'Best for traditional artists | AI-powered "Recipe" aid | high trust'),
    t('icon-paint-ai-pro','Icon Painting (AI)','lifestyle','Leading resource for traditional icon painting with AI-powered data.','https://iconography.net',true,false,8400, freeTier:'Free basic resources', price:0, tips:'Best for sacred art | AI-powered "Style" guide | Niche'),
    t('mosaic-ai-pro-design','Mosaic Architect','lifestyle','Leading design helper for mosaic artists using AI to map tiles.','https://mosaicarchitect.com',true,false,18000, freeTier:'Free basic patterns', price:0, tips:'AI-powered "Tesserae" generator | Best for mosaic artists | Creative'),
    t('calli-style-ai-pro','Calligraphy Style','lifestyle','AI-powered design and style help for modern calligraphy artists.','https://calligraphystyle.com',true,false,25000, freeTier:'Free basic guides', price:0, tips:'Best for lettering artists | AI-powered "Stroke" help | clean UI'),

    // ━━━ FINAL GEMS v37 (Modern AI Video) ━━━
    t('runway-gen-2-ai','Runway Gen-2','video','The world\'s #1 AI video generation platform for high-end film and arts.','https://runwayml.com',true,true,999999, freeTier:'Free trial with credits', price:15, priceTier:'Standard monthly starting', tips:'AI-powered "Text to Video" is magic | Best for experimental film | The market leader'),
    t('pika-labs-ai-pro','Pika','video','Leading AI video generation platform for realistic and stylized animation.','https://pika.art',true,true,500000, freeTier:'Free credits for new users', price:10, priceTier:'Plus monthly annual', tips:'AI-powered "Animation" from prompts | Best for social media clips | high quality'),
    t('hey-gen-ai-pro-vid','HeyGen','video','Leading AI-powered video spokesperson and translation platform for biz.','https://heygen.com',true,true,350000, freeTier:'1 free credit for starters', price:29, priceTier:'Creator monthly annual', tips:'AI-powered "Avatars" are elite | Best for corporate and ads | World leader'),
    t('synthesia-ai-pro','Synthesia','video','Leading platform for creating professional AI videos from text in minutes.','https://synthesia.io',true,true,250000, freeTier:'Free demo video available', price:22, priceTier:'Starter monthly annual', tips:'Best for training and HR videos | AI-powered "Voices" | robust and clean'),
    t('descript-ai-pro-vid','Descript','video','Leading all-in-one video and podcast editor that works like a doc with AI.','https://descript.com',true,true,500000, freeTier:'Free forever with 1 hour/mo', price:15, priceTier:'Creator monthly annual', tips:'AI-powered "Eye Contact" and "Overdub" | Best for content creators | High trust'),
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
