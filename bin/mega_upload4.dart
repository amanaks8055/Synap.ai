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
    // ━━━ AI AGENTS & FRAMEWORKS ━━━
    t('autogen','AutoGen','code','Microsoft framework for building multi-agent systems that can solve tasks together.','https://microsoft.github.io/autogen',true,true,5800, freeTier:'Free open source', price:0, tips:'Define agent roles | Let agents chat to solve complex tasks | Excellent for RAG'),
    t('crew-ai','CrewAI','code','Role-based multi-agent orchestration framework for autonomous AI workflows.','https://crewai.com',true,true,4600, freeTier:'Free open source', price:0, tips:'Assign specific tools to agents | Define process flows | Strong community support'),
    t('langchain','LangChain','code','Popular framework for building context-aware reasoning applications with LLMs.','https://langchain.com',true,true,12000, freeTier:'Free open source', price:0, tips:'Largest ecosystem | Huge library of integrations | Industry standard for LLM apps'),
    t('llamaindex','LlamaIndex','code','Data framework for LLM applications to connect private or domain-specific data.','https://llamaindex.ai',true,true,8400, freeTier:'Free open source', price:0, tips:'Best for RAG and data retrieval | Easy data connectors | Advanced indexing'),
    t('babyagi','BabyAGI','code','Minimalist AI agent that prioritizes and executes tasks autonomously to achieve goals.','https://github.com/yoheinakajima/babyagi',true,false,3200, freeTier:'Free open source', price:0, tips:'Task management loop | Simple Python implementation | Good for learning agents'),
    t('auto-gpt','AutoGPT','code','The original autonomous AI agent that manages its own tasks to achieve a goal.','https://agpt.co',true,false,9600, freeTier:'Free open source', price:0, tips:'Goal-oriented autonomy | Internet browsing capability | Needs careful supervision'),
    t('meta-gpt','MetaGPT','code','Multi-agent framework that acts like a software company to write entire projects.','https://github.com/geekan/MetaGPT',true,false,2800, freeTier:'Free open source', price:0, tips:'Assigns roles like PM, Coder, Reviewer | Generates PRDs and architecture | High productivity'),
    t('gpt-researcher','GPT Researcher','code','Autonomous agent designed for comprehensive online research on any topic.','https://github.com/assafelovic/gpt-researcher',true,false,2400, freeTier:'Free open source', price:0, tips:'Aggregates 20+ sources | Generates long-form reports | Excellent for deep research'),

    // ━━━ VECTOR DATABASES ━━━
    t('pinecone','Pinecone','code','Managed cloud-native vector database for high-performance AI applications.','https://pinecone.io',true,true,7200, freeTier:'Free starter index (up to 100k vectors)', price:70, priceTier:'Standard per node per month', tips:'Serverless option available | Easy setup | Excellent for production RAG'),
    t('milvus','Milvus','code','Open-source vector database built for scalable similarity search.','https://milvus.io',true,false,3800, freeTier:'Free open source (self-host)', price:0, tips:'Highly scalable architecture | Supports multi-indexing | Best for large-scale data'),
    t('weaviate','Weaviate','code','Open-source vector search engine with GraphQL and REST interface.','https://weaviate.io',true,true,4200, freeTier:'Free cloud sandbox', price:25, priceTier:'Standard cloud hosting', tips:'Stores objects and vectors together | Search with semantic meaning | Hybrid search support'),
    t('qdrant','Qdrant','code','Vector similarity search engine and database written in Rust for performance.','https://qdrant.tech',true,false,3200, freeTier:'Free cloud tier up to 1GB', price:25, priceTier:'Pro: managed instances', tips:'High performance Rust core | Payload filtering | Easy JSON API'),
    t('chromadb','Chroma','code','Open-source embedding database for building LLM apps with focus on simplicity.','https://trychroma.com',true,true,5600, freeTier:'Free open source', price:0, tips:'Simple API for Python/JS | Runs locally easily | Perfect for prototyping'),
    t('pgvector','pgvector','code','Open-source vector similarity search for PostgreSQL.','https://github.com/pgvector/pgvector',true,true,6800, freeTier:'Free and open source', price:0, tips:'Add vectors to existing Postgres DB | SQL query support | Easy integration'),

    // ━━━ MLOPS & DEPLOYMENT ━━━
    t('bentoml','BentoML','code','Unified framework for building, shipping, and scaling AI applications.','https://bentoml.ai',true,false,2800, freeTier:'Free open source', price:0, tips:'Standardize model packaging | High performance inference | Easy cloud deployment'),
    t('ray-serve','Ray Serve','code','Scalable model serving library for building online inference APIs.','https://ray.io',true,false,3400, freeTier:'Free open source', price:0, tips:'Distributed serving | Scales to 1000s of CPUs/GPUs | Used by OpenAI and Uber'),
    t('seldon-core','Seldon Core','code','ML deployment on Kubernetes with advanced monitoring and scaling.','https://seldon.io',true,false,2200, freeTier:'Free open source version', price:0, tips:'Enterprise grade MLOps | A/B testing support | Drift detection'),
    t('zenml','ZenML','code','Extensible open-source MLOps framework for reproducible pipelines.','https://zenml.io',true,false,1600, freeTier:'Free open source', price:0, tips:'Pipeline versioning | Tool-agnostic architecture | Cloud portability'),
    t('kubeflow','Kubeflow','code','The machine learning toolkit for Kubernetes for scalable deployments.','https://kubeflow.org',true,false,3800, freeTier:'Free open source', price:0, tips:'Complete ML lifecycle on K8s | Strong multi-cloud support | Industry standard'),

    // ━━━ SYNTHETIC DATA ━━━
    t('gretel-ai','Gretel AI','data','Privacy-preserving synthetic data platform for safe data sharing and training.','https://gretel.ai',true,true,3200, freeTier:'Free trial with 15 credits', price:500, priceTier:'Enterprise starting price', tips:'Generate privacy-safe data | Balance unbalanced datasets | Protect sensitive info'),
    t('mostly-ai','Mostly AI','data','Synthetic data platform for generating high-quality tabular data.','https://mostly.ai',true,false,2400, freeTier:'Free for up to 100k rows', price:0, tips:'Preserve correlation in data | Secure for financial data | Easy dashboard'),
    t('hazy-ai','Hazy','data','Enterprise synthetic data software for generating realistic financial data.','https://hazy.com',false,false,1400, freeTier:'Demo available', price:0, tips:'Focused on banking and insurance | High security compliance | Privacy-first'),
    t('syntho','Syntho','data','Core synthetic data platform for generating private and biased-free data.','https://syntho.ai',false,false,1200, freeTier:'Demo available', price:0, tips:'Privacy-preserving analytics | Smart de-identification | Fast data generation'),
    t('tonic-ai','Tonic','data','Realistic synthetic data for software testing and local development.','https://tonic.ai',true,false,2000, freeTier:'Free trial available', price:0, tips:'Subset and mask production data | Secure for developers | Best for QA'),

    // ━━━ BIOTECH & SCIENCE ━━━
    t('alphafold','AlphaFold','science','Google DeepMind AI system that predicts 3D structure of proteins.','https://deepmind.google/alphafold',true,true,15000, freeTier:'Free results via database', price:0, tips:'Scientific breakthrough tool | Predict any protein structure | Free for research'),
    t('rosettafold','RoseTTAFold','science','AI system for predicting protein structures and complexes.','https://github.com/RosettaCommons/RoseTTAFold',true,false,3400, freeTier:'Free and open source', price:0, tips:'Competitor to AlphaFold | Excellent accuracy | Good for multi-protein structures'),
    t('generate-biomed','Generate Biomedicines','science','AI platform for de novo protein design and drug discovery.','https://generatebiomedicines.com',false,false,2600, freeTier:'Institutional access only', price:0, tips:'Design functional proteins | Generative biology leader | Next-gen therapeutics'),
    t('insilico-medicine','Insilico Medicine','science','AI for end-to-end drug discovery and biomarker development.','https://insilico.com',false,false,2200, freeTier:'Individual demo only', price:0, tips:'AI-designed drugs in clinical trials | Pandas platform | Aging research focus'),
    t('atomwise','Atomwise','science','AI for structure-based drug discovery using neural networks.','https://atomwise.com',false,false,1800, freeTier:'Institutional access only', price:0, tips:'AtomNet technology | Predicts binding affinity | Fast screening of 10B+ molecules'),

    // ━━━ MANUFACTORING & SUPPLY CHAIN ━━━
    t('c3ai','C3 AI','business','Enterprise AI platform for predictive maintenance and inventory.','https://c3.ai',false,true,4800, freeTier:'Demo available', price:0, tips:'Massive enterprise deployments | Predict equipment failure | Supply chain optimization'),
    t('sparkbeyond','SparkBeyond','business','AI engines that discover hidden patterns in data for retail and supply chain.','https://sparkbeyond.com',false,false,2400, freeTier:'No free tier', price:0, tips:'Auto-discover features in data | Impact analysis | High level analytics'),
    t('uptake','Uptake','business','Industrial AI for asset performance management and reliability.','https://uptake.com',false,false,2800, freeTier:'Demo available', price:0, tips:'Predictive maintenance for machines | Reduce downtime | Energy efficiency'),
    t('coupa','Coupa AI','business','AI-powered spend management and supply chain design platform.','https://coupa.com',false,false,3400, freeTier:'Demo available', price:0, tips:'Optimize procurement | Risk assessment for suppliers | Sustainable sourcing'),
    t('project44','project44','business','AI supply chain visibility platform for real-time freight tracking.','https://project44.com',false,false,3200, freeTier:'No free tier', price:0, tips:'Track global shipments | High accuracy ETA | Reduce logistics costs'),

    // ━━━ PR & COMMUNICATION ━━━
    t('muckrack','Muck Rack','support','AI platform for PR teams to find journalists and monitor news.','https://muckrack.com',false,true,4200, freeTier:'Free basic profile for journalists', price:0, tips:'Identify relevant journalists | AI pitch generator | Beautiful reporting'),
    t('prowly','Prowly','support','AI PR software for media relations and press release distribution.','https://prowly.com',true,false,1800, freeTier:'7-day free trial', price:189, priceTier:'Professional monthly', tips:'Connect with influencers | PR metrics tracking | SEO press releases'),
    t('cision','Cision','support','Comprehensive PR monitoring and media database platform.','https://cision.com',false,false,2600, freeTier:'No free tier', price:0, tips:'Largest media database | Industry standard for monitoring | Impact reporting'),
    t('prezly','Prezly','support','AI PR tool for managing newsrooms and CRM for journalists.','https://prezly.com',true,false,1400, freeTier:'14-day free trial', price:50, priceTier:'Solo per month', tips:'Beautiful online newsrooms | Direct email pitching | Team collaboration'),
    t('brandwatch','Brandwatch','support','AI consumer intelligence and social listening platform.','https://brandwatch.com',false,false,3800, freeTier:'Demo available', price:0, tips:'Listen to millions of conversations | Detect emerging trends | Crisis management'),

    // ━━━ AUDIO MASTERING & FX ━━━
    t('landr','LANDR','audio','AI-powered audio mastering for musicians and producers.','https://landr.com',true,true,5400, freeTier:'Limited free masters with ads', price:12, priceTier:'Studio monthly unlimited masters', tips:'Industry standard AI mastering | Distribution included | Collaborative tools'),
    t('emasters','eMastered','audio','Professional AI audio mastering engine developed by Grammy winners.','https://emastered.com',false,false,3200, freeTier:'Free preview of master', price:13, priceTier:'Annual billed monthly', tips:'Customizable mastering engine | Fast results | Professional loudness'),
    t('cloudbounce','CloudBounce','audio','Fast and affordable AI mastering for desktop and cloud.','https://cloudbounce.com',true,false,1800, freeTier:'Free preview of master', price:5, priceTier:'Per track starting price', tips:'Loudness control | Desktop app available | Good for quick demos'),
    t('izotope-ozone','iZotope Ozone','audio','The industry standard mastering software with AI Assistant.','https://izotope.com',false,true,6800, freeTier:'Free trial available', price:249, priceTier:'One-time purchase (desktop)', tips:'Mastering Assistant sets initial chain | Tonal balance control | Essential for pros'),
    t('audiomodern-riffer','Audiomodern Riffer','audio','AI melody generator creating unique riffs and patterns.','https://audiomodern.com',false,false,2200, freeTier:'Demo available', price:50, priceTier:'One-time purchase', tips:'Generate endless MIDI melodies | Sync with DAW | High creativity'),

    // ━━━ MORE PRODUCTIVITY ━━━
    t('summari','Summari','reading','AI reading assistant that summarizes any article instantly.','https://summari.com',true,false,2800, freeTier:'Free browser extension (limited)', price:5, priceTier:'Pro: unlimited summaries', tips:'Get the gist in 30 seconds | Works on mobile and web | Saves hours of reading'),
    t('readwise-reader','Readwise Reader','reading','Powerful all-in-one reading app with Ghostreader AI.','https://readwise.io/reader',true,true,6200, freeTier:'30-day free trial', price:8, priceTier:'Full Readwise access monthly', tips:'AI summarizes and answers questions | Highlight anything | Best for researchers'),
    t('genei-ai','Genei','research','AI summarization and research tool for faster writing.','https://genei.io',true,false,2400, freeTier:'14-day free trial', price:10, priceTier:'Basic monthly', tips:'Extract keywords from papers | Linked citations | Good for students'),
    t('otter-ai-transcribe','Otter.ai','support','AI meeting assistant for transcription and notes.','https://otter.ai',true,true,9600, freeTier:'300 minutes free per month', price:10, priceTier:'Pro: 1200 minutes per month', tips:'Auto-joins Zoom/Teams calls | Real-time transcription | Smart summaries'),
    t('fireflies-ai','Fireflies.ai','support','AI voice assistant that records, transcribes, and searches meetings.','https://fireflies.ai',true,false,5800, freeTier:'Free forever with limits', price:10, priceTier:'Pro: unlimited transcriptions', tips:'Excellent search across all meetings | Integrates with CRMs | Topic tracking'),

    // ━━━ NO-CODE BUILDERS ━━━
    t('bubble-ai','Bubble','code','The most powerful no-code platform for building web apps.','https://bubble.io',true,true,12000, freeTier:'Free for learning', price:29, priceTier:'Starter plan with personal domain', tips:'Steep learning curve but worth it | Complete backend/frontend | Large marketplace'),
    t('framer-ai','Framer','design','AI tool that generates entire responsive websites from text.','https://framer.com',true,true,15000, freeTier:'Free with Framer domain', price:5, priceTier:'Mini plan for custom domain', tips:'Fastest way to build landing pages | Incredible design flexibility | AI-powered copy'),
    t('webflow-ai','Webflow','design','Professional website builder with AI for localization and design.','https://webflow.com',true,true,18000, freeTier:'Free until you launch', price:14, priceTier:'Basic plan with custom domain', tips:'Best for pixel-perfect design | AI helps with ALT text and code | Clean code export'),
    t('flutterflow-ai','FlutterFlow','code','AI-powered visual builder for building native mobile apps faster.','https://flutterflow.io',true,true,9800, freeTier:'Free to build (no export)', price:30, priceTier:'Standard with code export', tips:'One-click deploy to stores | Firebase integration | AI generates code/UI'),
    t('softr-ai','Softr','code','Building apps from Google Sheets or Airtable in minutes with AI.','https://softr.io',true,false,5200, freeTier:'Free for up to 5 apps', price:49, priceTier:'Professional: unlimited users', tips:'Easiest CRUD app builder | Great for internal tools | Connect to Airtable'),
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
