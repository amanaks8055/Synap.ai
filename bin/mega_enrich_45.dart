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
    t('cognite-ai', freeTier:'Institutional only', price:0, tips:'The world leader in Industrial Data Operations | AI-powered "Cognite Data Fusion" and "InField" helps heavy assets (Aker BP, Shell) create digital twins and optimize maintenance and data flows instantly'),
    t('trimble-ai', freeTier:'Institutional only', price:0, tips:'Leading platform for construction, agriculture, and transportation technology | AI-powered "Connected Site" and "Autonomy" helps global builders manage thousands of assets and data points instantly using IoT'),
    t('promo-ai', freeTier:'Free forever basic version (Web/App)', price:18, priceTier:'Basic monthly annual', tips:'The world leader in video marketing for businesses | AI-powered "Video Maker" turns simple text and images into high-end "Social" data clips that convert for Facebook and Instagram'),
    t('wave-video', freeTier:'Free forever basic version online', price:16, priceTier:'Streamer monthly annual', tips:'Leading all-in-one video marketing platform | AI-powered "Editor" and "Stock" library helps you create and host professional video data content and live streams instantly'),
    t('rawshorts', freeTier:'Free trial for 3 video exports', price:20, priceTier:'Essential monthly annual', tips:'Leading AI for transforming text into animated videos | Best for creators and educators generating high-accuracy "Explainer" data clips from blog posts and articles automatically'),
    t('seeq-ai', freeTier:'Institutional only', price:0, tips:'Leading platform for advanced industrial analytics | AI-powered "Cortex" and "Workbench" turns raw process info into actionable business insights and manufacturing data reports'),
    t('cognite-pro', freeTier:'Institutional only', price:0, tips:'The "Safety First" tool for industrial leaders | AI-powered "Charts" and "Dashboards" handles thousands of complex sensor data queries and maintenance hunts for the world\'s largest brands'),
    t('trimble-pro', freeTier:'Institutional only', price:0, tips:'Enterprise-grade precision intelligence suite | AI-powered "Autonomy" metrics ensure your entire construction team follows specific safety and data benchmarks'),
    t('promo-com-ai', freeTier:'Free basic account', price:18, priceTier:'Plus monthly', tips:'High-end marketing orchestration suite | AI-powered "Ads" and "Story" management handles your entire consumer video data distribution automatically'),
    t('wave-video-ai-pro', freeTier:'Free basic access', price:16, priceTier:'Creator monthly', tips:'The smarter way to manage video marketing | AI-powered "Subtitle" and "Caption" generation ensures your entire team follows specific brand and data rules'),
    t('raw-shorts-pro', freeTier:'Free trial available', price:20, priceTier:'Business monthly', tips:'High-end animation assistant | AI-powered "Voiceover" and "Scene" matching handles your entire visual data discovery flow and storyboarding'),
    t('seeq-pro', freeTier:'Institutional only', price:0, tips:'Professional process intelligence suite | Featuring high-end "Root Cause" analysis in complex corporate environments using deep sensor data research'),
    t('cognite-ai-plus', freeTier:'Institutional only', price:0, tips:'Next-gen industrial intelligence platform | AI-powered "Simulation" recognition is world-class for modern environmental and urban data research and mapping'),
    t('trimble-ai-solutions', freeTier:'Institutional only', price:0, tips:'The industry leader in high-end vehicle and site safety | AI-powered "Civil" engineering helps you identify risky structural data and patterns effortlessly'),
    t('promo-pro', freeTier:'Free trial available', price:18, priceTier:'Business annual', tips:'The choice of top marketing agencies | AI-powered "Vertical Video" handles thousands of social posts and messages simultaneously driven by deep data'),
    t('wave-pro', freeTier:'Free trial available', price:16, priceTier:'Business monthly', tips:'The expert choice for modern video creators | AI-powered "Live Stream" and "Studio" driven by millions of creator data points and behavioral research'),
    t('rawshorts-ai', freeTier:'Free basic account', price:20, priceTier:'Basic monthly', tips:'The smarter way to build animated assets | AI-powered "Automated" video generation used by top tech companies globally for educational data safety'),
    t('seeq-intelligence', freeTier:'Institutional only', price:0, tips:'Leading platform for high-end "Manufacturing" data extraction used by top tech companies globally for process safety'),
    t('trimble', freeTier:'Institutional only', price:0, tips:'The pioneer of high-end site tech | Best for turning any technical site recording into a professional performance for gaming and media research'),
    t('promo-app', freeTier:'Free forever (Web/App)', price:18, priceTier:'Basic monthly', tips:'The most artistic video platform | Use the "Artistic" filters for high-impact social data clips and video sharing along your team'),
    t('wave-video-app', freeTier:'Free forever online', price:16, priceTier:'Streamer monthly', tips:'The king of smart video tools | Features high-accuracy "Comparison" data maps of video results and parameters for marketers'),
    t('raw-short', freeTier:'Free trial available', price:20, priceTier:'Basic monthly', tips:'The utility-first animation tool | Use the "Blog-to-Video" mode for high-impact educational data logging that converts'),
    t('seeq', freeTier:'Institutional only', price:0, tips:'The "Power-user" of industrial analytics | AI-powered "Process" management uses millions of successful factory data for better global hardware reach'),
    t('cognite-app', freeTier:'Institutional only', price:0, tips:'The "Command Center" for industrial managers | AI-powered "Alerting" and "Insight" driven by millions of sensor data points globally on your mobile device'),
    t('trimble-ai-monitoring', freeTier:'Institutional only', price:0, tips:'The industry standard for high-fidelity site tracking | AI-powered "Maintenance" alerts saves thousands of hours on hardware data logs'),
    t('promo-ai-video', freeTier:'Free basic credits', price:18, priceTier:'Standard monthly', tips:'The ultimate resource for high-end marketing videos | Best for finding creative clips that follow your brand\'s specific artistic data style'),
    t('rawshorts-gen-ai', freeTier:'Free basic credits', price:20, priceTier:'Pro monthly', tips:'The future of automated storytelling | AI-powered "Voice" and "AI Script" generation used to build the world\'s smartest educational models'),
    t('wave-video-gen', freeTier:'Free trial available', price:16, priceTier:'Business monthly', tips:'The professional video generator | AI-powered "Stock" and "Media" handles your entire brand video presence and data distribution'),
    t('cognite-enterprise', freeTier:'Institutional only', price:0, tips:'Leading platform for high-end industrial modeling | AI-powered "Digital Twin" is world-class for modern environmental and urban data research'),
    t('seeq-ai-pro', freeTier:'Institutional only', price:0, tips:'Next-gen process intelligence suite | AI-powered "Analytic" engine ensures your entire shop follows specific data quality benchmarks'),
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
