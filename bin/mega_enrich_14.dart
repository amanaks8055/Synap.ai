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
    t('supabase-ai', freeTier:'Free project tier available', price:25, priceTier:'Pro monthly per project', tips:'Leading open source Firebase alternative | AI-powered "SQL" generator and "Edge Functions" with built-in pgvector'),
    t('planetscale-ai', freeTier:'Free trial with credits', price:39, priceTier:'Scaler monthly starting', tips:'The world\'s most advanced MySQL platform | AI-powered "Insights" and "Boost" for high-performance queries'),
    t('railway-ai', freeTier:'\$5 free trial credits', price:5, priceTier:'Developer monthly base', tips:'Best for deploying complex AI backends | AI-powered "Environment" setup and auto-infra from GitHub'),
    t('firebase-ai', freeTier:'Free "Spark" plan available', price:0, tips:'Google\'s app development platform | AI-powered "Extensions" for image taggings, translation, and summaries in one click'),
    t('warp', freeTier:'Free for personal use', price:12, priceTier:'Team monthly per user', tips:'The AI-powered terminal for modern teams | Use "Warp AI" to debug commands or write scripts from natural language'),
    t('krea', freeTier:'Free forever basic version', price:30, priceTier:'Pro monthly annual', tips:'Leading real-time AI image enhancer and generator | Best for creative professional upscaling and video flux'),
    t('nightcafe', freeTier:'Free basic daily credits', price:5, priceTier:'Pro monthly credits', tips:'Most popular AI art community suite | Best for group challenges and exploring multiple algorithms in one place'),
    t('dreamstudio', freeTier:'Free trial credits initially', price:10, priceTier:'Per 1000 credits', tips:'Stability AI\'s official web interface | Best for expert-level control over Stable Diffusion models and lighting'),
    t('clipdrop', freeTier:'Free basic version available', price:9, priceTier:'Pro monthly annual', tips:'Acquired by Stability AI | Best for removing backgrounds and relighting photos instantaneously'),
    t('stockimg', freeTier:'Free for up to 1 generation', price:19, priceTier:'Starter monthly annual', tips:'Best for high-quality AI-generated stock photos, posters, and logos for marketing'),
    t('durable', freeTier:'Free to build and design', price:12, priceTier:'Startup monthly annual', tips:'The world\'s fastest AI website builder | Generates a complete site with copy and images in 30 seconds'),
    t('fronty', freeTier:'Free for up to 5 simple pages', price:10, priceTier:'Pro monthly annual', tips:'Best for turning screenshots into clean HTML/CSS code | AI-powered "Image to Code" converter'),
    t('supermaven', freeTier:'Free forever (1M token context)', price:10, priceTier:'Pro monthly annual', tips:'Extremely fast AI coding assistant | Features a massive context window for entire codebase understanding'),
    t('aider', freeTier:'Completely free open source', price:0, tips:'Best terminal-based AI pair programmer | Directly edits files and commits to git based on your prompts'),
    t('sourcegraph', freeTier:'Free for personal/public repos', price:99, priceTier:'Enterprise monthly per user', tips:'Leading AI code search and intelligence platform | AI-powered "Cody" knows your entire codebase context'),
    t('inflection', freeTier:'Completely free online tool', price:0, tips:'The "PI" personal intelligence lab | Best for building conversational agents with high emotional intelligence'),
    t('continue-dev', freeTier:'Completely free open source', price:0, tips:'Leading open source alternative to Copilot | Best for using custom models (Ollama, Anthropic) inside VS Code'),
    t('bluewillow', freeTier:'Free beta trial available', price:5, priceTier:'Basic monthly annual', tips:'Leading Discord-based AI image generator | Best for high-quality artistic styles similar to Midjourney'),
    t('e2b', freeTier:'Free for up to 1vCPU tier', price:0, tips:'Leading sandboxed cloud environment for AI agents | Best for running untrusted AI code safely in the cloud'),
    t('fotor-ai', freeTier:'Free basic version available', price:3, priceTier:'Pro monthly annual', tips:'All-in-one AI photo editor and generator | Best for fast creative filters and professional enhancements'),
    t('remini-2', freeTier:'Free to explore, pay for high-res', price:5, priceTier:'Weekly subscription starting', tips:'The world leader in AI "Old Photo" restoration | Best for making blurry faces crystal clear'),
    t('bing-image', freeTier:'Completely free with Microsoft account', price:0, tips:'Microsoft\'s official DALL-E 3 interface | Best for high-accuracy text rendering in images for free'),
    t('flowise', freeTier:'Completely free open source', price:0, tips:'Leading low-code tool for building LLM apps | Best for visually chaining LangChain nodes and data'),
    t('dashword', freeTier:'Free trial for 1 report', price:99, priceTier:'Professional monthly starting', tips:'Best for SEO content research | AI-powered "Brief" generator for high-ranking blog posts'),
    t('krea-ai', freeTier:'Free basic version available', price:30, priceTier:'Pro monthly', tips:'The most artistic real-time image generator | Best for live creative brainstorming and sketches'),
    t('continue', freeTier:'Completely free open source', price:0, tips:'Leading AI assistant for VS Code | Best for local-first coding with deep Ollama and local LLM integration'),
    t('railway', freeTier:'\$5 free credits (Trial)', price:5, priceTier:'Developer monthly', tips:'The fastest cloud deployment for AI backends | Best for auto-scaling Python and Node.js agents'),
    t('stockimg-ai', freeTier:'Free trial credits', price:19, priceTier:'Starter monthly', tips:'Best for generating brand-consistent stock images and icons | AI-powered "Theme" consistency is great'),
    t('night-cafe-ai', freeTier:'Free daily credits', price:5, priceTier:'Pro monthly', tips:'Leading AI art generator with massive community | Best for experimenting with diverse algorithms'),
    t('warp-terminal', freeTier:'Free for individuals', price:12, priceTier:'Team monthly', tips:'The AI-native terminal | AI-powered "Command search" and "History" management for dev teams'),
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
