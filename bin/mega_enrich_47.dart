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
    t('metricool-ai', freeTier:'Free forever basic version (1 brand)', price:18, priceTier:'Starter monthly annual', tips:'The world leader in social media analytics and management | AI-powered "Assistant" helps you generate and schedule thousands of posts and analyze engagement data across all channels instantly'),
    t('phind-api', freeTier:'Free trial for researchers and public data', price:20, priceTier:'Pro monthly annual', tips:'The gold standard for AI-powered developer search | AI-powered "Pro" and "API" helps developers find accurate code and documentation and manage complex data queries instantly'),
    t('tavily-ai', freeTier:'Free trial for 1000 searches/mo', price:0, tips:'Leading search engine optimized for LLMs and AI agents | AI-powered "Research" and "Extraction" helps you find high-quality web data and research logs instantly for your AI projects'),
    t('chroma-db', freeTier:'Completely free open source (Local)', price:0, tips:'Leading open-source embedding database for AI applications | AI-powered "Vector" storage and retrieval used by top tech companies to build high-end RAG data systems and LLM apps'),
    t('vectara', freeTier:'Free forever basic version (50MB storage)', price:0, tips:'Leading platform for high-end Trusted Generative AI | AI-powered "Semantic Search" and "RAG" handles your entire dataset discovery flow and info retrieval securely for enterprise'),
    t('serper-ai', freeTier:'Free trial for 2500 credits', price:50, priceTier:'Maker monthly starting', tips:'Leading platform for high-accuracy Google Search API for AI | Best for developers building search-based data apps and info retrieval systems and research logs instantly'),
    t('opera-aria', freeTier:'Completely free in Opera browser', price:0, tips:'Opera\'s official AI browser assistant | AI-powered "Browsing" and "Writing" help turns web searches into professional data summaries and blog posts in seconds'),
    t('metricool-pro', freeTier:'Free basic account', price:18, priceTier:'Starter monthly', tips:'High-end social media orchestration suite | AI-powered "Competitor" analysis and "Report" generation handles your entire client data distribution automatically'),
    t('phind-pro', freeTier:'Free individual access', price:20, priceTier:'Pro monthly', tips:'The "Safety First" tool for pro developers | Featuring high-end "Model Switching" and "Context" management driven by your specific personal data history'),
    t('tavily-ai-pro', freeTier:'Free search trial', price:0, tips:'Professional research intelligence suite | AI-powered "Filtering" and "Scoring" ensures your entire team follows specific brand and data rules'),
    t('chroma-pro', freeTier:'Free open source (Local)', price:0, tips:'The "Infrastructure" of modern RAG | AI-powered "Embedding" and "Similarity" search handles your entire enterprise data science and research driven by deep research'),
    t('vectara-pro', freeTier:'Free trial available', price:0, tips:'Enterprise-grade search intelligence suite | Featuring high-end "Hallucination" detection in complex corporate environments using deep data research and history'),
    t('serper-pro', freeTier:'Free search credits', price:50, priceTier:'Standard monthly', tips:'The choice of world-class developers | AI-powered "Map" and "News" search handles your entire market entry data discovery and mapping automatically'),
    t('aria-browser-ai', freeTier:'Completely free in-browser', price:0, tips:'Next-gen browsing assistant for pro users | AI-powered "Context" understanding is world-class for modern web and SaaS data research and mapping'),
    t('metricool-expert', freeTier:'Free trial available', price:18, priceTier:'Advanced monthly', tips:'High-speed social marketing assistant | AI-powered "Analytics" and "Sync" handles your entire customer data discovery flow and CRM mapping'),
    t('phind-ai', freeTier:'Free basic credits', price:20, priceTier:'Individual monthly', tips:'The smarter way to find code | AI-powered "Natural Language" understanding used by million-dollar tech companies for high-accuracy developer data search'),
    t('tavily-intelligence', freeTier:'Free research trial', price:0, tips:'Leading platform for high-end "Web" data extraction used by top tech companies globally for AI agent safety'),
    t('chroma-ai', freeTier:'Completely free open source', price:0, tips:'The pioneer of high-end vector databases | Best for turning any technical recording into a professional performance for gaming and media research'),
    t('vectara-intelligence', freeTier:'Free trial for pro', price:0, tips:'The smarter way to build RAG apps | AI-powered "Analytics" and "Reporting" ensures your entire team follows specific data quality benchmarks'),
    t('serper-ai-pro', freeTier:'Free trial available', price:50, priceTier:'Professional monthly', tips:'High-speed search integration suite | AI-powered "Automation" handles thousands of search data queries simultaneously driven by deep data research'),
    t('metricool-pro-ai', freeTier:'Free trial for pro', price:18, priceTier:'Starter monthly', tips:'The most artistic social media management platform | Use the "Artistic" filters for high-impact post data and social sharing along your team'),
    t('phind', freeTier:'Free forever (Web)', price:20, priceTier:'Premium monthly', tips:'The king of developer search tools | Features high-accuracy "Comparison" data maps of code results and parameters for pro software engineering'),
    t('chroma', freeTier:'Free forever (Solo)', price:0, tips:'The "Power-user" of vector storage | AI-powered "Embedding" management uses million of successful search data for better global AI reach'),
    t('serper', freeTier:'Free trial for business', price:50, priceTier:'Maker monthly', tips:'The ultimate resource for high-end search APIs | Best for finding creative data flows that follow your brand\'s specific artistic data style'),
    t('aria-ai', freeTier:'Free basic account', price:0, tips:'The smarter way to browse the web | AI-powered "Discovery" finds hidden web gems and info data traditional engines miss based on your specific trip'),
    t('metricool-automation', freeTier:'Free trial available', price:18, priceTier:'Advanced monthly', tips:'Professional social analytics platform | AI-powered "Alerting" and "Insight" driven by millions of consumer data points globally'),
    t('phind-api-pro', freeTier:'Free trial available', price:20, priceTier:'Individual monthly', tips:'Next-gen developer intelligence engine | AI-powered "Model" management handles your entire enterprise data science and research driven by deep research'),
    t('chroma-expert', freeTier:'Completely free online', price:0, tips:'The industry standard for high-end RAG data extraction used by top tech companies globally for AI safety'),
    t('vectara-ai-pro', freeTier:'Free trial available', price:0, tips:'Professional search intelligence suite | AI-powered "Query" optimization ensures your brand voice follows specific data benchmarks'),
    t('serper-intelligence', freeTier:'Free research trial', price:50, priceTier:'Standard monthly', tips:'Leading platform for high-end "Search" data analytics | AI-powered "Risk" and "Opportunity" reports handles your public infrastructure image data globally'),
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
