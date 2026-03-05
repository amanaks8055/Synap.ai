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
    // ━━━ ENTERTAINMENT & CREATIVE APPS (Mass Market) ━━━
    t('capcut-ai-video','CapCut','video','The most popular mobile video editor with AI-powered auto-captioning and effects.','https://capcut.com',true,true,999999, freeTier:'Free basic version with watermarks', price:8, priceTier:'Pro monthly', tips:'Best for TikTok and Reels | AI-powered background removal | Thousands of templates'),
    t('fotor-ai-design','Fotor','design','All-in-one AI photo editor and design tool with text-to-image features.','https://fotor.com',true,true,180000, freeTier:'Free basic version', price:3, priceTier:'Pro per month billed annually', tips:'AI-powered face retouching | Remove objects with one click | High quality design templates'),
    t('befunky-ai-photo','BeFunky','design','Powerful and easy-to-use AI photo editor and collage maker online.','https://befunky.com',true,true,120000, freeTier:'Free basic version', price:5, priceTier:'Plus per month billed annually', tips:'Best for simple social media graphics | AI-powered collage generator | No account needed'),
    t('pixlr-ai-design','Pixlr','design','Modern AI-powered photo editor that works in your browser with no install.','https://pixlr.com',true,true,150000, freeTier:'Free for up to 3 saves/daily', price:5, priceTier:'Plus monthly', tips:'Photoshop alternative for web | AI-powered generative fill | Fast and lightweight'),
    t('adobe-express-ai','Adobe Express','design','Easiest way to create social graphics and videos with Adobe Firefly AI.','https://adobe.com/express',true,true,250000, freeTier:'Free forever basic version', price:10, priceTier:'Premium monthly', tips:'Access to Adobe Stock | AI-powered text effects | Best for small businesses'),
    t('animoto-ai-video','Animoto','video','Easiest way to create professional videos and slideshows with AI styles.','https://animoto.com',true,true,84000, freeTier:'Free for unlimited videos', price:8, priceTier:'Basic monthly', tips:'Best for family and memories | Integrated with Getty Images | Easy music sync'),
    t('magisto-ai-pro','Magisto (Vimeo)','video','AI-powered video editor that turns your photos and clips into smart movies.','https://magisto.com',true,true,92000, freeTier:'Free basic trial', price:5, priceTier:'Premium monthly', tips:'Automated editing | Best for quick business promos | Owned by Vimeo'),
    t('splice-ai-pro','Splice','video','Powerful and simple mobile video editor for creators with AI transitions.','https://spliceapp.com',true,true,58000, freeTier:'Free trial available', price:5, priceTier:'Monthly subscription', tips:'Best for mobile creators | AI-powered music beat matching | Professional controls'),
    t('inshot-ai-apps','InShot','video','Leading mobile video and photo editor with AI-powered background and effects.','https://inshot.com',true,true,250000, freeTier:'Free basic version', price:4, priceTier:'Pro monthly', tips:'Best for Instagram Stories | Easy to use for beginners | Massive sticker library'),
    t('vivavideo-ai-app','VivaVideo','video','Fun and easy video editor with AI-powered facial effects and animation.','https://vivavideo.tv',true,true,120000, freeTier:'Free basic version', price:3, priceTier:'VIP monthly', tips:'Best for fun social clips | AI-powered magic effects | High viral potential'),

    // ━━━ AI FOR E-COMMERCE SELLERS ━━━
    t('helium-10-ai','Helium 10','ecommerce','The #1 AI-powered software for Amazon sellers to find and rank products.','https://helium10.com',true,true,84000, freeTier:'Free limited browser extension', price:39, priceTier:'Starter monthly', tips:'AI-powered product research | Optimize listings with "Adtomic" AI | Used by 2M+ sellers'),
    t('jungle-scout-ai','Jungle Scout','ecommerce','Leading platform for Amazon sellers to find profitable products with AI.','https://junglescout.com',false,true,58000, freeTier:'7-day free trial', price:49, priceTier:'Basic monthly', tips:'Extremely accurate sales estimates | AI-powered keyword research | Best for FBA'),
    t('vitals-ai-pro','Vitals','ecommerce','All-in-one Shopify marketing app with AI reviews and cross-selling.','https://vitals.co',false,true,45000, freeTier:'30-day free trial', price:30, priceTier:'Hobby plan monthly', tips:'Replaces 40+ Shopify apps | AI-powered bundle suggestions | High conversion rates'),
    t('loox-ai-reviews','Loox','ecommerce','Leading visual reviews and referrals for Shopify with AI sentiment.','https://loox.app',false,true,38000, freeTier:'14-day free trial', price:10, priceTier:'Beginner monthly', tips:'Beautiful review widgets | AI-powered photo moderation | High trust factor'),
    t('pagefly-ai-design','PageFly','ecommerce','The #1 Shopify page builder with AI-powered drag-and-drop design.','https://pagefly.io',true,true,25000, freeTier:'Free for 1 slot', price:24, priceTier:'Pay-as-you-go starting', tips:'Build any shop layout | High performance pages | 100+ templates'),
    t('gem-pages-ai','GemPages','ecommerce','Powerful Shopify landing page builder with AI design assistance.','https://gempages.net',true,true,18000, freeTier:'Free for 1 page', price:29, priceTier:'Build monthly', tips:'Best for high-converting sales pages | AI-powered "Instant Landing" | Fast support'),
    t('shogun-ai-design','Shogun','ecommerce','Enterprise-grade e-commerce page builder with AI content generation.','https://getshogun.com',false,false,15000, freeTier:'10-day free trial', price:39, priceTier:'Build plan monthly', tips:'Best for high-growth brands | AI-powered copy rewriting | Robust A/B testing'),
    t('okendo-ai-rev','Okendo','ecommerce','Customer marketing platform for e-commerce with AI-powered insights.','https://okendo.io',false,false,12000, freeTier:'Demo available', price:19, priceTier:'Essential monthly', tips:'High-end review collection | AI analyzes customer sentiment | Best for luxury brands'),
    t('judge-me-ai','Judge.me','ecommerce','The fastest and most affordable product reviews app for Shopify with AI.','https://judge.me',true,true,45000, freeTier:'Completely free forever plan', price:15, priceTier:'Awesome monthly', tips:'Unlimited review requests | AI-powered spam filter | Best value for money'),
    t('klaviyo-ai-flows','Klaviyo (AI Flows)','ecommerce','Intelligent email and SMS automation with AI-powered predictive analytics.','https://klaviyo.com',true,true,120000, freeTier:'Free for up to 250 contacts', price:30, priceTier:'Starter monthly', tips:'Predict when customers will buy | AI-powered segmentation | Industry standard'),

    // ━━━ AI FOR EDUCATION & KIDS ━━━
    t('abcmouse-ai','ABCmouse','education','The #1 learning program for kids 2-8 with AI-powered personalized paths.','https://abcmouse.com',true,true,250000, freeTier:'30-day free trial', price:13, priceTier:'Monthly subscription', tips:'10k+ learning activities | AI tracks progress across subjects | Safe and ad-free'),
    t('duolingo-abc-ai','Duolingo ABC','education','Fun and free way for kids to learn to read with AI-powered phonics.','https://duolingo.com/abc',true,true,180000, freeTier:'Completely free forever', price:0, tips:'Scientifically proven | AI-powered mini-games | From the makers of Duolingo'),
    t('toca-boca-ai','Toca Boca (AI Worlds)','education','Award-winning apps that invite kids to play and learn with AI characters.','https://tocaboca.com',true,true,84000, freeTier:'Free basic worlds', price:0, tips:'Open-ended play | AI-powered interactions | Best for creative kids'),
    t('epic-books-ai','Epic!','education','The leading digital library for kids with AI-powered reading recommendations.','https://getepic.com',true,true,120000, freeTier:'Free limited daily reading', price:5, priceTier:'Family monthly billed annually', tips:'40k+ books for kids | AI-powered read-to-me features | Trusted by teachers'),
    t('khan-academy-kids','Khan Academy Kids','education','Award-winning free educational app for kids 2-8 with AI-powered lessons.','https://khanacademy.org/kids',true,true,150000, freeTier:'Completely free forever', price:0, tips:'Created with Stanford experts | AI-powered "Teacher" guide | 100% non-profit'),
    t('prodigy-math-ai','Prodigy Math','education','Fantasy world where kids learn math through AI-powered battles and quests.','https://prodigygame.com',true,true,92000, freeTier:'Completely free to play', price:6, priceTier:'Premium membership monthly', tips:'High engagement | AI-powered adaptive difficulty | Best for elementary school'),
    t('mystery-science-ai','Mystery Science','education','Leading open-and-go science lessons with AI-powered video questions.','https://mysteryscience.com',true,true,58000, freeTier:'Free limited lessons', price:0, tips:'Owned by Discovery Education | Expert science explainers | Used by 50% of US schools'),
    t('brainpop-ai-pro','BrainPOP','education','Animated educational site for kids with AI-powered quizzes and games.','https://brainpop.com',true,true,120000, freeTier:'Free topic of the day', price:0, tips:'The famous "Tim and Moby" | AI for identifying learning gaps | Multi-subject'),
    t('outschool-ai-pro','Outschool','education','Marketplace of live online classes for kids with AI-powered matching.','https://outschool.com',true,true,45000, freeTier:'Free to browse classes', price:15, priceTier:'Avg per class starting', tips:'100k+ unique classes | AI identifies best teachers | Small group learning'),
    t('tynker-ai-pro','Tynker','education','Leading platform for kids to learn coding with AI-powered path.','https://tynker.com',true,false,35000, freeTier:'Free basic course', price:30, priceTier:'Quarterly subscription', tips:'Master Minecraft and Roblox coding | AI-powered feedback | Fun and gamified'),

    // ━━━ AI FOR SOCIAL GOOD ━━━
    t('crisis-text-line-ai','Crisis Text Line','health','Free 24/7 support at your fingertips with AI-powered triage and help.','https://crisistextline.org',true,true,150000, freeTier:'Completely free forever', price:0, tips:'AI identifies high-risk messages | Volunteer-powered | Anonymous and safe'),
    t('be-my-eyes-ai','Be My Eyes','social','Connecting blind and low-vision people with volunteers using AI.','https://bemyeyes.com',true,true,120000, freeTier:'Completely free for users', price:0, tips:'New "Virtual Volunteer" powered by GPT-4 | Global community | Life-changing impact'),
    t('seeing-ai-pro','Seeing AI (Microsoft)','social','Free app that narrates the world around you with AI for the blind.','https://microsoft.com/en-us/ai/seeing-ai',true,true,84000, freeTier:'Completely free from Microsoft', price:0, tips:'Identifies objects, people, and text | AI-powered facial recognition | Best on iOS'),
    t('good-guides-ai','GoodOnYou','fashion','Find ethical and sustainable fashion brands with AI-powered ratings.','https://goodonyou.eco',true,true,58000, freeTier:'Completely free app', price:0, tips:'AI analyzes brand sustainability | Thousands of ratings | Shop with purpose'),
    t('too-good-to-go-ai','Too Good To Go','social','AI-powered app to buy surplus food from local spots and save waste.','https://toogoodtogo.com',true,true,150000, freeTier:'Free app for users', price:4, priceTier:'Avg per "Surprise Bag"', tips:'Save food from being thrown away | Huge discounts | Global environmental impact'),
    t('olio-ai-share','OLIO','social','Leading local sharing app that uses AI to connect neighbors for surplus.','https://olioapp.com',true,false,45000, freeTier:'Completely free to use', price:0, tips:'Food and non-food sharing | Safe and community-driven | Reduce local waste'),
    t('charity-miles-ai','Charity Miles','health','Walk, run, or bike to earn money for charity with AI-powered tracking.','https://charitymiles.org',true,true,84000, freeTier:'Completely free for users', price:0, tips:'Corporate sponsors pay per mile | AI prevents fraud | 40+ top charities supported'),
    t('eia-ai-pro','EIA (Environmental Investigation)','science','Non-profit using AI to expose environmental crime and protect habitat.','https://eia-international.org',true,false,15000, freeTier:'Completely free research', price:0, tips:'AI detects illegal logging and trade | Investigative focus | Global impact'),
    t('nature-conserve-ai','The Nature Conservancy','science','Leading environmental non-profit using AI for global conservation.','https://nature.org',true,true,92000, freeTier:'Free to browse research', price:0, tips:'AI-powered smart forest monitoring | Global scale | Science-based impact'),
    t('world-food-ai','World Food Programme','science','The UN agency that uses AI for global food tracking and crisis detection.','https://wfp.org',true,true,120000, freeTier:'Completely free reports', price:0, tips:'AI-powered hunger mapping (HungerMap LIVE) | Save lives in crises | Nobel Peace Prize winner'),

    // ━━━ OTHER HIGH IMPACT AI ━━━
    t('openai-dall-e-3','DALL-E 3','design','OpenAI\'s most advanced image generation model built into ChatGPT.','https://openai.com/dall-e-3',true,true,500000, freeTier:'Free via Bing Image Creator', price:20, priceTier:'Included in ChatGPT Plus monthly', tips:'Best for prompt following | High quality consistency | Safe for commercial use'),
    t('google-deepmind','Google DeepMind (Research)','science','Explore the latest breakthroughs in AI from the world\'s leading lab.','https://deepmind.google',true,true,180000, freeTier:'Completely free papers', price:0, tips:'Home of AlphaGo and AlphaFold | AGI research leader | Part of Google'),
    t('mistral-ai-pro','Mistral AI','code','Leading European AI company building efficient and powerful models.','https://mistral.ai',true,true,120000, freeTier:'Free basic API access', price:0, tips:'Best for open-weights models | Highly efficient | Leading in performance/size ratio'),
    t('cohere-ai-pro','Cohere','code','Enterprise-focused AI platform for search, discovery, and generation.','https://cohere.com',true,true,84000, freeTier:'Free trial for 20 searches/min', price:15, priceTier:'Production starting price', tips:'Best for large language model RAG | Enterprise grade security | Multilingual support'),
    t('hugging-face-pro','Hugging Face','code','The world\'s most popular platform for open source machine learning.','https://huggingface.co',true,true,250000, freeTier:'Free for sharing and CPU spaces', price:9, priceTier:'Pro: extra compute and 더 monthly', tips:'The "GitHub of AI" | 500k+ models | 100k+ datasets | Essential for AI devs'),
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
