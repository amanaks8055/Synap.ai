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
    // ━━━ AI FOR PERSONAL FINANCE & INVESTING (Rising stars) ━━━
    t('copilot-money-ai','Copilot Money','finance','Modern high-end personal finance app with AI-powered categorization and insights.','https://copilot.money',true,true,150000, freeTier:'1-month free trial', price:13, priceTier:'Monthly subscription', tips:'Best for Apple users | AI learns your spending patterns | Clean and powerful UI'),
    t('monarch-money-ai','Monarch Money','finance','Full-stack personal finance and budgeting platform with AI-powered tracking.','https://monarchmoney.com',true,true,180000, freeTier:'7-day free trial', price:15, priceTier:'Monthly billed annually', tips:'Best for couples | AI-powered "Sanity Check" | Robust wealth tracking'),
    t('rocket-money-ai','Rocket Money','finance','AI-powered app to find and cancel subscriptions, lower bills, and budget.','https://rocketmoney.com',true,true,250000, freeTier:'Free basic version', price:0, tips:'Formerly TrueBill | AI-powered bill negotiation | Best for saving money'),
    t('ynab-ai-pro','YNAB (You Need A Budget)','finance','Leading budget software following a proven method with AI-powered support.','https://ynab.com',true,true,150000, freeTier:'34-day free trial', price:15, priceTier:'Monthly subscription', tips:'Give every dollar a job | AI-powered target setting | Life-changing for many'),
    t('tiller-money-ai','Tiller Money','finance','Spreadsheet-based personal finance with AI-powered data feeds to Sheets/Excel.','https://tillerlearning.com',true,true,84000, freeTier:'30-day free trial', price:7, priceTier:'Monthly billed annually', tips:'Best for spreadsheet fans | AI-powered "AutoCat" | Full data control'),
    t('magnifi-ai-invest','Magnifi','finance','The world\'s first AI-powered investing assistant for personal portfolios.','https://magnifi.com',true,true,45000, freeTier:'Free basic search', price:14, priceTier:'Monthly subscription', tips:'Ask any investing question | AI-powered stock discovery | SEC regulated data'),
    t('wealthfront-ai-pro','Wealthfront','finance','Leading automated investment service with AI-powered "Path" financial planning.','https://wealthfront.com',true,true,250000, freeTier:'Free financial planning tools', price:0.25, priceTier:'Annual advisory fee', tips:'Best for passive investors | AI-powered tax-loss harvesting | Smart cash account'),
    t('betterment-ai-pro','Betterment','finance','Pioneer in robo-advisory with AI-powered goal setting and portfolios.','https://betterment.com',true,true,180000, freeTier:'Free to join', price:4, priceTier:'Monthly base or 0.25%', tips:'Automated diversified investing | AI-powered retirement planning | Easy to use'),
    t('m1-finance-ai','M1 Finance','finance','The finance super-app using AI for automated "Pie" based investing.','https://m1.com',true,true,120000, freeTier:'Free basic account', price:3, priceTier:'M1 Plus starting monthly', tips:'Customize your own portfolios | AI-powered "Dynamic Rebalancing" | High control'),
    t('robinhood-ai-pro','Robinhood (Gold)','finance','Leading mobile investing app with AI-powered market insights and data.','https://robinhood.com',true,true,999999, freeTier:'Free basic trade app', price:5, priceTier:'Robinhood Gold monthly', tips:'24-hour market access | AI-powered news summaries | 5% on cash with Gold'),

    // ━━━ AI FOR JOURNALISM & CONTENT CREATORS ━━━
    t('substack-ai-tools','Substack AI','writing','Leading platform for independent writers with AI-powered tools and audio.','https://substack.com',true,true,500000, freeTier:'Free for writers/readers', price:0, tips:'AI-powered voice voiceovers | Best for newsletters | High organic growth'),
    t('beehiiv-ai-pro','beehiiv','writing','The newsletter platform built for growth with AI-powered writing tools.','https://beehiiv.com',true,true,150000, freeTier:'Free for up to 2500 subs', price:42, priceTier:'Scale monthly', tips:'AI-powered "Ad Network" | Integrated referral program | Best for pros'),
    t('ghost-ai-pro','Ghost','writing','Professional open-source platform for independent journalism with AI.','https://ghost.org',true,true,120000, freeTier:'Free open source self-host', price:9, priceTier:'Starter monthly (hosted)', tips:'Non-profit and open source | AI-powered integration library | No fees from subs'),
    t('medium-ai-pro','Medium','writing','The largest open platform for writers with AI-powered content signals.','https://medium.com',true,true,999999, freeTier:'Free limited reading', price:5, priceTier:'Monthly membership', tips:'AI-powered "For You" feed | Partner program for earning | Huge built-in audience'),
    t('muck-rack-ai','Muck Rack','business','The most powerful platform for PR and journalism using AI for tracking.','https://muckrack.com',false,true,45000, freeTier:'Institutional only', price:0, tips:'Track journalists in real-time | AI-powered "Press Pal" | Industry standard'),
    t('critical-mention-ai','Critical Mention','business','Real-time news monitoring platform using AI for sentiment and alerts.','https://criticalmention.com',false,true,12000, freeTier:'Demo available', price:0, tips:'Track TV, radio, and social with AI | Used by major PR firms | Fast and accurate'),
    t('meltwater-ai-pro','Meltwater','business','Leading global media intelligence and social analytics with AI.','https://meltwater.com',false,true,58000, freeTier:'Demo available', price:0, tips:'AI-powered crisis detection | Strategic media insights | Global scale'),
    t('cision-ai-pro','Cision','business','The industry standard for PR and media intelligence using high-end AI.','https://cision.com',false,true,84000, freeTier:'Institutional only', price:0, tips:'Largest media database | AI-powered "Impact" metrics | Strategic intelligence'),
    t('factal-ai-news','Factal','news','Real-time AI-powered news for journalists and crisis managers.','https://factal.com',true,false,15000, freeTier:'Free trial for newsrooms', price:0, tips:'Hyper-accurate crisis alerts | AI verifies social media news | Trusted by big tech'),
    t('dataminr-ai-pro','Dataminr','news','Leading real-time AI platform for identifying high-impact news and events.','https://dataminr.com',false,true,35000, freeTier:'Institutional only', price:0, tips:'First alert for global news | AI-powered edge computation | Leading in news tech'),

    // ━━━ AI FOR RELIGION & SPIRITUALITY v2 ━━━
    t('youversion-ai','YouVersion (Bible App)','lifestyle','The world\'s #1 Bible app with AI-powered reading plans and search.','https://bible.com',true,true,999999, freeTier:'Completely free forever', price:0, tips:'1000+ translations | AI-powered "Daily Refresh" | Largest global community'),
    t('bible-gateway-ai','Bible Gateway','lifestyle','Leading online Bible search and tools with AI-powered library.','https://biblegateway.com',true,true,500000, freeTier:'Completely free to use', price:5, priceTier:'Plus monthly', tips:'Professional academic tools | AI-powered commentaries | Multi-device'),
    t('hallow-ai-pro','Hallow','lifestyle','The world\'s #1 Catholic prayer and meditation app with AI audio.','https://hallow.com',true,true,250000, freeTier:'Free basic version', price:10, priceTier:'Premium monthly', tips:'Guided prayers by Mark Wahlberg | AI-powered "Daily Gospel" | High quality audio'),
    t('insight-timer-ai','Insight Timer','lifestyle','Largest library of free meditations with AI-powered recommendations.','https://insighttimer.com',true,true,500000, freeTier:'Completely free version available', price:10, priceTier:'Member plus monthly', tips:'Best for yoga and mindfulness | AI metrics tracking | Global teacher community'),
    t('abide-ai-prayer','Abide','lifestyle','Leading Christian meditation app with AI-powered sleep stories.','https://abide.co',true,true,120000, freeTier:'Free basic sessions', price:8, priceTier:'Premium monthly annual', tips:'Biblical sleep aid | AI-powered "Daily Prayer" | Trusted and serene'),
    t('pray-com-ai-pro','Pray.com','lifestyle','The world\'s #1 app for daily prayer and faith-based audio content.','https://pray.com',true,true,150000, freeTier:'Free basic version', price:10, priceTier:'Premium monthly', tips:'Bible stories for kids | AI-powered prayer tracking | Huge celebrity narrator list'),
    t('islam360-ai-pro','Islam360','lifestyle','Comprehensive Islamic app with AI-powered Quran search and hadith.','https://islam360.app',true,true,180000, freeTier:'Completely free basic', price:0, tips:'Best for Quranic research | AI-powered translations | Global 10M+ users'),
    t('muslim-pro-ai','Muslim Pro','lifestyle','World\'s most popular Muslim app with AI-powered prayer times and qibla.','https://muslimpro.com',true,true,500000, freeTier:'Free basic version', price:4, priceTier:'Premium monthly', tips:'AI-powered "Qalbox" video | Multi-language Quran | Trusted for 10+ years'),
    t('sikh-net-ai','SikhNet','lifestyle','Leading resource for Sikhism with AI-powered Gurbani search and media.','https://sikhnet.com',true,true,45000, freeTier:'Completely free for everyone', price:0, tips:'largest Sikh media library | AI-powered "Gurmat" research | Non-profit'),
    t('chabad-ai-org','Chabad.org','lifestyle','Leading Jewish knowledge base with AI-powered Torah study tools.','https://chabad.org',true,true,150000, freeTier:'Completely free for everyone', price:0, tips:'Daily Torah study with AI | Ask the Rabbi AI assistant | Largest digital archive'),

    // ━━━ AI FOR CONSTRUCTION & ENGINEERING v2 ━━━
    t('bentley-synchro','Bentley SYNCHRO','science','4D construction management software with AI-powered site visualization.','https://bentley.com/synchro',false,true,12000, freeTier:'Institutional only', price:0, tips:'Sync schedule and 3D model with AI | Best for complex infrastructure | Leading tech'),
    t('oracle-construction-ai','Oracle Construction (Primavera)','business','Cloud-based construction management with AI-powered risk analysis.','https://oracle.com/construction',false,true,35000, freeTier:'Institutional only', price:0, tips:'Enterprise gold standard | AI identifies project delays | Robust and secure'),
    t('fieldwire-ai-pro','Fieldwire','business','The #1 jobsite management platform for construction with AI tracking.','https://fieldwire.com',true,true,45000, freeTier:'Free for small teams (5 users)', price:29, priceTier:'Pro per user monthly', tips:'Manage plans and tasks on mobile | AI-powered sheet syncing | Trusted by ENR 400'),
    t('struction-site-ai','StructionSite (Hilti)','business','AI-powered jobsite reality capture and 360-degree photo tracking.','https://structionsite.com',false,true,15000, freeTier:'Demo available', price:0, tips:'Acquired by Hilti | AI identifies construction progress | Best for large GC'),
    t('openspace-ai-pro','OpenSpace','business','Leading 360-degree photo documentation and progress tracking with AI.','https://openspace.ai',false,true,18000, freeTier:'Demo available', price:0, tips:'AI-powered "Vision Engine" | Automatic mapping from video | Leading in reality capture'),
    t('construct-bi-ai','ConstructBI','business','AI-powered business intelligence specifically for construction companies.','https://constructbi.com',false,false,5600, freeTier:'Demo available', price:0, tips:'Analyze job costs with AI | Integrated with Sage and Procore | Data-driven'),
    t('togal-ai-pro','Togal.ai','business','AI-powered construction estimating and takeoff software for speed.','https://togal.ai',false,true,12000, freeTier:'Free trial for 2 weeks', price:250, priceTier:'Monthly per user', tips:'Complete takeoffs in seconds with AI | Highest accuracy for 2D plans | Easy integration'),
    t('esticom-ai-pro','Esticom','business','Cloud-based construction takeoff and estimating software with AI.','https://esticom.com',false,false,8400, freeTier:'14-day free trial', price:80, priceTier:'Per user monthly billed annual', tips:'Acquired by Procore | AI-powered symbol recognition | Best for trade contractors'),
    t('kreo-ai-pro','Kreo','business','AI-powered construction estimating and scheduling for BIM workflows.','https://kreo.net',true,false,9200, freeTier:'Free basic viewer', price:75, priceTier:'Pro monthly', tips:'Best for BIM experts | AI-powered automatic takeoffs | Multi-language'),
    t('buildots-ai-pro','Buildots','business','AI-powered construction control center using computer vision for site.','https://buildots.com',false,false,5600, freeTier:'Institutional only', price:0, tips:'Automatic discrepancy detection | AI analyzes site images | High-end enterprise'),

    // ━━━ AI FOR DEVELOPER EXPERIENCE (DevEx) & DOCS ━━━
    t('gitbook-ai-pro','GitBook','code','Modern documentation platform for teams with AI-powered search.','https://gitbook.com',true,true,150000, freeTier:'Free for open source/personal', price:8, priceTier:'Plus per user monthly', tips:'AI "Lens" for asking docs questions | Beautiful design | Integrated with GitHub'),
    t('mintlify-ai-pro','Mintlify','code','The modern standard for developer documentation with AI-powered writing.','https://mintlify.com',true,true,45000, freeTier:'Free forever basic for personal', price:120, priceTier:'Startup plan monthly', tips:'AI writes your docs from code | Best for high-growth startups | High performance'),
    t('readme-ai-pro','ReadMe','code','Leading interactive API documentation platform with AI support.','https://readme.com',true,true,58000, freeTier:'Free trial available', price:99, priceTier:'Startup monthly', tips:'Best for API first companies | AI-powered "Owlly" assistant | Interactive explorers'),
    t('docusaurus-ai-pro','Docusaurus','code','Easy to build open source documentation with AI-powered search plugins.','https://docusaurus.io',true,true,180000, freeTier:'Completely free open source', price:0, tips:'Created by Meta | Best for React devs | Thousands of community plugins'),
    t('pocus-ai-pro','Pocus','business','The #1 Product-Led Sales platform using AI to identify best leads.','https://pocus.com',false,true,12000, freeTier:'Demo available', price:0, tips:'AI identifies which users to talk to | Best for PLG startups | Data-driven'),
    t('linear-ai-pro','Linear','code','The issue tracker for high-performance teams with AI-powered triage.','https://linear.app',true,true,250000, freeTier:'Free for unlimited members basic', price:8, priceTier:'Standard monthly', tips:'Fastest issue tracker | AI-powered "Sentry" integration | Clean and professional'),
    t('raycast-ai-docs','Raycast (AI Docs)','code','Instant access to developer docs directly from your Mac with AI.','https://raycast.com',true,true,120000, freeTier:'Free basic version', price:0, tips:'No more tab switching | AI-powered fuzzy search | Community provided doc sets'),
    t('stack-overflow-ai','Stack Overflow AI','code','Leading knowledge base for devs with new AI-powered "OverflowAI".','https://stackoverflow.co/ai',true,true,999999, freeTier:'Free for public community', price:0, tips:'AI summarizes trusted answers | Semantic search for code | Industry standard'),
    t('tldraw-ai-pro','tldraw','code','Collaborative whiteboard with AI-powered design to code features.','https://tldraw.com',true,true,150000, freeTier:'Completely free to use', price:0, tips:'"Make Real" AI tool turns sketches to code | Open source and fast | Best for prototyping'),
    t('supabase-ai-sql','Supabase (AI)','code','The open source Firebase alternative with AI-powered "Studio" tools.','https://supabase.com',true,true,250000, freeTier:'Free tier available (2 DBs)', price:25, priceTier:'Pro monthly base', tips:'AI generates SQL and migrations | Built-in vector support | Developer favorite'),
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
