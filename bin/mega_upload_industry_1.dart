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
    // ━━━ SMALL BUSINESS & ACCOUNTING AI ━━━
    t('quickbooks-ai-pro','QuickBooks AI','finance','Leading accounting software for small businesses with AI-powered bookkeeping.','https://quickbooks.intuit.com',true,true,250000, freeTier:'30-day free trial', price:30, priceTier:'Simple Start monthly', tips:'AI automates transaction categorization | AI-powered tax forecasting | Integrated payroll'),
    t('xero-ai-pro','Xero','finance','Beautiful accounting software for small business with AI-powered bank reconciliation.','https://xero.com',true,true,180000, freeTier:'30-day free trial', price:15, priceTier:'Early plan monthly', tips:'Best for collaboration with accountants | AI-powered "Hubdoc" for receipts | 1000+ apps'),
    t('wave-accounting-ai','Wave','finance','Completely free, high-quality accounting and invoicing for small businesses.','https://waveapps.com',true,true,150000, freeTier:'Accounting and invoicing are free', price:0, tips:'AI-powered receipt scanning | Pay-per-use payments and payroll | Best for freelancers'),
    t('freshbooks-ai-pro','FreshBooks','finance','Easy-to-use invoicing and accounting for small teams with AI tracking.','https://freshbooks.com',true,true,120000, freeTier:'Free trial for 30 days', price:17, priceTier:'Lite monthly', tips:'Most intuitive UI | AI-powered project time tracking | Automated late payment reminders'),
    t('bench-accounting-ai','Bench','finance','Professional bookkeeping service with an AI-powered platform and experts.','https://bench.co',false,true,45000, freeTier:'Free trial available', price:249, priceTier:'Monthly billed annually', tips:'Actually includes a real bookkeeper | AI extracts data from every receipt | Tax ready'),
    t('pilot-accounting-ai','Pilot','finance','Back-office for startups with AI-powered bookkeeping, tax, and CFO services.','https://pilot.com',false,true,15000, freeTier:'Demo available', price:499, priceTier:'Core plan monthly', tips:'Best for high-growth tech startups | AI-powered accuracy | Specialized tax guidance'),
    t('zola-ai-wedding','Zola','business','The easiest way to plan your wedding with AI-powered registry and site.','https://zola.com',true,true,120000, freeTier:'Completely free to join', price:0, tips:'AI-powered guest list manager | Integrated registry | Free wedding websites'),
    t('the-knot-ai-plan','The Knot','business','The world\'s #1 wedding planning site with AI-powered vendor matching.','https://theknot.com',true,true,150000, freeTier:'Completely free for couples', price:0, tips:'Largest vendor database | AI-powered budgeter | Great for inspiration'),
    t('expensify-ai','Expensify','finance','AI-powered expense management platform that makes bookkeeping easy.','https://expensify.com',true,true,84000, freeTier:'Free for personal/small teams (limited)', price:5, priceTier:'Collect per user monthly', tips:'AI "SmartScan" for receipts | Corporate card with high cash back | Easy reimbursements'),
    t('bill-com-ai','BILL','finance','The leading platform for automated accounts payable and receivable with AI.','https://bill.com',false,true,58000, freeTier:'Free trial available', price:45, priceTier:'Essentials monthly', tips:'AI-powered bill capture | Sync with all accounting software | Enterprise grade'),

    // ━━━ HR, HIRING & TALENT AI ━━━
    t('gusta-ai-pro','Gusto','business','The modern HR and payroll platform with AI-powered compliance and benefits.','https://gusto.com',false,true,150000, freeTier:'Free trial available', price:40, priceTier:'Simple base monthly', tips:'Extremely easy to use | AI-powered tax filing | Integrated hiring tools'),
    t('rippling-ai-pro','Rippling','business','Unify your HR, IT, and Finance on one platform with AI automation.','https://rippling.com',false,true,58000, freeTier:'30-day free trial', price:8, priceTier:'Per user monthly', tips:'Automate employee onboarding in 90 seconds | AI handles global compliance | All-in-one'),
    t('bamboo-hr-ai','BambooHR','business','The complete HR software for small and medium businesses with AI insights.','https://bamboohr.com',false,true,84000, freeTier:'Demo available', price:0, tips:'Best for company culture | AI-powered performance management | Great mobile app'),
    t('greenhouse-ai-rec','Greenhouse','business','Leading hiring software for high-growth teams with AI interview tools.','https://greenhouse.com',false,true,45000, freeTier:'Institutional only', price:0, tips:'Eliminate bias with AI | Detailed hiring analytics | Top tier candidate experience'),
    t('lever-ai-rec','Lever','business','The modern applicant tracking system with AI-powered sourcing and CRM.','https://lever.co',false,true,35000, freeTier:'Demo available', price:0, tips:'Best for technical hiring | AI-powered candidate nurturing | Integrated with LinkedIn'),
    t('hibob-ai-pro','HiBob','business','Modern HR platform for the global workplace with AI-powered engagement.','https://hibob.com',false,true,28000, freeTier:'Demo available', price:0, tips:'Focus on employee experience | AI-powered social feed | Great for remote teams'),
    t('checkr-ai-pro','Checkr','business','The most advanced background check platform powered by AI.','https://checkr.com',false,true,120000, freeTier:'Demo available', price:29, priceTier:'Avg per check starting', tips:'AI-powered "Fair Future" checks | Fastest turnaround in the industry | API for devs'),
    t('lattice-ai-pro','Lattice','business','Success platform for employees using AI for reviews and surveys.','https://lattice.com',false,true,45000, freeTier:'Demo available', price:4, priceTier:'Performance per user monthly', tips:'Connect goals to performance | AI-powered engagement surveys | Used by Reddit and Slack'),
    t('workday-ai-pro','Workday','business','Enterprise cloud-based software for HR and finance with AI at the core.','https://workday.com',false,true,250000, freeTier:'Institutional only', price:0, tips:'Industry standard for large corps | AI for workforce planning | Robust security'),
    t('paylocity-ai','Paylocity','business','Cloud-based HR and payroll for the modern workforce with AI.','https://paylocity.com',false,false,56000, freeTier:'Demo available', price:0, tips:'Best for deskless workers | AI-powered engagement | Integrated benefits'),

    // ━━━ FASHION & BEAUTY AI ━━━
    t('modiface-ai','ModiFace (L\'Oréal)','fashion','Leading platform for AR and AI-powered virtual try-on for beauty.','https://modiface.com',true,true,58000, freeTier:'Free consumer tools on brand sites', price:0, tips:'Virtual makeup try-on | AI-powered skin analysis | Used by top beauty brands'),
    t('perfect-corp-ai','Perfect Corp (YouCam)','fashion','The world\'s leading AR-powered beauty and fashion tech platform with AI.','https://perfectcorp.com',true,true,150000, freeTier:'Free YouCam app basic version', price:0, tips:'AR jewelry and glasses try-on | AI skin diagnostic | Enterprise leader'),
    t('fit-analytics-ai','Fit Analytics','fashion','Leading size and fit platform for e-commerce using AI for recommendations.','https://fitanalytics.com',true,true,45000, freeTier:'Consumer tool on sites like Nike', price:0, tips:'Acquired by Snap Inc | Find your perfect size with AI | Reduced returns for brands'),
    t('styletics-ai','Stylect','fashion','Explore and discover your perfect shoes with AI-powered preference matching.','https://stylect.com',true,false,15000, freeTier:'Completely free to use', price:0, tips:'Tinder for shoes | AI learns your style | Discovery-first experience'),
    t('fashion-cloud-ai','Fashion Cloud','fashion','The leading wholesale platform for the fashion industry with AI search.','https://fashion.cloud',false,true,12000, freeTier:'Demo available', price:0, tips:'B2B platform for retailers | AI-powered inventory planning | European leader'),
    t('glamsquad-ai','GLAMSQUAD','fashion','On-demand beauty services at your door with AI-powered pro matching.','https://glamsquad.com',true,true,58000, freeTier:'Free app for users', price:0, tips:'Book makeup and hair in seconds | AI-powered quality control | Professional pros'),
    t('zeekit-ai-pro','Zeekit (Walmart)','fashion','Virtual dressing room for e-commerce powered by high-end AI.','https://zeekit.me',true,false,12000, freeTier:'Integrated in Walmart site/app', price:0, tips:'Acquired by Walmart | Try on clothes on any body type | AI mapping tech'),
    t('lookiero-ai','Lookiero','fashion','Leading personal shopping service for women in Europe with AI.','https://lookiero.com',true,true,45000, freeTier:'Free style profile', price:10, priceTier:'Styling fee (credited back)', tips:'European version of Stitch Fix | AI learns your fit | Home try-on focus'),
    t('virtoo-ai','Virtoo','fashion','AI platform for creating virtual fashion models and clothing simulations.','https://virtoo.ai',false,false,5600, freeTier:'Institutional only', price:0, tips:'Best for fashion designers | AI-powered physics for cloth | Digital humans'),
    t('cloosiv-ai','Cloosiv','fashion','AI-powered platform for discovering and ordering from local coffee shops.','https://cloosiv.com',true,false,8400, freeTier:'Free app for users', price:0, tips:'Reward based local search | AI-powered morning routines | Support small biz'),

    // ━━━ RETAIL & HOSPITALITY AI ━━━
    t('opentable-ai-pro','OpenTable','business','The world\'s most popular restaurant booking platform with AI discovery.','https://opentable.com',true,true,250000, freeTier:'Completely free for diners', price:0, tips:'Earn points for every booking | AI-powered recommendations | Verified reviews'),
    t('resy-ai-pro','Resy','business','Premium restaurant reservation platform with AI-powered notifications.','https://resy.com',true,true,180000, freeTier:'Free for diners', price:0, tips:'Owned by American Express | Access to exclusive tables | AI notify list'),
    t('yelp-ai-pro','Yelp','business','The leading platform for finding local businesses with AI-powered search.','https://yelp.com',true,true,999999, freeTier:'Completely free to use', price:0, tips:'Verified user reviews | AI-powered "Highlights" | Book appointments in app'),
    t('trip-advisor-ai','Tripadvisor','travel','The world\'s largest travel guidance platform with AI-powered summaries.','https://tripadvisor.com',true,true,999999, freeTier:'Completely free to use', price:0, tips:'AI-powered review summaries | Huge global community | Book tours and hotels'),
    t('foursquare-ai-pro','Foursquare','travel','The leader in global location data and smart local discovery with AI.','https://foursquare.com',true,true,150000, freeTier:'Free for personal search app', price:0, tips:'Best location intelligence | AI-powered "CityGuide" | Huge developer API'),
    t('marriott-bonvoy-ai','Marriott Bonvoy','travel','World-class hospitality app with AI-powered mobile keys and chat.','https://marriott.com',true,true,250000, freeTier:'Free to join', price:0, tips:'Manage bookings across 30+ brands | AI-powered mobile check-in | Loyalty focus'),
    t('hilton-honors-ai','Hilton Honors','travel','Leading travel app with AI-powered room selection and digital check-in.','https://hilton.com',true,true,250000, freeTier:'Free to join', price:0, tips:'Select your exact room from a map | AI digital keys | Global scale'),
    t('expedia-ai-pro','Expedia','travel','Leading global travel app with AI-powered "Price Tracking" and search.','https://expedia.com',true,true,500000, freeTier:'Free to browse', price:0, tips:'One-stop shop for flights+hotels | AI-powered trip advisor | Robust loyalty'),
    t('kayak-ai-pro','KAYAK','travel','Smart travel search engine with AI-powered "Hacker Fares" and alerts.','https://kayak.com',true,true,180000, freeTier:'Completely free to use', price:0, tips:'Best for finding cheap flights | AI-powered price predictor | Simple UI'),
    t('skyscanner-ai-pro','Skyscanner','travel','The global travel search engine with AI-powered "Everywhere" search.','https://skyscanner.net',true,true,150000, freeTier:'Completely free to use', price:0, tips:'Find the cheapest month to fly | No hidden fees | Trusted worldwide'),

    // ━━━ AUTOMOTIVE & TRANSPORT AI ━━━
    t('tesla-fsd-ai','Tesla FSD','automotive','Leading full self-driving technology powered by vision and AI.','https://tesla.com',false,true,500000, freeTier:'Hardware required with car', price:99, priceTier:'Subscription monthly starting', tips:'Fully autonomous capability | AI-powered vision system | Most data in the field'),
    t('comma-ai-pro','comma.ai','automotive','Make any car smarter with an AI-powered dashcam and lane keeping.','https://comma.ai',false,true,12000, freeTier:'Open source software (Openpilot)', price:599, priceTier:'Hardware one-time', tips:'Self-driving for your current car | Open source community | AI-powered safety'),
    t('samsara-ai-pro','Samsara','business','Leading industrial IoT platform with AI for fleet and site management.','https://samsara.com',false,true,45000, freeTier:'Demo available', price:0, tips:'AI-powered dash cams for safety | Real-time fleet tracking | Industrial safety leader'),
    t('motive-ai-pro','Motive (KeepTruckin)','business','Modern fleet management and safety platform with AI driver coaching.','https://gomotive.com',false,true,35000, freeTier:'Demo available', price:0, tips:'Reduce accidents with AI | Integrated HOS and GPS | Best for trucking devs'),
    t('verizon-connect-ai','Verizon Connect','business','Leading fleet tracking and management software with AI analytics.','https://verizonconnect.com',false,false,25000, freeTier:'Demo available', price:0, tips:'Massive enterprise scale | AI-powered field service management | Robust reporting'),
    t('geotab-ai-pro','Geotab','business','The world\'s largest telematics platform using AI for data intelligence.','https://geotab.com',false,false,18000, freeTier:'Open API for developers', price:0, tips:'Massive dataset for AI models | Best for sustainable fleet tracking | Leading IoT'),
    t('lytx-ai-pro','Lytx','business','Leading video telematics and fleet safety solutions with AI coaching.','https://lytx.com',false,false,15000, freeTier:'Demo available', price:0, tips:'Machine vision for driver safety | AI identifies risk | Trusted by FedEx'),
    t('rimac-ai-pro','Rimac Technology','automotive','High-performance electric powertrain and AI systems for hypercars.','https://rimac-technology.com',false,true,8400, freeTier:'Hardware and car required', price:0, tips:'Fastest accelerating car technologies | AI-powered torque vectoring | Engineering leader'),
    t('rivian-ai-pro','Rivian','automotive','Electric adventure vehicles with AI-powered terrain and driver modes.','https://rivian.com',false,true,120000, freeTier:'Hardware and car required', price:0, tips:'Best electric outdoor vehicle | AI-powered "Gear Guard" | Highway assist'),
    t('lucid-ai-pro','Lucid Motors','automotive','Luxury electric cars with AI-powered "DreamDrive" driver assistance.','https://lucidmotors.com',false,true,58000, freeTier:'Hardware and car required', price:0, tips:'Leading range and efficiency | AI-powered sensor suite | High end luxury'),

    // ━━━ MISC INDUSTRY GEMS ━━━
    t('autodesk-fusion-ai','Autodesk Fusion 360','design','Integrated CAD/CAM/CAE tool with AI-powered generative design.','https://autodesk.com/fusion-360',true,true,150000, freeTier:'Free for students/personal hobbyist', price:60, priceTier:'Monthly subscription', tips:'Architectural and industrial modeling | AI finds the strongest part design | Best for 3D printing'),
    t('ansys-ai-pro','Ansys','science','Leading engineering simulation software using AI for physics-based models.','https://ansys.com',false,true,45000, freeTier:'Free student version', price:0, tips:'Simulate everything from cars to rockets | AI-powered "Ansys GPT" | Engineering gold standard'),
    t('altair-ai-pro','Altair','science','Global leader in computational logic and AI for engineering simulation.','https://altair.com',false,true,18000, freeTier:'Demo available', price:0, tips:'AI-powered design optimization | High-end aerospace and automotive data | Robust platform'),
    t('bentley-ai-pro','Bentley Systems','science','Software for digital twins and infrastructure engineering with AI.','https://bentley.com',false,false,15000, freeTier:'Institutional only', price:0, tips:'AI-powered asset health monitoring | Best for bridges and roads | Digital twins leader'),
    t('trimble-ai-pro','Trimble','business','Industrial technology for construction, geospace, and agriculture with AI.','https://trimble.com',false,true,45000, freeTier:'Demo available', price:0, tips:'AI-powered autonomous tractors | Construction site automation | High precision GPS'),
    t('john-deere-ai','John Deere (Digital)','business','Autonomous tractors and AI-powered smart farming technologies.','https://deere.com',false,true,58000, freeTier:'Hardware required', price:0, tips:'"See & Spray" AI technology | Reduce chemical use by 80% | Leading smart ag'),
    t('komatsu-ai-pro','Komatsu (Digital)','business','Autonomous mining trucks and smart construction systems using AI.','https://komatsu.com',false,false,12000, freeTier:'Institutional only', price:0, tips:'Self-driving 300 ton trucks | AI-powered site management | Industrial power'),
    t('caterpillar-ai','Caterpillar (Digital)','business','Construction and mining equipment with AI-powered diagnostics and autonomy.','https://cat.com',false,true,45000, freeTier:'Institutional only', price:0, tips:'AI-powered predictive maintenance | Global presence | World class heavy machinery'),
    t('siemens-ai-pro','Siemens (Digital Industries)','business','Leading industrial software for smart factories and automation with AI.','https://siemens.com',false,true,180000, freeTier:'Institutional only', price:0, tips:'The backbone of global manufacturing | AI-powered automation | Digital transformation leader'),
    t('abb-ai-pro','ABB (Robotics)','business','Leading global robotics and industrial automation company with AI.','https://abb.com',false,true,120000, freeTier:'Institutional only', price:0, tips:'AI-powered collaborative robots (YuMi) | Energy efficiency leader | High precision'),
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
