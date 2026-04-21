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
    // ━━━ 3D DESIGN & CREATIVE ━━━
    t('spline','Spline','design','Collaborative 3D design tool for the web with real-time editing.','https://spline.design',true,true,5400, freeTier:'Free basic features', price:9, priceTier:'Personal: unlimited files, more features', tips:'Export to web or React | Real-time collaboration | Easy to learn for 2D designers'),
    t('runway-ai','Runway','design','AI-powered creative suite for video, image, and motion generation workflows.','https://runwayml.com',true,true,6200, freeTier:'Free starter credits available', price:15, priceTier:'Standard monthly', tips:'Great for creators and teams | Strong AI video tooling | Reliable brand and assets'),
    t('kuma-ai','Kuma','design','AI character creation and 3D design for games and animation.','https://kuma.ai',true,false,1800, freeTier:'Free beta access', price:0, tips:'Fastest 3D character generator | Good for game assets | Export to Unity/Unreal'),
    t('meshy-ai','Meshy','design','AI toolbox for 3D content creation converting text and images to 3D.','https://meshy.ai',true,false,2400, freeTier:'10 free generations per month', price:16, priceTier:'Pro: 150 high-quality 3D models', tips:'Best for text-to-3D | Good PBR maps | Export to OBJ/GLTF'),
    t('tripo-ai','Tripo AI','design','High-quality AI 3D modeling from text and images in seconds.','https://tripoai.com',true,false,2200, freeTier:'10 free credits per day', price:15, priceTier:'Standard: 300 credits per month', tips:'Fast generation | Good topography | Essential for rapid 3D prototyping'),
    t('masterpiece-x','Masterpiece X','design','AI generating 3D models and animations from text prompts.','https://masterpiecexv.com',true,false,1600, freeTier:'Free plan with watermark', price:19, priceTier:'Pro: no watermark, export to FBX', tips:'Complete workflow including rigging | VR support | Intuitive generation'),
    t('roblox-ai','Roblox Assistant','design','AI assistant for Roblox creators helping with code and asset creation.','https://create.roblox.com',true,true,7800, freeTier:'Completely free for Roblox creators', price:0, tips:'Type to generate Luau code | Helps with game logic | Integrated with Roblox Studio'),
    t('nvidia-canvas','NVIDIA Canvas','design','AI turning simple brushstrokes into realistic landscape images.','https://nvidia.com/canvas',true,false,4600, freeTier:'Free for NVIDIA RTX users', price:0, tips:'Real-time landscape generation | RTX GPU required | Good for fast environment concepts'),

    // ━━━ CUSTOMER SUPPORT ━━━
    t('intercom-fin','Intercom Fin','support','AI chatbot for customer support with zero-shot accuracy.','https://intercom.com/fin',false,true,5800, freeTier:'14-day free trial', price:15, priceTier:'Per seat + \$0.99 per resolution', tips:'Resolves 50% of tickets automatically | Integrated with Intercom | Trusted security'),
    t('ada-support','Ada','support','Enterprise customer service automation with generative AI.','https://ada.cx',false,false,3400, freeTier:'No free tier', price:0, tips:'Omnichannel support | Multilingual | Deep integrations'),
    t('zendesk-ai','Zendesk AI','support','AI-powered customer service with intelligent triage and bots.','https://zendesk.com',false,true,6200, freeTier:'30-day free trial', price:19, priceTier:'Per agent for Suite Team', tips:'Auto-triaging of tickets | Suggested responses for agents | Powerful analytics'),
    t('gorgias-ai','Gorgias AI','support','E-commerce customer service platform with AI automation for Shopify.','https://gorgias.com',false,false,2800, freeTier:'7-day free trial', price:10, priceTier:'Starter: 50 tickets per month', tips:'Best for Shopify and Magento | Pre-built templates | Automated order status checks'),
    t('kustomer-ai','Kustomer AI','support','CRM for service with automated workflows and AI IQ features.','https://kustomer.com',false,false,2200, freeTier:'No free tier', price:89, priceTier:'Enterprise per user', tips:'Complete customer view | Unified timeline | Powerful rule builder'),
    t('front-ai','Front AI','support','Customer operations platform with shared inbox and AI automation.','https://front.com',false,false,3200, freeTier:'7-day free trial', price:19, priceTier:'Starter per user', tips:'Collaborative inbox | Shared templates | Automate routing and replies'),
    t('helpscout-ai','Help Scout AI','support','Simple and powerful customer service with AI drafting and docs.','https://helpscout.com',false,false,2600, freeTier:'15-day free trial', price:20, priceTier:'Standard per user', tips:'Human-first support | Great knowledge base | AI summarizes conversations'),
    t('freshdesk-ai','Freshdesk AI (Freddy)','support','Omnichannel customer service with AI-powered Freddy Bot.','https://freshdesk.com',true,false,4800, freeTier:'Free for up to 10 agents basic', price:15, priceTier:'Growth per agent per month', tips:'Powerful automation | Ticket management | Multi-channel support'),

    // ━━━ HR & RECRUITMENT ━━━
    t('eightfold-ai','Eightfold AI','hr','Enterprise talent intelligence platform for hiring and retention.','https://eightfold.ai',false,false,2400, freeTier:'Demo available', price:0, tips:'AI-powered skills discovery | Bias removal in hiring | Career pathing for employees'),
    t('paradox-ai','Paradox (Olivia)','hr','Conversational AI for recruiting automating interviews and hiring.','https://paradox.ai',false,false,2200, freeTier:'No free tier', price:0, tips:'Olivia handles candidate questions | Auto-schedules interviews | Used by McDonald\'s'),
    t('hirevue','HireVue','hr','Video interviewing and assessment platform with AI insights.','https://hirevue.com',false,false,2800, freeTier:'No free tier', price:0, tips:'Structured video interviews | Game-based assessments | Ethical AI compliance'),
    t('testgorilla','TestGorilla','hr','AI-powered pre-employment skills testing and assessment.','https://testgorilla.com',true,false,3600, freeTier:'Free with 10 free tests', price:26, priceTier:'Pay as you go per test', tips:'Library of 300+ tests | Anti-cheating measures | Data-driven hiring'),
    t('fetcher-ai','Fetcher','hr','AI sourcing and outreach platform for recruiting teams.','https://fetcher.ai',false,false,1800, freeTier:'Free trial available', price:0, tips:'AI sources diverse candidates | Automated outreach | Integrates with Greenhouse/Lever'),
    t('ashby-ai','Ashby','hr','All-in-one recruiting platform with powerful data and AI.','https://ashbyhq.com',false,false,2600, freeTier:'Demo available', price:0, tips:'Best for startups and scaling | Powerful reports | Modern candidate experience'),
    t('lever-ai','Lever','hr','Modern ATS and CRM for recruiting with intelligent sourcing.','https://lever.co',false,false,3200, freeTier:'No free tier', price:0, tips:'Collaborative hiring | Pipeline analytics | Strong LinkedIn integration'),
    t('greenhouse-ai','Greenhouse','hr','Leading ATS with intelligent hiring tools and diverse candidate sourcing.','https://greenhouse.io',false,false,3800, freeTier:'No free tier', price:0, tips:'Structured hiring process | Excellent data and reporting | Large integrations market'),

    // ━━━ LEGAL AI ━━━
    t('harvey-ai','Harvey AI','legal','Professional AI platform for legal teams and law firms.','https://harvey.ai',false,true,4200, freeTier:'Institutional access only', price:0, tips:'Private legal models | Document analysis | Trusted by world\'s leading law firms'),
    t('ironclad-ai','Ironclad','legal','Digital contracting platform with AI contract analysis and lifecycle.','https://ironcladapp.com',false,false,2800, freeTier:'Free trial available', price:0, tips:'Contract Repository | Clickwrap support | Negotiate Faster with AI'),
    t('spellbook-ai','Spellbook','legal','AI contract drafting and review inside Microsoft Word.','https://spellbook.com',false,false,3200, freeTier:'Beta access available', price:150, priceTier:'Professional per month', tips:'Draft contracts 10x faster | Suggest sections | Identifies missing clauses'),
    t('counselyze','Counselyze','legal','AI tool for lawyers simplifying document review and research.','https://counselyze.com',true,false,1400, freeTier:'Free basic plan', price:49, priceTier:'Pro: unlimited reviews', tips:'Simplify complex legal jargon | Fast file analysis | Privacy-first approach'),
    t('luminance-ai','Luminance','legal','AI for the legal processing of mergers, acquisitions, and due diligence.','https://luminance.com',false,false,2200, freeTier:'Institutional demo', price:0, tips:'World-leading legal AI | Automated due diligence | Used by the Big Four'),
    t('lawgeex','LawGeex','legal','Automated contract review and approval using AI for enterprises.','https://lawgeex.com',false,false,1800, freeTier:'No free tier', price:0, tips:'Legal policy enforcement | 24/7 contract review | Consistent compliance'),
    t('casetext-ai','Casetext CoCounsel','legal','AI legal research and drafting assistant built for law firm workflows.','https://casetext.com/cocounsel',false,true,1200, freeTier:'Trial available for firms', price:0, tips:'Fast legal research and drafting | Strong case-law grounding | Trusted by legal teams'),
    t('lexis-plus-ai','Lexis+ AI','legal','Generative AI for legal research and drafting by LexisNexis.','https://lexisnexis.com',false,true,3600, freeTier:'Subscriber access only', price:0, tips:'Authoritative legal content | Hallucination-free research | Draft with AI'),

    // ━━━ E-COMMERCE AI ━━━
    t('shopify-sidekick','Shopify Sidekick','ecommerce','AI assistant for Shopify merchants managing store tasks and data.','https://shopify.com',true,true,8400, freeTier:'Included in Shopify plans', price:25, priceTier:'Basic Shopify starting price', tips:'Ask any question about your store | Generate discounts | Redesign parts of store'),
    t('klaviyo-ai','Klaviyo AI','ecommerce','Intelligent email and SMS marketing specialized for e-commerce.','https://klaviyo.com',true,true,6800, freeTier:'Free up to 250 contacts', price:20, priceTier:'Growth up to 500 contacts', tips:'Predictive analytics for churn | Personalized product recommendations | Best-in-class Shopify integration'),
    t('dynamic-yield','Dynamic Yield','ecommerce','Personalization platform with AI for tailoring customer experiences.','https://dynamicyield.com',false,false,2800, freeTier:'No free tier', price:0, tips:'Best for large retailers | Omni-channel personalization | Acquired by Mastercard'),
    t('nosto','Nosto','ecommerce','AI-powered commerce experience platform for retailers.','https://nosto.com',false,false,2400, freeTier:'Free trial available', price:0, tips:'Personalized product discovery | User-generated content | Data-driven cross-selling'),
    t('wisely-ai','Wisely','ecommerce','AI demand forecasting and inventory optimization for retailers.','https://wisely.ai',false,false,1600, freeTier:'Demo available', price:0, tips:'Reduce stockouts | Optimize pricing | Predict future sales accurately'),
    t('vi-senze','ViSenze','ecommerce','Visual search and discovery for e-commerce and retail.','https://visenze.com',false,false,2200, freeTier:'Demo available', price:0, tips:'Search by image | Similar product recommendations | Smart tagging for inventory'),
    t('syte-ai','Syte','ecommerce','Visual AI for retail with visual search and personalized discovery.','https://syte.ai',false,false,1800, freeTier:'Demo available', price:0, tips:'Visual search for fashion | Hyper-personalization | Shop the look'),
    t('attentive-ai','Attentive','ecommerce','AI marketing platform for SMS and email with high ROI.','https://attentive.com',false,false,3400, freeTier:'No free tier', price:0, tips:'Leading SMS marketing | Personalized message triggers | Strong ROI for brands'),

    // ━━━ CYBER SECURITY ━━━
    t('crowdstrike-falcon','CrowdStrike Falcon','security','AI-native cybersecurity platform protecting endpoints and cloud.','https://crowdstrike.com',false,true,6400, freeTier:'15-day free trial', price:0, tips:'Industry standard for EDR | Detects threats autonomously | Cloud-native security'),
    t('sentinelone-vigilance','SentinelOne Vigilance','security','AI autonomous security response for enterprise endpoints.','https://sentinelone.com',false,false,4800, freeTier:'No free tier', price:0, tips:'Fully automated response | Singularity Platform unified | Leading MITRE scores'),
    t('darktrace-immune','Darktrace HEAL','security','Self-learning AI cybersecurity detecting and neutralizing threats.','https://darktrace.com',false,false,3600, freeTier:'Demo available', price:0, tips:'Self-learning engine | Stop ransomware in seconds | 24/7 autonomous protection'),
    t('wiz-security','Wiz','security','Cloud security platform with graph-based AI for threat analysis.','https://wiz.io',false,true,5200, freeTier:'Demo available', price:0, tips:'Scan everything in cloud | One platform for multi-cloud | Agentless scanning'),
    t('snyk-ai','Snyk AI (DeepCode)','security','Developer-first security platform using AI for code and open source.','https://snyk.io',true,true,5800, freeTier:'Free for personal/OSS repos', price:25, priceTier:'Individual developer plan', tips:'Scan code as you write | Automatic fix suggestions | Best for DevSecOps'),
    t('checkmarx','Checkmarx One','security','Enterprise application security platform with AI code analysis.','https://checkmarx.com',false,false,2400, freeTier:'No free tier', price:0, tips:'Static and dynamic analysis | Supply chain security | Built for scale'),
    t('fortinet-fortiaips','FortiAIPS','security','AI-powered intrusion prevention and advanced threat protection.','https://fortinet.com',false,false,3200, freeTier:'No free tier', price:0, tips:'Hardware integrated security | Global threat intelligence | Leading firewall provider'),
    t('palo-alto-prisma','Prisma Cloud','security','Palo Alto Networks AI cloud security with automated compliance.','https://paloaltonetworks.com',false,false,3800, freeTier:'Demo available', price:0, tips:'Complete SASE solution | Code-to-cloud security | Zero Trust architecture'),

    // ━━━ DATA SCIENCE ━━━
    t('dataiku-ai','Dataiku','data','Everyday AI platform for data science and machine learning.','https://dataiku.com',true,false,3200, freeTier:'Free edition available (self-host)', price:0, tips:'Collaborative data science | AutoML built-in | Scale from local to cloud'),
    t('knime','KNIME','data','Open-source data science platform with visual workflow builder.','https://knime.com',true,false,2800, freeTier:'Free open source forever', price:0, tips:'No-code data science | 2000+ nodes available | Connects to everything'),
    t('h2o-ai','H2O.ai','data','Open-source and enterprise AI for machine learning and predictive modeling.','https://h2o.ai',true,false,3400, freeTier:'Free open source core', price:0, tips:'Best-in-class AutoML | Driverless AI for enterprise | Distributed processing'),
    t('rapidminer','RapidMiner','data','Enterprise data science platform for end-to-end model building.','https://rapidminer.com',true,false,2200, freeTier:'Free community edition', price:0, tips:'Acquired by Altair | Visual workflow designer | Real-time scoring'),
    t('alteryx','Alteryx','data','Self-service data analytics and automation platform with AI.','https://alteryx.com',false,false,3600, freeTier:'30-day free trial', price:150, priceTier:'Designer per user per month', tips:'Powerful ETL and prep | No-code analytics | Strong for finance roles'),
    t('snowflake-cortex','Snowflake Cortex','data','Fully managed service that enables organizations to use AI and LLMs.','https://snowflake.com',false,true,7200, freeTier:'Credit-based pricing', price:0, tips:'Run LLMs directly on your data | Built-in ML functions | Secure and governed'),
    t('databricks-mosaic','Databricks Mosaic AI','data','Unified data and AI platform with MLflow and Apache Spark.','https://databricks.com',false,true,8400, freeTier:'14-day free trial', price:0, tips:'Lakehouse architecture | Train your own models with Mosaic | Best for big data'),
    t('weights-biases','Weights & Biases','data','Developer-first MLOps platform for tracking experiments and models.','https://wandb.ai',true,true,5200, freeTier:'Free for personal use and OSS', price:50, priceTier:'Professional for teams', tips:'Essential for deep learning | Visual experiment tracking | Model versioning'),

    // ━━━ GAMING ━━━
    t('unity-muse','Unity Muse','gaming','AI-powered creation assistant for Unity developers.','https://unity.com/muse',false,true,4800, freeTier:'Free trial available', price:30, priceTier:'Muse subscription', tips:'Generate textures and sprites | Chat with Unity docs | AI behavior trees'),
    t('unreal-engine-ai','Unreal Engine AI','gaming','Complete suite of AI tools for game developers in UE5.','https://unrealengine.com',true,true,12000, freeTier:'Free for individual projects', price:0, tips:'Best for AAA game dev | Neural Network Engine (NNE) | Procedural content gen'),
    t('leonardo-ai-gaming','Leonardo.ai for Gaming','gaming','Professional AI tool for game asset and environment creation.','https://leonardo.ai',true,true,8800, freeTier:'150 free credits per day', price:10, priceTier:'Apprentice: 8500 credits per month', tips:'Create consistent game assets | Live Canvas for rough sketches | Best for 2D assets'),
    t('layer-ai','Layer AI','gaming','Enterprise AI backend for high-quality game art production.','https://layer.ai',false,false,2400, freeTier:'Demo available', price:0, tips:'In-house model training | Secure IP protection | High speed production'),
    t('hotpot-gaming','Hotpot.ai Gaming','gaming','AI tools for creating game icons, assets, and copywriting.','https://hotpot.ai',true,false,3400, freeTier:'Free basic tools', price:10, priceTier:'Monthly credits for upscaling/gen', tips:'Easy icon generation | Quick skybox creation | Good for indie devs'),
    t('modl-ai-testing','Modl.ai','gaming','AI game testing to automate QA and discover bugs.','https://modl.ai',false,false,1400, freeTier:'Free trial available', price:0, tips:'Scale QA with AI bots | Map entire game levels | Works with any engine'),
    t('charactr-ai','charactr','gaming','AI text-to-speech and voice for video game characters.','https://charactr.com',true,false,2200, freeTier:'Free beta access', price:19, priceTier:'Starter: 1M characters per month', tips:'Fast realtime voices | High quality APIs | Emotional voice range'),
    t('voki-ai','Voki','gaming','AI avatars for education and gaming with multi-language support.','https://voki.com',true,false,1600, freeTier:'Free basic version', price:3, priceTier:'Level 1 Classroom subscription', tips:'Easy avatar creation | Good for teaching | Multilingual'),

    // ━━━ FOOD & COOKING ━━━
    t('chef-gpt','ChefGPT','food','AI personal chef generating recipes based on pantry items.','https://chefgpt.xyz',true,false,2800, freeTier:'Free basic access with ads', price:5, priceTier:'Pro: unlimited recipes, no ads', tips:'"Pantry Mode" simplifies meals | Meal planning for macro tracking | Shopping list generation'),
    t('dishgen','DishGen','food','AI recipe generator creating unique dishes from any prompt.','https://dishgen.com',true,false,1800, freeTier:'Free daily recipe generation', price:0, tips:'Create any dish | Search existing community recipes | Fast and easy'),
    t('supercook','SuperCook','food','Recipe search engine that finds meals with ingredients you already have.','https://supercook.com',true,true,4200, freeTier:'Completely free app and web', price:0, tips:'Add 100s of ingredients | Filters for diet and type | Saves money and waste'),
    t('recipe-ai','Recipe AI','food','App creating recipes from photos of your fridge or pantry.','https://recipeai.app',true,false,1400, freeTier:'Free basic scan', price:3, priceTier:'Monthly unlimited scans', tips:'Photo to recipe in seconds | Good for leftover use | Mobile first'),
    t('foodvisor','Foodvisor','food','AI nutrition app identifying food and nutrients from photos.','https://foodvisor.io',true,false,3200, freeTier:'Free basic food logging', price:9, priceTier:'Premium: dietitian support and plans', tips:'Log food with one photo | Personal nutrition coach | Connects with fitness apps'),
    t('yummly-pro','Yummly','food','Leading recipe app with AI recommendations and guided cooking.','https://yummly.com',true,false,5600, freeTier:'Free basic recipe access', price:5, priceTier:'Premium: ad-free and pro classes', tips:'Guided videos from chefs | Smart shopping list | "Pantry Ready" feature'),
    t('epicurious-ai','Epicurious','food','Expert recipes and cooking videos with AI search and filters.','https://epicurious.com',true,false,3400, freeTier:'Free limited access', price:0, tips:'Trusted source for home cooks | In-depth technique guides | Seasonal collections'),
    t('cook-unity','CookUnity','food','AI meal delivery service from world-class chefs to your door.','https://cookunity.com',false,false,2600, freeTier:'No free tier', price:13, priceTier:'Per meal starting price', tips:'Chef-prepared fresh meals | Personalized selections | No cooking required'),

    // ━━━ FITNESS ━━━
    t('fitness-ai','FitnessAI','fitness','AI gym coach generating personalized weightlifting plans.','https://fitnessai.com',false,true,4600, freeTier:'7-day free trial', price:10, priceTier:'Annual billing per month price', tips:'Optimized rest and reps | Gym-first focus | Beautiful minimalist app'),
    t('zest-ai','Zest','fitness','AI fitness app for outdoor and home workouts with form tracking.','https://zest.ai',true,false,2200, freeTier:'Free daily workouts', price:5, priceTier:'Pro: personalized plans and feedback', tips:'Uses camera for form correction | Audio-guided runs | Great for bodyweight'),
    t('trainfitness','TrainFitness','fitness','AI workout tracker for Apple Watch detecting exercises automatically.','https://trainfitness.ai',true,false,3800, freeTier:'Free basic tracking', price:9, priceTier:'Premium: advanced analytics across time', tips:'Zero manual logging | Automatic exercise detection | Apple Watch essential'),
    t('juggernautai','JuggernautAI','fitness','Advanced powerlifting AI coach adjusting to your fatigue and strength.','https://juggernautai.app',false,true,3200, freeTier:'14-day free trial', price:15, priceTier:'Monthly per athlete', tips:'Professional powerlifting coach | Daily feedback adjustment | Leading algorithm'),
    t('evolveai','EvolveAI','fitness','AI strength training app designed by champion athletes and scientists.','https://evolveai.app',false,false,2800, freeTier:'7-day free trial', price:15, priceTier:'Monthly prescription', tips:'Personalized for powerlifting | Dynamic intensity scaling | Community access'),
    t('stronger-by-day','Stronger by the Day','fitness','Training app by Megsquats with AI-guided strength cycles.','https://strongerbytheday.com',false,false,2400, freeTier:'Free trial available', price:12, priceTier:'Monthly per athlete', tips:'Focus on big compound movements | Great community | High-quality educational content'),
    t('peloton-guide','Peloton Guide','fitness','AI-powered strength training camera for Peloton home workouts.','https://onepeloton.com/guide',false,true,6200, freeTier:'Requires hardware purchase', price:0, tips:'Tracks reps and form | "Movement Tracker" keeps you honest | Huge library of classes'),
    t('tempo-fit','Tempo','fitness','Complete home gym with AI-powered form tracking and weights.','https://tempo.fit',false,false,3400, freeTier:'Requires hardware purchase', price:39, priceTier:'Monthly membership after hardware', tips:'Best-in-class form analysis | Real competition at home | Compact design'),

    // ━━━ TRAVEL ━━━
    t('vacay-ai','Vacay','travel','AI travel advisor and planner creating custom itineraries privately.','https://usevacay.com',true,false,2800, freeTier:'Free plan limited itineraries', price:10, priceTier:'Pro: unlimited and collaborative planning', tips:'Find hidden local spots | Group planning features | Export to Google Maps'),
    t('itinerary-ai','Itinerary AI','travel','AI trip planner that generates complete day-by-day travel plans.','https://itinerary.ai',true,false,2200, freeTier:'Free generations with signup', price:0, tips:'Simple and fast | Good for initial planning | Direct booking links'),
    t('getyourguide-ai','GetYourGuide','travel','Book tours and activities globally with AI-powered discovery.','https://getyourguide.com',true,true,8400, freeTier:'Free to browse and use', price:0, tips:'Huge global inventory | Mobile ticketing | AI suggests based on history'),
    t('viator-ai','Viator','travel','TripAdvisor-owned platform for booking travel experiences and tours.','https://viator.com',true,true,7800, freeTier:'Free to use', price:0, tips:'Reliable reviews | Reserve now, pay later | Largest inventory of tours'),
    t('roadtrippers-ai','Roadtrippers','travel','Leading road trip planning tool with AI for finding weird stops.','https://roadtrippers.com',true,false,4600, freeTier:'Free plan for 5 stops', price:5, priceTier:'Premium: unlimited stops and offline', tips:'Calculate fuel costs | Find "quirky" roadside stops | Essential for US road trips'),
    t('ispy-travel','iSpy Travel','travel','AI travel search finding hotels and flights from photos and text.','https://ispy.travel',true,false,1400, freeTier:'Free for basic search', price:0, tips:'Modern travel search | Visual discovery focus | Fast results'),
    t('trippy-ai','Trippy','travel','Community-driven travel advice with AI summarization and search.','https://trippy.com',true,false,2600, freeTier:'Completely free platform', price:0, tips:'Get advice from real travelers | AI summarizes long threads | Good for niche questions'),
    t('culture-trip-ai','Culture Trip','travel','Discover unique experiences and book hotels with AI guides.','https://theculturetrip.com',true,false,3800, freeTier:'Free to use and read', price:0, tips:'High-quality local articles | Off-the-beaten-path focus | Beautiful visual app'),
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
