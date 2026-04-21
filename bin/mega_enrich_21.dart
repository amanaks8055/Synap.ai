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
    t('xcode-ai', freeTier:'Free part of Apple Developer tools', price:0, tips:'Apple\'s official IDE for iOS/macOS | AI-powered "Predictive" code completion and Swift support used by world-class app developers'),
    t('gpt-engineer', freeTier:'Completely free open source', price:0, tips:'Leading autonomous AI agent for builds | Best for generating an entire codebase from a single prompt including backend and database logic'),
    t('pixelmator', freeTier:'Free trial for 15 days', price:50, priceTier:'Flat one-time fee', tips:'The best AI-powered Photoshop alternative for Mac | Features world-class "ML Super Resolution" and "Smart Deblur" used by pro photographers'),
    t('topaz-ai', freeTier:'Free trial available on site', price:199, priceTier:'Photo/Video AI flat fee', tips:'The gold standard for AI photo and video enhancement | AI-powered "DeepPRIME" and "Upscale" transforms blurry footage into 8K'),
    t('reclaim-ai', freeTier:'Free forever for individual use', price:8, priceTier:'Starter monthly annual', tips:'Leading AI smart calendar for teams | AI-powered "Habits" and "Task" scheduling automatically finds the best time for deep work'),
    t('pdfai', freeTier:'Free for up to 1 PDF (50 pages)', price:15, priceTier:'Pro monthly annual', tips:'Leading platform for chatting with any PDF | Best for legal and research teams extracting data from massive documents instantly'),
    t('unriddle', freeTier:'Free forever basic version', price:16, priceTier:'Pro monthly annual', tips:'Best for researchers managing libraries | AI-powered "Auto-link" and "Contextual Search" connects ideas across multiple papers'),
    t('codegpt', freeTier:'Free trial credits for dev', price:0, tips:'Leading extension for VS Code and JetBrains | Connect any LLM (OpenAI, Anthropic, Ollama) directly into your coding environment'),
    t('sweep-ai', freeTier:'Free for open source repos', price:0, tips:'Autonomous AI junior developer | Directly handles GitHub issues by writing code, building tests, and submitting PRs automatically'),
    t('starcoder', freeTier:'Completely free open source', price:0, tips:'Leading open source LLM for code | Best for self-hosting your own coding assistant with deep knowledge of 80+ programming languages'),
    t('topaz-photo-ai', freeTier:'Free trial available', price:199, priceTier:'Flat fee', tips:'The smartest photo enhancer | AI-powered "Autopilot" handles noise, blur, and lighting fixes in one click'),
    t('pixelmator-pro', freeTier:'Free trial available', price:50, priceTier:'Purchase once', tips:'Leading Mac photo editor with deep ML integration | Best for high-end masking and artistic effect generation'),
    t('reclaim', freeTier:'Free basic version', price:8, priceTier:'Starter monthly', tips:'The ultimate productivity calendar | Syncs your personal and work life perfectly with AI-powered time blocking'),
    t('pdf-ai-pro', freeTier:'Free document trial', price:15, priceTier:'Pro monthly', tips:'The fastest way to analyze reports and law papers | AI-powered "Summary" and "Citation" check is extremely accurate'),
    t('unriddle-ai', freeTier:'Free search tier', price:16, priceTier:'Premium monthly', tips:'Leading AI research assistant | Features "Deep Read" mode for understanding complex scientific data and connections'),
    t('code-gpt-ext', freeTier:'Free trial available', price:0, tips:'The "Power-user" tool for AI coding | Best for experimental LLM research and custom prompt engineering in VS Code'),
    t('sweep-dev', freeTier:'Free for local projects', price:0, tips:'The autonomous engineer for your backlog | Features deep reasoning for complex refactoring and bug data logs'),
    t('starcoder-2', freeTier:'Free open source (HuggingFace)', price:0, tips:'Next-gen code LLM from BigCode | Optimized for efficient on-device coding and high-accuracy Python/TS generation'),
    t('appgyver', freeTier:'Free for all personal projects', price:0, tips:'Owned by SAP | Leading enterprise no-code platform | Build high-performance business apps with complex logic and data'),
    t('supernotes', freeTier:'Free for up to 40 cards', price:6, priceTier:'Unlimited monthly annual', tips:'Best for visual and fast note-taking | AI-powered "Flashcard" and "Link" generation for students and researchers'),
    t('mymind', freeTier:'Free basic storage limited', price:12, priceTier:'Mastermind monthly annual', tips:'The "Private" memory extension | AI-powered "Auto-tagging" and "Visual" search for everything you save on the web'),
    t('undermind', freeTier:'Free trial for 3 research tasks', price:0, tips:'Next-gen AI search for academics | Best for finding that one "Needle in a haystack" paper using deep reasoning'),
    t('doctranslate', freeTier:'Free trial for 2 documents', price:0, tips:'Leading platform for high-accuracy document translation | AI-powered "Layout" preservation for PDFs and Office files'),
    t('safurai', freeTier:'Completely free for developers', price:0, tips:'Leading AI coding assistant with deep focus on clean code | AI-powered "Refactoring" used by 50k+ pro devs'),
    t('tabby', freeTier:'Completely free open source', price:0, tips:'Leading self-hosted alternative to GitHub Copilot | Best for teams needing 100% data privacy and custom model training'),
    t('gpt-engineer-ai', freeTier:'Free open source (Local)', price:0, tips:'The "One-command" app builder | Best for prototyping web apps and full-stack bots from a single text file'),
    t('code-climate', freeTier:'Free for open source projects', price:0, tips:'Leading platform for code quality and security | AI-powered "Velocity" and "Maintainability" data for engineering leads'),
    t('docstring-ai', freeTier:'Free trial available on site', price:0, tips:'Best for automated code documentation | AI-powered "Parser" writes professional docs for any function or class in seconds'),
    t('on1-ai', freeTier:'Free trial for 14 days', price:99, priceTier:'One-time purchase', tips:'Leading AI photo editor for pro photographers | Best for RAW masking and artistic style data replication'),
    t('topaz-video-ai', freeTier:'Free trial available', price:299, priceTier:'Flat one-time fee', tips:'The world leader in AI video upscaling | Best for restoring high-end cinematic footage and high frame-rate data'),
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
