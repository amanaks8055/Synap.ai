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
    // ━━━ HEALTH & MENTAL (Gems) ━━━
    t('waking-up-ai-pro','Waking Up (Pro)','health','Advanced meditation app by Sam Harris focused on philosophy and neuroscience.','https://wakingup.com',true,true,45000, freeTier:'Free limited sessions', price:20, priceTier:'Monthly membership', tips:'Deeper intellectual content | AI-powered search across lessons | Best for skeptics'),
    t('lo-on-ai','Loóna','health','Sleep-inducing app that uses AI to combine storytelling and coloring.','https://loona.app',true,true,38000, freeTier:'Free basic sleepscapes', price:13, priceTier:'Monthly subscription', tips:'Award-winning design | AI matches colors and sounds | Unique "sleepscapes"'),
    t('sleep-details-ai','Sleep Cycle (Advanced)','health','Intelligent sleep tracker that analyzes sounds and patterns with AI.','https://sleepcycle.com',true,true,92000, freeTier:'Free basic version', price:30, priceTier:'Premium annual', tips:'Wake up at the optimal time | AI identifies snoring and talking | Data-driven sleep'),
    t('meditopia-ai','Meditopia','health','Personalized meditation app that adapts to your mental state with AI.','https://meditopia.com',true,true,58000, freeTier:'Free basic sessions', price:10, priceTier:'Premium monthly', tips:'Best for stress and anxiety | AI tracks emotional progress | 1000+ meditations'),
    t('daily-bean-ai','DailyBean','health','Simple and beautiful mood tracker that uses AI to visualize your life.','https://dailybean.app',true,false,15000, freeTier:'Completely free basic', price:0, tips:'Categorize your day with icons | AI-powered reports | Great for mindfulness'),

    // ━━━ LIFESTYLE & FASHION (Specialized) ━━━
    t('stitch-fix-ai','Stitch Fix','fashion','Personal styling service that uses AI to deliver clothes you\'ll love.','https://stitchfix.com',true,true,150000, freeTier:'Free style profile', price:20, priceTier:'Styling fee (credited back)', tips:'AI learns your exact fit | Personal stylist included | No subscription required'),
    t('trunk-club-ai','Trunk Club (Nordstrom)','fashion','Premium personal styling for men and women with AI-powered curation.','https://trunkclub.com',true,true,84000, freeTier:'Free to join', price:25, priceTier:'Styling fee (credited back)', tips:'Nordstrom-quality clothes | AI-powered box curation | Easy returns and exchanges'),
    t('rent-the-runway-ai','Rent the Runway','fashion','Leading platform to rent designer clothes with AI-powered fit suggestions.','https://renttherunway.com',true,true,120000, freeTier:'Free to browse', price:94, priceTier:'Starter subscription monthly', tips:'Unlimited luxury wardrobe | AI predicts your fit | Sustainable fashion'),
    t('thredup-ai-pro','thredUP','fashion','The world\'s largest online thrift store with AI-powered pricing and sorting.','https://thredup.com',true,true,150000, freeTier:'Free to browse and sell', price:0, tips:'Up to 90% off brands | AI identifies trends | Eco-friendly shopping'),
    t('poshmark-ai-pro','Poshmark','fashion','Leading social marketplace for new and used clothes with AI search.','https://poshmark.com',true,true,250000, freeTier:'Free to list and buy', price:0, tips:'Negotiate prices with sellers | AI filters for authenticity | Huge community'),

    // ━━━ SCIENCE & NATURE (Gems) ━━━
    t('ebird-ai-pro','eBird','science','The world\'s largest birding community with AI-powered identification.','https://ebird.org',true,true,180000, freeTier:'Completely free forever', price:0, tips:'Cornell Lab of Ornithology project | AI Merlin integration | Track lifelists'),
    t('merlin-bird-id-ai','Merlin Bird ID','science','Identify thousands of birds by sound or photo with AI for free.','https://merlin.allaboutbirds.org',true,true,150000, freeTier:'Completely free forever', price:0, tips:'Best birding app | AI sound identification | Expert photo analysis'),
    t('seek-by-inaturalist','Seek by iNaturalist','science','Identify plants and animals in real-time with your camera and AI.','https://inaturalist.org/pages/seek_app',true,true,120000, freeTier:'Completely free forever', price:0, tips:'Gamified nature discovery | Safe for kids | AI identifying everything'),
    t('inaturalist-pro','iNaturalist (Community)','science','Record and share nature observations with AI and эксперт help.','https://inaturalist.org',true,true,150000, freeTier:'Completely free non-profit', price:0, tips:'Global biodiversity data | AI-powered suggestions | Expert verification'),
    t('world-wildlife-ai','WWF (World Wildlife Fund)','science','Support global conservation efforts with AI-powered wildlife tracking.','https://worldwildlife.org',true,true,84000, freeTier:'Free to browse', price:0, tips:'Learn about endangered species | AI-powered "Wildfinder" | Support a cause'),

    // ━━━ GOVERNMENT & CIVIC (Extra) ━━━
    t('congress-gov-ai','Congress.gov','business','The official website for US federal legislative info with AI search.','https://congress.gov',true,true,150000, freeTier:'Completely free public info', price:0, tips:'Track bills and votes | AI-powered summaries | Official government source'),
    t('fec-gov-ai','FEC.gov','business','Federal Election Commission data with AI-powered campaign finance search.','https://fec.gov',true,true,84000, freeTier:'Completely free public data', price:0, tips:'Track money in politics | AI identifies donor trends | Official transparency'),
    t('census-gov-ai','Census.gov','business','Official source of US social and economic data with AI analytics.','https://census.gov',true,true,120000, freeTier:'Completely free public info', price:0, tips:'Best for demographic research | AI-powered data tools | Trusted by policy makers'),
    t('grants-gov-ai','Grants.gov','business','The official source for finding and applying for federal grants with AI.','https://grants.gov',true,true,92000, freeTier:'Completely free service', price:0, tips:'Access billions in funding | AI-powered eligibility checker | Secure application'),
    t('regulations-gov-ai','Regulations.gov','business','Your voice in federal decision-making with AI-powered comment search.','https://regulations.gov',true,true,58000, freeTier:'Completely free public info', price:0, tips:'Participate in law-making | AI identifies key topics | Public transparency'),

    // ━━━ EDUCATION (History & Art) ━━━
    t('google-arts-culture','Google Arts & Culture','education','Discover world heritage and art in high-res with AI-powered search.','https://artsandculture.google.com',true,true,250000, freeTier:'Completely free for everyone', price:0, tips:'VR tours of museums | AI "Art Selfie" | High definition artwork'),
    t('khan-academy-history','Khan Academy (History)','education','World-class history education for free with AI-powered tutoring.','https://khanacademy.org',true,true,180000, freeTier:'Completely free non-profit', price:0, tips:'Learn with Sal Khan | AI "Khanmigo" assistant | Best for students'),
    t('crash-course-ai','Crash Course (YouTube)','education','Fast-paced, high quality educational videos with AI-powered subtitles.','https://youtube.com/user/crashcourse',true,true,150000, freeTier:'Completely free on YouTube', price:0, tips:'The Green brothers project | Best visual learning | All subjects covered'),
    t('ted-ed-ai','TED-Ed','education','Lessons worth sharing with beautiful animation and AI-powered questions.','https://ed.ted.com',true,true,120000, freeTier:'Completely free non-profit', price:0, tips:'Beautifully animated lessons | Built-in quizzes | AI recommends next topics'),
    t('wikipedia-ai-v2','Wikipedia','education','The free encyclopedia that anyone can edit with AI for categorization.','https://wikipedia.org',true,true,999999, freeTier:'Completely free non-profit', price:0, tips:'Global source of truth | AI protects against vandalism | Millions of articles'),

    // ━━━ PRODUCTIVITY (Calendar GEMS) ━━━
    t('google-calendar-ai','Google Calendar','productivity','The world\'s most popular calendar with AI-powered smart scheduling.','https://calendar.google.com',true,true,999999, freeTier:'Free for personal (G-suite basic)', price:0, tips:'AI "Search" and suggestions | Integrated with Gmail | Shareable calendars'),
    t('fantastical-ai-pro','Fantastical','productivity','The award-winning calendar and tasks app for Apple devices with AI.','https://flexibits.com/fantastical',true,true,120000, freeTier:'Free basic features', price:5, priceTier:'Premium monthly', tips:'Natural language parsing | Best design on Apple | AI-powered "Openings"'),
    t('calendly-ai-pro','Calendly','productivity','The modern scheduling platform that automates meeting setup with AI.','https://calendly.com',true,true,150000, freeTier:'Free for 1 event type', price:10, priceTier:'Standard monthly', tips:'Connect 6 calendars | AI-powered workflow automation | Huge business favorite'),
    t('motion-ai-pro','Motion','productivity','The AI-powered calendar that builds your schedule for you automatically.','https://usemotion.com',false,true,45000, freeTier:'7-day free trial', price:19, priceTier:'Individual monthly billed annually', tips:'AI prioritizes your tasks | Automatic rescheduling | Replaces your calendar'),
    t('cron-ai-pro','Cron (Notion Calendar)','productivity','The next-generation calendar for professionals and teams with AI.','https://cron.com',true,true,84000, freeTier:'Currently free for everyone', price:0, tips:'Owned by Notion | Fastest calendar UI | Time-zone management leader'),

    // ━━━ UTILITIES (Security GEMS v2) ━━━
    t('virustotal-ai-pro','VirusTotal','productivity','Analyze suspicious files and URLs to detect types of malware with AI.','https://virustotal.com',true,true,150000, freeTier:'Free for individuals', price:0, tips:'Owned by Google | 70+ antivirus engines | AI-powered behavioral analysis'),
    t('haveibeenpwned-ai','Have I Been Pwned?','productivity','Check if your email or phone is in a data breach with AI alerts.','https://haveibeenpwned.com',true,true,120000, freeTier:'Completely free service', price:0, tips:'The industry standard for breaches | Troy Hunt project | Secure and private'),
    t('shodan-ai-pro','Shodan','productivity','The search engine for the Internet of Things with AI-powered indexing.','https://shodan.io',true,false,45000, freeTier:'Free limited search', price:59, priceTier:'One-time membership starting', tips:'Find devices online | AI-powered vulnerability detection | Best for security researchers'),
    t('binary-edge-ai','BinaryEdge','productivity','Data collection and cybersecurity platform using AI for threat intel.','https://binaryedge.io',true,false,15000, freeTier:'Free basic account', price:10, priceTier:'Individual monthly', tips:'Track exposed assets | Real-time security updates | AI-powered risk scoring'),
    t('censys-ai-pro','Censys','productivity','The most accurate search engine for every device on the internet.','https://censys.io',true,false,18000, freeTier:'Free for research', price:0, tips:'Leading attack surface management | AI-powered discovery | Trusted by Fortune 500'),

    // ━━━ MISC INNOVATIONS ━━━
    t('starlink-roam-ai','Starlink Roam','travel','Global satellite internet for nomads with AI-powered beam steering.','https://starlink.com/roam',false,true,45000, freeTier:'Hardware purchase required', price:150, priceTier:'Monthly roam plan', tips:'High speed internet anywhere | Works while in motion | Best for RVers'),
    t('uber-ai-pro','Uber','travel','World\'s leading ride-hailing app with AI-powered pricing and routing.','https://uber.com',true,true,999999, freeTier:'Free app for users', price:0, tips:'AI predicts pickup times | Safe and reliable | Global coverage'),
    t('lyft-ai-pro','Lyft','travel','Ride-hailing platform focused on transparency and AI-powered service.','https://lyft.com',true,true,250000, freeTier:'Free app for users', price:0, tips:'Consistent pricing | AI-powered "Wait & Save" | Great driver support'),
    t('airbnb-ai-pro','Airbnb','travel','Leading marketplace for vacation rentals with AI-powered curation.','https://airbnb.com',true,true,500000, freeTier:'Free to browse', price:0, tips:'Unique stays globally | AI-powered "Guest Favorites" | Secure payments'),
    t('booking-ai-pro','Booking.com','travel','The world\'s largest travel site with AI-powered hotel recommendations.','https://booking.com',true,true,450000, freeTier:'Free for users', price:0, tips:'Largest selection of hotels | AI-powered price match | Genius loyalty rewards'),

    // ━━━ FINAL GEMS ━━━
    t('openai-chatgpt-plus','ChatGPT Plus','productivity','The premium version of ChatGPT with Gpt-4 and AI-powered plugins.','https://openai.com/chatgpt',true,true,999999, freeTier:'Free version available (3.5)', price:20, priceTier:'Plus monthly', tips:'Access to latest models | Advanced data analysis | Integrated DALL-E 3'),
    t('anthropic-claude-pro','Claude Pro','productivity','Anthropic\'s most powerful AI for complex reasoning and writing.','https://anthropic.com/claude',true,true,500000, freeTier:'Free version available', price:20, priceTier:'Pro monthly', tips:'Largest context window | Focus on safety and honesty | Best for long docs'),
    t('google-gemini-ultra','Gemini Ultra','productivity','Google\'s most capable AI model built for multimodal reasoning.','https://gemini.google.com',true,true,840000, freeTier:'Gemini (basic) is free', price:20, priceTier:'Gemini Advanced monthly', tips:'Deep Google ecosystem integration | Best for multimodal tasks | Fast and reliable'),
    t('perplexity-ai-pro','Perplexity Pro','research','The AI search engine that gives you cited answers and real-time info.','https://perplexity.ai',true,true,250000, freeTier:'Free basic search', price:20, priceTier:'Pro monthly', tips:'Best for cited research | Choose your own model | Real-time news access'),
    t('phind-ai-pro','Phind','code','AI search engine for developers that writes high quality code.','https://phind.com',true,true,120000, freeTier:'Free forever basic', price:20, priceTier:'Pro monthly', tips:'Best for technical questions | AI writes and explains code | Extremely fast'),
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
