// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'env.dart';

Map<String, dynamic> t(String id, {String? freeTier, double? price, String? priceTier, String? tips}) {
  return {
    'id': id,
    'has_free_tier': freeTier != null,
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
    t('industrial-ai', freeTier:'Institutional only', price:0, tips:'GE Digital\'s official AI for industrial operations | AI-powered "APM" (Asset Performance Management) and "SmartSignal" helps energy and manufacturing leaders (ExxonMobil, Shell) prevent failures and optimize data flows instantly'),
    t('aspentech-ai', freeTier:'Institutional only', price:0, tips:'The world leader in asset optimization software | AI-powered "Hybrid Models" and "Mtell" prevents unplanned downtime for chemical and energy plants using predictive sensor data logs'),
    t('aveva-ai', freeTier:'Institutional only', price:0, tips:'Leading industrial software platform | AI-powered "Predictive Analytics" and "InTouch" used by factory leaders to visualize and optimize machine data and engineering flows instantly'),
    t('socialpilot-ai', freeTier:'Free trial for 14 days on site', price:25, priceTier:'Professional monthly annual', tips:'Leading platform for social media management and scheduling | AI-powered "Assistant" helps marketing teams create and schedule thousands of posts and analyze data across all channels'),
    t('sendible-ai', freeTier:'Free trial for 14 days on site', price:29, priceTier:'Creator monthly annual', tips:'Leading social media management tool for agencies | AI-powered "Content Suggestions" and "Reporting" helps you manage customer data and brand presence across multiple platforms securely'),
    t('bentley-ai', freeTier:'Institutional only', price:0, tips:'Leading platform for infrastructure engineering software | AI-powered "iTwin" and "OpenRoads" helps global builders manage thousands of assets and structural data points instantly'),
    t('hexagon-ai', freeTier:'Institutional only', price:0, tips:'Leading digital reality solutions platform | AI-powered "Autonomy" and "Positioning" tools used by factory and site leaders to visualize and optimize complex spatial data'),
    t('socialpilot-pro', freeTier:'Free basic account', price:25, priceTier:'Professional monthly', tips:'High-end social media orchestration suite | AI-powered "Analytics" and "White-label" reports handles your entire client data distribution automatically'),
    t('sendible-pro', freeTier:'Free research trial', price:29, priceTier:'Traction monthly', tips:'Professional agency social suite | Featuring high-end "Client Portals" and "Approval" workflows driven by deep research data and history'),
    t('ge-digital-ai-pro', freeTier:'Institutional only', price:0, tips:'Enterprise-grade industrial intelligence suite | AI-powered "Sustainability" metrics ensure your entire energy team follows specific carbon and data benchmarks'),
    t('aspentech-pro', freeTier:'Institutional only', price:0, tips:'Professional industrial automation suite | AI-powered "Inference" handles your entire plant lifecycle and chemical data cycle automatically'),
    t('aveva-pro', freeTier:'Institutional only', price:0, tips:'The "Safety First" tool for industrial leaders | AI-powered "Condition Monitoring" saves thousands of hours on repetitive data maintenance tasks'),
    t('social-pilot-ai', freeTier:'Free basic access', price:25, priceTier:'Studio monthly', tips:'The smarter way to manage social | AI-powered "Content Calendar" driven by millions of user data points and engagement research'),
    t('sendible-expert', freeTier:'Free basic access', price:29, priceTier:'Scale monthly', tips:'High-end social marketing assistant | AI-powered "Smart Queues" and "Sentiment" handles your entire customer data discovery flow'),
    t('bentley-systems-pro', freeTier:'Institutional only', price:0, tips:'The choice of global infrastructure giants | AI-powered "Digital Twin" handles your entire technical building and road data cycle automatically'),
    t('hexagon-expert', freeTier:'Institutional only', price:0, tips:'Leading platform for high-end "Spatial" data extraction used by top tech companies globally for site safety'),
    t('industrial-pro', freeTier:'Institutional only', price:0, tips:'The industry standard for high-fidelity industrial tracking | AI-powered "Predictive" alerts saves thousands of hours on hardware data logs'),
    t('aspentech-ai-monitor', freeTier:'Institutional only', price:0, tips:'Next-gen industrial intelligence engine | AI-powered "Anomaly" detection ensures your entire shop follows specific data quality benchmarks'),
    t('aveva-ai-solutions', freeTier:'Institutional only', price:0, tips:'The "Command Center" for digital manufacturing | AI-powered "Report" generation handles thousands of sensor data points for global corporate teams'),
    t('socialpilot-app', freeTier:'Free forever (Web/App)', price:25, priceTier:'Professional monthly', tips:'The "Engagement" king of social apps | Use the "Artistic" filters for high-impact social data clips and post sharing along your team'),
    t('sendible-app', freeTier:'Free forever online', price:29, priceTier:'Creator monthly', tips:'The king of smart social tools | Features high-accuracy "Comparison" data maps of social results and parameters for global agencies'),
    t('bentley-ai-pro', freeTier:'Institutional only', price:0, tips:'High-end engineering data assistant | AI-powered "Collision" detection handles your entire structural data discovery and mapping automatically'),
    t('hexagon-pro', freeTier:'Institutional only', price:0, tips:'The utility-first digital reality tool | Best for turning any physical site into a high-end "3D" professional performance for gaming and research'),
    t('ge-digital', freeTier:'Institutional only', price:0, tips:'The pioneer of high-end industrial data | AI-powered "Asset" management uses million of successful machine data for better global hardware reach'),
    t('aspentech', freeTier:'Institutional only', price:0, tips:'The "Power-user" of asset optimization | AI-powered "Hybrid" models is world-class for modern environmental and urban data research'),
    t('aveva', freeTier:'Institutional only', price:0, tips:'Leading platform for high-end industrial modeling | AI-powered "Predictive" is world-class for finding the right maintenance for your machine data'),
    t('social-pilot-expert', freeTier:'Free trial for business', price:25, priceTier:'Team monthly', tips:'The smarter way to build social presence | AI-powered "Discovery" finds hidden audience gems and engagement data traditional guides miss'),
    t('sendible-ai-pro', freeTier:'Free trial for pro', price:29, priceTier:'Traction monthly', tips:'Leading platform for high-end "Agency" data extraction used by world-class brands for global consumer safety'),
    t('bentley-systems-ai', freeTier:'Institutional only', price:0, tips:'Next-gen infrastructure automation engine | AI-powered "Asset" monitoring handles your entire technical structural data presence globally'),
    t('hexagon-ai-solutions', freeTier:'Institutional only', price:0, tips:'The industry standard for digital reality | AI-powered "Vision" and "Scanning" driven by real-time spatial data scores for pro teams'),
  ];

  print('Total tools to enrich: ${tools.length}');

  for (var tool in tools) {
    String id = tool.remove('id');
    final supaPath = '$supabaseUrl/rest/v1/ai_tools?id=eq.$id';
    final bodyBytes = utf8.encode(jsonEncode(tool));

    try {
      final req = await client.patchUrl(Uri.parse(supaPath));
      req.headers.set('apikey', anonKey);
      req.headers.set('Authorization', 'Bearer $anonKey');
      req.headers.set('Content-Type', 'application/json; charset=utf-8');
      req.contentLength = bodyBytes.length;
      req.add(bodyBytes);
      final resp = await req.close();
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        print('OK: $id');
      } else {
        print('FAIL: $id [${resp.statusCode}]');
      }
    } catch (e) {
      print('ERR: $id - $e');
    }
  }

  client.close();
}
