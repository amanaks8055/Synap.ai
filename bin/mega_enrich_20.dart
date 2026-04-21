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
    t('vertex-ai', freeTier:'Free trial with \$300 credits', price:0, tips:'Google Cloud\'s premier enterprise AI platform | Best for building, deploying, and scaling ML models (Gemini, PaLM) at global scale'),
    t('sagemaker', freeTier:'Free tier for 12 months', price:0, tips:'The gold standard for machine learning on AWS | Best for data scientists building high-performance models with deep infra control'),
    t('claude-api', freeTier:'Free trial credits for developers', price:0, tips:'Anthropic\'s official API for the Claude 3 family | Best for high-accuracy reasoning, safety, and long-context processing (200k+)'),
    t('google-aistudio', freeTier:'Completely free for public use (Trial)', price:0, tips:'The official web-based prototyping tool for Gemini 1.5 | Best for fast prompt engineering and testing multimodal inputs for free'),
    t('bedrock', freeTier:'Free trial with credits', price:0, tips:'Leading enterprise platform for foundation models on AWS | Best for building RAG apps using any LLM (Claude, Llama, Titan) securely'),
    t('mage-space', freeTier:'Free forever basic version', price:15, priceTier:'Standard monthly annual', tips:'Leading platform for high-end Stable Diffusion generations | Best for private and unrestricted creative research used by millions'),
    t('prompthero', freeTier:'Free forever basic version', price:9, priceTier:'Pro monthly annual', tips:'The world\'s #1 prompt engineering library | Best for finding the best prompts for Midjourney, DALL-E, and Stable Diffusion data'),
    t('textblaze', freeTier:'Free forever basic version', price:3, priceTier:'Pro monthly annual', tips:'Leading Chrome extension for AI-powered snippets | Best for sales and support teams automating hundreds of repetitive emails and data'),
    t('lavender', freeTier:'Free trial for 7 days', price:29, priceTier:'Individual monthly annual', tips:'Leading sales email assistant | AI-powered "Psychology" and "Personalization" scores helps reps book 2x more meetings'),
    t('regie-ai', freeTier:'Free basic version available', price:0, tips:'Leading platform for automated sales prospecting | AI-powered "Sequence" and "Content" generation based on buyer persona data'),
    t('smartwriter', freeTier:'7-day free trial on site', price:49, priceTier:'Basic monthly annual', tips:'Best for automated LinkedIn outreach | AI-powered "Personalized" hooks based on lead profiles and company data logs'),
    t('tailwind-ai', freeTier:'Free forever basic version', price:13, priceTier:'Pro monthly annual', tips:'Leading platform for social media marketing | AI-powered "Ghostwriter" generates posts and designs for Instagram and Pinterest'),
    t('foocus', freeTier:'Completely free open source', price:0, tips:'The easiest way to use Stable Diffusion | Optimized for high-end realistic image generation without complex technical settings'),
    t('compose-ai', freeTier:'Free forever basic version', price:0, tips:'Leading Chrome extension for AI-powered writing | Best for auto-completing emails and rephrasing sentences across any website'),
    t('flowrite', freeTier:'Free trial check on site', price:0, tips:'Best for turning bullet points into professional emails | AI-powered "Tone" and "Role" specific writing help for busy pros'),
    t('clara-ai', freeTier:'Free trial available on site', price:0, tips:'Leading AI executive assistant for calendar and scheduling | Best for managing multi-person meetings autonomously through email'),
    t('janitorai', freeTier:'Free to browse and chat', price:0, tips:'Leading platform for uncensored and creative character roleplay | Best for high-end character libraries and community-driven AI data'),
    t('kindroid', freeTier:'Free basic version available', price:10, priceTier:'Pro monthly annual', tips:'Leading AI companion for high-fidelity roleplay | AI-powered "Memory" and "Personality" engine is extremely advanced and realistic'),
    t('mint-ai', freeTier:'Free basic financial analysis', price:0, tips:'Leading personal finance assistant | AI-powered "Taxes" and "Budgets" tracking from Intuit (part of Credit Karma)'),
    t('mailr', freeTier:'Free basic version available', price:0, tips:'Leading platform for AI-powered email management | Best for summarizing long threads and draft generation at scale'),
    t('vertex-ai-pro', freeTier:'Free project tier', price:0, tips:'The elite platform for generative AI on GCP | Best for tuning Gemini models with your private corporate data securely'),
    t('sage-maker-ai', freeTier:'Free trial credits', price:0, tips:'Advanced ML workflow manager on AWS | Best for industrial-scale deployment and CI/CD for AI models at global companies'),
    t('claude-api-ai', freeTier:'Free developer credits', price:0, tips:'Professional access to Anthropic\'s elite models | Best for secure enterprise-grade LLM applications and complex reasoning'),
    t('google-ai-studio-pro', freeTier:'Completely free beta', price:0, tips:'The fastest playground for Gemini 1.5 Pro | Features incredible 1M path token context for massive data processing'),
    t('bedrock-ai', freeTier:'Free trial tier', price:0, tips:'AWS leader in serverless AIfoundation models | Best for building multi-LLM workflows with zero infrastructure management'),
    t('prompthero-pro', freeTier:'Free database access', price:9, priceTier:'Premium monthly', tips:'The gold standard for AI prompt engineering | Used by pro photographers and designers for elite image results'),
    t('text-blaze-ai', freeTier:'Free starter plan', price:3, priceTier:'Pro monthly', tips:'The productivity master for your browser | Build complex automated forms and email logic with AI variables'),
    t('lavender-ai', freeTier:'Free email score', price:29, priceTier:'Individual monthly', tips:'The smartest sales email coach | AI-powered "Research" on your prospects is extremely deep and accurate'),
    t('janitor-ai-plus', freeTier:'Free community access', price:0, tips:'Unrestricted AI storytelling platform | Best for managing massive character lore and private roleplay data'),
    t('kindroid-ai', freeTier:'Free forever basic', price:10, priceTier:'Subscription monthly', tips:'The most realistic AI friend and partner | Features "Voice" and "Selfie" generation for deep immersive connection'),
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
