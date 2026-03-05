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
    t('c3-ai', freeTier:'Institutional only', price:0, tips:'The world leader in Enterprise AI software | AI-powered "Reliability" and "Inventory" management used by Shell, Baker Hughes, and the US Air Force to manage global assets instantly'),
    t('fantastical-ai', freeTier:'Free forever basic version (Web/App)', price:5, priceTier:'Individual monthly annual', tips:'The gold standard for smart calendars on Mac and iOS | AI-powered "Natural Language" scheduling turns complex meeting requests into professional data events instantly'),
    t('atlas-ai', freeTier:'Institutional only', price:0, tips:'Leading platform for hyperlocal socioeconomic intelligence | AI-powered "Economic" and "Infrastructure" data mapping used by global development banks and retailers'),
    t('habito-ai', freeTier:'Free forever basic mortgage search', price:0, tips:'Leading AI mortgage broker and home buying platform | AI-powered "Deal Finder" and "Chatbot" helps you find the best rates across thousands of mortgage data points'),
    t('entera-ai', freeTier:'Institutional only', price:0, tips:'Leading AI for single-family residential investing at scale | Best for institutional buyers finding and closing off-market property data deals automatically'),
    t('descartes-labs', freeTier:'Institutional only', price:0, tips:'Leading platform for high-accuracy Earth Observation and Supply Chain AI | AI-powered "Forecasts" for agriculture and global logistics driven by deep data'),
    t('fantastical-pro', freeTier:'Free basic account', price:5, priceTier:'Individual monthly', tips:'The industry standard for high-end scheduling | Features incredibly "Template" and "Time Zone" management driven by your specific personal data history'),
    t('c3-ai-pro', freeTier:'Institutional only', price:0, tips:'Professional enterprise intelligence suite | AI-powered "Supply Chain" optimization reduces carbon footprints and data waste for Global 2000 companies'),
    t('atlas-ai-pro', freeTier:'Institutional only', price:0, tips:'Professional geospatial research suite | Featuring high-end "Market Potential" detection in developing nations using satellite and census data'),
    t('habito-pro', freeTier:'Free mortgage trial', price:0, tips:'The smarter way to buy a home | AI-powered "Step-by-step" guidance ensures you land the best possible financial data profile for your mortgage'),
    t('entera-pro', freeTier:'Institutional only', price:0, tips:'Enterprise-grade residential investment platform | AI-powered "Market" insights driven by millions of housing data points and neighborhood research'),
    t('descartes-labs-ai', freeTier:'Institutional only', price:0, tips:'Professional data refinery for satellite imagery | Features incredible "Cloud" and "Land Use" capture for high-fidelity planetary data reports'),
    t('fantastical-ai-pro', freeTier:'Free basic access', price:5, priceTier:'Premium monthly', tips:'High-end productivity toolkit | AI-powered "Focus" and "Meeting" scheduling handles your entire team\'s calendar data distribution automatically'),
    t('c3-pro', freeTier:'Institutional only', price:0, tips:'The choices of global energy giants | AI-powered "Energy Management" handles your entire technical resource data cycle automatically driven by deep research'),
    t('atlas-pro', freeTier:'Institutional only', price:0, tips:'The choice of world-class retailers | AI-powered "Store Location" analysis handles your entire market entry data discovery and mapping automatically'),
    t('habito-ai-plus', freeTier:'Free basic version', price:0, tips:'The smartest mortgage coach in your browser | AI-powered "Comparison" engine driven by your specific financial and property data'),
    t('entera-ai-pro', freeTier:'Institutional only', price:0, tips:'The master of single-family investing | AI-powered "Profit" prediction handles thousands of property data points globally for pro buyers'),
    t('descartes-labs-pro', freeTier:'Institutional only', price:0, tips:'High-end geospatial data assistant | AI-powered "Satellite" monitoring handles thousands of global data points for technical agro-research'),
    t('fantastical-app', freeTier:'Free forever (Web/App)', price:5, priceTier:'Individual monthly', tips:'The most artistic calendar platform | Use the "Artistic" filters for high-impact schedule data and meeting sharing along your team'),
    t('c3-ai-energy', freeTier:'Institutional only', price:0, tips:'The "Command Center" for sustainable grid management | AI-powered "Efficiency" metrics ensure your field management follows specific data benchmarks'),
    t('atlas-ai-marketing', freeTier:'Institutional only', price:0, tips:'Leading AI for hyper-local market research | AI-powered "Spending" insights are world-class for finding the right buyers for your product data'),
    t('habito', freeTier:'Free mortgage search', price:0, tips:'The pioneer of automated home buying | Features world-class "Lender" data vault for high-speed mortgage approvals and data safety'),
    t('entera', freeTier:'Institutional only', price:0, tips:'Next-gen residential platform for pros | AI-powered "Buy Box" automation driven by millions of housing data points and research'),
    t('farmers-edge', freeTier:'Institutional only', price:0, tips:'Leading platform for digital farming and risk management | AI-powered "Insurance" and "Yield" tracking used by global food companies'),
    t('granular-ai', freeTier:'Institutional only (Corteva)', price:0, tips:'Leading AI for farm management and profitability | Best for industrial-scale agronomy finding the best nutrients and data-driven field harvest reports'),
    t('c3-enterprise', freeTier:'Institutional only', price:0, tips:'The the expert choice for AI infrastructure | AI-powered "Model" management handles your entire enterprise data science and research'),
    t('atlas-intelligence', freeTier:'Institutional only', price:0, tips:'Professional geospatial intelligence suite | AI-powered "Risk" and "Opportunity" reports handles your public infrastructure image data globally'),
    t('habito-ai-finance', freeTier:'Free basic tool', price:0, tips:'The industry standard for mortgage search | AI-powered "Rate" verification uses millions of successful loan data for better finance reach'),
    t('descartes-labs-intelligence', freeTier:'Institutional only', price:0, tips:'The gold standard for satellite data processing | Features incredible "Multimodal" understanding of your global supply chain data'),
    t('farmers-edge-pro', freeTier:'Institutional only', price:0, tips:'The ultimate resource for digital ag | AI-powered "Field" monitoring handles your entire technical crop and soil data cycle automatically'),
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
