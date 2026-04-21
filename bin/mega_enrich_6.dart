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
    t('azure-ai', freeTier:'Free trial with \$200 credits', price:0, tips:'Microsoft\'s enterprise AI suite | Best for vision, speech, and language models at scale | Very robust'),
    t('adobe-acrobat-ai', freeTier:'Free for limited queries', price:5, priceTier:'AI Assistant monthly', tips:'Best for summarizing long PDFs and financial reports | AI-powered "One-click" insights'),
    t('languagetool', freeTier:'Free forever basic version', price:10, priceTier:'Premium monthly annual', tips:'Best alternative to Grammarly | AI-powered "Style" and "Tone" correction for 30+ languages'),
    t('ginger-ai', freeTier:'Free forever basic version', price:7, priceTier:'Premium monthly annual', tips:'Best for rephrasing sentences | AI-powered "Sentence Rephraser" adds flow to your writing'),
    t('decktopus-ai', freeTier:'Free basic version available', price:10, priceTier:'Pro monthly annual', tips:'Best for generated deck structures | AI-powered "Text to Presentation" for sales teams'),
    t('napkin-ai', freeTier:'Free basic version available', price:10, priceTier:'Pro monthly annual', tips:'Best for visual explainers | AI-powered "Visual" generation from plain text ideas'),
    t('picsart-ai', freeTier:'Free basic version available', price:5, priceTier:'Gold monthly annual', tips:'The world\'s #1 creative community | AI-powered "Avatar" and "Background" removal'),
    t('tailor-brands', freeTier:'Free to design and preview', price:10, priceTier:'Basic monthly annual', tips:'Best for small biz branding | AI-powered "Logo" and "Business" setup in one place'),
    t('namelix', freeTier:'Completely free to use', price:0, tips:'Best for finding business names | AI-powered "Domain" and "Logo" preview is very high quality'),
    t('bittensor', freeTier:'Free open source network', price:0, tips:'Decentralized AI network | Best for building crowdsourced machine learning models (Web3)'),
    t('render-token', freeTier:'Free to explore, pay for GPU', price:0, tips:'Decentralized GPU rendering | Best for huge AI and 3D tasks at a fraction of cloud costs'),
    t('ocean-ai', freeTier:'Free open protocols', price:0, tips:'Decentralized data exchange | Best for monetizing private AI datasets safely (Web3)'),
    t('crisp-ai', freeTier:'Free for personal starters', price:25, priceTier:'Pro monthly per user', tips:'Best for customer support | AI-powered "Noise Cancellation" and "Magic Replies"'),
    t('kommunicate', freeTier:'Free trial for 30 days', price:40, priceTier:'Lite monthly annual', tips:'Best for hybrid support | AI-powered "Kompose" chatbot integrates with every CRM'),
    t('adalo-ai', freeTier:'Free forever basic version', price:36, priceTier:'Starter monthly annual', tips:'Best for building mobile apps from natural language | AI-powered "Logic" components'),
    t('heights-platform', freeTier:'30-day free trial on site', price:19, priceTier:'Starter monthly annual', tips:'Best for course creators | AI-powered "Course Builder" and data tracking help'),
    t('airgram', freeTier:'Free for up to 5 meetings/mo', price:18, priceTier:'Professional monthly', tips:'Best for sales and HR meetings | AI-powered "Highlights" and "Summaries" sync with CRM'),
    t('audo-ai', freeTier:'Free basic recording available', price:12, priceTier:'Pro monthly annual', tips:'Best for cleaning up podcast audio | AI-powered "Noise Removal" is extremely effective'),
    t('voice-maker', freeTier:'Free basic voices daily', price:5, priceTier:'Basic monthly annual', tips:'Best for high-volume text to speech | AI-powered "Standard" and "Neural" voices'),
    t('sounds-ai', freeTier:'Free basic access', price:0, tips:'Meta\'s specialized AI music generator | Best for background audio in videos and games'),
    t('tactiq', freeTier:'Free for up to 10 meetings/mo', price:12, priceTier:'Pro monthly annual', tips:'Best for Google Meet and Zoom | AI-powered "Action Items" extracted in real-time'),
    t('sembly', freeTier:'Free forever basic version', price:10, priceTier:'Personal monthly annual', tips:'Best for team meeting archives | AI-powered "Automated Minutes" is very accurate'),
    t('omnivore', freeTier:'Completely free forever', price:0, tips:'Privacy-first read-it-later app | AI-powered "Library" and "Search" for long-form content'),
    t('lindy-ai', freeTier:'Free basic version available', price:20, priceTier:'Pro monthly annual', tips:'The first AI executive assistant | Best for managing calendars and emails autonomously'),
    t('vocalize-ai', freeTier:'Free trial available', price:10, priceTier:'Premium monthly', tips:'Best for unique vocal transformations | AI-powered "Voice Cloning" is very realistic'),
    t('riffusion', freeTier:'Completely free online tool', price:0, tips:'AI-powered music gen from visual spectrograms | Best for experimental and unique audio'),
    t('lateral', freeTier:'Free basic version available', price:0, tips:'Best for organizing research papers | AI-powered "Literature Review" and table extraction'),
    t('textio', freeTier:'Institutional only', price:0, tips:'The gold standard for augmented writing in HR | Best for inclusive job descriptions'),
    t('levity', freeTier:'Free 14-day trial on site', price:20, priceTier:'Starter monthly annual', tips:'Best for AI-powered data labeling and simple models | No-code way to build AI flows'),
    t('crowdin-ai', freeTier:'Free for open source', price:40, priceTier:'Pro monthly annual', tips:'Leading translation management for devs | AI-powered "Machine Translation" helper'),
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
