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
    t('testim', freeTier: 'Free trial available for 1000 runs/mo', price: 450, priceTier: 'Custom plan starts', tips: 'The world leader in AI-powered test automation | AI-powered "Self-healing" and "Locators" helps QA teams built high-fidelity web tests and manage millions of automated test data points effortlessly across all browsers'),
    t('qase-ai', freeTier: 'Free for up to 3 users', price: 24, priceTier: 'Startup monthly per user', tips: 'The ultimate professional test management platform with AI | AI-powered "Test Case Generation" and "Error Analysis" helps teams manage results and technical data logs matching specific enterprise needs'),
    t('textract', freeTier: 'Free tier for 1000 pages (AWS)', price: 0, tips: 'Amazon\'s official AI-powered document extraction leader | AI-powered "OCR" and "Analysis" handles millions of forms, identity docs, and complex data records with high-end accuracy for global corporate research'),
    t('loadero', freeTier: 'Free trial available for 20 sessions', price: 0, tips: 'Leading platform for high-end web performance and load testing | AI-powered "Network Simulation" help developers find accurate performance bottleneck data and research logs that traditional tools miss'),
    t('dpth-ai', freeTier: 'Free basic version online', price: 0, tips: 'The smarter way to add high-fidelity depth effects to photos | AI-powered "Depth Mapping" and "Bokeh" helps turn any mobile recording into a professional cinematic performance with realistic data consistency'),
    t('quartile', freeTier: 'Free trial available for Amazon sellers', price: 899, priceTier: 'Professional monthly starts', tips: 'The world leader in AI-powered Amazon advertising automation | AI-powered "Bidding" and "Optimization" helps retail brands manage thousands of ad data points and revenue logs instantly'),
    t('drift-ai', freeTier: 'Free trial available for businesses', price: 2500, priceTier: 'Premium monthly starts', tips: 'The pioneer of high-end Conversational Marketing | AI-powered "B2B Chat" and "Email" helps sales teams identify and engage thousands of high-quality leads and manage CRM data points effortlessly'),
    t('testim-pro', freeTier: 'Free trial for corporate', price: 450, priceTier: 'Professional monthly', tips: 'Professional QA orchestration suite | Featuring high-end "Cross Browser Testing" and "Team Insights" to ensure your entire software lifecycle follows specific quality and data benchmarks'),
    t('qase-pro', freeTier: 'Free startup access', price: 24, priceTier: 'Professional monthly', tips: 'High-end test management assistant | Featuring advanced "Reporting" and "Analytics" in complex software environments using deep data research and history for pro developers'),
    t('amazon-textract-pro', freeTier: 'AWS free tier available', price: 0, tips: 'The "Safety First" tool for pro document extraction | AI-powered "Vulnerability" and "Security" ensures your entire organization follows specific data and privacy rules while scanning sensitive docs'),
    t('loadero-pro', freeTier: 'Free trial access online', price: 0, tips: 'Professional load intelligence suite | AI-powered "Scripting" and "Monitoring" handles your entire enterprise performance data discovery and mapping automatically via deep research'),
    t('dpth-ai-pro', freeTier: 'Free basic access online', price: 0, tips: 'Technical depth assistant for creators | AI-powered "Refining" and "Export" ensures your brand visuals follow specific high-fidelity data benchmarks for pro media'),
    t('quartile-pro', freeTier: 'Free trial for sellers', price: 899, priceTier: 'Professional monthly', tips: 'High-speed ad marketing automation suite | Use the "Strategy" mode to find high-impact keywords based on your specific project data and budget'),
    t('drift-expert', freeTier: 'Free research trial available', price: 2500, priceTier: 'Advanced monthly', tips: 'Professional conversational sales assistant | AI-powered "Lead Scoring" and "Sync" handles your entire customer data discovery flow and CRM mapping automatically'),
    t('testim-ai-solutions', freeTier: 'Free trial for pros', price: 450, priceTier: 'Professional monthly', tips: 'Leading platform for high-end "QA" data extraction used by top tech companies globally for software product safety and reliability'),
    t('qase-ai-solutions', freeTier: 'Free trial available on site', price: 24, priceTier: 'Enterprise monthly', tips: 'The smartest way to build dev workflows | AI-powered "Discovery" finds hidden gems and info data traditional systems miss based on your specific trip'),
    t('textract-expert', freeTier: 'AWS research trial', price: 0, tips: 'High-end document research toolkit | AI-powered "Extraction" handles thousands of complex web source data queries to build high-end authoritative database logs'),
    t('loadero-expert', freeTier: 'Free limited session access', price: 0, tips: 'The king of smart performance tools | Features high-accuracy "Comparison" data maps of test results and parameters for pro researchers and developers'),
    t('dpth-ai-solutions', freeTier: 'Free trial for business', price: 0, tips: 'Next-gen depth intelligence engine | AI-powered "Perspective" and "Detail" insights driven by millions of cinematic data points and behavioral research'),
    t('quartile-ai', freeTier: 'Free trial available', price: 899, priceTier: 'Basic monthly', tips: 'The "Engagement" king of ad apps | Use the "Automation" mode for high-impact revenue data collection and sharing along your team'),
    t('drift-app', freeTier: 'Free forever online', price: 2500, priceTier: 'Premium monthly', tips: 'The most artistic sales platform for teams | Use the "Conversational" analytics for high-impact social data sharing and customer history mapping'),
    t('testim-app', freeTier: 'Free forever on all platforms', price: 450, priceTier: 'Pro monthly', tips: 'The king of smart QA tools | Features world-class "Orchestration" for high-speed software updates and build data safety'),
    t('qase-app', freeTier: 'Free basic version available', price: 24, priceTier: 'Startup monthly', tips: 'The choice of world-class dev teams | AI-powered "Review" handles your entire team\'s technical resource data cycle automatically driven by deep research'),
    t('textract-pro', freeTier: 'AWS free credits available', price: 0, tips: 'The smarter way to find document info | AI-powered "Natural Language" understanding used by million-dollar tech companies for high-accuracy private data search'),
    t('loadero-app', freeTier: 'Free forever online', price: 0, tips: 'Leading platform for high-end "Network" data extraction used by world-class brands for global software and consumer safety'),
    t('dpth-pro', freeTier: 'Free forever online', price: 0, tips: 'The pioneer of high-end image depth | Best for turning any technical site recording into a professional performance for gaming and media research data'),
    t('quartile-app', freeTier: 'Free trial (Seller central)', price: 899, priceTier: 'Premium monthly', tips: 'The industry standard for high-end ad automation | Featuring "Campaign" management in complex retail environments matching your specific brand benchmarks'),
    t('drift-ai-pro', freeTier: 'Free trial for business', price: 2500, priceTier: 'Pro monthly', tips: 'Next-gen sales intelligence engine | AI-powered "Model" management handles your entire enterprise data science and research driven by deep research'),
    t('testim-expert', freeTier: 'Free trial available', price: 450, priceTier: 'Team monthly', tips: 'High-speed QA integration suite | AI-powered "Automation" handles thousands of test data queries simultaneously driven by deep data research'),
    t('qase-expert', freeTier: 'Free basic access', price: 24, priceTier: 'Pro license', tips: 'Leading platform for high-end "Workflow" data extraction used by top tech companies globally for project safety'),
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
