// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'env.dart';

Map<String, dynamic> t(String id, String name, String cat, String desc,
    String url, bool free, bool featured, int clicks,
    {String? freeTier, double? price, String? priceTier, String? tips}) {
  String domain;
  try {
    domain = Uri.parse(url).host;
    if (domain.isEmpty) domain = url.replaceAll('https://', '').split('/').first;
  } catch (_) {
    domain = url.replaceAll('https://', '').split('/').first;
  }
  return {
    'id': id,
    'name': name,
    'slug': id,
    'category_id': cat,
    'description': desc,
    'icon_emoji': '🤖',
    'icon_url': 'https://logo.clearbit.com/$domain',
    'website_url': url,
    'has_free_tier': free,
    'is_featured': featured,
    'click_count': clicks,
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
    // ━━━ AI FOR RETAIL & FASHION (Iconic) ━━━
    t('stitch-fix-ai','Stitch Fix (AI)','lifestyle','Leading personalized styling service using AI to match clothes to your style.','https://stitchfix.com',true,true,350000, freeTier:'Free style quiz online', price:20, priceTier:'Styling fee (credited to buy)', tips:'The pioneer of AI fashion | Best for personal style | High data trust'),
    t('far-fetch-ai-pro','Farfetch (AI)','lifestyle','Leading luxury fashion marketplace using AI for personalized discovery.','https://farfetch.com',true,true,500000, freeTier:'Completely free to browse', price:0, tips:'AI-powered "Visual Search" | Best for luxury items | Global scale'),
    t('zalando-ai-pro','Zalando (AI)','lifestyle','European fashion giant using AI-powered "Size Assistant" and virtual try-on.','https://zalando.com',true,true,999999, freeTier:'Completely free for the public', price:0, tips:'AI-powered "Size Advice" is elite | Best for EU fashion | high reliability'),
    t('nike-fit-ai-pro','Nike Fit (AI)','lifestyle','Nike\'s AI-powered app that scans your feet for the perfect shoe size.','https://nike.com',true,true,999999, freeTier:'Included with Nike app', price:0, tips:'Uses computer vision and AI | Best for performance shoes | Iconic'),
    t('warby-ai-pro-fit','Warby Parker (Virtual Try-on)','lifestyle','Leading eyewear brand using AI-powered AR for virtual glasses try-on.','https://warbyparker.com',true,true,500000, freeTier:'Completely free virtual try-on', price:0, tips:'Best-in-class AR/AI | Home try-on is also available | High trust'),

    // ━━━ AI FOR LEGAL & GOV (Iconic) ━━━
    t('harvey-ai-pro-legal','Harvey AI','business','The world\'s most powerful legal AI assistant for elite law firms.','https://harvey.ai',false,true,150000, freeTier:'Institutional only', price:0, tips:'The gold standard for legal AI | Best for contract review | Extremely secure'),
    t('case-text-ai-pro','CoCounsel (Casetext)','business','Leading legal research and brief writing assistant using high-end AI.','https://casetext.com',true,true,120000, freeTier:'Free trial for law firms', price:0, tips:'Owned by Thomson Reuters | Best for litigation | High accuracy'),
    t('spellbook-ai-legal','Spellbook','business','Leading contract drafting and review assistant that works inside MS Word.','https://spellbook.com',true,true,84000, freeTier:'Free demo available', price:0, tips:'Best for transactional lawyers | AI-powered "Risk" detect | high trust'),
    t('iron-clad-ai-legal','Ironclad (AI)','business','Leading digital dynamic contract platform with AI-powered data and logs.','https://ironcladapp.com',false,true,58000, freeTier:'Institutional only', price:0, tips:'Best for legal teams | AI-powered "Smart Import" | Industry giant'),
    t('legal-zoom-ai-pro','LegalZoom (AI)','business','Leading legal service platform with AI-powered documentation and help.','https://legalzoom.com',true,true,350000, freeTier:'Free basic setup (excluding fees)', price:0, tips:'Best for startups and LLCs | AI-powered "Compliance" | High trust'),

    // ━━━ AI FOR REAL ESTATE (Global Giants) ━━━
    t('zillow-ai-pro-est','Zillow (Zestimate)','lifestyle','The world\'s #1 real estate site using high-end AI for the "Zestimate".','https://zillow.com',true,true,999999, freeTier:'Completely free online data', price:0, tips:'AI-powered "Estimate" is the industry standard | Best for home search'),
    t('red-fin-ai-pro-est','Redfin (Hot Homes)','lifestyle','Leading brokerage site using AI to predict "Hot Homes" and fast sales.','https://redfin.com',true,true,500000, freeTier:'Completely free data and app', price:0, tips:'AI-powered "Forecast" | Best for serious buyers | high visibility'),
    t('realtor-ai-pro-data','Realtor.com (AI)','lifestyle','Leading property search using AI-powered "Dream Home" matching.','https://realtor.com',true,true,500000, freeTier:'Completely free data and app', price:0, tips:'The official NAR search site | AI-powered "Local" market data | reliable'),
    t('com-pass-ai-pro-re','Compass (AI)','lifestyle','Tech-first brokerage platform using AI-powered tools for agents and buyers.','https://compass.com',true,true,350000, freeTier:'Completely free app and site', price:0, tips:'Best for modern agents | AI-powered "Likely to Sell" scores | clean UI'),
    t('opendoor-ai-pro','Opendoor (iBuyer)','lifestyle','Leading iBuyer platform using AI-powered "Offer" engine for home sales.','https://opendoor.com',true,true,250000, freeTier:'Free instant cash offer', price:0, tips:'AI-powered "valuation" | Best for fast sales | market leader'),

    // ━━━ AI FOR CRYPTO & WEB3 (Elite) ━━━
    t('trm-labs-ai-pro','TRM Labs','code','Blockchain intelligence platform using AI to detect fraud and sanctions risks.','https://trmlabs.com',false,true,150000, freeTier:'Institutional only', price:0, tips:'AI-powered transaction tracing | Strong compliance workflows | Built for institutions'),
    t('elliptic-ai-pro-web','Elliptic','code','Leading crypto risk management and compliance with AI-powered monitoring.','https://elliptic.co',false,true,84000, freeTier:'Institutional only', price:0, tips:'Best for institutional crypto | AI-powered "Detection" | Global reach'),
    t('dune-ai-pro-data','Dune Analytics','code','The world\'s #1 community crypto data platform with new AI "Wizard".','https://dune.com',true,true,250000, freeTier:'Free forever basic version', price:0, tips:'AI-powered "Query" help | Best for blockchain research | Iconic'),
    t('nansen-ai-pro-web3','Nansen','code','Leading crypto analytics using AI-powered wallet labels and "Alpha".','https://nansen.ai',true,true,180000, freeTier:'Free basic version online', price:99, priceTier:'Standard monthly annual', tips:'AI-powered "Labels" are elite | Best for smart money tracking | High trust'),
    t('arkham-ai-pro-web3','Arkham Intelligence','code','Leading blockchain intelligence platform using AI for "De-anonymization".','https://arkhamintelligence.com',true,true,150000, freeTier:'Completely free currently', price:0, tips:'AI-powered "Ultra" engine | Best for tracking funds | Rapidly growing'),

    // ━━━ FINAL GEMS v41 (Modern AI DBs) ━━━
    t('pine-cone-ai-pro','Pinecone','code','The world\'s #1 vector database built for high-performance AI apps.','https://pinecone.io',true,true,350000, freeTier:'Free forever starter plan', price:70, priceTier:'S1 monthly base', tips:'Best for long-term memory | AI-powered "Vector" search | Industry leader'),
    t('weaviate-ai-pro','Weaviate','code','Leading open-source vector database for AI with multi-modal and search.','https://weaviate.io',true,true,180000, freeTier:'Free with sandbox cluster', price:25, priceTier:'Standard monthly cluster', tips:'Best for hybrid search | AI-powered "GraphQL" for vectors | Modern choice'),
    t('qdrant-ai-pro-vec','Qdrant','code','Leading high-performance vector database with high-end filtering and API.','https://qdrant.tech',true,true,120000, freeTier:'Free cloud tier available', price:0, tips:'Best for rust-based speed | AI-powered "Filtering" | High reliability'),
    t('chroma-db-ai-pro','Chroma','code','The open-source embedding database for building AI applications with Python.','https://trychroma.com',true,true,150000, freeTier:'Completely free open source', price:0, tips:'Best for LangChain and local dev | AI-powered "Native" Python API | Fast'),
    t('mil-vus-ai-pro-db','Milvus (Zilliz)','code','Leading enterprise vector database for massive scale AI and data labs.','https://milvus.io',true,true,84000, freeTier:'Free open source and trial', price:0, tips:'Best for billion-scale vectors | AI-powered "Cloud" managed | Robust'),
  ];

  print('Total tools to upload: ${tools.length}');

  const supaPath = '$supabaseUrl/rest/v1/ai_tools';
  const batchSize = 25;
  var uploaded = 0;

  for (var i = 0; i < tools.length; i += batchSize) {
    final end = (i + batchSize > tools.length) ? tools.length : i + batchSize;
    final batch = tools.sublist(i, end);
    final bodyBytes = utf8.encode(jsonEncode(batch));

    try {
      final req = await client.postUrl(Uri.parse(supaPath));
      req.headers.set('apikey', anonKey);
      req.headers.set('Authorization', 'Bearer $anonKey');
      req.headers.set('Content-Type', 'application/json; charset=utf-8');
      req.headers.set('Prefer', 'resolution=merge-duplicates');
      req.contentLength = bodyBytes.length;
      req.add(bodyBytes);
      final resp = await req.close();
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        uploaded += batch.length;
        print('OK $uploaded/${tools.length}');
      } else {
        final respBody = await utf8.decodeStream(resp);
        print('FAIL at $i [${resp.statusCode}]: $respBody');
      }
    } catch (e) {
      print('ERR at $i: $e');
    }
  }

  client.close();
  print('DONE! Uploaded $uploaded tools with full pricing data');
}
