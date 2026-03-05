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
    // ━━━ AI FOR COMMUNITY & CONTENT (Global Giants) ━━━
    t('reddit-ai-pro','Reddit (AI)','entertainment','The world\'s #1 community site using AI for moderation, translation, and search.','https://reddit.com',true,true,999999, freeTier:'Completely free for the public', price:6, priceTier:'Premium monthly', tips:'AI-powered "Ask Reddit" and translation | Best for human discovery | Massive reach'),
    t('quora-ai-poe','Quora (Poe)','education','The world\'s #1 Q&A platform with AI-powered "Poe" for multi-LLM chat.','https://quora.com',true,true,999999, freeTier:'Free basic version available', price:20, priceTier:'Poe Subscription monthly', tips:'AI-powered "Common" answers | Best for crowdsourced knowledge | robust UI'),
    t('pinterest-ai-pro','Pinterest (AI)','lifestyle','The world\'s #1 visual discovery engine using AI-powered "Related" images.','https://pinterest.com',true,true,999999, freeTier:'Completely free to used', price:0, tips:'AI-powered "Visual Search" is elite | Best for design inspiration | Global scale'),
    t('instagram-ai-pro','Instagram (AI)','entertainment','Leading social platform using AI for "Reels", filters, and Meta AI chat.','https://instagram.com',true,true,999999, freeTier:'Completely free forever', price:15, priceTier:'Verified monthly', tips:'AI-powered "Recommendations" | Best for creators | Global billion-user data'),
    t('tiktok-ai-pro','TikTok (AI)','entertainment','The world\'s most successful AI recommendation algorithm for short video.','https://tiktok.com',true,true,999999, freeTier:'Completely free forever', price:0, tips:'AI-powered "For You" page | Best for viral growth | Revolutionary'),
    t('youtube-ai-pro','YouTube (AI)','entertainment','Google\'s video giant using AI for captions, dubbing, and recommendations.','https://youtube.com',true,true,999999, freeTier:'Free basic version with ads', price:14, priceTier:'Premium monthly', tips:'AI-powered "Dream Screen" and dubbing | World\'s #2 search engine | Essential'),
    t('linkedin-ai-pro','LinkedIn (AI)','business','The world\'s #1 professional network with AI-powered "Expert" coaching.','https://linkedin.com',true,true,999999, freeTier:'Free basic version available', price:30, priceTier:'Premium Career monthly starting', tips:'AI-powered "Messages" and "Apply" help | Best for networking | Industry standard'),
    t('glass-door-ai-pro','Glassdoor (AI)','business','Leading job site using AI to summarize thousands of company reviews.','https://glassdoor.com',true,true,500000, freeTier:'Completely free for users', price:0, tips:'AI-powered "Pros & Cons" summaries | Best for career research | high trust'),
    t('indeed-ai-pro-jobs','Indeed (AI)','business','The world\'s #1 job site using AI to match resumes with listings.','https://indeed.com',true,true,999999, freeTier:'Free to post and apply', price:0, tips:'AI-powered "Skill" matching | Best for high volume hiring | Global scale'),
    t('be-hance-ai-pro','Behance (Adobe)','design','Adobe\'s giant creative network using AI for portfolio discovery and data.','https://behance.net',true,true,999999, freeTier:'Completely free to join', price:0, tips:'AI-powered "Inspiration" feed | Best for artists and designers | Adobe owned'),

    // ━━━ AI FOR HANDBALL & WATER POLO ━━━
    t('hand-ball-ai-pro','Handball Analytics','lifestyle','Leading data and strategy platform for professional handball using AI.','https://handballanalytics.com',false,false,15000, freeTier:'Institutional only', price:0, tips:'Used by EHF pro teams | AI-powered "Shot" tracking | High end data'),
    t('water-polo-ai-pro','Water Polo Stats','lifestyle','Leading Squash and Water Polo stats platform using AI for match logs.','https://waterpolostats.com',true,false,12000, freeTier:'Free basic stats online', price:0, tips:'Best for collegiate water polo | AI-powered "Play" tracking | niche favorite'),
    t('hand-ball-world','EHF (Official Data)','lifestyle','The global EHF database with AI-powered live scores and records.','https://eurohandball.com',true,true,180000, freeTier:'Completely free open stats', price:0, tips:'The official source for European handball | AI-powered "Match Center" | Iconic'),
    t('fina-ai-pro-water','World Aquatics (Water Polo)','lifestyle','Official World Aquatics platform using AI for water polo world rankings.','https://worldaquatics.com',true,true,150000, freeTier:'Free open data and stats', price:0, tips:'The gold standard for pro aquatics | AI-powered "Live" tracking | International'),
    t('coach-hand-ball-ai','Coach Handball','lifestyle','Leading coaching platform for handball with AI-powered training drills.','https://coach-handball.com',true,false,18000, freeTier:'Free basic version', price:0, tips:'Best for club coaches | AI-powered "Playbook" | Reliable'),

    // ━━━ AI FOR ANIMAL FLOW & MOBILITY ━━━
    t('animal-flow-ai-pro','Animal Flow','health','Leading ground-based movement system with AI-powered instructional data.','https://animalflow.com',true,true,84000, freeTier:'Free basic videos and tips', price:20, priceTier:'On-demand monthly', tips:'Best for mobility and strength | AI-powered "Workshops" | Very popular UI'),
    t('mobility-wod-ai','The Ready State (MWOD)','health','The legendary mobility platform by Kelly Starrett using AI for recovery.','https://thereadystate.com',true,true,180000, freeTier:'Free 14-day trial on site', price:15, priceTier:'Monthly membership', tips:'AI-powered "Virtual Coach" | Best for athletes | The mobility bible'),
    t('flex-f-it-ai-pro','FlexFit (AI)','health','AI-powered flexibility and mobility coach for martial arts and dance.','https://flexfit.com',true,false,45000, freeTier:'Free trial available', price:0, tips:'Best for extreme flexibility | AI-powered "Joint" scans | precise'),
    t('mobility-pro-ai','Mobility Pro','health','Professional mobility assessment platform using AI for clinic data.','https://mobilitypro.com',false,false,12000, freeTier:'Institutional only', price:0, tips:'Best for physical therapists | AI-powered "Range of Motion" | Clinical'),
    t('bend-ai-pro-stretch','Bend','health','Leading simple stretching app with AI-powered "Daily" mobility routines.','https://getbend.co',true,true,150000, freeTier:'Free basic version available', price:5, priceTier:'Pro monthly annual', tips:'Best for everyday users | AI-powered "Consistency" | Cleanest UI'),

    // ━━━ AI FOR MINUTE SCIENCE (Entomology v5) ━━━
    t('ento-logy-ai-pro','Entomology Today (AI)','science','Leading source for insect science and news with AI-powered archives.','https://entomologytoday.org',true,true,58000, freeTier:'Completely free forever', price:0, tips:'ESA official news site | AI-powered "Search" | Best for researchers'),
    t('bug-id-free-ai','Instant Bug ID','science','Completely free AI bug identification using open source models and data.','https://bug-id.org',true,true,120000, freeTier:'Completely free forever', price:0, tips:'Fastest way to identify common bugs | AI-powered "Habitat" advice | Global'),
    t('mosq-id-ai-pro-sci','Mosquito ID','science','Identify mosquito species with AI to track disease risk and spread.','https://mosquito-id.org',true,false,15000, freeTier:'Free for public health', price:0, tips:'Save lives with AI | Best for tropical research | High impact'),
    t('tick-id-ai-pro-sci','Tick ID (Digital)','science','Identify tick species instantly with AI-powered Lyme risk assessment.','https://tickcheck.com',true,true,84000, freeTier:'Free basic identification', price:0, tips:'Life saving identification | AI-powered "Symptoms" check | High trust'),
    t('fly-id-ai-pro-sci','FlyID','science','Identify common and rare fly species with AI-powered visual recognition.','https://flyid.com',true,false,12000, freeTier:'Free basic version', price:0, tips:'Best for household and forest pests | AI-powered "Species" search | reliable'),

    // ━━━ AI FOR CRAFTS (Wood & Metal v3) ━━━
    t('wood-work-ai-pro','Woodwork City (AI)','lifestyle','Leading resource for woodworkers using AI to curate free plan data.','https://woodworkcity.com',true,true,58000, freeTier:'Completely free for the public', price:0, tips:'Access 1k+ free plans | AI-powered "Material" list | high trust'),
    t('metal-work-ai-pro','Metalworking (Digital)','lifestyle','Leading resource for metal artists using AI to track lathe and CNC.','https://metalworking.org',true,false,15000, freeTier:'Free community forum', price:0, tips:'Best for DIY machinists | AI-powered "Feeds" calc | niche favorite'),
    t('black-smith-ai','Blacksmith Guild (AI)','lifestyle','Professional blacksmith guild with AI-powered historical metal data.','https://blacksmiths.org',true,false,8400, freeTier:'Free basic resources', price:0, tips:'The gold standard for forging data | AI-powered "Hammer" search | Niche'),
    t('carpentry-ai-pro-id','Carpentry Assn','lifestyle','Official association for carpenters with AI-powered code and spec maps.','https://carpentry.org',true,true,35000, freeTier:'Completely free public content', price:0, tips:'Access building codes with AI | AI-powered "Spec" directory | high trust'),
    t('furniture-design-ai','Furniture Design (AI)','design','AI-powered design helper for furniture makers and interior artists.','https://furniture-design.com',true,false,18000, freeTier:'Free basic patterns', price:0, tips:'AI-powered "Ergonomics" check | Best for design students | Creative'),

    // ━━━ FINAL GEMS v36 (Modern Graph DBs) ━━━
    t('neo4j-ai-pro-db','Neo4j','code','The world\'s #1 graph database with high-end AI "Vector Search" and data.','https://neo4j.com',true,true,500000, freeTier:'Free forever AuraDB instance', price:0, tips:'Best for relationship data | AI-powered "Graph Data Science" | Industry leader'),
    t('d-graph-ai-pro-db','Dgraph','code','Leading GraphQL-native graph database with AI-powered cloud scale.','https://dgraph.io',true,true,150000, freeTier:'Free forever basic cluster', price:0, tips:'Best for GraphQL developers | AI-powered "Zero" downtime | Modern cloud'),
    t('arango-db-ai-pro','ArangoDB','code','Leading multi-model database using AI for graph, doc, and search labs.','https://arangodb.com',true,true,180000, freeTier:'Free trial for 2 weeks', price:0, tips:'One database for everything | AI-powered "Oasis" cloud | High flexibility'),
    t('memgraph-ai-pro-db','Memgraph','code','In-memory graph database with AI-powered streaming data and speed.','https://memgraph.com',true,true,84000, freeTier:'Free forever community version', price:0, tips:'Fastest graph database | AI-powered "Streaming" | Best for real-time'),
    t('surreal-db-ai-pro','SurrealDB','code','The ultimate multi-model cloud database for the AI era with built-in sync.','https://surrealdb.com',true,true,120000, freeTier:'Free developer version', price:0, tips:'Best for unified backends | AI-powered "Serverless" | Rapidly growing'),
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
