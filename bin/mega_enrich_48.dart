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
    t('raycast-ai', freeTier:'Free forever basic version (Mac app)', price:8, priceTier:'Pro monthly annual', tips:'The world leader in Mac productivity commands | AI-powered "Ask AI" and "Floating Notes" helps developers and pro users search, code, and manage window data across all apps instantly using natural language'),
    t('spark-email', freeTier:'Free forever basic version (Mobile/Desktop)', price:5, priceTier:'Premium monthly annual', tips:'The gold standard for smart email management | AI-powered "Smart Search" and "Write" features help you manage thousands of messages and data threads instantly with high-end research'),
    t('agorapulse-ai', freeTier:'Free forever basic version (3 profiles)', price:49, priceTier:'Standard monthly annual', tips:'Leading platform for professional social media management | AI-powered "Assistant" helps marketing teams create, schedule, and analyze thousands of posts and data across all major channels'),
    t('perplexity-pages', freeTier:'Free search trial available', price:20, priceTier:'Pro monthly annual', tips:'Leading platform for AI-powered research and content publishing | AI-powered "Pages" turns complex research queries into professional, shareable web data reports and articles instantly'),
    t('jina-ai', freeTier:'Free trial for 1 million tokens/mo (API)', price:0, tips:'Leading platform for multimodal AI and search embeddings | AI-powered "Reader" and "Embeddings" used by top tech companies to build high-end RAG and multimodal data systems'),
    t('agorapulse-pro', freeTier:'Free basic account', price:49, priceTier:'Standard monthly', tips:'High-end social media orchestration suite | AI-powered "Competitor" analysis and "Report" generation handles your entire client data distribution automatically'),
    t('spark-pro', freeTier:'Free individual access', price:5, priceTier:'Premium monthly', tips:'The "Safety First" tool for pro email management | Featuring high-end "Priority" and "Thread" management driven by your specific personal data history'),
    t('raycast-pro', freeTier:'Free individual access', price:8, priceTier:'Pro monthly', tips:'Professional productivity command suite | Featuring high-end "Theme Customization" and "Quick AI" driven by your specific personal data history for pro teams'),
    t('perplexity-pro', freeTier:'Free search credits', price:20, priceTier:'Pro monthly', tips:'Professional research intelligence suite | AI-powered "Data Analyst" ensures your entire team follows specific brand and data rules while searching'),
    t('jina-ai-pro', freeTier:'Free trial for business', price:0, tips:'Professional multimodal intelligence suite | AI-powered "Reranker" ensures your entire team follows specific data quality benchmarks during retrieval'),
    t('kagi-ai', freeTier:'Free trial for 100 searches/mo', price:10, priceTier:'Professional monthly annual', tips:'Leading ad-free and privacy-focused search engine with AI | AI-powered "Quick Answer" and "Summarize" helps you find accurate web data and research logs instantly'),
    t('cohere-embed', freeTier:'Free trial for developers (API)', price:0, tips:'Leading platform for high-end text embeddings and classification | AI-powered "Classify" and "Embed" used by enterprise teams to build high-accuracy RAG and data discovery apps'),
    t('spark-ai-plus', freeTier:'Free basic access', price:5, priceTier:'Premium monthly', tips:'Next-gen email intelligence engine | AI-powered "Draft" generation is world-class for modern support and data rights research across your brand'),
    t('raycast-expert', freeTier:'Free basic access', price:8, priceTier:'Team monthly', tips:'The smarter way to manage Mac workflows | AI-powered "Shared Snippets" and "Commands" ensures your entire team follows specific brand and data rules'),
    t('agorapulse-expert', freeTier:'Free trial available', price:49, priceTier:'Professional monthly', tips:'High-speed social marketing assistant | AI-powered "Analytics" and "Sync" handles your entire customer data discovery flow and CRM mapping'),
    t('perplexity-expert', freeTier:'Free trial available', price:20, priceTier:'Pro monthly', tips:'The expert choice for modern research | AI-powered "Discovery" finds hidden web gems and engagement data traditional guides miss based on your specific trip'),
    t('jina-expert', freeTier:'Free trial available', price:0, tips:'High-end multimodal search assistant | AI-powered "Relationship" and "Tagging" handles your entire data presence globally'),
    t('kagi-pro', freeTier:'Free basic credits', price:10, priceTier:'Ultimate monthly', tips:'The smarter way to search for privacy-conscious users | AI-powered "Orion" and "Crystal" handles your entire dataset discovery flow and report sharing'),
    t('cohere-intelligence', freeTier:'Free search credits', price:0, tips:'Leading platform for high-end "Text" data extraction used by top tech companies globally for enterprise safety'),
    t('spark-app', freeTier:'Free forever (Mobile/App)', price:5, priceTier:'Premium monthly', tips:'The "Engagement" king of email apps | Use the "Artistic" filters for high-impact schedule data and meeting sharing along your team'),
    t('raycast-app', freeTier:'Free forever online', price:8, priceTier:'Pro monthly', tips:'The king of smart productivity tools | Features high-accuracy "Comparison" data maps of work results and parameters'),
    t('agorapulse-app', freeTier:'Free forever online', price:49, priceTier:'Standard monthly', tips:'The "Command Center" for social managers | AI-powered "Alerting" and "Insight" driven by millions of consumer data points globally'),
    t('perplexity-ai', freeTier:'Free basic access', price:20, priceTier:'Pro monthly', tips:'The "Power-user" of research tools | AI-powered "Search" uses million of successful conversation data for better global data reach'),
    t('jina-ai-solutions', freeTier:'Free trial available', price:0, tips:'Next-gen multimodal intelligence suite | Best for turning any technical recording into a professional performance for gaming and media research'),
    t('kagi-ai-pro', freeTier:'Free trial for pro', price:10, priceTier:'Professional monthly', tips:'The ultimate resource for high-end search | Best for finding creative data flows that follow your brand\'s specific artistic data style'),
    t('cohere-ai-pro', freeTier:'Free trial for business', price:0, tips:'Professional enterprise intelligence engine | AI-powered "Model" management handles your entire enterprise data science and research driven by deep research'),
    t('spark-expert', freeTier:'Free basic tool', price:5, priceTier:'Premium monthly', tips:'The industry standard for high-end email automation | AI-powered "Analytics" and "Reporting" ensures your brand follows specific data benchmarks'),
    t('raycast-ai-pro', freeTier:'Free trial available', price:8, priceTier:'Pro monthly', tips:'High-speed productivity integration suite | AI-powered "Automation" handles thousands of search data queries simultaneously driven by deep data research'),
    t('agorapulse-ai-pro', freeTier:'Free trial for pro', price:49, priceTier:'Standard monthly', tips:'Leading platform for high-end "Social" data extraction used by world-class brands for global consumer safety'),
    t('perplexity-pages-pro', freeTier:'Free trial for pro', price:20, priceTier:'Pro monthly', tips:'The pioneer of high-end research content | Best for building high-accuracy data reports and articles that convert automatically'),
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
