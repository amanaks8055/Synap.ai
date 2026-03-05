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
    // ━━━ BEAUTY & FASHION ━━━
    t('loreal-perso','L\'Oreal Perso','fashion','AI beauty device for creating personalized skin care and lip color formulas.','https://loreal.com',false,true,5400, freeTier:'Hardware purchase only', price:0, tips:'On-demand cosmetics at home | Real-time skin analysis | Exclusive to L\'Oreal'),
    t('modiface','ModiFace','fashion','Global leader in augmented reality and AI for the beauty industry.','https://modiface.com',true,true,6800, freeTier:'Free SDK demo', price:0, tips:'Virtual makeup try-on | Hair color simulation | Skin health diagnostic'),
    t('perfect-corp','Perfect Corp','fashion','AI/AR beauty and fashion tech solutions provider for brands.','https://perfectcorp.com',true,false,4200, freeTier:'Free YouCam app basic', price:0, tips:'Advanced face tracking | Jewelry try-on | Foundation shade finder'),
    t('hairstyles-ai','Hairstyles AI','fashion','AI tool for imagining new hairstyles and colors on your own photo.','https://hairstylesai.com',true,false,3200, freeTier:'3 free styles', price:9, priceTier:'Pro: 50+ styles', tips:'Try 100+ styles in minutes | Men and women options | High quality results'),
    t('style-dna','Style DNA','fashion','AI personal stylist app that determines your seasonal color and style.','https://styledna.ai',true,true,4800, freeTier:'Free basic style report', price:15, priceTier:'Pro: daily outfit recommendations', tips:'Scan your wardrobe | Personalized shopping | Style personality analysis'),

    // ━━━ ARCHITECTURE & URBAN ━━━
    t('spacio-ai','Spacemaker (Autodesk)','design','AI for architects and developers to optimize site designs and urban planning.','https://spacemakerai.com',false,true,4600, freeTier:'Institutional access only', price:0, tips:'Optimize for noise, wind, and sun | Real-time analysis | Acquired by Autodesk'),
    t('testfit-ai','TestFit','design','AI real estate feasibility and building design automation tool.','https://testfit.io',false,false,3200, freeTier:'Free trial available', price:0, tips:'Instant parking and unit layouts | Financial modeling built-in | Speed up site vetting'),
    t('sidewalk-labs','Sidewalk Labs (Delve)','design','Google (Alphabet) AI for generative urban design and sustainability.','https://sidewalklabs.com',false,false,2800, freeTier:'No public product', price:0, tips:'Delve creates 100s of urban scenarios | Focused on carbon neutral design | Smart city leader'),
    t('renderforest-ai','Renderforest Architecture','design','AI-powered architectural visualization and rendering tool for web.','https://renderforest.com',true,false,5600, freeTier:'Free for basic 720p', price:9, priceTier:'Pro: 4K rendering and commercial use', tips:'Easiest rendering for novices | Web-based interface | Fast results'),
    t('foster-partners-ai','Applied R+D','design','Internal AI development group at Foster + Partners for complex structures.','https://fosterandpartners.com',false,false,1400, freeTier:'Research reports available', price:0, tips:'Pioneers of building-integrated AI | Focus on futuristic design | Sustainability focus'),

    // ━━━ ENVIRONMENTAL & DISASTER ━━━
    t('pachama-ai','Pachama','science','AI for forest conservation and carbon credit verification via satellites.','https://pachama.com',false,true,3800, freeTier:'Browse projects for free', price:0, tips:'Verify carbon offsets with AI | Satellite monitoring of forests | Corporate transparency focus'),
    t('one-concern','One Concern','science','AI resilience platform predicting disaster impacts for urban areas.','https://oneconcern.com',false,false,2600, freeTier:'Institutional access', price:0, tips:'Predict flood and earthquake damage | Resilience scoring | Data-driven recovery'),
    t('floodbase','Floodbase','science','AI flood mapping and predictive monitoring for emergency response.','https://floodbase.com',false,false,2200, freeTier:'Demo available', price:0, tips:'Real-time flood alerts | Satellite data processing | Used by governments'),
    t('vizzuality','Vizzuality','science','Data-driven AI solutions for environmental and social change projects.','https://vizzuality.com',true,false,1800, freeTier:'Open data projects', price:0, tips:'Supply chain transparency | Biodiversity monitoring | Beautiful data storytelling'),
    t('the-ocean-cleanup-ai','The Ocean Cleanup','science','AI and robotics for detecting and removing plastic from oceans.','https://theoceancleanup.com',true,true,12000, freeTier:'Donation based', price:0, tips:'Autonomous interceptors | River monitoring with AI | Largest ocean cleanup effort'),

    // ━━━ HISTORY & ARCHEOLOGY ━━━
    t('global-heritage-fund','Global Heritage Fund','research','AI for detecting and protecting endangered archeological sites.','https://globalheritagefund.org',true,false,2400, freeTier:'Free project reports', price:0, tips:'Satellite monitoring of ruins | Community-led conservation | Damage detection'),
    t('google-arts-culture','Google Arts & Culture','research','AI and AR platform for experiencing the world\'s museums and heritage.','https://artsandculture.google.com',true,true,45000, freeTier:'Completely free forever', price:0, tips:'Selfie to painting match | Virtual museum tours | High-res art scans'),
    t('ancestry-ai','Ancestry AI','research','AI for digitizing records and identifying faces in family history.','https://ancestry.com',true,true,35000, freeTier:'Free basic tree building', price:24, priceTier:'Full access monthly', tips:'AI handwriting recognition | Photo restoration for family pics | DNA relative matching'),
    t('myheritage-ai','MyHeritage AI Time Machine','research','AI tool that imagines you in different historical periods from photos.','https://myheritage.com',true,true,18000, freeTier:'Limited free generations', price:0, tips:'Realistic historical photos | Ancestry matching | Extremely popular viral tool'),
    t('ancient-sites-explorer','Ancient Sites Explorer','research','AI-powered map exploring historical and archeological sites globally.','https://ancientsites.io',true,false,3600, freeTier:'Free for basic exploration', price:0, tips:'Interactive history map | 10k+ sites documented | 3D models of ruins'),

    // ━━━ AVIATION & LOGISTICS ━━━
    t('flightradar24-ai','Flightradar24','business','AI-powered flight tracking and arrival time predictions globally.','https://flightradar24.com',true,true,58000, freeTier:'Free live tracking on web/app', price:2, priceTier:'Silver: 90 days history and more stats', tips:'Real-time 3D flight view | Detailed aircraft info | Most accurate arrival times'),
    t('flexport-ai','Flexport','business','AI-driven global logistics and freight forwarding platform.','https://flexport.com',false,true,4200, freeTier:'Demo available', price:0, tips:'Real-time visibility into cargo | Automated customs | Supply chain optimization'),
    t('skydio-ai','Skydio','robotics','The world\'s leading autonomous drone for cinematography and inspection.','https://skydio.com',false,true,12000, freeTier:'App is free (pay for drone)', price:0, tips:'Industry leading obstacle avoidance | 360 degree vision | Best autonomous drone'),
    t('zipline-ai','Zipline','business','AI drone delivery service for medical supplies and retail.','https://flyzipline.com',false,true,8400, freeTier:'Commercial only', price:0, tips:'Fastest medical drone delivery | Used in Africa and US | 1M+ flights completed'),
    t('ge-aviation-ai','General Electric Aviation','business','AI for aircraft engine failure prediction and maintenance.','https://geaviation.com',false,false,1400, freeTier:'Institutional only', price:0, tips:'Digital twin of every engine | Predictive maintenance leader | Massive safety impact'),

    // ━━━ PHILOSOPHY & ETHICS ━━━
    t('ethical-ai-database','Ethical AI Database','research','Comprehensive database of ethical issues and papers in AI research.','https://ethical-ai.org',true,false,2200, freeTier:'Completely free resource', price:0, tips:'Best for academic research | Filter by ethical concern | Latest bias data'),
    t('philosophy-gpt','Philosophy GPT','chat','AI chatbot specialized in philosophical discourse and debate.','https://philosophygpt.app',true,false,3400, freeTier:'Free basic chat', price:5, priceTier:'Pro: in-depth debate mode', tips:'Debate with your favorite philosophers | Explains complex theories | Good for students'),
    t('alignment-forum','AI Alignment Forum','research','Research hub for AI safety and alignment research globally.','https://alignmentforum.org',true,true,4800, freeTier:'Free open access', price:0, tips:'Leading safety research | Technical discussions | Vital for AI developers'),
    t('future-of-humanity','Future of Humanity Institute','research','AI research institute at Oxford focusing on long-term AI ethics.','https://fhi.ox.ac.uk',true,false,2600, freeTier:'Public reports free', price:0, tips:'Nick Bostrom\'s institute | Foundational ethics papers | Global impact'),
    t('miri-ai','MIRI (Intelligence Research)','research','Machine Intelligence Research Institute focusing on mathematical AI safety.','https://intelligence.org',true,false,2800, freeTier:'Free open source papers', price:0, tips:'Technical safety focus | Mathematical alignment | Long-running non-profit'),

    // ━━━ TRAVEL (Niche) ━━━
    t('scotts-cheap-flights','Going (Scott\'s)','travel','AI-powered flight deal alerts for international and domestic travel.','https://going.com',true,true,9200, freeTier:'Free limited deal alerts', price:4, priceTier:'Premium: all deals and domestic', tips:'Incredible deal frequency | "Mistake fare" alerts | Best for budget travelers'),
    t('skiplagged','Skiplagged','travel','AI tool specialized in finding "hidden city" flights to save up to 80%.','https://skiplagged.com',true,false,15000, freeTier:'Free to use on web/app', price:0, tips:'Saves massive money | Use for one-way trips | Be careful with checked bags'),
    t('wanderlog-ai','Wanderlog','travel','AI trip planner with collaborative maps and expense tracking.','https://wanderlog.com',true,true,8400, freeTier:'Free unlimited itineraries', price:5, priceTier:'Pro: offline mode and auto-summaries', tips:'Import emails instantly | Best for group trips | Amazing UI and mobile app'),
    t('roadie-ai','Roadie','travel','AI-powered crowd-sourced delivery network for long-distance shipping.','https://roadie.com',true,false,4200, freeTier:'App is free (pay per delivery)', price:0, tips:'Send large items via someone already driving | Good for furniture | Faster than freight'),
    t('timeshifter','Timeshifter','travel','AI circadian rhythm app for overcoming jet lag for frequent travelers.','https://timeshifter.com',true,true,5600, freeTier:'First plan free', price:24, priceTier:'Yearly unlimited plans', tips:'Personalized light exposure | Designed by NASA scientists | Best for 10h+ flights'),
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
