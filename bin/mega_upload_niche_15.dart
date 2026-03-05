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
    // ━━━ AI FOR SPACE & ASTRONOMY ━━━
    t('space-x-starlink-ai','Starlink (SpaceX)','business','Global satellite internet using AI to optimize orbit and connectivity.','https://starlink.com',false,true,500000, freeTier:'Hardware purchase required', price:120, priceTier:'Residential monthly', tips:'AI-powered beam steering | Lowest latency satellite internet | Best for remote life'),
    t('planet-labs-ai','Planet Labs','science','Leading provider of daily satellite imagery using AI to detect changes on Earth.','https://planet.com',false,true,45000, freeTier:'Free basic data for researchers', price:0, tips:'Monitor global change in real-time | AI-powered "Planet Insights" | High precision'),
    t('maxar-ai-pro','Maxar Technologies','business','Leading provider of high-resolution satellite imagery and space infrastructure with AI.','https://maxar.com',false,true,35000, freeTier:'Institutional only', price:0, tips:'Industry standard for intelligence | AI-powered image enhancement | Secure'),
    t('black-sky-ai','BlackSky','business','Real-time satellite intelligence platform using AI for event monitoring.黑','https://blacksky.com',false,true,18000, freeTier:'Demo available', price:0, tips:'Fastest satellite revisit times | AI-powered "Spectra" platform | Real-time data'),
    t('orbit-fab-ai','Orbit Fab','science','Gas stations in space - building infrastructure for satellite refueling with AI help.','https://orbitfab.com',false,false,5600, freeTier:'Institutional only', price:0, tips:'AI-powered docking and logistics | Create a circular space economy | Innovative'),
    t('slingshot-ai-space','Slingshot Aerospace','business','Leading platform for space situational awareness and traffic management with AI.','https://slingshot向.com',false,false,4200, freeTier:'Institutional only', price:0, tips:'Prevent collisions in space with AI | Track every object in orbit | Data-driven'),
    t('leo-labs-ai-pro','LeoLabs','science','Real-time radar data and space traffic safety platform using AI.','https://leolabs.space',false,true,12000, freeTier:'Institutional only', price:0, tips:'Best for satellite operators | AI-powered collision alerts | Global radar network'),
    t('capella-space-ai','Capella Space','science','High-resolution synthetic aperture radar (SAR) satellite data with AI.','https://capellaspace.com',false,false,8400, freeTier:'Demo available', price:0, tips:'See through clouds and at night | AI-powered object detection | High accuracy'),
    t('iceye-ai-pro','ICEYE','science','Global leader in small SAR satellites using AI for flood and fire monitoring.','https://iceye.com',false,true,15000, freeTier:'Institutional only', price:0, tips:'Real-time disaster monitoring | AI-powered flood analytics | World scale'),
    t('synpsys-ai-space','Synspective','science','SAR satellite data and solutions for urban planning and monitoring with AI.','https://synspective.com',false,false,3500, freeTier:'Institutional only', price:0, tips:'Asian market leader for SAR | AI-powered land displacement detection | Clean data'),

    // ━━━ AI FOR ROBOTICS & DRONES v2 ━━━
    t('boston-dynamics-ai','Boston Dynamics','business','World-class robots like Spot and Atlas using AI for mobility and balance.','https://bostondynamics.com',false,true,120000, freeTier:'Institutional only', price:0, tips:'Most advanced mobile robots | AI-powered "Orbit" fleet management | Industry legend'),
    t('dji-ai-drones','DJI (Enterprise)','business','Leading drone manufacturer with AI-powered flight and object tracking.','https://dji.com',true,true,250000, freeTier:'Free basic app for flight', price:0, tips:'AI-powered "ActiveTrack" | Industry standard for aerial video | High reliability'),
    t('skydio-ai-drone','Skydio','business','Leading autonomous drone company using AI for obstacle avoidance and mapping.','https://skydio.com',false,true,84000, freeTier:'Institutional only', price:0, tips:'The "Uncrashable" drone | AI-powered "Autonomy Engine" | Best for inspections'),
    t('shield-ai-pro','Shield AI','business','AI-powered pilot systems for the next generation of defense drones and planes.','https://shield.ai',false,true,15000, freeTier:'Department of Defense only', price:0, tips:'AI-powered "Hivemind" pilot | Autonomous flight in GPS-denied zones | High tech'),
    t('anduril-ai-pro','Anduril Industries','business','Leading defense tech company using AI for border and base security.','https://anduril.com',false,true,35000, freeTier:'Institutional only', price:0, tips:'AI-powered "Lattice" platform | Autonomous underwater and aerial vehicles | Scale'),
    t('ghost-robotics-ai','Ghost Robotics','business','Vision-based legged robots (Dog robots) using AI for tough terrain and defense.','https://ghostrobotics.io',false,false,9200, freeTier:'Institutional only', price:0, tips:'Best for unstructured terrain | AI-powered blind locomotion | used by military'),
    t('unitree-ai-pro','Unitree Robotics','business','Leading provider of high-performance legged robots and AI at lower cost.','https://unitree.com',false,false,28000, freeTier:'Hardware purchase required', price:2000, priceTier:'G1 model one-time starting', tips:'Mass-market humanoid and dog robots | AI-powered mobility | Fast growing'),
    t('agility-robotics','Agility Robotics (Digit)','business','Humanoid robots built for logistics and warehouse tasks using AI.','https://agilityrobotics.com',false,true,18000, freeTier:'Institutional only', price:0, tips:'First humanoid in commercial workforce | AI-powered "Digit" robot | Logistics focus'),
    t('figure-ai-pro','Figure AI','business','Leading humanoid robot company using AI to build general-purpose humans.','https://figure.ai',false,true,45000, freeTier:'Institutional only', price:0, tips:'Partner of OpenAI and BMW | AI-powered speech and tasks | Cutting edge'),
    t('tesla-optimus-ai','Tesla Optimus','business','Tesla\'s general-purpose humanoid robot developed with vision AI.','https://tesla.com/optimus',false,true,250000, freeTier:'In development', price:0, tips:'The most anticipated humanoid | Built on same AI as FSD | Integrated at Tesla'),

    // ━━━ AI FOR CHEMISTRY & MATERIALS v2 ━━━
    t('kebotix-ai-pro','Kebotix','science','AI-powered "Self-Driving Lab" for discovering new materials and chemicals.','https://kebotix.com',false,true,5600, freeTier:'Institutional only', price:0, tips:'Speed up materials discovery by 10x | AI-powered chemistry | Innovative'),
    t('noble-ai-pro','Noble.AI','science','AI platform for accelerating high-stakes chemicals and materials R&D.','https://noble.ai',false,true,4200, freeTier:'Institutional only', price:0, tips:'AI-powered "Cortex" engine | Scientific-informed machine learning | Strategic'),
    t('citrine-informatics','Citrine Informatics','science','The leading data management and AI platform for chemicals and materials.','https://citrine.io',false,true,8400, freeTier:'Institutional only', price:0, tips:'Best for sustainable materials | AI-powered recipe optimization | Industry leader'),
    t('intellegens-ai','Intellegens','science','AI for predicting property data and optimizing materials and processes.','https://intellegens.com',false,false,3500, freeTier:'Demo available', price:0, tips:'AI-powered "Alchemite" platform | Handle sparse and noisy data | UK based'),
    t('enthrone-ai-pro','Enthought','science','Leading scientific computing company using AI for digital transformation.','https://enthought.com',false,false,9200, freeTier:'Institutional only', price:0, tips:'Python for science experts | AI-powered R&D labs | High accuracy'),
    t('benchling-ai-pro','Benchling','science','The R&D cloud for biotech with AI-powered sequence and data help.','https://benchling.com',true,true,120000, freeTier:'Free for academics/individuals', price:0, tips:'Industry standard for biotech R&D | AI-powered data tracking | Best UI in science'),
    t('tetra-science-ai','TetraScience','science','The scientific data cloud with AI-powered connectivity and insights.','https://tetrascience.com',false,true,15000, freeTier:'Institutional only', price:0, tips:'Connect all your lab instruments | AI-powered data lake for science | Scale'),
    t('dot-matics-ai','Dotmatics','science','Leader in R&D scientific software with AI-powered data management.','https://dotmatics.com',false,false,12000, freeTier:'Institutional only', price:0, tips:'End-to-end scientific platform | AI-powered workflows | Global presence'),
    t('st-ard-ai-pro','Standard BioTools','science','High-end mass cytometry and imaging systems using AI for data analysis.','https://standardbio.com',false,false,5600, freeTier:'Hardware required', price:0, tips:'Formerly Fluidigm | AI-powered cell analysis | High-end research only'),
    t('nanostring-ai','NanoString','science','Leading provider of spatial biology solutions with AI-powered image data.','https://nanostring.com',false,false,8400, freeTier:'Hardware required', price:0, tips:'Acquired by Bruker | AI-powered "CosMx" for 3D biology | World class'),

    // ━━━ AI FOR NON-PROFITS & PHILANTHROPY v2 ━━━
    t('blackbaud-ai-pro','Blackbaud','business','The world\'s leading software provider for the social good community with AI.','https://blackbaud.com',false,true,45000, freeTier:'Demo available', price:0, tips:'AI-powered "Raisers Edge NXT" | Best for large non-profits | Robust data'),
    t('network-for-good','Network for Good','business','Leading fundraising software for non-profits with AI-powered automation.','https://networkforgood.com',true,true,35000, freeTier:'Free basic fundraising tools', price:100, priceTier:'Starter monthly', tips:'Acquired by Bonterra | AI-powered "Donor Tracking" | Easy to use for SMB'),
    t('classy-ai-pro','Classy (GoFundMe)','business','Leading online fundraising platform with AI-powered donor insights.','https://classy.org',true,true,58000, freeTier:'Free for GoFundMe Charity users', price:0, tips:'Owned by GoFundMe | AI-powered "Campaign Builder" | High conversion design'),
    t('donors-choose-ai','DonorsChoose','education','Non-profit for supporting classroom projects with AI-powered vetting.','https://donorschoose.org',true,true,150000, freeTier:'Completely free to join', price:0, tips:'AI verifies every classroom project | High transparency | Support local teachers'),
    t('charity-navigator','Charity Navigator','business','The world\'s largest charity evaluator using AI for score summaries.','https://charitynavigator.org',true,true,250000, freeTier:'Completely free for the public', price:0, tips:'AI-powered "Impact" scores | Independent and non-profit | Trusted reviews'),
    t('guidestar-ai-pro','GuideStar (Candid)','business','The most comprehensive source of non-profit information with AI data.','https://guidestar.org',true,true,180000, freeTier:'Free basic non-profit search', price:100, priceTier:'Premium search monthly', tips:'World\'s largest database of 990s | AI-powered "Transparency" seals | Crucial'),
    t('give-well-ai','GiveWell','business','Leading independent charity evaluator using AI for rigorous research.','https://givewell.org',true,true,84000, freeTier:'Completely free for the public', price:0, tips:'Best for evidence-based giving | AI-powered "Top Charities" list | Non-profit'),
    t('effective-altruism','Effective Altruism (EA)','business','Global community using AI and logic to maximize humanitarian impact.','https://effectivealtruism.org',true,true,45000, freeTier:'Completely free to join', price:0, tips:'Data-driven philanthropy | AI-powered "Forum" | High intellectual rigor'),
    t('80k-hours-ai','80,000 Hours','education','Research on which careers have the most positive impact using AI data.','https://80000hours.org',true,true,58000, freeTier:'Completely free for everyone', price:0, tips:'Best for career planning | AI-powered "Job Board" | Non-profit and backed'),
    t('global-giving-ai','GlobalGiving','business','The world\'s first and largest global crowdfunding community for non-profits.','https://globalgiving.org',true,true,35000, freeTier:'Free to browse and join', price:0, tips:'AI-powered "Community" vetting | Support global causes | Trusted partner'),

    // ━━━ AI FOR KIDS & PARENTING v2 ━━━
    t('youtube-kids-ai','YouTube Kids','entertainment','Safe and curated version of YouTube for kids with AI-powered filters.','https://youtubekids.com',true,true,999999, freeTier:'Completely free with ads', price:0, tips:'AI-powered "Safe Search" | Parental controls | High quality curated content'),
    t('pbs-kids-ai-pro','PBS KIDS','education','Leading education and gaming platform for kids with AI-powered help.','https://pbskids.org',true,true,500000, freeTier:'Completely free for everyone', price:0, tips:'Non-profit and award winning | AI-powered "For Parents" tools | Safe and fun'),
    t('common-sense-ai','Common Sense Media','education','Leading source for movie and game ratings for parents using AI help.','https://commonsensemedia.org',true,true,250000, freeTier:'Free basic ratings', price:3, priceTier:'Plus monthly', tips:'Best for finding safe content | AI-powered "Parents Guide" | Non-profit'),
    t('bark-ai-parent','Bark','lifestyle','Leading parental control and safety app using AI to detect risks online.','https://bark.us',false,true,120000, freeTier:'7-day free trial', price:14, priceTier:'Premium monthly', tips:'AI detects cyberbullying and self-harm | Monitors 30+ apps | Most advanced'),
    t('aura-parent-ai','Aura Kids','lifestyle','Modern safety platform for kids with AI-powered ad-blocking and help.','https://aura.com/kids',false,true,84000, freeTier:'14-day free trial', price:10, priceTier:'Monthly billed annual', tips:'AI identifies dangerous sites | Part of Aura Security | Easy to use for parents'),
    t('qustodio-ai-pro','Qustodio','lifestyle','The world\'s most popular parental control app with AI-powered filters.','https://qustodio.com',true,true,180000, freeTier:'Free basic version available', price:5, priceTier:'Basic monthly annual', tips:'Best for screen time management | AI-powered "SOS" alerts | Global presence'),
    t('parent-ai-pro','Parent.com','lifestyle','Leading parenting community and data platform with AI-powered advice.','https://parent.com',true,false,45000, freeTier:'Free to browse articles', price:0, tips:'Community led | AI-powered "Advice" database | Curated and safe'),
    t('baby-center-ai','BabyCenter','health','The world\'s #1 pregnancy and parenting resource with AI tracking.','https://babycenter.com',true,true,999999, freeTier:'Completely free for parents', price:0, tips:'AI-powered "Is it safe?" search | Community of millions | Accurate medical info'),
    t('what-to-expect','What to Expect','health','The most famous pregnancy app using AI for day-by-day development.','https://whattoexpect.com',true,true,500000, freeTier:'Completely free for parents', price:0, tips:'Based on the world-famous book | AI-powered "Tracker" | Integrated community'),
    t('the-bump-ai-app','The Bump','health','Leading pregnancy and baby tracker with AI-powered visual guides.','https://thebump.com',true,true,350000, freeTier:'Completely free for parents', price:0, tips:'Best 3D fruit visuals | AI-powered "registry" helper | High engagement'),

    // ━━━ FINAL GEMS v8 (Advanced Infra) ━━━
    t('pinecone-ai-pro','Pinecone','code','Leading vector database for high-performance AI applications and search.','https://pinecone.io',true,true,150000, freeTier:'Free forever basic (1 index)', price:70, priceTier:'Standard monthly base', tips:'The industry standard for RAG | Serverless architecture | Enterprise security'),
    t('weaviate-ai-pro','Weaviate','code','Leading open-source vector database with built-in AI modules.','https://weaviate.io',true,true,84000, freeTier:'Free trial available on Cloud', price:25, priceTier:'Standard monthly base', tips:'Best for open source AI stacks | Deep integration with models | Scalable'),
    t('qdrant-ai-pro','Qdrant','code','High-performance vector search engine and database using Rust and AI.','https://qdrant.tech',true,true,45000, freeTier:'Free cloud tier available', price:20, priceTier:'Managed monthly base', tips:'Blazing fast (Rust) | Best for high-load systems | Open source core'),
    t('chroma-ai-pro','Chroma','code','Open source embedding database optimized for AI and ease of use.','https://trychroma.com',true,true,120000, freeTier:'Completely free open source', price:0, tips:'Simplest to get started | AI-native design | Huge community'),
    t('milvus-ai-pro','Milvus (Zilliz)','code','World\'s most advanced vector database for billion-scale AI datasets.','https://milvus.io',true,true,58000, freeTier:'Free open source self-host', price:0, tips:'Cloud version (Zilliz) available | Best for mega-scale enterprises | High trust'),
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
