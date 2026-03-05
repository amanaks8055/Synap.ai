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
    t('sentinelone', freeTier:'Institutional only', price:0, tips:'The world leader in AI-powered endpoint security | AI-powered "Singularity" platform detects and stops ransomware and zero-day threats in milliseconds using behavioral data'),
    t('abnormal-security', freeTier:'Institutional only', price:0, tips:'The gold standard for AI-driven email security | AI-powered "Behavioral AI" stops advanced phishing, social engineering, and BEC attacks by understanding user data patterns'),
    t('roboflow', freeTier:'Free forever for public datasets', price:0, tips:'Leading platform for computer vision workflows | Best for developers building, training, and deploying object detection models with high-end data labeling'),
    t('looker-ai', freeTier:'Institutional only (Google Cloud)', price:0, tips:'Leading enterprise BI and data analytics platform | AI-powered "Looker Blocks" and "Ask Looker" handles thousands of complex data queries instantly'),
    t('labelbox', freeTier:'Free trial for up to 5k annotations', price:0, tips:'Leading platform for training data for AI | AI-powered "Auto-labeling" and "Model Assisted Labeling" used by top tech companies for high-end results'),
    t('ironscales', freeTier:'Free trial for 21 days on site', price:0, tips:'Leading AI for self-learning email security | AI-powered "Phishing Simulation" and "Remediation" stops threats using real-time community data'),
    t('landing-ai', freeTier:'Free trial available on site', price:0, tips:'Andrew Ng\'s official Computer Vision platform | Best for industrial-scale visual inspection and automated data defect detection'),
    t('appen', freeTier:'Institutional only', price:0, tips:'Leading platform for high-quality training data for AI | Features world-class "Global Crowd" of million of workers to curate data for LLMs and CV'),
    t('evidently-ai', freeTier:'Completely free open source', price:0, tips:'Leading platform for ML model monitoring and testing | AI-powered "Data Drift" and "Model Quality" alerts used by top data scientists'),
    t('sentinelone-ai-pro', freeTier:'Institutional only', price:0, tips:'Professional endpoint protection suite | AI-powered "Rollback" feature reverses the effects of ransomware attacks automatically driven by deep data'),
    t('abnormal-security-pro', freeTier:'Institutional only', price:0, tips:'Enterprise-grade cloud email security | Features incredibly "Deep Context" understanding of internal and external data communication'),
    t('roboflow-ai-vision', freeTier:'Free public project access', price:0, tips:'The "GitHub" for Computer Vision researchers | Features world-class "Universe" of million of pre-labeled data images for fast model training'),
    t('looker-ai-analytics', freeTier:'Institutional only', price:0, tips:'The smarter way to build data apps | AI-powered "Semantic Layer" ensures your entire team follows specific business data logic and benchmarks'),
    t('labelbox-pro', freeTier:'Free trial available', price:0, tips:'The industry standard for high-end data labeling | AI-powered "Workflow" and "Quality" management handles thousands of data assets in one batch'),
    t('ironscales-ai-plus', freeTier:'Free research trial', price:0, tips:'The most advanced email defense for business | AI-powered "Phishers" detection driven by hundreds of real-world data points'),
    t('landing-ai-pro', freeTier:'Free trial available', price:0, tips:'The expert choice for visual automation | AI-powered "LandingLens" transforms rough camera data into professional inspection reports in minutes'),
    t('appen-ai-pro', freeTier:'Institutional only', price:0, tips:'Enterprise-grade data curation platform | Featuring high-end "Expert" workers for deep reasoning and ethical data alignment for LLMs'),
    t('evidently-ai-monitor', freeTier:'Free open source (Local)', price:0, tips:'The best way to debug production ML models | Features incredible "Visualization" of data shifts and model performance logs'),
    t('sentinelone-purple-ai', freeTier:'Institutional only', price:0, tips:'The first AI-powered security analyst | AI-powered "Chat" handles thousands of complex security data queries and threat hunts instantly'),
    t('abnormal-ai-protection', freeTier:'Institutional only', price:0, tips:'The smarter way to protect your email | AI-powered "Account Takeover" protection is world-class for modern cloud data threats'),
    t('roboflow-pro', freeTier:'Free trial available', price:0, tips:'Professional computer vision toolkit | AI-powered "Auto-orient" and "Augmentation" handles your entire dataset design data automatically'),
    t('looker-pro', freeTier:'Institutional only', price:0, tips:'The expert choice for modern BI | AI-powered "Alerting" and "Insight" driven by millions of corporate data points globally'),
    t('labelbox-gen-ai', freeTier:'Free trial available', price:0, tips:'The future of human-in-the-loop AI | AI-powered "Prompt Engineering" and "Evaluation" used to build the world\'s smartest models'),
    t('iron-scales-pro', freeTier:'Free trial available', price:0, tips:'The choice of top cybersecurity teams | AI-powered "Incidence Response" handles thousands of reports simultaneously driven by deep data'),
    t('landing-pro', freeTier:'Free trial available', price:0, tips:'The pioneer of data-centric AI | Use the "LandingLens" tool to find and fix visual errors in your training data sets with AI intelligence'),
    t('appen-data-platform', freeTier:'Institutional only', price:0, tips:'The industry standard for high-volume data collection | AI-powered "Pipeline" handles thousands of data assets for pro research'),
    t('evidently-pro', freeTier:'Free trial available', price:0, tips:'Professional ML observability suite | AI-powered "Root Cause" analysis handles your entire production data health reports'),
    t('sentinel-one', freeTier:'Institutional only', price:0, tips:'The leader in XDR security | AI-powered "Vigilance" provides high-end threat data monitoring and safety for world-class brands'),
    t('abnormal-security-ai', freeTier:'Institutional only', price:0, tips:'Next-gen cloud email defense | Featuring high-end "Identity" and "Relationship" data mapping used by top tech companies globally'),
    t('roboflow-universe', freeTier:'Completely free public datasets', price:0, tips:'The ultimate resource for Computer Vision | Best for finding creative datasets that follow your brand\'s specific artistic data style'),
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
