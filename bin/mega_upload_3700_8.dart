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
    // ━━━ AI FOR CUSTOMER SUPPORT (Iconic) ━━━
    t('zen-desk-ai-pro-sup','Zendesk','business','The world\'s #1 support platform with AI-powered "Zendesk AI" for agents.','https://zendesk.com',true,true,999999, freeTier:'Free trial for 14 days', price:19, priceTier:'Support Team monthly', tips:'AI-powered "Intelligent Triage" is elite | Best for scaled support teams | Official leader'),
    t('intercom-ai-pro-chat','Intercom','business','Leading customer messaging with AI-powered "Fin" for automated support.','https://intercom.com',true,true,500000, freeTier:'Free trial for 14 days', price:74, priceTier:'Essential monthly', tips:'AI-powered "Fin" chatbot is incredible | Best for SaaS companies | Modern UI'),
    t('fresh-desk-ai-pro','Freshdesk','business','Leading omnichannel support platform with AI-powered "Freddy" help.','https://freshdesk.com',true,true,350000, freeTier:'Free forever for up to 10 agents', price:15, priceTier:'Growth monthly annual', tips:'AI-powered "Automations" | Best for small/mid teams | Clean and robust'),
    t('help-scout-ai-pro','Help Scout','business','The most human-centric support platform with AI-powered "Docs" and chat.','https://helpscout.com',true,true,250000, freeTier:'15-day free trial on site', price:20, priceTier:'Standard monthly annual', tips:'Best for empathetic support | AI-powered "Summaries" | Highly reliable'),
    t('front-ai-pro-chat','Front','business','The shared inbox platform with AI-powered "Customer Context" and help.','https://front.com',true,true,180000, freeTier:'7-day free trial on site', price:19, priceTier:'Starter monthly annual', tips:'Best for team-based email support | AI-powered "Tags" | High efficiency'),
    t('drift-ai-pro-chat','Drift (Salesloft)','marketing','Leading conversational marketing platform with AI-powered sales chat.','https://drift.com',true,true,150000, freeTier:'Free basic version available', price:0, tips:'Owned by Salesloft | AI-powered "Playbooks" | Best for B2B lead gen'),
    t('gorgias-ai-pro-ecom','Gorgias','business','Leading support platform for e-commerce with AI-powered "Shopify" sync.','https://gorgias.com',true,true,120000, freeTier:'7-day free trial on site', price:50, priceTier:'Starter monthly', tips:'The absolute best for Shopify/e-com | AI-powered "Orders" | high ROI'),
    t('kustomer-ai-pro','Kustomer (Meta)','business','Leading enterprise CRM for support with high-end AI "Omnichannel" flows.','https://kustomer.com',false,true,84000, freeTier:'Acquired by Meta (Strategic)', price:0, tips:'Best for massive B2C brands | AI-powered "Single View" | Robust API'),
    t('happy-fox-ai-pro','HappyFox','business','Leading help desk and chat with AI-powered "Assist" and ticketing.','https://happyfox.com',false,false,45000, freeTier:'Demo available', price:29, priceTier:'Starter monthly', tips:'Best for enterprises | AI-powered "Workflows" | Highly secure and stable'),
    t('gladly-ai-pro-chat','Gladly','business','Modern support platform focused on people with AI-powered "Hero" help.','https://gladly.com',false,true,35000, freeTier:'Institutional only', price:150, priceTier:'Hero monthly per agent', tips:'Best for luxury brands | AI-powered "Conversation" history | High touch focus'),

    // ━━━ AI FOR BADMINTON & SQUASH ━━━
    t('bad-minton-ai-pro','Badminton Stats','lifestyle','Leading data and strategy platform for badminton using AI to track play.','https://badmintonstats.net',true,false,15000, freeTier:'Free basic stats online', price:0, tips:'Best for competitive players | AI-powered "Rankings" | high trust'),
    t('squash-ai-pro-data','Squash Analytics','lifestyle','Leading Squash tracking and strategy platform using AI for match logs.','https://squash-analytics.com',false,false,12000, freeTier:'Institutional only', price:0, tips:'Used by PSA pro players | AI-powered "Length" tracking | High end data'),
    t('court-hive-ai-pro','CourtHive','lifestyle','Leading Squash and Tennis coaching platform with AI-powered video data.','https://courthive.com',true,false,18000, freeTier:'Free basic version', price:0, tips:'Best for club coaches | AI-powered "Swing" timing | Reliable'),
    t('bad-minton-world','BWF (Official Data)','lifestyle','The global BWF database with AI-powered live scores and records.','https://bwfbadminton.com',true,true,250000, freeTier:'Completely free open stats', price:0, tips:'The official source for pro badminton | AI-powered "Match Center" | Iconic'),
    t('psa-squash-ai-pro','PSA World Tour (AI)','lifestyle','Official PSA squash platform using AI for world rankings and highlights.','https://psaworldtour.com',true,true,180000, freeTier:'Free open data and stats', price:0, tips:'The gold standard for pro squash | AI-powered "Live" tracking | International'),

    // ━━━ AI FOR MINUTE SCIENCE (Entomology & Malacology v3) ━━━
    t('ant-web-ai-pro-data','AntWeb','science','The world\'s largest database of ant images and data using AI for sorting.','https://antweb.org',true,true,35000, freeTier:'Completely free open data', price:0, tips:'Based at Cal Academy | AI-powered "Taxonomy" | Official global ant portal'),
    t('bug-guide-ai-pro','BugGuide','science','Leading community driven insect data in NA with AI-powered search help.','https://bugguide.net',true,true,250000, freeTier:'Completely free forever', price:0, tips:'Managed by Iowa State | AI-powered "Archive" | The bible of NA insects'),
    t('beetle-id-ai-pro','BeetleID','science','Identify coleoptera (beetles) instantly using AI-powered visual recognition.','https://beetleid.com',true,false,12000, freeTier:'Free basic identification', price:0, tips:'Best for beetle collectors | AI-powered "Specific" search | high trust'),
    t('mollusca-ai-pro','MolluscaBase','science','World data of all molluscs (shells, octopi) with AI-powered taxonomy.','https://molluscabase.org',true,true,15000, freeTier:'Completely free open data', price:0, tips:'Part of WoRMS | AI-powered "Literature" links | The scientific gold standard'),
    t('slug-id-ai-pro-sci','SlugID','science','Leading portal for identifying slugs and snails using AI and habitat data.','https://slugid.com',true,false,8400, freeTier:'Free basic identification', price:0, tips:'Best for garden and forest research | AI-powered "Mantle" analysis | Niche'),

    // ━━━ AI FOR CRAFTS (Textile & Quilting v2) ━━━
    t('quilt-id-ai-pro','Quilt ID (Digital)','lifestyle','Leading resource for quilters using AI to archive patterns and fabrics.','https://quiltid.com',true,false,15000, freeTier:'Free basic archive', price:0, tips:'Best for quilt history | AI-powered "Fabric" matching | high trust'),
    t('textile-soc-ai-pro','Textile Soc (Digital)','lifestyle','The Society of Dyers and Colourists using AI for textile data archives.','https://sdc.org.uk',true,false,12000, freeTier:'Free resources for students', price:0, tips:'Based in UK | AI-powered "Color" dictionary | high trust'),
    t('weave-ai-pro-design','Weave Architect','lifestyle','Leading design helper for handweavers using AI for loom patterns.','https://weavearchitect.com',true,false,18000, freeTier:'Free basic patterns', price:0, tips:'AI-powered "Draft" generator | Best for loom artists | high quality'),
    t('knit-purl-ai-pro','KnitPurl (AI)','lifestyle','Modern knitting tracker using AI for row counts and pattern help.','https://knitpurlapp.com',true,true,35000, freeTier:'Free basic version', price:0, tips:'Best for complex sweaters | AI-powered "Shape" guide | clean UI'),
    t('amigurumi-ai-pro','Amigurumi World','lifestyle','AI-powered pattern generator for Japanese crochet art (Amigurumi).','https://amigurumipatterns.net',true,true,58000, freeTier:'Free weekly patterns', price:0, tips:'Most popular crochet community | AI-powered "Cute" search | Global reach'),

    // ━━━ FINAL GEMS v34 (Modern Data Stack) ━━━
    t('snow-flake-ai-pro','Snowflake','code','The world\'s #1 AI data cloud with built-in "Cortex" for ML and data.','https://snowflake.com',true,true,500000, freeTier:'Free trial with \$400 credits', price:0, tips:'AI-powered "Cortex" is revolutionary | Best for large data teams | Industry giant'),
    t('data-bricks-ai-pro','Databricks','code','Leading data and AI company focused on lakehouse and high-end Mosaic AI.','https://databricks.com',true,true,350000, freeTier:'Free trial with community edition', price:0, tips:'Creator of Apache Spark | AI-powered "Mosaic" fine-tuning | The AI powerhouse'),
    t('fivetran-ai-pro-dat','Fivetran','code','The automated data pipeline platform with AI-powered connector sync.','https://fivetran.com',true,true,180000, freeTier:'Free forever basic version', price:0, tips:'AI-powered "Data" movement | Best for ETL into Snowflake | industry standard'),
    t('dbt-ai-pro-data','dbt (SQL)','code','Leading data transformation platform with AI-powered semantic help.','https://getdbt.com',true,true,250000, freeTier:'Free for individuals/small teams', price:100, priceTier:'Developer monthly', tips:'Best for SQL workflows | AI-powered "Cloud" IDE | High trust and standard'),
    t('air-byte-ai-pro-dat','Airbyte','code','Leading open-source data integration for AI and modern data stacks.','https://airbyte.com',true,true,150000, freeTier:'Free open source for self host', price:15, priceTier:'Cloud credit monthly', tips:'Best for custom connectors | AI-powered "Sync" | Rapidly growing favorite'),
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
