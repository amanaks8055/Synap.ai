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
    // ━━━ AI FOR AUDIO & BROADCAST (Pro Tools v2) ━━━
    t('stein-berg-ai-pro','Steinberg Cubase (AI)','entertainment','The world\'s #1 composition software with AI-powered "Chord Assistant" and help.','https://steinberg.net',true,true,250000, freeTier:'30-day free trial on site', price:99, priceTier:'Elements one-time purchase', tips:'AI-powered "VariAudio" and colors | Best for film scoring | German standard'),
    t('nuen-do-ai-pro-mas','Steinberg Nuendo','entertainment','Leading media production system with AI-powered "Dialogue" and "ADR" help.','https://steinberg.net/nuendo',true,true,120000, freeTier:'60-day free trial on site', price:999, priceTier:'Full license one-time', tips:'Best for movie post-production | AI-powered "Immersive" audio | Robust'),
    t('dorico-ai-pro-mus','Dorico (Steinberg)','entertainment','The world\'s most advanced scoring software with AI-powered layout and music.','https://dorico.com',true,true,150000, freeTier:'Free "SE" version available', price:559, priceTier:'Pro license one-time', tips:'Founded by the original Sibelius team | AI-powered "Engrave" | high end'),
    t('si-bel-ius-ai-pro','Avid Sibelius','entertainment','The world\'s #1 notation software with AI-powered "PhotoScore" and cloud.','https://avid.com/sibelius',true,true,350000, freeTier:'Free "First" version with limits', price:10, priceTier:'Artist monthly annual', tips:'The industry standard for composers | AI-powered "Scanning" | Robust'),
    t('presonus-ai-mix','PreSonus Studio One','entertainment','Leading modern DAW with AI-powered "Mix" and "Performance" help.','https://presonus.com',true,true,180000, freeTier:'Free basic version available', price:99, priceTier:'Artist one-time purchase', tips:'Best for songwriters and DJs | AI-powered "Track" sync | clean UI'),
    t('reason-ai-pro-st','Reason Studios','entertainment','The legendary "Rack" based DAW with AI-powered "Player" and sequencers.','https://reasonstudios.com',true,true,150000, freeTier:'30-day free trial on site', price:20, priceTier:'Reason+ monthly annual', tips:'Best for sound design | AI-powered "Chord" and "Scale" | unique UI'),
    t('bit-wig-ai-pro-st','Bitwig Studio','entertainment','Modern music creation system with AI-powered "Grid" and modular support.','https://bitwig.com',true,true,120000, freeTier:'Free trial (saving disabled)', price:399, priceTier:'Full license one-time', tips:'Best for experimental producers | AI-powered "Modulation" | high speed'),
    t('fruity-loops-mob','FL Studio Mobile','entertainment','Professional mobile DAW with AI-powered "DirectWave" and mixing help.','https://image-line.com',false,true,250000, freeTier:'No free tier', price:15, priceTier:'One-time purchase', tips:'Best for producing on the go | AI-powered "Drums" | High reliability'),
    t('korg-ai-pro-mus','KORG Gadget','entertainment','Leading electronic music production suite with AI-powered "Gadgets" and help.','https://korg.com',true,false,84000, freeTier:'Free limited version online', price:40, priceTier:'Pro version one-time', tips:'Best for Japanese synth sounds | AI-powered "Master" tools | precise'),
    t('art-uria-ai-pro','Arturia V Collection','entertainment','The world\'s #1 vintage synth collection with AI-powered "Sound" matching.','https://arturia.com',true,true,150000, freeTier:'Free trial of instruments', price:599, priceTier:'One-time purchase license', tips:'AI-powered "Patch" search | Best for authentic sounds | Industry standard'),

    // ━━━ AI FOR BOWLING & DARTS ━━━
    t('bowl-meta-ai-pro','BowlMeta','lifestyle','Leading automated bowling statistics and strategy with AI match logs.','https://bowlmeta.com',true,false,8400, freeTier:'Free basic stats online', price:0, tips:'Best for competitive bowlers | AI-powered "Spare" analytics | niche favorite'),
    t('dart-stats-ai-pro','DartConnect','lifestyle','The world\'s #1 darts scoring and data platform with AI-powered records.','https://dartconnect.com',true,true,120000, freeTier:'Free trial for 2 weeks', price:24, priceTier:'Premium yearly annual', tips:'Official scoring for the PDC | AI-powered "Competition" | Robust and standard'),
    t('score-darts-ai','ScoreDarts','lifestyle','Leading darts scorekeeper with AI-powered computer opponents and logs.','https://scoredarts.com',true,false,15000, freeTier:'Free basic version', price:0, tips:'Best for home practice | AI-powered "Bot" levels | clean and fast'),
    t('darts-id-ai-pro','DartsID','lifestyle','Identify darts technique and form instantly using AI-powered video data.','https://dartsid.com',true,false,5600, freeTier:'Free basic version', price:0, tips:'Best for pro training | AI-powered "Mechanical" check | high precision'),
    t('pdc-ai-pro-data','PDC (Official Data)','lifestyle','The global PDC database with AI-powered live scores and world rankings.','https://pdc.tv',true,true,250000, freeTier:'Completely free open stats', price:0, tips:'The official source for pro darts | AI-powered "Match Center" | Iconic'),

    // ━━━ AI FOR TRX & RESISTANCE BANDS ━━━
    t('trx-ai-pro-train','TRX Training (App)','health','The official suspension training platform with AI-powered personalized plans.','https://trxtraining.com',true,true,120000, freeTier:'Free trial on site', price:7, priceTier:'Premium monthly annual', tips:'Founded by Randy Hetrick | AI-powered "Intensity" guide | High trust'),
    t('stretch-it-app-ai','StretchIt','health','Leading flexibility and stretching app using AI to track and improve splits.','https://stretchitapp.com',true,true,150000, freeTier:'7-day free trial on site', price:20, priceTier:'Monthly membership', tips:'AI-powered "Personalized" training | Best for contortion | high quality UI'),
    t('band-fit-ai-pro','BandFit','health','Leading resistance band training system with AI-powered workout logs.','https://bandfit.com',true,false,45000, freeTier:'Free basic version available', price:10, priceTier:'Premium monthly', tips:'Best for at-home training | AI-powered "Protocol" | clean and fast'),
    t('x-bands-ai-pro','X-Bands (Digital)','health','Professional resistance band programs using AI-powered "Resistance" calc.','https://thexbands.com',true,false,25000, freeTier:'Free basic videos', price:0, tips:'Best for strength and rehab | AI-powered "Routine" help | High trust'),
    t('core-band-ai-pro','CoreBand','health','AI-powered core and abdominal training using resistance and help.','https://coreband.com',true,false,18000, freeTier:'Free trial available', price:0, tips:'Best for pelvic and core health | AI-powered "Check" | precise'),

    // ━━━ AI FOR MINUTE SCIENCE (Entomology & Ornithology v6) ━━━
    t('bird-id-expert-ai','BirdID (Expert)','science','Professional bird identification for ecologists using high-end AI labs.','https://birdid.expert',true,false,25000, freeTier:'Free for researchers', price:0, tips:'Based in Norway | AI-powered "Visual" search | high intellectual focus'),
    t('bug-id-sci-pro','BugID (Science)','science','Identify insect species instantly using AI-powered visual recognition.','https://bugid.org',true,false,15000, freeTier:'Free basic version', price:0, tips:'Best for professional entomologists | AI-powered "Species" search | reliable'),
    t('ant-id-ai-pro-sci','AntID','science','Identify ant species instantly using AI-powered visual recognition and data.','https://antid.com',true,false,12000, freeTier:'Free basic identification', price:0, tips:'Best for myrmecologists | AI-powered "Anatomy" analysis | high trust'),
    t('bee-id-expert-ai','BeeID (Expert)','science','Identify bee and pollinator species with AI-powered visual recognition.','https://beeid.expert',true,false,8400, freeTier:'Completely free open data', price:0, tips:'Save the bees with AI | Best for gardeners | High quality data'),
    t('wasp-id-expert-ai','WaspID (Expert)','science','Leading community driven wasp identification using AI and expert check.','https://waspid.expert',true,false,5600, freeTier:'Free basic version', price:0, tips:'Best for stinging insect research | AI-powered "Nest" logs | reliable'),

    // ━━━ AI FOR TRADITIONAL DESIGN (Shoes & Jewelry v2) ━━━
    t('shoe-cad-ai-pro','ShoeArchitect (AI)','design','Leading platform for creating professional shoe designs with AI.','https://shoecad.com',false,true,15000, freeTier:'Institutional only', price:0, tips:'AI-powered "Last" generation | Best for footwear designers | High precision'),
    t('jewel-cad-ai-pro','JewelCAD','design','Leading professional jewelry design and modeling with AI-powered help.','https://jewelcad.com',false,true,18000, freeTier:'Institutional only', price:0, tips:'Industry standard for jewelry | AI-powered "Gems" mapping | high end'),
    t('gem-cad-ai-pro-sci','GemCAD','design','Leading platform for designing gemstone cuts and facets with AI help.','https://gemcad.com',true,false,12000, freeTier:'Free trial version available', price:0, tips:'Best for lapidary artists | AI-powered "Refractive" aid | precise'),
    t('type-design-ai-pro','TypeArchitect','design','Leading platform for creating professional typefaces and fonts with AI.','https://type-design.com',false,true,15000, freeTier:'Institutional only', price:0, tips:'AI-powered "Kerning" generation | Best for font designers | high tech'),
    t('font-base-ai-pro','FontBase','design','Leading font manager for designers with AI-powered discovery and sync.','https://fontba.se',true,true,150000, freeTier:'Free forever basic version', price:3, priceTier:'Awesome monthly subscription', tips:'Best for Mac/PC font management | AI-powered "Tags" | cleanest UI'),

    // ━━━ FINAL GEMS v39 (Modern AI Auth) ━━━
    t('clerk-ai-pro-auth','Clerk','code','The most modern authentication and user management built for the AI era.','https://clerk.com',true,true,250000, freeTier:'Free for up to 5k active users', price:25, priceTier:'Pro monthly base', tips:'Best for Next.js AI apps | AI-powered "Security" | user favorite UI'),
    t('stytch-ai-pro-auth','Stytch','code','Leading platform for passwordless authentication with AI-powered logs.','https://stytch.com',true,true,150000, freeTier:'Free for up to 5k active users', price:0, tips:'Best for seamless login | AI-powered "Fraud" detection | High security'),
    t('auth-0-ai-pro-okta','Auth0 (Okta)','code','The industry standard for authentication with high-end AI security labs.','https://auth0.com',true,true,500000, freeTier:'Free for up to 7.5k active users', price:0, tips:'Owned by Okta | AI-powered "Anomaly" detect | World leader in auth'),
    t('supertokens-ai-pro','SuperTokens','code','The open-source authentication alternative for serious AI applications.','https://supertokens.com',true,true,120000, freeTier:'Free forever cloud tier available', price:0, tips:'Best for security-first devs | AI-powered "Session" help | rapid growth'),
    t('k-inde-ai-pro-auth','Kinde','code','Modern platform for auth and user management with AI-powered sync.','https://kinde.com',true,true,84000, freeTier:'Free for up to 7.5k active users', price:0, tips:'Best for Australian/Global startups | AI-powered "Growth" | clean UI'),
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
