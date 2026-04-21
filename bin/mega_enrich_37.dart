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
    t('mlflow', freeTier:'Completely free open source (Databricks)', price:0, tips:'The world leader in ML lifecycle management | AI-powered "Experiment" and "Model" tracking used by top data scientists to manage thousands of model versions and data metrics instantly'),
    t('augury-ai', freeTier:'Institutional only', price:0, tips:'Leading AI for predictive maintenance and machine health | AI-powered "Vibration" and "Sound" analysis prevents factory downtime by predicting failures using real-time sensor data'),
    t('reonomy', freeTier:'Free trial available for businesses', price:49, priceTier:'Individual monthly annual', tips:'Leading platform for commercial real estate intelligence | AI-powered "Property" and "Owner" discovery used by top investors to find off-market data deals instantly'),
    t('domino-data', freeTier:'Institutional only', price:0, tips:'Leading Enterprise AI platform for collaborative data science | Features world-class "Project" and "Compute" management used by Fortune 500 companies to scale their ML data'),
    t('virtual-staging', freeTier:'Free trial for 2 staged photos', price:15, priceTier:'Pro monthly annual', tips:'Leading AI for interior design and real estate marketing | Best for turning empty room photos into high-end "Furnished" artistic visual data instantly'),
    t('properly-ai', freeTier:'Free forever basic version online', price:0, tips:'Leading AI assistant for real estate appraisal and analysis | Best for identifying property value data trends and localized market research instantly'),
    t('stessa-ai', freeTier:'Free forever basic for up to 5 properties', price:15, priceTier:'Pro monthly annual', tips:'The "Command Center" for residential real estate investors | AI-powered "Income" and "Expense" tracking used by pro landlords to manage their portfolio data'),
    t('cropin-ai', freeTier:'Institutional only', price:0, tips:'Leading AI for agricultural data and sustainability | AI-powered "SmartFarm" used by global agribusinesses to optimize yield and data-driven field reports'),
    t('augury-ai-pro', freeTier:'Institutional only', price:0, tips:'Professional industrial intelligence suite | AI-powered "Actionable" insights reverses the effects of machine wear and tear driven by deep sensor data'),
    t('reonomy-ai-pro', freeTier:'Free research trial', price:49, priceTier:'Pro monthly', tips:'The smartest choice for CRE professionals | AI-powered "Deblocking" and "Portfolio" tracking handles your entire property data discovery and mapping automatically'),
    t('domino-data-pro', freeTier:'Institutional only', price:0, tips:'Professional data science orchestration suite | Featuring high-end "Model Governance" in complex corporate environments using deep research data and history'),
    t('virtual-staging-ai', freeTier:'Free staging trial', price:15, priceTier:'Starter monthly', tips:'The "Safety First" tool for real estate agents | AI-powered "Scene" generation saves thousands of dollars on physical furniture and staging data tasks'),
    t('properly-expert', freeTier:'Free basic access', price:0, tips:'The "Search Engine for Value" | AI-powered "Market Synthesis" driven by millions of real estate data points and valuation research'),
    t('stessa-app', freeTier:'Free forever basic version', price:15, priceTier:'Pro monthly', tips:'The smarter way to manage rentals | AI-powered "Tax" and "Performance" tracking driven by your specific property and finance data'),
    t('cropin-ai-pro', freeTier:'Institutional only', price:0, tips:'The choices of global agribusiness | AI-powered "Supply Chain" handles your entire technical crop and harvest data cycle automatically'),
    t('ml-flow-monitor', freeTier:'Free open source (Local)', price:0, tips:'The best way to debug ML experiments | Features incredible "Visualization" of data shifts and parameter logs for pro data engineering teams'),
    t('virtual-staging-pro', freeTier:'Free trial available', price:15, priceTier:'Pro monthly', tips:'High-end interior design assistant | AI-powered "Room" and "Furniture" matching handles your entire visual data discovery flow'),
    t('stessa-ai-pro', freeTier:'Free basic access', price:15, priceTier:'Pro monthly', tips:'The ultimate real estate growth platform | AI-powered "Banking" and "Reporting" automation used by top investors to manage their asset data'),
    t('cropin-intelligence', freeTier:'Institutional only', price:0, tips:'Leading platform for high-end digital farming | AI-powered "Risk" and "Opportunity" reports handles your public agriculture image data globally'),
    t('reonomy-app', freeTier:'Free trial for business', price:49, priceTier:'Starter monthly', tips:'The "Power-user" of property research | AI-powered "Search" and "Filter" uses million of successful CRE data for better investment'),
    t('domino-ai', freeTier:'Institutional only', price:0, tips:'The ultimate data science assistant | AI-powered "Compute" tracking handles your entire project data discovery flow'),
    t('mlflow-app', freeTier:'Free forever online', price:0, tips:'The king of ML tracking tools | Features high-accuracy "Comparison" data maps of model runs and parameters'),
    t('stessa', freeTier:'Free forever (Solo)', price:15, priceTier:'Pro monthly', tips:'The "Engagement" king of real estate apps | Use the "Receipt" scanner for high-impact expense data tracking that converts'),
    t('reonomy-pro', freeTier:'Free trial available', price:49, priceTier:'All-in-one monthly', tips:'The smartest way to find deals for pro investors | AI-powered "Portfolio" and "Asset" management driven by real-time market data'),
    t('virtualstaging-pro', freeTier:'Free staging trial', price:15, priceTier:'Pro monthly', tips:'Leading platform for high-end "Home Visuals" used by top tech companies globally for real estate safety'),
    t('augury-pro', freeTier:'Institutional only', price:0, tips:'Next-gen industrial intelligence platform | AI-powered "Recommendation" engine driven by millions of machine sensor data points'),
    t('cropin-pro', freeTier:'Institutional only', price:0, tips:'The industry standard for high-end agritech | AI-powered "Satellite" monitoring handles thousands of field data points simultaneously'),
    t('domino-enterprise', freeTier:'Institutional only', price:0, tips:'The choice of top data teams | AI-powered "Collaboration" and "Scale" handles your entire enterprise data science research'),
    t('reonomy-intelligence', freeTier:'Free trial for pro', price:49, priceTier:'Premium monthly', tips:'Professional CRE intelligence suite | Featuring high-end "Owner" and "Tenant" data insights used by top commercial brokers'),
    t('virtual-staging-ai-pro', freeTier:'Free staging credits', price:15, priceTier:'Standard monthly', tips:'The smarter way to stage homes | AI-powered "Redesign" is world-class for modern real estate and design data'),
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
