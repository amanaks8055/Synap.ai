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
    t('oura-ai', freeTier:'Free basic version with hardware purchase', price:6, priceTier:'Membership monthly annual', tips:'The world leader in smart ring technology | AI-powered "Readiness" and "Sleep" scoring used by pro athletes (NBA) to optimize their specific recovery data'),
    t('whisk-ai', freeTier:'Completely free online and mobile app', price:0, tips:'Owned by Samsung | Leading platform for smart meal planning and shopping | AI-powered "Nutrition" and "Inventory" management used by million of home cooks'),
    t('docugami', freeTier:'Free trial for 10 document types', price:15, priceTier:'Professional monthly per user', tips:'Leading AI for transforming unstructured documents into data | Best for business and legal teams extracting insights from thousands of PDFs and Office files instantly'),
    t('arable-ai', freeTier:'Institutional only', price:0, tips:'Leading AI for agricultural intelligence | AI-powered "Climate" and "Crop" monitoring used by global farmers to optimize irrigation and data-driven harvest reports'),
    t('foodsmart', freeTier:'Free forever basic for registered users', price:0, tips:'Leading platform for clinical-grade nutrition guidance | AI-powered "Meal" and "Health" tracking driven by deep medical data for chronic condition care'),
    t('mealprepai', freeTier:'Free trial for 1 week', price:10, priceTier:'Pro monthly annual', tips:'Best for fitness enthusiasts | AI-powered "Macronutrient" and "Budget" specific meal prep plans generated from your body and goal data'),
    t('gpt-lawyer', freeTier:'Free trial for 3 legal queries', price:20, priceTier:'Pro monthly annual', tips:'Leading AI assistant for consumer legal help | Best for understanding contracts, small claims, and traffic issues based on localized data'),
    t('buildout-ai', freeTier:'Institutional only', price:0, tips:'Leading AI for commercial real estate marketing | AI-powered "Market" and "Property" profiles used by top brokers to manage thousands of data listings'),
    t('complai', freeTier:'Institutional only', price:0, tips:'Leading platform for automated regulatory compliance | AI-powered "Audit" and "Risk" tracking handles thousands of corporate data filings for finance teams'),
    t('oura-ring-pro', freeTier:'Free basic access', price:6, priceTier:'Subscription monthly', tips:'The ultimate health research companion | AI-powered "Stress" and "Cycle" tracking finds hidden biometric data trends traditional trackers miss'),
    t('whisk-samsung', freeTier:'Completely free access', price:0, tips:'The "Smart Kitchen" of the future | AI-powered "Recipe" discovery driven by millions of global culinary data points and smart appliance research'),
    t('docugami-ai-pro', freeTier:'Free document trial', price:15, priceTier:'Pro monthly', tips:'Professional document intelligence suite | Featuring high-end "Knowledge Graph" generation for complex corporate document data flows'),
    t('arable-ai-pro', freeTier:'Institutional only', price:0, tips:'Enterprise-grade agricultural monitoring | AI-powered "Yield" prediction driven by real-time soil and weather data sensors globally'),
    t('foodsmart-ai', freeTier:'Free health access', price:0, tips:'The smarter way to eat healthy | AI-powered "Counseling" and "Grocery" integration driven by your specific health and body data'),
    t('meal-prep-ai-pro', freeTier:'Free trial available', price:10, priceTier:'Pro monthly', tips:'The "Power-user" of healthy eating | AI-powered "Shopping List" and "Cook Time" optimization handles your entire weekly food data planning'),
    t('gpt-lawyer-ai', freeTier:'Free trial available', price:20, priceTier:'Individual monthly', tips:'The industry standard for fast legal research | AI-powered "Contract Summarizer" is world-class for consumer protection and data rights'),
    t('buildout-pro', freeTier:'Institutional only', price:0, tips:'Professional CRE marketing suite | Featuring high-end "Brochure" and "Site" generation driven by millones of real estate data points'),
    t('compl-ai-pro', freeTier:'Institutional only', price:0, tips:'Next-gen corporate governance platform | AI-powered "Report" generation ensures your entire team follows specific compliance data benchmarks'),
    t('oura-app', freeTier:'Free with device', price:6, priceTier:'Membership monthly', tips:'The most artistic health data app | Featuring high-end "Biofeedback" and "Recovery" insights used by top pro data scientists'),
    t('whisk-app', freeTier:'Free forever (Solo)', price:0, tips:'The "One-click" meal planner | Use the "Artistic" filters for high-impact food data posts and recipe sharing along your team'),
    t('docugami-pro', freeTier:'Free trial available', price:15, priceTier:'Professional monthly', tips:'High-end business document assistant | AI-powered "Drafting" and "Review" handles your entire document data discovery flow'),
    t('arable-pro', freeTier:'Institutional only', price:0, tips:'Thechoices of global agronomists | AI-powered "Pulse" handles your entire technical crop and soil data cycle automatically'),
    t('foodsmart-pro', freeTier:'Free basic version', price:0, tips:'Professional nutrition intelligence platform | AI-powered "Telehealth" driven by millions of clinical data points and research'),
    t('mealprepai-pro', freeTier:'Free trial available', price:10, priceTier:'Pro monthly', tips:'High-speed meal automation suite | Use the "Pantry" mode to find recipes based on your specific ingredient data and budget'),
    t('gpt-lawyer-pro', freeTier:'Free trial available', price:20, priceTier:'Pro monthly', tips:'The safer way to navigate laws | AI-powered "Attorney" insights ensure your brand voice follows specific legal data benchmarks'),
    t('buildout-ai-marketing', freeTier:'Institutional only', price:0, tips:'Leading AI for commercial real estate ads | AI-powered "Targeting" is world-class for finding the right buyers for your property data'),
    t('complai-security', freeTier:'Institutional only', price:0, tips:'Leading platform for high-end corporate safety | AI-powered "Incident" tracking handles thousands of reports simultaneously driven by deep data'),
    t('oura-ring-ai', freeTier:'Free basic version', price:6, priceTier:'Monthly membership', tips:'The industry standard for high-fidelity sleep data | AI-powered "Laboratory" results integration handles your entire health record data safely'),
    t('arable-gen', freeTier:'Institutional only', price:0, tips:'The "Command Center" for sustainable farming | AI-powered "Efficiency" metrics ensure your field management follows specific environmental data'),
    t('docugami-ai', freeTier:'Free trial available', price:15, priceTier:'Pro monthly', tips:'Next-gen document automation engine | AI-powered "Relationship" and "Tagging" handles your entire document data presence globally'),
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
