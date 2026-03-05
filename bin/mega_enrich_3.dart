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
    t('photopea', freeTier:'Free with ads', price:5, priceTier:'Premium monthly', tips:'Best free Photoshop alternative | AI-powered "Magic Replace" and "Remove Background" are elite'),
    t('n8n', freeTier:'Free self-hosted (Desktop)', price:20, priceTier:'Starter monthly annual', tips:'Best for local-first automation | AI-powered "LangChain" nodes allow custom agents'),
    t('pipedream', freeTier:'Free for up to 10k credits/mo', price:19, priceTier:'Basic monthly annual', tips:'Best for developer-first workflows | AI-powered "Auto-generate" serverless functions'),
    t('readwise', freeTier:'30-day free trial on site', price:8, priceTier:'Full monthly annual', tips:'Best for digital highlights | Use "Reader" for AI-powered summaries of articles'),
    t('glasp', freeTier:'Completely free highlighter', price:0, tips:'Best for YouTube summaries | AI-powered "Social Web" highlighting for better learning'),
    t('tidio-ai', freeTier:'Free for up to 50 conversations', price:29, priceTier:'Starter monthly', tips:'Best for e-commerce support | AI-powered "Lyro" chatbot resolves most queries'),
    t('amazon-ai', freeTier:'Free tools for sellers', price:0, tips:'AI-powered "Product Listings" helper | Best for optimizing sales titles and data'),
    t('scite', freeTier:'7-day free trial on site', price:20, priceTier:'Premium monthly annual', tips:'Best for academic fact-checking | AI-powered "Smart Citations" verify research'),
    t('bing-copilot', freeTier:'Completely free with Microsoft account', price:20, priceTier:'Pro monthly', tips:'Best for real-time web search | AI-powered "Designer" is incredibly fast and free'),
    t('mem', freeTier:'Free basic version available', price:12, priceTier:'Pro monthly annual', tips:'The first self-organizing workspace | AI-powered "Mem It" captures anything instantly'),
    t('logseq', freeTier:'Completely free open source', price:0, tips:'Privacy-first knowledge graph | AI-powered "GPT" plugin for local notes research'),
    t('baseten', freeTier:'Free trial with credits', price:0, tips:'Best for deploying custom ML models | AI-powered "Serverless" inference at scale'),
    t('assembly-ai', freeTier:'Free tier for developers', price:0, tips:'Leading speech-to-text API | AI-powered "Summarization" and "Sentiment" is elite'),
    t('whisper', freeTier:'Completely free open source', price:0, tips:'OpenAI\'s gold standard for transcription | Best for local multi-lingual audio logs'),
    t('sonix-ai', freeTier:'Free trial for 30 mins', price:10, priceTier:'Standard hourly pay-as-you-go', tips:'Best for legal and academic audio | AI-powered "Editor" syncs with text'),
    t('happy-scribe', freeTier:'Free 10 mins trial', price:17, priceTier:'Basic monthly annual', tips:'Best for high-volume subtitling | AI-powered "Interactive" transcript editor'),
    t('notta-ai', freeTier:'Free 120 mins monthly', price:9, priceTier:'Pro monthly annual', tips:'Best for meeting notes | AI-powered "Summary" for Zoom and Google Meet'),
    t('transkriptor', freeTier:'Free trial for 30 mins', price:5, priceTier:'Lite monthly annual', tips:'Fastest way to turn audio into text | AI-powered "Share" and collab for teams'),
    t('google-travel', freeTier:'Completely free for public', price:0, tips:'AI-powered "Price Tracking" and "Things to do" | Best for complete trip planning'),
    t('tripit', freeTier:'Free basic version available', price:49, priceTier:'Pro yearly subscription', tips:'The ultimate travel organizer | AI-powered "Real-time" flight alerts and scores'),
    t('mealime', freeTier:'Free basic version available', price:6, priceTier:'Pro monthly annual', tips:'Best for personalized meal planning | AI-powered "Grocery List" automapping'),
    t('lunchbox-ai', freeTier:'Free tools for restaurants', price:0, tips:'Best for restaurant marketing | AI-powered "Food Photography" and data helper'),
    t('slides-ai', freeTier:'Free for 3 presentations/mo', price:10, priceTier:'Pro monthly annual', tips:'Best for fast Google Slides from text | AI-powered "One-click" creation'),
    t('slidesgo-ai', freeTier:'Free for up to 10 designs/mo', price:5, priceTier:'Premium monthly annual', tips:'Best for aesthetic templates | AI-powered "Presentation Maker" is very creative'),
    t('stable-audio', freeTier:'Free basic 20 tracks monthly', price:12, priceTier:'Pro monthly annual', tips:'Leading AI music gen | Best for high quality background tracks and loops'),
    t('tortoise-tts', freeTier:'Completely free open source', price:0, tips:'Ultra-realistic text-to-speech | Best for high-end voiceovers (requires GPU)'),
    t('ray-so', freeTier:'Completely free forever', price:0, tips:'Best for beautiful code snippets | AI-powered "Vibe" labels and clean designs'),
    t('carbon', freeTier:'Completely free forever', price:0, tips:'The industry standard for sharing code images | AI-powered "Themes" and data'),
    t('colorhunt', freeTier:'Completely free community', price:0, tips:'Best for designer color palettes | AI-powered "Trending" and "New" feeds'),
    t('quadratic', freeTier:'Free basic cloud tier', price:0, tips:'The infinite spreadsheet for developers | AI-powered "SQL" and "Python" nodes'),
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
