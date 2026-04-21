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
    t('respell', freeTier:'Free for first 5 flows', price:50, priceTier:'Pro monthly', tips:'Best for simple AI automations | AI-powered "Magic" blocks are very easy to use'),
    t('tabnine', freeTier:'Free basic auto-complete', price:12, priceTier:'Pro monthly annual', tips:'Best for local-first privacy | AI-powered "Full-line" suggestions are elite'),
    t('windsurf', freeTier:'Free trial available', price:20, priceTier:'Pro monthly', tips:'The agentic IDE by Codeium | AI-powered "Terminal" and "File" exploration'),
    t('sonarqube-ai', freeTier:'Free open source community', price:150, priceTier:'Developer annual starting', tips:'Enterprise code security | AI-powered "Clean Code" assistant'),
    t('polotno', freeTier:'Free for personal starters', price:0, tips:'Best for building design editors | AI-powered "SDK" for canvas apps'),
    t('autodraw', freeTier:'Completely free forever', price:0, tips:'Google\'s AI drawing tool | Best for turning doodles into clean icons'),
    t('brandbird', freeTier:'Free basic shares', price:15, priceTier:'Pro monthly annual', tips:'Best for high end social shares | AI-powered "Mockup" and "Shadow" help'),
    t('zhipu-ai', freeTier:'Free basic API credits', price:0, tips:'Leading Chinese LLM (GLM) | Best for Chinese language processing and math'),
    t('qwen', freeTier:'Free open source models', price:0, tips:'Alibaba\'s high-end LLM | Best for multi-lingual and coding benchmarks'),
    t('cohere-chat', freeTier:'Free credits for developers', price:0, tips:'Best for RAG and enterprise search | AI-powered "Command" models are fast'),
    t('textcortex', freeTier:'Free 10 creations daily', price:18, priceTier:'Lite monthly annual', tips:'Best for Chrome extension writing | AI-powered "Zeno" assistant is great'),
    t('simplified-ai', freeTier:'Free basic version available', price:15, priceTier:'Pro monthly annual', tips:'Best for social media teams | AI-powered "Design" and "Video" in one app'),
    t('power-automate', freeTier:'Free with Windows/Office', price:15, priceTier:'Premium monthly per user', tips:'Best for Microsoft ecosystem | AI-powered "Copilot" flow builder'),
    t('uipath-ai', freeTier:'Free community edition', price:0, tips:'The RPA enterprise leader | AI-powered "Document Understanding" is elite'),
    t('automation-anywhere', freeTier:'Free trial available', price:0, tips:'Best for scale RPA | AI-powered "AARI" digital assistant for teams'),
    t('vectary', freeTier:'Free for personal starters', price:19, priceTier:'Pro monthly annual', tips:'Best for 3D web design | AI-powered "Auto-Layout" for 3D elements'),
    t('described', freeTier:'Free basic version available', price:0, tips:'Best for alt-text and accessibility | AI-powered "Image" descriptions'),
    t('lexica', freeTier:'Free 16 images daily', price:10, priceTier:'Starter monthly annual', tips:'The "Stable Diffusion" search engine | Best for finding prompts'),
    t('gamma-ai', freeTier:'Free 400 credits initially', price:8, priceTier:'Plus monthly annual', tips:'Best for slide decks | AI-powered "One-click" presentation builder'),
    t('gamma', freeTier:'Free basic credits available', price:10, priceTier:'Pro monthly annual', tips:'Best for storytelling and sales decks | AI-powered "Interactive" layouts'),
    t('beautiful-ai', freeTier:'14-day free trial on site', price:12, priceTier:'Pro monthly annual', tips:'Best for design-first slides | AI-powered "Smart Slides" that auto-adjust'),
    t('prezi-ai', freeTier:'Free basic version available', price:7, priceTier:'Standard monthly annual', tips:'The non-linear presentation king | AI-powered "Content" helper'),
    t('visme-ai', freeTier:'Free basic version available', price:12, priceTier:'Starter monthly annual', tips:'Best for infographics | AI-powered "Design" templates are robust'),
    t('venngage-ai', freeTier:'Free for up to 5 designs', price:10, priceTier:'Premium monthly annual', tips:'Best for professional reports | AI-powered "Chart" generator'),
    t('infogram-ai', freeTier:'Free basic version available', price:19, priceTier:'Pro monthly annual', tips:'Best for interactive maps | AI-powered "Data" visualization'),
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
