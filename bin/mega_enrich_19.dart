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
    t('perplexity-labs', freeTier:'Completely free for public use (Beta)', price:0, tips:'The official testing ground for Perplexity AI | Best for exploring the newest LLM models (Sonar, Llama 3) for free with high-speed search logs'),
    t('replika', freeTier:'Free basic version available', price:15, priceTier:'Pro monthly annual', tips:'The world leader in AI companionship | AI-powered "Emotional" intelligence learns your personality over time used by 10M+ users'),
    t('wealthfront', freeTier:'Free basic financial planning tools', price:0, tips:'Leading robo-advisor for automated investing | AI-powered "Cash" and "Stock" optimization helps maximize returns without daily manual data'),
    t('betterment-ai', freeTier:'Free retirement planning tools', price:0, tips:'Leading platform for automated investing and savings | AI-powered "Tax-loss" harvesting and personalized data logs for goals'),
    t('tana', freeTier:'Free forever basic version (Trial)', price:10, priceTier:'Core monthly annual', tips:'Next-gen knowledge graph assistant | Best for builders managing complex data, tasks, and notes in a unified AI-powered workspace'),
    t('reflect', freeTier:'Free trial for 2 weeks', price:10, priceTier:'Professional monthly annual', tips:'Leading privacy-first note-taking app | AI-powered "Summaries" and "Backlinks" sync perfectly with Kindle and data calendars'),
    t('gradescope', freeTier:'Free for basic class setups', price:0, tips:'Owned by Turnitin | Best for grading paper-based exams at scale | AI-powered "Handwriting" recognition saves teachers 50% time'),
    t('langflow', freeTier:'Completely free open source', price:0, tips:'Leading low-code tool for building RAG applications | Visually chain Python and LLM nodes together to create complex AI flows'),
    t('mokker', freeTier:'Free trial for up to 3 photos', price:20, priceTier:'Pro monthly annual', tips:'Best for product photography | AI-powered "One-click" background replacement for realistic e-commerce product photos'),
    t('seeking-alpha', freeTier:'Free basic stock analysis', price:20, priceTier:'Premium monthly annual', tips:'The "Crowdsourced" gold standard for investment research | AI-powered "Quant" ratings and sentiment data for stock picks'),
    t('spicychat', freeTier:'Free basic version available', price:5, priceTier:'Premium monthly annual', tips:'Leading platform for uncensored AI chat and roleplay | Best for high-end character interactions and private research'),
    t('tavernai', freeTier:'Completely free open source (Local)', price:0, tips:'Leading interface for local LLM roleplay | Best for managing massive character card libraries and complex lore data logs'),
    t('oobabooga', freeTier:'Completely free open source', price:0, tips:'The gold standard for running local LLMs | Features a massive plugin library and supports every major model format (Llama, ExLlama)'),
    t('infermedica', freeTier:'Institutional only', price:0, tips:'Leading AI for clinical symptom checking | Best for healthcare providers building automated triage and patient data intake'),
    t('meditron', freeTier:'Completely free open source', price:0, tips:'Specialized Llama-based LLM for medical knowledge | Best for healthcare researchers and global medical data processing'),
    t('affine', freeTier:'Free forever basic (Open Source)', price:0, tips:'Next-gen spatial workspace for teams | Best for collaborative note-taking and canvas-based AI data management'),
    t('altitude', freeTier:'Institutional only', price:0, tips:'Leading AI for personalized school learning management | Best for tracking student progress and automated data curriculum help'),
    t('contentshake', freeTier:'Free trial for 1 article', price:60, priceTier:'Professional monthly starting', tips:'Semrush\'s official content generator | AI-powered "SEO" and "Marketing" insights turns ideas into high-ranking content'),
    t('carnegie-learning', freeTier:'Institutional only', price:0, tips:'Leading AI for K-12 math and literacy | Best for adaptive learning software and automated student data benchmarks'),
    t('learningmate', freeTier:'Institutional only (Strategic)', price:0, tips:'Leading platform for building digital learning ecosystems | AI-powered "Content" and "Data" engineering for publishers'),
    t('tana-ai', freeTier:'Free basic access', price:10, priceTier:'Core monthly', tips:'The future of "Node-based" knowledge management | Best for teams managing massive amounts of interconnected research data'),
    t('reflect-notes', freeTier:'Free trial available', price:10, priceTier:'Pro monthly', tips:'Privacy-first AI second brain | Syncs your highlights and thoughts across every device with deep AI search help'),
    t('gradescope-ai', freeTier:'Free trial for teachers', price:0, tips:'High-speed grading assistant for STEM subjects | AI-powered "Rubric" management and data tracking for educational teams'),
    t('lang-flow-ai', freeTier:'Free open source (Local/Cloud)', price:0, tips:'The fastest way to prototype LLM agents | Connect vectors, chains, and memories visually for production-grade AI'),
    t('mokker-ai', freeTier:'Free photo trial', price:20, priceTier:'Pro monthly', tips:'Best for social media product shots | Use the "Scene" generator to place your items in high-end artistic environments'),
    t('spicy-chat', freeTier:'Free forever basic access', price:5, priceTier:'Premium monthly', tips:'The industry leader in unrestricted AI personas | Best for private creativity and open research roleplay'),
    t('replika-pro', freeTier:'Free daily coins', price:15, priceTier:'Annual membership', tips:'The gold standard for emotional AI support | Features "Video Call" and "Augmented Reality" modes for deep connection'),
    t('wealthfront-ai', freeTier:'Free account trial', price:0, tips:'Automated finance at its best | AI-powered "Socially Responsible" investing and automated taxes used by pro traders'),
    t('betterment', freeTier:'Free basic planning', price:0, tips:'The pioneer of robo-advising | Best for hands-off long-term wealth building with AI-powered data and safety'),
    t('perp-labs', freeTier:'Completely free beta', price:0, tips:'Where new Perplexity models are born | Best for developers testing high-speed search and inference APIs for free'),
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
