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
    t('linkedin-ai', freeTier:'Free basic profile features', price:39, priceTier:'Premium Career monthly', tips:'The world\'s #1 professional network | AI-powered "Writing Assistant" and "Job Matching" used by 1B+ pros to land jobs and build data-driven personal brands'),
    t('answerthepublic', freeTier:'Free basic search (3/day)', price:99, priceTier:'Individual monthly annual', tips:'Neil Patel\'s official keyword research giant | AI-powered "Search Listening" tool that visualizes everything people ask about your brand data'),
    t('later', freeTier:'Free forever for 1 social set', price:18, priceTier:'Starter monthly annual', tips:'The industry standard for Instagram planning | AI-powered "Best Time to Post" and "Caption" generation driven by Millions of user data points'),
    t('explodingthopics', freeTier:'Free basic trend newsletter', price:39, priceTier:'Pro monthly annual', tips:'Leading platform for finding products before they go viral | AI-powered "Global" data monitoring used by top VCs and e-com brands'),
    t('enhancv', freeTier:'Free forever basic resume builder', price:10, priceTier:'Pro monthly annual', tips:'Leading platform for modern resume design | AI-powered "Content Analysis" helps you improve your resume based on top job description data'),
    t('hypotenuse-ai', freeTier:'Free for up to 10 credits', price:24, priceTier:'Individual monthly annual', tips:'Best for e-commerce content automation | AI-powered "Bulk" product descriptions and blog generation for pro Shopify store data'),
    t('flick-ai', freeTier:'Free trial for 7 days', price:11, priceTier:'Solo monthly annual', tips:'Leading Instagram hashtag and growth tool | AI-powered "Social Media Assistant" generates captions, hashtags, and posts in one data flow'),
    t('kreado', freeTier:'Free basic version available', price:0, tips:'Leading AI video avatar platform for marketing | Best for high-accuracy localized corporate training and e-com videos using data personas'),
    t('linkedin-pro', freeTier:'Free Career tools', price:39, priceTier:'Premium monthly', tips:'High-end professional networking suite | AI-powered "Sales Navigator" handles thousands of lead data points for B2B teams'),
    t('answerthepublic-ai', freeTier:'Free search access', price:99, priceTier:'Pro monthly', tips:'The "Search Voice" of the world | AI-powered "Keyword Grouping" handles thousands of consumer queries for your marketing data reports'),
    t('later-ai-social', freeTier:'Free forever starter', price:18, priceTier:'Starter monthly', tips:'The smarter way to plan social media | AI-powered "Visual Planner" handles your entire Instagram and TikTok data distribution'),
    t('exploding-topics-pro', freeTier:'Free basic access', price:39, priceTier:'Pro monthly', tips:'The "Trend Forecasting" engine for pros | AI-powered "Meta" research used by top marketers to find the next big data opportunity'),
    t('enhancv-ai-pro', freeTier:'Free resume trial', price:10, priceTier:'Premium monthly', tips:'The industry standard for high-end resumes | AI-powered "Bullet Point" optimization is world-class for tech job data'),
    t('hypotenuse-pro', freeTier:'Free credit trial', price:24, priceTier:'Starter monthly', tips:'The content greenhouse for e-com | AI-powered "Product Description" engine used by top brands to manage their catalog data'),
    t('flick-pro', freeTier:'Free social trial', price:11, priceTier:'Solo monthly', tips:'The choice of top Instagram influencers | AI-powered "Analytics" helps you understand what social data drives the most growth'),
    t('kreado-ai', freeTier:'Free basic video', price:0, tips:'Next-gen AI marketing video suite | Best for high-fidelity "Persona" generation and international voiceover data flows'),
    t('kwfinder', freeTier:'10-day free trial on site', price:29, priceTier:'Basic monthly annual', tips:'Mangools\' official keyword research tool | Best for finding long-tail keywords with low SEO difficulty for your blog data'),
    t('growthnotes-ai', freeTier:'Free trial for 1 research project', price:0, tips:'Leading AI assistant for startup growth hackers | Best for automated competitor and market research data processing'),
    t('audiense', freeTier:'Free forever basic version', price:149, priceTier:'Basic monthly annual', tips:'Leading platform for audience intelligence | AI-powered "Segmentation" and "Cultural" insights driven by Twitter and Twitter data'),
    t('constructor-io', freeTier:'Institutional only', price:0, tips:'Leading AI for personalized e-commerce search | Best for world-class product discovery and automated data ranking for high-end stores'),
    t('later-pro', freeTier:'Free trial available', price:18, priceTier:'Starter monthly', tips:'Professional social planning suite | AI-powered "Automation" handles thousands of social data posts across 10+ platforms'),
    t('answerthepublic-pro', freeTier:'Free audit access', price:99, priceTier:'Individual monthly', tips:'Professional consumer research suite | AI-powered "Topic" discovery handles your entire brand search data'),
    t('kw-finder-ai', freeTier:'Free trial access', price:29, priceTier:'Basic monthly', tips:'The smarter way to find keywords | AI-powered "Historical" data and trend scores used by top SEO teams globally'),
    t('audiense-ai-pro', freeTier:'Free basic account', price:149, priceTier:'Advanced monthly', tips:'The Bloomerg of social intelligence | AI-powered "Audience" mapping handles millions of user data points for high-end research'),
    t('explodingtopics', freeTier:'Free trend newsletter', price:39, priceTier:'Pro monthly', tips:'Leading discovery platform for new startups | Best for finding high-growth data trends before they become mainstream'),
    t('later-ai', freeTier:'Free forever (Solo)', price:18, priceTier:'Starter monthly', tips:'The "Command Center" for social content | AI-powered "Caption Writer" uses million of successful post data for better reach'),
    t('flick', freeTier:'Free trial available', price:11, priceTier:'Solo monthly', tips:'The ultimate Instagram assistant | AI-powered "Hashtag" manager handles your entire social data discovery flow'),
    t('answerthe-public', freeTier:'Free search daily', price:99, priceTier:'Pro monthly', tips:'The king of search listener tools | Features high-accuracy "Visual" data maps of consumer questions and needs'),
    t('hypotenuse', freeTier:'Free trial credits', price:24, priceTier:'Starter monthly', tips:'The "Power-user" of e-commerce content | AI-powered "SEO" and "Product" descriptions handles your entire store data'),
    t('enhancv-pro', freeTier:'Free resume builder', price:10, priceTier:'Premium monthly', tips:'The elite career toolkit | Featuring high-end templates and AI-powered "Resume Score" used by top pro data scientists'),
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
