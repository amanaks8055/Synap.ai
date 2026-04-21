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
    // ━━━ AI FOR KIDS & ACCESSIBILITY v2 ━━━
    t('duolingo-math-ai','Duolingo Math','education','Leading math learning app for kids using AI-powered gamification.','https://duolingo.com/math',true,true,500000, freeTier:'Completely free to use', price:0, tips:'AI-powered "Difficulty" scaling | Fun and colorful UI | Best for 7-12 year olds'),
    t('khan-academy-kids','Khan Academy Kids','education','Leading non-profit education app for toddlers and kids with AI-powered paths.','https://khanacademy.org/kids',true,true,999999, freeTier:'Completely free forever', price:0, tips:'Industry standard for free learning | AI-powered "Character" guides | High trust'),
    t('abc-mouse-ai-pro','ABCmouse','education','Leading early learning platform for kids 2-8 with AI-powered data.','https://abcmouse.com',true,true,180000, freeTier:'30-day free trial on site', price:13, priceTier:'Monthly membership', tips:'Comprehensive curriculum | AI-powered "Learning Path" | Millions of users'),
    t('toca-boca-ai-pro','Toca Boca (Digital)','entertainment','Leading world-building apps for kids with AI-powered physics and play.','https://tocaboca.com',true,true,500000, freeTier:'Free basic version available', price:1, priceTier:'Unlock packs starting', tips:'Best for open creative play | AI-powered "Characters" | Global favorite'),
    t('epic-books-ai','Epic!','education','Leading digital library for kids with AI-powered personalized reading.','https://getepic.com',true,true,350000, freeTier:'Free basic version online', price:10, priceTier:'Unlimited monthly', tips:'Access 40k+ books for kids | AI-powered "Quiz" helper | Best for teachers'),
    t('seeing-ai-google','Seeing AI (Microsoft)','health','The world\'s #1 accessibility app using AI to describe the world for the blind.','https://microsoft.com/en-us/ai/seeing-ai',true,true,999999, freeTier:'Completely free forever', price:0, tips:'AI-powered "Face" and "Currency" recognition | Life changing | High accuracy'),
    t('lookout-ai-google','Lookout (Google)','health','Leading accessibility app using AI to identify objects and text for low vision.','https://google.com/accessibility',true,true,500000, freeTier:'Completely free forever', price:0, tips:'AI-powered "Food Label" scanner | Fast and reliable | Best for Android users'),
    t('be-my-ai-pro','Be My Eyes (AI)','health','Leading platform connecting blind users with AI-powered visual assistance.','https://bemyeyes.com',true,true,250000, freeTier:'Completely free to use', price:0, tips:'AI-powered "Virtual Volunteer" (GPT-4) | Human backup available | Global community'),
    t('ava-ai-captions','Ava','health','Leading real-time captioning for the deaf and hard of hearing with AI.','https://ava.me',true,true,120000, freeTier:'Free basic daily minutes', price:15, priceTier:'Community monthly annual', tips:'AI-powered "Vibe" check for emotions | Best for group meetings | High speed'),
    t('otter-ai-pro-acc','Otter.ai (Accessibility)','health','Leading transcription platform used for accessibility in education and work with AI.','https://otter.ai',true,true,150000, freeTier:'Free basic version (300 mins/mo)', price:10, priceTier:'Pro monthly annual', tips:'AI-powered "Live Notes" | Best for university lectures | High accuracy'),

    // ━━━ AI FOR OUTDOORS & CAMPING v2 ━━━
    t('on-x-hunt-ai','onX Hunt','lifestyle','The #1 hunting and outdoor map app using AI for property boundaries.','https://onxmaps.com/hunt',true,true,180000, freeTier:'7-day free trial on site', price:30, priceTier:'Premium yearly starting', tips:'AI-powered "Public/Private" land data | Best for scouting | Industry leader'),
    t('on-x-backcount','onX Backcountry','lifestyle','Leading hiking and ski map with AI-powered snow and trail data.','https://onxmaps.com/backcountry',true,true,120000, freeTier:'Free basic version', price:30, priceTier:'Premium yearly', tips:'AI-powered "Avalanche" risk alerts | Best for winter sports | Reliable'),
    t('fat-map-ai-pro','FATMAP (Strava)','lifestyle','The world\'s most advanced 3D map for outdoor sports with AI data.','https://fatmap.com',true,true,150000, freeTier:'Free basic 3D maps', price:30, priceTier:'Premium yearly', tips:'Acquired by Strava | AI-powered "Terrain" analysis | High end 3D visuals'),
    t('gaia-gps-ai-pro','Gaia GPS','lifestyle','Leading outdoor navigation app with AI-powered satellite and topo.','https://gaiagps.com',true,true,120000, freeTier:'Free basic version available', price:40, priceTier:'Premium yearly', tips:'Owned by Outside | AI-powered "Track" data | Best for serious explorers'),
    t('peak-visor-ai','PeakVisor','lifestyle','Identify any mountain in 3D using AI-powered augmented reality.','https://peakvisor.com',true,true,84000, freeTier:'Free basic identification', price:3, priceTier:'Premium monthly', tips:'3D maps of every mountain | AI-powered "Peak" tagging | Beautiful UI'),
    t('fish-idy-ai-pro','Fishidy','lifestyle','Leading fishing mapping and data platform with AI-powered "Hotspots".','https://fishidy.com',true,false,45000, freeTier:'Free basic version', price:0, tips:'Powered by Fishing Hot Spots | AI-powered "Catch" log | high trust'),
    t('hunt-wise-ai-pro','HuntWise','lifestyle','Leading hunting tool using AI for solunar and weather predictions.','https://huntwise.com',true,false,35000, freeTier:'Free basic version', price:30, priceTier:'Pro yearly', tips:'AI-powered "Scent" tracker | Best for bow hunters | Reliable'),
    t('outdoor-active-ai','Outdooractive','lifestyle','Leading European outdoor platform for hiking and cycling with AI.','https://outdooractive.com',true,true,150000, freeTier:'Free basic version', price:3, priceTier:'Pro monthly annual', tips:'European leader | AI-powered "Buddy" check-in | huge trail database'),
    t('view-ranger-ai','ViewRanger (Outdooractive)','lifestyle','Pioneer in AR navigation for the outdoors using AI-powered skyline.','https://viewranger.com',true,false,58000, freeTier:'Part of Outdooractive', price:0, tips:'Award winning AR | AI-powered "Skyline" tagging | High reliability'),
    t('re-crea-ai-out','Recreation.gov','lifestyle','Find and book national park camp sites with AI-powered availability data.','https://recreation.gov',true,true,999999, freeTier:'Completely free to search', price:0, tips:'Official US gov portal | AI-powered "Lottery" for popular sites | Essential'),

    // ━━━ AI FOR TRADITIONAL CRAFTS & HOBBIES ━━━
    t('ravelry-ai-search','Ravelry (Digital)','lifestyle','The world\'s largest knitting and crochet database with AI-powered search.','https://ravelry.com',true,true,999999, freeTier:'Completely free for users', price:0, tips:'Access 1M+ patterns | AI-powered "Yarn" substitution | Massive community'),
    t('knit-companion','knitCompanion','lifestyle','Leading digital pattern reader for knitters with AI-powered tracking.','https://knitcompanion.com',true,true,120000, freeTier:'Free basic version', price:20, priceTier:'Setup one-time purchase', tips:'AI-powered "Key" tracker | No more paper patterns | Best for complex projects'),
    t('sewing-pattern-ai','The Fold Line','lifestyle','Leading marketplace for sewing patterns with AI-powered search.','https://thefoldline.com',true,false,45000, freeTier:'Free to browse and join', price:0, tips:'Best for modern sewists | AI-powered "Vibe" labels | High trust'),
    t('wood-ai-pro-labs','Woodworking (Digital)','lifestyle','Leading forum and resource for carpenters with AI-powered project data.','https://woodworking.org',true,false,58000, freeTier:'Completely free forever', price:0, tips:'Industry standard for hobbyists | AI-powered "Search" | legacy logic'),
    t('lutherie-ai-pro','Luthiers Interactive','lifestyle','AI-powered design and data platform for professional guitar makers.','https://luthiers-interactive.com',false,false,12000, freeTier:'Institutional only', price:0, tips:'AI-powered "Wood Ton Wood" analayis | Precision CAD for guitars | Niche'),
    t('ceramics-ai-pro','Ceramic Arts (Digital)','lifestyle','Leading resource for potters using AI to organize glaze recipes.','https://ceramicartsnetwork.org',true,false,58000, freeTier:'Free basic articles', price:10, priceTier:'CLAYflicks monthly', tips:'Best for serious ceramics | AI-powered "Glaze" search | High quality'),
    t('model-train-ai','Model Railroader (Digital)','lifestyle','The iconic magazine for model train fans with AI-powered archive search.','https://trains.com',true,true,84000, freeTier:'Free limited content', price:15, priceTier:'Unlimited monthly', tips:'Best for hobby historians | AI-powered "Layout" planning | high trust'),
    t('war-hammer-ai-app','Warhammer (App)','entertainment','Leading army builder and rules platform for Warhammer using AI data.','https://warhammer.com',true,true,350000, freeTier:'Free basic army building', price:7, priceTier:'Plus monthly', tips:'AI-powered "Battle Forge" | Best for miniature gamers | Official app'),
    t('comic-geeks-ai','League of Comic Geeks','entertainment','The world\'s most popular comic book tracker with AI-powered "For You".','https://leagueofcomicgeeks.com',true,true,180000, freeTier:'Completely free to use', price:0, tips:'Track your collection | AI-powered "Release" alerts | Huge community'),
    t('discogs-ai-vinyl','Discogs','entertainment','The world\'s largest vinyl and music marketplace with AI-powered valuation.','https://discogs.com',true,true,999999, freeTier:'Completely free to use', price:0, tips:'AI-powered "Collection" value | Best for audiophiles | Massive data'),

    // ━━━ AI FOR SENIORS & ELDERCARE ━━━
    t('care-dot-com-ai','Care.com','lifestyle','Leading marketplace for caregivers using AI for safety and matching.','https://care.com',true,true,500000, freeTier:'Free to join and post jobs', price:39, priceTier:'Premium monthly', tips:'AI-powered "Background" checks | Best for finding local help | Huge network'),
    t('elder-ai-care-uk','Elder','lifestyle','Leading UK-based live-in care platform with AI-powered matching.','https://elder.org',true,true,45000, freeTier:'Free care assessment', price:0, tips:'Best for elder care in UK | AI-powered "Nurture" plans | High quality'),
    t('papa-ai-care','Papa','lifestyle','Leading platform for "Papa Pals" providing companion care with AI help.','https://papa.com',false,true,35000, freeTier:'Insurance only', price:0, tips:'Combat loneliness with AI-powered social | Human companionship focus | trusted'),
    t('honor-ai-care','Honor Care (Home Instead)','lifestyle','Network of home care providers using AI for operations and safety.','https://honorcare.com',false,true,58000, freeTier:'Institutional only', price:0, tips:'Owned by Home Instead | AI-powered "Care Platform" | World\'s largest network'),
    t('lumin-ai-senior','Lumin','health','AI-powered tablet and social platform for seniors to stay connected.','https://lumindigital.com',false,false,15000, freeTier:'Institutional only', price:0, tips:'Simple UI for non-tech seniors | AI-powered "Check-ins" | Safe and private'),
    t('silver-sneakers-ai','SilverSneakers','health','Leading fitness program for seniors with AI-powered app and classes.','https://silversneakers.com',true,true,250000, freeTier:'Free via Medicare plans', price:0, tips:'Best for active seniors | AI-powered "Gym" finder | Millions of members'),
    t('grand-pad-ai-pro','GrandPad','lifestyle','The simple and secure tablet for seniors with AI-powered family sharing.','https://grandpad.net',false,true,45000, freeTier:'Hardware purchase required', price:40, priceTier:'Monthly subscription', tips:'Best for seniors 80+ | AI-powered "Video" calls | Built-in LTE'),
    t('senior-ly-ai-pro','Seniorly','lifestyle','Modern search for senior living with AI-powered matching and ratings.','https://seniorly.com',true,true,58000, freeTier:'Completely free for the public', price:0, tips:'AI-powered "Match Score" | Best for finding care homes | High trust'),
    t('a-place-for-mom-ai','A Place for Mom','lifestyle','The world\'s #1 senior living advisor using AI and expert help.','https://aplaceformom.com',true,true,250000, freeTier:'Completely free service for families', price:0, tips:'AI-powered "Care Advisor" | Largest network in US | Established and reliable'),
    t('seneca-ai-senior','Seneca','health','Leading AI companion app for cognitive health and memory for seniors.','https://seneca.ai',true,false,12000, freeTier:'Free basic version', price:0, tips:'Improve memory with AI | Science based exercises | Clean and simple'),

    // ━━━ FINAL GEMS v24 (Historical Tech Labs) ━━━
    t('xerox-parc-ai','Xerox PARC (SRI)','science','The legendary lab that invented the GUI, now using AI for materials.','https://parc.com',false,true,45000, freeTier:'Institutional only', price:0, tips:'Part of SRI International | AI-powered "Cleantech" | Industry legend'),
    t('hp-labs-ai-pro','HP Labs','science','Hewlett Packard\'s research arm using AI for 3D printing and security.','https://hp.com/labs',false,true,58000, freeTier:'Institutional only', price:0, tips:'AI-powered "Cyber" defense | Deep tech focus | Established since 1966'),
    t('ibm-research-ai','IBM Research','science','Global leader in AI research and the home of Watson and Quantum.','https://research.ibm.com',true,true,500000, freeTier:'Vast open source and papers', price:0, tips:'AI-powered "World" creator | 3000+ scientists | Highest number of patents'),
    t('microsoft-research','Microsoft Research','science','Leading research lab with AI-powered innovations across every domain.','https://microsoft.com/research',true,true,999999, freeTier:'Completely free open archives', price:0, tips:'Pioneer in Transformers and LLMs | 10+ global locations | World class'),
    t('bell-labs-ai-pro','Nokia Bell Labs','science','The lab that invented the transistor and C, now using AI for 6G.','https://bell-labs.com',false,true,84000, freeTier:'Institutional only', price:0, tips:'9 Nobel Prizes | AI-powered "Network" optimization | Global mystery lab'),
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
