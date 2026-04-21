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
    // Same tools as before...
    t('lumen5', freeTier:'Free video with watermark', price:11, priceTier:'Basic monthly annual', tips:'Best for turning blog posts into videos | Use "Custom" colors on paid plan'),
    t('kapwing-ai', freeTier:'Free for up to 4 mins video', price:16, priceTier:'Pro monthly annual', tips:'Best cloud video editor | AI-powered "Auto Subtitles" is extremely accurate'),
    t('wondershare-ai', freeTier:'Free trial with watermark', price:19, priceTier:'Pro monthly', tips:'Best for desktop editing | AI-powered "Smart Cutout" and "Audio Stretch"'),
    t('topaz-video', freeTier:'Free demo available', price:299, priceTier:'One-time purchase license', tips:'The industry standard for AI upscaling | Needs a powerful GPU for best speed'),
    t('hemingway', freeTier:'Free online web version', price:10, priceTier:'Editor Plus monthly', tips:'Best for bold and clear writing | Focus on "Grade" level below 9'),
    t('lex', freeTier:'Free for personal starters', price:0, tips:'AI-powered "Search" the web while writing | Best for long-form essays and books'),
    t('lovable', freeTier:'Free for personal projects', price:20, priceTier:'Pro monthly', tips:'Best for "Full-stack" apps from natural language | Replaces junior devs'),
    t('devin-ai', freeTier:'Waitlist/Institutional only', price:0, tips:'The first AI software engineer | Best for complex repo tasks and bug fixing'),
    t('cosine', freeTier:'Free for open source', price:0, tips:'Best for codebase understanding | AI-powered "Genie" can explain any file'),
    t('snyk', freeTier:'Free with scan limits', price:25, priceTier:'Individual monthly', tips:'Best for devsecops | AI-powered "Fix" suggestions for vuln code'),
    t('codacy', freeTier:'Free for open source', price:15, priceTier:'Pro monthly per user', tips:'Best for code quality and coverage | AI-powered "Reviews" on pull requests'),
    t('pictory', freeTier:'Free trial for 3 projects', price:19, priceTier:'Starter monthly annual', tips:'Best for faceless YouTube channels | AI-powered "Script to Video"'),
    t('captions-ai', freeTier:'Free basic version available', price:10, priceTier:'Pro monthly annual', tips:'Best for mobile creators | AI-powered "Eye Contact" and "Subtitles"'),
    t('podcast-ai', freeTier:'Free basic recording', price:30, priceTier:'Host monthly annual', tips:'Best for high end audio fixing | AI-powered "Speech Enhancement"'),
    t('voicemod-ai', freeTier:'Free basic voices daily', price:12, priceTier:'Pro one-time or monthly', tips:'Best for gamers and streamers | AI-powered "Custom" voices are cool'),
    t('blackbox-ai', freeTier:'Free daily limits basic', price:10, priceTier:'Pro monthly annual', tips:'The fastest AI coding assistant | Best for copy-pasting code from video'),
    t('pieces', freeTier:'Completely free for local', price:0, tips:'Best for saving code snippets | AI-powered "Context" search is local and fast'),
    t('shortlyai', freeTier:'Free trial for 300 words', price:65, priceTier:'Monthly annual', tips:'Best for fiction and storytelling | AI-powered "Expand" and "Rewrite"'),
    t('designs-ai', freeTier:'Free basic preview', price:19, priceTier:'Basic monthly', tips:'All-in-one suite | AI-powered "Logomaker" and "Video" generation'),
    t('lately-ai', freeTier:'Free trial available', price:49, priceTier:'Starter monthly annual', tips:'Best for B2B social media | AI-powered "Pillar" content atomization'),
    t('sprout-ai', freeTier:'30-day free trial on site', price:249, priceTier:'Standard monthly', tips:'Enterprise standard | AI-powered "Social Listening" and scheduling'),
    t('canva-social', freeTier:'Free basic version available', price:12, priceTier:'Pro monthly annual', tips:'Best for bulk Instagram/TikTok creation | AI-powered "Magic Media"'),
    t('loomly', freeTier:'15-day free trial on site', price:26, priceTier:'Base monthly annual', tips:'Best for small team approvals | AI-powered "Post" ideas and suggestions'),
    t('flair-ai', freeTier:'Free for first 30 images', price:10, priceTier:'Pro monthly', tips:'Best for product photography | AI-powered "Background" replacement'),
    t('booth-ai', freeTier:'Free demo available', price:199, priceTier:'Pro monthly starting', tips:'Best for e-commerce brands | AI-powered "Studio" for items'),
    t('narrato', freeTier:'Free trial for 7 days', price:19, priceTier:'Pro monthly annual', tips:'Best for content teams | AI-powered "Briefs" and scheduling'),
    t('workato', freeTier:'Institutional only', price:2000, priceTier:'Platform annual starting', tips:'Enterprise standard for automation | AI-powered "Recipes" for complex flows'),
    t('apify', freeTier:'Free with \$5 credits/month', price:41, priceTier:'Starter monthly annual', tips:'Best for web scraping at scale | AI-powered "Browslee" help'),
    t('phantom-buster', freeTier:'14-day free trial on site', price:48, priceTier:'Starter monthly annual', tips:'Best for LinkedIn and growth automation | AI-powered "Extraction"'),
    t('stack-ai', freeTier:'Free basic version available', price:200, priceTier:'Pro monthly starting', tips:'Best for building custom AI apps | Low-code node-based building'),
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
