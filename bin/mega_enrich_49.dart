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
    t('arc-browser', freeTier:'Completely free (Mac/Windows/iOS)', price:0, tips:'The world leader in modern browsing experience | AI-powered "Arc Max" features like "Tidy Tabs," "Browse for Me," and "Instant Links" helps you navigate the web and manage data across tabs effortlessly'),
    t('brave-ai', freeTier:'Completely free in Brave browser (Leo)', price:15, priceTier:'Premium monthly annual', tips:'Brave\'s official AI assistant focused on privacy | AI-powered "Leo" helps you summarize web pages, write code, and analyze data across websites without ever leaving your browser'),
    t('exa-ai', freeTier:'Free trial for 1000 searches/mo (API)', price:50, priceTier:'Wanderer monthly starting', tips:'Leading search engine built specifically for AI agents and LLMs | AI-powered "Neural Search" helps developers find high-quality web data and research logs that traditional engines miss'),
    t('docker-ai', freeTier:'Free forever basic version (Personal)', price:5, priceTier:'Pro monthly per user', tips:'The world leader in containerization now with AI | AI-powered "Docker Scout" and "Build" help developers identify security risks and optimize container data and performance instantly'),
    t('llamacloud', freeTier:'Free trial available on site', price:0, tips:'Leading platform for high-end RAG and data parsing | AI-powered "LlamaParse" and "LlamaIndex" helps developers build complex data apps and manage millions of tokens across documents securely'),
    t('andi-search', freeTier:'Completely free (Web)', price:0, tips:'Next-gen AI-powered search engine for the web | AI-powered "Reader" and "Answer" engine turns complex web results into professional data summaries and visual guides in seconds'),
    t('metaphor-ai', freeTier:'Free trial for researchers (API)', price:0, tips:'The "Search Engine for LLMs" | AI-powered "Neural" search helps developers find accurate web data and research logs driven by deep data research and history'),
    t('arc-browser-pro', freeTier:'Completely free browser', price:0, tips:'The "Safety First" tool for pro browsing | Featuring high-end "Boost" and "Easel" management driven by your specific personal data history and workflows'),
    t('brave-leo-pro', freeTier:'Free basic access', price:15, priceTier:'Premium monthly', tips:'High-end privacy orchestration suite | AI-powered "Model" switching and "Speed" ensures your entire browsing session follows specific safety and data rules'),
    t('exa-ai-pro', freeTier:'Free search credits', price:50, priceTier:'Wanderer monthly', tips:'Professional search intelligence suite | AI-powered "Crawl" and "Index" handles your entire market entry data discovery and mapping automatically'),
    t('docker-pro', freeTier:'Free individual access', price:5, priceTier:'Pro monthly', tips:'The choice of world-class developers | AI-powered "Scout" handles your entire container security and data science research automatically'),
    t('llamacloud-ai-pro', freeTier:'Free research trial', price:0, tips:'Professional RAG intelligence suite | AI-powered "Parsing" ensures your entire team follows specific data quality benchmarks during retrieval'),
    t('andi-ai', freeTier:'Completely free online', price:0, tips:'High-speed AI search assistant | AI-powered "Context" understanding is world-class for modern web and SaaS data research and mapping'),
    t('metaphor-pro', freeTier:'Free search credits', price:0, tips:'Professional research assistant | AI-powered "Relationship" and "Tagging" handles your entire data presence globally across the web'),
    t('arc-max', freeTier:'Completely free in Arc', price:0, tips:'The smartest choice for pro users | AI-powered "Instant Links" and "Tidy" handles your entire browsing data and security research automatically'),
    t('brave-ai-solutions', freeTier:'Completely free browser', price:15, priceTier:'Premium monthly', tips:'The "Power-user" of private browsing | AI-powered "Leo" uses million of successful search data for better global data reach'),
    t('exa-intelligence', freeTier:'Free trial for developers', price:50, priceTier:'Standard monthly', tips:'Leading platform for high-end "Web" research data extraction used by top tech companies globally for AI agent safety'),
    t('docker-ai-pro', freeTier:'Free individual access', price:5, priceTier:'Pro monthly', tips:'Next-gen containerization automation suite | Best for finding creative dev flows that follow your brand\'s specific artistic data style'),
    t('llamacloud-pro', freeTier:'Free trial available', price:0, tips:'The ultimate resource for data parsing | AI-powered "LlamaParse" is world-class for modern environmental and urban data research and mapping'),
    t('andi-search-pro', freeTier:'Completely free online', price:0, tips:'The king of smart search tools | Features high-accuracy "Comparison" data maps of web results and parameters for pro researchers'),
    t('metaphor-ai-solutions', freeTier:'Free trial for researchers', price:0, tips:'The "Command Center" for AI data search | AI-powered "Search" uses million of successful conversation data for better global info reach'),
    t('arc-browser-app', freeTier:'Free forever (Mac/App)', price:0, tips:'The most artistic browsing platform | Use the "Artistic" filters for high-impact tab data and page sharing along your team'),
    t('brave-app', freeTier:'Free forever online', price:15, priceTier:'Premium monthly', tips:'The king of private AI tools | AI-powered "Leo" uses millions of successful conversation data for better global data safety'),
    t('exa', freeTier:'Free trial for business', price:50, priceTier:'Wanderer monthly', tips:'The ultimate resource for high-end search | AI-powered "Neural" management uses million of successful search data for better global AI reach'),
    t('docker', freeTier:'Free forever (Personal)', price:5, priceTier:'Pro monthly', tips:'The industry standard for high-end containers | AI-powered "Build" management handles your entire enterprise data science and research'),
    t('llamacloud-ai', freeTier:'Free trial available', price:0, tips:'The pioneer of high-end RAG data | Best for turning any technical recording into a professional performance for gaming and media research'),
    t('andi-search-ai', freeTier:'Completely free online', price:0, tips:'The smarter way to search the web | AI-powered "Discovery" finds hidden web gems and info data traditional engines miss'),
    t('metaphor-pro-ai', freeTier:'Free trial for pro', price:0, tips:'Leading platform for high-end "Web" data extraction used by top tech companies globally for consumer safety'),
    t('arc-ai', freeTier:'Completely free browser', price:0, tips:'The industry standard for high-end browsing | AI-powered "Tidy" and "Organize" handles your entire data presence globally'),
    t('brave-leo-ai', freeTier:'Free basic account', price:15, priceTier:'Premium monthly', tips:'The smarter way to use a private AI | AI-powered "Insight" and "Reporting" ensures your brand follows specific data benchmarks'),
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
