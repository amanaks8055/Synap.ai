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
    // ━━━ AI FOR ENERGY & CLIMATE (Pro) ━━━
    t('carbon-direct-ai','Carbon Direct','science','Leading science-based carbon management platform using AI for modeling.','https://carbon-direct.com',false,true,12000, freeTier:'Demo available', price:0, tips:'Manage your carbon footprint with AI | Science-first approach | Best for enterprise'),
    t('watershed-ai-pro','Watershed','science','The enterprise sustainability platform using AI to measure and reduce carbon.','https://watershed.com',false,true,18000, freeTier:'Demo available', price:0, tips:'Industry leader for ESG | AI-powered data ingestion | Trusted by Walmart/Airbnb'),
    t('persefoni-ai-pro','Persefoni','science','Leading climate accounting platform for finance using AI for emissions data.','https://persefoni.com',false,true,15000, freeTier:'Free basic carbon tier', price:0, tips:'Best for banking and finance | AI-powered PCAF alignment | Highly secure'),
    t('enverus-ai-energy','Enverus','business','The most accurate energy data and intelligence platform using high-end AI.','https://enverus.com',false,true,35000, freeTier:'Institutional only', price:0, tips:'AI for oil and gas, renewables, and grid | 25+ years of data | Strategic focus'),
    t('drift-ai-energy','Drift (Energy)','business','AI-powered platform to optimize energy and reduce costs for large consumers.','https://drift.com',false,false,5600, freeTier:'Demo available', price:0, tips:'Real-time renewable energy matching | AI-powered grid optimization | Lower bills'),
    t('stem-ai-energy','Stem','business','Global leader in AI-driven energy storage and solar asset management.','https://stem.com',false,true,12000, freeTier:'Demo available', price:0, tips:'AI-powered "Athena" platform | Optimize battery storage | Energy transition leader'),
    t('aurora-solar-ai','Aurora Solar','business','The #1 software for solar sales and design using AI for site analysis.','https://aurorasolar.com',false,true,45000, freeTier:'Free trial available', price:150, priceTier:'Individual monthly annual', tips:'AI-powered 3D roof modeling | Most accurate solar performance data | Fast'),
    t('helioscope-ai-pro','HelioScope','business','Leading solar design software for commercial and industrial projects using AI.','https://helioscope.com',true,false,18000, freeTier:'30-day free trial', price:79, priceTier:'Standard monthly', tips:'Best for large scale solar | AI-powered site layout | Part of Aurora Solar'),
    t('gridly-ai-pro','Gridly','business','AI-powered platform for localizing games and digital content at scale.','https://gridly.com',true,false,9200, freeTier:'Free for up to 3k records', price:49, priceTier:'Plus monthly', tips:'Best for game developers | AI-powered translation and assets | Fast'),
    t('ecovadis-ai-pro','EcoVadis','business','The world\'s most trusted business sustainability ratings platform with AI.','https://ecovadis.com',false,true,84000, freeTier:'Free self-assessment', price:0, tips:'Industry standard for vendor ESG | AI-powered risk monitoring | Global scale'),

    // ━━━ AI FOR HEALTHCARE v3 (Patient & Ops) ━━━
    t('zocdoc-ai-pro','Zocdoc','health','Leading platform to find and book doctors with AI-powered matching.','https://zocdoc.com',true,true,500000, freeTier:'Completely free to use for patients', price:0, tips:'Verified patient reviews | AI-powered insurance checker | Book appts in app'),
    t('babylon-health-ai','Babylon Health','health','Personalized digital health service with AI-powered symptom checker.','https://babylonhealth.com',true,true,180000, freeTier:'Free basic symptom checker', price:0, tips:'24/7 access to medical info | AI-powered health assessment | Safe and private'),
    t('ada-health-ai-pro','Ada Health','health','The most accurate symptom checker and health companion powered by AI.','https://ada.com',true,true,250000, freeTier:'Completely free for users', price:0, tips:'Medical-grade AI | Developed by doctors | Huge database of conditions'),
    t('k-health-ai-pro','K Health','health','Personalized medical care and prescription app with AI-powered chat.','https://khealth.com',true,true,120000, freeTier:'Free basic health info', price:49, priceTier:'Monthly membership (docs)', tips:'AI identifies similar cases | Best for fast prescriptions | Reliable medical data'),
    t('ro-health-ai-pro','Ro (Roman)','health','Direct-to-patient healthcare platform with AI-powered pharmacy help.','https://ro.co',true,true,150000, freeTier:'Free hair/skin analysis tools', price:0, tips:'Personalized treatment plans | AI-powered delivery tracking | Discrete and safe'),
    t('hims-hers-ai-pro','Hims & Hers','health','Leading individualized wellness platform with AI-powered care tools.','https://forhims.com',true,true,180000, freeTier:'Free health profile and tools', price:0, tips:'Best for skincare and hair | AI-powered personalized prescriptions | Top tier UC'),
    t('folx-health-ai','FOLX Health','health','The leading health platform for the LGBTQIA+ community with AI support.','https://folxhealth.com',false,true,35000, freeTier:'Demo available', price:39, priceTier:'Membership monthly', tips:'Inclusive and expert care | AI-powered gender affirmation help | Global leader'),
    t('modern-fertility','Modern Fertility (Ro)','health','Leading platform for women\'s health and fertility tracking with AI.','https://modernfertility.com',true,true,45000, freeTier:'Free fertility tools online', price:150, priceTier:'One-time hormone test', tips:'Acquired by Ro | Learn your hormones with AI genetics | Community support'),
    t('clue-period-ai','Clue','health','Leading cycle and period tracker using AI for future predictions.','https://helloclue.com',true,true,500000, freeTier:'Free basic tracking', price:5, priceTier:'Plus monthly', tips:'Scientifically driven | AI identifies cycle patterns | Privacy-first (GDPR)'),
    t('flo-health-ai-pro','Flo Health','health','The world\'s #1 women\'s health app with AI-powered cycle tracking.','https://flo.health',true,true,999999, freeTier:'Free basic tracking', price:10, priceTier:'Premium monthly', tips:'AI-powered health insights | Huge global community | Trusted by millions'),

    // ━━━ AI FOR LOCAL GOVERNMENT & SAFETY v1 ━━━
    t('starlight-ai-gov','Starlight','business','AI-powered platform for local governments to manage public safety.','https://starlight.ai',false,true,12000, freeTier:'Demo available', price:0, tips:'Predict crime patterns with AI | Optimize police resources | Transparent data'),
    t('urban-footprint-ai','UrbanFootprint','business','Leading urban planning and risk analysis platform using AI data.','https://urbanfootprint.com',false,true,15000, freeTier:'Demo available', price:0, tips:'Best for city resilience | AI-powered neighborhood data | Trusted by planners'),
    t('via-ai-transport','Via','business','Leading transit tech platform using AI for on-demand public transport.','https://ridewithvia.com',true,true,45000, freeTier:'Free app for riders', price:0, tips:'Optimize bus routes with AI | Reduce city traffic | Global presence'),
    t('rapid-sos-ai','RapidSOS','business','Leading emergency response data platform using AI for 911 centers.','https://rapidsos.com',false,true,58000, freeTier:'Institutional only', price:0, tips:'AI-powered data from Google/Apple | Save lives with precision | Critical tech'),
    t('mark-43-ai-pro','Mark43','business','Cloud-native public safety software with AI-powered reporting and CAD.','https://mark43.com',false,true,18000, freeTier:'Demo available', price:0, tips:'Best for police and fire depts | AI-powered documentation | Secure and reliable'),
    t('shot-spotter-ai','ShotSpotter (SoundThinking)','business','AI-powered acoustic gunshot detection system for public safety.','https://soundthinking.com',false,true,25000, freeTier:'Demo available', price:0, tips:'Detect shots in seconds with AI | High precision | Used in 100+ cities'),
    t('flock-safety-ai','Flock Safety','business','Leading AI-powered license plate recognition and neighborhood safety.','https://flocksafety.com',false,true,35000, freeTier:'Demo available', price:0, tips:'Best for private neighborhoods | AI identifies vehicle types | Privacy focused'),
    t('city-base-ai','CityBase','business','Leading platform for local government payments and digital services with AI.','https://thecitybase.com',false,false,5600, freeTier:'Institutional only', price:0, tips:'AI-powered kiosks and web | Acquired by GTY Technology | Citizen focused'),
    t('pavilion-ai-gov','Pavilion','business','The "Amazon for government procurement" using AI for searches.','https://withpavilion.com',true,true,12000, freeTier:'Free for government users', price:0, tips:'Search thousands of contracts | AI-powered "Tinder" for bids | Fast and clean'),
    t('opengov-ai-pro','OpenGov','business','The modern cloud for local government with AI-powered budgeting.','https://opengov.com',false,true,28000, freeTier:'Demo available', price:0, tips:'Industry standard for transparency | AI-powered reporting | User friendly'),

    // ━━━ ARTS, CULTURE & ARCHIVE AI v2 ━━━
    t('ancestry-ai-pro','Ancestry','lifestyle','The world\'s largest genealogy records using AI for name recognition.','https://ancestry.com',true,true,500000, freeTier:'Free basic search', price:25, priceTier:'Discovery monthly', tips:'AI translates old records | Millions of family trees | Best for history fans'),
    t('my-heritage-ai','MyHeritage','lifestyle','Leading platform for family history and DNA with AI-powered "Deep Nostalgia".','https://myheritage.com',true,true,250000, freeTier:'Free basic limited tree', price:15, priceTier:'Premium plus monthly', tips:'Animate old photos with AI | AI-powered record matching | Global database'),
    t('family-search-ai','FamilySearch','lifestyle','The world\'s largest free genealogy resource with AI records.','https://familysearch.org',true,true,999999, freeTier:'Completely free forever', price:0, tips:'Non-profit (LDS Church) | AI-powered "Full Text" search | BILLIONS of records'),
    t('smithsonian-ai','Smithsonian Open Access','science','Explore millions of items from the Smithsonian with AI search.','https://si.edu/openaccess',true,true,150000, freeTier:'Completely free public data', price:0, tips:'Download 2.8M+ items for free | AI-powered visual search | World heritage'),
    t('met-museum-ai','The MET (Digital Collection)','education','Digital archives of the Metropolitan Museum of Art with AI discovery.','https://metmuseum.org',true,true,120000, freeTier:'Completely free to browse', price:0, tips:'High-res art for everyone | AI-powered "Object" search | Art historical AI data'),
    t('europeana-ai-pro','Europeana','education','Discover world heritage from thousands of European institutions with AI.','https://europeana.eu',true,true,84000, freeTier:'Completely free public data', price:0, tips:'Multilingual AI search | High quality art and photos | EU supported'),
    t('archive-org-ai','Internet Archive','education','Non-profit library of millions of free books, movies, and software with AI.','https://archive.org',true,true,999999, freeTier:'Completely free for everyone', price:0, tips:'The "Wayback Machine" for the web | AI-powered book OCR | Knowledge preservation'),
    t('un-digital-library','United Nations Digital Library','business','The UN\'s official digital records using AI for categorization.','https://digitallibrary.un.org',true,true,45000, freeTier:'Completely free public info', price:0, tips:'Access all UN resolutions | AI-powered search | Historical diplomatic data'),
    t('loc-gov-ai','Library of Congress','education','The largest library in the world with AI-powered digital labs.','https://loc.gov',true,true,250000, freeTier:'Completely free for the public', price:0, tips:'AI-powered newspaper search | Millions of primary sources | USA official'),
    t('british-library-ai','British Library','education','Explore one of the world\'s largest libraries with AI-powered archives.','https://bl.uk',true,true,150000, freeTier:'Free to search records', price:0, tips:'High quality digital manuscripts | AI for transcription | National treasure'),

    // ━━━ AUTOMOTIVE v2 (Specific Brands & EV) ━━━
    t('tesla-mobile-ai','Tesla App','automotive','Control your Tesla vehicle and home energy with AI-powered mobile app.','https://tesla.com',true,true,999999, freeTier:'Free for Tesla owners', price:0, tips:'AI-powered "Summon" | Real-time vehicle diagnostics | Best EV mobile app'),
    t('ford-pass-ai','FordPass','automotive','Connect and control your Ford vehicle with AI-powered health alerts.','https://ford.com/fordpass',true,true,250000, freeTier:'Free for Ford owners', price:0, tips:'AI-powered "Predictive" maintenance | Find fuel and charging | Smart control'),
    t('mercedes-me-ai','Mercedes me','automotive','Your personal digital assistant for your Mercedes-Benz with AI.','https://mercedes-benz.com',true,true,180000, freeTier:'Free for Mercedes owners', price:0, tips:'AI-powered MBUX interaction | High end luxury UI | Real-time security'),
    t('mybmw-ai-app','My BMW','automotive','Digital companion for your BMW with AI-powered trip planning.','https://bmw.com',true,true,150000, freeTier:'Free for BMW owners', price:0, tips:'Check vehicle status with AI | Send routes to car | Digital keys'),
    t('abrp-ai-pro','ABRP (A Better Routeplanner)','automotive','Leading EV route planning app using AI for consumption and charging.','https://abetterrouteplanner.com',true,true,84000, freeTier:'Free basic version', price:5, priceTier:'Premium monthly', tips:'Acquired by Rivian | AI accounts for wind and weather | Essential for EV trips'),
    t('plugshare-ai-pro','PlugShare','automotive','The most accurate EV charging station map with AI-powered filters.','https://plugshare.com',true,true,250000, freeTier:'Completely free to use', price:0, tips:'Largest EV charging social network | AI-powered "Station Rating" | Global reach'),
    t('electrify-america-ai','Electrify America','automotive','Leading high-speed EV charging network with AI-powered mobile app.','https://electrifyamerica.com',true,true,120000, freeTier:'Free app for users', price:4, priceTier:'Pass+ monthly membership', tips:'Fastest charging in USA | AI-powered station status | Rewards program'),
    t('chargepoint-ai-pro','ChargePoint','automotive','The world\'s largest EV charging network with AI-powered home tools.','https://chargepoint.com',true,true,180000, freeTier:'Free app for users', price:0, tips:'Workplace and home charging leader | AI-powered "Activity" reports | Huge network'),
    t('evgo-ai-pro','EVgo','automotive','Leading fast-charging network for EVs using AI to optimize uptime.','https://evgo.com',true,true,84000, freeTier:'Free app for users', price:7, priceTier:'Plus monthly membership', tips:'Reserved charging stalls | AI-powered "Autocharge+" | High reliability'),
    t('wallbox-ai-pro','Wallbox','automotive','Smart EV charging solutions for home and business with AI energy.','https://wallbox.com',true,false,25000, freeTier:'Free app for hardware users', price:0, tips:'AI-powered "Eco-Smart" solar charging | Best design | High performance'),

    // ━━━ FINAL GEMS v2 ━━━
    t('perplexity-ai-search','Perplexity','research','AI search engine that provides cited answers to complex questions.','https://perplexity.ai',true,true,999999, freeTier:'Free basic search forever', price:20, priceTier:'Pro monthly', tips:'Best for academic and news research | Real-time citations | High accuracy'),
    t('arc-browser-ai','Arc Browser','productivity','Leading web browser with built-in AI for summarizing and organizing.','https://arc.net',true,true,500000, freeTier:'Completely free to use', price:0, tips:'AI-powered "Browse for Me" | Clean and powerful UI | Built on Chromium'),
    t('brave-ai-leo','Brave (Leo AI)','productivity','Privacy-first browser with a built-in AI assistant for all sites.','https://brave.com',true,true,350000, freeTier:'Free for users', price:15, priceTier:'Premium monthly for extra models', tips:'Best for privacy | AI-powered ad blocking | Secure and fast'),
    t('opera-ai-aria','Opera (Aria AI)','productivity','Modern browser with a free built-in AI assistant and speed tools.','https://opera.com',true,true,250000, freeTier:'Completely free for users', price:0, tips:'Best for social integration | AI-powered sidebar | Free VPN included'),
    t('vivaldi-ai-tools','Vivaldi','productivity','The most customizable browser with AI-powered notes and email.','https://vivaldi.com',true,true,120000, freeTier:'Completely free open source', price:0, tips:'Extreme customizability | AI-powered sidebar | Built for power users'),
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
