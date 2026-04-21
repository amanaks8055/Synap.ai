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
    t('epidemic-sound', freeTier:'Free trial for 30 days on site', price:9, priceTier:'Personal monthly annual', tips:'The world leader in royalty-free music for creators | AI-powered "Soundmatch" finds the perfect tracks for your video content data effortlessly'),
    t('beamery', freeTier:'Institutional only', price:0, tips:'Leading platform for Talent Lifecycle Management | AI-powered "Skills" and "Mobility" engine helps global brands manage their workforce data at scale'),
    t('copygenius', freeTier:'Free trial for 500 words', price:19, priceTier:'Starter monthly annual', tips:'Leading AI tool for e-commerce and ad copy | AI-powered "Genius Mode" generates high-converting product descriptions and niche data blog posts instantly'),
    t('tripnotes', freeTier:'Free forever basic version online', price:0, tips:'The smartest AI travel assistant | Best for finding the best local spots and building interactive map-based itineraries from natural language data'),
    t('pymetrics', freeTier:'Institutional only', price:0, tips:'Leading AI for fair and objective hiring | Features world-class "Neuroscience" games to match candidates to roles based on cognitive data'),
    t('talview', freeTier:'Institutional only', price:0, tips:'Leading platform for automated video interviews and assessments | AI-powered "Proctoring" and "Behavioral" insights for high-volume HR data'),
    t('mya-systems', freeTier:'Institutional only', price:0, tips:'The pioneer of AI recruiting assistants | AI-powered "NLU" handles thousands of candidate conversations and scheduling tasks automatically'),
    t('didimo', freeTier:'Free trial for 3 high-res avatars', price:0, tips:'Leading platform for generating lifelike 3D digital humans | Best for gaming and VR designers creating realistic "Digital Twins" from photo data'),
    t('ludo-ai', freeTier:'Free trial available on site', price:20, priceTier:'Individual monthly annual', tips:'The "Command Center" for game researchers | AI-powered "Trend" and "Concept" discovery used by top game studios to find the next big data hit'),
    t('kinetix', freeTier:'Free forever basic for creators', price:0, tips:'Leading AI for 3D animation from video | Best for turning any real-world motion into professional 3D animated data for Metaverse and games'),
    t('epidemic-sound-ai', freeTier:'Free basic access', price:9, priceTier:'Personal monthly', tips:'High-end audio discovery engine | AI-powered "Search" uses your specific video audio to find matching rhythmic music data'),
    t('beamery-ai-pro', freeTier:'Institutional only', price:0, tips:'Professional talent intelligence suite | Uses millions of historical data points to predict which candidates will be top performers'),
    t('copy-genius-pro', freeTier:'Free credit limit', price:19, priceTier:'Starter monthly', tips:'The smartest ad writer for e-com | Features world-class "Tone" and "Role" specific data frameworks for high-converting marketing'),
    t('trip-notes-ai', freeTier:'Free Forever (Web/App)', price:0, tips:'The future of holiday planning | Best for travelers building deep research logs and map-based data itineraries instantly'),
    t('pymetrics-pro', freeTier:'Institutional only', price:0, tips:'Enterprise-grade bias-free hiring platform | AI-powered "Behavioral" scores driven by millions of cognitive research data points'),
    t('talview-ai-pro', freeTier:'Institutional only', price:0, tips:'The choices of global enterprise HR | AI-powered "Skill Match" handles your entire technical assessment data cycle'),
    t('mya-ai-recruiter', freeTier:'Institutional only', price:0, tips:'The smartest way to scale hiring | AI-powered "Workflow" automation saves thousands of HR hours on repetitive data tasks'),
    t('didimo-ai', freeTier:'Free avatar trial', price:0, tips:'High-end 3D persona generator | Features world-class "Unity" and "Unreal" integration for seamless character data mapping'),
    t('ludo-ai-games', freeTier:'Free research trial', price:20, priceTier:'Standard monthly', tips:'The data-driven game designer | Use the "Competitive" analysis to find gaps in the market and AI-powered "Concept" data logs'),
    t('kinetix-ai-pro', freeTier:'Free motion trial', price:0, tips:'The safest way to animate 3D characters | AI-powered "Capture" turns phone video into high-fidelity skeletal data for game dev'),
    t('copygenius-ai', freeTier:'Free forever basic access', price:19, priceTier:'Pro monthly', tips:'The content greenhouse for creators | AI-powered "SEO" and "Marketing" insights handles your entire brand data presence'),
    t('tripnotes-pro', freeTier:'Free basic access', price:0, tips:'The "Power-user" of travel planning | AI-powered "Discovery" finds hidden gems and restaurant data traditional guides miss'),
    t('pymetrics-ai', freeTier:'Institutional only', price:0, tips:'The gold standard for fair talent matching | Features advanced "Psychological" data profiling used by top tech companies globally'),
    t('talview-intelligence', freeTier:'Institutional only', price:0, tips:'The industry leader in remote hiring | AI-powered "Integrity" checking handles thousands of candidate data points simultaneously'),
    t('ep-sound', freeTier:'Free trial available', price:9, priceTier:'Personal monthly', tips:'The premier music library for high-end creators | Best for finding unique and royalty-free tracks for your video data projects'),
    t('beamery-talent', freeTier:'Institutional only', price:0, tips:'The "SAP" for talent management | Features incredible "Data Visualization" of your global workforce skills and trends'),
    t('copygenius-pro', freeTier:'Free word trial', price:19, priceTier:'Starter monthly', tips:'The professional content generator | AI-powered "Ad" and "Social" copy used by top marketing agencies for better data ROI'),
    t('didimo-3d', freeTier:'Free basic access', price:0, tips:'The easiest way to build lifelike digital humans | AI-powered "Facial" animation handles complex emotional data effortlessly'),
    t('ludo-pro', freeTier:'Free trial available', price:20, priceTier:'Standard monthly', tips:'The industry standard for game market research | AI-powered "Market" data finds the most profitable niches for your dev team'),
    t('kinetix-3d', freeTier:'Free basic version', price:0, tips:'High-speed 3D motion capture from web | Best for creating unique and expressive animations for your brand\'s 3D data'),
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
