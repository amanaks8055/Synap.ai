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
    t('wanderlog', freeTier:'Free forever basic version (Web/App)', price:0, tips:'The world\'s #1 travel planning tool | AI-powered "Itinerary" and "Budget" manager turns road trip ideas into professional interactive data maps used by million of travelers'),
    t('patentpal', freeTier:'Free trial for 1 patent draft', price:99, priceTier:'Individual monthly annual', tips:'Leading AI for patent drafting and IP strategy | Best for patent attorneys and inventors generating high-accuracy legal figures and data descriptions instantly'),
    t('kira-ai', freeTier:'Institutional only (Litera)', price:0, tips:'The gold standard for AI-based contract review and due diligence | AI-powered "Clustering" finds risks across thousands of corporate data docs for global law firms'),
    t('klarity-ai', freeTier:'Institutional only', price:0, tips:'Leading AI for automated revenue recognition and accounting | AI-powered "Deal Document" analysis helps finance teams manage thousands of complex data contracts instantly'),
    t('specifio', freeTier:'Institutional only', price:0, tips:'Leading AI for high-accuracy patent application generation | Best for IP firms automating the technical writing and data visualization cycle for inventions'),
    t('termsservice', freeTier:'Completely free online tool', price:0, tips:'Leading AI for summarizing "Terms of Service" and "Privacy Policies" | Best for users needing to understand complex legal data risks in seconds'),
    t('notabot', freeTier:'Free forever basic version online', price:0, tips:'Leading AI assistant for legal research and document drafting | Best for lawyers needing fast semantic search across their own private data archives'),
    t('veritone-ai', freeTier:'Institutional only', price:0, tips:'Leading AI for media and entertainment data intelligence | AI-powered "Cognitive" platform used by global broadcasters to search and analyze video audio at scale'),
    t('thinkon-ai', freeTier:'Institutional only', price:0, tips:'Leading enterprise platform for data-driven decisions | AI-powered "Insight" engine used by corporate leaders to find trends in massive data silos'),
    t('wanderlog-ai-pro', freeTier:'Free basic access', price:0, tips:'The ultimate travel research companion | AI-powered "Discovery" finds hidden gems and restaurant data traditional guides miss based on your specific trip'),
    t('patent-pal-ai', freeTier:'Free draft trial', price:99, priceTier:'Pro monthly', tips:'The smartest choice for IP professionals | AI-powered "FIG" generation handles your entire patent data visualization and mapping automatically'),
    t('kira-ai-pro', freeTier:'Institutional only', price:0, tips:'Professional legal intelligence suite | Featuring high-end "Anomaly" detection in complex corporate contracts using deep research data and history'),
    t('klarity-pro', freeTier:'Institutional only', price:0, tips:'The "Safety First" tool for finance heads | AI-powered "Compliance" and "Audit" automation saves thousands of hours on repetitive data tasks'),
    t('think-on-ai-pro', freeTier:'Institutional only', price:0, tips:'Next-gen corporate strategy platform | AI-powered "Market" insights driven by millions of user data points and behavioral research'),
    t('wanderlog-pro', freeTier:'Free trial available', price:0, tips:'The expert choice for group travel | AI-powered "Collaborative" planning handles thousands of data points for your entire team simultaneously'),
    t('patentpal-pro', freeTier:'Free trial available', price:99, priceTier:'Pro monthly', tips:'High-end IP orchestration suite | AI-powered "Project" management handles thousands of legal data tasks across your entire patent team'),
    t('kira-intelligence', freeTier:'Institutional only', price:0, tips:'The choices of global law firms | AI-powered "Skill Match" handles your entire technical assessment and data discovery data cycle'),
    t('notabot-ai', freeTier:'Free forever basic access', price:0, tips:'The smarter way to build legal docs | AI-powered "Drafting" and "Editing" used by top law firms globally for high-accuracy research'),
    t('think-on', freeTier:'Institutional only', price:0, tips:'The "SAP" for corporate intelligence | Features incredible "Data Visualization" of your global business trends and data forecasting'),
    t('wanderlog-app', freeTier:'Free forever (Web/App)', price:0, tips:'The "Power-user" of holiday planning | AI-powered "Distance" and "Time" optimization uses million of successful trip data for better travel'),
    t('patent-pal', freeTier:'Free trial available', price:99, priceTier:'Basic monthly', tips:'The ultimate patent assistant | AI-powered "Description" generation handles your entire document data discovery flow'),
    t('klarity', freeTier:'Institutional only', price:0, tips:'The industry standard for high-end accounting AI | Features world-class "Revenue" data validation used by top tech companies globally'),
    t('notabot-pro', freeTier:'Free research trial', price:0, tips:'High-end legal research assistant | AI-powered "Case Search" finds info in volumes as easily as searching on Google with deep data reasoning'),
    t('thinkon-pro', freeTier:'Institutional only', price:0, tips:'Professional enterprise intelligence suite | AI-powered "Recommendation" engine driven by millions of corporate data points at scale'),
    t('wanderlog-ai', freeTier:'Free basic account', price:0, tips:'The future of travel planning | AI-powered "Itinerary" and "Budget" management handled automatically based on your specific traveler data'),
    t('kira-ai-reviews', freeTier:'Institutional only', price:0, tips:'The master of contract intelligence | AI-powered "Insight" reports handles your legal image and data presence across global firms'),
    t('thinkon-intelligence', freeTier:'Institutional only', price:0, tips:'The expert choice for modern enterprise | AI-powered "Alerting" and "Insight" driven by millions of corporate data points globally'),
    t('patentpal-ai-pro', freeTier:'Free draft trial', price:99, priceTier:'Pro monthly', tips:'The choice of top IP attorneys | AI-powered "Automation" handles thousands of patent data docs simultaneously for your firm'),
    t('wander-log-pro', freeTier:'Free trial available', price:0, tips:'Leading platform for high-end "Travel Storytelling" | AI-powered "Media" analysis handles thousands of trip photos and videos for social data'),
    t('kira', freeTier:'Institutional only', price:0, tips:'The pioneer of high-end contract AI | Best for turning any legal recording into a professional performance for gaming, film, and media data'),
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
