// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

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
  const supabaseUrl = 'https://ssemwzmwhlcfmzmrweuw.supabase.co';
  const anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNzZW13em13aGxjZm16bXJ3ZXV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIxNzkxMTcsImV4cCI6MjA4Nzc1NTExN30.QF9G86V2HxzMrnN37ENQkrY7L_m7LBuxa56tC5MoywA';
  final client = HttpClient();

  final tools = <Map<String, dynamic>>[
    t('palantir-foundry', freeTier:'Institutional only', price:0, tips:'The world leader in data-driven operations | AI-powered "Ontology" and "Decision Mirror" helps organizations (Airbus, BP) connect silos and optimize global logistics and data flows instantly'),
    t('samsara-ai', freeTier:'Institutional only', price:0, tips:'Leading platform for Connected Operations | AI-powered "Dash Cam" and "Telematics" prevents accidents and optimizes fuel efficiency for massive vehicle fleets using real-time data logs'),
    t('manychat-ai', freeTier:'Free forever basic version (Up to 1000 contacts)', price:15, priceTier:'Pro monthly annual', tips:'The world leader in chat marketing for Instagram and FB | AI-powered "Flow Builder" turns simple prompts into high-end "Conversational" data journeys that convert'),
    t('aisera', freeTier:'Institutional only', price:0, tips:'Leading AI for automated employee and customer experience | AI-powered "Service Graph" and "LXP" handles thousands of support data queries and internal tickets for Global 2000 brands'),
    t('collect-chat', freeTier:'Free forever basic version (Up to 50 responses/mo)', price:24, priceTier:'Lite monthly annual', tips:'Leading AI chatbot for websites and lead generation | Best for non-technical users creating "Interactive" data flows that handle meetings and sales automatically'),
    t('ptc-ai', freeTier:'Institutional only', price:0, tips:'Leading industrial software platform with deep AI | AI-powered "Vuforia" (AR) and "ThingWorx" (IoT) used by factory leaders to visualize and optimize machine data instantly'),
    t('palantir-pro', freeTier:'Institutional only', price:0, tips:'The "Safety First" tool for government and finance | AI-powered "Gotham" and "Foundry" handles thousands of complex data queries and threat hunts for the world\'s largest brands'),
    t('samsara-pro', freeTier:'Institutional only', price:0, tips:'Enterprise-grade fleet intelligence suite | AI-powered "Efficiency" metrics ensure your entire logistics team follows specific safety and data benchmarks'),
    t('manychat-pro', freeTier:'Free basic account', price:15, priceTier:'Pro monthly', tips:'High-end marketing orchestration suite | AI-powered "Template" and "Trigger" management handles your entire consumer data distribution automatically'),
    t('aisera-ai-pro', freeTier:'Institutional only', price:0, tips:'Professional conversational automation suite | Featuring high-end "NLU" in complex corporate environments using deep data research and history for pro support'),
    t('collect-chat-pro', freeTier:'Free basic access', price:24, priceTier:'Standard monthly', tips:'The "Search Engine for Leads" | AI-powered "Validation" and "Report" generation ensures your entire team follows specific brand and data rules'),
    t('ptc-pro', freeTier:'Institutional only', price:0, tips:'Professional industrial automation suite | AI-powered "PLM" handles your entire product lifestyle and manufacturing data cycle automatically'),
    t('palantir-ai-plus', freeTier:'Institutional only', price:0, tips:'Next-gen data intelligence platform | AI-powered "Simulation" recognition is world-class for modern environmental and urban data research and mapping'),
    t('samsara-ai-plus', freeTier:'Institutional only', price:0, tips:'The industry leader in high-end vehicle and worker safety | AI-powered "Vision" helps you identify risky driving data and patterns effortlessly'),
    t('many-chat-pro', freeTier:'Free trial available', price:15, priceTier:'Pro monthly', tips:'The choice of top marketing agencies | AI-powered "Instagram Automation" handles thousands of comments and messages simultaneously driven by deep data'),
    t('aisera-expert', freeTier:'Institutional only', price:0, tips:'The smarter way to manage enterprise support | AI-powered "Insights" driven by millions of employee data points and behavioral research'),
    t('collect-pro', freeTier:'Free trial available', price:24, priceTier:'Standard monthly', tips:'High-end lead generation assistant | AI-powered "Analytics" and "Sync" handles your entire customer data discovery flow and CRM mapping'),
    t('ptc-intelligence', freeTier:'Institutional only', price:0, tips:'Leading platform for high-end "Digital Twin" data extraction used by top tech companies globally for industrial safety'),
    t('palantir-foundry-ai', freeTier:'Institutional only', price:0, tips:'The smartest choice for data-driven CEOs | AI-powered "AIP" (Artificial Intelligence Platform) handles your entire corporate data and security research'),
    t('samsara-app', freeTier:'Free basic with hardware', price:0, tips:'The "Command Center" for fleet managers | AI-powered "Alerting" and "Insight" driven by millions of sensor data points globally on your mobile'),
    t('manychat-app', freeTier:'Free forever online', price:15, priceTier:'Pro monthly', tips:'The most artistic messaging platform | Use the "Artistic" filters for high-impact chatbot data and meeting sharing along your team'),
    t('aisera-automation', freeTier:'Institutional only', price:0, tips:'Next-gen customer intelligence engine | AI-powered "Self-service" uses millions of successful conversation data for better global support reach'),
    t('collect-chat-ai', freeTier:'Free basic account', price:24, priceTier:'Starter monthly', tips:'The king of smart forms and bots | Features high-accuracy "Comparison" data maps of customer results and parameters for marketers'),
    t('palantir', freeTier:'Institutional only', price:0, tips:'The pioneer of high-end data OS | Best for turning any technical recording into a professional performance for gaming and media research'),
    t('samsara', freeTier:'Institutional only', price:0, tips:'The "Power-user" of industrial safety | AI-powered "Fleet" management uses million of successful safety data for better global hardware reach'),
    t('many-chat', freeTier:'Free trial for business', price:15, priceTier:'Standard monthly', tips:'The ultimate resource for high-end chatbots | Best for finding creative bot flows that follow your brand\'s specific artistic data style'),
    t('aisera-pro', freeTier:'Institutional only', price:0, tips:'Professional enterprise intelligence suite | AI-powered "Model" management handles your entire enterprise data science and research driven by deep research'),
    t('collect-chat-app', freeTier:'Free forever (Web/App)', price:24, priceTier:'Standard monthly', tips:'The smarter way to build website bots | AI-powered "Relationship" and "Tagging" handles your entire data presence globally'),
    t('palantir-ai', freeTier:'Institutional only', price:0, tips:'The choice of world-class analysts | AI-powered "Data Integration" handles your entire dataset design data automatically for pro reports'),
    t('samsara-ai-monitoring', freeTier:'Institutional only', price:0, tips:'The industry standard for high-fidelity industrial tracking | AI-powered "Maintenance" alerts saves thousands of hours on hardware data logs'),
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
