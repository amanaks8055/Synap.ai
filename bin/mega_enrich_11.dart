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
    t('wolfram-gpt', freeTier:'Free basic computational queries', price:12, priceTier:'Personal monthly annual', tips:'The gold standard for computational knowledge | Best for math, chemistry, and high-fidelity data queries'),
    t('docusign-ai', freeTier:'Free trial for 3 document sends', price:10, priceTier:'Personal monthly annual', tips:'The world leader in digital signatures | AI-powered "Agreement Summaries" and "Agreement Analyzer"'),
    t('planner-5d', freeTier:'Free forever basic version', price:7, priceTier:'Premium monthly annual', tips:'Best for interior design enthusiasts | AI-powered "Magic Layout" creates rooms from floor plans'),
    t('circleboom-ai', freeTier:'Free basic management tools', price:17, priceTier:'Pro monthly annual', tips:'Leading social media manager tool | AI-powered "Post" generator and automated hashtag data'),
    t('tavily', freeTier:'Free for up to 1k searches/mo', price:0, tips:'Best AI search engine for developers (RAG) | AI-powered "Search" and "Scrape" in one API call'),
    t('placeit', freeTier:'Free basic designs available', price:15, priceTier:'Unlimited monthly subscription', tips:'Owned by Envato | Best for high-end mockups | AI-powered "Logo" and "T-shirt" placement help'),
    t('smartmockups', freeTier:'Free basic mockups trial', price:14, priceTier:'Pro monthly annual', tips:'Best for product presentations | AI-powered "One-click" device and apparel mockups from your designs'),
    t('ironclad', freeTier:'Institutional only', price:0, tips:'Leading platform for enterprise contract management | AI-powered "Contract Intelligence" for legal teams'),
    t('casetext', freeTier:'Institutional only', price:0, tips:'Owned by Thomson Reuters | Best for legal research | AI-powered "CoCounsel" handles paralegal tasks'),
    t('luminance', freeTier:'Institutional only', price:0, tips:'Leading AI for legal document review | AI-powered "Diligence" and "Investigation" tools for law firms'),
    t('reimagine-home', freeTier:'Free forever basic version', price:10, priceTier:'Pro monthly credits', tips:'Best for virtual staging | AI-powered "Furniture" and "Style" replacement for real estate photos'),
    t('foyr-neo', freeTier:'14-day free trial on site', price:44, priceTier:'Standard monthly annual', tips:'Leading interior design tool for pros | AI-powered "Lightning" and "Rendering" is extremely fast'),
    t('metaphor', freeTier:'Free trial for developers', price:0, tips:'Redefining search with neural links | Best for finding content with context that traditional search misses'),
    t('mediamodifier', freeTier:'Free forever basic version', price:9, priceTier:'Professional monthly annual', tips:'Best for social media mockups | AI-powered "Design" and "Image" editors for fast graphics'),
    t('socialbu-ai', freeTier:'Free for up to 2 accounts', price:8, priceTier:'Standard monthly annual', tips:'Best for multi-platform scheduling | AI-powered "Feed" and "Chat" automation for teams'),
    t('stencil-ai', freeTier:'Free for up to 10 images/mo', price:9, priceTier:'Pro monthly annual', tips:'Best for blog graphics | AI-powered "Social" and "Quote" generation for fast content'),
    t('picmonkey', freeTier:'Free trial available on site', price:7, priceTier:'Basic monthly annual', tips:'Owned by Shutterstock | Best for easy photo editing | AI-powered "Touch Up" and "Design"'),
    t('wikipedia-ai', freeTier:'Completely free open archives', price:0, tips:'The largest knowledge base in the world | AI-powered "Summaries" and "Citation" checks help research'),
    t('mediamodifier-ai', freeTier:'Free basic downloads monthly', price:9, priceTier:'Pro monthly annual', tips:'High-end mockup and image editing suite | AI-powered "Product" photo placement is very easy'),
    t('adobe-post', freeTier:'Free part of Creative Cloud', price:10, priceTier:'Premium monthly', tips:'Now part of Adobe Express | Best for vertical video and social stories | AI-powered "Layout"'),
    t('andi-ai', freeTier:'Completely free to use', price:0, tips:'Next-gen AI search engine | Best for finding direct answers and summaries without ad clutter'),
    t('boosted-ai', freeTier:'Institutional only', price:0, tips:'Leading AI for quantitative investment | AI-powered "Stock Selection" and "Portfolio" optimization help'),
    t('stencils', freeTier:'Free for personal starters', price:9, priceTier:'Pro monthly annual', tips:'Leading platform for building custom stencils and graphics | AI-powered "Design" help'),
    t('proton', freeTier:'Free basic email account', price:4, priceTier:'Mail Plus monthly annual', tips:'The pioneer of private and secure tech | AI-powered "Phishing" and "Spam" detection is elite'),
    t('latch-ai', freeTier:'Institutional only', price:0, tips:'Leading AI for construction and property management | AI-powered "Documentation" and "Workflow" help'),
    t('lexion', freeTier:'Institutional only', price:0, tips:'Best for finance and operations legal tasks | AI-powered "Contract" extraction and automation'),
    t('unity-ml', freeTier:'Completely free open source', price:0, tips:'The gold standard for AI in gaming | Training intelligent agents using reinforcement learning in Unity'),
    t('google-translate-ai-pro', freeTier:'Free API credits initially', price:0, tips:'The advanced version of Google\'s translation engine | AI-powered "Custom" and "Domain-specific" models'),
    t('raspberry-ai', freeTier:'Free open source tools', price:0, tips:'Leading platform for edge computing | AI-powered "Inference" on small hardware for IoT projects'),
    t('gcp-ai', freeTier:'Free trial with \$300 credits', price:0, tips:'Google Cloud\'s full AI suite | Best for Vertex AI, BigQuery ML, and high-end training at scale'),
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
