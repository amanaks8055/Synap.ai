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
    // ━━━ AI FOR FOOD DELIVERY & RIDESHARE (Consumer Giants) ━━━
    t('uber-ai-pro','Uber (AI)','lifestyle','Leading mobility platform using AI for pricing, matching, and autonomous.','https://uber.com',true,true,999999, freeTier:'Free app for users', price:10, priceTier:'Uber One monthly', tips:'AI-powered "Upfront Pricing" | Best for global travel | industry pioneer'),
    t('lyft-ai-pro','Lyft','lifestyle','Leading North American rideshare using AI for traffic and driver data.','https://lyft.com',true,true,500000, freeTier:'Free app for users', price:10, priceTier:'Lyft Pink monthly', tips:'AI-powered "Wait & Save" | Great for cities | High social focus'),
    t('grab-ai-pro','Grab','lifestyle','Southeast Asia\'s leading "Super App" for food and drive using AI.','https://grab.com',true,true,999999, freeTier:'Free app for users', price:0, tips:'AI-powered "Geo" data is elite | Best for SEA region | Multi-service'),
    t('bolt-ai-pro','Bolt','lifestyle','European mobility giant using AI for fast delivery and rides.','https://bolt.eu',true,true,500000, freeTier:'Free app for users', price:0, tips:'European leader | AI-powered "Driver" safety | Competitive pricing'),
    t('door-dash-ai','DoorDash','lifestyle','Leading US food delivery platform with AI-powered "DashMart" and matching.','https://doordash.com',true,true,999999, freeTier:'Free app for users', price:10, priceTier:'DashPass monthly', tips:'AI-powered "Prep Time" prediction | Huge store selection | US leader'),
    t('uber-eats-ai','Uber Eats','lifestyle','Global food delivery giant using AI for personalized menu discovery.','https://ubereats.com',true,true,999999, freeTier:'Free app for users', price:10, priceTier:'Uber One monthly', tips:'AI-powered "Pick For You" | Millions of restaurants | Global scale'),
    t('grub-hub-ai-pro','Grubhub','lifestyle','Leading food delivery with AI-powered logistics and order tracking.','https://grubhub.com',true,true,350000, freeTier:'Free app for users', price:10, priceTier:'Grubhub+ monthly', tips:'Part of Just Eat Takeaway | AI-powered "Delivery" speed | Robust'),
    t('instacart-ai-pro','Instacart','lifestyle','World\'s leading grocery delivery with AI-powered "Caper" smart carts.','https://instacart.com',true,true,500000, freeTier:'Free app for users', price:10, priceTier:'Instacart+ monthly', tips:'AI-powered "Shopping" lists | Best for groceries | US/Canada leader'),
    t('deliveroo-ai-pro','Deliveroo','lifestyle','Leading high-end food delivery using AI for logistics "Frank" engine.','https://deliveroo.co.uk',true,true,350000, freeTier:'Free app for users', price:5, priceTier:'Plus monthly', tips:'AI-powered "Frank" optimizes couriers | Best in UK/EU | High quality'),
    t('up-first-ai','Just Eat','lifestyle','Global food delivery giant using AI for local restaurant matching.','https://just-eat.co.uk',true,true,500000, freeTier:'Free app for users', price:0, tips:'Massive European footprint | AI-powered "Offers" | Reliable and fast'),

    // ━━━ AI FOR MILITARY & INTELLIGENCE v2 ━━━
    t('palantir-ai-pro','Palantir (AIP)','business','Leading investigative data platform with new AI-powered "AIP" assistant.','https://palantir.com',false,true,250000, freeTier:'Institutional only', price:0, tips:'The gold standard for "Foundry" and "Gotham" | AI-powered data fusion | Global scale'),
    t('anduril-ai-pro','Anduril','business','Defense technology company using AI for autonomous border and sea.','https://anduril.com',false,true,150000, freeTier:'Institutional only', price:0, tips:'AI-powered "Lattice" platform | Advanced autonomous systems | Silicon Valley focus'),
    t('lockheed-ai-pro','Lockheed Martin (AI)','business','Global security and aerospace leader with high-end AI flight labs.','https://lockheedmartin.com',false,true,120000, freeTier:'Institutional only', price:0, tips:'AI-powered fighter jet systems | Massive gov partnership | Industry legend'),
    t('raytheon-ai-pro','RTX (Raytheon)','business','Leading defense and tech company using AI for cyber and sensing.','https://rtx.com',false,true,84000, freeTier:'Institutional only', price:0, tips:'AI-powered missile and radar tech | Global defense leader | Reliable'),
    t('northrop-ai-pro','Northrop Grumman','business','Global security leader using AI for autonomous systems and space.','https://northropgrumman.com',false,true,58000, freeTier:'Institutional only', price:0, tips:'AI-powered "Global Hawk" | Cutting edge space tech | Strategic'),
    t('leidos-ai-pro','Leidos','business','Science and technology leader using AI for health and defense labs.','https://leidos.com',false,false,45000, freeTier:'Institutional only', price:0, tips:'AI-powered "Trusted AI" labs | massive gov contractor | Research focus'),
    t('booz-allen-ai','Booz Allen Hamilton','business','Global consulting giant with high-end AI and cybersecurity labs.','https://boozallen.com',false,true,84000, freeTier:'Institutional only', price:0, tips:'Leading advisor to US gov on AI | Deep cyber expertise | Strategic focus'),
    t('caci-ai-pro','CACI International','business','Leading provider of information solutions and AI for national security.','https://caci.com',false,false,35000, freeTier:'Institutional only', price:0, tips:'AI-powered intelligence analysis | Mission focused | high security'),
    t('saic-ai-pro','SAIC','business','Leading technology integrator using AI for space and defense.','https://saic.com',false,false,28000, freeTier:'Institutional only', price:0, tips:'AI-powered "Cloud" solutions | robust government focus | Reliable'),
    t('general-dynamics-ai','General Dynamics','business','Global aerospace and defense company with AI-powered land systems.','https://gd.com',false,false,45000, freeTier:'Institutional only', price:0, tips:'AI-powered ship and tank systems | massive industrial base | global leader'),

    // ━━━ AI FOR GEOGRAPHY & GIS v2 ━━━
    t('esri-arcgis-ai','Esri (ArcGIS)','science','The world leader in GIS and mapping with high-end AI labs (GeoAI).','https://esri.com',true,true,250000, freeTier:'Free basic version for students', price:100, priceTier:'Individual yearly starting', tips:'AI-powered "Predictive" mapping | Industry standard for GIS | Massive data'),
    t('mapbox-ai-pro','Mapbox','code','Leading map platform for developers with AI-powered traffic and data.','https://mapbox.com',true,true,350000, freeTier:'Free basic credits for devs', price:0, tips:'Best for custom map designs | AI-powered "Tiling" | millions of apps'),
    t('carto-ai-pro','CARTO','code','Leading cloud-native GIS platform with AI-powered spatial analytics.','https://carto.com',true,true,120000, freeTier:'Free trial available', price:0, tips:'AI-powered "Spatial" insights | Best for business data on maps | clean and fast'),
    t('google-maps-ai','Google Maps (Platform)','code','World\'s most popular map API using AI for route and business data.','https://mapsplatform.google.com',true,true,999999, freeTier:'\$200 free monthly credit', price:0, tips:'AI-powered "Place" data is the best | Global scale | Industry standard'),
    t('here-maps-ai','HERE Technologies','code','Leading global map and location data for automotive and supply chain with AI.','https://here.com',true,true,150000, freeTier:'Free basic version for devs', price:0, tips:'Owned by Audi/BMW/Daimler | AI-powered "Live" traffic | Robust and secure'),
    t('bing-maps-ai-pro','Bing Maps (Azure)','code','Microsoft\'s map platform with AI-powered aerial and road data.','https://microsoft.com/maps',true,true,180000, freeTier:'Free basic version available', price:0, tips:'Integrated with Azure AI | AI-powered "Road" detection | Global coverage'),
    t('tomtom-ai-pro','TomTom','code','Leading provider of location and navigation tech with AI-powered data.','https://tomtom.com',true,true,120000, freeTier:'Free basic version for users', price:0, tips:'AI-powered "Traffic" is elite | European leader | High reliability'),
    t('open-street-ai','OpenStreetMap (AI)','science','The "Wikipedia of Maps" using AI to help people edit global data.','https://openstreetmap.org',true,true,500000, freeTier:'Completely free forever', price:0, tips:'Crowdsourced and open | AI-powered "Edit" help (iD editor) | Global community'),
    t('radar-ai-pro-geo','Radar.io','code','Leading geofencing and location platform for developers with AI.','https://radar.com',true,true,58000, freeTier:'Free for up to 100k requests', price:0, tips:'Best for mobile app tracking | AI-powered "Fraud" detection | clean and fast'),
    t('foursquare-ai','Foursquare (Digital)','marketing','Leading location intelligence platform using AI for business visits.','https://foursquare.com',true,true,150000, freeTier:'Free basic version for users', price:0, tips:'AI-powered "Visit" data | Best for foot traffic analytics | High trust'),

    // ━━━ AI FOR SPACE & ASTRONOMY v3 ━━━
    t('nasa-ai-pro-data','NASA (AI)','science','The world\'s leading space agency with vast open-source AI and data.','https://nasa.gov/ai',true,true,999999, freeTier:'Completely free open data', price:0, tips:'Access millions of space images | AI-powered "Exoplanet" search | Global jewel'),
    t('spacex-ai-pro-fly','SpaceX (Ai)','science','Space technology leader using high-end AI for rocket landing and Starlink.','https://spacex.com',false,true,500000, freeTier:'Institutional only', price:0, tips:'AI-powered autonomous docking | World\'s most advanced rockets | Revolutionary'),
    t('esa-ai-pro-sci','ESA (Digital)','science','European Space Agency with AI-powered climate monitoring and data.','https://esa.int',true,true,350000, freeTier:'Completely free for research', price:0, tips:'European space leader | AI-powered "Copernicus" data | High intellectual focus'),
    t('jaxa-ai-pro-sci','JAXA (Ai)','science','Japanese Aerospace Exploration Agency using AI for deep space and probes.','https://jaxa.jp',true,false,150000, freeTier:'Free for research', price:0, tips:'Pioneer in asteroid sampling with AI | Japanese quality | high precision'),
    t('isro-ai-pro-sci','ISRO (Digital)','science','Indian Space Research Organisation with AI-powered moon and mars labs.','https://isro.gov.in',true,true,250000, freeTier:'Free for research', price:0, tips:'Leading low-cost space tech | AI-powered "Vikram" lander | Massive potential'),
    t('seti-ai-search','SETI Institute (AI)','science','Using AI to search the universe for signs of extraterrestrial life.','https://seti.org',true,true,58000, freeTier:'Completely free forever', price:0, tips:'AI-powered signal processing | Global non-profit | join the search'),
    t('slooh-ai-space','Slooh','science','Live online telescope platform using AI to help students and fans.','https://slooh.com',true,false,45000, freeTier:'7-day free trial on site', price:15, priceTier:'Student monthly', tips:'Control real telescopes with AI | Best for schools | Interactive'),
    t('sky-guide-ai-pro','Sky Guide (Fifth Star)','science','The most beautiful stargazing app using AI to track satellites.','https://fifthstar.com',true,true,120000, freeTier:'Free basic version', price:3, priceTier:'Plus monthly', tips:'Best-in-class UI | AI-powered "Satellite" tracking | Apple Design winner'),
    t('star-chart-ai','Star Chart','science','Augmented reality astronomy with AI-powered voice and sky search.','https://starchart.info',true,false,84000, freeTier:'Free basic version available', price:5, priceTier:'Upgrade one-time', tips:'Best for AR exploration | AI-powered "3D" planets | Easy to use for kids'),
    t('night-sky-ai-pro','Night Sky','science','Leading AR space app with AI-powered "Magic" sky search and data.','https://icandiapps.com',true,true,150000, freeTier:'Free basic version', price:10, priceTier:'Premium yearly', tips:'AI-powered satellite flyover alerts | Apple exclusive | Very high quality'),

    // ━━━ FINAL GEMS v22 (Modern Storage) ━━━
    t('dropbox-ai-pro','Dropbox (Dash)','productivity','Leading cloud storage with new AI-powered "Dash" search and help.','https://dropbox.com',true,true,999999, freeTier:'Free for up to 2GB', price:10, priceTier:'Plus monthly annual', tips:'AI-powered universal search with Dash | Best for teams | Industry legend'),
    t('box-ai-pro-cloud','Box (AI)','productivity','Enterprise content management with high-end AI-powered "Box AI".','https://box.com',true,true,350000, freeTier:'Free for individuals (10GB)', price:15, priceTier:'Business monthly', tips:'Best for high security firms | AI-powered "Summaries" | Enterprise standard'),
    t('google-drive-ai','Google Drive (AI)','productivity','The world\'s most popular cloud storage with AI-powered search (Gemini).','https://google.com/drive',true,true,999999, freeTier:'Free for up to 15GB', price:2, priceTier:'Basic monthly (100GB)', tips:'AI-powered "Gemini" integration | Seamless with Workspace | Global leader'),
    t('one-drive-ai-pro','OneDrive (AI)','productivity','Microsoft\'s cloud storage with AI-powered photo and file search.','https://onedrive.com',true,true,999999, freeTier:'Free for up to 5GB', price:2, priceTier:'Basic monthly (100GB)', tips:'Best for Windows users | AI-powered "Recap" | Deep Office integration'),
    t('i-cloud-ai-pro','iCloud (AI)','productivity','Apple\'s cloud with AI-powered "Intelligence" for photos and files.','https://icloud.com',true,true,999999, freeTier:'Free for up to 5GB', price:1, priceTier:'Plus monthly (50GB)', tips:'Seamless Apple ecosystem | AI-powered "Object" search | Private and secure'),
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
