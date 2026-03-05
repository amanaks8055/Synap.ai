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
    // ━━━ AI FOR DEV MONITORING & OPS (Iconic) ━━━
    t('data-dog-ai-pro','Datadog','code','The observability and security platform for cloud-scale apps with AI-powered Bits.','https://datadoghq.com',true,true,500000, freeTier:'Free for up to 5 hosts', price:15, priceTier:'Pro per host monthly annual', tips:'AI-powered "Bits" assistant for faster RCA | Best for multi-cloud | Industry standard'),
    t('new-relic-ai-pro','New Relic','code','Leading observability platform with AI-powered "Grok" and error tracking.','https://newrelic.com',true,true,350000, freeTier:'Free for 1 user and 100GB monthly', price:0, tips:'AI-powered "Grok" assistant | Best for full-stack monitoring | High trust'),
    t('dynatrace-ai-pro','Dynatrace','code','Unified observability and security platform with high-end AI "Davis".','https://dynatrace.com',false,true,180000, freeTier:'15-day free trial on site', price:0, tips:'AI-powered "Davis" engine is elite | Best for enterprise scale | automation king'),
    t('splunk-ai-pro-log','Splunk','code','The world leader in log management and security with AI-powered insights.','https://splunk.com',true,true,250000, freeTier:'Free version for up to 500MB/day', price:0, tips:'AI-powered "Mission Control" | Best for high security firms | Huge data scale'),
    t('grafana-ai-pro','Grafana Enterprise','code','Leading platform for open-source observability with AI-powered viz.','https://grafana.com',true,true,500000, freeTier:'Free version for up to 10k metrics', price:0, tips:'AI-powered "Sensa" alerts | Best visual dashboards | Open source leader'),
    t('elastic-ai-pro-log','Elastic (ELK)','code','Leading search and observability with AI-powered "Vector" and logs.','https://elastic.co',true,true,350000, freeTier:'Free open source for self host', price:16, priceTier:'Standard monthly cloud', tips:'The ELK stack gold standard | AI-powered "ESRE" for search | Robust'),
    t('sentry-ai-pro-err','Sentry','code','Leading platform for error tracking with AI-powered "Sentries" help.','https://sentry.io',true,true,350000, freeTier:'Free forever for individuals', price:26, priceTier:'Team monthly annual', tips:'Best for seeing errors in real-time | AI-powered "Issue" summaries | Modern UI'),
    t('pager-duty-ai-pro','PagerDuty','code','Leading incident response platform with AI-powered automation and triage.','https://pagerduty.com',true,true,180000, freeTier:'Free for up to 5 users', price:21, priceTier:'Professional monthly per user', tips:'AI-powered "AIOps" | Best for critical on-call teams | Industry standard'),
    t('honeycomb-ai-pro','Honeycomb','code','Leading observability for high-cardinality data with AI-powered Query.','https://honeycomb.io',true,true,84000, freeTier:'Free forever with 20M events', price:0, tips:'AI-powered "Query Assistant" | Best for complex microservices | Modern'),
    t('logz-io-ai-pro','Logz.io','code','Leading open-source based observability with AI-powered log management.','https://logz.io',true,false,45000, freeTier:'Free trial with 250MB daily', price:0, tips:'Best for ELK in the cloud | AI-powered "Insights" | Simple and fast'),

    // ━━━ AI FOR TRAVEL & TOURS (Experiences) ━━━
    t('viator-ai-pro-trip','Viator (Tripadvisor)','lifestyle','Leading platform for tours and activities with AI-powered recommendations.','https://viator.com',true,true,999999, freeTier:'Free app and membership', price:0, tips:'Access 300k+ global tours | AI-powered "Lists" | Owned by Tripadvisor'),
    t('get-your-guide-ai','GetYourGuide','lifestyle','Leading European platform for experiences and tours with AI-powered discovery.','https://getyourguide.com',true,true,500000, freeTier:'Free app for users', price:0, tips:'Best for European cities | AI-powered "Trending" | High quality focus'),
    t('klook-ai-pro-asia','Klook','lifestyle','Leading Asia-based travel platform for tours and transit with AI focus.','https://klook.com',true,true,500000, freeTier:'Free app and rewards', price:0, tips:'Best for Asia/Japan/KR | AI-powered "Passes" | High value and fast'),
    t('withlocals-ai-pro','Withlocals','lifestyle','Connect with locals for unique private tours using AI for matching.','https://withlocals.com',true,true,58000, freeTier:'Completely free to browse', price:0, tips:'Best for authentic local experiences | AI-powered "Host" matching | Cultural'),
    t('peek-ai-pro-trip','Peek','lifestyle','Leading software for activity businesses with AI-powered guest data.','https://peek.com',true,false,45000, freeTier:'Free to browse as users', price:0, tips:'Used by top activity operators | AI-powered "Calendar" | high trust'),
    t('fare-harbor-ai-pro','FareHarbor (Booking)','business','Leading reservation system for tours using AI for pricing and data logs.','https://fareharbor.com',false,false,35000, freeTier:'Institutional only', price:0, tips:'Owned by Booking.com | AI-powered "Reporting" | Best for boat/bus tours'),
    t('eat-with-ai-pro','Eatwith','lifestyle','Unique social dining experiences with locals using AI for matching.','https://eatwith.com',true,true,84000, freeTier:'Completely free to join', price:0, tips:'Best for culinary travel | AI-powered "Menu" search | High quality focus'),
    t('airbnb-experience','Airbnb Experiences','lifestyle','Unique activities led by local hosts with AI-powered quality check.','https://airbnb.com/experiences',true,true,999999, freeTier:'Completely free to browse', price:0, tips:'Most creative tours in the world | AI-powered "Photos" | Global reach'),
    t('civ-itatis-ai-pro','Civitatis','lifestyle','Leading Spanish-speaking platform for tours with AI-powered localized help.','https://civitatis.com',true,true,180000, freeTier:'Completely free members', price:0, tips:'Best for ES/LATAM travelers | AI-powered "Top" lists | High reliability'),
    t('headout-ai-pro-go','Headout','lifestyle','On-demand platform for local experiences with AI-powered "Last Minute" deals.','https://headout.com',true,false,120000, freeTier:'Free app and rewards', price:0, tips:'Best for shows and tickets | AI-powered "Availability" | high speed'),

    // ━━━ AI FOR GEOSCIENCE (Hydrology & Glaciology) ━━━
    t('hydro-data-ai-gov','USGS Water (AI)','science','Real-time monitoring of US rivers and streams with AI-powered flow data.','https://waterdata.usgs.gov',true,true,250000, freeTier:'Completely free open data', price:0, tips:'Official US portal | AI-powered "Flood" alerts | Critical for safety'),
    t('global-water-watch','Global Water Watch','science','Using satellite data and AI to track global freshwater resources.','https://globalwaterwatch.org.au',true,false,12000, freeTier:'Completely free for research', price:0, tips:'AI-powered "Reservoir" monitoring | High impact environmental tech'),
    t('glacier-ai-monitor','Global Glacier Monitor','science','Tracking the health of the world\'s glaciers using AI and satellite data.','https://wgms.ch',true,true,15000, freeTier:'Completely free open archives', price:0, tips:'Based in Switzerland | AI-powered "Mass Balance" | Essential for climate'),
    t('world-glacier-inv','World Glacier Inventory','science','Comprehensive database of global glaciers with AI-powered mapping.','https://nsidc.org',true,true,35000, freeTier:'Completely free open data', price:0, tips:'Managed by NSIDC | AI-powered "Cryosphere" data | High trust'),
    t('aqueduct-ai-water','Aqueduct (WRI)','science','Mapping high-water risk areas globally using AI-powered geospatial data.','https://wri.org/aqueduct',true,true,58000, freeTier:'Completely free for the public', price:0, tips:'Best for ESG and planning | AI-powered "Water Stress" | Global scale'),

    // ━━━ AI FOR FINANCE (Taxes & Accounting v3) ━━━
    t('turbo-tax-ai-pro','TurboTax (AI)','business','The #1 US tax software with AI-powered "Intuit Assist" for filing.','https://turbotax.intuit.com',true,true,999999, freeTier:'Free basic filing for simple returns', price:60, priceTier:'Deluxe starting per return', tips:'AI-powered "Audit" defense | Use "Intuit Assist" for questions | Industry leader'),
    t('h-and-r-block-ai','H&R Block (AI)','business','Leading tax platform with AI-powered "Expert" chat and automated filing.','https://hrblock.com',true,true,500000, freeTier:'Free online basic version', price:35, priceTier:'Deluxe starting per return', tips:'AI-powered "Max Refund" guarantee | Best for physical/digital hybrid'),
    t('tax-slayer-ai-pro','TaxSlayer','business','Fast and affordable tax filing with AI-powered error checking.','https://taxslayer.com',true,true,250000, freeTier:'Free basic version available', price:20, priceTier:'Classic starting per return', tips:'Best value for pro filers | AI-powered "Deduction" finder | Reliable'),
    t('free-tax-usa-ai','FreeTaxUSA','business','Leading low-cost tax filing with AI-powered state and federal data.','https://freetaxusa.com',true,true,350000, freeTier:'Free federal for everyone', price:15, priceTier:'State return fee', tips:'Favorite of frugal filers | AI-powered "Accuracy" check | High trust'),
    t('tax-jar-ai-pro-biz','TaxJar (Stripe)','business','Leading sales tax automation for e-commerce with AI-powered nexus.','https://taxjar.com',true,true,120000, freeTier:'30-day free trial on site', price:19, priceTier:'Starter monthly starting', tips:'Owned by Stripe | AI-powered "AutoFile" is elite | Best for US sellers'),
    t('avalara-ai-pro-tax','Avalara','business','Leading global tax compliance with AI-powered cross-border data.','https://avalara.com',false,true,84000, freeTier:'Institutional only', price:0, tips:'Best for global corporations | AI-powered "VAT" help | Industry standard'),
    t('tax-fix-ai-pro-eu','Taxfix','business','Leading European tax app with AI-powered mobile filing and logic.','https://taxfix.de',true,true,150000, freeTier:'Free to calculate your refund', price:40, priceTier:'Flat fee per submission', tips:'Best for Germany/France/Italy | AI-powered "Chat" | fast and clean'),
    t('clear-tax-ai-india','Clear (ClearTax)','business','India\'s leading tax and GST platform with AI-powered e-filing.','https://clear.in',true,true,500000, freeTier:'Free basic income tax filing', price:0, tips:'Best for Indian business and individuals | AI-powered "GST" sync | Huge scale'),
    t('quick-books-tax-ai','QuickBooks Tax','business','Leading small business accounting with AI-powered real-time tax labs.','https://quickbooks.intuit.com',true,true,500000, freeTier:'30-day free trial on site', price:30, priceTier:'Simple Start monthly', tips:'Best for freelancers | AI-powered "Self-Employed" | Highly trusted'),
    t('xero-tax-ai-pro','Xero Tax','business','Leading cloud accounting with AI-powered regional tax automation.','https://xero.com',true,true,350000, freeTier:'30-day free trial on site', price:15, priceTier:'Starter monthly starting', tips:'Best for global small/mid firms | AI-powered "Reporting" | modern UI'),

    // ━━━ FINAL GEMS v27 (Modern Database) ━━━
    t('supabase-ai-pro-db','Supabase','code','The open-source Firebase alternative with built-in AI (Postgres/Vectors).','https://supabase.com',true,true,500000, freeTier:'Free forever basic project', price:25, priceTier:'Pro monthly base', tips:'Best for Flutter/React devs | AI-powered "SQL" assistant | Industry favorite'),
    t('planet-scale-ai-db','PlanetScale','code','World\'s most advanced serverless MySQL with AI-powered "Rewind" and scale.','https://planetscale.com',true,true,250000, freeTier:'Free hobby tier available', price:29, priceTier:'Scaler monthly base', tips:'Best for massive scaling | AI-powered "Insights" | High durability'),
    t('neon-ai-pro-db','Neon','code','Serverless Postgres platform with AI-powered "Autoscaling" and branch.','https://neon.tech',true,true,120000, freeTier:'Free forever hobby project', price:19, priceTier:'Launch monthly annual', tips:'Best for fast branching | AI-powered "Database" help | Modern cloud'),
    t('pinecone-ai-pro-db','Pinecone','code','Leading vector database for building high-end AI applications and search.','https://pinecone.io',true,true,350000, freeTier:'Free basic index for starters', price:0, tips:'The gold standard for AI vectors | AI-powered "Search" | Enterprise scale'),
    t('mongo-db-ai-atlas','MongoDB Atlas','code','Leading document database with built-in AI "Vector Search" and cloud.','https://mongodb.com/atlas',true,true,999999, freeTier:'Free forever basic cluster', price:0, tips:'The market leader | AI-powered "Atlas Search" | Globally distributed'),
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
