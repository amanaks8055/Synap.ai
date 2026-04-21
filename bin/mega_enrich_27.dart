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
    t('coschedule', freeTier:'Free forever basic marketing calendar', price:29, priceTier:'Individual monthly annual', tips:'The world leader in marketing management | AI-powered "Mia" assistant helps you plan, write, and schedule your entire content strategy data in one calendar'),
    t('mention', freeTier:'Free trial for 14 days', price:41, priceTier:'Solo monthly annual', tips:'Leading platform for real-time media monitoring | AI-powered "Sentiment" and "Topic" analysis used by global brands to track every web data mention'),
    t('teal-hq', freeTier:'Free forever basic career tools', price:9, priceTier:'Plus weekly starting', tips:'Leading AI platform for job seekers | AI-powered "Resume" and "Application" tracker used by 1M+ pros to land jobs at top tech companies'),
    t('careerflow', freeTier:'Free forever basic extension', price:15, priceTier:'Pro monthly annual', tips:'Best for LinkedIn optimization | AI-powered "profile" and "Apply" help turns your LinkedIn presence into a high-converting lead magnet for recruiters'),
    t('persado', freeTier:'Institutional only', price:0, tips:'The gold standard for motivation-aware AI content | AI-powered "Emotional" science drives billions in revenue for top retailers by personalizing every word of data'),
    t('missinglettr', freeTier:'Free forever for 1 workspace', price:7, priceTier:'Solo monthly annual', tips:'Best for automated social campaigns | AI-powered "Curate" and "Drip" campaigns turn one blog post into a year of social media data automatically'),
    t('recombee', freeTier:'Free for up to 100k requests/mo', price:0, tips:'Leading AI recommendation engine for developers | Best for building high-end "Personalized" product and content feeds driven by real-time user data'),
    t('coschedule-ai', freeTier:'Free basic access', price:29, priceTier:'Solo monthly', tips:'The "Command Center" for marketing teams | AI-powered "Headline Studio" ensures your titles get 10x more clicks through deep data analysis'),
    t('mention-ai-pro', freeTier:'Free research trial', price:41, priceTier:'Solo monthly', tips:'Advanced web and social intelligence | AI-powered "Competitive" benchmarking handles thousands of data points for your brand reports'),
    t('teal-ai-pro', freeTier:'Free basic Resume tool', price:9, priceTier:'Plus weekly', tips:'The smartest career coach in your browser | AI-powered "Job Match" score finds high-probability opportunities based on your specific skills data'),
    t('persado-ai-marketing', freeTier:'Institutional only', price:0, tips:'Leading enterprise generative AI | Features world-class "Knowledge Base" of emotional data used to optimize trillion-dollar customer journeys'),
    t('missing-lettr-ai', freeTier:'Free forever basic access', price:7, priceTier:'Solo monthly', tips:'The automation master for social content | AI-powered "Calendar" handles your entire brand distribution and scheduling data automatically'),
    t('recombee-ai-engine', freeTier:'Free dev tier', price:0, tips:'The most powerful recommendation API | Features incredible "Multimodal" understanding of your product catalog and user behavior data'),
    t('klevu', freeTier:'Institutional only', price:0, tips:'Leading AI for e-commerce search and discovery | Best for high-accuracy localized product searches and automated data tagging for pro stores'),
    t('okendo', freeTier:'Institutional only', price:0, tips:'Leading platform for building high-end "Customer Stories" and reviews | AI-powered "Insight" extraction helps brands understand buyer data deeply'),
    t('post-planner', freeTier:'Free trial available on site', price:7, priceTier:'Starter monthly annual', tips:'Best for finding and sharing viral content | AI-powered "Predictive" engagement score helps you pick the right social data to share'),
    t('oneup', freeTier:'Free trial for 7 days', price:12, priceTier:'Starter monthly annual', tips:'Leading multi-platform social manager | Best for automated scheduling and evergreen queues for small biz marketing data'),
    t('talkwalker', freeTier:'Institutional only', price:0, tips:'The "Bloomberg" of social intelligence | AI-powered "Trend" and "Topic" discovery used by world-class PR and marketing teams globally'),
    t('coschedule-pro', freeTier:'Free trial available', price:29, priceTier:'Individual monthly', tips:'High-end marketing orchestration suite | AI-powered "Project" management handles thousands of data tasks across your entire team'),
    t('mention-pro', freeTier:'Free trial available', price:41, priceTier:'Solo monthly', tips:'Professional brand monitoring suite | AI-powered "Insight" reports handles your public image data across 10+ social platforms'),
    t('teal-pro', freeTier:'Free basic version', price:36, priceTier:'Monthly membership', tips:'The ultimate career growth platform | AI-powered "Networking" and "Follow-up" automation used by top executives to manage their career data'),
    t('careerflow-ai', freeTier:'Free basic tracker', price:15, priceTier:'Pro monthly', tips:'The future of job searching | AI-powered "Application" and "Interview" prep used by students from Ivy League schools to land data roles'),
    t('persado-pro', freeTier:'Institutional only', price:0, tips:'Professional generative AI for enterprises | Uses millions of historical data points to predict which words will drive the most revenue'),
    t('missinglettr-pro', freeTier:'Free trial available', price:7, priceTier:'Solo monthly', tips:'The choice of top agencies | AI-powered "Curated" feeds handles thousands of social data shares automatically for your clients'),
    t('recombee-pro', freeTier:'Free trial for dev', price:0, tips:'High-end personalization engine | Features incredible "Live" updates driven by real-time user interaction data at scale'),
    t('klevu-ai-pro', freeTier:'Institutional only', price:0, tips:'The smarter way to search for products | AI-powered "Natural Language" understanding used by billion-dollar e-com brands'),
    t('okendo-ai-reviews', freeTier:'Institutional only', price:0, tips:'The industry standard for high-end reviews | AI-powered "Media" analysis handles thousands of customer photos and videos for data social proof'),
    t('postplanner-ai', freeTier:'Free basic access', price:7, priceTier:'Starter monthly', tips:'The "Engagement" king of social media | Use the "Artistic" filters for high-impact social data posts that convert'),
    t('oneup-ai-pro', freeTier:'Free trial available', price:12, priceTier:'Starter monthly', tips:'The choice of small biz owners | AI-powered "One-click" publishing handles your entire social media data distribution'),
    t('talkwalker-ai-social', freeTier:'Institutional only', price:0, tips:'The master of consumer intelligence | AI-powered "Video" and "Image" recognition handles your brand\'s visual data presence globally'),
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
