// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

Map<String, dynamic> t(String id, String name, String cat, String desc,
    String url, bool free, bool featured, int clicks,
    {String? freeTier, double? price, String? priceTier, String? tips}) {
  String domain;
  try {
    domain = Uri.parse(url).host;
    if (domain.isEmpty) domain = url.replaceAll('https://', '').split('/').first;
  } catch (_) {
    domain = url.replaceAll('https://', '').split('/').first;
  }
  return {
    'id': id,
    'name': name,
    'slug': id,
    'category_id': cat,
    'description': desc,
    'icon_emoji': '🤖',
    'icon_url': 'https://logo.clearbit.com/$domain',
    'website_url': url,
    'has_free_tier': free,
    'is_featured': featured,
    'click_count': clicks,
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
    // ━━━ INFRASTRUCTURE & CLOUD AI ━━━
    t('aws-sagemaker-ai','AWS SageMaker','code','The most comprehensive ML platform to build, train, and deploy models at scale.','https://aws.amazon.com/sagemaker',true,true,45000, freeTier:'Free tier for 2 months (limited)', price:0, tips:'Best for enterprise scale | Built-in Jupyter notebooks | Integrated with AWS stack'),
    t('google-vertex-ai','Google Vertex AI','code','Unified AI platform for training and deploying ML models and generative AI.','https://cloud.google.com/vertex-ai',true,true,38000, freeTier:'\$300 free credits for new users', price:0, tips:'Access to Gemini models | Auto-ML for non-coders | Leading in ML research'),
    t('azure-ml-ai','Azure Machine Learning','code','Enterprise-grade service for the machine learning lifecycle in the cloud.','https://azure.microsoft.com/en-us/products/machine-learning',true,true,35000, freeTier:'Free account + \$200 credits', price:0, tips:'Best for Microsoft ecosystem | Integrated with PowerBI | Robust security and compliance'),
    t('heroku-ai','Heroku (ML addons)','code','Easiest platform for deploying web apps with AI-powered add-ons.','https://heroku.com',true,false,28000, freeTier:'No free tier (students only)', price:5, priceTier:'Eco plan monthly', tips:'Single command deploy | Massive ecosystem of add-ons | Managed infrastructure'),
    t('vercel-ai','Vercel AI SDK','code','The framework for building high-performance AI-powered web applications.','https://vercel.com/ai',true,true,42000, freeTier:'Free for hobby projects', price:20, priceTier:'Pro: more usage and collaboration', tips:'Leading edge for Next.js and AI | Streaming responses | Pre-built UI components'),

    // ━━━ DATABASES & RAG ━━━
    t('pinecone-ai','Pinecone','code','The vector database for building high-performance AI applications.','https://pinecone.io',true,true,35000, freeTier:'Free starter pod (limited)', price:70, priceTier:'Pro: per hour pricing', tips:'Industry leader for vector search | Massive scale | Fully managed SaaS'),
    t('weaviate-ai','Weaviate','code','Open-source vector database for storing and querying AI-powered data.','https://weaviate.io',true,true,18000, freeTier:'Free trial for sandbox', price:25, priceTier:'Serverless monthly', tips:'Built-in ML modules | Hybrid search (vector + keyword) | Great community support'),
    t('qdrant-ai','Qdrant','code','High-performance vector search engine with extended filtering capabilities.','https://qdrant.tech',true,false,12000, freeTier:'Free tier available (1GB)', price:25, priceTier:'Pro starting price', tips:'Rust-powered performance | Comprehensive filtering | Distributed architecture'),
    t('chroma-db-ai','Chroma','code','The open-source embedding database for building AI applications with Python.','https://trychroma.com',true,true,15000, freeTier:'Completely free open source', price:0, tips:'Easiest to setup locally | Designed for LLM workflows | Integration with LangChain'),
    t('milvus-ai','Milvus','code','World\'s most advanced open-source vector database for cloud-native AI.','https://milvus.io',true,false,9200, freeTier:'Completely free open source', price:0, tips:'Architected for Kubernetes | Support for billions of vectors | High reliability'),

    // ━━━ CI/CD & OPS AI ━━━
    t('circleci-ai','CircleCI','code','Leading CI/CD platform with AI-powered resource optimization.','https://circleci.com',true,true,25000, freeTier:'Free for up to 6000 mins/month', price:15, priceTier:'Performance plan monthly', tips:'Docker-first CI | Massive library of Orbs | Global scale'),
    t('github-actions-ai','GitHub Actions','code','Automate your workflow from idea to production on GitHub.','https://github.com/features/actions',true,true,84000, freeTier:'Free for public repos (limited)', price:0, tips:'Integrated with GitHub | Huge community for actions | Secure and fast'),
    t('gitlab-ai','GitLab Duo','code','The complete DevSecOps platform with AI-powered code suggestions.','https://gitlab.com',true,true,45000, freeTier:'Free for individual users', price:19, priceTier:'Premium per user monthly', tips:'AI code security | Integrated CI/CD | Best for large organizations'),
    t('sentry-ai','Sentry','code','AI-powered error tracking and performance monitoring for developers.','https://sentry.io',true,true,58000, freeTier:'Free for individuals (5k events)', price:26, priceTier:'Team plan monthly', tips:'See exactly what broke | AI-suggested fixes | Support for every language'),
    t('logrocket-ai','LogRocket','code','Modern frontend monitoring with AI-powered session replay and errors.','https://logrocket.com',true,false,15000, freeTier:'Free for up to 1000 sessions', price:99, priceTier:'Team plan monthly', tips:'See what users did | AI detects frustration | Performance monitoring'),

    // ━━━ ADS & CAMPAIGNS AI ━━━
    t('adcreative-ai','AdCreative.ai','marketing','AI platform for generating conversion-focused ad creatives and copy.','https://adcreative.ai',true,true,18000, freeTier:'7-day free trial', price:21, priceTier:'Starter plan monthly', tips:'Generate 100s of ads in seconds | AI predicts CTR | Integrate with Google/Meta'),
    t('pencil-ai','Pencil','marketing','AI platform for e-commerce brands to generate high-performing video ads.','https://trypencil.com',false,true,12000, freeTier:'Demo available', price:119, priceTier:'Professional monthly', tips:'Best for TikTok/Meta ads | AI analyzes past performance | Fast turnaround'),
    t('madgicx-ai','Madgicx','marketing','The all-in-one AI advertising platform for Facebook and Google Ads.','https://madgicx.com',false,false,9200, freeTier:'7-day free trial', price:49, priceTier:'Starter monthly', tips:'Automated ad optimization | Advanced audience targeting | Robust creative analytics'),
    t('revealbot-ai','Revealbot','marketing','AI-powered automation for scaling Facebook, Google, and TikTok ads.','https://revealbot.com',false,false,8400, freeTier:'14-day free trial', price:99, priceTier:'Monthly based on spend', tips:'Advanced rule-based automation | Cross-platform scaling | Best for agencies'),
    t('smartly-ai','Smartly.io','marketing','Enterprise social advertising platform with AI-powered automation.','https://smartly.io',false,true,5600, freeTier:'Demo available', price:0, tips:'Used by Uber and eBay | Complex creative automation | Multi-platform scale'),

    // ━━━ ANALYTICS & INSIGHTS ━━━
    t('amplitude-ai','Amplitude','marketing','Leading digital analytics platform with AI-powered player insights.','https://amplitude.com',true,true,35000, freeTier:'Free for up to 100k events/month', price:0, tips:'Know your user behavior | AI-powered cohort analysis | Industry standard'),
    t('mixpanel-ai','Mixpanel','marketing','Advanced product analytics for mobile and web with AI-powered reports.','https://mixpanel.com',true,true,45000, freeTier:'Free for up to 20m events/month', price:24, priceTier:'Growth plan monthly', tips:'Powerful funnel analysis | AI "Insights" dashboard | Easy integration'),
    t('hotjar-ai','Hotjar','marketing','Heatmaps and session recording platform with AI-powered summaries.','https://hotjar.com',true,true,84000, freeTier:'Free basic recording', price:32, priceTier:'Plus plan monthly', tips:'Visualize user frustration | Record real user sessions | AI summarizes feedback'),
    t('fullstory-ai','FullStory','marketing','Digital experience intelligence platform with AI-powered indexing.','https://fullstory.com',false,false,15000, freeTier:'14-day free trial', price:0, tips:'Quantify impact of bugs | AI-powered "Rage Click" detection | Enterprise security'),
    t('heap-ai','Heap','marketing','Automated digital analytics with AI-powered insight discovery.','https://heap.io',true,false,12000, freeTier:'Free for up to 10k sessions', price:0, tips:'Capture every user action | AI recommends where to optimize | No-code setup'),

    // ━━━ COMMUNICATION & MEETINGS AI ━━━
    t('zoom-ai-companion','Zoom AI Companion','productivity','Built-in AI for meeting summaries, drafting messages, and more.','https://zoom.com',true,true,150000, freeTier:'Free for basic meetings', price:15, priceTier:'Pro monthly', tips:'Integrated into the app | Automated meeting notes | High quality transcriptions'),
    t('microsoft-teams-ai','Teams Premium','productivity','AI-powered features for meetings, webinars, and collaboration.','https://microsoft.com/teams',false,true,120000, freeTier:'Free version available', price:7, priceTier:'Monthly per user', tips:'AI-generated meeting chapters | Live translation | Personalized summaries'),
    t('slack-ai','Slack AI','productivity','Harness the collective knowledge of your team with AI in Slack.','https://slack.com/ai',false,true,150000, freeTier:'Free trial for teams', price:0, tips:'AI thread summaries | Powerful search across channels | Channel recaps'),
    t('around-ai','Around','productivity','Video calls designed for high-performance remote teams with AI audio.','https://around.co',true,false,18000, freeTier:'Free for small teams', price:0, tips:'AI-powered noise cancellation | Circular video frames | Integrated with Slack'),
    t('gather-town-ai','Gather','productivity','Virtual office for remote teams with AI-powered networking tools.','https://gather.town',true,true,25000, freeTier:'Free for up to 10 users', price:7, priceTier:'Per user monthly', tips:'Visual proximity chat | AI-powered avatars | Best for remote team culture'),

    // ━━━ PRODUCTIVITY UTILITIES ━━━
    t('toggl-track-ai','Toggl Track','productivity','Simple and powerful time tracking with AI-powered reminders.','https://toggl.com/track',true,true,58000, freeTier:'Free for up to 5 users', price:9, priceTier:'Starter per user monthly', tips:'One-click tracking | Beautiful reports | Integrated with 100+ tools'),
    t('harvest-ai','Harvest','productivity','Time tracking and invoicing with AI-powered reports and forecasting.','https://getharvest.com',true,false,35000, freeTier:'Free for 1 user and 2 projects', price:10, priceTier:'Pro per user monthly', tips:'Best for agencies | Simple expense tracking | Integrated with Stripe'),
    t('clockify-ai','Clockify','productivity','The most popular free time tracker for teams with self-hosted AI.','https://clockify.me',true,true,120000, freeTier:'Completely free forever basic', price:4, priceTier:'Basic monthly per user', tips:'Used by millions | Timesheets and calendar | Free for unlimited users'),
    t('forest-app-ai','Forest','productivity','Gamified Pomodoro timer that helps you stay focused by planting trees.','https://forestapp.cc',true,true,250000, freeTier:'Free on Android / Paid on iOS', price:2, priceTier:'One-time purchase', tips:'Stay away from your phone | Partnered with real tree planting | High motivation'),
    t('freedom-ai','Freedom','productivity','Block distracting websites and apps with AI-powered scheduling.','https://freedom.to',true,false,15000, freeTier:'Free trial for 7 sessions', price:3, priceTier:'Premium monthly', tips:'Lock down your devices | Recurring blocks | AI focus coach'),

    // ━━━ FILE UTILITIES AI ━━━
    t('ilovepdf-ai','iLovePDF','productivity','All the tools you need to work with PDFs in one place with AI.','https://ilovepdf.com',true,true,250000, freeTier:'Free forever basic', price:4, priceTier:'Premium: no ads and more files', tips:'Compress and merge PDFs | AI-powered OCR | Desktop app available'),
    t('smallpdf-ai','Smallpdf','productivity','The first and only PDF software you will actually love with AI.','https://smallpdf.com',true,true,150000, freeTier:'Free daily usage limit', price:7, priceTier:'Pro monthly', tips:'Fastest web PDF tools | 256-bit SSL encryption | High quality conversion'),
    t('convertio-ai','Convertio','productivity','Advanced AI-powered file converter for any file format online.','https://convertio.co',true,true,120000, freeTier:'Free for small files', price:9, priceTier:'Light plan monthly', tips:'300+ formats supported | Cloud-based conversion | No software to install'),
    t('zamzar-ai','Zamzar','productivity','Easy, reliable and fast file conversion with AI-powered tracking.','https://zamzar.com',true,false,56000, freeTier:'Free for up to 2 files daily', price:9, priceTier:'Basic plan monthly', tips:'Leader since 2006 | API for developers | Safe and secure'),
    t('cloudconvert-ai','CloudConvert','productivity','File converter for any format with AI for high quality presets.','https://cloudconvert.com',true,false,45000, freeTier:'Free for 25 conversions daily', price:9, priceTier:'Package starting price', tips:'Highest quality conversion | Integrated with Google Drive | Safe and secure'),

    // ━━━ OTHER MISC ━━━
    t('waymo-ai','Waymo','travel','The world\'s most experienced autonomous driving technology.','https://waymo.com',false,true,150000, freeTier:'Pay per ride in select cities', price:0, tips:'Fully autonomous taxi | AI-powered safety | Google/Alphabet project'),
    t('starlink-ai','Starlink','travel','Leading satellite internet service with AI-powered beam navigation.','https://starlink.com',false,true,85000, freeTier:'Hardware purchase required', price:120, priceTier:'Monthly residential plan', tips:'Internet anywhere on Earth | AI optimizes signal | SpaceX project'),
    t('whoop-coach-ai','Whoop AI Coach','health','Personal health coach built into Whoop using your body\'s data.','https://whoop.com/coach',false,true,45000, freeTier:'Requires Whoop membership', price:30, priceTier:'Monthly membership', tips:'AI understands your recovery | Ask fitness questions | Personalized training'),
    t('sleep-cycle-ai','Sleep Cycle','health','Smart alarm clock that tracks sleep patterns with AI sound detection.','https://sleepcycle.com',true,true,84000, freeTier:'Free basic version', price:30, priceTier:'Premium annual', tips:'Wake up at the right time | AI detects snoring and talk | Detailed sleep analysis'),
  ];

  print('Total tools to upload: ${tools.length}');

  const supaPath = '$supabaseUrl/rest/v1/ai_tools';
  const batchSize = 25;
  var uploaded = 0;

  for (var i = 0; i < tools.length; i += batchSize) {
    final end = (i + batchSize > tools.length) ? tools.length : i + batchSize;
    final batch = tools.sublist(i, end);
    final bodyBytes = utf8.encode(jsonEncode(batch));

    try {
      final req = await client.postUrl(Uri.parse(supaPath));
      req.headers.set('apikey', anonKey);
      req.headers.set('Authorization', 'Bearer $anonKey');
      req.headers.set('Content-Type', 'application/json; charset=utf-8');
      req.headers.set('Prefer', 'resolution=merge-duplicates');
      req.contentLength = bodyBytes.length;
      req.add(bodyBytes);
      final resp = await req.close();
      final respBody = await utf8.decodeStream(resp);
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        uploaded += batch.length;
        print('OK $uploaded/${tools.length}');
      } else {
        print('FAIL at $i [${resp.statusCode}]: $respBody');
      }
    } catch (e) {
      print('ERR at $i: $e');
    }
  }

  client.close();
  print('DONE! Uploaded $uploaded tools with full pricing data');
}
