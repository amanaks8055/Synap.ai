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
    // ━━━ HIGH-END CREATIVE & GRAPHICS AI ━━━
    t('adobe-firefly-pro','Adobe Firefly','design','Adobe\'s family of creative generative AI models for high-end design.','https://adobe.com/firefly',true,true,250000, freeTier:'25 free monthly credits', price:5, priceTier:'Premium: 100 credits monthly', tips:'Best for commercial safety | Integrated with Photoshop and Illustrator | AI text-to-image'),
    t('midjourney-pro-ai','Midjourney','design','Leading AI image generator known for artistic quality and photorealism.','https://midjourney.com',false,true,500000, freeTier:'No free trial currently', price:10, priceTier:'Basic plan monthly', tips:'Use Discord to generate | Best for artistic explorations | High res output'),
    t('magnific-ai-pro','Magnific AI','design','The world\'s most powerful AI image upscaler and enhancer for creators.','https://magnific.ai',false,true,180000, freeTier:'No free tier', price:39, priceTier:'Solo plan monthly', tips:'"Re-imagine" your images | Best for professional photographers | Extreme detail enhancement'),
    t('topaz-labs-ai','Topaz Photo AI','design','AI-powered software for noise reduction, sharpening, and upscaling photos.','https://topazlabs.com',false,true,120000, freeTier:'Free trial available (watermarked)', price:199, priceTier:'One-time purchase', tips:'Desktop software for Mac/PC | AI-powered "Autopilot" | Professional quality'),
    t('upscayl-pro-ai','Upscayl','design','Free and open source AI image upscaler that works locally on your computer.','https://upscayl.org',true,true,150000, freeTier:'Completely free open source', price:0, tips:'Runs on your GPU | Privacy-first | Support for multiple AI models'),
    t('kling-ai-video','Kling AI','video','Next-generation AI video generator from text with extreme realism and consistency.','https://klingai.com',true,true,92000, freeTier:'Free daily credits', price:10, priceTier:'Standard monthly', tips:'Generate 1080p realistic videos | Best for storytelling | Highly competitive with Sora'),
    t('pika-labs-ai','Pika','video','Leading AI platform for animating images and generating videos from text.','https://pika.art',true,true,180000, freeTier:'Free daily credits', price:10, priceTier:'Starter monthly', tips:'"Modify Region" AI tool | Best for realistic movement | Integrated lip-sync'),
    t('runway-gen3-video','Runway Gen-3','video','High-fidelity AI video generation and editing model for cinematic scenes.','https://runwayml.com',true,true,150000, freeTier:'Starter credits available', price:15, priceTier:'Standard monthly', tips:'Strong motion control tools | Great for storytelling and ad creatives | Trusted by creators'),
    t('leonardo-ai-pro','Leonardo.ai','design','Full-stack AI image generation platform for creators and developers.','https://leonardo.ai',true,true,250000, freeTier:'150 daily free tokens', price:12, priceTier:'Apprentice monthly', tips:'Train your own models | AI-powered canvas | API available for devs'),
    t('playground-ai-pro','Playground','design','Online AI image creator that makes it easy for anyone to create art.','https://playground.com',true,true,180000, freeTier:'50 free images daily', price:15, priceTier:'Pro monthly', tips:'Easy integrated editor | Community-driven prompt search | High quality models'),

    // ━━━ 3D, ARCHITECTURE & INDUSTRIAL AI ━━━
    t('spline-ai-pro','Spline AI','design','Collaborative 3D design tool with AI features for physics and modeling.','https://spline.design',true,true,58000, freeTier:'Free for personal projects', price:9, priceTier:'Super per month billed annually', tips:'Create 3D for the web | AI-powered style transfer | Real-time collaboration'),
    t('meshy-ai-pro','Meshy','design','AI-powered tool for generating high-quality 3D models from text or images.','https://meshy.ai',true,true,45000, freeTier:'Free limited generations', price:20, priceTier:'Pro monthly', tips:'Generate 3D textures and meshes | Export to Blender/Unity | Fast turnaround'),
    t('tripo-ai-3d','Tripo AI','design','High-speed AI 3D generator that creates meshes from text in seconds.','https://tripo3d.ai',true,true,35000, freeTier:'Free basic version', price:30, priceTier:'Pro monthly', tips:'Extremely fast 3D generation | API for game developers | Professional geometry'),
    t('veras-architecture','Veras','design','AI-powered visualization for architects to create renderings from CAD.','https://evolvelab.io/veras',true,true,28000, freeTier:'Free trial available', price:50, priceTier:'Individual monthly', tips:'Integrated with Revit and Rhino | Create photo-real renderings in seconds | AI style control'),
    t('ark-design-ai','Ark Design','design','AI platform for architects to automate floor plan generation and feasibility.','https://arkdesign.ai',false,true,12000, freeTier:'Demo available', price:0, tips:'Optimize for density and sunlight | AI-powered site analysis | Enterprise focused'),
    t('makito-3d-ai','Makit.io','design','AI assistant for 3D modeling and rendering in high-fidelity environments.','https://makit.io',true,false,9200, freeTier:'Free trial available', price:25, priceTier:'Pro monthly', tips:'Best for interior designers | AI-powered furniture placement | Realistic lighting'),
    t('naro-architecture','Naro','design','AI-powered platform for sustainable architectural design and modeling.','https://narodesign.com',false,false,4500, freeTier:'Institutional only', price:0, tips:'Carbon footprint analysis | AI-powered form finding | High transparency'),
    t('hypar-ai-pro','Hypar','design','The platform for building custom, generative building systems with AI.','https://hypar.io',true,false,8400, freeTier:'Free basic version', price:75, priceTier:'Professional monthly', tips:'Python-based generative design | Cloud infrastructure for buildings | Open standard'),
    t('testfit-ai-pro','TestFit','design','Leading building feasibility platform using AI for rapid site planning.','https://testfit.io',false,true,15000, freeTier:'Demo and trial available', price:0, tips:'AI-powered parking and unit layouts | Real-time financial analysis | Trusted by developers'),
    t('spacemaker-ai','Spacemaker (Autodesk)','design','AI software to help architects and urban designers optimize site plans.','https://spacemakerai.com',false,true,12000, freeTier:'Demo available', price:0, tips:'Acquired by Autodesk | AI for noise and wind analysis | Leading in urban tech'),

    // ━━━ LEGAL & PROFESSIONAL AI ━━━
    t('casetext-cocounsel','CoCounsel (Casetext)','business','The world\'s first AI legal assistant designed for professional lawyers.','https://casetext.com/cocounsel',false,true,45000, freeTier:'Demo available', price:500, priceTier:'Monthly per user (approx)', tips:'Acquired by Thomson Reuters | Review docs and research laws | "Reliable" AI for legal'),
    t('harvey-ai-legal','Harvey','business','AI platform for elite law firms to automate complex legal work.','https://harvey.ai',false,true,32000, freeTier:'Institutional only', price:0, tips:'Built on specialized LLMs | Used by top 10 law firms | High degree of accuracy'),
    t('pax-legal-ai','Pax','business','AI legal intelligence platform for summarizing and analyzing contracts.','https://paxlegal.ai',true,false,8400, freeTier:'Free trial for 5 documents', price:50, priceTier:'Pro monthly', tips:'Best for small legal teams | AI-powered risk detection | Secure and private'),
    t('ironclad-ai-pro','Ironclad','business','Leading contract management platform with AI-powered redlining.','https://ironcladapp.com',false,true,15000, freeTier:'Demo available', price:0, tips:'Best for enterprise procurement | AI analyzes contract terms | Integrated with Salesforce'),
    t('luminance-ai-pro','Luminance','business','The most advanced AI for legal document processing and due diligence.','https://luminance.com',false,false,9200, freeTier:'Institutional only', price:0, tips:'Self-learning AI for legal | Used by thousands of lawyers | Multi-language support'),
    t('klarity-ai-pro','Klarity','business','AI platform that automates revenue recognition and contract review.','https://klarity.com',false,false,5600, freeTier:'Demo available', price:0, tips:'Best for accounting/finance teams | AI-powered data extraction | High precision'),
    t('ross-legal-ai','ROSS Intelligence','business','AI-powered legal research that understands natural language queries.','https://rossintelligence.com',false,false,4200, freeTier:'Demo available', price:0, tips:'Fastest legal research | AI-powered case summaries | Integrated citations'),
    t('legal-zoom-ai','LegalZoom (AI Tools)','business','World-class legal services for business with AI-powered document help.','https://legalzoom.com',true,true,250000, freeTier:'Free basic setup info', price:0, tips:'Most recognized brand | AI for trademark search | Best for entrepreneurs'),
    t('rocket-lawyer-ai','Rocket Lawyer','business','Leading legal document platform with AI-powered legal advice.','https://rocketlawyer.com',true,true,150000, freeTier:'Free trial for 7 days', price:40, priceTier:'Premium monthly', tips:'Best for personal and small biz | On-call lawyer support | Secure storage'),
    t('clio-ai-law','Clio','business','The leading legal practice management software with AI-powered insights.','https://clio.com',false,true,58000, freeTier:'7-day free trial', price:39, priceTier:'Starter per user monthly', tips:'All-in-one for lawyers | AI-powered billing and tasks | Robust security'),

    // ━━━ LOGISTICS, SUPPLY CHAIN & MANUFACTURING AI ━━━
    t('project-44-ai','project44','business','The leading supply chain visibility platform using AI for tracking.','https://project44.com',false,true,25000, freeTier:'Demo available', price:0, tips:'Track global freight in real-time | AI-powered ETA prediction | Enterprise standard'),
    t('fourkites-ai-pro','FourKites','business','Leading supply chain intelligence platform with AI-powered orchestration.','https://fourkites.com',false,true,18000, freeTier:'Demo available', price:0, tips:'Best for large manufacturers | AI identifies disruptions | Real-time visibility'),
    t('flexport-ai-pro','Flexport','business','The modern freight forwarder using AI to simplify global trade.','https://flexport.com',true,true,45000, freeTier:'Free access to dashboard', price:0, tips:'Industry disruptor | AI-powered logistics | Transparent pricing and data'),
    t('c3-ai-pro','C3 AI','business','Enterprise AI software platform for digital transformation and supply chain.','https://c3.ai',false,true,12000, freeTier:'Demo available', price:0, tips:'Tom Siebel\'s company | AI for inventory optimization | Massive industrial scale'),
    t('sight-machine-ai','Sight Machine','business','The manufacturing data platform using AI to optimize production and quality.','https://sightmachine.com',false,false,5600, freeTier:'Demo available', price:0, tips:'AI for smart factories | Real-time production visibility | Data-driven manufacturing'),
    t('falkonry-ai-pro','Falkonry','business','AI for operational AI and predictive quality in industrial manufacturing.','https://falkonry.com',false,false,4200, freeTier:'Demo available', price:0, tips:'Acquired by IFS | Pattern recognition for machines | High precision'),
    t('uptake-ai-pro','Uptake','business','AI platform for industrial diagnostics and predictive maintenance.','https://uptake.com',false,true,9200, freeTier:'Demo available', price:0, tips:'Best for fleets and heavy machinery | AI predicts failures | Cost-saving tech'),
    t('sparkcognition-ai','SparkCognition','business','Leading enterprise AI company building industrial-scale AI systems.','https://sparkcognition.com',false,false,8400, freeTier:'Institutional only', price:0, tips:'AI for energy, aviation, and defense | Trusted by global leaders | High security'),
    t('pathway-ai-pro','Pathway','business','Real-time data processing platform using AI for logistics and supply chain.','https://pathway.com',true,false,5600, freeTier:'Free open source edition', price:0, tips:'Python-first streaming AI | High performance | Best for tech-heavy logistics'),
    t('source-day-ai','SourceDay','business','AI-powered collaborative platform for direct spend management and procurement.','https://sourceday.com',false,false,3500, freeTier:'Demo available', price:0, tips:'Prevents supply chain gaps | AI manages PO changes | Integrated with ERPs'),

    // ━━━ AI FOR HEALTHCARE PROFESSIONALS ━━━
    t('doximity-gpt','Doximity (DoximityGPT)','health','The world\'s largest professional network for physicians with AI tools.','https://doximity.com',true,true,250000, freeTier:'Free for verified medical professionals', price:0, tips:'HIPAA compliant AI tools | Fax and call from mobile | Official US Doctor network'),
    t('ambience-ai','Ambience Healthcare','health','AI-powered operating system for healthcare professionals to automate notes.','https://ambiencehealthcare.com',false,true,12000, freeTier:'Demo available', price:0, tips:'Best for clinical documentation | AI scribe for exams | Integrated with Epic/Cerner'),
    t('augmedix-ai-pro','Augmedix','health','Advanced AI medical documentation and automated clinician support.','https://augmedix.com',false,true,15000, freeTier:'Demo available', price:0, tips:'Proven ROI for doctors | AI-powered patient notes | Real-time support'),
    t('deep-scribe-ai','DeepScribe','health','AI-powered clinical documentation that uses ambient sensing for notes.','https://deepscribe.ai',false,true,18000, freeTier:'7-day free trial', price:0, tips:'The largest AI clinical dataset | Highest accuracy documentation | Trusted by Mayo Clinic'),
    t('glass-health-ai','Glass Health','health','AI-powered platform for clinical decision support and medical knowledge.','https://glass.health',true,true,45000, freeTier:'Free basic decision support', price:15, priceTier:'Plus monthly', tips:'Best for differential diagnosis | AI-powered medical textbooks | Peer-reviewed content'),
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
