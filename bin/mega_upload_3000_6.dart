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
    // ━━━ AI FOR AUTOMOTIVE & MOBILITY v2 ━━━
    t('tesla-fsd-ai-pro','Tesla FSD','business','Automotive industry leader in vision-based AI for autonomous driving.','https://tesla.com/fsd',false,true,999999, freeTier:'Hardware purchase required', price:99, priceTier:'Subscription monthly', tips:'The world\'s most deployed AI driving system | Vision-only (no radar) | 1B+ miles driven'),
    t('waymo-one-ai','Waymo One','business','Leading autonomous ride-hailing service using high-end AI and LiDAR.','https://waymo.com',true,true,250000, freeTier:'Free app for users (pay per ride)', price:0, tips:'Owned by Google | AI-powered "Safety" focus | Operating in major US cities'),
    t('cruise-ai-pro','Cruise','business','Autonomous ride-hailing platform using AI to build all-electric fleet.','https://getcruise.com',true,true,120000, freeTier:'Free app for users (pay per ride)', price:0, tips:'Owned by GM | AI-powered "Origin" vehicle | High reliability'),
    t('mobileye-ai-pro','Mobileye','business','Global leader in vision-based advanced driver assistance systems (ADAS) using AI.','https://mobileye.com',false,true,84000, freeTier:'Institutional only', price:0, tips:'Owned by Intel | AI-powered "REM" maps | Used by 30+ car brands'),
    t('zoox-ai-mobility','Zoox','business','The autonomous vehicle built for riders, not drivers, using AI and EVs.','https://zoox.com',false,true,45000, freeTier:'In development', price:0, tips:'Owned by Amazon | AI-powered bidirectional driving | Modern luxury'),
    t('aurora-ai-trucking','Aurora Innovation','business','Leading autonomous trucking and mobility platform powered by AI.','https://aurora.tech',false,true,35000, freeTier:'Institutional only', price:0, tips:'AI-powered "Aurora Driver" | Focus on heavy logistics | Strategic partner of Toyota'),
    t('lime-ai-pro','Lime','lifestyle','Leading global micro-mobility provider using AI for fleet management.','https://li.me',true,true,500000, freeTier:'Free app for users (pay per ride)', price:0, tips:'AI-powered "Juicer" network | Sustainable EVs | World\'s largest city footprint'),
    t('bird-ai-mobility','Bird','lifestyle','Global sharing platform for electric scooters and bikes optimized with AI.','https://bird.co',true,true,350000, freeTier:'Free app for users (pay per ride)', price:0, tips:'AI-powered "Parking" check | Best for short city trips | High engagement'),
    t('city-mapper-ai','Citymapper','lifestyle','The ultimate transport app using AI to find the fastest way across town.','https://citymapper.com',true,true,500000, freeTier:'Completely free to use', price:3, priceTier:'Club monthly', tips:'AI-powered real-time transit data | Best for complex cities (NYC/London) | UI gold'),
    t('moovit-ai-pro','Moovit (Intel)','lifestyle','The world\'s #1 mobility-as-a-service app using AI for transit data.','https://moovit.com',true,true,999999, freeTier:'Completely free with ads', price:0, tips:'Owned by Intel | AI-powered crowdsourced data | Available in 3000+ cities'),

    // ━━━ AI FOR INFRASTRUCTURE & CONSTRUCTION v2 ━━━
    t('autodesk-form-it','Autodesk FormIt','design','3D sketching and early-stage architectural modeling using AI data.','https://autodesk.com/formit',true,true,120000, freeTier:'Free basic version available', price:0, tips:'Best for conceptual design | AI-powered energy analysis | Part of AEC suite'),
    t('bim-object-ai','BIMobject','design','Global marketplace for BIM content using AI for data and categorization.','https://bimobject.com',true,true,250000, freeTier:'Completely free for designers', price:0, tips:'2000+ brands and millions of objects | AI-powered recommendations | Industry logic'),
    t('plan-grid-ai','PlanGrid (Autodesk)','business','Leading construction productivity software with AI-powered sheet data.','https://plangrid.com',false,true,84000, freeTier:'Demo available', price:39, priceTier:'Nailgun monthly billed annual', tips:'Best for field teams | AI-powered automatic hyperlinking | Robust and fast'),
    t('procore-ai-pro','Procore','business','The industry standard for construction management with AI-powered insights.','https://procore.com',false,true,150000, freeTier:'Demo available', price:0, tips:'AI-powered "Risk" and "Safety" tools | Manage billion-dollar projects | Scale'),
    t('strux-hub-ai','StruxHub','business','AI-powered platform for construction logistics and delivery management.','https://struxhub.com',false,false,12000, freeTier:'Demo available', price:0, tips:'Best for job site organization | AI-powered schedules | Real-time data'),
    t('open-space-ai-pro','OpenSpace','business','AI-powered photo documentation for construction sites using 360 cams.','https://openspace.ai',false,true,45000, freeTier:'Demo available', price:0, tips:'AI-powered "Vision" tracks progress | Best for large developers | High accuracy'),
    t('holobuilder-ai','HoloBuilder (FARO)','business','Leading 360 photo and reality capture for construction with AI help.','https://holobuilder.com',false,false,28000, freeTier:'Institutional only', price:0, tips:'Owned by FARO | AI-powered "Site Insights" | World class hardware integration'),
    t('v-rex-ai-pro','Vrex','business','AI-powered VR collaboration for BIM and construction teams.','https://vrex.no',false,false,15000, freeTier:'Demo available', price:0, tips:'Walk through your design in VR with AI | Best for site inspections | modern'),
    t('field-wire-ai','Fieldwire (Hilti)','business','Jobsite management for construction teams with AI-powered task data.','https://fieldwire.com',true,true,120000, freeTier:'Free for up to 5 users', price:29, priceTier:'Pro per user monthly', tips:'Owned by Hilti | AI-powered "Plan" reading | Best for small and big teams'),
    t('reconstruct-ai-pro','Reconstruct','business','AI-powered visual command center for construction and property.','https://reconstructinc.com',false,false,12000, freeTier:'Demo available', price:0, tips:'AI-powered "4D" schedule matching | Best for complex builds | Data-driven'),

    // ━━━ AI FOR ENERGY & OIL/GAS v2 ━━━
    t('schlum-ai-pro','Schlumberger (SLB Agora)','business','The world\'s leading oilfield services company with AI-powered edge labs.','https://slb.com',false,true,45000, freeTier:'Institutional only', price:0, tips:'Digital transformation leader | AI-powered reservoir modeling | Global scale'),
    t('halliburton-ai','Halliburton (Landmark)','business','Leading provider of exploration and production software with AI data.','https://halliburton.com',false,true,35000, freeTier:'Institutional only', price:0, tips:'AI-powered "DecisionSpace" | Industry standard for oil/gas R&D | Secure'),
    t('baker-hughes-ai','Baker Hughes (C3 AI)','business','Industrial AI applications for the energy industry powered by C3 AI.','https://bakerhughes.com',false,true,28000, freeTier:'Institutional only', price:0, tips:'AI-powered emissions tracking | Clean energy focus | Strategic partnership'),
    t('shell-ai-pro','Shell (Digital)','business','Leading energy company using AI for retail, exploration, and grid.','https://shell.com',false,true,58000, freeTier:'Institutional only', price:0, tips:'AI-powered "Loyalty" programs | Energy transition leader | Massive data scale'),
    t('bp-digital-ai','BP (Castrol Smart)','business','Energy giant using AI for predictive maintenance and refinery data.','https://bp.com',false,true,45000, freeTier:'Institutional only', price:0, tips:'AI-powered trading and supply chain | Net-zero focus | High technology'),
    t('exxon-ai-pro','ExxonMobil (Digital)','business','The world\'s largest public energy company with high-end AI labs.','https://corporate.exxonmobil.com',false,false,35000, freeTier:'Institutional only', price:0, tips:'AI-powered drilling and safety | Massive R&D spend | Global industry leader'),
    t('chevron-ai-pro','Chevron (Microsoft Forge)','business','Leading energy company using AI and Microsoft Cloud for transformation.','https://chevron.com',false,false,25000, freeTier:'Institutional only', price:0, tips:'AI-powered "Carbon Capture" research | Clean energy focus | Strategic focus'),
    t('total-energies-ai','TotalEnergies (Digital)','business','Global multi-energy company with AI-powered solar and wind networks.','https://totalenergies.com',false,false,18000, freeTier:'Institutional only', price:0, tips:'French energy leader | AI-powered "Smart Cities" | Diversified portfolio'),
    t('enel-ai-pro','Enel (Digital)','business','One of the world\'s largest utilities using AI to manage the smart grid.','https://enel.com',false,true,58000, freeTier:'Institutional only', price:0, tips:'World leader in renewable energy | AI-powered "Smart Metering" | European tech'),
    t('iberdrola-ai-pro','Iberdrola','business','Leading global utility company using AI for wind and solar data.','https://iberdrola.com',false,true,45000, freeTier:'Institutional only', price:0, tips:'World leader in wind energy | AI-powered maintenance | Spanish energy giant'),

    // ━━━ AI FOR MEDICINE & SPECIALISTS v2 ━━━
    t('philips-health-ai','Philips (HealthSuite)','health','Global leader in health tech using AI for radiology and ICU care.','https://philips.com',false,true,150000, freeTier:'Institutional only', price:0, tips:'AI-powered "SmartSpeed" MRI | Best hospital UI | Trusted for 100+ years'),
    t('siemens-healthex','Siemens Healthineers','health','Leading provider of medical imaging and lab tech with high-end AI.','https://siemens-healthineers.com',false,true,120000, freeTier:'Institutional only', price:0, tips:'AI-powered "AI-Rad Companion" | Industry standard for labs | Global scale'),
    t('ge-health-ai','GE HealthCare','health','Leading provider of medical imaging and digital solutions with AI.','https://gehealthcare.com',false,true,150000, freeTier:'Institutional only', price:0, tips:'AI-powered "Critical Care" suite | Best for ultrasound | Trusted brand'),
    t('medtronic-ai-pro','Medtronic (Digital)','health','World\'s largest medical device company using AI for chronic care.','https://medtronic.com',false,true,84000, freeTier:'Institutional only', price:0, tips:'AI-powered "Smart insulin" pumps | Global leader in heart tech | Reliable'),
    t('stryker-ai-pro','Stryker (Mako)','health','Leading provider of surgical robotics using AI for precision orthopedics.','https://stryker.com',false,true,45000, freeTier:'Institutional only', price:0, tips:'AI-powered "Mako" robot | Best for joint replacement | Pro standard'),
    t('intuitive-surg-ai','Intuitive (da Vinci)','health','The world leader in robotic-assisted surgery and AI analytics.','https://intuitive.com',false,true,58000, freeTier:'Institutional only', price:0, tips:'AI-powered "da Vinci" robot | Minimize invasiveness | 10M+ surgeries'),
    t('dexcom-ai-pro','Dexcom','health','Leading provider of continuous glucose monitoring with AI alerts.','https://dexcom.com',false,true,250000, freeTier:'Hardware and subscription required', price:0, tips:'Best for Type 1 Diabetes | AI-powered "High/Low" alerts | Global trust'),
    t('abbott-ai-health','Abbott (FreeStyle)','health','Leading global healthcare company with AI-powered sensors and labs.','https://abbott.com',false,true,180000, freeTier:'Institutional only', price:0, tips:'AI-powered "Libre" sensors | World class labs | Trusted for over 100 years'),
    t('roche-health-ai','Roche (Digital)','health','World\'s largest biotech company using AI for personalized diagnostics.','https://roche.com',false,true,120000, freeTier:'Institutional only', price:0, tips:'Pioneer in oncology therapy with AI | Swiss quality | massive R&D'),
    t('novartis-ai-pro','Novartis (Digital)','health','Leading medicine company using AI to accelerate drug discovery.','https://novartis.com',false,true,84000, freeTier:'Institutional only', price:0, tips:'Multi-year AI partnership with Microsoft | Focus on data science | Strategic'),

    // ━━━ FINAL GEMS v16 (Dev Operations) ━━━
    t('datadog-ai-pro','Datadog','code','The observability and security platform for cloud apps with AI help.','https://datadoghq.com',true,true,250000, freeTier:'Free basic version up to 5 hosts', price:15, priceTier:'Pro monthly base', tips:'Best for cloud monitoring | AI-powered "Watchdog" for anomalies | Scale'),
    t('new-relic-ai','New Relic','code','Leading platform for app performance monitoring and observability with AI.','https://newrelic.com',true,true,180000, freeTier:'Free forever basic tier (100GB/mo)', price:0, tips:'AI-powered "Gropping" and root cause | Best for DevOps teams | Reliable'),
    t('dynatrace-ai-pro','Dynatrace','code','Unified observability and security platform with AI-powered Davis.','https://dynatrace.com',true,true,84000, freeTier:'15-day free trial on site', price:0, tips:'The enterprise standard | AI-powered "Causation" engine | High automation'),
    t('splunk-ai-pro','Splunk (Cisco)','code','Leading data platform for security and observability with AI data.','https://splunk.com',true,true,150000, freeTier:'Free basic version available', price:0, tips:'Owned by Cisco | AI-powered "Insights" | Best for petabyte scale'),
    t('p-ager-duty-ai','PagerDuty','code','Leading platform for real-time operations and incident response with AI.','https://pagerduty.com',true,true,120000, freeTier:'Free for up to 6 users', price:21, priceTier:'Professional monthly', tips:'AI-powered "Noise Reduction" | Industry standard for on-call | High trust'),
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
