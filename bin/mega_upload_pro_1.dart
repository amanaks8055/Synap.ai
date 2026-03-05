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
    // ━━━ LEGAL AI (Professional) ━━━
    t('casetext-ai','Casetext (CoCounsel)','legal','The world\'s first AI legal assistant for document review and research.','https://casetext.com',false,true,15000, freeTier:'Demo available', price:500, priceTier:'Enterprise starting price', tips:'AI-powered legal research | Document review in minutes | Used by thousands of law firms'),
    t('harvey-ai','Harvey','legal','Custom AI for elite law firms to automate complex legal workflows.','https://harvey.ai',false,true,12000, freeTier:'Institutional access only', price:0, tips:'Built on GPT-4 | Backed by OpenAI Startup Fund | Enterprise-grade security'),
    t('spellbook-ai','Spellbook','legal','AI tool that drafts and reviews contracts directly in Microsoft Word.','https://spellbook.com',true,true,8400, freeTier:'Free trial for lawyers', price:89, priceTier:'Pro per user monthly', tips:'Best Word integration | Suggests missing clauses | Detects aggressive terms'),
    t('lawgeex-ai','LawGeex','legal','AI platform for automated contract review and approval for legal teams.','https://lawgeex.com',false,false,5600, freeTier:'Demo available', price:0, tips:'Review contracts against your policy | Speed up deal closing | High accuracy'),
    t('everlaw-ai','Everlaw','legal','Cloud-based e-discovery platform with AI-powered review and prediction.','https://everlaw.com',false,false,4800, freeTier:'Demo available', price:0, tips:'Fastest document review | Predictive coding | Collaborative legal workflows'),
    t('disco-ai','DISCO','legal','AI platform for legal professionals to manage discovery and litigation.','https://csdisco.com',false,false,3200, freeTier:'Demo available', price:0, tips:'High-speed e-discovery | AI-powered tag predictions | Used in major litigations'),
    t('kira-systems-ai','Kira Systems','legal','AI-powered contract analysis for due diligence and lease abstraction.','https://kirasystems.com',false,false,2400, freeTier:'Demo available', price:0, tips:'Acquired by Litera | Extract data from 1000s of contracts | High precision'),
    t('legasis-ai','Legasis','legal','Legal compliance and entity management with AI for risk assessment.','https://legasis.in',false,false,1800, freeTier:'Demo available', price:0, tips:'Best for Indian legal compliance | Automated risk tracking | Enterprise ready'),

    // ━━━ MEDICAL & HEALTHCARE AI ━━━
    t('viz-ai','Viz.ai','health','AI-powered clinical decision support for stroke and heart disease.','https://viz.ai',false,true,12000, freeTier:'Hospital access only', price:0, tips:'Saves vital minutes in stroke care | AI connects specialists instantly | FDA cleared'),
    t('babylon-ai','Babylon Health','health','AI-powered symptom checker and virtual consultations.','https://babylonhealth.com',true,true,25000, freeTier:'Free symptom checker', price:0, tips:'Connect with doctors 24/7 | AI-driven triage | Personalized health plans'),
    t('ada-health-ai','Ada Health','health','Personal health companion for symptom checking and health guidance.','https://ada.com',true,true,35000, freeTier:'Completely free for users', price:0, tips:'High diagnostic accuracy | Developed by doctors | Safe and private'),
    t('paige-ai','Paige','health','AI-powered digital pathology for faster and more accurate cancer diagnosis.','https://paige.ai',false,false,4200, freeTier:'Institutional only', price:0, tips:'FDA-cleared for prostate cancer | AI assists pathologists | Digital slides focus'),
    t('path-ai','PathAI','health','AI-powered pathology solutions for drug development and diagnostics.','https://pathai.com',false,false,3800, freeTier:'Demo available', price:0, tips:'Quantify immune cells in tissue | Improve clinical trials | High quality datasets'),
    t('butterfly-network-ai','Butterfly Network','health','Portable ultrasound device with AI-powered imaging and guidance.','https://butterflynetwork.com',false,true,9600, freeTier:'App is free (pay for device)', price:0, tips:'Turn your iPhone into an ultrasound | AI helps with probe placement | Affordable diagnostics'),
    t('ecko-health-ai','Eko Health','health','Digital stethoscopes with AI for detecting heart murmurs and AFib.','https://ekohealth.com',false,true,7200, freeTier:'App basic is free', price:0, tips:'FDA-cleared AI algorithms | Connects to smartphone | Trusted by cardiologists'),

    // ━━━ ARCHITECTURE (Advanced) ━━━
    t('ark-design-ai','Ark','design','AI platform for optimizing building designs for light, wind, and cost.','https://arkdesign.ai',false,true,6200, freeTier:'Demo available', price:0, tips:'Generate 100s of schematic designs | Sustainability focus | Instant site analysis'),
    t('maket-ai','Maket','design','AI tool for residential floor plans and architectural visualization.','https://maket.ai',true,true,8400, freeTier:'Free basic version available', price:20, priceTier:'Professional monthly', tips:'Generate floor plans from text | 3D visualizer built-in | Great for homeowners'),
    t('hypar-ai','Hypar','design','Platform for generating and sharing building systems with AI.','https://hypar.io',true,false,3200, freeTier:'Free for open source projects', price:50, priceTier:'Professional monthly', tips:'Python-powered building generation | BIM integration | Scalable cloud compute'),
    t('planfinder-ai','PlanFinder','design','AI plugin for Revit and Rhino to generate apartment floor plans.','https://planfinder.xyz',true,true,4600, freeTier:'30-day free trial', price:15, priceTier:'Monthly subscription', tips:'Fastest way to layout apartments | Works inside your CAD tool | AI-driven optimization'),
    t('veras-ai','EvolveLAB Veras','design','AI-powered visualization for Revit, Rhino, and SketchUp.','https://evolvelab.io/veras',true,true,5800, freeTier:'Free limited version', price:30, priceTier:'Standard monthly', tips:'Render directly in CAD | Multiple variations in seconds | Very high quality'),

    // ━━━ FINANCE & TRADING (Institutional) ━━━
    t('bloomberg-gpt','BloombergGPT','finance','Large language model specifically trained for the financial industry.','https://bloomberg.com',false,true,15000, freeTier:'Bloomberg Terminal only', price:2000, priceTier:'Terminal monthly starting', tips:'Unmatched financial data | Sentiment analysis on news | SQL-like financial queries'),
    t('kavout-ai','Kavout','finance','AI-powered investment platform with quantitative stock ratings.','https://kavout.com',false,false,4200, freeTier:'Demo available', price:0, tips:'Kai score for stock prediction | Used by hedge funds | Data-driven insights'),
    t('aladdin-blackrock','Aladdin (BlackRock)','finance','The world\'s most powerful risk management and investment system.','https://blackrock.com/aladdin',false,true,9200, freeTier:'Institutional only', price:0, tips:'Manages \$20 trillion+ in assets | AI-powered risk scoring | Industry standard'),
    t('quantconnect-ai','QuantConnect','finance','Cloud-based algorithmic trading platform with AI backtesting.','https://quantconnect.com',true,true,8400, freeTier:'Free for individuals (limited)', price:20, priceTier:'Researcher monthly', tips:'Code in Python/C# | Access to massive datasets | Direct broker integration'),
    t('numerai-ai','Numerai','finance','The hardest data science tournament in the world for stock market AI.','https://numer.ai',true,true,15000, freeTier:'Completely free to compete', price:0, tips:'Encrypted data | Crowd-sourced hedge fund | Win crypto (NMR) rewards'),

    // ━━━ HR & TALENT (Enterprise) ━━━
    t('eightfold-ai','Eightfold','hr','AI platform for talent intelligence and skill-based hiring.','https://eightfold.ai',false,true,5200, freeTier:'Demo available', price:0, tips:'Identify skill gaps | Bias-free hiring | Internal mobility focus'),
    t('phenom-ai','Phenom','hr','Intelligent Talent Experience Platform for large enterprise hiring.','https://phenom.com',false,false,3400, freeTier:'Demo available', price:0, tips:'AI-powered career sites | Recruitment CRM | Bot for candidate engagement'),
    t('hired-ai','Hired','hr','AI marketplace for tech talent with salary transparency and skills test.','https://hired.com',true,true,12000, freeTier:'Free for candidates', price:0, tips:'Companies apply to you | Verified salaries | High quality tech focus'),
    t('human-interest-ai','Human Interest','hr','AI-powered 401(k) for small businesses to automate retirement plans.','https://humaninterest.com',false,false,2800, freeTier:'Demo available', price:0, tips:'Easiest 401k setup | Automatic payroll sync | Affordable for startups'),
    t('lattice-ai','Lattice','hr','Performance management platform with AI for goals and feedback.','https://lattice.com',false,true,6800, freeTier:'Demo available', price:11, priceTier:'Performance monthly per user', tips:'Best for startup HR | Integrated with Slack | Beautiful analytics'),

    // ━━━ ENGINEERING & PLM ━━━
    t('ptc-creo-ai','PTC Creo','code','Generative design and AI-driven CAD software for mechanical engineering.','https://ptc.com',false,true,5400, freeTier:'Free trial available', price:0, tips:'Optimize for 3D printing | Simulation-led design | Real-time analysis'),
    t('ansys-ai','ANSYS Simulation','code','AI-powered engineering simulation software for physics and fluid dynamics.','https://ansys.com',false,true,8200, freeTier:'Free student version', price:0, tips:'Industry standard for simulation | AI speeds up solve times | Used by F1 teams'),
    t('altium-ai','Altium Designer','code','PCB design software with AI-powered routing and component placement.','https://altium.com',false,true,6200, freeTier:'Free trial available', price:0, tips:'Best for electronics designers | Cloud-based collaboration | Massive component library'),
    t('autodesk-fusion-ai','Fusion 360','code','Cloud-based CAD/CAM/CAE tool with generative design.','https://autodesk.com/fusion-360',true,true,15000, freeTier:'Free for personal use', price:70, priceTier:'Professional monthly', tips:'Best all-in-one tool | Generative design engine | Integrated manufacturing'),
    t('ntopology-ai','nTop','code','Advanced engineering design software for complex geometries with AI.','https://ntopology.com',false,false,3200, freeTier:'Demo available', price:0, tips:'Generative lattices | high performance structures | Best for aerospace'),
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
