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
    t('travelperk-ai', freeTier:'Free forever basic for businesses', price:0, tips:'Leading corporate travel management platform | AI-powered "Ada" assistant handles thousands of flight and hotel bookings, changes, and invoices instantly driven by deep traveler data'),
    t('cronometer', freeTier:'Free forever basic version (Ad-supported)', price:9, priceTier:'Gold monthly annual', tips:'The gold standard for high-accuracy nutrition tracking | AI-powered "Micro-nutrient" and "Biomarker" analysis used by pro athletes and data scientists globally'),
    t('yummly', freeTier:'Free forever basic version online', price:0, tips:'Leading smart cooking and recipe platform | AI-powered "Personalized" meal plans and ingredient matching based on your specific diet and taste data'),
    t('contractbook', freeTier:'Free forever basic version for individuals', price:99, priceTier:'Foundation monthly annual', tips:'Leading platform for automated contract management | AI-powered "Drafting" and "Data" extraction helps legal teams manage thousands of documents instantly'),
    t('lose-it', freeTier:'Free forever basic version online', price:4, priceTier:'Premium monthly annual', tips:'Leading weight loss and calorie tracking app | AI-powered "Snap It" photo recognition turns food photos into high-accuracy nutritional data logs'),
    t('plantjammer', freeTier:'Free forever basic version online', price:0, tips:'Leading AI for plant-based cooking and sustainability | Best for building high-end "Empty Fridge" recipes by matching available ingredient data'),
    t('evisort', freeTier:'Institutional only', price:0, tips:'Leading enterprise AI for contract intelligence | AI-powered "Deep Search" finds data and risks across 100k+ legal papers in seconds'),
    t('cronometer-ai-pro', freeTier:'Free basic account', price:9, priceTier:'Gold monthly', tips:'The industry standard for high-fidelity health data | AI-powered "Trend" analysis helps you understand how your diet drives your physical performance'),
    t('travelperk-ai-pro', freeTier:'Free for small teams', price:15, priceTier:'Premium monthly annual', tips:'High-end corporate travel suite | AI-powered "Budget" and "Compliance" tracking handles your entire team\'s travel data safely'),
    t('contractbook-ai-pro', freeTier:'Free tool trial', price:99, priceTier:'Pro monthly', tips:'The "Safety First" tool for legal teams | AI-powered "Workflow" automation saves thousands of hours on repetitive signatures and data tasks'),
    t('yummly-ai-recipes', freeTier:'Free basic access', price:0, tips:'The "Search Engine for Taste" | AI-powered "Meal Planning" driven by millions of global culinary data points and research'),
    t('lose-it-ai-plus', freeTier:'Free basic version', price:4, priceTier:'Premium annual', tips:'The smartest calorie coach in your pocket | AI-powered "Sleep" and "Activity" integration driven by your specific body data'),
    t('plant-jammer-ai', freeTier:'Free recipe trial', price:0, tips:'The future of vegetarian cooking | Best for travelers building deep research logs and ingredient data itineraries instantly'),
    t('evisort-ai-pro', freeTier:'Institutional only', price:0, tips:'Professional legal intelligence suite | Featuring high-end "Anomaly" detection in complex corporate contracts using deep research data'),
    t('cronometer-pro', freeTier:'Free trial available', price:9, priceTier:'Gold monthly', tips:'The expert choice for nutrition data | Use the "Custom" presets to track specific athletic goals and health benchmarks with AI help'),
    t('contractbook-pro', freeTier:'Free trial available', price:99, priceTier:'Pro monthly', tips:'High-end legal orchestration suite | AI-powered "Project" management handles thousands of legal data tasks across your entire team'),
    t('yummly-pro', freeTier:'Free trial available', price:5, priceTier:'Subscription monthly member', tips:'The premier cooking assistant for high-end creators | Best for finding unique and specialized recipes for your food data projects'),
    t('lose-it-pro', freeTier:'Free trial available', price:4, priceTier:'Premium monthly', tips:'The choice of millions for sustainable weight loss | AI-powered "Habit" tracking handles your entire health and data distribution'),
    t('travelperk-enterprise', freeTier:'Free basic access', price:0, tips:'The "Command Center" for global travel | AI-powered "Report" generation handles thousands of data points for corporate finance teams'),
    t('cronometer-app', freeTier:'Free forever (Solo)', price:9, priceTier:'Gold monthly', tips:'The "Power-user" of health tracking | AI-powered "Nutrient" verification uses million of successful diet data for better health reach'),
    t('contract-book', freeTier:'Free trial available', price:99, priceTier:'Basic monthly', tips:'The ultimate legal assistant | AI-powered "Signature" tracking handles your entire document data discovery flow'),
    t('yummly-app', freeTier:'Free forever online', price:0, tips:'The king of smart kitchen tools | Features high-accuracy "Visual" data maps of ingredients and cooking steps'),
    t('loseit', freeTier:'Free basic account', price:4, priceTier:'Premium monthly', tips:'The "Engagement" king of health apps | Use the "Barcode" scanner for high-impact food data logging that converts'),
    t('travelperk', freeTier:'Free for startups', price:0, tips:'The smartest way to travel for business | AI-powered "FlexiPerk" handles thousands of cancellations and data refunds automatically'),
    t('contractbook-ai', freeTier:'Free basic account', price:99, priceTier:'Standard monthly', tips:'Leading platform for high-end "Contract" data extraction used by top tech companies globally for legal safety'),
    t('yummly-ai', freeTier:'Free basic account', price:0, tips:'Next-gen food intelligence platform | AI-powered "Recommendation" engine driven by millions of user data points'),
    t('cronometer-ai', freeTier:'Free basic account', price:9, priceTier:'Gold annual', tips:'The first AI-powered nutrition analyst | AI-powered "Lab" results integration handles your entire health record data safely'),
    t('travelperk-pro', freeTier:'Free trial available', price:15, priceTier:'Premium monthly', tips:'The choice of high-performance teams | AI-powered "Risk" and "Safety" alerts handles your entire traveler data globally'),
    t('eigen-ai', freeTier:'Institutional only', price:0, tips:'Leading AI for complex data extraction from finance and law docs | AI-powered "Research" used by world-class banks (Goldman Sachs)'),
    t('lovo-fitness', freeTier:'Free trial for 2 workouts', price:15, priceTier:'Pro monthly annual', tips:'Leading platform for AI-powered personalized fitness | Best for turning your specific physical data into high-end workout routines'),
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
