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
    // ━━━ AI FOR WEALTH & INVESTMENT v2 ━━━
    t('addepar-ai-pro','Addepar','business','Leading wealth management platform using AI for complex portfolio data.','https://addepar.com',false,true,35000, freeTier:'Institutional only', price:0, tips:'Industry standard for family offices | AI-powered data aggregation | High security'),
    t('envestnet-ai-pro','Envestnet','business','Leading wealth management technology using AI for financial wellness data.','https://envestnet.com',false,true,45000, freeTier:'Institutional only', price:0, tips:'Massive advisor network | AI-powered "Insights" | Integrated with Yodlee'),
    t('yodlee-ai-pro','Envestnet | Yodlee','business','The gold standard for financial data aggregation using high-end AI.','https://yodlee.com',false,true,84000, freeTier:'Demo available', price:0, tips:'Empower apps with bank data | AI-powered transaction labeling | Trusted by banks'),
    t('plaid-ai-pro','Plaid','business','Leading platform to connect bank accounts to apps with AI security.','https://plaid.com',true,true,250000, freeTier:'Free for personal dev credits', price:0, tips:'The bridge for modern fintech | AI-powered "Transfer" risk | Seamless and fast'),
    t('stripe-ai-pro','Stripe (AI)','business','Global payment infrastructure with AI-powered fraud (Radar) and data.','https://stripe.com',true,true,999999, freeTier:'Free to join and integrate', price:0, tips:'AI-powered "Radar" stops fraud | Best docs in the world | Industry legend'),
    t('robinhood-ai-pro','Robinhood (Sherwood)','business','Leading mobile trading app using AI for personalized news and help.','https://robinhood.com',true,true,999999, freeTier:'Completely free to trade stocks', price:5, priceTier:'Gold monthly', tips:'AI-powered "Sherwood" news | Best mobile UI | 24/5 trading support'),
    t('wealth-front-ai','Wealthfront','business','Leading robo-advisor using AI to optimize your long-term investments.','https://wealthfront.com',true,true,180000, freeTier:'Free for first \$5k managed (promo)', price:0, tips:'AI-powered tax-loss harvesting | Best automated savings | Clean design'),
    t('betterment-ai-pro','Betterment','business','The first robo-advisor using AI for personalized financial goals and data.','https://betterment.com',true,true,150000, freeTier:'Free to browse and plan', price:4, priceTier:'Digital monthly base', tips:'Best for goal-based investing | AI-powered retirement planning | Trusted'),
    t('m1-finance-ai','M1 Finance','business','The "Finance Super App" using AI for automated pies and borrowing.','https://m1.com',true,true,120000, freeTier:'Free basic version', price:3, priceTier:'Plus monthly annual', tips:'Build your own index with AI | Automated rebalancing | High value'),
    t('personal-cap-ai','Empower (Personal Capital)','business','Leading wealth management tool with AI-powered net worth tracking.','https://empower.com',true,true,250000, freeTier:'Completely free dashboard', price:0, tips:'Best for high-net-worth tracking | AI-powered "Feeds" | Secure and robust'),

    // ━━━ AI FOR LUXURY & HIGH-END LIFESTYLE ━━━
    t('net-jets-ai-pro','NetJets','lifestyle','Leading private jet company using AI for global fleet optimization.','https://netjets.com',false,true,35000, freeTier:'Institutional only', price:0, tips:'The gold standard for private flight | AI-powered "Owner" services | Global scale'),
    t('wheels-up-ai-pro','Wheels Up','lifestyle','Modern private aviation platform using AI for booking and logistics.','https://wheelsup.com',false,true,25000, freeTier:'Member app only', price:0, tips:'Acquired by Delta | AI-powered flight marketplace | High reliability'),
    t('evo-jets-ai-pro','evoJets','lifestyle','Private jet charter brokerage using AI for real-time pricing and data.','https://evojets.com',false,false,12000, freeTier:'Free price quotes online', price:0, tips:'Best for luxury charters | AI-powered fleet search | Global presence'),
    t('luxury-retreats','Luxury Retreats (Airbnb)','lifestyle','The world\'s most high-end vacation rentals using AI for concierge help.','https://airbnb.com/luxury',false,true,15000, freeTier:'Airbnb Luxe (new name)', price:0, tips:'Owned by Airbnb | AI-powered property vetting | 24/7 personal service'),
    t('one-finestay-ai','onefinestay','lifestyle','Leading luxury hospitality brand using AI for bespoke home stays.','https://onefinestay.com',false,true,18000, freeTier:'Accor hotels partner', price:0, tips:'Best for luxury flats in London/Paris | AI-powered guest services | Premium'),
    t('sothebys-ai-pro','Sotheby\'s (Digital)','lifestyle','The iconic auction house using AI for art valuation and discovery.','https://sothebys.com',true,true,250000, freeTier:'Free to browse and join', price:0, tips:'AI-powered "Art Indices" | High-end collection management | Global legacy'),
    t('christies-ai-pro','Christie\'s','lifestyle','Leading art and luxury business using AI for buyer insights and data.','https://christies.com',true,true,180000, freeTier:'Free to browse auctions', price:0, tips:'AI-powered "Collector" portal | Best for rare artifacts | Global leader'),
    t('artsy-ai-pro','Artsy','lifestyle','The world\'s largest online art marketplace with AI-powered "For You".','https://artsy.net',true,true,150000, freeTier:'Completely free to use', price:0, tips:'Track 1M+ artworks | AI-powered "Art Genome Project" | Best for collectors'),
    t('artory-ai-pro','Artory','lifestyle','Blockchain and AI-powered registry for art and collectibles.','https://artory.com',true,false,12000, freeTier:'Free to join', price:0, tips:'Secure art titles with AI | Verified provenance | High trust for investors'),
    t('masterworks-ai-pro','Masterworks','business','The first platform that lets you invest in multi-million dollar art with AI.','https://masterworks.com',false,true,58000, freeTier:'Free to join the waitlist', price:0, tips:'AI-powered art selection | Fractional ownership | Returns focus'),

    // ━━━ AI FOR MANUFACTURING & LOGISTICS v3 ━━━
    t('siemens-ai-pro','Siemens (MindSphere)','business','Leading industrial IoT platform using AI for factory automation.','https://siemens.com',false,true,84000, freeTier:'Institutional only', price:0, tips:'AI-powered "Digital Twin" | European industrial leader | Massive global scale'),
    t('ge-digital-ai','GE Digital (Proficy)','business','leading industrial software company using AI for grid and factory.','https://ge.com/digital',false,true,58000, freeTier:'Institutional only', price:0, tips:'AI-powered predictive maintenance | Energy and aviation focus | Robust'),
    t('abb-ability-ai','ABB Ability','business','Cross-industry digital software using AI for robotics and power.','https://abb.com',false,true,45000, freeTier:'Institutional only', price:0, tips:'World leader in industrial robotics | AI-powered energy grid | Global scale'),
    t('fanuc-ai-robot','FANUC (AI)','business','leading manufacturer of factory automation and robots with AI.','https://fanuc.com',false,true,35000, freeTier:'Institutional only', price:0, tips:'Japanese industrial legend | AI-powered robot vision | High reliability'),
    t('kuka-ai-pro','KUKA (Digital)','business','Leading industrial robotics company using AI for human-robot collab.','https://kuka.com',false,false,28000, freeTier:'Institutional only', price:0, tips:'Best for automotive factories | AI-powered "SmartPad" | German tech'),
    t('teradyne-ai-pro','Teradyne','business','Leading provider of automated test equipment and AI robots (UR).','https://teradyne.com',false,false,18000, freeTier:'Institutional only', price:0, tips:'Owned by Universal Robots | AI-powered collaborative arms | high end'),
    t('universal-robots-ai','Universal Robots','business','The world\'s #1 collaborative robot company using AI for "Cobots".','https://universal-robots.com',false,true,58000, freeTier:'Demo available', price:0, tips:'Easiest to program with AI | Best for SMB factories | Global leader'),
    t('honeywell-ai-pro','Honeywell (Forge)','business','Leading enterprise performance management for buildings and aero with AI.','https://honeywell.com',false,true,45000, freeTier:'Institutional only', price:0, tips:'AI-powered "Forge" platform | Sustainable buildings focus | Industrial scale'),
    t('emerson-ai-pro','Emerson (Plantweb)','business','Global technology and engineering company using AI for process labs.','https://emerson.com',false,true,32000, freeTier:'Institutional only', price:0, tips:'AI-powered process control | Oil and gas focus | Robust and secure'),
    t('rockwell-ai-pro','Rockwell Automation','business','Leading industrial automation and digital transformation with AI.','https://rockwellautomation.com',false,true,25000, freeTier:'Institutional only', price:0, tips:'AI-powered "FactoryTalk" | US industrial leader | Reliable and fast'),

    // ━━━ AI FOR TAX & ACCOUNTING v2 ━━━
    t('turbotax-ai-pro','TurboTax (Intuit)','business','The world\'s #1 tax prep software with AI-powered "Intuit Assist".','https://turbotax.com',true,true,999999, freeTier:'Free basic tax filing available', price:60, priceTier:'Deluxe starting', tips:'AI-powered "Maximum Refund" check | Most popular in US | Easy to use'),
    t('h-r-block-ai','H&R Block','business','Leading tax service using AI for digitized filing and expert help.','https://hrblock.com',true,true,500000, freeTier:'Free basic filing available', price:55, priceTier:'Deluxe starting', tips:'AI-powered "Tax Pro" matching | Virtual and in-person help | Reliable'),
    t('tax-slayer-ai','TaxSlayer','business','Fast and easy tax filing for everyone with AI-powered guidance.','https://taxslayer.com',true,true,250000, freeTier:'Free first-time filing available', price:30, priceTier:'Classic starting', tips:'Best value for money | AI-powered "Deduction" finder | clean UI'),
    t('tax-act-ai-pro','TaxAct','business','Leading tax prep platform focusing on accuracy and AI data.','https://taxact.com',true,false,180000, freeTier:'Free basic filing online', price:45, priceTier:'Deluxe starting', tips:'Best for small biz taxes | AI-powered "Accuracy" guarantee | Robust'),
    t('quickbooks-ai-pro','QuickBooks (Intuit)','business','The industry standard for small business accounting with AI (Assist).','https://quickbooks.com',true,true,999999, freeTier:'30-day free trial on site', price:30, priceTier:'Simple Start monthly', tips:'AI-powered receipt scanning | 1M+ small biz users | Integrated with bank'),
    t('xero-ai-accounting','Xero','business','Beautiful cloud accounting for small biz with AI-powered automation.','https://xero.com',true,true,500000, freeTier:'30-day free trial', price:15, priceTier:'Early plan monthly', tips:'Best for creative firms | AI-powered "Bank Rec" | Global presence'),
    t('fresh-books-ai','FreshBooks','business','Leading invoice and accounting for freelancers with AI-powered tracking.','https://freshbooks.com',true,true,350000, freeTier:'30-day free trial', price:17, priceTier:'Lite monthly', tips:'Best for service providers | AI-powered time tracking | Easy to use'),
    t('sage-ai-accounting','Sage (Intacct)','business','Leading enterprise and SMB accounting with AI-powered insights.','https://sage.com',false,true,250000, freeTier:'Free trial available', price:0, tips:'Best for mid-market firms | AI-powered "Intacct" | High trust/British leader'),
    t('bench-accounting-ai','Bench','business','Real bookkeeping for entrepreneurs with AI-powered data management.','https://bench.co',false,true,84000, freeTier:'1-month free bookkeeping', price:249, priceTier:'Core monthly billed annual', tips:'Best for high-growth startups | Real experts + AI | Peace of mind'),
    t('wave-accounting-ai','Wave','business','The best free accounting software for small businesses with AI info.','https://waveapps.com',true,true,250000, freeTier:'Completely free accounting', price:0, tips:'Best for solopreneurs | AI-powered invoices | Support and community'),

    // ━━━ FINAL GEMS v13 (Enterprise Data) ━━━
    t('snowflake-ai-pro','Snowflake (Cortex)','code','Leading cloud data platform with new AI-powered Cortex services.','https://snowflake.com',true,true,250000, freeTier:'Free trial with credits', price:0, tips:'The gold standard for data warehouse | AI-powered "Horizon" | Enterprise scale'),
    t('databricks-ai-pro','Databricks (Dolly)','code','The data and AI company building the world\'s first "Lakehouse" with AI.','https://databricks.com',true,true,180000, freeTier:'Community Edition free', price:0, tips:'Founded by spark creators | AI-powered "Mosaic AI" | Best for ML and big data'),
    t('mongodb-ai-pro','MongoDB (Atlas AI)','code','Leading developer data platform with built-in AI search and data help.','https://mongodb.com',true,true,500000, freeTier:'Free forever Atlas cluster', price:0, tips:'Best for document data | AI-powered "Vector Search" | Millions of devs'),
    t('elastic-search-ai','Elasticsearch (ELK)','code','Leading search and analytics engine with vector search and AI.','https://elastic.co',true,true,350000, freeTier:'Free open source (ELK)', price:95, priceTier:'Standard monthly base', tips:'Best for log data and site search | AI-powered "ESRE" | Scalable'),
    t('redis-ai-pro','Redis (Cloud)','code','The world\'s fastest real-time data platform with AI vector capabilities.','https://redis.com',true,true,250000, freeTier:'Free forever cloud tier', price:0, tips:'Lowest latency data | AI-powered "RedisVL" | Industry standard for cache'),
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
