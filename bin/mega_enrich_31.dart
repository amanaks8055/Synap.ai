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
    t('cody-ai', freeTier:'Free forever for individual developers', price:9, priceTier:'Pro monthly annual', tips:'Sourcegraph\'s official AI coding assistant | Features world-class "Knowledge Graph" that understands your entire codebase and external data docs instantly'),
    t('ai-dungeon', freeTier:'Free forever basic version (Ad-supported)', price:10, priceTier:'Adventurer monthly annual', tips:'The pioneer of AI-generated roleplay | AI-powered "Unlimited Storytelling" where your choices drive a unique and infinite data world for gamers'),
    t('exabeam-ai', freeTier:'Institutional only', price:0, tips:'Leading AI-driven Security Operations (SIEM) | AI-powered "Threat Hunter" used by global enterprises to detect and stop cyber attacks using behavioral data'),
    t('cylance-ai', freeTier:'Institutional only (BlackBerry)', price:0, tips:'The gold standard for AI-based antivirus and security | Best for preventing malware execution through deep predictive ML models and device data logs'),
    t('fiddler-ai', freeTier:'Institutional only', price:0, tips:'Leading platform for AI Observability and Model Monitoring | AI-powered "Explainability" helps data scientists debug and trust their LLMs and ML data'),
    t('domo-ai', freeTier:'Free trial available on site', price:0, tips:'Leading business intelligence platform with deep AI | AI-powered "Assistant" handles thousands of complex data queries and dashboard generation instantly'),
    t('perception-point', freeTier:'Institutional only', price:0, tips:'Leading AI for advanced threat protection | Best for detecting phishing and malware in emails and cloud apps using real-time behavioral data'),
    t('private-ai', freeTier:'Free trial for 20 documents', price:0, tips:'Leading platform for automated data de-identification | AI-powered "PII Discovery" finds and masks sensitive info in 50+ languages automatically'),
    t('acrolinx', freeTier:'Institutional only', price:0, tips:'Leading platform for building brand-consistent content at scale | AI-powered "Strategy" engine ensures every word follows your enterprise data guidelines'),
    t('latitude-ai-pro', freeTier:'Free basic access', price:10, priceTier:'Pro monthly', tips:'The "Safety First" tool for gamers and writers | AI-powered "Model Switch" lets you use GPT-4 or Claude for your private data stories'),
    t('cody-sourcegraph', freeTier:'Free individual access', price:9, priceTier:'Pro monthly', tips:'The smartest coding assistant for large teams | AI-powered "Context" engine handles thousands of files in your repo for accurate code results'),
    t('ai-dungeon-pro', freeTier:'Free basic play', price:10, priceTier:'Adventurer monthly', tips:'The ultimate creative writing playground | Features world-class "Memory" and "Character" tracking for deep and consistent data storytelling'),
    t('exabeam-pro', freeTier:'Institutional only', price:0, tips:'Enterprise-grade security intelligence suite | AI-powered "Automation" handles thousands of security alerts simultaneously driven by deep data research'),
    t('cylance-pro', freeTier:'Institutional only', price:0, tips:'The elite choice for endpoint protection | Featuring high-end "Zero Trust" data security driven by 10+ years of malware research data'),
    t('fiddler-ai-pro', freeTier:'Institutional only', price:0, tips:'The "MRI" for your AI models | AI-powered "Bias" and "Drift" detection ensure your production algorithms follow ethical data standards'),
    t('domo-ai-analytics', freeTier:'Free trial available', price:0, tips:'The "Command Center" for corporate leaders | AI-powered "Data Apps" turn raw info into actionable business insights instantly and securely'),
    t('perception-point-ai', freeTier:'Institutional only', price:0, tips:'Leading platform for high-end email security | AI-powered "Recursive Unpacking" finds hidden threats in complex data files automatically'),
    t('private-ai-engine', freeTier:'Free API credits', price:0, tips:'The best way to protect user privacy in LLMs | Features world-class "Redaction" of sensitive data points for secure internal AI apps'),
    t('acrolinx-ai-pro', freeTier:'Institutional only', price:0, tips:'The "Standard" for high-end corporate writing | AI-powered "Checking" ensures every technical doc follows your specific brand and data rules'),
    t('cody-ai-pro', freeTier:'Free basic extension', price:9, priceTier:'Individual monthly', tips:'The developer productivity master | AI-powered "Unit Test" and "Doc" generation saves hundreds of hours for pro data engineering teams'),
    t('ai-dungeon-unlimited', freeTier:'Free trial available', price:10, priceTier:'Subscription monthly', tips:'The king of interactive fiction | AI-powered "Multimodal" support allows you to see images of your generated data worlds instantly'),
    t('exabeam-security', freeTier:'Institutional only', price:0, tips:'The industry leader in user behavior analysis | AI-powered "Risk Scoring" finds malicious insiders and compromised data accounts automatically'),
    t('cylance-ai-security', freeTier:'Institutional only', price:0, tips:'Next-gen cyber defense platform | AI-powered "Cloud" and "Mobile" protection handles your entire enterprise data surface area'),
    t('fiddler-ai-monitor', freeTier:'Institutional only', price:0, tips:'The choice of top data scientists | AI-powered "Alerting" handles thousands of production data streams for model health and quality'),
    t('domo-pro', freeTier:'Free trial available', price:0, tips:'The expert choice for business intelligence | AI-powered "Alerts" and "Insight" driven by millions of corporate data points'),
    t('perception-pro', freeTier:'Institutional only', price:0, tips:'The smarter way to protect your brand | AI-powered "Anti-Phishing" is world-class for modern web and SaaS data threats'),
    t('private-ai-pro', freeTier:'Free trial available', price:0, tips:'The ultimate data privacy toolkit | AI-powered "Compliance" for GDPR and HIPAA handles your entire corporate data redaction'),
    t('acrolinx-pro', freeTier:'Institutional only', price:0, tips:'The choice of global content giants | AI-powered "Governance" handles thousands of writers and millions of data points across your team'),
    t('cody', freeTier:'Free individual access', price:9, priceTier:'Individual monthly', tips:'The smartest AI for your IDE | Use the "Custom" prompts to build tailored coding assistants for your specific project data'),
    t('ai-dungeon-adventurer', freeTier:'Free basic version', price:10, priceTier:'Monthly membership', tips:'The leading platform for high-end AI roleplay | AI-powered "Scenario" generation used by millions of creative data explorers'),
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
