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
    t('android-studio-ai', freeTier:'Completely free for developers', price:0, tips:'Google\'s official IDE for Android development | AI-powered "Gemini in Android Studio" helps with coding, debugging, and data logic used by million of app devs'),
    t('minimax-video', freeTier:'Free beta access and daily credits', price:0, tips:'The "Kling" of video generation | Best for high-complexity human physics and artistic motion used by high-end creative researchers'),
    t('mixo', freeTier:'Free to design and preview basic', price:9, priceTier:'Basic monthly annual', tips:'The fastest way to launch a startup idea | AI-powered "Startup Generator" builds a landing page, copy, and logo from a single prompt in minutes'),
    t('phidata', freeTier:'Completely free open source', price:0, tips:'Leading framework for building AI assistants with memory and tools | Best for developers creating production-grade LLM agents with Pydantic and data flows'),
    t('semantic-kernel', freeTier:'Completely free open source (Microsoft)', price:0, tips:'Microsoft\'s official SDK for building AI agents | Best for integrating LLMs into enterprise C# and Python apps with deep data safety'),
    t('superagent', freeTier:'Free forever basic version', price:0, tips:'Leading low-code platform for deploying AI agents | Best for developers needing a simple cloud interface for LangChain and tool data'),
    t('animoto', freeTier:'Free forever basic version', price:8, priceTier:'Basic monthly annual', tips:'Leading platform for fast video generation for small businesses | AI-powered "Template" and "Music" matching for social media marketing'),
    t('img2go', freeTier:'Free forever basic version', price:6, priceTier:'Pro monthly annual', tips:'All-in-one AI image editing suite | Best for high-speed conversions, upscaling, and artistic filters used by blog designers'),
    t('blogify', freeTier:'Free trial for 3 blog posts', price:24, priceTier:'Starter monthly annual', tips:'Best for turning video/audio into professional blogs | AI-powered "SEO" and "Rewrite" handles your entire content marketing data flow'),
    t('closerscopy', freeTier:'Free trial available on site', price:49, priceTier:'Professional monthly starting', tips:'Leading AI tool for professional copywriters | Best for high-converting sales letters, ads, and long-form email data logs'),
    t('writier', freeTier:'Free trial for 2000 words', price:10, priceTier:'Pro monthly annual', tips:'Best for clean and fast blog writing | AI-powered "Predictive" text and SEO help used by independent creators'),
    t('lenvideo', freeTier:'Free basic version available', price:0, tips:'Leading AI video search and summarization tool | Best for finding specific data and moments inside hours of video footage instantly'),
    t('mixo-ai', freeTier:'Free startup trial', price:9, priceTier:'Basic monthly', tips:'The ultimate validation tool for founders | AI-powered "Waitlist" and "Analytics" handles your early product launch data'),
    t('phidata-ai', freeTier:'Free open source (Local/Cloud)', price:0, tips:'The developer-first AI agent platform | Features world-class "Knowledge Base" and "Tool" integration for building smarter agents'),
    t('semantic-kernel-pro', freeTier:'Free open source SDK', price:0, tips:'Enterprise-grade AI orchestration by Microsoft | Best for building RAG and multi-agent systems with deep Azure data safety'),
    t('animoto-video', freeTier:'Free with watermark', price:8, priceTier:'Basic monthly', tips:'The "Power-user" of business slideshows | AI-powered "Branding" ensures every video follows your specific font and color data'),
    t('img2go-ai-pro', freeTier:'Free basic storage', price:6, priceTier:'Premium monthly', tips:'Professional AI image toolkit | Best for high-fidelity "Photo Restoration" and "Vector" conversion for print designers'),
    t('blogify-pro', freeTier:'Free trial available', price:24, priceTier:'Starter monthly', tips:'The smartest content repurposing suite | AI-powered "Podcast to Post" keeps your brand voice consistent across all data channels'),
    t('closers-copy-ai', freeTier:'Free tool trial', price:49, priceTier:'Pro monthly', tips:'The expert-level copywriting assistant | Features world-class "Step-by-step" frameworks for sales and marketing pros'),
    t('writier-ai-pro', freeTier:'Free word limit', price:10, priceTier:'Pro monthly', tips:'High-speed AI writing environment | Use the "Context" mode to feed your research into the editor for deep accurate content'),
    t('lenvideo-pro', freeTier:'Free search trial', price:0, tips:'Leading enterprise video intelligence | AI-powered "Semantic" search finds info in videos as easily as searching on Google'),
    t('mini-max-ai', freeTier:'Free beta daily', price:0, tips:'China\'s leader in cinematic AI video | Best for high-fidelity human textures and realistic physical lighting in generations'),
    t('super-agent-pro', freeTier:'Free basic access', price:0, tips:'The easiest way to put AI agents into production | Features world-class "Dashboard" and "API" for managing LLM data flows'),
    t('android-studio-gemini', freeTier:'Completely free (Google)', price:0, tips:'The future of mobile development | AI-powered "Firebase" integration and automated error logging used by elite Android devs'),
    t('docstring-pro', freeTier:'Free trial available', price:0, tips:'The industry standard for code documentation | AI-powered "API Generator" handles thousands of files in one data processing batch'),
    t('code-climate-ai', freeTier:'Free for public repos', price:0, tips:'The "CTO\'s Dashboard" for engineering | AI-powered "Refactor" and "Debt" analysis gives you clear data on your team\'s code quality'),
    t('gpt-engineer-pro', freeTier:'Free local version', price:0, tips:'The autonomous app builder for pros | Features deep "Full-stack" capabilities for building React/Node apps from scratch with AI'),
    t('namelix-pro', freeTier:'Free design trial', price:20, priceTier:'Brand pack', tips:'The gold standard for AI brand names and logos | Best for founders needing high-end aesthetic designs and domain data checks'),
    t('mixo-launch', freeTier:'Free build access', price:9, priceTier:'Starter monthly', tips:'The standard for landing page automation | AI-powered "Product-market fit" research handles your early startup data validation'),
    t('android-studio-ai-pro', freeTier:'Completely free (Google)', price:0, tips:'Google\'s most advanced coding assistant | AI-powered "Performance" and "Network" debugging handles your entire app data cycle'),
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
