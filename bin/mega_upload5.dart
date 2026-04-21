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
    // ━━━ PARENTING & KIDS ━━━
    t('storybird-ai','Storybird AI','education','AI storybook generator for parents and teachers creating personalized tales.','https://storybird.ai',true,true,3400, freeTier:'Free basic story creation', price:5, priceTier:'Standard: unlimited stories', tips:'Personalize with your child\'s name | Choose artistic styles | Download as PDF'),
    t('moms-ai-coach','Moms AI Coach','health','AI assistant for new parents providing expert advice and support.','https://moms.ai',true,false,1800, freeTier:'Free basic q&a', price:0, tips:'Get fast answers to baby questions | Breastfeeding help | Sleep schedule advice'),
    t('nini-ai','Nini','education','AI-powered educational assistant for children helping with homework.','https://nini.ai',true,false,2200, freeTier:'Free trial available', price:10, priceTier:'Pro: unlimited questions', tips:'Safe for kids | Explains concepts simply | Math and science help'),
    t('parenting-ai','Parenting AI','health','AI tool for managing family schedules, chores, and behavioral tracking.','https://parentingai.app',true,false,1400, freeTier:'Free for basic tracking', price:3, priceTier:'Monthly per family', tips:'Gamify chores | Reward systems | Behavior analysis for parents'),
    t('babysense-ai','BabySense AI','health','AI video baby monitor with breathing and movement tracking.','https://babysense.io',false,true,5600, freeTier:'Requires hardware purchase', price:0, tips:'Contactless monitoring | High definition night vision | Trusted by millions'),

    // ━━━ SPIRITUALITY & ASTROLOGY ━━━
    t('co-star-ai','Co-Star','spiritual','Hyper-personalized AI astrology app based on real-time NASA data.','https://costarastrology.com',true,true,18000, freeTier:'Free daily horoscope', price:0, tips:'NASA-powered accuracy | Connect with friends | Beautiful design'),
    t('the-pattern','The Pattern','spiritual','AI social network mapping your personality and relationships.','https://thepattern.com',true,true,15000, freeTier:'Free personality insights', price:0, tips:'Detailed relationship compatibility | "Personal bond" analysis | Soulmate focus'),
    t('astrology-gpt','Astrology GPT','spiritual','AI chatbot that reads your birth chart and answers life questions.','https://astrologygpt.site',true,false,4200, freeTier:'3 free queries per day', price:5, priceTier:'Pro: unlimited readings', tips:'Instant birth chart analysis | Predictions for career and love | Easy to use'),
    t('tara-ai-divine','Tara AI','spiritual','AI-powered spiritual advisor and daily manifestation tool.','https://tara.ai',true,false,2800, freeTier:'Free basic daily guidance', price:15, priceTier:'Pro: in-depth readings', tips:'Voice-based guidance | Personalized rituals | Manifestation focus'),
    t('varkala-ai','Varkala','spiritual','AI tool for Vedic astrology (Jyotish) and traditional Indian readings.','https://varkala.ai',true,false,3600, freeTier:'Free basic kundli', price:10, priceTier:'Full gemstone and remedy report', tips:'Detailed Vedic chart | Dosha analysis | Muhurata calculations'),

    // ━━━ DATING & RELATIONSHIPS ━━━
    t('iris-ai-dating','Iris Dating','social','AI dating app that predicts your "type" through visual learning.','https://irisdating.com',true,true,5400, freeTier:'Free basic swiping', price:20, priceTier:'Premium: priority and more filters', tips:'Learns what you find attractive | Prevents fake profiles | High match quality'),
    t('rizz-ai','Rizz AI','social','AI wingman that suggests clever lines and responses for dating apps.','https://rizz.ai',true,true,9200, freeTier:'Free daily lines', price:4, priceTier:'Pro: unlimited suggestions', tips:'Copy paste chat for context | Multiple styles (witty, bold, etc.) | Works on Tinder/Hinge'),
    t('your-move-ai','YourMove AI','social','AI tool for fixing your dating profile and improving conversations.','https://yourmove.ai',true,false,4800, freeTier:'Free profile check', price:15, priceTier:'Full rewrite and coach access', tips:'Profile photo review | Auto-bio generator | Conversation coaching'),
    t('flirty-ai','Flirty AI','social','AI assistant for crafting personalized flirting messages and icebreakers.','https://flirty.ai',true,false,3200, freeTier:'5 free messages per day', price:5, priceTier:'Weekly subscription', tips:'Icebreakers from interests | Tone adjustment | Works for any social app'),
    t('keeper-ai','Keeper','social','AI matchmaking service for high-quality marriage-minded individuals.','https://keeper.ai',false,false,2400, freeTier:'Signup for waiting list', price:0, tips:'Manual vetting + AI | Focus on traditional values | 1-on-1 matches'),

    // ━━━ CAR & AUTOMOTIVE ━━━
    t('fixico-ai','Fixico','automotive','AI-powered platform for car body repair estimates from photos.','https://fixico.com',true,false,2800, freeTier:'Free for consumers', price:0, tips:'Take 3 photos for quote | Network of 2500+ shops | Savings of 30%+'),
    t('waymo-ai','Waymo One','automotive','The world\'s first fully autonomous ride-hailing service by Google.','https://waymo.com',false,true,12000, freeTier:'App is free (pay per ride)', price:0, tips:'Safest autonomous driving | available in Phoenix, SF, LA | "Driverless" experience'),
    t('comma-ai','comma.ai','automotive','Open-source driver assistance system using consumer-grade hardware.','https://comma.ai',false,true,8400, freeTier:'Open source software free', price:1999, priceTier:'Hardware: comma 3X', tips:'Add self-driving to existing car | Works in 250+ models | Privacy focused'),
    t('tesla-fsd','Tesla FSD','automotive','AI-driven full self-driving capability for Tesla vehicles.','https://tesla.com',false,true,25000, freeTier:'Demo in person free', price:99, priceTier:'Monthly subscription', tips:'Requires Tesla hardware | Version 12 is major leap | Best for highways'),
    t('car-guru-ai','CarGurus AI','automotive','AI-powered car search and market value analyzer for used cars.','https://cargurus.com',true,false,6200, freeTier:'Free for search and valuation', price:0, tips:'Identify "Great Deals" | History reports linked | Dealer ratings focus'),

    // ━━━ AGRICULTURE ━━━
    t('climate-ai','Climate AI','agriculture','AI platform for climate-resilient agriculture and supply chain.','https://climate.ai',false,false,1800, freeTier:'Institutional access', price:0, tips:'Predict weather impact on crops | Climate risk assessment | Seed optimization'),
    t('blue-river-tech','Blue River','agriculture','AI-powered "See & Spray" technology for precise weed control.','https://bluerivertechnology.com',false,false,2200, freeTier:'Commercial only', price:0, tips:'Acquired by John Deere | Reduce chemical use by 90% | Identifies weeds individually'),
    t('taranis-ai','Taranis','agriculture','AI aerial intelligence platform for broad-acre crop health.','https://taranis.com',false,false,2600, freeTier:'Demo available', price:0, tips:'High-res leaf-level imagery | Detect pests and disease | Yield predictions'),
    t('agrow-ai','Agrow','agriculture','AI for greenhouse automation and climate control optimization.','https://agrow.ai',true,false,1400, freeTier:'Free basic monitoring', price:0, tips:'Optimize CO2 and light | Remote greenhouse control | Energy saving'),
    t('farmers-business-ai','FBN AI','agriculture','Data network for farmers with AI-driven pricing and insights.','https://fbn.com',true,false,3400, freeTier:'Free network access', price:0, tips:'Price transparency for seeds | Chemical efficacy comparison | Largest farmer data network'),

    // ━━━ CONSTRUCTION ━━━
    t('build-ai','Build AI','construction','AI dashcams for construction sites to track progress and safety.','https://buildai.construction',false,false,1600, freeTier:'Demo available', price:0, tips:'Automate progress reports | Detect safety violations | Used on large projects'),
    t('vi-construction','VisiLean','construction','Lean construction management with AI-powered visual collaboration.','https://visilean.com',false,false,1200, freeTier:'30-day free trial', price:0, tips:'BIM integration | Mobile app for field teams | Real-time progress tracking'),
    t('plan-grid-ai','PlanGrid (Autodesk)','construction','Construction management software with AI for submittal extraction.','https://plangrid.com',false,false,4800, freeTier:'Free trial available', price:39, priceTier:'Standard monthly', tips:'Mark up blueprints on iPad | Instant syncing to all devices | Submittal AI saves weeks'),
    t('open-space-ai','OpenSpace','construction','AI-powered 360 photography for construction site documentation.','https://openspace.ai',false,true,3200, freeTier:'Demo available', price:0, tips:'Walk around for auto-mapping | "Google Street View" for sites | Progress tracking'),
    t('concreit-ai','Concreit','construction','AI for scheduling and concrete delivery optimization for sites.','https://concreit.com',false,false,900, freeTier:'No free tier', price:0, tips:'Optimize logistics | Reduce waste | Real-time tracking of trucks'),

    // ━━━ HOBBIES & CRAFTS ━━━
    t('pattern-gpt','Pattern GPT','hobby','AI generator for sewing and knitting patterns from descriptions.','https://patterngpt.com',true,false,2400, freeTier:'Free basic patterns', price:5, priceTier:'Pro: custom sizing and export', tips:'Design custom clothing | Export to PDF | All body types supported'),
    t('knit-ai','Knit AI','hobby','AI assistant for knitters to calculate yarn and design patterns.','https://knit.ai',true,false,1600, freeTier:'Free tool for simple calculations', price:0, tips:'Convert patterns to different weights | Yarn estimator | Community sharing'),
    t('guitar-ai','Guitar AI','hobby','AI-powered guitar learning app that listens to your playing.','https://guitarai.app',true,false,3800, freeTier:'Free basic lessons', price:10, priceTier:'Premium: all songs and theory', tips:'Real-time feedback on notes | Interactive tabs | Great for beginners'),
    t('origami-ai','Origami AI','hobby','AI generating complex origami diagrams and 3D folding steps.','https://origami-ai.com',true,false,1400, freeTier:'Free basic models', price:4, priceTier:'Pro: specialized 3D models', tips:'Step-by-step 3D view | Design your own models | Printable guides'),
    t('chess-ai-coach','Chess.com AI','hobby','AI coach that analyzes your chess games and suggests improvements.','https://chess.com',true,true,25000, freeTier:'1 free analysis per day', price:7, priceTier:'Platinum: unlimited analysis', tips:'Game Review explains moves | Trainer mode for drills | Best in class engine'),

    // ━━━ PET CARE ━━━
    t('petphrase','PetPhrase','pets','AI translator that analyzes pet sounds and behavior for owners.','https://petphrase.com',true,false,3400, freeTier:'Free basic analysis', price:2, priceTier:'Pro monthly', tips:'Understand "Meows" and "Barks" | Behavior guide included | Fun for owners'),
    t('fuzzy-ai-vet','Fuzzy','pets','AI vet assistant for pet health advice and triage.','https://yourfuzzy.com',false,true,4200, freeTier:'Free first consultation', price:25, priceTier:'Monthly membership with 24/7 vet access', tips:'24/7 vet chat | Telehealth for pets | Personalized pet vitamins'),
    t('embark-ai','Embark','pets','AI powered dog DNA testing for health and breed identification.','https://embarkvet.com',false,true,6800, freeTier:'No free tier', price:129, priceTier:'Breed ID kit', tips:'Identifies 350+ breeds | Screens for 250+ health risks | Connect with relatives'),
    t('petcube-ai','Petcube','pets','Smart pet camera with AI vet and human-pet interaction.','https://petcube.com',false,false,5200, freeTier:'App is free (pay for camera)', price:0, tips:'AI detects pet behavior | Remote treat flinger | 2-way audio'),
    t('basepaws','Basepaws','pets','AI-driven cat DNA and health testing for preventative care.','https://basepaws.com',false,false,3200, freeTier:'No free tier', price:99, priceTier:'Cat DNA kit', tips:'Dental and gut health reports | Chronic kidney disease screening | Breed focus'),

    // ━━━ SPORTS ━━━
    t('home-court','HomeCourt','sports','AI basketball training app using your phone camera to track shots.','https://homecourt.ai',true,true,8400, freeTier:'Free basic workouts', price:14, priceTier:'Pro: unlimited tracking and scouts', tips:'Used by NBA teams | Real-time shot tracking | Virtual competitions'),
    t('swingvision','SwingVision','sports','AI for tennis using your iPhone to track stats and highlights.','https://swing.vision',true,true,7200, freeTier:'Free basic play tracking', price:12, priceTier:'Pro: unlimited analysis and video', tips:'Automatic line calling | Shot placement heatmaps | Video highlights instantly'),
    t('golf-ai-swing','Golf AI','sports','AI golf swing analyzer providing instant tips and drills.','https://golfai.app',true,false,4600, freeTier:'3 free swing reviews', price:10, priceTier:'Monthly coach access', tips:'Compare with pros | 3D posture analysis | Putting coach included'),
    t('strava-ai','Strava Beacon','sports','Leading fitness social network with AI for safety and routes.','https://strava.com',true,true,35000, freeTier:'Free basic tracking', price:6, priceTier:'Subscription for routes and metrics', tips:'Heatmaps for popular routes | Safety tracking Beacon | Best for cycling/running'),
    t('hudl-ai','Hudl Focus','sports','AI smart camera for capturing and analyzing team sports games.','https://hudl.com',false,true,6800, freeTier:'Quote based', price:0, tips:'Automatic game recording | Performance analytics | Recruitment tools built-in'),
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
