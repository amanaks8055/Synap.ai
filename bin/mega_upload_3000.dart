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
    // ━━━ AI FOR FOOD, DRINK & COOKING ━━━
    t('yummly-ai-pro','Yummly','lifestyle','Personalized recipe recommendations and smart meal planning with AI.','https://yummly.com',true,true,500000, freeTier:'Free basic app for users', price:5, priceTier:'Pro monthly', tips:'AI learns your tastes and allergies | Integration with smart ovens | Easy meal prep'),
    t('tasty-ai-app','Tasty (BuzzFeed)','lifestyle','Leading food and recipe platform with AI-powered discovery and tips.','https://tasty.co',true,true,999999, freeTier:'Completely free to use', price:0, tips:'Fastest growing food brand | AI-powered "What\'s in my fridge" | High engagement'),
    t('super-cook-ai','SuperCook','lifestyle','Find recipes based on the ingredients you already have with AI search.','https://supercook.com',true,true,250000, freeTier:'Completely free for everyone', price:0, tips:'No-waste cooking with AI | Add over 2000 ingredients | Best for casual cooks'),
    t('vivino-ai-pro','Vivino','lifestyle','The world\'s largest wine marketplace with AI-powered visual label search.','https://vivino.com',true,true,500000, freeTier:'Completely free for users', price:0, tips:'Identify any wine with a photo | AI-powered "Match for You" | Verified reviews'),
    t('delectable-ai','Delectable','lifestyle','High-end wine tracking and discovery app with AI-powered label scan.','https://delectable.com',true,false,45000, freeTier:'Free basic version', price:0, tips:'Best for wine collectors | AI-powered expert reviews | Clean design'),
    t('untappd-ai-pro','Untappd','lifestyle','The leading social network for beer fans with AI-powered recommendations.','https://untappd.com',true,true,350000, freeTier:'Completely free to use', price:0, tips:'Find local craft beer with AI | Earn badges for check-ins | Huge community'),
    t('distiller-ai-pro','Distiller','lifestyle','The expert companion for whiskey, rum, and spirits with AI data.','https://distiller.com',true,false,84000, freeTier:'Free basic version', price:5, priceTier:'Pro monthly', tips:'Find the perfect bottle with AI | verified expert ratings | Discovery first'),
    t('mixel-ai-app','Mixel','lifestyle','Modern cocktail recipe app with AI-powered liquor cabinet tracking.','https://mixel.app',true,false,25000, freeTier:'Free basic recipes', price:0, tips:'Best drink visuals | AI-powered cocktail suggestions | Support small biz'),
    t('drizly-ai-pro','Drizly (Uber)','lifestyle','Leading alcohol delivery platform with AI-powered "Fast" pairing.','https://drizly.com',true,true,180000, freeTier:'Free app for users', price:0, tips:'Acquired by Uber | Best for last-minute parties | AI identifies best prices'),
    t('minibar-ai-delivery','Minibar Delivery','lifestyle','On-demand alcohol and party supply delivery with AI-powered help.','https://minibardelivery.com',true,true,84000, freeTier:'Free app for users', price:0, tips:'Professional gift service | AI-powered "Bartender" help | High reliability'),

    // ━━━ AI FOR MENTAL HEALTH & PSYCHOLOGY v2 ━━━
    t('woebot-pro-health','Woebot Health','health','The most clinically-validated AI mental health ally for enterprise.','https://woebothealth.com',false,true,35000, freeTier:'Institutional only', price:0, tips:'FDA breakthrough status | AI-powered CBT for everyone | Scaling care'),
    t('ginger-ai-pro','Ginger (Headspace)','health','Mental health support on demand with AI and live coaches.','https://ginger.com',false,true,58000, freeTier:'7-day free trial on site', price:0, tips:'Merged with Headspace | AI-powered triage to the right care | Best for workers'),
    t('lyra-health-ai','Lyra Health','health','Leading employee mental health platform using AI for matching and data.','https://lyrahealth.com',false,true,45000, freeTier:'Employer sponsored only', price:0, tips:'Best for tech giants | AI-powered "Provider" matching | Evidence-based care'),
    t('modern-health-ai','Modern Health','health','Global mental health platform using AI for personalized wellness plans.','https://modernhealth.com',false,true,35000, freeTier:'Employer sponsored only', price:0, tips:'Unified platform for therapy and coaching | AI-powered "Path" | Global scale'),
    t('octave-ai-health','Octave','health','High-quality behavioral health platform using AI for better outcomes.','https://octavehealth.com',false,false,15000, freeTier:'Free to browse providers', price:0, tips:'Insurance-friendly therapy | AI-powered progress tracking | Modern clinics'),
    t('spring-health-ai','Spring Health','health','Precision mental health platform using AI to find the right care fast.','https://springhealth.com',false,true,28000, freeTier:'Employer sponsored only', price:0, tips:'AI-powered "Clinical" data | high success rates | Robust enterprise support'),
    t('talkspace-ai-pro','Talkspace','health','The world\'s most famous therapy app with AI-powered matching and chat.','https://talkspace.com',true,true,250000, freeTier:'Free consultation and assessment', price:69, priceTier:'Weekly starting', tips:'Therapy via text/video | AI-powered "Assessment" | Most convenient'),
    t('better-help-ai','BetterHelp','health','The world\'s largest therapy platform using AI to match you with experts.','https://betterhelp.com',true,true,500000, freeTier:'Financial aid available', price:60, priceTier:'Weekly starting', tips:'Massive network of 30k+ therapists | AI-powered matching | Secure and safe'),
    t('7-cups-ai-support','7 Cups','health','The world\'s largest emotional support network with AI and listeners.','https://7cups.com',true,true,180000, freeTier:'Completely free listener support', price:15, priceTier:'Therapy monthly starting', tips:'Best for casual peer support | AI-powered "Active Listener" bot | Global'),
    t('sanvello-ai-pro','Sanvello','health','Leading app for stress and anxiety using AI and clinically proven tools.','https://sanvello.com',true,true,120000, freeTier:'Free basic version', price:9, priceTier:'Premium monthly', tips:'Best for self-care | AI-powered mood tracking | Covered by many insurance'),

    // ━━━ AI FOR PHILOSOPHY & ETHICS ━━━
    t('ethics-ai-center','Center for AI Safety','science','Non-profit research lab using AI and philosophy to reduce global risks.','https://safe.ai',true,true,15000, freeTier:'Completely free public research', price:0, tips:'Leading in AI safety research | Academic focus | Non-profit and independent'),
    t('miri-ai-research','MIRI (Machine Intelligence)','science','The pioneer in AI safety research using logic and math for ethics.','https://intelligence.org',true,true,12000, freeTier:'Completely free public data', price:0, tips:'Longest running safety lab | Deeply philosophical | Non-profit'),
    t('future-of-life-ai','Future of Life Institute','science','Leading non-profit using AI and ethic to ensure tech benefits life.','https://futureoflife.org',true,true,35000, freeTier:'Completely free for the public', price:0, tips:'Leading in policy and ethics | Backed by Elon Musk | High impact insights'),
    t('human-compatible-ai','CHAI (Berkeley)','science','UC Berkeley lab using AI to build systems that are human-aligned and safe.','https://humancompatible.ai',true,false,9200, freeTier:'Public academic research', price:0, tips:'Led by Stuart Russell | World class safety research | Academic gold standard'),
    t('partnership-ai-pro','Partnership on AI','business','Global non-profit that brings together tech giants for ethical AI.','https://partnershiponai.org',true,false,5600, freeTier:'Completely free public info', price:0, tips:'Industry-led ethics | Focus on fairness and bias | Multi-stakeholder'),
    t('ada-lovelace-ai','Ada Lovelace Institute','science','Independent research institute ensuring data and AI work for people.','https://adalovelaceinstitute.org',true,false,4200, freeTier:'Completely free public research', price:0, tips:'UK based and high impact | Focus on justice and ethics | Non-profit'),
    t('ethical-ai-gov','OECD.AI','business','The global policy hub for AI ethics and national strategies.','https://oecd.ai',true,false,5600, freeTier:'Completely free public data', price:0, tips:'Track global AI policy in real-time | Strategic and high-level | Most trusted'),
    t('un-ai-ethics-pro','UNESCO AI Ethics','business','The UN agency leading the global recommendation on AI ethics.','https://unesco.org/en/artificial-intelligence',true,false,8400, freeTier:'Completely free public data', price:0, tips:'Global south focus | Cultural preservation in AI | Diplomatic leader'),
    t('ai-ethics-lab','AI Ethics Lab','science','Strategic consulting and research lab using philosophy for better AI.','https://aiethicslab.com',false,false,3500, freeTier:'Demo available', price:0, tips:'First consultancy for AI ethics | Scientific and rigorous | Non-profit roots'),
    t('data-ethics-pro','Data Ethics (Denmark)','business','Leading European non-profit for human-centric data and AI policies.','https://dataethics.eu',true,false,2800, freeTier:'Completely free for the public', price:0, tips:'European values in AI | Strategic and high impact | Trusted by EU'),

    // ━━━ AI FOR HOBBIES & CRAFTS v2 ━━━
    t('instructables-ai','Instructables (Autodesk)','lifestyle','The world\'s largest DIY community using AI to categorize every project.','https://instructables.com',true,true,500000, freeTier:'Completely free for everyone', price:0, tips:'Find how to build anything | AI-powered "Magic" search | Huge community'),
    t('ravelry-ai-knitting','Ravelry','lifestyle','The world\'s largest community for knitting and crochet with AI data.','https://ravelry.com',true,true,250000, freeTier:'Completely free to use', price:0, tips:'Largest yarn and pattern database | AI-powered search | Best for crafters'),
    t('sew-ist-ai-pro','Sewist','lifestyle','AI-powered pattern generator for custom sewing and fashion design.','https://sewist.com',true,false,15000, freeTier:'Free basic pattern editor', price:20, priceTier:'Premium per pattern starting', tips:'Create your own fashion with AI | High precision measurements | Unique'),
    t('craftsy-ai-pro','Craftsy','lifestyle','Learn any craft from experts with AI-powered course paths and help.','https://craftsy.com',true,true,84000, freeTier:'Free projects available', price:8, priceTier:'Monthly billed annually', tips:'Best for serious hobbyists | AI-powered "My Craft" tracker | High quality'),
    t('houzz-ai-design','Houzz (Pro)','design','Leading home remodeling and design platform with AI-powered 3D tools.','https://houzz.com',true,true,500000, freeTier:'Free app for users', price:0, tips:'AI "Visual Match" for furniture | 3D room planner | professional network'),
    t('pinterest-ai-pro','Pinterest','design','The world\'s visual discovery engine with AI-powered "Visual Search".','https://pinterest.com',true,true,999999, freeTier:'Completely free to use', price:0, tips:'AI-powered "Shop the Look" | Best for inspiration | billions of pins'),
    t('shutterfly-ai-pro','Shutterfly','lifestyle','Leading platform for custom photos and gifts with AI-powered auto-layout.','https://shutterfly.com',true,true,150000, freeTier:'Free to join and browse', price:0, tips:'AI-powered "Magic" photo books | Best price for prints | Secure and safe'),
    t('canva-print-ai','Canva Print','lifestyle','Design and print professional products with AI-powered quality check.','https://canva.com/print',true,true,250000, freeTier:'Completely free to design', price:0, tips:'High quality printing | AI-powered "Layout" check | Free global shipping'),
    t('moo-print-ai-pro','MOO','business','Leading high-end business card and merch platform with AI design help.','https://moo.com',true,true,58000, freeTier:'Free sample kits', price:0, tips:'Best for professional branding | AI-powered "Design" service | High quality'),
    t('vista-print-ai','VistaPrint','business','The world\'s largest custom printing destination with AI-powered tools.','https://vistaprint.com',true,true,350000, freeTier:'Completely free to design', price:0, tips:'Acquired by Cimpress | AI-powered "Logo Maker" | Global industry leader'),

    // ━━━ AI FOR CYBERSECURITY v2 (Advanced) ━━━
    t('crowdstrike-falcon','CrowdStrike Falcon','business','Leading AI-native endpoint protection and threat intelligence.','https://crowdstrike.com',false,true,180000, freeTier:'Demo available', price:0, tips:'AI-powered "Falcon OverWatch" | Stops breaches in seconds | World class'),
    t('sentinel-one-ai','SentinelOne (Singularity)','business','Leading autonomous AI security platform for endpoints and cloud.','https://sentinelone.com',false,true,120000, freeTier:'Demo available', price:0, tips:'AI-powered "Purple AI" for security teams | Stops ransomware fast | Scale'),
    t('darktrace-ai-pro','Darktrace','business','The world\'s first "AI for Cyber" platform that defends like an immune system.','https://darktrace.com',false,true,58000, freeTier:'Demo available', price:0, tips:'AI-powered "Self-Learning" | Identify internal threats | European tech leader'),
    t('tanium-ai-pro','Tanium','business','Leading platform for real-time endpoint management and security with AI.','https://tanium.com',false,true,45000, freeTier:'Institutional only', price:0, tips:'Track 1M+ endpoints in seconds with AI | High visibility | Trusted by top banks'),
    t('zscaler-ai-pro','Zscaler','business','Leading cloud security platform with AI-powered zero trust architecture.','https://zscaler.com',false,true,84000, freeTier:'Institutional only', price:0, tips:'Best for secure remote work | AI-powered "Phishing" block | Global scale'),
    t('okta-ai-identity','Okta (Identity Engine)','business','The world\'s #1 identity platform using AI for fraud and access control.','https://okta.com',true,true,150000, freeTier:'Free for personal developers', price:0, tips:'Secure all your apps with AI | AI-powered "Risk" scores | Industry standard'),
    t('auth0-ai-pro','Auth0 (Okta)','code','Leading authentication platform for developers with AI-powered security.','https://auth0.com',true,true,120000, freeTier:'Free for up to 7,500 users', price:23, priceTier:'Individual monthly', tips:'Best for developer security | AI-powered "Bot Detection" | Easy to integrate'),
    t('snyk-ai-code-sec','Snyk','code','Leading developer security platform using AI to find vulnerabilities.','https://snyk.io',true,true,180000, freeTier:'Free basic version for solo devs', price:25, priceTier:'Team monthly annual', tips:'AI-powered "DeepCode" | Fix security leaks in real-time | Developer priority'),
    t('sonarqube-ai-pro','SonarQube','code','Leading platform for code quality and security with AI-powered analysis.','https://sonarsource.com',true,true,84000, freeTier:'Free open source version', price:0, tips:'The gold standard for code quality | AI-powered "Clean Code" | Robust'),
    t('veracode-ai-pro','Veracode','code','Leading application security testing platform with high-end AI labs.','https://veracode.com',false,true,15000, freeTier:'Demo available', price:0, tips:'AI-powered "Fix" for code security | Best for enterprise apps | Secure'),

    // ━━━ FINAL GEMS v10 (Automation) ━━━
    t('make-com-ai-pro','Make (Integromat)','business','Leading visual automation platform with AI-powered logic and apps.','https://make.com',true,true,250000, freeTier:'Free for up to 1,000 ops/month', price:9, priceTier:'Core monthly', tips:'Draw your workflows with AI | 1000+ app integrations | Best value for money'),
    t('zapier-ai-pro','Zapier (Central)','business','The standard for automation with new AI-powered "Central" bots.','https://zapier.com',true,true,500000, freeTier:'Free for up to 5 zaps', price:20, priceTier:'Starter monthly', tips:'AI-powered "Buid with AI" prompt | Most integrations in world | Reliable'),
    t('pabbly-ai-pro','Pabbly','business','All-in-one business suite including automation with AI-powered help.','https://pabbly.com',true,false,45000, freeTier:'Free trial available', price:20, priceTier:'Standard monthly', tips:'No per-task fees | AI-powered "Sync" | Best for marketing teams'),
    t('n8n-ai-pro','n8n.io','code','Fair-code automation platform for self-hosting with AI nodes.','https://n8n.io',true,true,84000, freeTier:'Completely free self-host', price:20, priceTier:'Starter monthly (hosted)', tips:'Best for developers | AI-powered "LangChain" integration | High flexibility'),
    t('active-pieces-ai','Activepieces','code','Open source automation platform built for AI and developer teams.','https://activepieces.com',true,true,15000, freeTier:'Completely free self-host', price:15, priceTier:'Starter monthly (hosted)', tips:'Best for AI agents | Open source and fast | Built on modern tech'),
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
