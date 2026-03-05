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
    // ━━━ AI FOR REAL ESTATE & ARCHITECTURE ━━━
    t('zillow-ai-pro','Zillow (AI Features)','business','Leading real estate marketplace with AI-powered "Zestimate" and 3D tours.','https://zillow.com',true,true,500000, freeTier:'Completely free to search and browse', price:0, tips:'AI identifies home features from photos | Interactive 3D home tours | Best for home buyers'),
    t('redfin-ai-pro','Redfin','business','Modern real estate brokerage using AI to find homes and value properties.','https://redfin.com',true,true,250000, freeTier:'Free to browse and search', price:0, tips:'Real-time market data | AI-powered home suggestions | Lower fees for sellers'),
    t('realtor-com-ai','Realtor.com','business','Official source for real estate listings with AI-powered search filters.','https://realtor.com',true,true,180000, freeTier:'Completely free for users', price:0, tips:'Accurate professional data | AI-powered local neighborhood insights | Reliable'),
    t('matterport-ai-3d','Matterport','design','Leading 3D digital twin platform for real estate and construction with AI.','https://matterport.com',true,true,84000, freeTier:'Free for 1 active space', price:10, priceTier:'Starter monthly', tips:'Create professional 3D tours | AI-powered room identification | Industry standard'),
    t('airdna-ai-pro','AirDNA','business','The gold standard for short-term rental data and AI-powered performance.','https://airdna.co',true,true,45000, freeTier:'Free basic market research', price:15, priceTier:'Essential monthly', tips:'Predict Airbnb income with AI | Best for investors | Global coverage'),
    t('reonomy-ai-pro','Reonomy','business','The largest commercial real estate data platform using AI for discovery.','https://reonomy.com',false,true,15000, freeTier:'Demo available', price:0, tips:'Acquired by Altus Group | AI-powered ownership discovery | Best for CRE pros'),
    t('cherre-ai-pro','Cherre','business','Leading real estate data management platform that unifies sources with AI.','https://cherre.com',false,false,8400, freeTier:'Institutional only', price:0, tips:'Connect all real estate data | AI-powered risk analysis | Enterprise grade'),
    t('propstream-ai-pro','PropStream','business','Leading platform for real estate investors using AI for lead generation.','https://propstream.com',false,true,35000, freeTier:'7-day free trial', price:99, priceTier:'Monthly subscription', tips:'Find motivated sellers | AI-powered skip tracing | Best for wholesalers'),
    t('dealmachine-ai','DealMachine','business','Easiest way for real estate investors to find deals using AI for driving.','https://dealmachine.com',true,true,45000, freeTier:'Free trial for 7 days', price:59, priceTier:'Basic monthly', tips:'"Drive for Dollars" app | AI targets distressed properties | Automated mailers'),
    t('keyway-ai-pro','Keyway','business','AI-powered platform for commercial real estate transactions and management.','https://keyway.com',false,false,5600, freeTier:'Demo available', price:0, tips:'Fastest CRE deals | AI-powered underwriting | Data-driven institutional'),

    // ━━━ AI FOR PETS, VETS & ANIMALS ━━━
    t('rover-ai-pro','Rover','lifestyle','World\'s largest network of per sitters and dog walkers with AI matching.','https://rover.com',true,true,250000, freeTier:'Free app for users', price:0, tips:'AI-powered trust and safety | Verified reviews for sitters | Daily card updates'),
    t('wag-ai-pro','Wag!','lifestyle','On-demand dog walking and pet services with AI-powered GPS and tracking.','https://wagwalking.com',true,true,120000, freeTier:'Free app for users', price:0, tips:'Insured and bonded sitters | AI-powered walker alerts | 24/7 support'),
    t('fuziee-ai-pet','Fuzzie','lifestyle','AI-powered app for managing your pet\'s health, schedule, and records.','https://fuzzie.io',true,false,15000, freeTier:'Free to browse', price:0, tips:'AI-powered pet diary | Health alerts based on patterns | Community-driven'),
    t('petcube-ai-cam','Petcube','lifestyle','Smart pet camera with AI-powered vet chat and activity detection.','https://petcube.com',true,true,84000, freeTier:'Free basic app', price:6, priceTier:'Pet Care monthly', tips:'AI detects human vs pet | Integrated 24/7 vet support | High-res camera'),
    t('whistle-ai-pet','Whistle','lifestyle','Health and location tracker for pets using AI to identify behaviors.','https://whistle.com',false,true,45000, freeTier:'Hardware purchase required', price:8, priceTier:'Monthly subscription', tips:'AI identifies scratching and licking | Precise GPS tracking | Best for active dogs'),
    t('basepaws-ai','Basepaws','lifestyle','Leading cat DNA test using AI to identify breed and health traits.','https://basepaws.com',false,true,25000, freeTier:'Hardware purchase required', price:99, priceTier:'One-time test', tips:'Learn your cat\'s genetics | AI-powered dental health report | Unique and cool'),
    t('wisdom-panel-ai','Wisdom Panel','lifestyle','The world\'s leading dog DNA test with AI-powered breed identification.','https://wisdompanel.com',false,true,58000, freeTier:'Hardware purchase required', price:80, priceTier:'One-time test starting', tips:'Over 350 breeds identified | AI targets health risks | Most accurate for dogs'),
    t('embark-ai-test','Embark','lifestyle','High-end dog DNA test developed by vet experts using AI genetics.','https://embarkvet.com',false,true,35000, freeTier:'Hardware purchase required', price:129, priceTier:'One-time test', tips:'Highest craftmanship in genetics | AI finds relatives | Trusted by breeders'),
    t('vetster-ai-pro','Vetster','health','The world\'s largest marketplace for on-demand virtual vet appointments.','https://vetster.com',true,true,84000, freeTier:'Free to browse vets', price:50, priceTier:'Avg per appointment', tips:'24/7 access to experts | AI for pre-screening | Secure video chat'),
    t('pawp-ai-member','Pawp','health','24/7 virtual vet and emergency fund for your pets with AI support.','https://pawp.com',false,true,58000, freeTier:'No free tier', price:24, priceTier:'Monthly membership', tips:'Includes \$3,000 emergency fund | AI-powered triage | Unlimited vet chats'),

    // ━━━ GOLF, FISHING & OUTDOOR HOBBIES AI ━━━
    t('arcoss-golf-ai','Arccos Golf','health','Leading AI-powered platform for golf performance tracking and caddie.','https://arccosgolf.com',false,true,45000, freeTier:'Hardware purchase required', price:12, priceTier:'Monthly billed annually', tips:'Official caddie of the PGA Tour | AI-powered "Plays Like" distance | Learn your gaps'),
    t('golfshot-ai-pro','Golfshot','health','Leading golf GPS and tracker with AI-powered voice and auto-tracking.','https://golfshot.com',true,true,120000, freeTier:'Free basic GPS version', price:4, priceTier:'Pro per month billed annually', tips:'Track every shot automatically | AI-powered "Auto-Shot" | Available on Apple Watch'),
    t('fishbrain-ai-pro','Fishbrain','entertainment','The world\'s #1 social network for anglers with AI-powered catch logs.','https://fishbrain.com',true,true,250000, freeTier:'Free basic social version', price:10, priceTier:'Pro monthly', tips:'Find hot fishing spots with AI | Predict the best time to fish | Identification tool'),
    t('fish-angler-ai','FishAngler','entertainment','Free and comprehensive fishing app with AI-powered weather and logs.','https://fishangler.com',true,true,150000, freeTier:'Completely free for everyone', price:0, tips:'Log your catches for research | AI-powered "Catch Insights" | Massive community'),
    t('alltrails-ai-pro','AllTrails','travel','The world\'s most popular hiking and trail app with AI-powered navigation.','https://alltrails.com',true,true,999999, freeTier:'Free basic version', price:3, priceTier:'Pro monthly billed annually', tips:'Download maps for offline use | AI-powered "Navigate" | 400k+ hand-curated trails'),
    t('strava-ai-pro','Strava','health','The leading social network for athletes with AI-powered segments and goals.','https://strava.com',true,true,999999, freeTier:'Free basic version', price:12, priceTier:'Premium monthly', tips:'AI-powered "Segment" leaderboards | Best community for runners/cyclists | Privacy first'),
    t('trainingpeaks-ai','TrainingPeaks','health','World-class training software for endurance athletes with AI analytics.','https://trainingpeaks.com',true,true,84000, freeTier:'Free basic version', price:20, priceTier:'Premium monthly', tips:'Used by pro cyclists and triathletes | AI-powered "TSS" load tracking | Plan your peak'),
    t('komoot-ai-pro','komoot','travel','Discover the best trails for trekking and cycling with AI-powered routes.','https://komoot.com',true,true,180000, freeTier:'Free basic version (1 region)', price:30, priceTier:'Premium annual', tips:'Best for bike tours in Europe | AI-powered surface analysis | Expert highlights'),
    t('onx-maps-ai','onX Hunt','travel','Leading GPS app for hunters using AI to find public and private land.','https://onxmaps.com',true,true,120000, freeTier:'7-day free trial', price:30, priceTier:'Premium annual per state', tips:'High resolution satellite maps | AI identifies property lines | Essential for hunters'),
    t('garden-answers-ai','Garden Answers','science','Identify over 20,000 plants instantly with your camera and AI.','https://gardenanswers.com',true,true,150000, freeTier:'Completely free to use', price:0, tips:'Identify pests and diseases | AI-powered "Advice" database | Best for gardeners'),

    // ━━━ AI FOR GAMING & METAVERSE (Meta Assets) ━━━
    t('roblox-ai-dev','Roblox Studio AI','entertainment','Leading platform for creating games with new AI-powered code and material.','https://roblox.com/create',true,true,999999, freeTier:'Completely free to build', price:0, tips:'AI-powered "Assistant" for Luau code | Generative textures | Reach 70M+ daily users'),
    t('unity-muse-ai','Unity Muse','code','The AI-powered companion for Unity developers to create textures and sprites.','https://unity.com/muse',true,true,84000, freeTier:'30-day free trial', price:30, priceTier:'Muse monthly', tips:'Best for Unity game devs | AI text-to-code and texture | Integrated in editor'),
    t('inworld-ai-pro','Inworld AI','entertainment','Leading platform for creating AI-powered NPCs and characters for games.','https://inworld.ai',true,true,45000, freeTier:'Free for personal/education', price:20, priceTier:'Pro: more interaction mins monthly', tips:'Realistic character personalities | AI-powered voice and logic | Unity/UE focus'),
    t('ready-player-me','Ready Player Me','entertainment','Cross-game avatar platform using AI to create your digital twin.','https://readyplayer.me',true,true,150000, freeTier:'Completely free for users', price:0, tips:'Use one avatar in 10k+ apps/games | AI identifies your face from photo | Most popular'),
    t('modulate-ai-tox','Modulate (ToxMod)','entertainment','AI-powered voice moderation for online games to prevent toxicity.','https://modulate.ai',false,true,12000, freeTier:'Demo available', price:0, tips:'Trusted by Call of Duty and Rec Room | AI filters in real-time | Safe gaming for kids'),
    t('any-world-ai','Anyworld','entertainment','AI platform for automating 3D rigging and animation for games.','https://anyworld.com',true,false,9200, freeTier:'Free trial available', price:15, priceTier:'Individual monthly', tips:'Rig any 3D model in seconds with AI | Huge library of assets | Fast and scalable'),
    t('kaedim-ai-pro','Kaedim','design','Convert 2D images to high-quality 3D models automatically with AI.','https://kaedim3d.com',false,true,18000, freeTier:'Demo available', price:150, priceTier:'Starter monthly', tips:'Best for quick asset generation | Used by game studios | High quality topology'),
    t('promethean-ai','Promethean AI','design','The world\'s first AI for building virtual worlds and digital environments.','https://prometheanai.com',true,true,12000, freeTier:'Free for personal projects', price:50, priceTier:'Commercial monthly', tips:'Create environments by talking to AI | Integrated with Unreal and Maya | Fast'),
    t('poly-ai-textures','Polycam (AI)','design','Leading 3D scanning app using AI for photogrammetry and LIDAR.','https://poly.cam',true,true,150000, freeTier:'Free basic scans', price:8, priceTier:'Pro per month billed annually', tips:'Scan the world in 3D with your phone | AI-powered "RoomPlan" | Export to OBJ/GLTF'),
    t('skybox-lab-ai','Blockade Labs (Skybox)','design','Generate beautiful 360-degree virtual worlds from text with AI.','https://blockadelabs.com',true,true,84000, freeTier:'Free basic generations', price:10, priceTier:'Pro monthly', tips:'One click skybox generation | Best for VR and game backgrounds | High resolution'),

    // ━━━ CRYPTO, WEB3 & DATA INTEL AI ━━━
    t('nansen-ai-crypto','Nansen','business','Real-time crypto and NFT analytics with AI-powered wallet labeling.','https://nansen.ai',true,true,120000, freeTier:'Free basic data lite', price:99, priceTier:'Standard monthly', tips:'Identify "Smart Money" movements | AI-powered risk signals | Used by top traders'),
    t('dune-analytics-ai','Dune Analytics','business','Community-driven crypto data dashboards using AI for SQL suggestions.','https://dune.com',true,true,150000, freeTier:'Completely free to browse', price:0, tips:'Most powerful crypto data tool | AI-powered "Dune Wizard" assistant | Public data'),
    t('arkham-intel-ai','Arkham Intelligence','business','Leading blockchain intelligence platform using AI for deanonymization.','https://arkhamintelligence.com',true,true,180000, freeTier:'Completely free for everyone', price:0, tips:'Track any wallet in real-time | AI-powered "ULTRA" engine | Investigate scams'),
    t('glassnode-ai-pro','Glassnode','business','Leading on-chain data and market intelligence using AI for charts.','https://glassnode.com',true,true,84000, freeTier:'Free basic on-chain metrics', price:29, priceTier:'Standard monthly', tips:'Professional grade metrics | AI identifies market cycles | Reliable and trusted'),
    t('the-block-pro-ai','The Block Pro','business','Premium research and data on digital assets using AI for insights.','https://theblock.pro',false,true,45000, freeTier:'Institutional only', price:0, tips:'Best for institutional crypto research | AI-powered market alerts | Detailed data'),
    t('crypto-quant-ai','CryptoQuant','business','Data and analytics for crypto markets using AI-powered on-chain data.','https://cryptoquant.com',true,true,58000, freeTier:'Free basic account', price:29, priceTier:'Advanced monthly', tips:'Identify whale movements | AI-powered alerts | Global community'),
    t('token-terminal-ai','Token Terminal','business','Financial data for blockchains and dapps with AI-powered reporting.','https://tokenterminal.com',true,true,35000, freeTier:'Free to browse basic data', price:325, priceTier:'Pro monthly', tips:'Best for fundamental analysis | AI identifies profitable protocols | High trust'),
    t('messari-ai-pro','Messari','business','Leading crypto research and data platform with AI-powered news tools.','https://messari.io',true,true,120000, freeTier:'Free basic research', price:25, priceTier:'Pro monthly', tips:'Track the whole ecosystem | AI-powered "Governor" for DAOs | Detailed research'),
    t('elliptic-ai-pro','Elliptic','business','Global leader in crypto risk management and compliance with AI.','https://elliptic.co',false,false,12000, freeTier:'Institutional only', price:0, tips:'Best for banking and legal | AI verifies crypto transactions | Safety focus'),
    t('chainalysis-ai','Chainalysis','business','The most trusted blockchain data and analytics platform using AI.','https://chainalysis.com',false,true,92000, freeTier:'Free reports available', price:0, tips:'Partner of FBI and IRS | AI identifies illegal activities | The industry gold standard'),

    // ━━━ FINAL GEMS ━━━
    t('openai-sora-video','Sora (Research)','video','OpenAI\'s upcoming text-to-video model that creates highly realistic scenes.','https://openai.com/sora',false,true,999999, freeTier:'Currently not public', price:0, tips:'Most anticipated AI tool | Photorealistic video up to 60s | Physics-accurate'),
    t('google-veo-video','Veo (Google)','video','Google\'s most capable generative video model for creators and brands.','https://deepmind.google/technologies/veo',false,true,250000, freeTier:'Waitlist available', price:0, tips:'Direct competitor to Sora | Built for 1080p and longer clips | Part of Google Cloud'),
    t('meta-movie-gen','Movie Gen (Meta)','video','Meta\'s new AI tool for generating high-quality video and audio together.','https://ai.meta.com/research/movie-gen',false,true,150000, freeTier:'Research stage', price:0, tips:'Synchronized audio and video | Realistic human movement | Meta AI integration'),
    t('notion-ai-writer','Notion AI','productivity','Write faster and better directly inside your Notion workspace with AI.','https://notion.com/product/ai',true,true,999999, freeTier:'Free trial for everyone', price:8, priceTier:'Fixed per user monthly', tips:'Best for summarizing notes | Integrated in your docs | Write/Edit/Draft with ease'),
    t('zoom-ai-companion','Zoom AI Companion','productivity','Collaborate better with AI-powered meeting summaries and chat help.','https://zoom.us/ai-companion',true,true,999999, freeTier:'Included in most paid plans', price:0, tips:'Summarize meetings in seconds | AI-powered chat catch-up | No extra cost for Pro'),
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
