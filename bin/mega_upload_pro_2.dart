// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'env.dart';

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
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
  final client = HttpClient();

  final tools = <Map<String, dynamic>>[
    // ━━━ SECURITY (Enterprise) ━━━
    t('crowdstrike-ai','CrowdStrike Falcon','security','Leading cloud-native endpoint protection with AI-powered threat hunters.','https://crowdstrike.com',false,true,18000, freeTier:'15-day free trial', price:0, tips:'Detect zero-day threats with AI | Cloud-scale visibility | Industry standard for SOCs'),
    t('sentinelone-ai','SentinelOne','security','Autonomous AI endpoint security platform for prevention and response.','https://sentinelone.com',false,true,15000, freeTier:'Demo available', price:0, tips:'Single agent for all platforms | AI-powered rollback | High detection rate'),
    t('darktrace-ai','Darktrace','security','Self-learning AI that detects and responds to cyber threats in real-time.','https://darktrace.com',false,true,12000, freeTier:'Trial available', price:0, tips:'Learns your specific network behavior | Autonomous response | Protects cloud and email'),
    t('zscaler-ai','Zscaler','security','AI-powered zero trust exchange for secure cloud transformation.','https://zscaler.com',false,false,8400, freeTier:'Demo available', price:0, tips:'Zero trust architecture | AI-powered data protection | Accelerates user experience'),
    t('palo-alto-cortex','Palo Alto Cortex','security','AI-driven security operations (XDR) for advanced threat prevention.','https://paloaltonetworks.com',false,false,9200, freeTier:'Demo available', price:0, tips:'Unified data lake | AI-driven automation | Best-in-class threat intel'),

    // ━━━ DATA SCIENCE (Enterprise) ━━━
    t('databricks-ai','Databricks','code','Unified analytics platform for data and AI built on lakehouse architecture.','https://databricks.com',true,true,25000, freeTier:'14-day free trial', price:0, tips:'Collaborative notebooks | Spark-based scaling | MLflow for lifecycle management'),
    t('snowflake-cortex','Snowflake Cortex','code','Fully managed AI service in Snowflake for LLMs and data science.','https://snowflake.com',false,true,18000, freeTier:'30-day free trial', price:0, tips:'SQL-based AI functions | Zero-ops infrastructure | Secure data sharing'),
    t('dataiku-ai','Dataiku','code','Centralized data platform that moves businesses from analytics to AI.','https://dataiku.com',true,false,8400, freeTier:'Free edition available', price:0, tips:'Collaborative data science | Visual and code-based flows | Enterprise governance'),
    t('h2o-ai','H2O.ai','code','Open-source and enterprise AI platform for automated machine learning.','https://h2o.ai',true,false,9600, freeTier:'Free open source', price:0, tips:'AutoML leader | Distributed computing | Driverless AI for enterprise'),
    t('knime-ai','KNIME','code','Low-code data science platform for data prep and machine learning.','https://knime.com',true,false,6200, freeTier:'Free open source desktop', price:0, tips:'Drag-and-drop workflow | Huge community of extensions | Best for data prep'),

    // ━━━ LOGISTICS (Enterprise) ━━━
    t('convoy-ai','Convoy','business','AI-powered trucking network that connects shippers with carriers.','https://convoy.com',false,true,5400, freeTier:'Free for shippers basic', price:0, tips:'Automated matching | Real-time tracking | Reduce empty miles'),
    t('lineage-logistics-ai','Lineage Logistics','business','AI-driven temperature-controlled supply chain and warehouse giant.','https://lineagelogistics.com',false,false,2800, freeTier:'Institutional only', price:0, tips:'Cold storage leader | AI optimizes energy and space | Global network'),
    t('ch-robinson-ai','C.H. Robinson (Navisphere)','business','Global logistics platform using AI for freight and supply chain visibility.','https://chrobinson.com',false,false,3600, freeTier:'Demo available', price:0, tips:'Largest freight broker in US | AI-powered price predictions | Real-time alerts'),
    t('sixfold-ai','Sixfold (Transporeon)','business','Real-time transport visibility platform with AI-powered ETA predictions.','https://sixfold.com',false,false,1400, freeTier:'Demo available', price:0, tips:'Accurate ETAs for trucking | Multi-modal visibility | Acquired by Transporeon'),
    t('fourkites-ai','FourKites','business','Leading global supply chain visibility platform with AI analytics.','https://fourkites.com',false,false,2400, freeTier:'Demo available', price:0, tips:'End-to-end visibility | Yard management AI | Dynamic ETA leader'),

    // ━━━ MANUFACTURING (Enterprise) ━━━
    t('siemens-mindsphere','Siemens MindSphere','business','Cloud-based open IoT operating system with AI for industrial data.','https://siemens.com',false,true,6800, freeTier:'Free trial available', price:0, tips:'Connect every machine | AI for predictive maintenance | Leading in Industry 4.0'),
    t('honeywell-forge','Honeywell Forge','business','Enterprise performance management for industrial and building data.','https://honeywell.com',false,false,4200, freeTier:'Demo available', price:0, tips:'Optimize building energy | AI for asset reliability | Safety monitoring'),
    t('ge-digital-ai','GE Digital (Proficy)','business','Industrial software with AI for manufacturing and grid optimization.','https://ge.com/digital',false,false,3800, freeTier:'Institutional only', price:0, tips:'MES and SCADA leader | AI-powered process optimization | Renewable energy focus'),
    t('rockwell-ai','Rockwell Automation (FactoryTalk)','business','Industrial automation and digital transformation with AI analytics.','https://rockwellautomation.com',false,false,3400, freeTier:'Demo available', price:0, tips:'Smart manufacturing leader | AI for floor safety | Scalable on-prem and cloud'),
    t('abb-ai','ABB Ability','business','Digital solutions and AI for industrial electrification and robotics.','https://abb.com',false,false,2600, freeTier:'Institutional only', price:0, tips:'Robot automation focus | AI for energy efficiency | Marine and ports solutions'),

    // ━━━ EVENT MANAGEMENT AI ━━━
    t('cvent-ai','Cvent','marketing','Leading meetings, events, and hospitality technology platform with AI.','https://cvent.com',false,true,12000, freeTier:'Free professional account (limited)', price:0, tips:'AI-powered venue sourcing | All-in-one event app | Robust data networking'),
    t('hopin-ai','Hopin','marketing','All-in-one virtual event platform with AI for networking and content.','https://hopin.com',true,true,9600, freeTier:'Free for up to 100 registrations', price:99, priceTier:'Pro starting monthly', tips:'Best for hybrid events | AI networking matches people | High engagement tools'),
    t('bizzabo-ai','Bizzabo','marketing','Modern event success platform for high-impact in-person and virtual.','https://bizzabo.com',false,false,5400, freeTier:'Demo available', price:0, tips:'Personalized attendee journeys | AI for content discovery | Data-driven ROI'),
    t('hubilo-ai','Hubilo','marketing','Virtual and hybrid event platform with AI for attendee engagement.','https://hubilo.com',true,false,4200, freeTier:'Free trial available', price:0, tips:'Gamification built-in | AI matches attendees | Multi-platform support'),
    t('eventbrite-ai','Eventbrite','marketing','Global ticketing and event discovery platform with AI recommendations.','https://eventbrite.com',true,true,45000, freeTier:'Free for free events', price:0, tips:'Largest event marketplace | AI-powered marketing tools | Easy social sharing'),

    // ━━━ AGRICULTURE (Enterprise) ━━━
    t('indigo-ag','Indigo Ag','agriculture','AI platform for sustainable farming and carbon credit markets.','https://indigoag.com',false,false,2200, freeTier:'Free for farmers basic', price:0, tips:'Carbon credit focus | Biological seed treatments | Data-driven grain market'),
    t('farmers-business-network','FBN','agriculture','Global farmer-to-farmer network with AI for price transparency.','https://fbn.com',true,true,8400, freeTier:'Free membership', price:0, tips:'Compare seed and chemical prices | Largest farmer dataset | Direct-to-farm supply'),
    t('john-deere-ai','John Deere Operations Center','agriculture','AI-powered farming equipment and data management platform.','https://johndeere.com',false,true,15000, freeTier:'App is free (requires equipment)', price:0, tips:'Autonomous tractors | See & Spray AI | Real-time field data'),
    t('agworld-ai','Agworld','agriculture','Farm management and collaboration platform with AI data tracking.','https://agworld.com',false,false,2600, freeTier:'Free trial available', price:0, tips:'Best for collaboration with agronomists | Data-driven farm plans | Financial tracking'),
    t('fieldview-ai','Climate FieldView (Bayer)','agriculture','Leading digital farming platform with AI for field mapping.','https://climate.com',true,false,9200, freeTier:'Free basic account', price:99, priceTier:'Plus per year', tips:'Real-time data from equipment | Yield mapping AI | Pest and disease alerts'),
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
