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
    t('alphasense', freeTier:'Free trial for institutional users', price:0, tips:'The gold standard for market intelligence and search | AI-powered "Sentiment" and "Smart" notes used by top hedge funds and analysts'),
    t('roam-research', freeTier:'Free trial for 30 days', price:15, priceTier:'Professional monthly annual', tips:'The pioneer of networked thought | Best for building a "Personal Knowledge Graph" with bidirectional links and AI-powered data logs'),
    t('artbreeder', freeTier:'Free basic version available', price:9, priceTier:'Starter monthly annual', tips:'Leading platform for creative "Collage" and "Splicing" of AI images | Best for generating unique character portraits and worlds'),
    t('synthesia-education', freeTier:'Free basic video trial', price:30, priceTier:'Starter monthly annual', tips:'Specialized version of Synthesia for educators | Best for high-accuracy localized corporate training and school lessons'),
    t('socratic', freeTier:'Completely free for students', price:0, tips:'Google\'s official AI homework helper | Best for math, science, and history explanations with high-quality visual steps'),
    t('gimkit', freeTier:'Free forever basic version', price:5, priceTier:'Pro monthly annual', tips:'Leading classroom engagement game | AI-powered "Kit" creation and live data tracking for teachers and students'),
    t('mathgpt', freeTier:'Free limited daily queries', price:10, priceTier:'Premium monthly annual', tips:'Specialized LLM for mathematics | Best for high-complexity calculus, algebra, and step-by-step logic proofs'),
    t('century-tech', freeTier:'Institutional only', price:0, tips:'Leading AI for personalized school learning | AI-powered "Pathway" adapts to student knowledge gaps in real-time'),
    t('yoodli', freeTier:'Free forever basic version', price:0, tips:'The "Grammarly" for your speech | AI-powered "Analytics" on your filler words, pacing, and eye contact for better public speaking'),
    t('artbreeder-ai', freeTier:'Free daily credits', price:9, priceTier:'Starter monthly', tips:'High-end AI art fusion and generator | Use the "Mixer" tool to combine artistic styles and character features smoothly'),
    t('thunkable-ai', freeTier:'Free to build and preview', price:45, priceTier:'Pro monthly annual', tips:'Leading no-code mobile app builder | AI-powered "Logic" and "Data" integration used by 3M+ developers'),
    t('directus-ai', freeTier:'Free forever (self-hosted)', price:99, priceTier:'Cloud Standard monthly', tips:'Leading open source data platform | AI-powered "Queries" and "Insights" for headless CMS and internal tools'),
    t('stock-hero', freeTier:'Free trial for 5 trades', price:45, priceTier:'Lite monthly annual', tips:'Leading stock trading bot | AI-powered "Backtesting" and automated logic for retail investors without coding'),
    t('simplywall', freeTier:'Free basic version available', price:10, priceTier:'Premium monthly annual', tips:'Best for visual stock market analysis | AI-powered "Snowflake" chart gives instant health scores for any company'),
    t('composer', freeTier:'Free basic version available', price:30, priceTier:'Pro monthly annual', tips:'Leading platform for automated algorithmic trading | Build and backtest complex trading bots from natural language'),
    t('profile-pic', freeTier:'One-time payment per pack', price:20, priceTier:'Standard pack flat fee', tips:'Leading AI avatar generator for LinkedIn and social | Best for high-end professional headshots from your selfies'),
    t('aidoc', freeTier:'Institutional only', price:0, tips:'The world leader in clinical AI for radiology | Best for detecting life-threatening conditions like brain bleeds in real-time'),
    t('hims-hers', freeTier:'Free consultation trial', price:0, tips:'Leading telehealth giant | AI-powered "Treatment" matching for personal wellness and prescription health'),
    t('latenode', freeTier:'Free forever for 1 project', price:0, tips:'Leading low-code automation platform | Best for building complex backend logic with AI and custom code blocks'),
    t('semafind', freeTier:'Free trial available on site', price:0, tips:'Specialized AI for medical and legal data search | Best for finding "Hard-to-find" clinical evidence and data logs'),
    t('art-breeder', freeTier:'Free basic version', price:9, priceTier:'Starter monthly', tips:'The pioneer of AI-powered creative image breeding | Best for character designers and world builders'),
    t('thunkable', freeTier:'Free for personal starters', price:45, priceTier:'Pro monthly', tips:'The "Visual" app builder for teams | AI-powered "Screen" generation from simple text briefs'),
    t('yoodli-ai', freeTier:'Free basic version', price:0, tips:'The ultimate AI communication coach | Used by top executives and Toastmasters to master public speaking'),
    t('gimkit-pro', freeTier:'Free trial for teachers', price:5, priceTier:'Pro monthly', tips:'High-energy classroom games powered by data | AI-powered "Difficulty" balancing for student learning'),
    t('socratic-ai', freeTier:'Completely free (Google)', price:0, tips:'The smartest homework assistant | Use the camera to scan math problems for instant step-by-step help'),
    t('roam-research-pro', freeTier:'Free trial available', price:15, priceTier:'Standard monthly', tips:'The "Zettelkasten" method made digital | Best for researchers and writers managing massive interconnected data'),
    t('alphasense-pro', freeTier:'Institutional only', price:0, tips:'The Bloomberg of market intelligence | AI-powered "Synonyms" and data extraction finds info 10x faster'),
    t('directus', freeTier:'Free and open source', price:99, priceTier:'Cloud Standard', tips:'The leading low-code data platform | AI-powered "Internal tools" and backend management for teams'),
    t('sema4-ai', freeTier:'Institutional only', price:0, tips:'Leading health intelligence platform | Best for predictive patient care and genomic data analysis at scale'),
    t('speechling', freeTier:'Free forever basic version', price:19, priceTier:'Unlimited monthly annual', tips:'Best for language speaking practice | AI-powered "Comparison" checks your pronunciation against native speakers'),
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
