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
    // ━━━ AI FOR CHIPS & HARDWARE (Tech foundations) ━━━
    t('nvidia-cuda-ai','NVIDIA CUDA','code','Leading parallel computing platform and API model for AI and deep learning.','https://developer.nvidia.com/cuda-zone',true,true,999999, freeTier:'Completely free for developers', price:0, tips:'The foundation of modern AI | Optimize your code for GPUs | Robust and mature'),
    t('amd-rocm-ai','AMD ROCm','code','Open source software platform for GPU computing and deep learning on AMD.','https://amd.com/rocm',true,true,120000, freeTier:'Completely free open source', price:0, tips:'Best alternative to CUDA | Open source and fast | Growing ecosystem'),
    t('intel-oneapi-ai','Intel oneAPI','code','Unified programming model for high-performance computing across Intel chips.','https://oneapi.io',true,true,150000, freeTier:'Completely free for everyone', price:0, tips:'Optimize across CPU/GPU/FPGA | AI-powered data libraries | Industry standard'),
    t('qualcomm-ai-hub','Qualcomm AI Hub','code','Developer tools for running generative AI on mobile and edge devices.','https://www.qualcomm.com/ai-hub',true,true,84000, freeTier:'Free for developers', price:0, tips:'Execute AI locally on Snapdragon | Fast and energy efficient | Best for mobile apps'),
    t('arm-ai-ecosystem','Arm AI','code','Leading platform for AI on mobile and IoT devices using Arm architectures.','https://arm.com/ai',true,true,350000, freeTier:'Free developer docs and tools', price:0, tips:'Powers 99% of smartphones | AI-powered "Ethos" processors | Energy leader'),
    t('tensor-rt-ai','NVIDIA TensorRT','code','High-performance deep learning inference optimizer and runtime for NVIDIA.','https://developer.nvidia.com/tensorrt',true,true,180000, freeTier:'Free for personal/dev', price:0, tips:'Optimize models for real-time inference | 10x faster than standard | Pro grade'),
    t('hugging-face-pro','Hugging Face (Pro)','code','Leading platform for AI models and datasets with high-end collab tools.','https://huggingface.co',true,true,999999, freeTier:'Free for public models and hub', price:9, priceTier:'Pro monthly', tips:'The GitHub for AI | AI-powered "AutoTrain" | Millions of models'),
    t('Weights-Biases-ai','Weights & Biases','code','Leading platform for tracking AI experiments and managing model versions.','https://wandb.ai',true,true,120000, freeTier:'Free for personal/research', price:50, priceTier:'Plus per seat monthly', tips:'Industry standard for AI teams | AI-powered model comparison | Robust'),
    t('neptune-ai-pro','Neptune.ai','code','Metadata store for MLOps - track your AI training and data versioning.','https://neptune.ai',true,false,45000, freeTier:'Free for individuals', price:150, priceTier:'Team monthly base', tips:'Best for commercial AI teams | AI-powered dashboard | Scalable and fast'),
    t('comet-ai-pro','Comet','code','Leading platform for tracking, comparing, and optimizing AI models.','https://comet.com',true,true,35000, freeTier:'Free for individuals/research', price:0, tips:'AI-powered hyperparameter search | Data science collaboration | High performance'),

    // ━━━ AI FOR AGRICULTURE & FOOD v2 ━━━
    t('indigo-ag-ai','Indigo Ag','business','Science-led carbon credit development for farmers using AI for modeling.','https://indigoag.com',false,true,12000, freeTier:'Demo available', price:0, tips:'AI-powered "Carbon" program | Help farmers earn credits | Biological focus'),
    t('farmers-business-ai','FBN (Farmers Business Network)','business','Data-driven network for farmers using AI to optimize seeds and prices.','https://fbn.com',true,true,45000, freeTier:'Free to join the network', price:0, tips:'Transparent pricing for farmers | AI-powered soil analytics | Massive data'),
    t('pest-prophet-ai','PestProphet','science','AI-powered app for predicting crop pests and diseases using weather data.','https://pestprophet.com',true,false,8400, freeTier:'Free trial available', price:15, priceTier:'Monthly per farm', tips:'Save on pesticides with AI | Accurate local weather models | Easy to use'),
    t('taranis-ai-pro','Taranis','business','AI-powered crop intelligence platform using high-res aerial imagery.','https://taranis.com',false,true,15000, freeTier:'Institutional only', price:0, tips:'Identify Every leaf on a farm with AI | Precision scouting | Best for large growers'),
    t('abundance-ai-pro','Abundant Robots','business','Autonomous apple harvesting robots using vision and AI for picking.','https://abundantrobots.com',false,false,5600, freeTier:'Institutional only', price:0, tips:'Reduce labor costs with AI | Gentle on fruit | Innovative hardware'),
    t('iron-ox-ai-farm','Iron Ox','lifestyle','Autonomous indoor greenhouse using AI and robots for sustainable food.','https://ironox.com',false,true,12000, freeTier:'Institutional only', price:0, tips:'Zero waste farming with AI | Locally grown veggies | Cutting-edge robotics'),
    t('bowery-ai-farm','Bowery Farming','lifestyle','Leading vertical farming company using AI for plant health and yield.','https://boweryfarming.com',true,true,28000, freeTier:'Free to find in stores', price:0, tips:'AI-powered "BoweryOS" | No pesticides | Freshest greens in the city'),
    t('plenty-ai-farm','Plenty','lifestyle','Indoor vertical farming using AI to optimize every aspect of plant life.','https://plenty.ag',true,true,35000, freeTier:'Free to find in stores', price:0, tips:'95% less water with AI | Part of Walmart supply chain | Most efficient'),
    t('aerofarms-ai-pro','AeroFarms','lifestyle','Global leader in indoor vertical farming using AI and aeroponics.','https://aerofarms.com',true,true,18000, freeTier:'Free to find in stores', price:0, tips:'Certified B Corp | AI-powered "Plant Biology" data | World class scale'),
    t('infarm-ai-pro','Infarm','lifestyle','Cloud-connected local vertical farming using AI for fresh herbs.','https://infarm.com',true,false,12000, freeTier:'Free to find in stores', price:0, tips:'Farms directly in grocery stores | AI-powered remote control | European leader'),

    // ━━━ AI FOR RECRUITING & HR v2 ━━━
    t('eightfold-ai-pro','Eightfold.ai','business','Leading talent intelligence platform using AI for hiring and retention.','https://eightfold.ai',false,true,15000, freeTier:'Institutional only', price:0, tips:'AI-powered "Global Talent Intelligence" | Match skills to roles | Enterprise grade'),
    t('phenom-ai-pro','Phenom','business','AI-powered talent experience platform for high-growth enterprises.','https://phenom.com',false,true,12000, freeTier:'Demo available', price:0, tips:'AI-powered chatbots for hiring | Personalized career sites | Global presence'),
    t('him-pro-ai','Hired','business','Leading career marketplace using AI to match candidates with recruiters.','https://hired.com',true,true,84000, freeTier:'Completely free for candidates', price:0, tips:'Best for tech roles | AI-powered "Salary Predictor" | Upfront info'),
    t('otta-ai-pro','Otta','business','The job search app for the best startups and tech companies with AI.','https://otta.com',true,true,150000, freeTier:'Completely free for candidates', price:0, tips:'AI-powered "Suitability" scores | Data-driven job hunt | High quality focus'),
    t('wantedly-ai-pro','Wantedly','business','Leading social recruiting platform using AI for cultural matching.','https://wantedly.com',true,true,45000, freeTier:'Free for candidates', price:0, tips:'Asian market leader | AI-powered "Discovery" feed | Focus on passion'),
    t('dice-ai-pro','Dice','business','Leading tech-focused job board with AI-powered candidate signals.','https://dice.com',true,true,58000, freeTier:'Free for candidates', price:0, tips:'Best for IT and engineering roles | AI-powered "IntelliSearch" | Trusted for 20+ yrs'),
    t('monster-ai-pro','Monster','business','Global job search giant using AI for matching and resume help.','https://monster.com',true,true,120000, freeTier:'Free for candidates', price:0, tips:'One of the largest databases | AI-powered "Job Ad" creation | Global scale'),
    t('glassdoor-ai-pro','Glassdoor','business','Leading platform for company reviews and salaries with AI insights.','https://glassdoor.com',true,true,999999, freeTier:'Completely free for users', price:0, tips:'Transparent company culture data | AI-powered "Highlights" | Best for research'),
    t('hired-score-ai','HiredScore','business','AI-powered talent orchestration for global enterprise HR teams.','https://hiredscore.com',false,false,5600, freeTier:'Institutional only', price:0, tips:'Acquired by Workday | AI identifies internal talent | Ethical and compliant'),
    t('pando-logic-ai','PandoLogic','marketing','AI-powered programmatic job advertising for high-volume hiring.','https://pandologic.com',false,false,4200, freeTier:'Demo available', price:0, tips:'Acquired by Veritone | AI-powered "pandoIQ" | Automate ad spend'),

    // ━━━ AI FOR MARINE & OCEAN v2 ━━━
    t('sail-drone-ai','Saildrone','science','Autonomous ocean drones using AI for mapping and weather data.','https://saildrone.com',false,true,12000, freeTier:'Institutional only', price:0, tips:'AI-powered "Voyager" drones | 1:1 map of the ocean floor | Sustainable data'),
    t('ocean-mind-ai-pro','OceanMind','science','AI-powered marine compliance and anti-illegal fishing platform.','https://oceanmind.global',true,true,8400, freeTier:'Free for qualified NGOs', price:0, tips:'Non-profit and high tech | AI identifies illegal ships | Environmental legacy'),
    t('global-fishing-ai','Global Fishing Watch','science','Transparent ocean platform using AI to track every large fishing boat.','https://globalfishingwatch.org',true,true,15000, freeTier:'Completely free public data', price:0, tips:'Backed by Google and Leonardo DiCaprio | AI identifies fleet behavior | Open source'),
    t('sofarocean-ai-pro','Sofar Ocean','science','The largest ocean intelligence network using AI for weather and routing.','https://sofarocean.com',false,true,12000, freeTier:'Free basic dashboard online', price:0, tips:'AI-powered "Wayfinder" for ships | Save fuel and time | Huge buoy network'),
    t('nautilus-labs-ai','Nautilus Labs','business','AI-powered platform for the commercial maritime industry to save fuel.','https://nautiluslabs.com',false,false,5600, freeTier:'Demo available', price:0, tips:'Optimize vessel performance with AI | Sustainable shipping | Data-driven ops'),
    t('x-mar-ai-pro','Xmar (Digital)','business','AI-powered maritime platform for automated chartering and logistics.','https://xmar.io',false,false,4200, freeTier:'Demo available', price:0, tips:'Best for bulk shipping | AI-powered contract management | Fast and clean'),
    t('ocean-bolt-ai','Oceanbolt','business','Real-time dry bulk market intelligence using AI for cargo tracking.','https://oceanbolt.com',false,true,5800, freeTier:'Demo available', price:0, tips:'Acquired by Veson Nautical | AI-powered fleet analytics | Professional grade'),
    t('sea-markets-ai','Sea/ (Digital)','business','Leading maritime software suite using AI for data and trade help.','https://sea.live',false,false,5600, freeTier:'Institutional only', price:0, tips:'Best for shipping brokers | AI-powered "Sea/net" data | Global presence'),
    t('veson-ai-pro','Veson Nautical','business','The global industry standard for maritime commercial management with AI.','https://veson.com',false,true,9200, freeTier:'Institutional only', price:0, tips:'AI-powered "IMOS" platform | Best for oil and gas shipping | Highly secure'),
    t('fleet-mon-ai-pro','FleetMon','business','Live AIS ship tracking and maritime database with AI-powered search.','https://fleetmon.com',true,true,45000, freeTier:'Free basic account for ship info', price:0, tips:'Acquired by Kpler | AI-powered "Port" alerts | Reliable and fast'),

    // ━━━ AI FOR HOBBIES & CASUAL FUN v2 ━━━
    t('night-cafe-ai-fun','NightCafe Studio','entertainment','The easiest AI art generator to use with a fun daily community.','https://nightcafe.studio',true,true,150000, freeTier:'5 free daily credits', price:5, priceTier:'Pro monthly', tips:'Tons of algorithms (SDXL/DALL-E) | Daily art challenges | Best community'),
    t('starry-ai-fun','starryai','entertainment','AI art generator app for mobile that turns words into artwork.','https://starryai.com',true,true,120000, freeTier:'5 free daily credits', price:10, priceTier:'Premium monthly', tips:'Create NFTs or art on the go | AI-powered "Style" selection | Fast'),
    t('dream-by-wombo-ai','Dream by WOMBO','entertainment','World-famous high-speed AI art generator for mobile and web.','https://dream.ai',true,true,250000, freeTier:'Completely free basic version', price:10, priceTier:'Premium monthly for high-res', tips:'Most viral art app | AI-powered "Styles" | Fast and beautiful'),
    t('imagine-ai-fun','Imagine.art','entertainment','Leading AI art generator with high-quality models and upscaling.','https://imagine.art',true,true,84000, freeTier:'Free basic generations', price:7, priceTier:'Basic monthly annual', tips:'Best for high-quality portraits | AI-powered "Inpainting" | clean UI'),
    t('getimg-ai-pro','getimg.ai','design','Magical AI image generation and editing directly in your browser.','https://getimg.ai',true,true,120000, freeTier:'100 free monthly images', price:12, priceTier:'Basic monthly', tips:'AI-powered "Outpainting" | Training your own models with AI | High performance'),
    t('playground-ai-pro','Playground AI','design','High-end AI image creator for social media and product photos.','https://playground.com',true,true,180000, freeTier:'Free forever basic for personal', price:12, priceTier:'Pro monthly', tips:'Best for social media managers | AI-powered layout tools | High quality'),
    t('tensor-art-ai','Tensor.art','design','Leading platform for high-end AI models and generation (Safetensors).','https://tensor.art',true,true,58000, freeTier:'Free basic daily gens', price:0, tips:'The "Civitai" alternative with cloud gen | AI-powered Lora training | Pro focus'),
    t('sea-art-ai-pro','SeaArt.ai','design','Powerful AI art generator with advanced manual controls and models.','https://seaart.ai',true,true,45000, freeTier:'Free basic daily gens', price:10, priceTier:'VIP monthly', tips:'Asian market leader | AI-powered smart editing | Huge model library'),
    t('lexica-ai-pro','Lexica','design','The search engine for stable diffusion prompts and high-end art.','https://lexica.art',true,true,150000, freeTier:'Free basic search + limited gen', price:10, priceTier:'Starter monthly', tips:'AI-powered "Lexica Aperture" model | High quality aesthetics | Best for inspiration'),
    t('leonardo-ai-pro','Leonardo.ai','design','Leading production-grade AI asset generation for creatives and games.','https://leonardo.ai',true,true,250000, freeTier:'Free daily credits forever', price:12, priceTier:'Apprentice monthly', tips:'AI-powered "Canvas" for editing | High fidelity models | Professional UI'),

    // ━━━ FINAL GEMS v9 (Toolchains) ━━━
    t('lang-chain-ai-pro','LangChain','code','The framework for building LLM applications with chains and agents.','https://langchain.com',true,true,250000, freeTier:'Completely free open source', price:0, tips:'The industry standard for AI apps | Connect LLMs to any data | Huge community'),
    t('lang-smith-ai-pro','LangSmith','code','Leading platform for debugging and monitoring LLM applications.','https://smith.langchain.com',true,true,84000, freeTier:'Free forever for individuals', price:0, tips:'AI-powered "Tracing" | Best for professional AI teams | High performance'),
    t('llamaindex-ai-pro','LlamaIndex','code','Data framework for LLM applications to connect external data (RAG).','https://llamaindex.ai',true,true,150000, freeTier:'Completely free open source', price:0, tips:'The gold standard for RAG | Built-in data connectors | Fast and reliable'),
    t('haystack-ai-pro','Haystack (Deepset)','code','Open source NLP framework for building search and RAG with AI.','https://haystack.deepset.ai',true,true,45000, freeTier:'Completely free open source', price:0, tips:'Best for enterprise search | AI-powered "Pipelines" | Highly modular'),
    t('semantic-kernel-ai','Semantic Kernel (MS)','code','Microsoft\'s SDK for integrating LLMs into apps with skills and memory.','https://learn.microsoft.com/semantic-kernel',true,true,58000, freeTier:'Completely free open source', price:0, tips:'Best for .NET/C# developers | Enterprise focused | AI-powered agents'),
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
