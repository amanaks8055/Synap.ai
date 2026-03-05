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
    // ━━━ AI FOR HR & RECRUITING (Iconic) ━━━
    t('work-day-ai','Workday (AI)','business','The world\'s #1 HR platform with integrated AI for talent and finance labs.','https://workday.com',false,true,999999, freeTier:'Demo available', price:0, tips:'The enterprise standard | AI-powered "Skills Cloud" is elite | Global leader'),
    t('hi-bob-ai-pro','HiBob','business','Modern HR platform for high-growth companies with AI-powered engagement help.','https://hibob.com',false,true,350000, freeTier:'Demo available', price:0, tips:'Best for startups and mid-market | AI-powered "Culture" feedback | clean UI'),
    t('lattice-ai-pro','Lattice','business','Leading people management platform with AI-powered goals and feedback help.','https://lattice.com',false,true,250000, freeTier:'Demo available', price:11, priceTier:'Individual monthly annual', tips:'Best for performance reviews | AI-powered "Summary" is high value'),
    t('green-house-ai','Greenhouse','business','Leading recruiting platform with AI-powered hiring and equity tools.','https://greenhouse.io',false,true,180000, freeTier:'Institutional only', price:0, tips:'Best for interview planning | AI-powered "Sourcing" help | reliable'),
    t('lever-ai-pro-hires','Lever (Employ)','business','Leading modern ATS with AI-powered candidate relationship management help.','https://lever.co',false,true,120000, freeTier:'Institutional only', price:0, tips:'Best for diverse hiring | AI-powered "Pipeline" automation | high trust'),

    // ━━━ AI FOR FINANCE & ERP (Iconic) ━━━
    t('oracle-erp-ai','Oracle Cloud ERP (AI)','business','Leading enterprise ERP giant using high-end AI for finance and supply.','https://oracle.com/erp',false,true,999999, freeTier:'Free trial for clouds', price:0, tips:'The global finance standard | AI-powered "Accounting" automation | robust'),
    t('sap-ai-pro-erp','SAP (AI Foundation)','business','The world\'s #1 ERP platform with built-in "Joule" AI for business pros.','https://sap.com',false,true,999999, freeTier:'Limited free trial', price:0, tips:'Industry giant | AI-powered "Supply Chain" is the gold standard | Global'),
    t('net-suite-ai-pro','Oracle NetSuite (AI)','business','Leading all-in-one cloud ERP for mid-market with AI-powered insights.','https://netsuite.com',false,true,500000, freeTier:'Institutional only', price:0, tips:'Best for scaling companies | AI-powered "Planning" is elite | High trust'),
    t('quick-books-ai','QuickBooks (Intuit Assist)','business','The world\'s #1 small biz accounting with AI-powered "Intuit Assist" help.','https://quickbooks.intuit.com',true,true,999999, freeTier:'Free trial for 30 days', price:15, priceTier:'Simple Start monthly', tips:'Best for small biz | AI-powered "Cash Flow" forecasting is great'),
    t('xero-ai-pro-acc','Xero (AI)','business','Leading global cloud accounting with AI-powered "Ask" and bank reconciliation.','https://xero.com',true,true,500000, freeTier:'Free trial for 30 days', price:15, priceTier:'Starter monthly annual', tips:'Best for modern accountants | AI-powered "Hubdoc" data entry | high reach'),

    // ━━━ AI FOR LOGISTICS & MARITIME (Iconic) ━━━
    t('maersk-ai-pro-ship','Maersk (Digital)','business','The world\'s #1 shipping giant using AI for global logistics and data.','https://maersk.com',true,true,999999, freeTier:'Completely free tools for public', price:0, tips:'AI-powered "Predictive" shipping | Best for global trade | Iconic'),
    t('zero-ai-pro-mar','ZeroNorth (Maritime)','business','Leading platform for optimizing maritime fuel and routing using AI labs.','https://zeronorth.com',false,true,35000, freeTier:'Institutional only', price:0, tips:'Save CO2 with AI | Best for shipping fleets | Danish tech powerhouse'),
    t('vessel-bot-ai','VesselBot','business','Leading supply chain visibility platform using AI for maritime and road.','https://vesselbot.com',false,false,15000, freeTier:'Demo available', price:0, tips:'AI-powered "Emissions" tracking | Best for global sustainability | robust'),
    t('sea-id-ai-pro-nav','SeaID','business','Professional maritime data and navigation platform using AI for safety logs.','https://seaid.net',false,false,12000, freeTier:'Institutional only', price:0, tips:'Used by pro nav teams | AI-powered "Route" safety | precision mapping'),
    t('cargo-ai-pro-log','Cargo.ai','business','Leading air freight digital platform with AI-powered booking and data.','https://cargoai.co',true,true,58000, freeTier:'Free for freight forwarders', price:0, tips:'Best for air cargo price search | AI-powered "Carbon" calc | clean UI'),

    // ━━━ AI FOR AEROSPACE & DEFENSE (Iconic) ━━━
    t('lock-heed-ai-pro','Lockheed Martin (AI)','science','Global defense giant using AI for autonomous flight and mission logs.','https://lockheedmartin.com',false,true,999999, freeTier:'Institutional only', price:0, tips:'The gold standard for aerospace AI | Best for defense pros | High tech'),
    t('ray-theon-ai-pro','Raytheon (RTX)','science','Leading aerospace and defense company using AI for threat detect and labs.','https://rtx.com',false,true,500000, freeTier:'Institutional only', price:0, tips:'AI-powered "Sensor" fusion | Best for security tech | High trust'),
    t('pal-antir-ai-pro','Palantir (AIP)','code','Leading big data company with high-end AI "AIP" platform for enterprise.','https://palantir.com',false,true,350000, freeTier:'Institutional only', price:0, tips:'The ultimate data platform | AI-powered "Ontology" is revolutionary | robust'),
    t('and-uril-ai-pro','Anduril (Lattice)','code','Leading defense tech company using AI-powered "Lattice" for autonomous systems.','https://anduril.com',false,true,120000, freeTier:'Institutional only', price:0, tips:'Founded by Palmer Luckey | AI-powered "Detection" | Hardware/Software sync'),
    t('shield-ai-pro-pil','Shield AI (Hivemind)','code','Leading aerospace company with AI "Hivemind" that pilots jets autonomously.','https://shield.ai',false,true,84000, freeTier:'Institutional only', price:0, tips:'The "Top Gun" of AI | Best for autonomous air combat | High innovation'),

    // ━━━ FINAL GEMS v42 (Modern AI Monitoring) ━━━
    t('data-dog-ai-pro','Datadog (Bits AI)','code','Leading monitoring platform with new AI-powered "Bits" assistant for devops.','https://datadoghq.com',true,true,500000, freeTier:'Free for up to 5 hosts', price:15, priceTier:'Infrastructure monthly annual', tips:'AI-powered "Anomaly" detection is elite | Best for cloud ops | Industry leader'),
    t('splunk-ai-pro-dat','Splunk (AI)','code','The world\'s #1 observability giant with integrated AI for security and logs.','https://splunk.com',true,true,350000, freeTier:'Free trial for cloud hosts', price:0, tips:'Enterprise gold standard | AI-powered "Predictive" ops | High trust'),
    t('new-relic-ai-pro','New Relic (Grocco)','code','Leading observability platform with high-end AI-powered insights and logs.','https://newrelic.com',true,true,180000, freeTier:'Free forever with 100GB/mo', price:0, tips:'Best for full-stack visibility | AI-powered "Alerts" | highly robust'),
    t('dyn-at-race-ai','Dynatrace (Davis AI)','code','Leading platform for enterprise observability with high-end "Davis" AI lab.','https://dynatrace.com',true,true,150000, freeTier:'Free trial for 15 days', price:0, tips:'AI-powered "Root Cause" analysis | Best for massive clouds | High tech'),
    t('graf-ana-ai-pro','Grafana (AI)','code','The world\'s #1 visualization tool for data with AI-powered query help.','https://grafana.com',true,true,999999, freeTier:'Free forever cloud basic', price:0, tips:'Open source standard | AI-powered "Trace" and "Log" help | clean and powerful'),
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
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        uploaded += batch.length;
        print('OK $uploaded/${tools.length}');
      } else {
        final respBody = await utf8.decodeStream(resp);
        print('FAIL at $i [${resp.statusCode}]: $respBody');
      }
    } catch (e) {
      print('ERR at $i: $e');
    }
  }

  client.close();
  print('DONE! Uploaded $uploaded tools with full pricing data');
}
