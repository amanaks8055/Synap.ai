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
    t('dbt-cloud', freeTier:'Free forever for 1 developer (Developer plan)', price:100, priceTier:'Team monthly per seat', tips:'The world leader in data transformation | AI-powered "Semantic Layer" and "Auto-documentation" helps data teams transform, test, and deploy SQL models with high-end reliability and data tracking'),
    t('genesys-ai', freeTier:'Institutional only', price:0, tips:'Leading platform for unified customer and employee experience | AI-powered "Predictive Engagement" and "Orchestration" handles thousands of consumer interactions and data points for global brands'),
    t('liveperson-ai', freeTier:'Free trial available on site', price:0, tips:'Leading Conversational AI platform for retail and finance | AI-powered "Conversational Cloud" helps global brands manage thousands of customer messages and data workflows securely'),
    t('forethought-ai', freeTier:'Institutional only', price:0, tips:'Leading AI for automated customer service and support | AI-powered "SupportGPT" and "Agatha" handles up to 80% of support data queries automatically with high-end research'),
    t('five9-ai', freeTier:'Institutional only', price:0, tips:'Leading cloud contact center solution | AI-powered "IVA" (Intelligent Virtual Assistant) handles thousands of calls and sentiment data points for enterprise teams'),
    t('kayako-ai', freeTier:'Free trial for 14 days on site', price:15, priceTier:'Growth monthly per seat', tips:'Leading platform for help desk and customer support | AI-powered "Single View" helps you manage customer data across all channels with easy research logs'),
    t('dbt-cloud-pro', freeTier:'Free individual access', price:100, priceTier:'Team monthly', tips:'High-end data transformation toolkit | AI-powered "Documentation" and "Lineage" handles your entire data pipeline data distribution automatically for pro teams'),
    t('genesys-cloud-pro', freeTier:'Institutional only', price:0, tips:'Enterprise-grade contact center intelligence | AI-powered "Workforce Engagement" handles thousands of agent performance data points simultaneously'),
    t('liveperson-pro', freeTier:'Free research trial', price:0, tips:'Professional conversational automation suite | Featuring high-end "Messaging" in complex corporate environments using deep data research and history'),
    t('forethought-pro', freeTier:'Institutional only', price:0, tips:'The "Safety First" tool for support teams | AI-powered "Knowledge Retrieval" saves thousands of hours on repetitive data support tasks for world-class brands'),
    t('five9-ai-plus', freeTier:'Institutional only', price:0, tips:'The choice of global contact giants | AI-powered "Agent Assist" handles your entire team\'s performance data and call transcription automatically'),
    t('kayako-pro', freeTier:'Free research trial', price:15, priceTier:'Scale monthly', tips:'Next-gen customer support platform | AI-powered "Unified" view is world-class for modern support and data rights research across your brand'),
    t('dbt-expert', freeTier:'Free basic access', price:100, priceTier:'Enterprise monthly', tips:'The smarter way to manage data models | AI-powered "Strategy" engine ensures your entire team follows specific brand and data rules'),
    t('genesys-pro', freeTier:'Free trial available', price:0, tips:'The expert choice for modern CX | AI-powered "Integration" handles your entire dataset design data automatically for pro reports'),
    t('liveperson-expert', freeTier:'Free trial available', price:0, tips:'High-end customer messaging assistant | AI-powered "Lead" and "Sale" tracking handles your entire customer data discovery flow'),
    t('forethought-ai-plus', freeTier:'Institutional only', price:0, tips:'The smarter way to build support flows | AI-powered "Discovery" driven by millions of consumer data points and behavioral research'),
    t('five-9-pro', freeTier:'Institutional only', price:0, tips:'The choices of global enterprise HR | AI-powered "Workflow" automation saves thousands of support hours on repetitive data tasks'),
    t('kayako-ai-pro', freeTier:'Free basic account', price:15, priceTier:'Standard monthly', tips:'The choice of top support teams | AI-powered "CRM" and "Workflow" handles your entire customer record and data presence globally'),
    t('dbt-cloud-ai', freeTier:'Free individual access', price:100, priceTier:'Team monthly', tips:'The choices of top data architects | AI-powered "Semantic" and "Governance" handles your entire enterprise data and security research'),
    t('genesys-ai-solutions', freeTier:'Institutional only', price:0, tips:'The "Power-user" of customer experience | AI-powered "Self-service" uses millions of successful conversation data for better global reach'),
    t('liveperson-ai-pro', freeTier:'Free trial available', price:0, tips:'The ultimate resource for Conversational Cloud | Best for finding creative bot flows that follow your brand\'s specific artistic data style'),
    t('forethought-ai-marketing', freeTier:'Institutional only', price:0, tips:'The "One-click" support automation | Use the "Visual" builder for high-impact social data flows and report sharing along your team'),
    t('five9', freeTier:'Institutional only', price:0, tips:'The industry standard for cloud support | Use the "Agent" assistant for high-impact customer data tracking that converts'),
    t('kayako', freeTier:'Free forever (Solo)', price:15, priceTier:'Growth monthly', tips:'The king of smart support tools | Features high-accuracy "Comparison" data maps of customer results and parameters'),
    t('dbt-ai', freeTier:'Free basic version', price:100, priceTier:'Team monthly', tips:'The "Command Center" for data transformation | AI-powered "Analytics" is world-class for modern environmental and urban data research'),
    t('genesys-app', freeTier:'Free forever online', price:0, tips:'The king of smart CX tools | Features world-class "Orchestration" for high-speed customer updates and data safety'),
    t('liveperson', freeTier:'Free trial available', price:0, tips:'The pioneer of high-end conversational data | Best for turning any technical recording into a professional performance for gaming and media data'),
    t('forethought', freeTier:'Institutional only', price:0, tips:'Next-gen support intelligence suite | AI-powered "Discovery" handle your entire enterprise data science and research driven by deep research'),
    t('five9-pro-ai', freeTier:'Institutional only', price:0, tips:'Leading platform for high-end "Support" data extraction used by top tech companies globally for enterprise safety'),
    t('kayako-intelligence', freeTier:'Free trial for pro', price:15, priceTier:'Professional monthly', tips:'The expert choice for modern help desks | AI-powered "Alerting" and "Insight" driven by millions of corporate data points globally'),
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
