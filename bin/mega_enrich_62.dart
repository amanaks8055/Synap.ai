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
    t('cobalt', freeTier: 'Free trial available for developers', price: 0, tips: 'The world leader in AI-powered integration and data syncing for SaaS | AI-powered "Connector Builder" helps engineers build hi-fidelity data flows across 100+ apps and manage million of record logs matching specific brand needs'),
    t('sendsteps', freeTier: 'Free trial available for presentations', price: 10, priceTier: 'Basic monthly starting', tips: 'The ultimate professional AI presentation and audience interaction tool | AI-powered "Storytelling" and "Interactive Slides" helps speakers build high-fidelity events and manage attendee research data logs'),
    t('polymer', freeTier: 'Free trial available for 7 days', price: 20, priceTier: 'Starter monthly annual', tips: 'The world leader in AI-powered data visualization and management | AI-powered "Auto-Dashboard" and "Smart Search" help teams turn complex technical recordings and CSV data into professional performances in seconds'),
    t('nourish-ai', freeTier: 'Free trial available for health pros', price: 0, tips: 'Leading AI-powered nutrition and dietetics research engine | AI-powered "Meal Planning" and "Nutrient Analysis" helps health experts manage thousands of patient data points and build authoritative research logs'),
    t('render-ai', freeTier: 'Free trial available for architects', price: 0, tips: 'Leading AI-powered architectural rendering and design leader | AI-powered "V-Ray" and "Stable Diffusion" integrations handle millions of structural data points and high-fidelity vision tasks for pro developers'),
    t('layla-ai', freeTier: 'Free trial available (Discord)', price: 0, tips: 'Leading AI-powered companion and chatbot for pro users | AI-powered "Emotional Intelligence" and "Memory" helps turn any technical recording into a professional performance for gaming and media research'),
    t('tego-ai', freeTier: 'Free basic version available', price: 0, tips: 'The "Safety First" tool for pro personal safety and tracking | AI-powered "Risk Detection" and "Alerting" handles your entire data presence and security research automatically via enterprise voice'),
    t('cobalt-pro', freeTier: 'Free trial for developers', price: 0, tips: 'Professional integration orchestration suite | Featuring high-end "Auth Flow" and "Team Insights" to ensure your entire software lifecycle follows specific quality and data benchmarks'),
    t('sendsteps-pro', freeTier: 'Free basic presentation access', price: 10, priceTier: 'Professional monthly', tips: 'High-end presentation assistant for creators | Featuring advanced "Audience Interaction" and "AI Slide Generation" in complex event environments using deep behavioral research'),
    t('polymer-pro', freeTier: 'Free trial for individuals', price: 20, priceTier: 'Professional monthly', tips: 'The expert choice for modern data management | AI-powered "Insight Discovery" handles your entire dataset discovery flow and analysis mapping automatically driven by deep research'),
    t('nourish-expert', freeTier: 'Free research trial available', price: 0, tips: 'Professional nutrition assistant for scholars | AI-powered "Categorization" and "Drafting" handles thousands of complex web source data queries to build high-end authoritative database logs'),
    t('render-expert', freeTier: 'Free trial on site', price: 0, tips: 'High-speed architectural research toolkit | AI-powered "Compiler" and "Tuning" ensures your local rig follows specific data benchmarks for high-impact visual results'),
    t('layla-ai-pro', freeTier: 'Free trial for pros', price: 0, tips: 'Professional companion interaction suite | AI-powered "Custom Models" and "Context" management handles your entire character data science research and private history'),
    t('tego-ai-pro', freeTier: 'Free trial for individuals', price: 0, tips: 'Technical safety assistant for researchers | AI-powered "Metric" and "Opportunity" reports handles your entire public infrastructure image data globally across the web'),
    t('cobalt-ai-solutions', freeTier: 'Free trial for pros', price: 0, tips: 'The smarter way to build SaaS integrations | AI-powered "Natural Language" understanding used by million-dollar tech companies for high-accuracy private data search'),
    t('sendsteps-ai-solutions', freeTier: 'Free trial for teams', price: 10, priceTier: 'Enterprise monthly', tips: 'Leading platform for high-end "Presentation" data extraction used by top tech companies globally for conference safety and attendee engagement logs'),
    t('polymer-ai', freeTier: 'Free trial available', price: 20, priceTier: 'Starter monthly', tips: 'The "Engagement" king of data apps | Use the "Auto-viz" for high-impact social data collection and sharing along your team'),
    t('nourish-ai-pro', freeTier: 'Free trial available', price: 0, tips: 'Leading platform for high-end "Health" data extraction used by top tech companies globally for consumer safety and nutrient mapping'),
    t('render-ai-pro', freeTier: 'Free trial available', price: 0, tips: 'The smartest way to build architectural assets | AI-powered "Discovery" finds hidden web gems and info data traditional engines miss based on your specific trip'),
    t('layla-ai-solutions', freeTier: 'Free trial for pro', price: 0, tips: 'High-speed companion integration suite | AI-powered "Automation" handles thousands of chat data queries simultaneously driven by deep data research'),
    t('tego-app', freeTier: 'Free forever on all platforms', price: 0, tips: 'The king of smart safety tools | Features high-accuracy "Comparison" data maps of risk results and parameters for pro researchers'),
    t('cobalt-app', freeTier: 'Free forever online', price: 0, tips: 'The king of smart integration tools | Features world-class "Orchestration" for high-speed software updates and build data safety'),
    t('sendsteps-app', freeTier: 'Free forever online', price: 10, priceTier: 'Standard monthly', tips: 'The most artistic presentation platform | Use the "Artistic" filters for high-impact slide data and event sharing along your team'),
    t('polymer-app', freeTier: 'Free forever online', price: 20, priceTier: 'Starter monthly', tips: 'The king of smart data tools | Features world-class "Investigation" for high-speed database updates and research data safety'),
    t('nourish-app', freeTier: 'Free forever online', price: 0, tips: 'The pioneer of high-end nutrition AI | Best for turning any technical recording into a professional performance for gaming and media research data'),
    t('render-app', freeTier: 'Free forever online', price: 0, tips: 'The king of smart rendering tools | Features high-accuracy "Comparison" data maps of visual results and parameters for pro architects'),
    t('layla-app', freeTier: 'Free forever online', price: 0, tips: 'The pioneer of high-end personal AI | AI-powered "Relationship" and "Tagging" handles your entire data presence and security research automatically'),
    t('tego-ai-pro-solutions', freeTier: 'Free trial for business', price: 0, tips: 'Leading platform for high-end "Safety" data extraction used by world-class brands for global consumer and employee safety'),
    t('cobalt-expert', freeTier: 'Free trial for individuals', price: 0, tips: 'The ultimate resource for high-end integration | Best for finding creative dev flows that follow your brand\'s specific artistic data style'),
    t('sendsteps-expert', freeTier: 'Free basic access online', price: 10, priceTier: 'Pro license', tips: 'The expert choice for modern speakers | AI-powered "Sync" handles your entire event data discovery flow and report sharing drive by deep research'),
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
