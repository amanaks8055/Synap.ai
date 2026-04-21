// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'env.dart';

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
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
  final client = HttpClient();

  final tools = <Map<String, dynamic>>[
    // ━━━ AI FOR NOTES & SECOND BRAIN (Iconic) ━━━
    t('notion-ai-pro','Notion','productivity','The world\'s #1 workspace with built-in "Notion AI" for writing and data.','https://notion.so',true,true,999999, freeTier:'Free forever personal basic version', price:10, priceTier:'Plus monthly per user', tips:'AI-powered "Q&A" for your own notes | Best for all-in-one productivity | Global leader'),
    t('obsidian-ai-pro','Obsidian','productivity','Powerful and private note-taking app with a massive AI-powered plugin system.','https://obsidian.md',true,true,500000, freeTier:'Completely free for personal use', price:8, priceTier:'Sync monthly annual', tips:'Best for networked thought (ZK) | AI-powered "Smart Connections" | Developer favorite'),
    t('roam-ai-pro-mind','Roam Research','productivity','The original "Second Brain" for networked thought with AI-powered search.','https://roamresearch.com',false,true,180000, freeTier:'Institutional only', price:15, priceTier:'Monthly membership', tips:'Best for academic research | AI-powered "Block" references | High trust'),
    t('logseq-ai-pro','Logseq','productivity','Open-source and private knowledge base with AI-powered task management.','https://logseq.com',true,true,120000, freeTier:'Completely free forever', price:0, tips:'Privacy first | AI-powered "Query" system | Best for power users'),
    t('hepta-base-ai','Heptabase','productivity','Visual note-taking tool for learning complex topics with AI-powered mapping.','https://heptabase.com',false,true,58000, freeTier:'Institutional only', price:8, priceTier:'Monthly annual subscription', tips:'Best for visual thinkers | AI-powered "Card" system | high quality UI'),
    t('mem-ai-pro-note','Mem','productivity','The first AI-native workspace that organizes your notes for you automatically.','https://mem.ai',true,true,150000, freeTier:'Free basic version available', price:12, priceTier:'Premium monthly', tips:'AI-powered "Automated" organization | Best for fast catch-up | Innovative'),
    t('capacities-ai','Capacities','productivity','Object-based note-taking for networked thought with AI-powered visuals.','https://capacities.io',true,true,84000, freeTier:'Free forever basic version', price:10, priceTier:'Believer monthly annual', tips:'Best for organizing people/books | AI-powered "Assistant" | European tech'),
    t('craft-docs-ai','Craft','productivity','Leading document editor with AI-powered "Assistant" and beautiful design.','https://craft.do',true,true,250000, freeTier:'Free forever basic version', price:10, priceTier:'Plus monthly annual', tips:'Apple Design Award winner | AI-powered "Summaries" | High end visuals'),
    t('standard-notes-ai','Standard Notes','productivity','Leading secure and private note taking with AI-powered extensions.','https://standardnotes.com',true,true,120000, freeTier:'Free basic version available', price:10, priceTier:'Productivity monthly annual', tips:'End-to-end encrypted | AI-powered "Markdown" | high security focus'),
    t('ever-note-ai-pro','Evernote','productivity','The iconic note-taking app with new AI-powered "Search" and "Cleanup".','https://evernote.com',true,true,999999, freeTier:'Free basic version (fixed limits)', price:15, priceTier:'Personal monthly', tips:'The industry legend | AI-powered "Tasks" | robust across all devices'),

    // ━━━ AI FOR CLIMBING & BOULDERING ━━━
    t('the-crag-ai-climb','theCrag','lifestyle','The world\'s largest collaborative climbing guide with AI-powered beta.','https://thecrag.com',true,true,180000, freeTier:'Completely free for the public', price:0, tips:'Find every route in the world | AI-powered "Tick" logs | Global community'),
    t('mountain-proj-ai','Mountain Project (REI)','lifestyle','The #1 US climbing guide using AI for photo identification and safety.','https://mountainproject.com',true,true,500000, freeTier:'Completely free forever', price:0, tips:'Owned by REI | AI-powered "Route" search | Best for US climbers'),
    t('27-crags-ai-pro','27crags','lifestyle','Leading European bouldering guide with AI-powered GPS and premium topos.','https://27crags.com',true,true,150000, freeTier:'Free basic version available', price:5, priceTier:'Premium monthly', tips:'Best for European bouldering | AI-powered "Local" tips | Reliable'),
    t('k-limb-ai-pro','Krimp','lifestyle','The #1 training app for climbers using AI for personalized session plans.','https://krimptraining.com',true,true,120000, freeTier:'Free basic version online', price:10, priceTier:'Premium monthly annual', tips:'Founded by Stian Christophersen | AI-powered "Core" plans | high quality'),
    t('moon-board-ai','MoonBoard','lifestyle','Connect with the global MoonBoard community using AI-powered benchmarks.','https://moonboarding.com',true,true,84000, freeTier:'Free app for board owners', price:0, tips:'The ultimate training board | AI-powered "Problem" search | Global standard'),

    // ━━━ AI FOR HEALTH (Sleep & Snoring) ━━━
    t('snore-lab-ai-pro','SnoreLab','health','The world\'s #1 snoring tracker using AI to monitor and improve sleep.','https://snorelab.com',true,true,250000, freeTier:'Free basic version available', price:5, priceTier:'Premium yearly annual', tips:'Track Every snore with AI | AI-powered "Remedy" testing | high trust'),
    t('sleep-cycle-ai','Sleep Cycle','health','Leading smart alarm clock using AI-powered sound analysis and logs.','https://sleepcycle.com',true,true,999999, freeTier:'Free basic version available', price:30, priceTier:'Premium yearly starting', tips:'AI-powered "Cough" tracking | Best for non-wearable data | World leader'),
    t('shut-eye-ai-pro','ShutEye','health','AI-powered sleep assistant for tracking, music, and dream logs.','https://shuteye.ai',true,true,180000, freeTier:'Free trial available', price:10, priceTier:'Premium monthly', tips:'AI-powered "Dream" analysis | Best for relaxation | high quality UI'),
    t('pillow-ai-sleep','Pillow','health','Leading Apple Watch sleep tracker using AI for sound and heart data.','https://pillow.app',true,true,250000, freeTier:'Free basic version', price:5, priceTier:'Premium monthly', tips:'Best for Apple ecosystem | AI-powered "Snooze" help | Beautiful visuals'),
    t('aura-health-ai','Aura Health','health','The "Spotify for Mental Health" with AI-powered sleep and coaching.','https://aurahealth.io',true,true,350000, freeTier:'Free trial available', price:100, priceTier:'Yearly membership', tips:'AI-powered "Coach" matching | Best for daily habits | High engagement'),

    // ━━━ AI FOR GEOSCIENCE (Mineralogy & Gemology v2) ━━━
    t('mindat-ai-pro-data','Mindat.org','science','The world\'s largest mineral database with AI-powered search and data.','https://mindat.org',true,true,500000, freeTier:'Completely free open data', price:0, tips:'The gold standard for mineralogists | AI-powered "Photo" ID help | Non-profit'),
    t('gem-a-ai-pro-sci','Gem-A (Digital)','science','The Gemmological Association of GB with AI-powered gem research logs.','https://gem-a.com',true,true,35000, freeTier:'Free resources for students', price:0, tips:'Oldest gem lab in the world | AI-powered "Instrument" guides | High trust'),
    t('gia-ai-pro-gems','GIA (Digital)','science','The world\'s #1 authority on diamonds and gems using high-end AI labs.','https://gia.edu',true,true,500000, freeTier:'Vast open records and data', price:0, tips:'Creator of the 4Cs | AI-powered "Retailer" search | International leader'),
    t('rock-id-ai-pro-geo','Rock Identifier','science','Identify any rock or stone instantly using AI-powered visual recognition.','https://rockidentifier.com',true,true,120000, freeTier:'Free basic identification', price:20, priceTier:'Premium yearly annual', tips:'AI-powered "Value" estimator | Best for rockhounds | high accuracy'),
    t('mineral-id-ai-pro','Mineral ID','science','Leading community driven mineral identification using AI and expert check.','https://mineral-id.com',true,false,45000, freeTier:'Free basic version', price:0, tips:'Best for field mineralogy | AI-powered "Crystallography" | reliable'),

    // ━━━ AI FOR LIGHTING & SOUND DESIGN ━━━
    t('dialux-ai-pro-light','DIALux','design','Leading professional lighting design software with AI-powered calc.','https://dialux.com',true,true,350000, freeTier:'Completely free for designers', price:0, tips:'Industry standard for light planning | AI-powered "Room" creation | Robust'),
    t('relux-ai-pro-light','Relux','design','High-end lighting and sensor design platform with AI-powered logs.','https://relux.com',true,true,120000, freeTier:'Free forever basic version', price:0, tips:'Best for European standards | AI-powered "Product" data | precise'),
    t('spl-ai-pro-sound','SPL Meter (AI)','science','Professional sound level meter with AI-powered frequency analysis.','https://studiosixdigital.com',true,false,45000, freeTier:'Free basic version available', price:20, priceTier:'Pro unlock one-time', tips:'Used by pro acoustic engineers | AI-powered "RTA" | High precision'),
    t('audio-hijack-ai','Audio Hijack','productivity','Legendary macOS audio tool with AI-powered noise reduction and EQ.','https://rogueamoeba.com',true,true,150000, freeTier:'Free trial (noise on export)', price:64, priceTier:'One-time purchase', tips:'Best for podcasters and streamers | AI-powered "Broadcast" help | Mac only'),
    t('sound-source-ai','SoundSource','productivity','The ultimate macOS sound control with AI-powered per-app volume.','https://rogueamoeba.com',true,true,120000, freeTier:'Free trial available', price:39, priceTier:'One-time purchase', tips:'Best for power users | AI-powered "Super Volume" | Cleanest UI'),

    // ━━━ FINAL GEMS v31 (Modern AI APIs) ━━━
    t('fal-ai-pro-gen','Fal.ai','code','The fastest platform for building real-time generative AI apps with APIs.','https://fal.ai',true,true,180000, freeTier:'Free trial with credits', price:0, tips:'Best for real-time diffusion | AI-powered "Scaling" | Developer favorite'),
    t('together-ai-pro','Together AI','code','Leading cloud platform for training and fine-tuning open source AI models.','https://together.ai',true,true,250000, freeTier:'Free trial with \$25 credits', price:0, tips:'Compute for the masses | AI-powered "Turing" clusters | high performance'),
    t('replicate-ai-pro','Replicate','code','Run machine learning models in the cloud with a simple API using AI.','https://replicate.com',true,true,500000, freeTier:'Free for public models (pay per work)', price:0, tips:'Best for testing GitHub models | AI-powered "Deploy" | The standard for hackathons'),
    t('runpod-ai-pro','RunPod','code','Leading GPU cloud for AI training and inference with high-end hardware.','https://runpod.io',false,true,150000, freeTier:'Institutional only', price:0.5, priceTier:'Starting per hour GPU', tips:'Best for serverless GPU | AI-powered "Pods" | High flexibility and low cost'),
    t('vast-ai-pro-cloud','Vast.ai','code','The world\'s largest marketplace for low-cost GPU compute with AI help.','https://vast.ai',false,true,120000, freeTier:'Institutional only', price:0.1, priceTier:'Starting per hour GPU', tips:'Most affordable GPU time | AI-powered "Instance" search | Reliable'),
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
