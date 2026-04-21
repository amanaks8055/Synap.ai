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
    // ━━━ AI FOR HR & RECRUITING v2 ━━━
    t('linkedin-recruiter','LinkedIn Recruiter','business','The gold standard for talent acquisition with AI-powered candidate matching.','https://business.linkedin.com/talent-solutions/recruiter',false,true,500000, freeTier:'Institutional only', price:0, tips:'AI-powered "Spotlights" for fast hiring | Best for executive search | Massive database'),
    t('indeed-ai-employer','Indeed (AI)','business','The world\'s #1 job site using AI for smart matching and candidate screens.','https://indeed.com',true,true,999999, freeTier:'Free to post basic jobs', price:0, tips:'AI-powered "Matched Candidates" | Best for high-volume hiring | Globally trusted'),
    t('glassdoor-ai-pro','Glassdoor','business','Leading career community using AI for company reviews and salary data.','https://glassdoor.com',true,true,500000, freeTier:'Completely free for the public', price:0, tips:'AI-powered "Review" summaries | Best for culture research | Reliable'),
    t('monster-ai-pro','Monster','business','Leading global job board using AI for real-time talent search and data.','https://monster.com',true,true,250000, freeTier:'Free basic search', price:0, tips:'Pioneer in online jobs | AI-powered "Smart Search" | Global reach'),
    t('zip-recruiter-ai','ZipRecruiter','business','Leading marketplace using AI to pitch your resume to the best jobs.','https://ziprecruiter.com',true,true,350000, freeTier:'Free for job seekers', price:0, tips:'AI-powered "Phil" assistant | Best for fast mobile hiring | US leader'),
    t('greenhouse-ai-pro','Greenhouse','business','Leading hiring software for startups and enterprise with AI workflows.','https://greenhouse.io',false,true,120000, freeTier:'Demo available', price:0, tips:'Best for structured interviewing | AI-powered "Reporting" | Pro standard'),
    t('lever-ai-pro-hires','Lever','business','Leading talent acquisition suite using AI for CRM and collaborative hiring.','https://lever.co',false,true,84000, freeTier:'Demo available', price:0, tips:'Acquired by Employ | AI-powered "Nurture" campaigns | Clean and fast'),
    t('workable-ai-pro','Workable','business','Leading all-in-one recruiting software using AI for candidate sourcing.','https://workable.com',true,true,150000, freeTier:'15-day free trial', price:149, priceTier:'Starter monthly', tips:'Best for small/medium business | AI-powered "Auto-Sourcing" | Global focus'),
    t('smart-recruiters-ai','SmartRecruiters','business','Leading enterprise hiring platform with AI-powered internal mobility.','https://smartrecruiters.com',false,true,84000, freeTier:'Institutional only', price:0, tips:'Best for large global firms | AI-powered "Hiring Success" | Robust'),
    t('team-tailor-ai','Teamtailor','business','Leading employer branding and recruiting platform with AI-powered UI.','https://teamtailor.com',false,false,45000, freeTier:'Demo available', price:0, tips:'Best for beautiful career sites | AI-powered "Candidate Experience" | Modern'),

    // ━━━ AI FOR LEGAL & CONTRACTS v2 ━━━
    t('lexis-nexis-ai','Lexis+ (AI)','business','Leading global legal research and intelligence with high-end AI labs.','https://lexisnexis.com',false,true,150000, freeTier:'Institutional only', price:0, tips:'Industry standard for law firms | AI-powered "Brief Analysis" | Massive database'),
    t('westlaw-ai-pro','Westlaw Precision','business','Leading provider of legal research with AI-powered precision search.','https://thomsonreuters.com/westlaw',false,true,120000, freeTier:'Institutional only', price:0, tips:'Owned by Thomson Reuters | AI-powered "KeyCite" | Best for US case law'),
    t('ironclad-ai-pro','Ironclad','business','Leading digital contracting platform with AI-powered repository and data.','https://ironcladapp.com',false,true,58000, freeTier:'Demo available', price:0, tips:'Best for legal ops teams | AI-powered "Insights" | High security'),
    t('docusign-ai-pro','DocuSign (AI)','business','The world\'s #1 e-signature platform with AI-powered CLM and contract lab.','https://docusign.com',true,true,999999, freeTier:'Free to sign documents', price:10, priceTier:'Personal monthly', tips:'AI-powered "Agreement Cloud" | Industry legend | Best for all business'),
    t('hellosign-ai-pro','Dropbox Sign','business','Easy and secure e-signatures with AI-powered templates and tracking.','https://hellosign.com',true,true,350000, freeTier:'3 free signatures per month', price:15, priceTier:'Essentials monthly', tips:'Owned by Dropbox | AI-powered "Forms" builder | Fast and reliable'),
    t('panda-doc-ai-pro','PandaDoc','business','Leading document automation and e-signature with AI-powered sales tools.','https://pandadoc.com',true,true,180000, freeTier:'Free e-sign for everyone', price:19, priceTier:'Essentials monthly per seat', tips:'Best for sales proposals | AI-powered "Content Library" | Clean UI'),
    t('legal-zoom-ai','LegalZoom','business','Leading provider of legal services for small biz using AI and tech.','https://legalzoom.com',true,true,500000, freeTier:'Free initial business plans (pay state fees)', price:0, tips:'Best for starting a company | AI-powered "Compliance" | Most popular'),
    t('rocket-lawyer-ai','Rocket Lawyer','business','Leading digital legal platform using AI for documents and expert law.','https://rocketlawyer.com',true,true,250000, freeTier:'7-day free trial on site', price:39, priceTier:'Monthly membership', tips:'Easy DIY legal docs | AI-powered "Ask a Lawyer" | Worldwide reach'),
    t('clio-ai-law-pro','Clio','business','The world\'s leading cloud-based legal practice management with AI help.','https://clio.com',false,true,84000, freeTier:'Demo available', price:39, priceTier:'Starter monthly per user', tips:'Industry standard for solo/small firms | AI-powered "Duo" | High trust'),
    t('law-pay-ai-pro','LawPay','business','Leading payment solution for legal professionals with AI-powered security.','https://lawpay.com',false,true,45000, freeTier:'Institutional only', price:0, tips:'Compliant with IOLTA | AI-powered "Secure Link" | Trusted by ABA'),

    // ━━━ AI FOR PARENTING & KIDS v2 ━━━
    t('huckleberry-ai-pro','Huckleberry','lifestyle','The #1 baby sleep and development tracker using AI for sleep plans.','https://huckleberrycare.com',true,true,150000, freeTier:'Free basic tracking', price:10, priceTier:'Plus monthly annual', tips:'AI-powered "SweetSpot" for naps | Best for new parents | Data-driven'),
    t('nannya-ai-pro','Nannya','lifestyle','AI-powered parenting coach and assistant for daily rituals and advice.','https://nannya.com',true,false,12000, freeTier:'Free basic version', price:0, tips:'Personalized plans for kids | AI-powered "Tantrum" help | Modern and clean'),
    t('baby-center-ai','BabyCenter','lifestyle','The world\'s most popular pregnancy and parenting app with AI data.','https://babycenter.com',true,true,999999, freeTier:'Completely free to use', price:0, tips:'Track Every week of growth | AI-powered "Community" | Massive database'),
    t('the-bump-ai-pro','The Bump','lifestyle','Leading pregnancy and newborn tracker with AI-powered gift guides.','https://thebump.com',true,true,350000, freeTier:'Completely free for users', price:0, tips:'Best for registry help | AI-powered "Inside the Bump" visuals | Trusted'),
    t('what-to-expect-ai','What to Expect','lifestyle','The iconic pregnancy brand using AI for personalized daily health info.','https://whattoexpect.com',true,true,500000, freeTier:'Completely free to use', price:0, tips:'Home of the famous book | AI-powered "Due Date" calculator | Huge reach'),
    t('glow-ai-parenting','Glow (Baby)','health','Leading cycle and baby tracker with AI-powered health monitoring.','https://glowing.com',true,true,180000, freeTier:'Free basic version', price:10, priceTier:'Premium monthly', tips:'AI-powered "Insights" for growth | Best for fertility and babies | Data-rich'),
    t('flo-ai-parenting','Flo (Health)','health','Leading women’s health platform with AI-powered pregnancy tracking.','https://flo.health',true,true,999999, freeTier:'Free basic version', price:10, priceTier:'Premium monthly', tips:'Most popular period tracker | AI-powered "Health Assistant" | Medical grade'),
    t('clu-ai-health','Clue','health','Leading period tracker using AI/science to predict cycles and health.','https://helloclue.com',true,true,350000, freeTier:'Free basic version', price:10, priceTier:'Plus monthly', tips:'Gender-neutral focus | AI-powered "Birth Control" helper | European tech'),
    t('owlet-ai-monitor','Owlet','lifestyle','Smart baby monitor using AI-powered "Dream" sleep data and oxygen.','https://owletcare.com',false,true,84000, freeTier:'Hardware purchase required', price:0, tips:'AI-powered "Dream Sock" | Best for peace of mind | high precision sensors'),
    t('nanit-ai-camera','Nanit','lifestyle','Leading smart baby camera with AI-powered sleep tracking and breathing.','https://nanit.com',false,true,120000, freeTier:'Hardware and subscription', price:5, priceTier:'Insights monthly', tips:'AI tracks breathing without sensors | Best overhead camera | Award-winning'),

    // ━━━ AI FOR PETS HEALTH v2 ━━━
    t('vets-now-ai-pro','Vets Now','health','Leading UK emergency vet service with AI-powered video consultations.','https://vets-now.com',true,true,45000, freeTier:'Free phone advice often', price:0, tips:'UK leader in pet emergency | AI-powered triage | Reliable and fast'),
    t('pawp-ai-member','Pawp','health','The "Amazon Prime" for pet health with AI-powered 24/7 video vets.','https://pawp.com',false,true,58000, freeTier:'Free to browse', price:19, priceTier:'Monthly membership', tips:'Includes \$3k emergency fund | AI-powered "Consult" | Best for pet peace of mind'),
    t('fuzzy-ai-pet-pro','Fuzzy','health','Digital-first pet health platform with AI-powered telemedicine.','https://yourfuzzy.com',false,false,25000, freeTier:'Free health quiz', price:0, tips:'Customized pet care plans | AI-powered "Rx" delivery | fast growing'),
    t('modern-animal-ai','Modern Animal','health','Leading tech-forward vet clinics with AI-powered app and records.','https://modernanimal.com',false,true,35000, freeTier:'Member only clinics', price:199, priceTier:'Yearly membership', tips:'The "One Medical" for pets | AI-powered health dash | Luxury clinics'),
    t('vet-interactive','FirstVet','health','Leading global video vet service with AI-powered diagnostic help.','https://firstvet.com',true,true,84000, freeTier:'Free coverage via insurance partners', price:20, priceTier:'Start consultation', tips:'Global leader in pet telehealth | AI-powered triage | High trust'),

    // ━━━ FINAL GEMS v19 (Modern Dev Tools) ━━━
    t('vs-code-ai-pro','VS Code (AI)','code','The world\'s #1 code editor with built-in AI (Copilot) and extensions.','https://code.visualstudio.com',true,true,999999, freeTier:'Completely free open source', price:0, tips:'Industry standard | 100k+ extensions | AI-powered everything (via Copilot)'),
    t('cursor-ai-pro-dev','Cursor','code','The world\'s first AI-native code editor that builds software with you.','https://cursor.com',true,true,250000, freeTier:'Free basic version (2k token usage)', price:20, priceTier:'Pro monthly', tips:'Built on VS Code | AI-powered "Global Search" | Best AI coding experience'),
    t('zeta-ai-editor','Zed','code','High-performance code editor built in Rust with built-in AI pairing.','https://zed.dev',true,true,84000, freeTier:'Completely free for personal', price:0, tips:'Blazing fast (60fps) | AI-powered "Assistant" | Best for minimalists'),
    t('replit-ai-ghost','Replit Ghostwriter','code','The world\'s #1 cloud IDE with AI-powered "Ghostwriter" that codes with you.','https://replit.com',true,true,500000, freeTier:'Free for personal starters', price:15, priceTier:'Hacker monthly', tips:'Best for building fast in the browser | AI-powered "Deployment" | Community'),
    t('fleet-ai-pro-dev','JetBrains Fleet','code','The next-gen lightweight IDE from JetBrains with built-in AI help.','https://jetbrains.com/fleet',true,true,120000, freeTier:'Free during preview', price:0, tips:'Cloud or local | AI-powered "Smart Mode" | Modern and sleek UI'),
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
