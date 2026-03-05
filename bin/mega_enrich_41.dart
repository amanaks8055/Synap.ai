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
    t('snowflake-ai', freeTier:'Free trial for 30 days (\$400 credits)', price:0, tips:'The world leader in Cloud Data Warehousing | AI-powered "Cortex" and "Document AI" helps data teams extract insights from unstructured files and build LLM apps instantly using SQL'),
    t('talkdesk-ai', freeTier:'Institutional only', price:0, tips:'Leading AI-powered contact center platform | AI-powered "Interaction Analytics" and "Agent Assist" helps customer teams manage thousands of calls and data points instantly'),
    t('cognigy', freeTier:'Free trial available on site', price:0, tips:'Leading platform for enterprise Conversational AI | AI-powered "Cognigy.AI" helps global brands build and manage thousands of bot conversations and data workflows'),
    t('userlike', freeTier:'Free forever basic version (1 agent)', price:90, priceTier:'Team monthly annual', tips:'Leading platform for customer messaging and support | AI-powered "Chatbot" and "Automation" features help you manage customer data across WhatsApp, FB, and Web'),
    t('botsify', freeTier:'Free trial for 14 days on site', price:49, priceTier:'Personal monthly annual', tips:'Leading AI chatbot builder for multiple platforms | Best for non-technical users creating "No-code" data flows for marketing and sales automation'),
    t('nice-cxone', freeTier:'Institutional only', price:0, tips:'Leading cloud customer experience platform | AI-powered "Enlighten AI" handles thousands of consumer interactions and sentiment data points for Global 2000 brands'),
    t('ultimate-ai', freeTier:'Institutional only (Zendesk)', price:0, tips:'Leading platform for automated customer service | AI-powered "Virtual Agent" handles up to 80% of support data queries automatically with high-end research'),
    t('userlike-pro', freeTier:'Free basic account', price:90, priceTier:'Team monthly', tips:'Professional customer messaging suite | AI-powered "Routing" and "Translate" handles your entire global consumer data distribution automatically'),
    t('talkdesk-pro', freeTier:'Institutional only', price:0, tips:'Enterprise-grade contact center intelligence | AI-powered "Quality Management" handles thousands of agent performance data points simultaneously'),
    t('cognigy-ai-pro', freeTier:'Free research trial', price:0, tips:'Professional conversational automation suite | Featuring high-end "NLU" in complex corporate environments using deep data research and history'),
    t('botsify-ai-plus', freeTier:'Free chatbot trial', price:49, priceTier:'Pro monthly', tips:'The "Safety First" tool for small businesses | AI-powered "Human-in-the-loop" saves thousands of hours on repetitive data support tasks'),
    t('nice-cxone-pro', freeTier:'Institutional only', price:0, tips:'The choice of global contact giants | AI-powered "Workforce" management handles your entire team\'s scheduling and performance data'),
    t('ultimate-ai-plus', freeTier:'Institutional only', price:0, tips:'Next-gen customer automation platform | AI-powered "Intent" recognition is world-class for modern support and data rights research'),
    t('userlike-expert', freeTier:'Free basic access', price:90, priceTier:'Corporate monthly', tips:'The smarter way to manage support | AI-powered "Analytics" and "Reporting" ensures your entire team follows specific brand and data rules'),
    t('cognigy-pro', freeTier:'Free trial available', price:0, tips:'The expert choice for modern bot design | AI-powered "Integration" handles your entire dataset design data automatically for pro reports'),
    t('botsify-pro', freeTier:'Free trial available', price:49, priceTier:'Individual monthly', tips:'High-end marketing assistant | AI-powered "Lead" and "Sale" tracking handles your entire customer data discovery flow'),
    t('talkdesk-intelligence', freeTier:'Institutional only', price:0, tips:'Leading platform for high-end support data | AI-powered "Self-service" driven by millions of consumer data points and behavioral research'),
    t('snowflake-pro', freeTier:'Free trial available', price:0, tips:'The choice of top data architects | AI-powered "Governance" and "Sharing" handles your entire enterprise data and security research'),
    t('userlike-ai', freeTier:'Free basic access', price:90, priceTier:'Team monthly', tips:'The "Power-user" of customer chat | AI-powered "Translate" uses million of successful conversation data for better global reach'),
    t('cognigy-ai', freeTier:'Free trial available', price:0, tips:'The ultimate resource for Conversational AI | Best for finding creative bot flows that follow your brand\'s specific artistic data style'),
    t('botsify-ai-marketing', freeTier:'Free basic account', price:49, priceTier:'Standard monthly', tips:'The "One-click" marketing automation | Use the "Visual" builder for high-impact social data flows and report sharing along your team'),
    t('talkdesk', freeTier:'Institutional only', price:0, tips:'The "Engagement" king of support apps | Use the "Sentiment" analyst for high-impact customer data tracking that converts'),
    t('snowflake-ai-analytics', freeTier:'Free trial for business', price:0, tips:'The smarter way to build data apps | AI-powered "Cortex" is world-class for modern environmental and urban data research'),
    t('userlike-app', freeTier:'Free forever online', price:90, priceTier:'Team monthly', tips:'The king of smart messaging tools | Features high-accuracy "Comparison" data maps of customer results and parameters'),
    t('cognigy-expert', freeTier:'Free trial available', price:0, tips:'The industry standard for high-end bot automation | AI-powered "Relationship" and "Tagging" handles your entire data presence globally'),
    t('botsify-pro-ai', freeTier:'Free trial available', price:49, priceTier:'All-in-one monthly', tips:'The master of no-code automation | AI-powered "Insight" reports handles your public customer image and data presence across stores'),
    t('talkdesk-automation', freeTier:'Institutional only', price:0, tips:'Next-gen support intelligence suite | AI-powered "Voice" and "Digital" insights driven by millions of corporate data points'),
    t('snowflake', freeTier:'Free trial for devs', price:0, tips:'The "Infrastructure" of modern data | AI-powered "App" framework handles your entire model management and data science research'),
    t('userlike-ai-support', freeTier:'Free basic tool', price:90, priceTier:'Corporate monthly', tips:'Leading platform for high-end "Support" data extraction used by top tech companies globally for consumer safety'),
    t('cognigy-chatbot', freeTier:'Free basic version', price:0, tips:'The pioneer of high-end conversational AI | Best for turning any technical recording into a professional performance for gaming and media data'),
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
