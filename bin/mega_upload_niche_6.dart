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
    // ━━━ HEALTH (Specific Conditions) ━━━
    t('dexcom-ai-pro','Dexcom','health','Leading continuous glucose monitoring (CGM) with AI-powered alerts and trends.','https://dexcom.com',false,true,150000, freeTier:'Requires hardware and prescription', price:0, tips:'Real-time glucose tracking | AI predicts lows before they happen | Share data with doctors'),
    t('libre-ai-pro','FreeStyle Libre','health','World-leading sensor-based glucose monitoring with AI-powered mobile app.','https://freestyle.abbott',false,true,120000, freeTier:'Hardware purchase required', price:0, tips:'No fingersticks required | AI identifies food impact | Integrated with health apps'),
    t('omnipod-ai-pro','Omnipod DASH','health','Tubeless insulin pump system with AI-powered automated delivery.','https://omnipod.com',false,true,84000, freeTier:'Hardware purchase required', price:0, tips:'Discreet and wearable | AI-powered personal bolus calculator | High degree of freedom'),
    t('kardia-ai-pro','KardiaMobile (AliveCor)','health','The most clinically-validated personal EKG with AI-powered arrhythmia detection.','https://alivecor.com',true,true,58000, freeTier:'Free basic EKG check', price:10, priceTier:'KardiaCare monthly', tips:'Detected AFib and Bradycardia | FDA cleared | AI-powered "Smart Rhythm" reports'),
    t('withings-ai-pro','Withings Health Mate','health','Unified health app for smart scales and watches with AI-powered analysis.','https://withings.com',true,true,120000, freeTier:'Free app for users', price:0, tips:'Industry leading design | AI identifies vascular age | Integrated with Apple Health'),

    // ━━━ EDUCATION (Specific Exams) ━━━
    t('magoosh-ai-pro','Magoosh','education','Affordable and effective test prep for GRE, GMAT, SAT, and ACT with AI.','https://magoosh.com',true,true,150000, freeTier:'Free trial for 7 days', price:25, priceTier:'Avg per month billed annually', tips:'Video lessons for every question | AI-powered score predictor | Targeted practice'),
    t('kaplan-ai-pro','Kaplan','education','The global leader in test prep for MCAT, LSAT, and Bar with AI tutoring.','https://kaptest.com',true,true,120000, freeTier:'Free practice tests', price:100, priceTier:'Detailed package starting', tips:'Proven results | AI-powered "Study Planner" | Official practice materials'),
    t('princeton-review-ai','The Princeton Review','education','Leading test prep and college admission services with AI support.','https://princetonreview.com',true,true,92000, freeTier:'Free practice tools', price:0, tips:'Premium rankings | AI-powered homework help | Ivy league experts'),
    t('khan-academy-sat','Khan Academy (SAT)','education','The official SAT practice partner with AI-powered personalized lessons.','https://khanacademy.org/sat',true,true,250000, freeTier:'Completely free forever', price:0, tips:'Official practice questions | AI-powered progress tracking | Built with College Board'),
    t('varsity-tutors-ai','Varsity Tutors','education','Leading platform for live 1-on-1 online tutoring with AI-powered matching.','https://varsitytutors.com',true,true,84000, freeTier:'Free learning resources', price:50, priceTier:'Avg per hour starting', tips:'Subject experts for everything | AI-powered diagnostic tests | Mobile learning'),

    // ━━━ DESIGN (Style Focus) ━━━
    t('muji-ai-design','MUJI (Design Philosophy)','design','Explore the minimalist and functional design from MUJI with AI curation.','https://muji.com',true,true,120000, freeTier:'Free to browse products', price:0, tips:'Japanese minimalism | Focus on high quality material | AI-powered "No-Brand" search'),
    t('bauhaus-ai-archive','Bauhaus Archive','design','Digital archives of the iconic Bauhaus school with AI-powered search.','https://bauhaus.de',true,true,45000, freeTier:'Completely free public access', price:0, tips:'Learn the roots of modern design | AI-powered visual discovery | Open data focus'),
    t('dribbble-ai-pro','Dribbble','design','The leading destination to find and showcase creative work with AI.','https://dribbble.com',true,true,250000, freeTier:'Free to browse', price:5, priceTier:'Pro: no ads and multi-shots monthly', tips:'Best for UI/UX inspiration | AI-curated "Popular" section | Hiring portal built-in'),
    t('adobe-color-ai','Adobe Color','design','Create and browse color palettes with AI-powered extraction and harmony.','https://color.adobe.com',true,true,180000, freeTier:'Completely free for users', price:0, tips:'Extract colors from images | AI "Accessibility" check | Sync with Creative Cloud'),
    t('canva-magic-ai','Canva (Magic Studio)','design','The all-in-one AI design tool for social media, docs, and more.','https://canva.com',true,true,999999, freeTier:'Free forever basic version', price:13, priceTier:'Pro: magic tools and 더 monthly', tips:'"Magic Media" text-to-image | Best for non-designers | Millions of templates'),

    // ━━━ BUSINESS (Industry Specific) ━━━
    t('procore-ai-pro','Procore','business','The leading construction management software with AI-powered safety and site planning.','https://procore.com',false,true,45000, freeTier:'Demo available', price:0, tips:'Best for large scale projects | AI-powered drawing management | Real-time site data'),
    t('lexisnexis-ai-pro','LexisNexis','business','Leading global provider of legal, regulatory, and business intel with AI.','https://lexisnexis.com',false,true,58000, freeTier:'Institutional only', price:0, tips:'World-class legal database | AI-powered "Context" insights | Trusted by everyone'),
    t('bloomberg-terminal','Bloomberg Terminal','business','The gold standard for real-time financial data and news with AI.','https://bloomberg.com/professional',false,true,180000, freeTier:'Institutional only', price:2000, priceTier:'Monthly per terminal', tips:'The most powerful tool in finance | AI "BloombergGPT" features | Essential for traders'),
    t('mckinsey-ai-insights','McKinsey AI Insights','business','Official research and tools from McKinsey on AI and digital transformation.','https://mckinsey.com',true,true,92000, freeTier:'Completely free research papers', price:0, tips:'Thought leadership on AI | Strategic consulting focus | Global industry data'),
    t('gartner-ai-magic','Gartner (AI Hub)','business','The leading research and advisory company with AI-powered "Magic Quadrants".','https://gartner.com',false,true,84000, freeTier:'Limited access for members', price:0, tips:'Essential for enterprise tech buyers | AI-powered vendor analysis | Top tier strategy'),

    // ━━━ MARKETING (Niche Focus) ━━━
    t('upfluence-ai-pro','Upfluence','marketing','The #1 influencer marketing platform with AI-powered search and CRM.','https://upfluence.com',false,true,18000, freeTier:'Demo available', price:0, tips:'Find influencers by engagement | AI-powered campaign tracking | Shopify integration'),
    t('aspire-ai-pro','Aspire','marketing','Leading influencer marketing platform for high-growth e-commerce brands.','https://aspire.io',false,true,15000, freeTier:'Demo available', price:0, tips:'Best for creative relationships | AI-powered content analysis | Paid media integration'),
    t('grin-ai-pro','GRIN','marketing','The world\'s first creator management platform for e-commerce with AI.','https://grin.co',false,true,12000, freeTier:'Demo available', price:0, tips:'End-to-end creator workflow | AI identifies fake followers | Trusted by top brands'),
    t('hella-retention-ai','Hella Retention','marketing','AI-powered retention platform for e-commerce using predictive analytics.','https://hellaretention.com',false,false,5600, freeTier:'Demo available', price:0, tips:'Predict which users will churn | AI-powered email and SMS | Data-driven growth'),
    t('klaviyo-ai-pro','Klaviyo','marketing','Leading e-commerce marketing automation for email and SMS with AI.','https://klaviyo.com',true,true,120000, freeTier:'Free for up to 250 contacts', price:30, priceTier:'Starter monthly', tips:'Best for Shopify and Magento | AI-powered segmentation | Industry standard'),

    // ━━━ PRODUCTIVITY (Methods GEMS) ━━━
    t('todoist-ai-pro','Todoist','productivity','The world\'s #1 to-do list and task manager app with AI assistant.','https://todoist.com',true,true,250000, freeTier:'Free for up to 5 projects', price:5, priceTier:'Pro monthly', tips:'"AI Filter" assistant | Natural language dates | Best across all devices'),
    t('things-3-ai','Things 3','productivity','The award-winning personal task manager for Apple with AI-like simplicity.','https://culturedcode.com/things',false,true,150000, freeTier:'One-time purchase required', price:10, priceTier:'One-time purchase for iPhone', tips:'The gold standard for task UI | Goal-oriented design | Privacy-first'),
    t('ominifocus-ai-pro','OmniFocus','productivity','The professional task manager for Apple users following the GTD method.','https://omnigroup.com/omnifocus',true,false,45000, freeTier:'14-day free trial', price:10, priceTier:'Subscription monthly', tips:'Best for GTD experts | Powerful forecasting | Integrated with Apple ecosystem'),
    t('taskpapyer-ai','TaskPaper','productivity','Plain text to-do lists for Mac that feel like a real piece of paper.','https://taskpaper.com',true,false,15000, freeTier:'Free trial available', price:25, priceTier:'One-time purchase', tips:'Clean and minimalist | Developer friendly | Built on plain text'),
    t('sunsama-ai-pro','Sunsama','productivity','The daily planner for professionals to stay calm and focused with AI.','https://sunsama.com',false,true,58000, freeTier:'14-day free trial', price:20, priceTier:'Monthly billed annually', tips:'Guided daily planning | AI imports tasks from Jira/Trello | High intentionality'),

    // ━━━ UTILITIES (Specific OS) ━━━
    t('powertoys-ai','Microsoft PowerToys','productivity','A set of utilities for power users to tune and streamline Windows with AI.','https://github.com/microsoft/PowerToys',true,true,150000, freeTier:'Completely free open source', price:0, tips:'A better "Alt-Tab" and color picker | AI-powered text extractor | Official Microsoft project'),
    t('raycast-ai-pro','Raycast','productivity','A blazingly fast, extendable launcher for Mac with AI built-in.','https://raycast.com',true,true,120000, freeTier:'Free for personal use', price:8, priceTier:'Pro: AI and 더 monthly', tips:'Replaces Spotlight | Thousands of community extensions | Best tool for Mac power users'),
    t('alfred-ai-pro','Alfred','productivity','The award-winning app for Mac that boosts efficiency with hotkeys and AI.','https://alfredapp.com',true,true,84000, freeTier:'Free basic version', price:34, priceTier:'Single license one-time', tips:'Powerful workflows | AI-powered search | Long-standing community favorite'),
    t('brew-sh-ai','Homebrew','code','The missing package manager for macOS (and Linux) with AI-powered search.','https://brew.sh',true,true,250000, freeTier:'Completely free open source', price:0, tips:'The mac developer standard | Install thousands of tools with CLI | Community driven'),
    t('chocolatey-ai-pro','Chocolatey','code','The package manager for Windows that automates software management.','https://chocolatey.org',true,true,58000, freeTier:'Free for individual use', price:0, tips:'Best for Windows automation | One command install for 10k+ apps | Trusted by NASA'),

    // ━━━ LIFESTYLE (Hobbies GEMS) ━━━
    t('chess-com-ai','Chess.com','entertainment','The world\'s #1 chess site with AI-powered analysis and bots.','https://chess.com',true,true,999999, freeTier:'Free basic version with ads', price:8, priceTier:'Gold monthly', tips:'Learn with AI-powered "Game Review" | Play against 300+ AI bot personalities | Huge community'),
    t('lichess-ai-pro','Lichess','entertainment','The free and open-source chess server for everyone, with AI.','https://lichess.org',true,true,250000, freeTier:'Completely free forever no ads', price:0, tips:'Best for privacy and purists | AI-powered Stockfish analysis | Community supported'),
    t('origami-ai-pro','Origami.me','entertainment','Explore the art of paper folding with AI-powered instructions and tips.','https://origami.me',true,false,15000, freeTier:'Free instructions online', price:0, tips:'Beautiful models from beginners to pros | AI-powered project finder'),
    t('all-recipes-pro','Allrecipes (Pro)','food','Leading recipe site with AI-powered substitutions and cooking tips.','https://allrecipes.com',true,true,250000, freeTier:'Completely free version', price:0, tips:'User-reviewed recipes | AI-powered meal planner | Community favorite'),
    t('duolingo-math-pro','Duolingo Math','education','Learn math through fast-paced, bitesized lessons with AI.','https://duolingo.com/math',true,true,150000, freeTier:'Completely free forever', price:0, tips:'Same fun mechanics as language | AI-powered difficulty adaptation | Best for kids'),

    // ━━━ SCIENCE (Deep Tech Focus) ━━━
    t('nasa-ai-pro','NASA (AI/ML)','science','Explore NASA\'s official research and data on AI and machine learning.','https://nasa.gov',true,true,250000, freeTier:'Completely free public data', price:0, tips:'AI for space exploration | Open data access | World class research'),
    t('esa-ai-pro','ESA (European Space Agency)','science','Official space agency of Europe with AI for earth observation.','https://esa.int',true,true,120000, freeTier:'Completely free public data', price:0, tips:'Monitor environmental changes | AI-powered science missions | Global collaboration'),
    t('noaa-ai-pro','NOAA (Weather/Climate)','science','The official US source for weather, climate, and ocean data with AI.','https://noaa.gov',true,true,150000, freeTier:'Completely free public data', price:0, tips:'Most accurate climate data | AI-powered hurricane forecasts | Global sensor network'),
    t('oceana-ai-pro','Oceana','science','Protecting the world\'s oceans with AI-powered tracking and data.','https://oceana.org',true,true,45000, freeTier:'Free to browse', price:0, tips:'Identify illegal labels | Support marine life | AI-powered reports'),
    t('greenpeace-ai-pro','Greenpeace','science','Global environmental organization using AI for tracking deforestation.','https://greenpeace.org',true,true,58000, freeTier:'Free to join and browse', price:0, tips:'Investigate environmental crimes | AI-powered satellite monitoring | Global presence'),

    // ━━━ GOVERNMENT (Regional Focus) ━━━
    t('gov-uk-ai','GOV.UK','business','The official website for all UK government services and information.','https://gov.uk',true,true,250000, freeTier:'Completely free forever', price:0, tips:'Best government UI in the world | AI-powered help and search | Unified portal'),
    t('europa-eu-ai','Europa (EU)','business','The official website of the European Union with AI-powered law search.','https://europa.eu',true,true,180000, freeTier:'Completely free public info', price:0, tips:'Access all EU member data | AI for regulatory compliance | Multilingual'),
    t('india-gov-in-ai','India.gov.in','business','The national portal of India for all government services with AI.','https://india.gov.in',true,true,250000, freeTier:'Completely free forever', price:0, tips:'One portal for 1.4B people | AI-powered digital India services | Mobile ready'),
    t('australia-gov-au','Australia.gov.au','business','Your direct link to all Australian government info and services.','https://australia.gov.au',true,true,120000, freeTier:'Completely free forever', price:0, tips:'Simple and fast | AI-powered help for citizens | Official primary source'),
    t('service-canada-ai','Service Canada','business','Access Canada\'s programs and services for citizens with AI help.','https://canada.ca',true,true,150000, freeTier:'Completely free for users', price:0, tips:'Bilingual support | AI-powered benefit finder | Secure digital identity'),
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
