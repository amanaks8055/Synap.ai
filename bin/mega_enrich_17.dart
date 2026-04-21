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
    t('palantir', freeTier:'Institutional only', price:0, tips:'The world leader in enterprise data analysis | AI-powered "Foundry" and "Gotham" platforms used by governments and Fortune 500s'),
    t('calm', freeTier:'Free basic version available', price:15, priceTier:'Premium monthly annual', tips:'The gold standard for meditation and sleep | AI-powered "Smart" recommendations for stress and focus used by 100M+ users'),
    t('noom', freeTier:'Free 14-day trial period', price:70, priceTier:'Monthly membership annual', tips:'Leading AI-powered weight loss and fitness app | Best for psychological and behavioral change in diet'),
    t('livongo', freeTier:'Institutional/Insurance only', price:0, tips:'Owned by Teladoc | Best for chronic condition management | AI-powered "Real-time" coaching for diabetes'),
    t('bardeen', freeTier:'Free forever basic version', price:10, priceTier:'Pro monthly annual', tips:'Leading browser-based automation tool | AI-powered "Magic Box" builds complex workflows from natural language'),
    t('gumloop', freeTier:'Free forever basic version', price:0, tips:'Leading low-code automation for browser tasks | Best for web scraping and data extraction without technical coding'),
    t('pickaxe', freeTier:'Free trial available on site', price:39, priceTier:'Standard monthly annual', tips:'Best for building custom AI apps and tools without code | Features deep GPT-4 and custom data integration'),
    t('tempus', freeTier:'Institutional only', price:0, tips:'Leading AI for precision medicine | Best for genomic data and cancer research used by top hospitals worldwide'),
    t('flatiron', freeTier:'Institutional only (Strategic)', price:0, tips:'Owned by Roche | The goal standard for oncology data | AI-powered "Real-world Evidence" for cancer researchers'),
    t('mendel', freeTier:'Institutional only', price:0, tips:'Leading AI for clinical trials and data parsing | AI-powered "Clinical" data extraction from patient records'),
    t('finviz', freeTier:'Free basic stock visualizer', price:25, priceTier:'Elite monthly annual', tips:'Leading stock market visualizer | AI-powered "Pattern Recognition" and advanced screener data'),
    t('kensho', freeTier:'Institutional only', price:0, tips:'Owned by S&P Global | The gold standard for financial AI | Best for structured data and high-end market analysis'),
    t('fliki', freeTier:'Free 5 mins trial monthly', price:21, priceTier:'Standard monthly annual', tips:'Leading platform for turning scripts into videos | AI-powered "Voice" and "Stock" matching for social creators'),
    t('hour-one', freeTier:'Free trial available on site', price:25, priceTier:'Lite monthly annual', tips:'Leading AI video avatar platform | Best for high-accuracy corporate training and news broadcasting'),
    t('galileo', freeTier:'Free trial available on site', price:0, tips:'Next-gen UI generation tool | Best for turning ideas into editable high-quality Figma designs instantly'),
    t('hatchful', freeTier:'Completely free online tool', price:0, tips:'Shopify\'s official logo generator | AI-powered "Industry" specific templates for small biz branding'),
    t('listening', freeTier:'Free trial for 2 weeks', price:15, priceTier:'Standard monthly annual', tips:'The world leader in turning academic papers into audio | AI-powered "Research" reading for busy docs'),
    t('ilus', freeTier:'Free basic version available', price:0, tips:'Leading platform for generating beautiful stylised icons | AI-powered "Icon" design that follows your brand style'),
    t('rivet', freeTier:'Completely free open source', price:0, tips:'The developer IDE for building with LLMs | Best for visually chaining prompts and testing data flows (Web3)'),
    t('doceree', freeTier:'Institutional only', price:0, tips:'Leading AI for physician-targeted marketing | AI-powered "Precision" messaging for pharmaceutical brands'),
    t('Gumloop-AI', freeTier:'Free basic access', price:0, tips:'Next-gen web automation assistant | Best for complex multi-step browser scraping and data formatting'),
    t('Bardeen-AI', freeTier:'Free forever (Starter)', price:10, priceTier:'Pro monthly', tips:'The "Zapier" for your browser | AI-powered "Auto-scrape" and data entry used by top founders'),
    t('Calm-AI-Pro', freeTier:'Free daily meditations', price:15, priceTier:'Premium monthly', tips:'High-end mental wellness suite | Use the "Daily Calm" for AI-powered personalized focus sessions'),
    t('Noom-AI-Pro', freeTier:'Free consultation trial', price:70, priceTier:'Monthly', tips:'The smartest weight loss tracker | AI-powered "Medication" and "Nutritional" data logs'),
    t('Fliki-AI', freeTier:'Free video credits', price:21, priceTier:'Standard monthly', tips:'Best for repurposing blogs into videos | AI-powered "Voiceover" and media matching is very fast'),
    t('Hour-One-AI', freeTier:'Free basic video', price:25, priceTier:'Lite monthly', tips:'Enterprise-grade AI personas | Best for automated HR training and localized global videos'),
    t('Hatchful-Logo', freeTier:'Completely free (Shopify)', price:0, tips:'The fastest way to get a professional logo | Use the "Artistic" filters for unique small biz looks'),
    t('Gumloop-Pro', freeTier:'Free trial available', price:0, tips:'The "Auto-GPT" for your browser | AI-powered "Recursive" data gathering for high-end research'),
    t('Pickaxe-AI', freeTier:'Free basic access', price:39, priceTier:'Standard monthly', tips:'Best for monetizing your AI prompts | Build custom internal tools with deep data integration'),
    t('subtle-medical', freeTier:'Institutional only', price:0, tips:'Leading AI for medical imaging | Best for accelerating MRI and CT scans while maintaining quality'),
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
