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
    // ━━━ AI FOR TECH DISCOVERY (Iconic) ━━━
    t('product-hunt-ai','Product Hunt','marketing','The world\'s #1 place to launch new products with AI-powered personalized feeds.','https://producthunt.com',true,true,999999, freeTier:'Completely free for the public', price:0, tips:'AI-powered "Product" recommendations | Best for early adopters | Silicon Valley favorite'),
    t('hacker-news-ai','Hacker News (Algolia)','code','Leading tech news forum using AI-powered "Algolia Search" for deep archives.','https://news.ycombinator.com',true,true,999999, freeTier:'Completely free search forever', price:0, tips:'Official YC forum | AI-powered "Search" is blazing fast | The gold standard tech news'),
    t('slash-dot-ai-pro','Slashdot','code','The original tech news for nerds using AI-powered "Story" discovery and tags.','https://slashdot.org',true,true,500000, freeTier:'Completely free news online', price:0, tips:'The "Slashdot effect" pioneer | AI-powered "Comments" | Iconic'),
    t('fark-ai-pro-news','Fark','entertainment','Unique news curation site using AI for personalized "Funny" and "Odd" tags.','https://fark.com',true,true,350000, freeTier:'Free basic version available', price:5, priceTier:'TotalFark monthly subscription', tips:'Best for satirical news | AI-powered "Headline" help | robust community'),
    t('tech-meme-ai-pro','Techmeme','marketing','Leading tech news aggregator using AI to summarize the most important stories.','https://techmeme.com',true,true,500000, freeTier:'Completely free for the public', price:0, tips:'AI-powered "River of News" | Best for tech executives | High trust'),
    t('the-verge-ai-pro','The Verge','entertainment','Leading tech and lifestyle news using AI for "Listen" and smart feeds.','https://theverge.com',true,true,999999, freeTier:'Completely free news online', price:0, tips:'Owned by Vox | AI-powered "Charts" and reviews | Best for tech enthusiasts'),
    t('tech-crunch-ai-pro','TechCrunch','business','Leading source for startup news and data with AI-powered "Equity" help.','https://techcrunch.com',true,true,999999, freeTier:'Free basic news available', price:15, priceTier:'EC+ monthly annual', tips:'The startup bible | AI-powered "Disrupt" data | High trust and reach'),
    t('engadget-ai-pro','Engadget','entertainment','Leading gadget news and reviews using AI for high-end "Product" data.','https://engadget.com',true,true,500000, freeTier:'Completely free news online', price:0, tips:'Owned by Yahoo/Apollo | AI-powered "Reviews" sentiment | Iconic'),
    t('wired-ai-pro-tech','WIRED','entertainment','Leading tech and culture magazine using AI for deep research and feeds.','https://wired.com',true,true,500000, freeTier:'Limited free articles monthly', price:5, priceTier:'Digital monthly annual', tips:'Owned by Condé Nast | AI-powered "Story" archives | High quality journalism'),
    t('ars-technica-ai','Ars Technica','code','Deep dive tech and science news using AI for high-end "Research" archives.','https://arstechnica.com',true,true,350000, freeTier:'Free basic news available', price:25, priceTier:'Pro yearly annual', tips:'Best for engineering deep dives | AI-powered "Scientific" tags | High trust'),

    // ━━━ AI FOR POLO & EQUESTRIAN ━━━
    t('polo-stats-ai-pro','Polo Analytics','lifestyle','Leading data and strategy platform for professional polo using AI.','https://poloanalytics.com',false,false,12000, freeTier:'Institutional only', price:0, tips:'Used by pro teams in AR/US | AI-powered "Horse" tracking | High end data'),
    t('equestrian-ai-pro','Jump ID','lifestyle','Leading jumping and equestrian analytics platform with AI-powered video data.','https://jumpid.com',true,false,8400, freeTier:'Free basic version', price:0, tips:'Best for show jumping coaches | AI-powered "Stride" tracking | niche favorite'),
    t('equi-id-ai-pro-val','EquiID (Valuation)','lifestyle','AI-powered valuation and pedigree for professional equestrian horses.','https://equiid.com',false,false,5600, freeTier:'Institutional only', price:0, tips:'Used by buyers and breeders | AI-powered "Bloodline" analysis | High trust'),
    t('horse-id-ai-pro-sci','HorseID','lifestyle','Identify horse breeds and health markers instantly using AI-powered data.','https://horseid.com',true,false,15000, freeTier:'Free basic identification', price:0, tips:'Best for stables and owners | AI-powered "Movement" check | reliable'),
    t('equis-ai-pro-data','FEI (Official Data)','lifestyle','The global FEI database with AI-powered live scores and world rankings.','https://fei.org',true,true,180000, freeTier:'Completely free open stats', price:0, tips:'The official source for pro equestrian | AI-powered "Result" center | Iconic'),

    // ━━━ AI FOR TAI CHI & QIGONG ━━━
    t('tai-chi-ai-pro-move','Tai Chi Architect','health','Leading platform for learning Tai Chi with AI-powered form tracking.','https://taichiarchitect.com',true,false,25000, freeTier:'Free basic lessons', price:0, tips:'Best for balance and health | AI-powered "Postural" guide | high quality'),
    t('qi-gong-ai-pro-heal','Qigong (Digital)','health','Professional resource for Qigong with AI-powered breath and energy data.','https://qigong.org',true,false,18000, freeTier:'Free basic resources', price:0, tips:'Best for mindfulness | AI-powered "Flow" aid | high trust'),
    t('martial-arts-ai-pro','Martial Art AI','health','AI-powered training and form check for diverse martial arts styles.','https://martialartai.com',true,false,35000, freeTier:'Free trial available', price:0, tips:'Best for dojo students | AI-powered "Kata" check | clean UI'),
    t('kung-fu-ai-pro-data','Kung Fu (Digital)','health','Leading database of traditional Kung Fu with AI-powered archives.','https://kungfu.org',true,false,12000, freeTier:'Free basic videos', price:0, tips:'Best for history buffs | AI-powered "Style" search | niche favorite'),
    t('flow-ma-ai-pro-heal','Flow Martial Arts','health','Leading platform for movement-based martial arts using AI for coaching.','https://flowma.com',true,true,58000, freeTier:'Free community resources', price:0, tips:'Best for holistic training | AI-powered "Routine" help | high end'),

    // ━━━ AI FOR MINUTE SCIENCE (Mineralogy & Gemology v3) ━━━
    t('gem-id-pro-ai-sci','GemID (Science)','science','Professional gem identification for labs using high-end AI visual data.','https://gemid.org',true,false,15000, freeTier:'Free for researchers', price:0, tips:'Based in Thailand | AI-powered "Optical" search | high intellectual focus'),
    t('rock-id-sci-pro-geo','RockID (Expert)','science','Identify mineral samples instantly using AI-powered visual recognition.','https://rockid.expert',true,false,12000, freeTier:'Free basic version', price:0, tips:'Best for professional mineralogists | AI-powered "Streak" aid | reliable'),
    t('mineral-id-pro-sci','MineralID (Expert)','science','Identify crystal structures instantly using AI-powered visual recognition.','https://mineralid.expert',true,false,8400, freeTier:'Free basic identification', price:0, tips:'Best for crystallographers | AI-powered "Face" analysis | high trust'),
    t('geology-free-ai','Open Geology (AI)','science','Completely free AI geology assistant using open data and research.','https://opengeology.org',true,true,45000, freeTier:'Completely free forever', price:0, tips:'Best for students | AI-powered "Textbook" help | Global'),
    t('earth-sci-id-pro','EarthSciID','science','Leading community driven Earth science identification using AI help.','https://earthsciid.com',true,false,5600, freeTier:'Free basic version', price:0, tips:'Best for field geoscientists | AI-powered "Mapping" | reliable'),

    // ━━━ AI FOR SPECIALIZED ART (Bookbinding & Enameling v2) ━━━
    t('book-bind-id-pro','Bookbinding (Pro)','lifestyle','Professional software for bookbinders using AI for precise measurements.','https://bookbinding.pro',false,true,12000, freeTier:'Institutional only', price:0, tips:'Best for restoration artists | AI-powered "Spine" calc | niche favorite'),
    t('enamel-id-ai-pro','EnamelID','lifestyle','Identify enameling techniques and colors instantly with AI-powered data.','https://enamelid.com',true,false,5600, freeTier:'Free basic guides', price:0, tips:'Best for metal artists | AI-powered "Color" help | high trust'),
    t('gold-smith-ai-pro','Goldsmith Architect','lifestyle','AI-powered design and pattern help for goldsmiths and jewelers.','https://goldsmitharchitect.com',true,false,8400, freeTier:'Free basic patterns', price:0, tips:'AI-powered "Weight" generator | Best for bench jewelers | Creative'),
    t('silver-smith-ai-pro','Silversmith (Digital)','lifestyle','Leading resource for silversmiths using AI to track metal alloys.','https://silversmith.org',true,false,12000, freeTier:'Free community forum', price:0, tips:'Best for sterling artists | AI-powered "Hallmark" ID | niche'),
    t('craft-id-ai-pro-gen','CraftID','lifestyle','Identify traditional craft styles and origins instantly using AI data.','https://craftid.com',true,false,15000, freeTier:'Free basic search', price:0, tips:'Best for collectors | AI-powered "Origin" check | clean UI'),

    // ━━━ FINAL GEMS v40 (Modern AI Tests) ━━━
    t('cy-press-ai-pro-test','Cypress','code','Leading front-end testing tool with new AI-powered "Cypress AI" help.','https://cypress.io',true,true,350000, freeTier:'Free for open source and small teams', price:75, priceTier:'Team monthly annual', tips:'AI-powered "Auto-fix" is elite | Best for modern JS apps | User favorite UI'),
    t('play-wright-ai-pro','Playwright (Microsoft)','code','Microsoft\'s elite testing library with AI-powered code generation.','https://playwright.dev',true,true,250000, freeTier:'Completely free open source', price:0, tips:'Best for multi-browser tests | AI-powered "Codegen" | High speed'),
    t('test-im-ai-pro-qa','Testim (Tricentis)','code','Leading AI-powered test automation platform for fast and stable QA.','https://testim.io',true,true,120000, freeTier:'Free for up to 1k runs/mo', price:0, tips:'AI-powered "Smart Locators" | Best for enterprise QA | High reliability'),
    t('mablo-ai-pro-test','mabl','code','Leading low-code test automation with AI-powered "Self-healing" and data.','https://mabl.com',true,true,84000, freeTier:'14-day free trial on site', price:0, tips:'Best for delivery teams | AI-powered "Insights" | robust and clean'),
    t('sauce-labs-ai-pro','Sauce Labs','code','The world\'s largest test cloud with AI-powered "Error Reporting" and logs.','https://saucelabs.com',true,true,250000, freeTier:'Free forever for open source', price:50, priceTier:'Solo monthly starting', tips:'AI-powered "Analysis" | Best for cross-platform testing | Industry giant'),
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
