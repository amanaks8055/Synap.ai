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
    t('nvidia-ai', freeTier:'Free to explore, pay for GPU usage', price:0, tips:'The world leader in AI hardware and software | Best for high-end training and inference (Jetson, NeMo)'),
    t('boston-dynamics', freeTier:'Institutional only', price:0, tips:'The gold standard for mobile robotics | AI-powered "Spot" and "Atlas" are the most advanced in the world'),
    t('you-chat', freeTier:'Free forever basic version', price:15, priceTier:'YouPro monthly annual', tips:'Best for search-integrated chat | AI-powered "Citations" and "Multimodal" search are elite'),
    t('pi-ai', freeTier:'Completely free to use', price:0, tips:'Inflection\'s high-EQ AI companion | Best for personal coaching and deep conversation'),
    t('terraform-ai', freeTier:'Free open source edition', price:20, priceTier:'Standard monthly per user', tips:'The industry standard for IaC | AI-powered "Registry" and "Cloud" help with complex setups'),
    t('playwright-ai', freeTier:'Completely free open source', price:0, tips:'Leading modern E2E testing framework | AI-powered "Codegen" and "Trace Viewer" are extremely fast'),
    t('selenium-ai', freeTier:'Completely free open source', price:0, tips:'The industry standard for web automation | AI-powered "IDE" and custom grids for legacy testing'),
    t('cypress-ai', freeTier:'Free forever basic version', price:75, priceTier:'Team monthly starting', tips:'Best for frontend developer testing | AI-powered "Cloud" and "Dashboard" for large teams'),
    t('k6-ai', freeTier:'Free open source tool', price:0, tips:'Best for load testing at scale | AI-powered "Cloud" reporting from Grafana labs'),
    t('amazon-textract', freeTier:'Free for first 1k pages', price:0, tips:'AWS leader in document extraction | AI-powered "Queries" for highly structured data'),
    t('google-docai', freeTier:'Free trial with credits', price:0, tips:'Leading platform for building custom document flows | AI-powered "Procurement" and "Identity" models'),
    t('writer-ai', freeTier:'14-day free trial on site', price:18, priceTier:'Team monthly per user', tips:'Best for enterprise content teams | AI-powered "Styleguide" and "Compliance" checks'),
    t('ink-editor', freeTier:'Free basic version available', price:35, priceTier:'Pro monthly annual', tips:'Best for SEO writing | AI-powered "Optimization" score is very accurate for ranking'),
    t('fetch-ai', freeTier:'Free open protocols', price:0, tips:'Leading agentic AI for the spatial web | AI-powered "uAgents" for decentralized logic (Web3)'),
    t('anima-ai', freeTier:'Free basic version available', price:31, priceTier:'Pro monthly annual', tips:'Best for turning designs into high-quality code | AI-powered "Figma to Code" is very clean'),
    t('anyscale', freeTier:'Free trial with credits', price:0, tips:'The creators of Ray | Best for scaling Python and AI workloads across clusters at high speed'),
    t('steve-ai', freeTier:'Free for up to 3 downloads/mo', price:15, priceTier:'Basic monthly annual', tips:'Best for text-to-animated-video | AI-powered "Avatar" and "Scene" logic is very easy'),
    t('vidnoz', freeTier:'Free daily credits available', price:10, priceTier:'Starter monthly annual', tips:'Best for talking head videos | AI-powered "Avatar" synthesis is very high speed'),
    t('autocut', freeTier:'Free trial available on site', price:15, priceTier:'Pro monthly', tips:'Best for editing "Talking Head" videos | AI-powered "Silent Cut" saves hours of work'),
    t('mathpix', freeTier:'Free for up to 10 scans/mo', price:5, priceTier:'Pro monthly annual', tips:'The world leader in OCR for math and science | AI-powered "Latex" and "MS Word" export'),
    t('percy', freeTier:'Free for 5k screenshots/mo', price:0, tips:'Owned by BrowserStack | Best for visual regression testing | AI-powered "Diff" engine'),
    t('applitools', freeTier:'Free trial available on site', price:0, tips:'The gold standard for AI-powered visual testing | Best for complex cross-browser UI/UX'),
    t('mabl-ai', freeTier:'14-day free trial on site', price:0, tips:'Leading intelligent test automation | AI-powered "Self-healing" tests reduce maintenance by 90%'),
    t('forter', freeTier:'Institutional only', price:0, tips:'Leading e-commerce fraud prevention | AI-powered "Decision" engine is extremely accurate at scale'),
    t('lyrebird', freeTier:'Part of Descript basic', price:15, priceTier:'Creator monthly annual', tips:'Pioneer of AI voice cloning | Best for high-end "Overdub" in podcasting'),
    t('riffusion-audio', freeTier:'Completely free online tool', price:0, tips:'Unique music gen from images | Best for experimental and atmospheric background audio'),
    t('singularity', freeTier:'Free open protocols', price:0, tips:'Decentralized AI marketplace | Best for finding niche algorithms and high-end AI labs (Web3)'),
    t('phlanx', freeTier:'Free trial for 7 days', price:25, priceTier:'Basic monthly annual', tips:'Best for social media audit | AI-powered "Engagement" calculator for influencers'),
    t('reverso-ai', freeTier:'Free forever basic version', price:11, priceTier:'Premium monthly annual', tips:'The "DeepL" of multilingual writing help | AI-powered "Context" is extremely good'),
    t('mabl', freeTier:'14-day free trial on site', price:0, tips:'Intelligent E2E testing leader | AI-powered "Automated" test regression and data'),
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
