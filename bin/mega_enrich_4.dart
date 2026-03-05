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
    t('opus-pro', freeTier:'Free 30 mins trial', price:9, priceTier:'Essential monthly', tips:'Best for turning long YouTube videos into shorts | AI-powered "Virality Score" is elite'),
    t('repurpose-io', freeTier:'Free 14-day trial on site', price:12, priceTier:'Content Marketer monthly annual', tips:'Best for multi-channel distribution | AI-powered "Auto-publish" from TikTok to Reels'),
    t('typefully', freeTier:'Free basic version available', price:12, priceTier:'Creator monthly annual', tips:'Best for Twitter/X threads | AI-powered "Rewrite" and "Review" helps growth'),
    t('taplio', freeTier:'Free basic browser extension', price:39, priceTier:'Starter monthly annual', tips:'Best for LinkedIn personal branding | AI-powered "Viral" hook generator'),
    t('shield-app', freeTier:'10-day free trial on site', price:12, priceTier:'Creator monthly annual', tips:'Best for LinkedIn analytics | AI-powered "Content" performance tracking'),
    t('glide-ai', freeTier:'Free forever with usage limits', price:25, priceTier:'Maker monthly annual', tips:'Best for building custom business apps from sheets | AI-powered "Text" and "Image" components'),
    t('retool-ai', freeTier:'Free for up to 5 users', price:10, priceTier:'Team monthly annual', tips:'The industry standard for internal tools | AI-powered "Queries" and "UI" generation'),
    t('google-translate', freeTier:'Completely free forever', price:0, tips:'The world\'s #1 translation tool | AI-powered "Neural" results are highly accurate for major languages'),
    t('apple-translate', freeTier:'Completely free on Apple devices', price:0, tips:'Best for private and offline translation | AI-powered "On-device" processing'),
    t('papago', freeTier:'Completely free online app', price:0, tips:'Naver\'s elite translation engine | Best for Korean and East Asian languages'),
    t('smartcat', freeTier:'Free trial for developers', price:0, tips:'Best for enterprise localization | AI-powered "Translation Memory" saves 50% on costs'),
    t('lokalise-ai', freeTier:'14-day free trial on site', price:120, priceTier:'Essential monthly annual', tips:'Best for software localization | AI-powered "Quality Check" and "Context"'),
    t('phrase-ai', freeTier:'14-day free trial on site', price:0, tips:'Leading enterprise translation platform | AI-powered "Morgue" data and logs'),
    t('unbabel', freeTier:'Institutional only', price:0, tips:'Best for customer service translation | AI-powered "Quality Estimation" is elite'),
    t('eightfold', freeTier:'Institutional only', price:0, tips:'The leader in AI-powered talent intelligence | Best for skills-based hiring at scale'),
    t('phenom', freeTier:'Institutional only', price:0, tips:'The "Talent Experience" leader | AI-powered "Chatbot" and "Personalization" for candidates'),
    t('manatal', freeTier:'14-day free trial on site', price:15, priceTier:'Professional monthly annual', tips:'Best for modern agencies | AI-powered "Parsing" and "Ranking" for resumes'),
    t('parabola', freeTier:'Free 14-day trial on site', price:80, priceTier:'Solo monthly annual', tips:'Best for complex e-com data flows | No-code way to build data pipelines'),
    t('talend', freeTier:'Free trial available on site', price:0, tips:'Owned by Qlik | Industry giant for data integration | AI-powered "Data Quality" help'),
    t('eightfold-ai', freeTier:'Institutional only (Strategic)', price:0, tips:'The pioneer of skills-based hiring | AI-powered "Talent Intelligence" platform'),
    t('tome-ai', freeTier:'Free basic credits available', price:10, priceTier:'Pro monthly annual', tips:'Best for fast generative slide decks | USE "DALL-E" mode for unique visuals'),
    t('musicgen', freeTier:'Completely free open source', price:0, tips:'Meta\'s high-end music generator | Best for researchers and local audiophiles'),
    t('trip-planner', freeTier:'Completely free basic trip', price:0, tips:'Best for fast itinerary generation | AI-powered "Route" and "Booking" help'),
    t('charisma-ai', freeTier:'Free trial available', price:0, tips:'Leading AI for interactive characters and storytelling | Best for RPG and game writers'),
    t('stitch-fix', freeTier:'Styling fee credited to buy', price:20, priceTier:'Styling Fee per fix', tips:'The gold standard for AI-powered fashion | Best for unique personal style'),
    t('zyler', freeTier:'Free demo available', price:0, tips:'Best for fashion virtual try-on | AI-powered "Physics" for clothes is elite'),
    t('cala-ai', freeTier:'Free trial for designers', price:0, tips:'Best for fashion production management | AI-powered "Design" and "Supply" help'),
    t('lykdat', freeTier:'Free for up to 100 images', price:23, priceTier:'Standard monthly', tips:'Best for fashion visual search | AI-powered "Apparel" tagging for stores'),
    t('systran', freeTier:'Free online translation', price:5, priceTier:'Standard monthly annual', tips:'The pioneer of machine translation | Best for high security and private translation'),
    t('publer', freeTier:'Free forever basic version', price:12, priceTier:'Professional monthly annual', tips:'Best for social media scheduling | AI-powered "Post" ideas are very creative'),
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
