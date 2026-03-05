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
    // ━━━ AI FOR ROBOTICS & DRONES v2 ━━━
    t('dji-ai-pro-fly','DJI Fly (AI)','video','Leading drone software with AI-powered "MasterShots" and obstacle avoidance.','https://dji.com',true,true,999999, freeTier:'Free app for DJI owners', price:0, tips:'AI-powered "ActiveTrack" is world class | Best for solo filmmakers | Industry standard'),
    t('skydio-ai-pro','Skydio','video','The world\'s most advanced autonomous drone using Vision AI for tracking.','https://skydio.com',false,true,120000, freeTier:'Institutional/Consumer only', price:0, tips:'AI-powered avoidence 360-degrees | Made in USA | Best for extreme sports'),
    t('parrot-ai-drone','Parrot (FreeFlight)','video','Leading European drone brand using AI for mapping and thermal imaging.','https://parrot.com',true,true,84000, freeTier:'Free basic version', price:0, tips:'Best for industrial inspections | AI-powered security features | European tech'),
    t('boston-dynamics-ai','Boston Dynamics (Spot)','science','The most advanced legged robots in the world powered by high-end AI.','https://bostondynamics.com',false,true,150000, freeTier:'Institutional only', price:0, tips:'AI-powered navigation and balance | Iconic "Spot" and "Atlas" | Industry legend'),
    t('unitree-ai-robot','Unitree Robotics','science','Leading provider of high-performance quadruped robots and biped AI.','https://unitree.com',false,true,84000, freeTier:'Institutional only', price:0, tips:'First affordable "Dog" robots with AI | Global leader in scale | High-speed'),
    t('figure-ai-pro','Figure AI','science','Building the world\'s first commercially viable humanoid robot with AI.','https://figure.ai',false,true,58000, freeTier:'In development', price:0, tips:'Partnered with BMW and OpenAI | AI-powered multi-purpose work | Cutting edge'),
    t('tesla-optimus-ai','Tesla Optimus','science','Tesla\'s humanoid robot project using FSD-inspired vision AI.','https://tesla.com/optimus',false,true,250000, freeTier:'In development', price:0, tips:'Leverages Tesla\'s massive AI compute | Focused on assembly line work | Viral'),
    t('agility-robotics','Agility Robotics (Digit)','science','Leading provider of humanoid robots for warehouse logistics and AI.','https://agilityrobotics.com',false,false,35000, freeTier:'Institutional only', price:0, tips:'AI-powered "Digit" robot works at Amazon | Best for logistics | Reliable'),
    t('sanctuary-ai-pro','Sanctuary AI','science','Building human-like intelligence in general-purpose robots with AI.','https://sanctuary.ai',false,false,25000, freeTier:'In development', price:0, tips:'AI-powered "Phoenix" robot | Focus on dexterity | High tech'),
    t('1x-technologies-ai','1X Technologies','science','Leading humanoid robotics company focusing on safe human-robot collab.','https://1x.tech',false,true,45000, freeTier:'Supported by OpenAI', price:0, tips:'AI-powered "EVE" and "NEO" | Focused on home and work | Innovative'),

    // ━━━ AI FOR HARDWARE & CHIPS v2 ━━━
    t('intel-ai-pro-dev','Intel AI','code','Leading platform for AI developers with OpenVINO and high-end hardware.','https://intel.com/ai',true,true,500000, freeTier:'Free developer toolkits', price:0, tips:'Industry standard for PC AI | AI-powered "Core Ultra" | Robust and mature'),
    t('amd-ai-pro-ryzen','AMD AI (Ryzen)','code','Leading high-performance computing with Ryzen AI and open software.','https://amd.com/ai',true,true,350000, freeTier:'Free driver/kit updates', price:0, tips:'Best for gaming and workstations | AI-powered "Ryzen AI" engine | Open source focus'),
    t('arm-ai-pro-tech','ARM AI','code','The foundation of mobile AI with high-efficiency IP and AI processors.','https://arm.com/ai',false,true,250000, freeTier:'Institutional only', price:0, tips:'Powering 99% of phones in the world | AI-powered "Ethos" | Global leader'),
    t('qualcomm-ai-hub','Qualcomm AI Hub','code','Leading mobile and edge AI platform with specialized hardware data.','https://qualcomm.com/ai',true,true,180000, freeTier:'Free developer templates', price:0, tips:'AI-powered "Snapdragon" | Best for on-device AI | Huge scale'),
    t('apple-core-ai-dev','Apple Core ML','code','Leading framework for building on-device AI for iPhone and Mac.','https://developer.apple.com/machine-learning',true,true,999999, freeTier:'Completely free for Apple devs', price:0, tips:'Direct hardware access | AI-powered "Neural Engine" | Private and fast'),
    t('samsung-galaxy-ai','Samsung Galaxy AI','lifestyle','Suite of AI-powered mobile features for photo, text, and search.','https://samsung.com/galaxy-ai',true,true,999999, freeTier:'Included with Galaxy devices', price:0, tips:'AI-powered "Circle to Search" | High social engagement | Global reach'),
    t('google-tensor-ai','Google Tensor','code','Google\'s custom silicon for mobile AI and high-end photo data.','https://google.com/pixel',true,true,500000, freeTier:'Included with Pixel devices', price:0, tips:'AI-powered "Magic Eraser" | Best for Google ecosystem | High quality'),
    t('ti-ai-pro-hardware','Texas Instruments AI','code','Leading provider of embedded processors for industrial AI and sensing.','https://ti.com/ai',true,false,45000, freeTier:'Free SDKs and documentation', price:0, tips:'Industry standard for automotive | AI-powered "Jacinto" | Reliable'),
    t('st-micro-ai-pro','STMicroelectronics AI','code','Global leader in microcontrollers with AI-powered NanoEdge and data.','https://st.com/ai',true,false,35000, freeTier:'Free developer tools', price:0, tips:'Best for low-power IoT | AI-powered "STM32" | European leader'),
    t('raspberry-pi-ai','Raspberry Pi (AI)','code','Leading platform for educational hardware with new AI camera kits.','https://raspberrypi.com',true,true,250000, freeTier:'Free OS and tools', price:0, tips:'Best for learning AI hardware | Huge community | Low cost and versatile'),

    // ━━━ AI FOR PSYCHOLOGY & THERAPY v3 ━━━
    t('woebot-ai-pro','Woebot','health','Pioneering AI-powered chatbot for CBT and mental health support.','https://woebothealth.com',true,true,150000, freeTier:'Free basic version available', price:0, tips:'Built by Stanford psychologists | AI-powered check-ins | Clinically validated'),
    t('wysa-ai-pro-care','Wysa','health','Leading AI companion for mental health with human coach backup.','https://wysa.com',true,true,120000, freeTier:'Free basic AI chat', price:15, priceTier:'Premium monthly', tips:'Best for anxiety management | AI-powered "Exercise" | High privacy focus'),
    t('youper-ai-care','Youper','health','AI-powered emotional health assistant for tracking and CBT.','https://youper.ai',true,true,84000, freeTier:'7-day free trial on site', price:10, priceTier:'Premium monthly starting', tips:'AI-powered "Mood" tracking | Personal and fast | High engagement'),
    t('ginger-ai-wellness','Ginger (Headspace)','health','On-demand mental health support with AI-powered coaching and therapy.','https://ginger.io',false,true,150000, freeTier:'Employer plans only', price:0, tips:'Acquired by Headspace | AI-powered triage | Available 24/7'),
    t('lyra-health-ai','Lyra Health','health','Leading platform for employer mental health with AI matching.','https://lyrahealth.com',false,true,120000, freeTier:'Employer plans only', price:0, tips:'Best for Fortune 500 companies | AI-powered counselor matching | Pro'),
    t('talk-space-ai-pro','Talkspace','health','The pioneer in online therapy with AI-powered progress tracking.','https://talkspace.com',true,true,350000, freeTier:'Free initial assessment', price:69, priceTier:'Starting per week', tips:'Best for long-term therapy | AI-powered "Psychiatry" tools | Most popular'),
    t('better-help-ai','BetterHelp','health','The world\'s largest therapy platform using AI for counselor matching.','https://betterhelp.com',true,true,500000, freeTier:'Free initial quiz and plan', price:60, priceTier:'Starting per week', tips:'Largest network of therapists | AI-powered "Matching" | Massive scale'),
    t('cerebral-ai-pro','Cerebral','health','Leading platform for online mental health and medication with AI.','https://cerebral.com',false,true,84000, freeTier:'No free tier', price:99, priceTier:'Monthly membership base', tips:'Best for ADHD and depression | AI-powered "Clinician" dash | Tech-forward'),
    t('calm-health-ai','Calm Health','health','The clinical side of Calm using AI for patient mental health tools.','https://calm.com/health',false,false,45000, freeTier:'Insurance only', price:0, tips:'AI-powered "Clinical" tracks | Designed for hospitals | Robust'),
    t('modern-health-ai','Modern Health','health','Comprehensive employer mental health platform with AI-powered pathways.','https://modernhealth.com',false,false,35000, freeTier:'Employer plans only', price:0, tips:'Best global coverage | AI-powered "Triaging" | High quality focus'),

    // ━━━ AI FOR ADVERTISING & BRANDING v3 ━━━
    t('google-ads-ai-pro','Google Ads (AI)','marketing','The world\'s largest advertising platform with AI-powered Performance Max.','https://ads.google.com',true,true,999999, freeTier:'Free to join and list', price:0, tips:'AI-powered "Search" and "Display" | Most powerful targeting | Global leader'),
    t('meta-ads-ai-pro','Meta Ads (Advantage+)','marketing','Leading social advertising with AI-powered audience and creative help.','https://ads.facebook.com',true,true,999999, freeTier:'Free to join and browse', price:0, tips:'Best for e-commerce | AI-powered "Advantage+" | Billion user reach'),
    t('tiktok-ads-ai','TikTok Ads (Smart)','marketing','Leading short-form video ads with AI-powered creative and trends.','https://ads.tiktok.com',true,true,500000, freeTier:'Free to join and learn', price:0, tips:'Best for Gen Z | AI-powered "Creative Center" | Viral potential'),
    t('linkedin-ads-ai','LinkedIn Ads','marketing','The #1 B2B advertising platform with AI-powered professional data.','https://business.linkedin.com/ads',true,true,350000, freeTier:'Free to join and learn', price:0, tips:'Target by job title and industry | AI-powered "Lead Gen" | High value'),
    t('amazon-ads-ai-pro','Amazon Ads','marketing','Leading retail advertising with AI-powered product and data help.','https://advertising.amazon.com',true,true,500000, freeTier:'Free for sellers account', price:0, tips:'Best for Amazon sellers | AI-powered "Sponsored Products" | Most mature'),
    t('snap-ads-ai-pro','Snapchat Ads','marketing','Leading AR and video advertising with AI-powered audience tools.','https://forbusiness.snapchat.com',true,true,180000, freeTier:'Free to browse and learn', price:0, tips:'Best for AR campaigns | AI-powered "Lenses" | Mobile first'),
    t('pinterest-ads-ai','Pinterest Ads','marketing','Visual advertising platform with AI-powered discovery and shopping.','https://ads.pinterest.com',true,true,250000, freeTier:'Free to browse and learn', price:0, tips:'Best for visual brands | AI-powered "Visual Search" | High intent'),
    t('reddit-ads-ai-pro','Reddit Ads','marketing','Target niche communities with AI-powered context and data help.','https://ads.reddit.com',true,false,150000, freeTier:'Free to join and learn', price:0, tips:'Best for community engagement | AI-powered "Keyword" search | Viral'),
    t('taboola-ai-pro','Taboola','marketing','Leading native discovery platform using AI to power content ads.','https://taboola.com',true,false,120000, freeTier:'Free to browse and learn', price:0, tips:'Best for publishers | AI-powered "SmartBid" | Massive reach on news sites'),
    t('outbrain-ai-pro','Outbrain','marketing','Leading recommendation platform using AI for native advertising.','https://outbrain.com',true,false,84000, freeTier:'Free to browse and learn', price:0, tips:'Best for content marketing | AI-powered "Zemanta" | Global network'),

    // ━━━ FINAL GEMS v18 (Developer Logistics) ━━━
    t('terminal-ai-pro','Warp','code','The modern terminal with built-in AI for commands and collaboration.','https://warp.dev',true,true,120000, freeTier:'Free for personal use', price:12, priceTier:'Individual monthly', tips:'AI-powered "Command" search | Blazing fast (Rust) | Best for modern devs'),
    t('iterm2-ai-pro','iTerm2 (AI)','code','Leading macOS terminal with AI-powered plugins and search help.','https://iterm2.com',true,true,250000, freeTier:'Completely free open source', price:0, tips:'Industry standard for Mac | AI-powered "Bard" plugin | Highly customizable'),
    t('fig-ai-pro-shell','Fig (Amazon)','code','Leading shell autocomplete and AI assistant for the command line.','https://fig.io',true,true,180000, freeTier:'Acquired by Amazon - Free Beta', price:0, tips:'Best for team autocomplete | AI-powered "Scripts" | Developer favorite'),
    t('oh-my-zsh-ai','Oh My Zsh','code','The framework for Zsh with AI-powered plugins and themes.','https://ohmyz.sh',true,true,500000, freeTier:'Completely free forever', price:0, tips:'Used by millions of devs | 300+ plugins | Open source legend'),
    t('homebrew-ai-pro','Homebrew','code','The "Missing Package Manager" for macOS using AI for package search.','https://brew.sh',true,true,999999, freeTier:'Completely free forever', price:0, tips:'Essential for every dev | AI-powered "Analytic" data | Industry standard'),
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
