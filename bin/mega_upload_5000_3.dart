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
    // ━━━ AI FOR AUTOMOTIVE & AUTONOMOUS (Iconic) ━━━
    t('tesla-ai-pro-fpc','Tesla (FSD/Autopilot)','lifestyle','The world\'s #1 autonomous driving system using high-end vision-based AI.','https://tesla.com',false,true,999999, freeTier:'Standard Safety Autopilot included', price:99, priceTier:'FSD Subscription monthly', tips:'AI-powered "Full Self-Driving" | The vision-only pioneer | Global leader'),
    t('rivian-ai-pro','Rivian (Driver+)','lifestyle','Leading electric truck maker using AI for advanced driver assistance and logs.','https://rivian.com',true,true,500000, freeTier:'Driver+ included in vehicle', price:0, tips:'Best for adventure tech | AI-powered "Gear Guard" security | High trust'),
    t('waymo-ai-pro-cab','Waymo (Google)','lifestyle','Alphabet\'s autonomous ride-hailing service using high-end AI labs and sensors.','https://waymo.com',true,true,350000, freeTier:'Free app, pay per ride', price:0, tips:'The world\'s #1 robotaxi | AI-powered "Lidar" fusion | Extremely safe'),
    t('cruise-ai-pro-car','Cruise (General Motors)','lifestyle','Leading autonomous vehicle company focused on urban ride-hailing and AI.','https://getcruise.com',true,true,250000, freeTier:'Free app, pay per ride', price:0, tips:'AI-powered "Origin" vehicle | Best for city navigating | GM backed'),
    t('ford-ai-pro-blue','Ford (BlueCruise)','lifestyle','Ford\'s hands-free driving technology using AI-powered cameras and maps.','https://ford.com',true,true,180000, freeTier:'90-day free trial on new cars', price:75, priceTier:'Monthly membership', tips:'Best for highway cruising | AI-powered "Hands-free" | iconic heritage'),

    // ━━━ AI FOR ENERGY & GRID (Iconic) ━━━
    t('grid-ai-pro-ener','Grid AI (Energy)','science','Leading platform for grid optimization and energy forecasting using AI labs.','https://grid.ai',false,true,120000, freeTier:'Institutional only', price:0, tips:'Best for utility companies | AI-powered "Demand" prediction | clean energy focus'),
    t('en-phase-ai-sol','Enphase (Enlighten)','science','The world\'s #1 solar inverter company using AI for energy storage and monitoring.','https://enphase.com',true,true,350000, freeTier:'Completely free tools for owners', price:0, tips:'AI-powered "Storm Guard" | Best for home solar | High reliability'),
    t('solar-edge-ai-pro','SolarEdge (Digital)','science','Leading solar tech giant using AI-powered power optimizers and data logs.','https://solaredge.com',true,true,250000, freeTier:'Free app and portal for users', price:0, tips:'AI-powered "Monitoring" | Best for production tracking | global leader'),
    t('next-era-ai-pro','NextEra Energy (AI)','science','The world\'s largest renewable energy company using AI for wind and solar.','https://nexteraenergy.com',false,true,84000, freeTier:'Institutional only', price:0, tips:'Best for energy investors | AI-powered "Yield" forecasting | massive scale'),
    t('stem-ai-pro-bat','Stem (Athena)','science','Leading AI-driven energy storage and grid management for enterprise.','https://stem.com',false,true,58000, freeTier:'Institutional only', price:0, tips:'AI-powered "Athena" engine | Best for smart buildings | High innovation'),

    // ━━━ AI FOR HEALTHCARE & BIOTECH (Iconic) ━━━
    t('epic-ai-pro-health','Epic (Cosmos)','health','The world\'s #1 electronic health record (EHR) with high-end AI research data.','https://epic.com',false,true,999999, freeTier:'Institutional only', price:0, tips:'Used by the best hospitals | AI-powered "Cosmos" data is massive | Industry giant'),
    t('cerner-ai-pro','Oracle Health (Cerner)','health','Leading healthcare tech giant using AI for patient data and cloud logs.','https://oracle.com/health',false,true,500000, freeTier:'Institutional only', price:0, tips:'Best for enterprise hospitals | AI-powered "Clinical" help | Robust'),
    t('il-lumina-ai-pro','Illumina (AI)','science','The world\'s #1 DNA sequencing company using AI for genomic insights and labs.','https://illumina.com',false,true,350000, freeTier:'Institutional only', price:0, tips:'The gold standard for genomics | AI-powered "Variant" calling | High tech'),
    t('moderna-ai-pro','Moderna (AI)','science','Leading biotech giant using AI-powered "mRNA" platform for drug discovery.','https://moderna.com',false,true,250000, freeTier:'Institutional only', price:0, tips:'AI-powered "Discovery" speed | Best for vaccine research | World leader'),
    t('temp-us-ai-pro','Tempus','health','Leading precision medicine company using AI to analyze clinical and genomic data.','https://tempus.com',false,true,120000, freeTier:'Institutional only', price:0, tips:'Best for oncology | AI-powered "Smart" insights | Highly innovative'),

    // ━━━ AI FOR AGRICULTURE (Global Giants) ━━━
    t('john-deere-ai','John Deere (Autonomous)','science','The world\'s #1 ag tech company using high-end AI for autonomous tractors.','https://deere.com',true,true,500000, freeTier:'Free "Operations Center" app', price:0, tips:'AI-powered "See & Spray" | Best for precision farming | Iconic and giant'),
    t('bayer-ai-pro-ag','Bayer (FieldView)','science','Leading agriculture giant using AI-powered "Climate FieldView" for crops.','https://climate.com',true,true,350000, freeTier:'Free trial for farmers', price:0, tips:'The gold standard for crop data | AI-powered "Yield" maps | High reliability'),
    t('cort-eva-ai-pro','Corteva (Granular)','science','Leading ag-science company with AI-powered "Granular" management logs.','https://granular.ag',true,false,84000, freeTier:'Free demo available', price:0, tips:'Best for large scale farms | AI-powered "Profit" maps | robust'),
    t('indigo-ag-ai-pro','Indigo Ag','science','Leading biotech and carbon credit platform using AI for soil and fields.','https://indigoag.com',true,false,58000, freeTier:'Free registration for farmers', price:0, tips:'Best for sustainable farming | AI-powered "Carbon" tracking | high growth'),
    t('blue-river-deere','Blue River (John Deere)','science','Deere company specialized in AI-powered vision systems for weeding and care.','https://bluerivertechnology.com',false,true,35000, freeTier:'Part of John Deere ecosystem', price:0, tips:'AI-powered "Machine Learning" for crops | Best for robot weeding'),

    // ━━━ FINAL GEMS v43 (Modern AI Agents v2) ━━━
    t('agency-sw-ai-pro','Agency Swarm','code','Leading framework for building collaborative AI agent swarms and teams.','https://agencyswarm.ai',true,true,250000, freeTier:'Free open source framework', price:0, tips:'Best for multi-agent systems | AI-powered "Orchestration" | clean UI'),
    t('camel-ai-pro-code','CAMEL-AI','code','Communicative Agents for "Mind" exploration of Large Landscape models.','https://camel-ai.org',true,true,150000, freeTier:'Completely free open source', price:0, tips:'Pioneer of agent communication | Best for research and multi-agent POCs'),
    t('baby-agi-ai-pro','BabyAGI','code','The minimalist AI agent that manages and executes tasks autonomously with logs.','https://babyagi.id',true,true,120000, freeTier:'Completely free open source', price:0, tips:'Founded by Yohei Nakajima | Best for simple task loops | High speed'),
    t('agent-gpt-ai-pro','AgentGPT','code','The world\'s #1 browser-based autonomous AI agent platform with UI.','https://agentgpt.reworkd.ai',true,true,500000, freeTier:'Free trial with limited runs', price:40, priceTier:'Pro monthly', tips:'Best for non-technical users | AI-powered "Assembly" | Clean and easy'),
    t('god-mode-ai-pro','Godmode','code','Leading web UI for browsing and executing autonomous AI tasks at scale.','https://godmode.space',true,true,350000, freeTier:'Free trial available (credits)', price:0, tips:'Best for visual agent tracking | AI-powered "Web" browse | high performance'),
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
