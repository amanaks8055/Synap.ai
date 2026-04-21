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
    t('adobe-express', freeTier:'Free basic version available', price:10, priceTier:'Premium monthly', tips:'Best for fast social graphics | AI-powered "Text to Image" and "Generative Fill" are elite'),
    t('ifttt-ai', freeTier:'Free for up to 2 applets', price:3, priceTier:'Pro monthly annual', tips:'Best for simple personal automation | AI-powered "Summarizer" for emails and news'),
    t('tray-io', freeTier:'Free trial available on site', price:0, tips:'Enterprise standard for automation | AI-powered "Merlin" assistant builds flows from text'),
    t('contentful-ai', freeTier:'Free for up to 5 users/intro', price:489, priceTier:'Team monthly annual', tips:'Best for headless CMS | AI-powered "Content Type" generator and data help'),
    t('strapi-ai', freeTier:'Free community edition (self-host)', price:29, priceTier:'Cloud Pro monthly', tips:'Leading open source headless CMS | AI-powered "Plugin" support for content summaries'),
    t('sanity-ai', freeTier:'Free forever for individual devs', price:15, priceTier:'Growth monthly per user', tips:'Best for real-time collab and data | AI-powered "Assist" helps write schema and content'),
    t('vectorizer-ai', freeTier:'Free beta access available', price:10, priceTier:'Pro monthly', tips:'Best for turning PNG/JPG into clean SVG | AI-powered "Curves" are extremely precise'),
    t('designify', freeTier:'Free basic downloads', price:0, tips:'Best for automatic product photo enhancement | AI-powered "Background" and "Shadow" replacement'),
    t('appsmith', freeTier:'Free community edition', price:20, priceTier:'Business monthly per user', tips:'Best for building internal admin panels | AI-powered "JS" and "SQL" helper is great'),
    t('tooljet-ai', freeTier:'Free open source edition', price:20, priceTier:'Business monthly', tips:'Leading open source internal tool builder | AI-powered "Low-code" components'),
    t('snappa', freeTier:'Free for up to 3 downloads/mo', price:15, priceTier:'Pro monthly annual', tips:'Best for non-designers | AI-powered "Resize" and templates are very intuitive'),
    t('befunky', freeTier:'Free basic version available', price:12, priceTier:'Pro monthly annual', tips:'All-in-one photo editor and collage maker | AI-powered "Enhance" and "Cartoonizer"'),
    t('pixlr', freeTier:'Free basic version available', price:1, priceTier:'Plus monthly annual', tips:'Best browser-based photo editor | AI-powered "Object Remover" and "Generative Fill"'),
    t('unscreen', freeTier:'Free limited downloads', price:2, priceTier:'Per character/second pricing', tips:'Best for removing backgrounds from videos/GIFs | AI-powered "Edge" detection is elite'),
    t('remnote', freeTier:'Free forever basic version', price:6, priceTier:'Pro monthly annual', tips:'Best for students and researchers | AI-powered "Flashcard" generation from notes'),
    t('vista-create', freeTier:'Free basic version available', price:13, priceTier:'Pro monthly annual', tips:'Best for 1M+ creative assets | AI-powered "Background Remover" for graphics'),
    t('buildship', freeTier:'Free with usage limits', price:25, priceTier:'Starter monthly annual', tips:'Leading low-code backend builder | AI-powered "Nodes" from natural language'),
    t('cohere-api', freeTier:'Free credits for developers', price:0, tips:'Leading RAG and enterprise LLM | AI-powered "Command" models are extremely fast'),
    t('ai21', freeTier:'Free API credits initially', price:0, tips:'Leading jurassic-series LLMs | Best for context-aware writing and summaries'),
    t('inflection-api', freeTier:'Free trial available on site', price:0, tips:'The "PI" personal intelligence API | Best for high-EQ conversational AI'),
    t('aleph-alpha', freeTier:'Free trial for developers', price:0, tips:'European leader in sovereign AI | Best for secure and private LLM deployments'),
    t('noodl', freeTier:'Free open source edition', price:0, tips:'Leading low-code app builder for enterprises | AI-powered "Node" logic help'),
    t('deepdreamgenerator', freeTier:'Free basic credits daily', price:19, priceTier:'Advanced monthly', tips:'Best for artistic AI art | AI-powered "Deep Style" and "Text 2 Dream" are elite'),
    t('leapai', freeTier:'Free forever playground', price:0, tips:'Best for building AI image workflows | AI-powered "Fine-tuning" for custom models'),
    t('astria', freeTier:'Free to explore, pay per model', price:5, priceTier:'Flat fee per training', tips:'The gold standard for AI "Avanar" training | Best for high-end professional avatars'),
    t('bigjpg', freeTier:'Free with speed limits', price:6, priceTier:'Premium 2 months access', tips:'Best for upscaling anime and illustrations | AI-powered "Noise" reduction'),
    t('neural-love', freeTier:'Free basic version available', price:30, priceTier:'Pro monthly credits', tips:'Best for restoring old photos and video | AI-powered "Sharpen" and "Colorize"'),
    t('snowpixel', freeTier:'Free trial available on site', price:15, priceTier:'Starter monthly credits', tips:'Best for social media managers | AI-powered "Bulk" creative generation'),
    t('autoblogging', freeTier:'Free credits initially', price:49, priceTier:'Starter monthly', tips:'Best for niche blogs | AI-powered "One-click" article generation with images'),
    t('ifttt', freeTier:'Free for up to 2 applets', price:3, priceTier:'Pro monthly annual', tips:'The pioneer of web automation | AI-powered "Summary" for busy teams'),
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
