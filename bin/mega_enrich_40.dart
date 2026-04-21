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
    t('datarobot', freeTier:'Institutional only', price:0, tips:'The pioneer of Automated Machine Learning (AutoML) | AI-powered "Predictive" platform helps data scientists build, deploy, and manage thousands of models and data metrics across any cloud instantly'),
    t('akiflow', freeTier:'Free trial for 7 days on site', price:15, priceTier:'Individual monthly annual', tips:'The world\'s #1 productivity command center | AI-powered "Time Blocking" and "Task" management turns complex project requests into professional data events instantly'),
    t('sisense', freeTier:'Free trial available on site', price:0, tips:'Leading platform for infusing analytics everywhere | AI-powered "Knowledge" engine handles thousands of complex data queries and dashboard generation for enterprise teams'),
    t('qlik-ai', freeTier:'Free trial available on site', price:30, priceTier:'Standard monthly starting', tips:'Leading platform for real-time data integration and analytics | AI-powered "Insight Advisor" handles thousands of complex data queries and dashboard generation instantly'),
    t('metabase-ai', freeTier:'Completely free open source (Local)', price:85, priceTier:'Starter monthly annual', tips:'The easiest way for everyone in your company to ask questions and learn from data | AI-powered "Visual" search and dashboard generation driven by millions of user data'),
    t('superset-ai', freeTier:'Completely free open source (Apache)', price:0, tips:'Leading modern data exploration and visualization platform | AI-powered "SQL" lab and dashboard builder used by top tech companies for high-end results'),
    t('redash-ai', freeTier:'Completely free open source (Local)', price:0, tips:'The "Power-user" tool for data teams | AI-powered "Query" assistant turns rough SQL into professional data visualizations and reports instantly'),
    t('akiflow-pro', freeTier:'Free basic account', price:15, priceTier:'Individual monthly', tips:'High-end productivity toolkit | AI-powered "Focus" and "Meeting" scheduling handles your entire team\'s calendar data distribution automatically'),
    t('datarobot-ai-pro', freeTier:'Institutional only', price:0, tips:'Professional enterprise intelligence suite | AI-powered "Compliance" and "Governance" ensures your entire team follows specific compliance data benchmarks'),
    t('sisense-ai-pro', freeTier:'Free research trial', price:0, tips:'Advanced business intelligence suite | AI-powered "Analytic" engine ensures your entire shop follows specific data quality benchmarks'),
    t('qlik-ai-plus', freeTier:'Free basic access', price:30, priceTier:'Professional monthly', tips:'The "Command Center" for data leaders | AI-powered "Data Integration" handles your entire dataset design data automatically for pro reports'),
    t('metabase-expert', freeTier:'Free basic version', price:85, priceTier:'Subscription monthly', tips:'The smarter way to build data apps | AI-powered "Relationship" and "Tagging" handles your entire database data presence globally'),
    t('superset-pro', freeTier:'Free trial available', price:0, tips:'The choice of global data giants | AI-powered "Security" and "Scale" handles your entire enterprise data science research and history'),
    t('redash-pro', freeTier:'Free trial available', price:0, tips:'The expert choice for modern BI | AI-powered "Alerting" and "Insight" driven by millions of corporate data points globally'),
    t('akiflow-app', freeTier:'Free forever (Web/App)', price:15, priceTier:'Individual monthly', tips:'The most artistic productivity platform | Use the "Artistic" filters for high-impact schedule data and meeting sharing along your team'),
    t('datarobot-auto-ml', freeTier:'Institutional only', price:0, tips:'The industry standard for high-end AutoML | Features world-class "Model" management handles your entire enterprise data science and research'),
    t('sisense-intelligence', freeTier:'Institutional only', price:0, tips:'Professional enterprise intelligence suite | AI-powered "Market" insights driven by millions of corporate data points at scale'),
    t('qlik-pro', freeTier:'Free trial available', price:30, priceTier:'Individual monthly', tips:'The ultimate data growth platform | AI-powered "Reporting" automation used by top executives to manage their asset data'),
    t('metabase-ai-pro', freeTier:'Free basic access', price:85, priceTier:'Pro monthly', tips:'The future of data discovery | AI-powered "Search" and "Filter" uses million of successful corporate data for better investment'),
    t('superset-app', freeTier:'Free forever online', price:0, tips:'The king of modern BI tools | Features high-accuracy "Comparison" data maps of database results and parameters'),
    t('redash', freeTier:'Free forever (Solo)', price:0, tips:'The ultimate SQL assistant | AI-powered "Visualizer" handles your entire document data discovery flow and report sharing'),
    t('datarobot-ai', freeTier:'Institutional only', price:0, tips:'The pioneer of high-end AutoML | Best for turning any technical recording into a professional performance for gaming and media data'),
    t('akiflow-ai-pro', freeTier:'Free trial available', price:15, priceTier:'Pro monthly', tips:'High-speed productivity automation suite | Use the "Inbox" mode to find tasks based on your specific project data and budget'),
    t('sisense-ai', freeTier:'Institutional only', price:0, tips:'Next-gen enterprise intelligence engine | AI-powered "Discovery" driven by millions of user data points and behavioral research'),
    t('qlik-ai-solutions', freeTier:'Free trial available', price:30, priceTier:'Standard monthly', tips:'The choice of top data teams | AI-powered "Knowledge Base" handles your entire data science and research driven by deep research'),
    t('metabase-pro', freeTier:'Free trial available', price:85, priceTier:'Starter monthly', tips:'The smartest way to search for data | AI-powered "Natural Language" understanding used by billion-dollar corporate brands'),
    t('superset-ai-pro', freeTier:'Free trial available', price:0, tips:'Enterprise-grade analytics platform | AI-powered "Scaling" handles thousands of cloud data sources for privacy and risk reports'),
    t('redash-ai-pro', freeTier:'Free research trial', price:0, tips:'Professional data intelligence suite | AI-powered "Query" optimization ensures your brand voice follows specific data benchmarks'),
    t('datarobot-enterprise', freeTier:'Institutional only', price:0, tips:'Leading platform for high-end data modeling | AI-powered "Explainability" is world-class for modern environmental and urban data research'),
    t('akiflow-ai', freeTier:'Free basic account', price:15, priceTier:'Starter monthly', tips:'The smarter way to manage your time | AI-powered "Priority" metrics ensure your daily management follows specific data benchmarks'),
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
