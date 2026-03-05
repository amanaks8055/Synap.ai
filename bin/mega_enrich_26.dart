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
    t('ubersuggest', freeTier:'Free basic version for 3 searches/day', price:12, priceTier:'Individual monthly annual', tips:'Neil Patel\'s official SEO tool | AI-powered "Keyword" and "Content" ideas helps you find low-competition opportunities instantly'),
    t('browse-ai', freeTier:'Free trial for 50 credits', price:19, priceTier:'Starter monthly annual', tips:'The easiest way to scrape and monitor any website | AI-powered "Robot" learns to extract data in clicks without any coding'),
    t('cloudcraft', freeTier:'Free trial available on site', price:49, priceTier:'Professional monthly per user', tips:'Owned by Datadog | Best for designing AWS architectures | AI-powered "Live" data sync and cost estimation for cloud engineers'),
    t('diagrams-ai', freeTier:'Completely free open source (Draw.io)', price:0, tips:'The gold standard for whiteboarding and diagrams | AI-powered "Prompt to Diagram" creates complex flowcharts and layouts instantly'),
    t('ubersuggest-ai', freeTier:'Free basic access', price:12, priceTier:'Individual monthly', tips:'Leading platform for digital marketing data | Use the "AI Writer" to generate high-ranking blog posts based on top-performing keywords'),
    t('browse-ai-pro', freeTier:'Free research credits', price:19, priceTier:'Starter monthly', tips:'High-speed web intelligence for sales teams | Best for monitoring competitor prices and inventory data automatically'),
    t('cloud-craft-ai', freeTier:'Free trial available', price:49, priceTier:'Pro monthly', tips:'The "CAD" for cloud architects | AI-powered "Visualization" turns complex AWS infra into professional documentation in minutes'),
    t('draw-io-ai', freeTier:'Completely free (Local/Cloud)', price:0, tips:'The smarter version of Diagrams.net | Best for building architectural data maps and system flows for technical reports'),
    t('describely', freeTier:'Free trial for 10 products', price:10, priceTier:'Core monthly annual', tips:'Best for e-commerce store owners | AI-powered "Bulk" product descriptions and SEO data for Shopify and Amazon stores'),
    t('magical', freeTier:'Free forever basic version', price:12, priceTier:'Core monthly annual', tips:'Leading AI productivity extension | AI-powered "Automation" handles repetitive data entry and messaging across any web app instantly'),
    t('haystack', freeTier:'Completely free open source', price:0, tips:'Leading framework for building RAG applications | Best for developers creating production-grade LLM applications with complex data pipelines'),
    t('katteb', freeTier:'Free trial for 2000 words', price:15, priceTier:'Starter monthly annual', tips:'The "Fact-checked" AI writer | AI-powered "Real-time" search verifies every claim to ensure high-accuracy content for news and science'),
    t('mem0', freeTier:'Completely free open source', price:0, tips:'Leading memory layer for AI agents | Best for developers building personalized assistants that remember user preferences and data over time'),
    t('vue-ai', freeTier:'Institutional only', price:0, tips:'Leading AI for retail and e-commerce personalization | AI-powered "Visual" product recommendations and data tagging used by global brands'),
    t('barilliance', freeTier:'Institutional only', price:0, tips:'Leading platform for e-com personalization | AI-powered "Real-time" recommendations and abandoned cart flows driven by deep buyer data'),
    t('plannable', freeTier:'Free trial for 50 posts', price:11, priceTier:'Basic monthly annual', tips:'Best for social media teams and agencies | AI-powered "Approval" and "Collaboration" workflows handles all your brand content data'),
    t('ubersuggest-pro', freeTier:'Free search trial', price:12, priceTier:'Pro monthly', tips:'Professional SEO intelligence suite | Use the "Site Audit" to find technical errors and AI-powered "Opportunity" data logs'),
    t('browseai', freeTier:'Free trial credits', price:19, priceTier:'Starter monthly', tips:'The "No-code" scraper for busy teams | Best for building price trackers and lead lists from any website in minutes'),
    t('cloudcraft-ai', freeTier:'Free trial available', price:49, priceTier:'Pro monthly', tips:'High-end cloud design and cost planning | Features deep "AWS" and "Azure" data integration for accurate architectural reports'),
    t('magical-ai-pro', freeTier:'Free basic extension', price:12, priceTier:'Individual monthly', tips:'The ultimate productivity assistant | Features world-class "Auto-fill" and data transfer used by top sales and HR teams'),
    t('haystack-ai', freeTier:'Free open source (Deepset)', price:0, tips:'The pioneer of enterprise LLM search | Best for building complex multi-modal AI agents with deep data reasoning and retrieval'),
    t('mem-0-ai', freeTier:'Free open source repo', price:0, tips:'The "Long-term Memory" for your agents | Features incredible "Contextual" recall and data privacy for high-end AI research'),
    t('describely-ai', freeTier:'Free product credits', price:10, priceTier:'Core monthly', tips:'Advanced e-com content automation | AI-powered "Branding" ensures every product description follows your specific data guidelines'),
    t('katteb-ai-pro', freeTier:'Free word limit', price:15, priceTier:'Pro monthly', tips:'The future of journalistic AI writing | Use the "Verified" mode to ensure your articles are backed by the latest web data'),
    t('plannable-ai', freeTier:'Free collaboration trial', price:11, priceTier:'Starter monthly', tips:'The "Command Center" for social media | Use the "Grid" view for high-end visual planning of your brand\'s Instagram data'),
    t('vue-ai-retail', freeTier:'Institutional only', price:0, tips:'The smarter way to sell fashion | AI-powered "Tagging" and "Attribute" extraction handles your entire catalog data automatically'),
    t('barilliance-pro', freeTier:'Institutional only', price:0, tips:'Next-gen e-commerce growth engine | AI-powered "Behavioral" targeting driven by millions of user data points'),
    t('ubersuggest-enterprise', freeTier:'Free audit access', price:12, priceTier:'Elite monthly', tips:'Leading platform for massive-scale SEO research | AI-powered "Competitive" data helps you beat the world\'s largest brands'),
    t('cloudcraft-pro', freeTier:'Free trial available', price:49, priceTier:'All-in-one monthly', tips:'The expert choice for cloud documentation | AI-powered "Live View" handles thousands of AWS resource data updates in real-time'),
    t('magical-app', freeTier:'Free starter extension', price:12, priceTier:'Core monthly', tips:'The "One-click" data entry tool | Features incredible "Cross-site" data mapping used by top recruiters and sales pros globally'),
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
