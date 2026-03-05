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
    // ━━━ DEVELOPER TOOLS (Niche) ━━━
    t('localstack-ai','LocalStack','code','Cloud service emulator for local development and testing with AI for cloud resource mocking.','https://localstack.cloud',true,true,3800, freeTier:'Free community edition', price:25, priceTier:'Pro per user monthly', tips:'Test AWS infra offline | Instant feedback loop | Huge list of supported services'),
    t('testim-ai','Testim','code','AI-powered test automation for fast and reliable end-to-end testing.','https://testim.io',true,false,2800, freeTier:'Free for up to 100 runs per month', price:0, tips:'Self-healing tests | Low-code editor | Integrated with CI/CD'),
    t('applitools-ai','Applitools','code','AI platform for automated visual testing and monitoring of web and mobile apps.','https://applitools.com',true,true,4200, freeTier:'Free forever basic', price:0, tips:'Industry standard for visual regressions | Support for 50+ SDKs | Cross-browser cloud'),
    t('datadog-ai','Datadog Watchdog','code','Monitoring and security platform with Watchdog AI for anomaly detection.','https://datadoghq.com',true,true,12000, freeTier:'Free trial available', price:15, priceTier:'Pro starting price', tips:'Monitor across entire stack | AI identifies root cause | Real-time alerts'),
    t('new-relic-ai','New Relic AI','code','Observability platform with AI to help engineers find and fix issues faster.','https://newrelic.com',true,true,9600, freeTier:'Free up to 100GB/month', price:0, tips:'Full-stack monitoring | AI-powered incident intelligence | Easy instrumentation'),

    // ━━━ MARKETING & SEO (Advanced) ━━━
    t('semrush-ai','SEMrush','marketing','Leading SEO platform with AI tools for keyword research and writing.','https://semrush.com',true,true,18000, freeTier:'Free basic account (limited)', price:129, priceTier:'Pro monthly', tips:'Largest keyword database | Competitor analysis is unmatched | AI Writing Assistant'),
    t('ahrefs-ai','Ahrefs','marketing','Powerful SEO toolset with AI for backlink analysis and site auditing.','https://ahrefs.com',true,true,15000, freeTier:'Free Webmaster Tools', price:99, priceTier:'Lite monthly', tips:'Most accurate backlink data | Site audit finds technical issues | Content explorer'),
    t('moz-ai','Moz Pro','marketing','SEO software with AI for local search and link building insights.','https://moz.com',true,false,8400, freeTier:'30-day free trial', price:99, priceTier:'Standard monthly', tips:'Pioneers of SEO | "Domain Authority" metrics | Local SEO focus'),
    t('surfer-seo-ai','Surfer','marketing','AI content optimization tool for ranking higher in search engines.','https://surferseo.com',false,true,7200, freeTier:'7-day money back guarantee', price:29, priceTier:'Lite monthly', tips:'Best for content editing | Analyzes 500+ ranking factors | Grow Flow insights'),
    t('clearscope-ai','Clearscope','marketing','Enterprise grade content optimization platform for top SEO performance.','https://clearscope.io',false,false,4800, freeTier:'Demo available', price:170, priceTier:'Essentials monthly', tips:'Used by world-class content teams | Cleanest UI | Very accurate recommendations'),

    // ━━━ EMAIL MARKETING AI ━━━
    t('mailchimp-ai','Mailchimp','marketing','Leading email platform with AI for content generation and segments.','https://mailchimp.com',true,true,25000, freeTier:'Free for up to 1000 sends', price:13, priceTier:'Essentials monthly', tips:'Best for beginners | AI Content Optimizer | Intuit ecosystem'),
    t('klaviyo-ai','Klaviyo','marketing','E-commerce marketing automation with AI-powered predictive analytics.','https://klaviyo.com',true,true,18000, freeTier:'Free for up to 250 contacts', price:20, priceTier:'Email plan monthly', tips:'Best for Shopify/Magento | Predictive CLV | Advanced segmentations'),
    t('active-campaign-ai','ActiveCampaign','marketing','CXA platform with AI-powered email and CRM automation.','https://activecampaign.com',false,false,12000, freeTier:'14-day free trial', price:29, priceTier:'Lite monthly', tips:'Superior automation builder | CRM for small business | High deliverability'),
    t('convertkit-ai','ConvertKit','marketing','Marketing platform for creators with AI tools for newsletters.','https://convertkit.com',true,false,9600, freeTier:'Free for up to 1000 subs', price:9, priceTier:'Creator monthly', tips:'Best for bloggers and creators | Simple workflows | Built-in landing pages'),
    t('beehiiv-ai','beehiiv','marketing','New-age newsletter platform with AI writing and growth tools.','https://beehiiv.com',true,true,6200, freeTier:'Free up to 2500 subs', price:42, priceTier:'Grow plan monthly', tips:'Fastest growing newsletter tool | AI writing assistant | Superior referral system'),

    // ━━━ BUSINESS & LEGAL (Niche) ━━━
    t('ironclad-ai','Ironclad','legal','Digital contracting platform with AI for legal team automation.','https://ironcladapp.com',false,false,2800, freeTier:'Demo available', price:0, tips:'Fastest contract execution | AI-powered repository | Used by L\'Oreal and Dropbox'),
    t('linklaters-ai','Linklaters CreateiQ','legal','Data-backed contract management platform from global law firm Linklaters.','https://linklaters.com',false,false,1400, freeTier:'Corporate access only', price:0, tips:'Legal-grade AI | High security compliance | Built by top lawyers'),
    t('robin-ai','Robin AI','legal','AI-powered contract editing and review platform for fast legal turnarounds.','https://robinai.co.uk',true,false,2200, freeTier:'Free basic plan', price:0, tips:'Review contracts in seconds | Free legal templates | Used by world\'s top VCs'),
    t('luminance-ai','Luminance','legal','Advanced AI for legal document review and discovery globally.','https://luminance.com',false,false,1800, freeTier:'Demo available', price:0, tips:'AI understands legal concepts | Faster than humans at review | Diligence expert'),
    t('clio-ai','Clio','legal','Cloud-based legal practice management with AI tools for lawyers.','https://clio.com',false,true,5400, freeTier:'7-day free trial', price:39, priceTier:'EasyStart per month', tips:'Manage your entire law firm | Integrated billing | HIPAA and SOC2 compliant'),

    // ━━━ FINANCE & ACCOUNTING (More) ━━━
    t('xero-ai','Xero (Hubdoc)','finance','Cloud accounting software for small business with AI automation.','https://xero.com',false,true,18000, freeTier:'30-day free trial', price:15, priceTier:'Early plan monthly', tips:'Connect with 1000+ apps | Beautiful dashboards | Hubdoc scans invoices automatically'),
    t('quickbooks-ai','QuickBooks Online','finance','Leading accounting software with AI for categorizing transactions.','https://quickbooks.com',false,true,25000, freeTier:'30-day free trial', price:30, priceTier:'Simple Start monthly', tips:'Industry standard for SMBs | Expert tax help built-in | Robust mobile app'),
    t('freshbooks-ai','FreshBooks','finance','Simple invoicing and accounting for freelancers with AI automation.','https://freshbooks.com',false,false,12000, freeTier:'30-day free trial', price:17, priceTier:'Lite monthly', tips:'Best for service-based biz | Easiest invoicing UI | Project time tracking'),
    t('wave-accounting-ai','Wave','finance','Free financial software for small businesses with paid AI services.','https://waveapps.com',true,true,15000, freeTier:'Free forever accounting/invoicing', price:0, tips:'Totally free accounting | Pay for payroll and payments | Great for freelancers'),
    t('bench-ai','Bench','finance','Professional AI-assisted bookkeeping service for small businesses.','https://bench.co',false,false,5600, freeTier:'Free consultation', price:249, priceTier:'Monthly professional bookkeeping', tips:'Real humans + AI | Tax ready financials | Connect with all your banks'),

    // ━━━ CREATIVE (More Niche) ━━━
    t('spline-ai','Spline','design','AI-powered 3D design tool for the web with real-time collaboration.','https://spline.design',true,true,12000, freeTier:'Free forever basic', price:24, priceTier:'Super: extra exports and AI', tips:'Easiest 3D tool for web devs | Export to React/Three.js | AI generates 3D objects'),
    t('vectary-ai','Vectary','design','Online 3D design and AR platform with AI-powered features.','https://vectary.com',true,false,5800, freeTier:'Free starter (limited)', price:15, priceTier:'Pro: unlimited projects and AR', tips:'No-code 3D and AR | Best for product design | Browser-based CAD'),
    t('pika-art-ai','Pika','video','AI video generation platform for high-quality animations and clips.','https://pika.art',true,true,15000, freeTier:'30 free credits daily', price:10, priceTier:'Standard monthly', tips:'Best for cinematic animations | Lip-sync feature | High community engagement'),
    t('kaiber-ai','Kaiber','video','AI video laboratory for creating stunning visual animations and art.','https://kaiber.ai',false,false,8400, freeTier:'7-day free trial', price:15, priceTier:'Explorer plan monthly', tips:'Used by Linkin Park | Unique visual styles | Music-reactive video'),
    t('heygen-ai-more','HeyGen','video','Leading AI video generation for hyper-realistic avatars and translations.','https://heygen.com',true,true,18000, freeTier:'1 free credit for trial', price:24, priceTier:'Creator plan monthly', tips:'Best lip-sync in the market | 100+ AI avatars | Instant video translation'),

    // ━━━ EDUCATION (Specialized) ━━━
    t('khan-academy-khanmigo','Khanmigo','education','AI tutor by Khan Academy that guides students through learning.','https://khanacademy.org',true,true,45000, freeTier:'Khan Academy is free', price:4, priceTier:'Monthly donation for Khanmigo', tips:'Safe for kids | Guides instead of giving answers | Integrated with lessons'),
    t('photomath-ai','Photomath','education','The world\'s most used math learning app with AI step-by-step help.','https://photomath.com',true,true,58000, freeTier:'Free basic solver', price:10, priceTier:'Plus: deep explainers', tips:'Scan any math problem | Animating steps | High accuracy'),
    t('brainly-ai','Brainly','education','Global student community with AI-verified answers for homework.','https://brainly.com',true,false,35000, freeTier:'Free basic access', price:0, tips:'Peer-to-peer help | AI-verified expert answers | Great for high school students'),
    t('quizlet-ai','Quizlet Q-Chat','education','Leading study app with AI tutor and automated flashcards.','https://quizlet.com',true,true,42000, freeTier:'Free basic flashcards', price:3, priceTier:'Plus monthly', tips:'AI generates study sets | Q-Chat tutor | Best for memorization'),
    t('mendeley-ai','Mendeley','education','Reference manager and academic social network with AI research tools.','https://mendeley.com',true,false,15000, freeTier:'Free up to 2GB storage', price:5, priceTier:'Premium: more storage', tips:'Manage all your research papers | Cite while you write | AI-powered search'),

    // ━━━ HEALTH & WELLNESS (Niche) ━━━
    t('oura-ring-ai','Oura','health','Smart ring with AI for tracking recovery, sleep, and heart rate.','https://ouraring.com',false,true,15000, freeTier:'Hardware purchase required', price:6, priceTier:'Monthly membership', tips:'Most accurate sleep tracker | Small and comfortable | Daily readiness score'),
    t('whoop-ai','Whoop','health','Wearable performance coach with AI for strain and recovery tracking.','https://whoop.com',false,true,12000, freeTier:'Free 30-day trial (device included)', price:30, priceTier:'Monthly membership', tips:'Screenless design for athletes | AI coach for workouts | Detailed recovery data'),
    t('clue-ai','Clue','health','Period tracking and reproductive health app with AI-powered cycles.','https://helloclue.com',true,true,18000, freeTier:'Free basic tracking', price:10, priceTier:'Plus monthly', tips:'Science-based data | Privacy-first | Hormone tracking focus'),
    t('flo-ai','Flo','health','Leading period and ovulation tracker with AI health assistant.','https://flo.health',true,true,25000, freeTier:'Free basic tracking', price:15, priceTier:'Premium monthly', tips:'Health expert chats | Personalized health plan | Secret chats for users'),
    t('basis-ai','Basis','health','AI-powered clinical trial platform for mental health treatments.','https://basis.com',false,false,1400, freeTier:'No public product', price:0, tips:'Focused on sleep and wellness | Data-driven clinical studies | Privacy focused'),

    // ━━━ OPEN SOURCE GEMS ━━━
    t('ollama','Ollama','code','Run large language models like Llama 3 and Mistral locally on your machine.','https://ollama.com',true,true,35000, freeTier:'Completely free open source', price:0, tips:'Easiest way to run local AI | CLI and API support | Massive model library'),
    t('stable-diffusion-webui','Automatic1111','design','The most popular interface for running Stable Diffusion locally.','https://github.com/AUTOMATIC1111/stable-diffusion-webui',true,true,45000, freeTier:'Completely free open source', price:0, tips:'Huge plugin ecosystem | Complete control over image generation | Requires good GPU'),
    t('local-ai','LocalAI','code','Complete OpenAI-compatible API for local models running on your hardware.','https://localai.io',true,false,5600, freeTier:'Completely free open source', price:0, tips:'Drop-in replacement for OpenAI | Supports CUDA, Metal | Run on CPU'),
    t('fabric-ai','Fabric','productivity','AI framework for automating your life with modular prompts (patterns).','https://github.com/danielmiessler/fabric',true,true,9200, freeTier:'Completely free open source', price:0, tips:'CLI-first productivity | Extract wisdom from YouTube | Awesome pattern library'),
    t('anything-llm','AnythingLLM','productivity','All-in-one desktop AI for RAG on your local files with privacy.','https://useanything.com',true,true,12000, freeTier:'Completely free open source', price:0, tips:'Best desktop RAG tool | Easy install | Private and secure'),
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
