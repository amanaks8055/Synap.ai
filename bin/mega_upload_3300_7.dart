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
    // ━━━ AI FOR HR & PAYROLL (Modern Giants) ━━━
    t('gusto-ai-pro','Gusto','business','Leading HR and payroll platform using AI to automate tax and benefits.','https://gusto.com',true,true,500000, freeTier:'Free to join for employees', price:40, priceTier:'Simple monthly annual', tips:'Best for small businesses | AI-powered "Compliance" | User favorite UI'),
    t('rippling-ai-pro','Rippling','business','The legendary all-in-one HR/IT platform with AI-powered system sync.','https://rippling.com',false,true,350000, freeTier:'Institutional only', price:0, tips:'Best for global teams | AI-powered "Unity" platform | Blazing fast operations'),
    t('deel-ai-compliance','Deel','business','Leading global hiring and payroll giant using AI for local law help.','https://deel.com',true,true,250000, freeTier:'Free to join and browse', price:0, tips:'Hire in any country with AI | AI-powered "Trust" and compliance | Global scale'),
    t('zenefits-ai-pro','Zenefits (TriNet)','business','Leading people platform using AI for health benefits and payroll logs.','https://zenefits.com',false,true,180000, freeTier:'Institutional only', price:0, tips:'Owned by TriNet | AI-powered "Reporting" | Best for medium size firms'),
    t('bamboo-hr-ai','BambooHR','business','Leading HR software for growing businesses with AI-powered performance.','https://bamboohr.com',false,true,150000, freeTier:'Demo available', price:0, tips:'Best for culture and employee data | AI-powered "Hiring" | Clean and simple'),
    t('pay-locity-ai','Paylocity','business','Leading enterprise payroll and HCM using AI for talent and data help.','https://paylocity.com',false,false,84000, freeTier:'Institutional only', price:0, tips:'Best for large US firms | AI-powered "Modern" workforce tools | robust'),
    t('pay-cor-ai-pro','Paycor','business','Leading provider of HCM software using AI for leadership and payroll.','https://paycor.com',false,false,58000, freeTier:'Institutional only', price:0, tips:'Best for mid-market CEOs | AI-powered "Predictive" insights | Reliable'),
    t('adp-ai-pro-hr','ADP (Vantage)','business','The world\'s #1 payroll provider with massive AI-powered data labs.','https://adp.com',false,true,500000, freeTier:'Institutional only', price:0, tips:'Pioneer in payroll | AI-powered "Wisdom" data | World leader'),
    t('workday-ai-pro','Workday','business','Leading enterprise cloud platform for finance and HR with high-end AI labs.','https://workday.com',false,true,250000, freeTier:'Institutional only', price:0, tips:'The gold standard for Fortune 500 AI | AI-powered "Skills" cloud | high end'),
    t('justworks-ai-pro','Justworks','business','Leading PEO platform for startups using AI for simple benefits and pay.','https://justworks.com',false,true,120000, freeTier:'Institutional only', price:0, tips:'Best for tech startups | AI-powered "Support" | Extremely clean UI'),

    // ━━━ AI FOR COOKING & GASTRONOMY v3 ━━━
    t('chef-steps-ai','ChefSteps (Joule)','lifestyle','Leading molecular gastronomy platform using AI for water oven (Sous Vide).','https://chefsteps.com',true,true,150000, freeTier:'Free basic recipes', price:0, tips:'Learn high-end cooking with AI | AI-powered "Joule" app | Best for techies'),
    t('modernist-cuisine-ai','Modernist Cuisine','lifestyle','The legendary lab of Nathan Myhrvold using AI for food science data.','https://modernistcuisine.com',true,true,84000, freeTier:'Free articles and visuals', price:0, tips:'The "Bible" of food science | AI-powered "Kitchen" labs | world class images'),
    t('culinary-agents-ai','Culinary Agents','business','Leading job site for the hospitality industry with AI-powered matching.','https://culinaryagents.com',true,true,120000, freeTier:'Free to join and browse', price:0, tips:'Best for chefs and servers | AI-powered "Network" | US market leader'),
    t('seven-rooms-ai','SevenRooms','business','Leading guest experience platform for restaurants using AI CRM data.','https://sevenrooms.com',false,true,58000, freeTier:'Institutional only', price:0, tips:'AI-powered "Guest" profiles | Best for fine dining | Global reach'),
    t('open-table-ai','OpenTable (AI)','lifestyle','World\'s #1 restaurant booking app with AI-powered discovery and data.','https://opentable.com',true,true,999999, freeTier:'Completely free for the public', price:0, tips:'AI-powered "Recommended for you" | Billion diners data | Industry standard'),
    t('resy-ai-pro-book','Resy (American Express)','lifestyle','Leading high-end restaurant booking using AI for "Global" dinner help.','https://resy.com',true,true,500000, freeTier:'Completely free to use', price:0, tips:'Owned by Amex | AI-powered "Notify" for tables | Best for foodies'),
    t('tock-ai-pro-eat','Tock','lifestyle','Leading platform for reservations and takeout with AI-powered ticketing.','https://exploretock.com',true,true,180000, freeTier:'Completely free for the public', price:0, tips:'Founded by Nick Kokonas | AI-powered "Pre-payment" | High quality focus'),
    t('yelp-ai-pro-eat','Yelp (AI)','lifestyle','Leading local discovery engine using AI to summarize millions of reviews.','https://yelp.com',true,true,999999, freeTier:'Completely free to use', price:0, tips:'AI-powered "Review Highlights" | Best for local biz | Global reach'),
    t('tripadvisor-ai','Tripadvisor (AI)','lifestyle','World\'s largest travel platform using AI for a personalized trip feed.','https://tripadvisor.com',true,true,999999, freeTier:'Completely free forever', price:0, tips:'AI-powered "Review" sentiment | Best for global travel | Billion user data'),
    t('zagat-ai-pro-eat','Zagat','lifestyle','The legendary dining guide using AI to curate professional ratings.','https://zagat.com',true,false,45000, freeTier:'Completely free to read', price:0, tips:'The iconic "Burgundy" book data | AI-powered "Lists" | high trust'),

    // ━━━ AI FOR GEOSCIENCE (Volcanology & Seismology) ━━━
    t('volcano-ai-monitor','Volcano Watch (AI)','science','Using AI to monitor global volcanic activity and hazard predictions.','https://volcano.si.edu',true,true,12000, freeTier:'Completely free from Smithsonian', price:0, tips:'The gold standard for volcano data | AI-powered "Alerts" | Global'),
    t('earthquake-ai-usgs','USGS Earthquake (AI)','science','Real-time earthquake monitoring using AI and global seismic data.','https://earthquake.usgs.gov',true,true,500000, freeTier:'Completely free for the public', price:0, tips:'Official US portal | AI-powered "ShakeMap" | life saving data'),
    t('iris-ai-geo-pro','IRIS (NSF)','science','Consortium of universities using AI for deep seismic research.','https://iris.edu',true,true,35000, freeTier:'Free for research and education', price:0, tips:'AI-powered "SeisWare" | Best for earth scientists | High accuracy'),
    t('g-net-ai-pro-geo','G-NET','science','Global GNSS network using AI to track tectonic plate movements.','https://unavco.org',true,false,15000, freeTier:'Free for researchers', price:0, tips:'AI-powered "Plate" velocity | Essential for geophysicists | high tech'),
    t('noaa-tsunami-ai','NOAA Tsunami (AI)','science','Global tsunami warning system using AI and sea floor sensors.','https://tsunami.gov',true,true,120000, freeTier:'Completely free for the public', price:0, tips:'AI-powered "Inundation" maps | Best for coastal safety | Global'),

    // ━━━ AI FOR MUSIC & SHEET MUSIC v2 ━━━
    t('ultimate-guitar-ai','Ultimate Guitar','entertainment','The world\'s #1 tab database using AI for "Tabs" and auto-scrolling.','https://ultimate-guitar.com',true,true,999999, freeTier:'Free basic tabs and tools', price:5, priceTier:'Pro monthly annual', tips:'AI-powered "Official" tabs | Best for learning guitar | Massive community'),
    t('song-sterr-ai-pro','Songsterr','entertainment','Leading tab player using AI for realistic playback and learning.','https://songsterr.com',true,true,350000, freeTier:'Free basic playback', price:10, priceTier:'Plus monthly annual', tips:'AI-powered "Sync" with audio | Best for multi-instrumentalists | Clean UI'),
    t('muse-score-ai-pro','MuseScore','entertainment','Leading open-source sheet music platform with AI-powered layout help.','https://musescore.org',true,true,500000, freeTier:'Completely free forever', price:0, tips:'Best for composers | AI-powered "Audio" export | huge community library'),
    t('note-flight-ai','Noteflight','entertainment','Leading browser-based sheet music editor with AI-powered sharing.','https://noteflight.com',true,true,180000, freeTier:'Free for up to 10 scores', price:7, priceTier:'Premium monthly', tips:'Best for teachers and schools | AI-powered "Learn" | Hal Leonard owned'),
    t('flat-io-ai-music','Flat.io','entertainment','Leading collaborative sheet music editor with AI-powered sync.','https://flat.io',true,true,120000, freeTier:'Free for up to 10 scores', price:7, priceTier:'Individual monthly annual', tips:'Best for simple collaboration | AI-powered "History" | clean design'),
    t('tom-play-ai-pro','Tomplay','entertainment','Interactive sheet music with high-quality AI-powered recordings.','https://tomplay.com',true,false,84000, freeTier:'Free trial available', price:15, priceTier:'Premium monthly annual', tips:'Play with a real orchestra | AI-powered "Tempo" control | high quality'),
    t('nkoda-ai-library','nkoda','entertainment','The world\'s largest library of digital sheet music with AI sharing.','https://nkoda.com',true,false,58000, freeTier:'Free trial on site', price:10, priceTier:'Premium monthly annual', tips:'Best for classical musicians | AI-powered "Annotations" | Official pubs only'),

    // ━━━ FINAL GEMS v26 (Modern Messaging) ━━━
    t('slack-ai-pro-chat','Slack (AI)','productivity','The world\'s #1 team chat with new AI-powered "Summaries" and help.','https://slack.com',true,true,999999, freeTier:'Free for up to 90 days history', price:7, priceTier:'Pro monthly annual per seat', tips:'AI-powered "Recap" is elite | Best for business communication | Salesforce owned'),
    t('discord-ai-pro','Discord (AI)','entertainment','Leading community platform using AI for moderation and "Clyde" help.','https://discord.com',true,true,999999, freeTier:'Completely free basic version', price:10, priceTier:'Nitro monthly', tips:'AI-powered "AutoMod" | Best for gaming and dev groups | Massive scale'),
    t('telegram-ai-pro','Telegram (AI)','lifestyle','Fast and secure messaging using AI for bots and large communities.','https://telegram.org',true,true,999999, freeTier:'Completely free forever', price:5, priceTier:'Premium monthly', tips:'The bot king with AI | Best for power users | Highly private and fast'),
    t('signal-ai-pro-msg','Signal','lifestyle','The world\'s most secure messenger with AI-powered privacy tech.','https://signal.org',true,true,500000, freeTier:'Completely free forever', price:0, tips:'End-to-end encryption standard | AI-powered "Spam" filtering | Non-profit'),
    t('whatsapp-ai-pro','WhatsApp (AI)','lifestyle','The world\'s #1 messenger with AI-powered "Meta AI" for help and search.','https://whatsapp.com',true,true,999999, freeTier:'Completely free forever', price:0, tips:'AI-powered "Stickers" and "Support" | 2B+ users | Global industry standard'),
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
