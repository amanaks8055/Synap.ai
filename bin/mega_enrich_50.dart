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
    t('raindrop', freeTier: 'Free forever basic features', price: 3.5, priceTier: 'Pro monthly', tips: 'The ultimate AI bookmark manager | Use "Auto-tagging" and "Full-text search" to organize and find your research data across all devices and browsers instantly'),
    t('rasa-ai', freeTier: 'Open Source version completely free', price: 0, tips: 'The standard for enterprise Conversational AI | AI-powered "NLU" and "Dialogue Management" helps developers build and manage high-end, data-consistent bot assistants for complex domains'),
    t('pandorabots', freeTier: 'Free trial available for sandbox', price: 19, priceTier: 'Developer monthly starts', tips: 'One of the world\'s oldest and most reliable bot hosting services | AI-powered "AIML" engine helps you scale bot data to millions of end-users with high-fidelity conversational logic'),
    t('bitbucket-ai', freeTier: 'Free for up to 5 users', price: 3, priceTier: 'Standard per user', tips: 'The code management giant with AI integration | Use "Bitbucket Pipelines" and "Code Insights" to automate testing and security data checks directly within your dev workflow'),
    t('kubernetes-ai', freeTier: 'Open source core is free', price: 0, tips: 'The standard for container orchestration at scale | AI-powered "Keda" and "Autoscaling" helps manage infra data and compute resource allocation for massively distributed AI systems'),
    t('chatbox-app', freeTier: 'Free basic version available', price: 0, tips: 'The versatile desktop client for multiple AI models | Best for power users who want a high-end interface to manage their personal LLM data and prompts across OpenAI, Claude, and more'),
    t('tars', freeTier: 'Free trial available for 14 days', price: 99, priceTier: 'Business monthly starts', tips: 'High-end conversational landing page creator | AI-powered "Conversational UI" turns boring static data forms into high-converting chat experiences for top-tier marketing campaigns'),
    t('raindrop-pro', freeTier: 'Free basic account available', price: 3.5, priceTier: 'Pro monthly', tips: 'Professional research organization suite | Features "Broken Link Detection" and "Duplicate Finder" to maintain a perfect archive of your web-based research data'),
    t('rasa-pro', freeTier: 'Open Source base available', price: 0, tips: 'Enterprise-grade conversational data platform | Featuring advanced "Security" and "Scale" modules to handle massive volumes of sensitive customer interactions with high-end reliability'),
    t('pandorabots-pro', freeTier: 'Free sandbox access', price: 19, priceTier: 'Developer plan', tips: 'The pro choice for global bot hosting | AI-powered "API Access" allows you to integrate complex conversational data models directly into your mobile and web applications'),
    t('bitbucket-pro', freeTier: 'Free for small teams', price: 3, priceTier: 'Premium per user', tips: 'The "Admin\'s Choice" for Git repositories | AI-powered "Smart Commits" and "Audit Logs" ensure your team\'s code data follows strict enterprise compliance and security standards'),
    t('tars-ai-pro', freeTier: 'Free trial available on site', price: 99, priceTier: 'Professional monthly', tips: 'High-speed marketing automation suite | Use the "Data Dashboard" to analyze thousands of chat responses and lead data points to optimize your funnel automatically'),
    t('chatbox-expert', freeTier: 'Free basic account access', price: 0, tips: 'Advanced LLM interaction toolkit | AI-powered "Chat History" and "Search" handles your entire personal AI assistant research data distribute across multiple providers'),
    t('raindrop-app', freeTier: 'Free forever on all platforms', price: 3.5, priceTier: 'Pro monthly', tips: 'The king of smart bookmarking | Features high-accuracy "Web Archive" which saves permanent data copies of your favorite research pages even if they go offline'),
    t('rasa-expert', freeTier: 'Free open source core', price: 0, tips: 'The smartest way to build custom LLM bots | AI-powered "Data Training" tools ensures your entire customer support team follows specific business logic and data rules'),
    t('pandorabots-ai', freeTier: 'Free playground access', price: 19, priceTier: 'Pro monthly', tips: 'Leading platform for high-end "Character" AI | Best for building high-fidelity virtual assistants that maintain consistent persona data and history across all user sessions'),
    t('bitbucket-cloud', freeTier: 'Free for individuals', price: 3, priceTier: 'Standard per user', tips: 'Next-gen code hosting and CI/CD | AI-powered "Dependency Scanning" is world-class for modern software supply chain security and vulnerability data research'),
    t('kubernetes-pro', freeTier: 'Open source core is free', price: 0, tips: 'The expert choice for cloud-native AI | AI-powered "Scheduler" handles your entire model training and inference job data across thousands of cloud nodes'),
    t('tars-ai-solutions', freeTier: 'Free trial for businesses', price: 99, priceTier: 'Professional monthly', tips: 'The choice of world-class marketing teams | AI-powered "Flow Optimization" handles thousands of lead data captures simultaneously driven by deep behavioral research'),
    t('chatbox-ai-pro', freeTier: 'Free trial for pro features', price: 0, tips: 'High-end AI management suite | Use the "Prompt Manager" to organize thousands of complex instructions and research data patterns for world-class AI results'),
    t('raindrop-ai', freeTier: 'Free basic version available', price: 3.5, priceTier: 'Pro monthly', tips: 'The "Search Engine" for your own bookmarks | AI-powered "Smart Suggestions" uses millions of user tagging patterns for better global research data discovery'),
    t('rasa-enterprise', freeTier: 'Institutional focus', price: 0, tips: 'The the expert choice for mission-critical AI assistants | AI-powered "Analytics" and "Review" helps scale your support data and research with world-class accuracy'),
    t('pandorabots-intelligence', freeTier: 'Sandbox free trial', price: 19, priceTier: 'Pro monthly', tips: 'High-end conversational analytics suite | Featuring "Sentiment Detection" in complex user queries to help your bot data response better during pro research sessions'),
    t('bitbucket-ai-pro', freeTier: 'Free trial for pro', price: 3, priceTier: 'Premium per user', tips: 'The smarter way to manage code data | AI-powered "Pull Request Summaries" uses million of successful code merges data for better global dev reach'),
    t('tars-chatbot', freeTier: 'Free marketing trial', price: 99, priceTier: 'Standard monthly', tips: 'The pioneer of high-end conversational landing pages | Best for turning any technical ad traffic into a professional lead data performance for marketing'),
    t('chatbox', freeTier: 'Completely free (BYO API Key)', price: 0, tips: 'The ultimate AI interface for desktop | Best for power users find and managing their entire LLM data discovery and prompt sharing along your team'),
    t('raindrop-intelligence', freeTier: 'Free basic features', price: 3.5, priceTier: 'Pro monthly', tips: 'Leading platform for high-end "Personal" data archiving used by researchers globally to build their own searchable knowledge base of the web'),
    t('rasa-ai-pro', freeTier: 'Free trial for enterprise', price: 0, tips: 'The industry standard for high-accuracy conversational AI | AI-powered "Conversation Design" handles your entire bot data presence and security research'),
    t('bitbucket', freeTier: 'Free for 5 users', price: 3, priceTier: 'Standard per user', tips: 'The industry standard for enterprise Git | AI-powered "Repo" management handles your entire data presence and security research driven by deep research'),
    t('tars-ai', freeTier: 'Free trial available', price: 99, priceTier: 'Business monthly', tips: 'Leading platform for converting data traffic into leads | AI-powered "Lead Scoring" optimization ensures your brand follows specific data benchmarks for high-impact ROI'),
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
