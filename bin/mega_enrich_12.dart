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
    t('turbotax-ai', freeTier:'Free basic tax filing available', price:0, tips:'The world leader in consumer tax prep | AI-powered "Intuit Assist" helps find deductions and answers in real-time'),
    t('taxact-ai', freeTier:'Free basic version available', price:0, tips:'Leading tax filing solution | AI-powered "Xpert" help for tax questions and planning'),
    t('ramp-ai', freeTier:'Institutional only', price:0, tips:'Leading corporate card and spend management | AI-powered "Savings" insights and automated accounting'),
    t('brex-ai', freeTier:'Institutional only', price:0, tips:'The leader in spend management for tech | AI-powered "Empower" dashboard and finance help'),
    t('tweethunter', freeTier:'7-day free trial on site', price:49, priceTier:'Standard monthly annual', tips:'Best for Twitter/X growth | AI-powered "Viral" hook generator and automated scheduling'),
    t('tribescaler', freeTier:'Free basic version available', price:10, priceTier:'Pro monthly annual', tips:'Best for high-converting Twitter hooks | AI-powered "Algorithm" friendly writing help'),
    t('socialbee-ai', freeTier:'14-day free trial on site', price:19, priceTier:'Bootstrap monthly annual', tips:'Best for categorized social management | AI-powered "Post" generator and evergreen queues'),
    t('vistasocial', freeTier:'Free forever for 3 accounts', price:15, priceTier:'Pro monthly per user', tips:'Modern social media management tool | AI-powered "Sentiment" and "Smart Replies" for support'),
    t('sleep-cycle', freeTier:'Free basic version available', price:10, priceTier:'Premium monthly annual', tips:'Leading AI sleep tracker | AI-powered "Sound" analysis detects snoring and sleep quality patterns'),
    t('rise-science', freeTier:'7-day free trial on site', price:60, priceTier:'Yearly membership', tips:'Best for tracking sleep debt and energy | AI-powered "Circadian" rhythm mapping for peak performance'),
    t('rootd', freeTier:'Free basic version available', price:10, priceTier:'Premium monthly annual', tips:'Award-winning app for anxiety and panic attacks | AI-powered "Anxiety" relief tools and data'),
    t('divvy-ai', freeTier:'Institutional only', price:0, tips:'Owned by BILL | Leading spend management tool | AI-powered "Budgeting" and "Expense" automation'),
    t('pilot-finance', freeTier:'Institutional only', price:0, tips:'Leading AI-powered bookkeeping and tax for startups | AI-powered "Back-office" and finance help'),
    t('coreweave', freeTier:'Free to explore, pay for GPU usage', price:0, tips:'Leading specialized cloud provider for AI | Best for massive GPU clusters (H100, A100) at lower costs'),
    t('wave-ai', freeTier:'Free forever basic accounting', price:16, priceTier:'Pro monthly per user', tips:'Best for small biz accounting | AI-powered "Invoice" and "Receipt" scanning for fast setup'),
    t('storychief', freeTier:'14-day free trial on site', price:240, priceTier:'Essential monthly starting', tips:'Best for content marketing teams | AI-powered "Multi-channel" publishing and SEO help'),
    t('longshot', freeTier:'Free credits for developers', price:29, priceTier:'Pro monthly annual', tips:'Best for long-form factual content | AI-powered "Fact-check" and "SERP" analysis is elite'),
    t('writerly', freeTier:'7-day free trial on site', price:34, priceTier:'Pro monthly annual', tips:'Best for high-quality marketing copy | AI-powered "Templates" and "Persona" creation'),
    t('getfloorplan', freeTier:'Free trial for 2D plans', price:20, priceTier:'Per render pricing', tips:'Best for real estate marketing | AI-powered "3D" rendering from 2D floor plans in minutes'),
    t('fashionadvisor', freeTier:'Completely free online tool', price:0, tips:'Best for personalized fashion advice | AI-powered "What to wear" help based on trends and weather'),
    t('contentbot', freeTier:'Free forever basic version', price:19, priceTier:'Starter monthly annual', tips:'Leading platform for AI content automation | AI-powered "Full Blog" generator and data help'),
    t('photopea-ai-pro', freeTier:'Free with ads online', price:5, priceTier:'Premium monthly', tips:'The free Photoshop killer | AI-powered "Generative" tools and data based on web tech'),
    t('postly-ai', freeTier:'Free forever basic version', price:9, priceTier:'Pro monthly annual', tips:'Best for multi-platform social media distribution | AI-powered "One-click" publishing'),
    t('cookup-ai', freeTier:'Free forever basic version', price:0, tips:'Leading discovery platform for AI apps | Best for finding the newest tools and products fast'),
    t('ink', freeTier:'Free forever basic version', price:35, priceTier:'Pro monthly annual', tips:'Leading SEO content editor | AI-powered "Competitive" score and keyword data is elite'),
    t('dxo-ai', freeTier:'Free trial for 30 days', price:139, priceTier:'Flat one-time fee', tips:'Leading platform for RAW photo processing | AI-powered "DeepPRIME" noise reduction is world-class'),
    t('zyro-ai-id', freeTier:'Free to build and design', price:3, priceTier:'Website monthly annual', tips:'Best for fast landing pages | AI-powered "Heatmap" and "Content" generator for small biz'),
    t('crello-ai', freeTier:'Free basic version available', price:13, priceTier:'Pro monthly annual', tips:'Now VistaCreate | Best for creative templates | AI-powered "Background Remover" for graphics'),
    t('bg-eraser-pro', freeTier:'Free basic downloads', price:0, tips:'Best for removing objects and backgrounds | AI-powered "Correction" and "Enhancement" is very fast'),
    t('palette-color', freeTier:'Free high speed preview', price:9, priceTier:'Pro monthly annual', tips:'The gold standard for photo colorization | AI-powered "Presets" for pro photographers'),
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
