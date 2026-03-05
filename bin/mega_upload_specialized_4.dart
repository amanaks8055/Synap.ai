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
    // ━━━ HEALTH & FITNESS (Specialized) ━━━
    t('myfitnesspal-ai','MyFitnessPal','health','The world\'s most popular nutrition and fitness tracker with AI barcode scanning.','https://myfitnesspal.com',true,true,150000, freeTier:'Free basic tracking', price:20, priceTier:'Premium monthly', tips:'Largest food database | AI-powered macro tracking | Sync with all wearables'),
    t('strava-ai','Strava','health','Leading social network for athletes with AI-powered route planning and segments.','https://strava.com',true,true,250000, freeTier:'Free basic tracking', price:12, priceTier:'Subscription monthly', tips:'Best for running and cycling | AI-powered Beacon safety | Join global challenges'),
    t('calm-ai-pro','Calm','health','The #1 app for sleep, meditation and relaxation with AI-powered stories.','https://calm.com',true,true,180000, freeTier:'Free basic sessions', price:15, priceTier:'Premium monthly', tips:'Celebrity-narrated stories | AI suggests sleep routines | Industry leader'),
    t('headspace-ai-pro','Headspace','health','Guided meditation and mindfulness for every day with AI-powered stress relief.','https://headspace.com',true,true,160000, freeTier:'Free basic sessions', price:13, priceTier:'Monthly billed annually', tips:'Best for beginners | AI focus music | Scientifically proven benefits'),
    t('fitbod-ai','Fitbod','health','AI-powered workout plans that adapt to your progress and available equipment.','https://fitbod.me',true,true,45000, freeTier:'3 free workouts', price:13, priceTier:'Elite monthly', tips:'Best for gym goers | AI calculates recovery | Video guides for every lift'),

    // ━━━ PERSONAL FINANCE AI ━━━
    t('mint-ai-successor','Monarch Money','finance','The modern successor to Mint with AI-powered budget tracking and multi-account sync.','https://monarchmoney.com',false,true,25000, freeTier:'7-day free trial', price:15, priceTier:'Monthly subscription', tips:'Collaborative household budgeting | AI categories transactions | No ads'),
    t('ynab-ai-pro','YNAB (You Need A Budget)','finance','Proven method and app to help you gain control of your money with AI.','https://ynab.com',false,true,45000, freeTier:'34-day free trial', price:15, priceTier:'Monthly subscription', tips:'Zero-based budgeting | AI helps with overspending | High customer loyalty'),
    t('copilot-finance-ai','Copilot Money','finance','AI-powered personal finance tracker with beautiful design and smart categories.','https://copilot.money',false,true,18000, freeTier:'Free trial code available', price:13, priceTier:'Monthly subscription', tips:'The best UI in finance | AI-powered automation | Secure and private'),
    t('rocket-money-ai','Rocket Money','finance','AI-powered app to find and cancel unwanted subscriptions and save money.','https://rocketmoney.com',true,true,84000, freeTier:'Free basic version', price:3, priceTier:'Premium: canceller and more monthly', tips:'Identify recurring bills | AI-powered negotiations | Personal wealth tracking'),
    t('sofi-ai','SoFi','finance','All-in-one personal finance app for banking, loans, and AI-powered investing.','https://sofi.com',true,true,120000, freeTier:'Completely free to join', price:0, tips:'High interest rates | AI-powered stock picks | Unified financial view'),

    // ━━━ REAL ESTATE AI ━━━
    t('zillow-ai-pro','Zillow','business','The leading real estate marketplace with AI-powered "Zestimate" valuations.','https://zillow.com',true,true,250000, freeTier:'Completely free for search', price:0, tips:'Most accurate home values | 3D home tours | Largest inventory of listings'),
    t('redfin-ai-pro','Redfin','business','Modern real estate brokerage with AI-powered search and lower fees.','https://redfin.com',true,true,150000, freeTier:'Free for search', price:0, tips:'See homes faster | Local agent expert help | Save on commission'),
    t('realtor-ai-pro','Realtor.com','business','The official real estate site of the NAC with AI-powered home alerts.','https://realtor.com',true,true,120000, freeTier:'Free to browse', price:0, tips:'Up-to-date listings | Neighborhood insights | AI-powered mortgage calculator'),
    t('street-easy-ai','StreetEasy','business','NYC\'s #1 real estate marketplace with AI-powered rental search.','https://streeteasy.com',true,true,45000, freeTier:'Free for search', price:0, tips:'Specific to NYC market | AI identifies no-fee listings | Accurate building data'),
    t('apartments-ai','Apartments.com','business','Largest rental marketplace with AI-powered neighborhood matching.','https://apartments.com',true,true,84000, freeTier:'Free for search', price:0, tips:'Comphrensive rental listings | AI search by area | Secure online applications'),

    // ━━━ UTILITIES & SECURITY ━━━
    t('1password-ai','1Password','productivity','The world\'s most-loved password manager with AI-powered security alerts.','https://1password.com',false,true,150000, freeTier:'14-day free trial', price:3, priceTier:'Individual monthly', tips:'Secure by design | AI-powered "Watchtower" | Shared vaults for families'),
    t('lastpass-ai','LastPass','productivity','Popular password manager with AI for detecting weak and leaked passwords.','https://lastpass.com',true,true,120000, freeTier:'Free basic version (1 device)', price:3, priceTier:'Premium monthly', tips:'Easy syncing | AI security dashboard | Trusted by 30M+ users'),
    t('nordvpn-ai','NordVPN','productivity','Leading VPN with AI-powered "Threat Protection" and global servers.','https://nordvpn.com',false,true,180000, freeTier:'30-day money back guarantee', price:5, priceTier:'Standard monthly billed 2yr', tips:'Double VPN for security | Best speed in the industry | AI-powered malware block'),
    t('expressvpn-ai','ExpressVPN','productivity','High-speed, secure, and anonymous VPN with AI-optimized servers.','https://expressvpn.com',false,true,120000, freeTier:'30-day money back guarantee', price:13, priceTier:'Monthly subscription', tips:'Most reliable for streaming | 3000+ servers globally | Strong privacy policy'),
    t('surfshark-ai','Surfshark','productivity','Budget-friendly VPN with AI-powered antivirus and identity protection.','https://surfshark.com',false,true,84000, freeTier:'30-day money back guarantee', price:2, priceTier:'Monthly billed 2yr', tips:'Unlimited devices | AI-powered CleanWeb | Very affordable'),

    // ━━━ NEWS & SOCIAL ━━━
    t('substack-ai','Substack','marketing','Leading newsletter platform with AI-powered recommendations and notes.','https://substack.com',true,true,150000, freeTier:'Free for free newsletters', price:0, tips:'The home for independent writers | AI-powered "Notes" social feed | Powerful discovery'),
    t('medium-ai-premium','Medium','marketing','Open platform where 100M+ people come to read insightful AI stories.','https://medium.com',true,true,180000, freeTier:'Free 3 stories/month', price:5, priceTier:'Member monthly', tips:'High quality writing | AD-free experience | AI-powered reading suggestions'),
    t('pocket-ai-web','Pocket','productivity','Save everything from across the web with AI-powered tagging and search.','https://getpocket.com',true,true,150000, freeTier:'Free basic version', price:5, priceTier:'Premium monthly', tips:'Read offline anywhere | AI summarizes articles | Permanent library'),
    t('flipboard-ai','Flipboard','news','Your personal social magazine with AI-curated news and topics.','https://flipboard.com',true,true,84000, freeTier:'Completely free app', price:0, tips:'Beautiful magazine layout | AI-powered curation | Follow any topic'),
    t('smartnews-ai','SmartNews','news','Award-winning news app with AI for real-time local and global stories.','https://smartnews.com',true,true,58000, freeTier:'Completely free app', price:0, tips:'Best for local news | AI-powered breaking alerts | Ad-lite experience'),

    // ━━━ OFFICE & DOCS ━━━
    t('notion-plus-ai','Notion Plus','productivity','The all-in-one workspace with AI for docs, wikis, and projects.','https://notion.so',true,true,250000, freeTier:'Free for individuals', price:10, priceTier:'Plus per user monthly', tips:'Best for knowledge management | AI-powered content generation | Unified workspace'),
    t('obsidian-ai','Obsidian','productivity','Powerful knowledge base on local Markdown files with AI plugins.','https://obsidian.md',true,true,84000, freeTier:'Completely free for personal', price:0, tips:'Privacy first | Huge community of AI plugins | Best for PKM experts'),
    t('roam-research-ai','Roam Research','productivity','Note-taking tool for networked thought with AI-powered linking.','https://roamresearch.com',false,false,15000, freeTier:'30-day free trial', price:15, priceTier:'Professional monthly', tips:'Bi-directional linking | Best for researchers | High density of thought'),
    t('clickup-plus-ai','ClickUp Plus','productivity','The project management platform to replace them all with AI.','https://clickup.com',true,true,150000, freeTier:'Free forever basic', price:10, priceTier:'Plus per user monthly', tips:'AI-powered summaries | 1000+ integrations | Highly customizable'),
    t('monday-pro-ai','monday.com','productivity','Work OS that helps teams manage projects and workflows with AI.','https://monday.com',true,true,120000, freeTier:'Free for up to 2 seats', price:10, priceTier:'Standard per seat monthly', tips:'Visual and intuitive | AI-powered automation | Robust mobile app'),

    // ━━━ EDUCATION GEMS ━━━
    t('babbel-ai','Babbel','education','The language learning app that gets you talking with AI-powered voice.','https://babbel.com',true,true,92000, freeTier:'Free first lesson', price:14, priceTier:'Monthly subscription', tips:'Best for conversational skills | AI-powered speech recognition | High quality dialogues'),
    t('rosetta-stone-ai','Rosetta Stone','education','The gold standard in language learning with AI-powered immersion.','https://rosettastone.com',true,true,84000, freeTier:'Free demo sessions', price:12, priceTier:'Monthly subscription', tips:'Context-based learning | TruAccent AI voice recognition | Most recognized brand'),
    t('udemy-ai-plus','Udemy','education','Largest online course marketplace with AI-powered learning paths.','https://udemy.com',true,true,250000, freeTier:'Free previews for courses', price:10, priceTier:'Personal plan monthly', tips:'210k+ courses | AI recommends what to learn next | Frequent sales'),
    t('coursera-ai-plus','Coursera','education','Learn from top universities and companies with AI-powered tutors.','https://coursera.org',true,true,180000, freeTier:'Free to audit most courses', price:59, priceTier:'Plus monthly', tips:'University-backed certificates | AI-powered Coach | Best for career growth'),
    t('edx-ai-pro','edX','education','Elite online learning from Harvard, MIT, and more with AI support.','https://edx.org',true,true,150000, freeTier:'Free to audit most courses', price:0, tips:'Academic rigor | Executive education | AI for assignment feedback'),
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
