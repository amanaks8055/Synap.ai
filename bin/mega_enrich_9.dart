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
    t('huggingface', freeTier:'Free to host and share models', price:9, priceTier:'PRO Account monthly', tips:'The world\'s #1 AI community | Best for finding open-source models | Use "Spaces" for easy demos'),
    t('runway', freeTier:'Free forever with 125 credits', price:12, priceTier:'Standard monthly annual', tips:'Leading AI video editor | AI-powered "Gen-2" and "Motion Brush" are industry standards for creators'),
    t('stable-diffusion', freeTier:'Completely free open source', price:0, tips:'The gold standard for local image generation | Best for high-end "ControlNet" and custom models'),
    t('voiceflow', freeTier:'Free forever for 2 projects', price:50, priceTier:'Pro monthly per user', tips:'Best for building conversational AI agents | AI-powered "Knowledge Base" and "Flow" builder'),
    t('coze', freeTier:'Free to build and deploy', price:0, tips:'TikTok\'s developer platform for AI bots | Best for multi-agent workflows and easy plugin integration'),
    t('algolia-ai', freeTier:'Free for up to 10k searches/mo', price:1, priceTier:'Standard pay-as-you-go', tips:'Leading search API platform | AI-powered "Dynamic Re-ranking" and "Personalization" is elite'),
    t('bigquery-ai', freeTier:'Free for first 10GB storage', price:0, tips:'Google Cloud\'s massive data warehouse | AI-powered "ML" functions let you run SQL on datasets'),
    t('surfer-seo', freeTier:'Free basic tools available', price:69, priceTier:'Essential monthly annual', tips:'Best for SEO content optimization | AI-powered "Content Editor" and "Keyword" auditing'),
    t('power-bi-ai', freeTier:'Free basic desktop version', price:10, priceTier:'Pro monthly per user', tips:'Microsoft\'s leading BI tool | AI-powered "Q&A" and "Quick Insights" are extremely powerful'),
    t('builder-io', freeTier:'Free for up to 5 users', price:0, tips:'Leading visual CMS | AI-powered "Design to Code" turns Figma designs into production React code'),
    t('musho', freeTier:'Free basic layers/designs', price:10, priceTier:'Pro monthly', tips:'Best for Figma designers | AI-powered "Layout" and "Content" generation for web designs'),
    t('coqui', freeTier:'Free to explore/limited', price:20, priceTier:'Creator monthly', tips:'Leading platform for AI voice cloning | Best for high-fidelity emotional voiceovers in games'),
    t('diagram', freeTier:'Free trial available on Figma', price:0, tips:'Acquired by Figma | AI-powered "Design" tools and data generation within the canvas'),
    t('banana-dev', freeTier:'Free trial with credits', price:0, tips:'Best for ultra-fast serverless GPU deployment | Optimize your AI models for low-latency inference'),
    t('lightning-ai', freeTier:'Free to explore/credits', price:0, tips:'The creators of PyTorch Lightning | Best for building and scaling AI apps from prototype to cloud'),
    t('comet-ml', freeTier:'Free for academic/open source', price:0, tips:'Leading MLOps platform | AI-powered "Experiment Tracking" and "Model Production" management'),
    t('dvc-ai', freeTier:'Completely free open source', price:0, tips:'Data Version Control | The "Git for Data" | Best for managing massive datasets and ML pipelines'),
    t('arize-ai', freeTier:'Free basic version available', price:0, tips:'Leading AI observability platform | Best for monitoring model performance and detecting drift in prod'),
    t('voice-flow', freeTier:'Free forever basic version', price:50, priceTier:'Pro monthly annual', tips:'Best for designing complex AI chatbots | AI-powered "NLU" and "Designer" are extremely intuitive'),
    t('photosonic', freeTier:'Free basic credits monthly', price:10, priceTier:'Starter monthly annual', tips:'Best for fast blog graphics | AI-powered "Styles" and "Auto-complete" for creative prompts'),
    t('sellesta', freeTier:'Free for up to 10 products', price:14, priceTier:'Basic monthly annual', tips:'Best for Amazon sellers | AI-powered "SEO" and "Optimization" for product listings'),
    t('prisync', freeTier:'14-day free trial on site', price:99, priceTier:'Professional monthly starting', tips:'Leading e-com price tracking | AI-powered "Dynamic Pricing" and competitive data logs'),
    t('ada-cx', freeTier:'Institutional only', price:0, tips:'Leading customer service automation | AI-powered "Reasoning" engine for complex support queries'),
    t('bloomreach', freeTier:'Institutional only', price:0, tips:'The leader in personalized e-commerce content | AI-powered "Search" and "Merchandising" is elite'),
    t('forethought', freeTier:'Institutional only', price:0, tips:'Leading AI for support teams | AI-powered "Solve" and "Route" helps teams handle 2x tickets'),
    t('sonix', freeTier:'Free trial for 30 mins', price:10, priceTier:'Standard hourly', tips:'The industry leader in high-end audio transcription | AI-powered "Editor" is robust and fast'),
    t('notta', freeTier:'Free 120 mins monthly', price:9, priceTier:'Pro monthly annual', tips:'Leading meeting productivity tool | AI-powered "Transcript" and "Summary" for every call'),
    t('tactiq-ai', freeTier:'Free for up to 10 meetings/mo', price:12, priceTier:'Pro monthly annual', tips:'Leading Chrome extension for meeting notes | AI-powered "Ask" questions to your transcript'),
    t('slideai', freeTier:'Free for 3 presentations/mo', price:10, priceTier:'Pro monthly annual', tips:'Best for fast generative slides | AI-powered "Text to Deck" for Google Slides is magic'),
    t('sembly', freeTier:'Free forever basic version', price:10, priceTier:'Personal monthly annual', tips:'Best for high-quality meeting minutes | AI-powered "Action Items" and "Tasks" extraction'),
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
