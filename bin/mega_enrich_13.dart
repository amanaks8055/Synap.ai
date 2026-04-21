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
    t('khan-academy', freeTier:'Completely free for everyone', price:0, tips:'The world\'s #1 educational platform | AI-powered "Khanmigo" acts as a personal tutor for any subject'),
    t('civitai', freeTier:'Free to browse and download models', price:0, tips:'The largest community for open-source AI models | Best for finding specialized "LoRAs" for Stable Diffusion'),
    t('cloudflare-ai', freeTier:'Free trial for developers', price:0, tips:'Leading edge computing network | AI-powered "Workers AI" lets you run models on the global edge in clicks'),
    t('flo-health', freeTier:'Free basic version available', price:10, priceTier:'Premium monthly annual', tips:'Leading health app for women | AI-powered "Predictive" cycles and health insights used by millions'),
    t('codecademy-ai', freeTier:'Free basic coding tracks', price:20, priceTier:'Plus monthly annual', tips:'Leading coding school | AI-powered "Learning Assistant" and "Code Explanation" for beginners'),
    t('datacamp-ai', freeTier:'First chapter of all courses free', price:12, priceTier:'Premium monthly annual', tips:'Best for learning data science | AI-powered "Code" help and skill assessments for teams'),
    t('netlify-ai', freeTier:'Free for personal starters', price:19, priceTier:'Pro monthly per user', tips:'Leading platform for web devs | AI-powered "Deploy" and "Optimization" for frontend apps'),
    t('digitalocean-ai', freeTier:'Free trial with credits', price:0, tips:'Best for simple developer cloud | AI-powered "GPU Droplets" for running lightweight ML tasks'),
    t('aws-ai', freeTier:'Free tier for 12 months', price:0, tips:'Industry standard for AI infrastructure | Best for SageMaker, Bedrock, and Alexa-level models'),
    t('lambda-gpu', freeTier:'Free to explore, pay for GPU usage', price:0, tips:'Leading specialized cloud for high-end AI research | Best for H100 and A100 training at scale'),
    t('gigapixel', freeTier:'Free trial available on site', price:99, priceTier:'Flat one-time fee', tips:'Part of Topaz Labs | The gold standard for AI photo upscaling | Best for huge prints'),
    t('luminar-neo', freeTier:'Free trial for 7 days', price:10, priceTier:'Pro monthly annual', tips:'Leading AI-powered photo editor | AI-powered "Sky Replacement" and "Relight" is world-class'),
    t('denoise-ai', freeTier:'Free trial available on site', price:79, priceTier:'Flat one-time fee', tips:'Topaz Labs leader in noise removal | Best for low-light photography and pro camera data'),
    t('ai-sharpen', freeTier:'Free trial available on site', price:79, priceTier:'Flat one-time fee', tips:'Topaz Labs leader in image sharpening | AI-powered "Shake Reduction" and "Focus" help'),
    t('feedhive', freeTier:'Free trial for 7 days', price:15, priceTier:'Creator monthly annual', tips:'Best for multi-channel social growth | AI-powered "Post" recycling and scheduling'),
    t('chatfuel', freeTier:'Free trial for 50 users', price:14, priceTier:'Grow monthly annual', tips:'Leading platform for Facebook and WhatsApp bots | AI-powered "NLU" and data flows'),
    t('landbot', freeTier:'Free basic version available', price:30, priceTier:'Starter monthly annual', tips:'Best for building conversational lead forms | AI-powered "Visual" builder and data collection'),
    t('adobe-enhance', freeTier:'Completely free (daily limits)', price:0, tips:'Part of Adobe Podcast | Best for cleaning voice recordings | AI-powered "Mic" simulation is elite'),
    t('venice-ai', freeTier:'Free forever basic version', price:10, priceTier:'Pro monthly annual', tips:'Leading privacy-first AI search and chat | Best for uncensored and secure research'),
    t('seaart', freeTier:'Free daily credits available', price:10, priceTier:'VIP monthly annual', tips:'Leading Asian AI art community | Best for anime and high-end creative models (based on SD)'),
    t('piclumen', freeTier:'Free basic version available', price:0, tips:'Next-gen AI image generator | Best for high-speed creative prototyping and artistic filters'),
    t('kimi', freeTier:'Free to use in China (Web/App)', price:0, tips:'Moonshot AI\'s high-end LLM | Best for long-context (2M+ tokens) processing and data logs'),
    t('hackerrank-ai', freeTier:'Free for developers', price:0, tips:'Leading platform for technical hiring | AI-powered "Hiring" and "Skill" assessment for HR teams'),
    t('kimi-ai', freeTier:'Free forever basic version', price:0, tips:'Leading Chinese LLM for research | Best for analyzing massive PDFs and financial reports'),
    t('sea-art-ai', freeTier:'Free daily credits', price:10, priceTier:'Standard monthly', tips:'High-end AI art generator and model library | Best for creative LoRAs and upscale'),
    t('civit-ai-pro', freeTier:'Free basic access', price:0, tips:'The largest repo of open AI models | Best for finding high-quality checkpoints and LoRAs'),
    t('landbot-pro', freeTier:'Free trial available', price:30, priceTier:'Starter monthly', tips:'The "No-code" king of chatbots | AI-powered "Workflow" and data collection for sales'),
    t('adobe-speech', freeTier:'Free basic version available', price:0, tips:'The best tool for cleaning voice audio | AI-powered "Professional" podcast quality for everyone'),
    t('aws-bedrock', freeTier:'Free trial with credits', price:0, tips:'Leading enterprise AI platform | Best for building RAG and multi-model apps at scale'),
    t('azure-openai', freeTier:'Institutional only', price:0, tips:'Enterprise-grade GPT models on Microsoft Cloud | Best for security-first corporate AI apps'),
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
