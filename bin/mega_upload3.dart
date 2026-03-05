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
  const anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNzZW13em13aGxjLmZtem1yd2V1dyIsInJvbGUiOiJhbm9uIiwiaWF0IjoxNzcyMTc5MTE3LCJleHAiOjIwODc3NTUxMTd9.QF9G86V2HxzMrnN37ENQkrY7L_m7LBuxa56tC5MoywA';
  // Correction in key if it was truncated, but actually using the one from previous logic.
  // Wait, let me double check the key from mega_upload1.dart
  const actualKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNzZW13em13aGxjZm16bXJ3ZXV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIxNzkxMTcsImV4cCI6MjA4Nzc1NTExN30.QF9G86V2HxzMrnN37ENQkrY7L_m7LBuxa56tC5MoywA';
  
  final client = HttpClient();

  final tools = <Map<String, dynamic>>[
    // ━━━ INTERIOR DESIGN ━━━
    t('homestyler','Homestyler','design','AI-powered online 3D home design and interior decoration tool.','https://homestyler.com',true,true,4800, freeTier:'Free basic 3D rendering', price:5, priceTier:'Pro: high-res 4K renders', tips:'Best for floor planning | Huge library of furniture | Real-time 3D view'),
    t('planner5d','Planner 5D','design','Advanced 2D/3D home design tool with AI floor plan recognition.','https://planner5d.com',true,false,3600, freeTier:'Free basic catalog', price:7, priceTier:'Premium: all items and textures', tips:'Scan plans from paper | Interior AI styles | VR mode support'),
    t('room-gpt','RoomGPT','design','AI room redesign tool that generates new interior styles from photos.','https://roomgpt.io',true,true,5400, freeTier:'3 free credits per day', price:9, priceTier:'Pro: 50+ renders and priority', tips:'Redesign any room in seconds | Try 8+ different styles | Perfect for inspiration'),
    t('interior-ai','Interior AI','design','AI interior designer for virtual staging and professional redesigns.','https://interiorai.com',true,false,4200, freeTier:'Free trial with limited renders', price:29, priceTier:'Pro: private mode and higher res', tips:'Used by realtors for staging | Very realistic renders | High resolution output'),
    t('renovate-ai','Renovate AI','design','AI tool for planning home renovations and visualize changes.','https://renovateai.app',true,false,1800, freeTier:'Free limited use', price:15, priceTier:'Premium: unlimited projects', tips:'Best for structural change ideas | Local contractor links | Cost estimator included'),

    // ━━━ PHOTOGRAPHY ━━━
    t('aftershoot','Aftershoot','photo','AI photo culling and editing assistant for professional photographers.','https://aftershoot.com',false,true,3200, freeTier:'30-day free trial', price:10, priceTier:'Select plan per month', tips:'Culls 1000s of images in minutes | Learns your editing style | Saves hours in Lightroom'),
    t('imagen-ai','Imagen AI','photo','AI-powered personalized photo editing assistant for Lightroom.','https://imagen-ai.com',false,false,2800, freeTier:'1000 free edits on signup', price:0.05, priceTier:'Pay per edit with \$7 monthly minimum', tips:'Extremely accurate style copying | Cloud-based processing | Best for weddings'),
    t('vance-ai','VanceAI','photo','AI image enhancement tools for sharpening, denoising, and upscaling.','https://vanceai.com',true,false,4400, freeTier:'3 free credits per month', price:5, priceTier:'Basic: 100 credits per month', tips:'Best for old photo restoration | Batch processing available | High quality sharpening'),
    t('topaz-photo-ai','Topaz Photo AI','photo','Professional AI for sharpening, noise reduction, and upscaling.','https://topazlabs.com',false,true,6800, freeTier:'Free trial with watermark', price:199, priceTier:'One-time purchase for desktop', tips:'Industry standard for sharpening | Recover blurry faces | Essential for pros'),
    t('skylum-luminar','Luminar Neo','photo','AI-powered photo editor with sky replacement and portrait bokeh.','https://skylum.com',false,false,5400, freeTier:'7-day free trial', price:10, priceTier:'Monthly subscription or lifetime', tips:'Best sky replacement | Automatic relighting | Powerline removal'),

    // ━━━ NEWS & MEDIA ━━━
    t('ground-news','Ground News','news','AI news aggregator showing political bias and blind spots.','https://ground.news',true,true,8400, freeTier:'Free bias check on web', price:1, priceTier:'Pro: blind spot feed and search', tips:'See how different sides cover a story | Detect sensationalism | Compare sources instantly'),
    t('artifact-news','Artifact','news','AI-powered news feed that learns from your reading habits.','https://artifact.news',true,false,4600, freeTier:'Completely free app', price:0, tips:'Summarize news with AI | Clickbait detection | Quality-first algorithm'),
    t('inoreader-ai','Inoreader','news','Powerful RSS reader with AI filtering and content discovery.','https://inoreader.com',true,false,3800, freeTier:'Free up to 150 feeds', price:7, priceTier:'Pro: AI rules and highlights', tips:'Automate news monitoring | Filter by keyword | High quality highlights'),
    t('feedly-leo','Feedly (Leo)','news','AI research assistant that filters your news and identifies trends.','https://feedly.com',true,false,5200, freeTier:'Free basic RSS reader', price:6, priceTier:'Pro+: Leo AI assistant included', tips:'Leo identifies signal from noise | Auto-summaries | Enterprise threat intel'),
    t('newsletter-ai','Newsletter AI','news','AI tool that summarizes your email newsletters into a daily digest.','https://newsletterai.com',true,false,2200, freeTier:'Free for up to 5 newsletters', price:5, priceTier:'Pro: unlimited newsletters', tips:'Clean your inbox | Daily summary in one email | Reading progress tracking'),

    // ━━━ SPREADSHEETS & DATA ━━━
    t('sheetplus','SheetPlus','productivity','AI tool that generates Excel and Google Sheets formulas instantly.','https://sheetplus.ai',true,true,3400, freeTier:'Free 10 formulas per month', price:6, priceTier:'Pro: unlimited formulas and explainers', tips:'Type in English to get formulas | Explains how complex formulas work | VS Code extension'),
    t('formula-bot','Formula Bot','productivity','AI assistant for Excel formulas, VBA, and data analysis tasks.','https://formulabot.com',true,false,4200, freeTier:'5 free formulas per month', price:7, priceTier:'Pro: unlimited and data tools', tips:'Excel and Google Sheets support | SQL query generator | Data analysis chatbot'),
    t('numerics-ai','Numerics','productivity','AI-powered dashboards for tracking business KPIs and metrics.','https://cynapse.com/numerics',true,false,1800, freeTier:'Free basic dashboards', price:10, priceTier:'Pro: unlimited dashboards and data sources', tips:'Best for Apple devices | Native widgets | Real-time data visualization'),
    t('arcwise','Arcwise','productivity','AI copilot for Google Sheets helping with data cleaning and analysis.','https://arcwise.app',true,false,2600, freeTier:'Free for personal use', price:0, tips:'Fastest way to clean data | Natural language queries on sheets | ChatGPT integration'),
    t('coefficients','Coefficient','productivity','AI-powered Google Sheets and Excel connector for live business data.','https://coefficient.io',true,false,3200, freeTier:'Free for up to 5000 rows', price:49, priceTier:'Starter: unlimited rows and refreshes', tips:'Connect Salesforce, HubSpot to Sheets | Automatic refreshes | AI formula builder'),

    // ━━━ DATABASE TOOLS ━━━
    t('text-to-sql','Text2SQL','code','AI SQL generator converting natural language into SQL queries.','https://text2sql.ai',true,true,5800, freeTier:'10 free queries per day', price:4, priceTier:'Pro: unlimited and custom schema', tips:'Paste your schema for better queries | Supports all major DBs | Explain function'),
    t('outerbase','Outerbase','code','Modern database interface with AI (EZ-SQL) for easy querying.','https://outerbase.com',true,true,4600, freeTier:'Free for 2 databases', price:20, priceTier:'Pro: unlimited databases and teams', tips:'Edit DB like a spreadsheet | AI writes your queries | Beautiful UI'),
    t('bitio','bit.io','code','AI-assisted serverless database for rapid data deployment.','https://bit.io',true,false,2400, freeTier:'Free up to 3GB storage', price:10, priceTier:'Pro: 10GB+ and higher limits', tips:'Auto-generated APIs | Easy data sharing | PostgreSQL compatible'),
    t('hasura-ai','Hasura Data Delivery','code','AI-powered GraphQL engine for instant database APIs.','https://hasura.io',true,false,5200, freeTier:'Free tier for cloud', price:0, tips:'Instant GraphQL on Postgres | AI helps with schema and queries | Very fast'),
    t('neon-ai','Neon Serverless','code','Serverless PostgreSQL with AI-powered branching and scaling.','https://neon.tech',true,true,7200, freeTier:'Free storage up to 5GB', price:0, tips:'Great for dev/staging | Branching like git | Scales to zero automatically'),

    // ━━━ DEVOPS & CLOUD ━━━
    t('pulumi-ai','Pulumi AI','code','AI assistant for infrastructure as code (IaC) using Pulumi.','https://pulumi.com/ai',true,true,3800, freeTier:'Free for individuals', price:0, tips:'Generate cloud infra in any language | Natural language to IaC | Visualizes changes'),
    t('kcl-lang','KCL','code','Cloud-native configuration language with AI for cloud automation.','https://kcl-lang.io',true,false,1400, freeTier:'Free open source', price:0, tips:'Schema-first configuration | Good for Kubernetes | Fast and safe'),
    t('infra-ai','Infra AI','code','AI tool for managing and automating cloud infrastructure tasks.','https://infra.app',true,false,2200, freeTier:'Free trial available', price:15, priceTier:'Pro for teams', tips:'Kubernetes cluster management | AI-powered log analysis | Cost optimization'),
    t('vantage-ai','Vantage','code','AI cloud cost management and optimization platform.','https://vantage.sh',true,false,3200, freeTier:'Free for up to \$2.5k monthly spend', price:0, tips:'Identify cloud waste | Savings recommendations | Multi-cloud support'),
    t('cast-ai','CAST AI','code','AI-powered Kubernetes cost optimization and automation.','https://cast.ai',true,false,2800, freeTier:'Free for cost reporting', price:0, tips:'Automatic scaling | Spot instance management | Massive savings on EKS/GKE'),

    // ━━━ PERSONAL FINANCE ━━━
    t('monarch-money','Monarch Money','finance','AI-powered personal finance and budgeting for individuals and families.','https://monarchmoney.com',false,true,5400, freeTier:'7-day free trial', price:8, priceTier:'Monthly billed annually', tips:'AI categorization is very accurate | Collaboration for couples | Beautiful dashboards'),
    t('copilot-money','Copilot Money','finance','Beautiful AI personal finance app with smart tracking for Mac/iOS.','https://copilot.money',false,true,4800, freeTier:'1-month free trial', price:8, priceTier:'Monthly subscription', tips:'Best UI in finance apps | AI learned categories | Amazon integration'),
    t('rocket-money','Rocket Money','finance','AI tool for canceling unwanted subscriptions and saving money.','https://rocketmoney.com',true,false,9200, freeTier:'Free basic tracking', price:3, priceTier:'Premium: sub cancellation and more', tips:'Cancels subs for you | Negotiates bills | Good for automation'),
    t('cleo-ai','Cleo','finance','AI money assistant with a personality to help you save and budget.','https://meetcleo.com',true,true,7200, freeTier:'Free basic assistant', price:6, priceTier:'Cleo+ for credit building/advances', tips:'Funny personality ("Roast me") | Visual budgeting | Automated savings'),
    t('toshl-ai','Toshl Finance','finance','Global expense tracker with AI for expense categorization and travel.','https://toshl.com',true,false,3400, freeTier:'Free basic manual logging', price:2, priceTier:'Medici: bank sync and AI', tips:'Excellent for multiple currencies | Clean travel tracking | Export to CSV'),

    // ━━━ MENTAL HEALTH ━━━
    t('woebot-ai','Woebot','health','AI chatbot for mental health based on cognitive behavioral therapy.','https://woebothealth.com',true,true,8400, freeTier:'Free for individuals', price:0, tips:'Built by Stanford psychologists | Check-ins for mood | CBT techniques daily'),
    t('wysa-ai','Wysa','health','AI-powered emotional support bot for anxiety and stress.','https://wysa.io',true,true,7200, freeTier:'Free basic bot', price:15, priceTier:'Premium with clinical sessions', tips:'Used by the NHS | Privacy-first | Exercises for better sleep'),
    t('headspace-ai','Headspace','health','Leading meditation app with AI for personalized mental wellness.','https://headspace.com',true,false,12000, freeTier:'7-day free trial', price:12, priceTier:'Monthly subscription', tips:'Guided meditations | Sleep sounds | Mindful focus for work'),
    t('calm-ai','Calm','health','AI-powered app for sleep, meditation, and relaxation.','https://calm.com',true,false,15000, freeTier:'7-day free trial', price:14, priceTier:'Monthly billed annually', tips:'Sleep stories from celebrities | Daily calm meditations | Very high quality audio'),
    t('youper-ai','Youper','health','Telehealth platform using AI for mental health and therapy.','https://youper.ai',true,false,4800, freeTier:'Free mood tracking', price:20, priceTier:'Full therapy and medication plans', tips:'AI therapy assistant | Clinically validated | Tracks symptoms over time'),

    // ━━━ LANGUAGE LEARNING ━━━
    t('duolingo-max','Duolingo Max','education','AI-powered Duolingo with Roleplay and Explain My Answer features.','https://duolingo.com',false,true,25000, freeTier:'Free standard Duolingo available', price:30, priceTier:'Duolingo Max with GPT-4', tips:'Roleplay with AI characters | Deep dive into mistakes | Highly gamified'),
    t('elsaspeak','ELSA Speak','education','AI English tutor focusing on pronunciation and accent reduction.','https://elsaspeak.com',true,true,9200, freeTier:'Free basic pronunciation', price:10, priceTier:'Pro: unlimited lessons and scores', tips:'Real-time feedback on mouth shape | Best for TOEFL/IELTS | Personalized path'),
    t('tala-ai','Tala','education','AI-powered English learning app specialized for speaking practice.','https://tala.so',true,false,1800, freeTier:'Free trial available', price:5, priceTier:'Pro: unlimited conversations', tips:'Speak naturally with AI | Vocabulary builder | Good for conversational fluency'),
    t('memrise-ai','Memrise','education','Language learning app with AI "MemBot" for conversational practice.','https://memrise.com',true,false,8400, freeTier:'Free basic courses', price:8, priceTier:'Pro: ad-free and AI features', tips:'Real videos of locals | AI coach MemBot | Best for vocabulary'),
    t('lingopie','Lingopie','education','Language learning platform using TV shows and AI interaction.','https://lingopie.com',false,false,4200, freeTier:'7-day free trial', price:12, priceTier:'Monthly subscription', tips:'Learn while watching Netflix | AI clickable subtitles | Best for immersion'),

    // ━━━ AI HARDWARE & ROBOTICS ━━━
    t('rabbit-r1','Rabbit R1','hardware','AI hardware device with Large Action Model (LAM) for automation.','https://rabbit.tech',false,true,15000, freeTier:'No free tier', price:199, priceTier:'One-time hardware purchase', tips:'Automate apps without UI | Perplexity included | Small portable design'),
    t('human-pin','Humane AI Pin','hardware','Wearable AI assistant projected on your hand with voice control.','https://humane.com',false,true,12000, freeTier:'No free tier', price:699, priceTier:'Hardware + \$24 monthly subscription', tips:'Screenless interaction | Laser projector display | Privacy-first design'),
    t('brilliant-monocle','Brilliant Monocle','hardware','Open-source AR monocle for AI hackers and developers.','https://brilliant.xyz',false,false,3200, freeTier:'Open source firmware free', price:349, priceTier:'One-time hardware purchase', tips:'Programmable with Python | Add AI to your vision | Minimal design'),
    t('meta-glasses','Ray-Ban Meta','hardware','AI-powered smart glasses with camera and voice assistant.','https://ray-ban.com',false,true,18000, freeTier:'No free tier', price:299, priceTier:'Starting price for hardware', tips:'Multimodal AI (can see what you see) | Best smart glasses available | Excellent speakers'),
    t('figure-ai','Figure AI','robotics','AI robotics company building general-purpose humanoid robots.','https://figure.ai',false,false,5600, freeTier:'No public product', price:0, tips:'AI models by OpenAI | Humanoid form factor | Used in manufacturing'),
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
      req.headers.set('apikey', actualKey);
      req.headers.set('Authorization', 'Bearer $actualKey');
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
