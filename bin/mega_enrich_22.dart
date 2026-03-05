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
    t('jetbrains-ai', freeTier:'Free trial for 7 days', price:10, priceTier:'Individual monthly annual', tips:'The official AI assistant for IntelliJ, PyCharm, and WebStorm | AI-powered "Context-aware" code completion and refactoring used by millions of pros'),
    t('aws-codewhisperer', freeTier:'Free for individual developers', price:19, priceTier:'Professional monthly per user', tips:'Now part of Amazon Q Developer | Leading AI coding assistant for AWS infra | Best for high-accuracy cloud development and security scans'),
    t('elicit-research', freeTier:'Free basic version available', price:12, priceTier:'Pro monthly annual', tips:'The gold standard for scientific research automation | AI-powered "Literature Review" summarizes and extracts data from 200M+ papers instantly'),
    t('consensus-app', freeTier:'Free forever basic version', price:8, priceTier:'Premium monthly annual', tips:'The "Search Engine for Truth" | Best for finding direct evidence-based answers from peer-reviewed research papers without ad clutter'),
    t('capture-one', freeTier:'Free trial for 30 days', price:24, priceTier:'Desktop monthly annual', tips:'The world leader in tethered shooting and RAW editing | AI-powered "Smart Adjustments" and "AI Crop" used by top fashion photographers'),
    t('coderabbit', freeTier:'Free for open source projects', price:15, priceTier:'Pro monthly annual', tips:'Next-gen AI code reviewer | Directly joins your PRs on GitHub/GitLab to provide high-end logic feedback and security data logs'),
    t('humata', freeTier:'Free for up to 60 pages', price:15, priceTier:'Pro monthly annual', tips:'Leading platform for analyzing massive technical manuals and documents | AI-powered "Deep Search" used by engineering and legal teams'),
    t('codellama', freeTier:'Completely free open source', price:0, tips:'Meta\'s world-class LLM for code | Best for self-hosting high-performance assistants for Python, C++, and Java developers'),
    t('luminar-ai', freeTier:'Free trial available on site', price:99, priceTier:'Flat one-time fee', tips:'Leading AI-powered photo editor for enthusiasts | Best for "Artificial Intelligence" based sky replacement and skin retouching'),
    t('powtoon', freeTier:'Free forever basic version', price:15, priceTier:'Lite monthly annual', tips:'Leading platform for animated business presentations | AI-powered "Character" and "Scene" generation for fast marketing videos'),
    t('jetbrains-assistant', freeTier:'Free trial tier', price:10, priceTier:'Monthly subscription', tips:'The smartest coding companion for pro devs | Features "Local" and "Cloud" based AI data processing for privacy and speed'),
    t('aws-q-developer', freeTier:'Free for individuals', price:19, priceTier:'Professional monthly', tips:'The evolution of CodeWhisperer | Best for full-lifecycle cloud development from ideation to secure deployment on AWS'),
    t('elicit-ai', freeTier:'Free basic research access', price:12, priceTier:'Pro monthly', tips:'The research laboratory in your browser | Best for systematic reviews and complex data extraction from scientific journals'),
    t('consensus-search', freeTier:'Free basic search', price:8, priceTier:'Premium monthly', tips:'Evidence-based search engine for professionals | AI-powered "Synthesis" summarizes scientific consensus on any medical or science query'),
    t('capture-one-pro', freeTier:'Free trial available', price:24, priceTier:'All-in-one monthly', tips:'The industry standard for high-end RAW processing | AI-powered "Color" and "Detail" reconstruction is world-class'),
    t('code-rabbit-ai', freeTier:'Free project trial', price:15, priceTier:'Annual membership', tips:'The AI that reads every line of your code | Reduces review time by 70% with high-accuracy logic and security data'),
    t('humata-ai', freeTier:'Free document analysis', price:15, priceTier:'Pro monthly', tips:'The fastest way to understand complex technical data | Use the "Chat" feature to find answers buried in 1000+ page PDFs'),
    t('mentat', freeTier:'Completely free open source', price:0, tips:'The command-line AI coding agent that lives in your terminal | Directly coordinates with your IDE to solve complex Jira and GitHub issues'),
    t('metabob', freeTier:'Free for personal developers', price:0, tips:'Leading AI for debugging and refactoring | Best for finding complex logic bugs that traditional static analysis misses in C++ and Python'),
    t('looklet', freeTier:'Institutional only', price:0, tips:'Leading AI for automated fashion photography | Features world-class virtual models and clothing data mapping for e-commerce'),
    t('matter-app', freeTier:'Free forever basic version', price:0, tips:'Leading discovery platform for AI applications | Best for finding the most innovative and newest startups in the AI ecosystem'),
    t('ai-commit', freeTier:'Completely free open source', price:0, tips:'Leading CLI tool for automated git commit messages | AI-powered "Diff" analysis generates professional commit logs in seconds'),
    t('namelix-logo-maker', freeTier:'Free to design and preview', price:20, priceTier:'Logo pack flat fee', tips:'Leading AI-powered brand identity tool | Best for generating professional logo sets and business card data in one click'),
    t('typedream', freeTier:'Free to build and host on domain', price:12, priceTier:'Personal monthly annual', tips:'Leading "Notion-like" website builder | AI-powered "Page" generation and layout for startups and creators'),
    t('zeroscope', freeTier:'Completely free open source', price:0, tips:'Leading open source text-to-video model | Best for experimental creative research and high-speed video prototyping (based on ModelScope)'),
    t('zysite', freeTier:'Free to design basic', price:5, priceTier:'Website monthly', tips:'Leading AI website generator for small businesses | AI-powered "SEO" and "Copywriting" handles your entire online presence'),
    t('pow-toon-ai', freeTier:'Free basic access', price:15, priceTier:'Lite monthly', tips:'The pioneer of automated animation | Use the "Scene" generator to turn blog posts into high-impact marketing videos'),
    t('luminar-pro', freeTier:'Free trial available', price:10, priceTier:'Subscription monthly', tips:'The most artistic AI photo editor | Best for high-end landscape and portrait enhancements with professional data presets'),
    t('capture-one-enterprise', freeTier:'Institutional only', price:0, tips:'The gold standard for high-volume studios | AI-powered "Workflow" and "Asset management" for world-class fashion brands'),
    t('aws-code-whisper', freeTier:'Free basic individual access', price:19, priceTier:'Pro monthly', tips:'Secure and accurate AI for cloud architects | Use the "Security" scan to find vulnerabilities in your Python and Java data'),
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
