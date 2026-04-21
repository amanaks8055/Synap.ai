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
    // ━━━ AI FOR CLOUD SECURITY (Iconic) ━━━
    t('snyk-ai-pro-sec','Snyk','code','The developer-first security platform with AI-powered "Snyk AI" for code.','https://snyk.io',true,true,500000, freeTier:'Free forever with monthly scan limits', price:25, priceTier:'Individual monthly annual', tips:'AI-powered "Fix" suggestions | Best for engineering teams | Industry favorite'),
    t('wiz-ai-pro-sec','Wiz','code','Leading cloud security platform with AI-powered "Graph" and threat detect.','https://wiz.io',false,true,350000, freeTier:'Institutional only', price:0, tips:'The fastest growing security firm | AI-powered "RCA" | Best for multi-cloud'),
    t('palo-alto-ai-pro','Palo Alto Networks (AI)','code','Leading security giant using AI-powered "Precision AI" across cloud/network.','https://paloaltonetworks.com',false,true,500000, freeTier:'Institutional only', price:0, tips:'Industry standard for enterprise | AI-powered "Prisma" security | robust'),
    t('crowd-strike-ai-pro','CrowdStrike','code','Leading endpoint security giant with AI-powered "Charlotte" assistant.','https://crowdstrike.com',false,true,350000, freeTier:'Institutional only', price:0, tips:'The gold standard for EDR | AI-powered "Falcon" platform | World leader'),
    t('sentinel-one-ai-pro','SentinelOne','code','Leading AI-native security platform for endpoint, cloud, and identity help.','https://sentinelone.com',false,true,180000, freeTier:'Institutional only', price:0, tips:'AI-powered "Purple AI" assistant | Best for automated defense | Robust'),
    t('check-marx-ai-pro','Checkmarx','code','Leading application security testing with AI-powered "Fusion" and code help.','https://checkmarx.com',false,false,84000, freeTier:'Institutional only', price:0, tips:'Best for enterprise AppSec | AI-powered "SCA" and code scan | Reliable'),
    t('veracode-ai-pro-sec','Veracode','code','Leading cloud-native AppSec platform with AI-powered fixing and data.','https://veracode.com',false,false,58000, freeTier:'Institutional only', price:0, tips:'Best for compliance and devsecops | AI-powered "Fix" help | robust'),
    t('aqua-sec-ai-pro-con','Aqua Security','code','Leading container and cloud-native security with AI-powered detection.','https://aquasec.com',true,false,45000, freeTier:'Free open source tools available', price:0, tips:'Best for Kubernetes security | AI-powered "CNAPP" | High trust'),
    t('lacework-ai-pro-sec','Lacework','code','Leading cloud security platform using AI for anomaly detection and help.','https://lacework.com',false,false,35000, freeTier:'Acquired by Fortinet', price:0, tips:'AI-powered "Polygraph" maps | Best for cloud data | robust'),
    t('darktrace-ai-pro','Darktrace','code','Leading autonomous AI security for networks, email, and cloud labs.','https://darktrace.com',false,true,120000, freeTier:'Institutional only', price:0, tips:'Best for self-learning AI defense | AI-powered "Active" response | High tech'),

    // ━━━ AI FOR LACROSSE & FIELD HOCKEY ━━━
    t('lax-stats-ai-pro','LaxStats','lifestyle','Leading Lacrosse statistics and strategy platform using AI for match logs.','https://laxstats.com',true,false,15000, freeTier:'Free basic stats online', price:0, tips:'Best for high school/college lax | AI-powered "Rankings" | high trust'),
    t('field-hockey-ai-pro','Field Hockey Analytics','lifestyle','Leading data platform for field hockey using AI to track play and strategy.','https://fieldhockeyanalytics.com',false,false,12000, freeTier:'Institutional only', price:0, tips:'Used by pro and national teams | AI-powered "Match" tagging | High end data'),
    t('coach-lax-ai-pro','CoachLax','lifestyle','Leading coaching platform for Lacrosse with AI-powered training drills.','https://coachlax.com',true,false,18000, freeTier:'Free basic version', price:0, tips:'Best for club coaches | AI-powered "Skill" generator | Reliable'),
    t('first-class-lax-ai','First Class Lacrosse','lifestyle','Leading training and media platform using AI-powered personalized loops.','https://firstclasslax.com',true,true,58000, freeTier:'Free basic videos', price:0, tips:'Founded by Greg Gurenlian | AI-powered "Breakdowns" | high quality'),
    t('usa-lax-ai-pro','USA Lacrosse (Data)','lifestyle','The official US Lacrosse database with AI-powered records and safety logs.','https://usalacrosse.com',true,true,150000, freeTier:'Completely free for members', price:0, tips:'The official source for US lax | AI-powered "Coach" certification | Iconic'),

    // ━━━ AI FOR WOMEN\'S HEALTH v2 ━━━
    t('clue-ai-pro-period','Clue','health','Leading period and cycle tracker using AI for health logs and research.','https://helloclue.com',true,true,999999, freeTier:'Free basic version available', price:5, priceTier:'Plus monthly annual', tips:'Science-based tracking | AI-powered "Symptom" analysis | High privacy'),
    t('flo-ai-pro-period','Flo','health','The world\'s #1 health app for women using AI for personalized body logs.','https://flo.health',true,true,999999, freeTier:'Free basic version available', price:10, priceTier:'Premium monthly annual', tips:'AI-powered "Health Assistant" | Best for fertility and cycle | Huge community'),
    t('natural-cycles-ai','Natural Cycles','health','The world\'s first FDA-cleared birth control app using AI and temp data.','https://naturalcycles.com',false,true,250000, freeTier:'Hardware purchase and sub', price:13, priceTier:'Monthly membership', tips:'AI-powered "Algorithm" is elite | Best for natural planning | High tech'),
    t('modern-fer-ai-pro','Modern Fertility (Ro)','health','Leading at-home fertility testing with AI-powered dashboard and help.','https://modernfertility.com',true,true,120000, freeTier:'Free community and tool', price:0, tips:'Owned by Ro | AI-powered "Hormone" tracking | Clean and simple'),
    t('carrot-fer-ai-pro','Carrot Fertility','health','Leading global fertility benefits platform using AI for personalized care.','https://get-carrot.com',false,true,84000, freeTier:'Institutional only', price:0, tips:'Best for corporate benefits | AI-powered "Plan" matching | International'),

    // ━━━ AI FOR MINUTE SCIENCE (Entomology & Ornithology v4) ━━━
    t('bird-soft-ai-pro','BirdSoft','science','Leading professional software for ornithologists using AI for data logs.','https://birdsoft.com',true,false,12000, freeTier:'Free basic version', price:0, tips:'Best for field researchers | AI-powered "Species" search | reliable'),
    t('ants-id-ai-pro-sci','AntsID','science','Identify ant species instantly using AI-powered visual recognition and data.','https://antsid.com',true,false,15000, freeTier:'Free basic identification', price:0, tips:'Best for myrmecologists | AI-powered "Structure" analysis | high trust'),
    t('bee-id-ai-pro-sci','BeeID','science','Identify bee and pollinator species with AI-powered visual recognition.','https://beeid.com',true,true,35000, freeTier:'Completely free open identification', price:0, tips:'Save the bees with AI | Best for gardeners | High quality data'),
    t('wasp-id-ai-pro-sci','WaspID','science','Leading community driven wasp identification using AI and expert check.','https://waspid.com',true,false,8400, freeTier:'Free basic version', price:0, tips:'Best for stinging insect research | AI-powered "Nest" logs | reliable'),
    t('term-ite-id-ai-pro','Termite Identifier','science','AI-powered identification for termites and wood-boring insects for pros.','https://termiteid.com',false,false,12000, freeTier:'Institutional only', price:0, tips:'Best for pest control experts | AI-powered "Damage" analysis | precise'),

    // ━━━ AI FOR EXHIBITION & STAGE DESIGN v3 ━━━
    t('vector-works-ai-pro','Vectorworks','design','Leading professional design software for stage, lighting, and landscape.','https://vectorworks.net',true,true,180000, freeTier:'Educational version available', price:150, priceTier:'Monthly membership annual', tips:'Industry standard for entertainment | AI-powered "Viz" | High tech architecture'),
    t('wysi-wyg-ai-pro','WYSIWYG Lighting','design','Leading platform for pre-visualizing stage and show lighting with AI.','https://cast-soft.com',false,true,35000, freeTier:'Institutional only', price:0, tips:'Best for world tours | AI-powered "Real-time" rendering | The pro gold standard'),
    t('grand-ma-ai-pro-con','GrandMA (MA Lighting)','design','The world\'s #1 lighting console software with AI-powered automation.','https://malighting.com',true,true,120000, freeTier:'Free "onPC" software', price:0, tips:'Live show standard | AI-powered "3D" visualizer | Industry legend'),
    t('capture-ai-pro-viz','Capture (Visualizer)','design','Leading design and visualization software for stage and environment.','https://capture.se',true,true,58000, freeTier:'Free basic demo version', price:0, tips:'Best for multi-layer shows | AI-powered "Console" sync | Swedish tech'),
    t('resolume-ai-pro-vj','Resolume','design','The world\'s #1 VJ software using AI-powered mapping and video effects.','https://resolume.com',true,true,150000, freeTier:'Free trial available', price:299, priceTier:'Avenue one-time purchase', tips:'Best for live visuals and festivals | AI-powered "Projection" mapping | high speed'),

    // ━━━ FINAL GEMS v35 (Modern AI Search) ━━━
    t('perplex-ity-ai-pro','Perplexity AI','productivity','The world\'s #1 AI search engine focused on citations and real-time news.','https://perplexity.ai',true,true,999999, freeTier:'Free unlimited basic search', price:20, priceTier:'Pro monthly', tips:'Best for finding sources | AI-powered "Discovery" and "Files" | The new Google'),
    t('you-com-ai-pro-ser','You.com','productivity','Leading AI-powered search for developers with built-in code and agent.','https://you.com',true,true,500000, freeTier:'Free basic search with limits', price:15, priceTier:'Pro monthly annual', tips:'Best for programming help | AI-powered "write" and "draw" | highly customizable'),
    t('exa-ai-pro-search','Exa (Metaphor)','code','Leading search engine for AI models that finds pages other search misses.','https://exa.ai',true,true,120000, freeTier:'Free for up to 1k searches', price:50, priceTier:'Starter monthly', tips:'Best for building AI agents | AI-powered "Neural" search | Innovative'),
    t('andi-search-ai-pro','Andi','productivity','The conversational AI search engine that summarizes the web for you.','https://andisearch.com',true,true,180000, freeTier:'Completely free forever', price:0, tips:'No ads or tracking | AI-powered "Reader" view | Fast and clean'),
    t('kagi-ai-pro-search','Kagi','productivity','Privacy-first paid search engine with built-in AI "Universal Summaries".','https://kagi.com',true,true,150000, freeTier:'100 free searches for life', price:10, priceTier:'Professional monthly', tips:'Best high quality results | AI-powered "Fast" mode | User favorite'),
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
