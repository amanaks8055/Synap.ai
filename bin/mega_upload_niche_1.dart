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
    // ━━━ GAMING AI (Advanced) ━━━
    t('unity-muse-ai','Unity Muse','code','AI-powered companion for Unity developers to create textures, sprites, and code.','https://unity.com/products/muse',true,true,18000, freeTier:'Free trial available', price:30, priceTier:'Subscription monthly', tips:'Best for Unity game devs | AI-assisted animation | Sprite and texture gen'),
    t('unreal-engine-ai','Unreal Engine (AI Tools)','code','Suite of AI tools for behavior trees, environmental queries, and NPC logic.','https://unrealengine.com',true,true,25000, freeTier:'Free for students/small projects', price:0, tips:'Industry standard for AAA games | Powerful behavior trees | Mass AI for thousands of NPCs'),
    t('inworld-ai','Inworld AI','code','AI engine for creating smart, emotive, and interactive NPCs for games.','https://inworld.ai',true,true,12000, freeTier:'Free for up to 30 mins interactions', price:50, priceTier:'Pro: unlimited interactions', tips:'Characters that can talk and remember | Integrate with Unity/Unreal | Dynamic dialogue'),
    t('scenario-ai','Scenario','design','AI-powered game asset generator for consistent textures and sprites.','https://scenario.com',true,true,9200, freeTier:'Free for up to 30 images/month', price:20, priceTier:'Pro: unlimited private models', tips:'Train models on your own art style | Perfect for mobile games | Export JSON metadata'),
    t('rosebud-ai','Rosebud AI','code','AI-powered game creation platform where you can build games with text.','https://rosebud.ai',true,false,5600, freeTier:'Free basic version', price:0, tips:'Text-to-game generator | No-code focus | Integrated game hosting'),

    // ━━━ ROBOTICS (Enterprise) ━━━
    t('nvidia-isaac','NVIDIA Isaac','code','AI platform for accelerating development of autonomous robots.','https://nvidia.com/isaac',true,true,15000, freeTier:'Free for individual use', price:0, tips:'World-class simulation (Omniverse) | GPU-accelerated perception | Multi-robot orchestration'),
    t('ros-ai','ROS (Robot Operating System)','code','Open-source framework for building robot software with AI libraries.','https://ros.org',true,true,35000, freeTier:'Completely free open source', price:0, tips:'De facto standard for robotics | Huge library ecosystem | Support for Python/C++'),
    t('vicarious-ai','Vicarious','business','AI for robotic automation in turnkey manufacturing and logistics.','https://vicarious.com',false,false,2800, freeTier:'Institutional only', price:0, tips:'Owned by Intrinsic (Alphabet) | General-purpose robot learning | High precision'),
    t('boston-dynamics-ai','Boston Dynamics (Spot)','business','Advanced AI and mobility for autonomous industrial inspection robots.','https://bostondynamics.com',false,true,12000, freeTier:'Demo available', price:0, tips:'The famous "Spot" robot | AI for dynamic sensing | Hardened for industrial use'),
    t('dexterity-ai','Dexterity','business','AI-powered robotics for full-stack supply chain and warehouse automation.','https://dexterity.ai',false,false,2400, freeTier:'Demo available', price:0, tips:'Robots that can pick and pack any item | High speed and reliability | Integrated with WMS'),

    // ━━━ SPACE & SATELLITE (Deep Tech) ━━━
    t('descartes-labs-ai','Descartes Labs','science','Geospatial intelligence platform using AI for satellite imagery analysis.','https://descarteslabs.com',false,true,4800, freeTier:'Institutional only', price:0, tips:'Monitor global supply chains | Agricultural forecasting | AI-powered sensor fusion'),
    t('planet-labs-ai','Planet','science','Daily satellite imagery of the entire Earth with AI-powered change detection.','https://planet.com',true,true,9200, freeTier:'Free basic education/research access', price:0, tips:'The largest fleet of satellites | AI for automated urban tracking | High-res daily data'),
    t('orbital-insight','Orbital Insight','science','AI platform that analyzes geospatial data to understand global trends.','https://orbitalinsight.com',false,false,3200, freeTier:'Demo available', price:0, tips:'Track oil storage and ship traffic | AI-powered land use classification | Economic signals'),
    t('slingshot-aerospace','Slingshot Aerospace','science','AI for space situational awareness and satellite traffic management.','https://slingshotaerospace.com',false,true,1800, freeTier:'Demo available', price:0, tips:'Prevent satellite collisions | Track space debris | AI-powered space maps'),
    t('blacksky-ai','BlackSky','science','Real-time global intelligence using AI and high-frequency satellite imaging.','https://blacksky.com',false,false,2200, freeTier:'Demo available', price:0, tips:'Tactical space-based intelligence | AI for event notification | High revisit rates'),

    // ━━━ CRYPTO & WEB3 AI ━━━
    t('nansen-ai','Nansen','finance','Blockchain analytics platform that enriches on-chain data with AI labels.','https://nansen.ai',true,true,18000, freeTier:'Free basic dashboard', price:99, priceTier:'Standard monthly', tips:'Track "Smart Money" movements | AI-powered wallet labels | High quality NFT data'),
    t('dune-ai','Dune Analytics','finance','Community-driven crypto data analytics with AI-powered SQL helper.','https://dune.com',true,true,35000, freeTier:'Free forever basic', price:349, priceTier:'Pro: private queries and more', tips:'Learn SQL with AI | Create custom crypto dashboards | Real-time on-chain data'),
    t('arkham-ai','Arkham Intelligence','finance','AI-powered blockchain intelligence platform for deanonymizing wallets.','https://arkhamintelligence.com',true,true,25000, freeTier:'Currently free to use', price:0, tips:'Visualize wallet connections | AI for entity identification | Crypto sleuthing tool'),
    t('elliptic-ai','Elliptic','finance','Blockchain risk management and compliance with AI-powered monitoring.','https://elliptic.co',false,false,4200, freeTier:'Demo available', price:0, tips:'Best for institucional crypto safety | AI detects money laundering | Trusted by exchanges'),
    t('chainalysis-ai','Chainalysis','finance','Leading blockchain data platform using AI to solve cybercrimes.','https://chainalysis.com',false,true,9600, freeTier:'Institutional only', price:0, tips:'Official investigator for governments | Tracks crypto scams and hacks | AI-powered link analysis'),

    // ━━━ PHARMA & BIOTECH AI ━━━
    t('insilico-medicine','Insilico Medicine','science','AI platform for drug discovery and aging research.','https://insilico.com',false,true,3500, freeTier:'Institutional only', price:0, tips:'Pioneer in AI-generated drugs | Generative biology leader | Significant FDA pipeline'),
    t('recursion-ai','Recursion','science','AI-powered drug discovery using industrial-scale biology data.','https://recursion.com',false,true,2800, freeTier:'Institutional only', price:0, tips:'Massively parallel biology | AI predicts drug effects | Large data repository'),
    t('schrodinger-ai','Schrödinger','science','Advanced molecular simulation and AI platform for drug discovery.','https://schrodinger.com',false,false,4500, freeTier:'Demo available', price:0, tips:'Chemistry simulation leader | Physics-based models with AI | Used by all top pharma'),
    t('atomwise-ai','Atomwise','science','AI for structure-based drug design using neural networks for binding.','https://atomwise.com',false,false,2600, freeTier:'Demo available', price:0, tips:'First AI for virtual screening | Deep learning for chemistry | Collaborative research'),
    t('benevolent-ai','BenevolentAI','science','AI platform that discovers and develops treatments for rare diseases.','https://benevolent.com',false,false,1400, freeTier:'Institutional only', price:0, tips:'Best for disease target identification | Patient-centric data | Integrated lab/AI'),

    // ━━━ ENERGY & CLIMATE AI ━━━
    t('autodesk-green-building','Autodesk Green Building Studio','science','AI-powered building energy analysis and sustainability modeling.','https://autodesk.com',false,false,5600, freeTier:'Free trial available', price:0, tips:'Optimize for LEED certification | AI for solar and wind analysis | Integrated with Revit'),
    t('stem-ai','Stem','science','AI-powered energy storage and smart grid management for business.','https://stem.com',false,false,1200, freeTier:'Demo available', price:0, tips:'Athena AI optimizes battery use | Reduce peak demand charges | Smart grid leader'),
    t('uplight-ai','Uplight','science','AI platform for utilities to drive household and business energy savings.','https://uplight.com',false,false,900, freeTier:'Consumer app (via utility)', price:0, tips:'Connects with smart thermostats | AI-powered energy coaching | Millions of users'),
    t('carbon-direct-ai','Carbon Direct','science','Science-based carbon management with AI for offset verification.','https://carbon-direct.com',false,true,1500, freeTier:'Institutional only', price:0, tips:'Highest standard for carbon removal | AI verifies climate tech | Scientific advisory'),
    t('watttime-ai','WattTime','science','AI that allows devices to automatically shift energy use to clean times.','https://watttime.org',true,true,3200, freeTier:'Free data for non-profits', price:0, tips:'Automated carbon tagging | AI for emissions detection | Integrated with smart homes'),

    // ━━━ HUMANITIES & ARCHIVE AI ━━━
    t('ancestry-ai','Ancestry','research','The world\'s largest family history site with AI for document transcription.','https://ancestry.com',true,true,150000, freeTier:'Free basic tree building', price:20, priceTier:'Full membership monthly', tips:'AI reads old handwriting | Billion of records | DNA matching built-in'),
    t('familysearch-ai','FamilySearch','research','Completely free family history archive with AI indexing.','https://familysearch.org',true,true,120000, freeTier:'Completely free forever', price:0, tips:'Largest non-profit archive | AI for record identification | Global user community'),
    t('wayback-machine-ai','Wayback Machine','research','The Internet Archive with AI-powered search and preservation.','https://archive.org/web',true,true,250000, freeTier:'Completely free non-profit', price:0, tips:'Save any page forever | AI helps with content categorization | Digital library of millions'),
    t('europeana-ai','Europeana','research','Digital repository of European cultural heritage with AI search.','https://europeana.eu',true,false,45000, freeTier:'Completely free public access', price:0, tips:'Books, music, and art from EU | AI-powered visual discovery | Open data focus'),
    t('smithsonian-ai','Smithsonian Open Access','research','Millions of items from the Smithsonian database for free AI use.','https://si.edu/openaccess',true,true,58000, freeTier:'Completely free creative commons', price:0, tips:'Best for training AI models on history | High quality 3D scans | Open API'),

    // ━━━ PHILOSOPHY & ETHICS (AI) ━━━
    t('openai-alignment','OpenAI Alignment','research','Research on making AI systems follow human intent and safety.','https://openai.com/alignment',true,true,45000, freeTier:'Free research papers', price:0, tips:'Key for AGI safety | RLHF pioneers | Focus on superalignment'),
    t('anthropic-safety','Anthropic (Safety)','research','Constitution AI and research on building steerable AI systems.','https://anthropic.com/research',true,true,38000, freeTier:'Free research papers', price:0, tips:'Constitutional AI pioneers | Interpretability research | Focus on model safety'),
    t('future-of-life','Future of Life Institute','research','Non-profit working to reduce global catastrophic risks from AI.','https://futureoflife.org',true,false,15000, freeTier:'Completely free and non-profit', price:0, tips:'The famous "AI Pause" letter | Focus on policy and ethics | Global think tank'),
    t('aisec-ai','Center for AI Safety (CAIS)','research','Technical research and advocacy for reducing societal-scale AI risks.','https://safe.ai',true,false,12000, freeTier:'Free educational courses', price:0, tips:'"Intro to ML Safety" course | Academic focus on alignment | Top safety researchers'),
    t('alignment-forum','AI Alignment Forum','research','The leading community and technical hub for AI safety research.','https://alignmentforum.org',true,false,8400, freeTier:'Free to browse and read', price:0, tips:'Technical deep dives | Discussion on AGI timelines | Connected to LessWrong'),
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
