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
    t('github', freeTier:'Free for personal/public repos', price:4, priceTier:'Team monthly per user', tips:'The world\'s #1 coding platform | AI-powered "Copilot" is a must-have for speed'),
    t('postman-ai', freeTier:'Free for up to 3 users/collab', price:12, priceTier:'Basic monthly annual', tips:'Best for API testing | AI-powered "Postman Echo" and "Tests" generator'),
    t('rapidapi', freeTier:'Free for basic API keys', price:0, tips:'The world\'s #1 API marketplace | AI-powered "Discovery" helps find the best models fast'),
    t('swagger-ai', freeTier:'Free open source tools', price:0, tips:'Industry standard for API docs | AI-powered "OpenAPI" generator and mock data logs'),
    t('ilovepdf', freeTier:'Free forever basic version', price:7, priceTier:'Premium monthly annual', tips:'Best for simple PDF tasks | AI-powered "OCR" and "Compression" are very fast'),
    t('nanonets', freeTier:'Free for first 100 pages', price:499, priceTier:'Starter monthly starting', tips:'Best for automated data extraction from receipts | AI-powered "OCR" is elite'),
    t('docsumo', freeTier:'Free for up to 50 pages', price:500, priceTier:'Growth monthly annual', tips:'Best for complex document parsing | AI-powered "Custom" field extraction for teams'),
    t('rossum', freeTier:'Free trial available on site', price:0, tips:'Enterprise document gateway | AI-powered "Transactional" data capture with low setup'),
    t('turnitin-ai', freeTier:'Institutional only', price:0, tips:'The gold standard for plagiarism detection | AI-powered "Writing" and "AI" detector for schools'),
    t('copyleaks', freeTier:'Free basic version available', price:10, priceTier:'Pro monthly annual', tips:'Best for detecting AI-generated text | AI-powered "Similarity" and "Grammar" reports'),
    t('kickresume', freeTier:'Free basic templates available', price:19, priceTier:'Premium monthly annual', tips:'Best for beautiful AI resumes | AI-powered "Bullet Points" based on your job title'),
    t('jobscan-ai', freeTier:'Free trail for 5 scans', price:49, priceTier:'Monthly membership', tips:'Best for ATS optimization | AI-powered "Keyword" matching for your target job'),
    t('rezi-ai', freeTier:'Free basic version available', price:20, priceTier:'Pro monthly annual', tips:'Leading AI-powered resume builder | AI-powered "Real-time" feedback on your draft'),
    t('siri-ai', freeTier:'Completely free on Apple devices', price:0, tips:'Apple\'s built-in vocal assistant | AI-powered "Shortcuts" for complex automation flows'),
    t('samsung-bixby', freeTier:'Completely free on Samsung devices', price:0, tips:'Samsung\'s vocal assistant | AI-powered "Bixby Vision" is great for visual search'),
    t('mycroft', freeTier:'Completely free open source', price:0, tips:'The open-source privacy vocal assistant | AI-powered "Skills" can be built by anyone'),
    t('reverso', freeTier:'Free forever basic version', price:11, priceTier:'Premium monthly annual', tips:'Best for context-aware translation | AI-powered "Contextual" examples are very high quality'),
    t('trinka-ai', freeTier:'Free forever basic version', price:7, priceTier:'Premium monthly annual', tips:'Best for academic and medical writing | AI-powered "Publication" readiness checks'),
    t('scribbr', freeTier:'Free for basic citations', price:0, tips:'Best for proofreading and APA/MLA formatting | AI-powered "Plagiarism" check is very high quality'),
    t('nanonets-ai', freeTier:'Free for up to 100 pages/mo', price:499, priceTier:'Pro monthly starting', tips:'The industry leader in OCR | AI-powered "Machine Learning" models for any document'),
    t('parseur', freeTier:'Free forever basic (20 docs)', price:39, priceTier:'Starter monthly annual', tips:'Best for extracting data from emails | AI-powered "Extraction" rules are very solid'),
    t('drift-chat', freeTier:'Free basic version available', price:2500, priceTier:'Premium annual starting', tips:'Best for B2B sales acceleration | AI-powered "Conversational" marketing chatbot'),
    t('codility', freeTier:'Free trial for HR teams', price:0, tips:'Leading coding test platform | AI-powered "Integrity" check and skill assessments'),
    t('vervoe', freeTier:'Free trial available on site', price:0, tips:'Best for skill-based testing | AI-powered "Auto-grading" for candidate assessments'),
    t('karat-ai', freeTier:'Institutional only', price:0, tips:'Leading technical interviewing platform | AI-powered "Interview" help and benchmarks'),
    t('chainGPT', freeTier:'Free for basic blockchain data', price:0, tips:'Leading AI for crypto and blockchain | AI-powered "Smart Contract" generator and auditor'),
    t('arduino-ai', freeTier:'Free open source tools', price:0, tips:'Leading platform for IoT | AI-powered "Cloud" and "Code" help for hardware projects'),
    t('i-love-pdf-ai', freeTier:'Free forever basic version', price:7, priceTier:'Premium monthly annual', tips:'Best for bulk PDF editing | AI-powered "Convert" and "Sign" in one place'),
    t('whitesmoke', freeTier:'No free version available', price:5, priceTier:'Essential monthly annual', tips:'Old school grammar king | AI-powered "Style" and "Tone" correction for professional writing'),
    t('upfluence', freeTier:'Institutional only', price:0, tips:'Best for influencer marketing at scale | AI-powered "Campaign" management and ROI tracking'),
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
