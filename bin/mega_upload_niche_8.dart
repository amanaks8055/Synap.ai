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
    // ━━━ AI FOR VOICE & SPEECH (Deep Dive) ━━━
    t('lovo-ai-pro','LOVO AI','audio','Leading AI voice platform for creating professional content with high-quality AI voices.','https://lovo.ai',true,true,120000, freeTier:'14-day free trial', price:19, priceTier:'Basic monthly', tips:'Best for social media and marketing | AI-powered "Genny" editor | 500+ voices'),
    t('murf-ai-pro','Murf AI','audio','AI voice generator for high-quality voiceovers in videos, presentations, and 더.','https://murf.ai',true,true,150000, freeTier:'Free basic version', price:19, priceTier:'Basic per user monthly', tips:'Professional studio quality | AI-powered "Voice Changer" | Easy to sync with slides'),
    t('play-ht-ai','Play.ht','audio','Leading AI text-to-speech platform with ultra-realistic AI voices and cloning.','https://play.ht',true,true,180000, freeTier:'Free basic version', price:31, priceTier:'Creator monthly', tips:'API for real-time speech | Best for long-form content | High fidelity clones'),
    t('wellsaid-labs-ai','WellSaid Labs','audio','Enterprise-grade AI voice platform for businesses to create high-quality audio.','https://wellsaidlabs.com',true,true,45000, freeTier:'7-day free trial', price:44, priceTier:'Maker monthly', tips:'Natural and human-like | Best for corporate training | High security'),
    t('speechify-ai-pro','Speechify','audio','The world\'s #1 text-to-speech app that turns any text into high-quality audio.','https://speechify.com',true,true,500000, freeTier:'Free basic version', price:12, priceTier:'Premium monthly billed annually', tips:'Read faster with AI voices | High quality narration | Available on all devices'),
    t('descript-ai-audio','Descript (Audio)','audio','Full-stack AI audio and video editor that makes editing as easy as text.','https://descript.com',true,true,250000, freeTier:'Free forever basic', price:12, priceTier:'Creator monthly', tips:'AI "Overdub" voice cloning | "Studio Sound" enhancement | Transcribe and edit'),
    t('krisp-ai-pro','Krisp','productivity','AI-powered noise cancellation for meetings that removes background sounds.','https://krisp.ai',true,true,150000, freeTier:'60 mins free/daily', price:8, priceTier:'Pro monthly', tips:'Best for remote workers | AI "Voice Clarity" | Integrated with all meeting apps'),
    t('otter-ai-pro','Otter.ai','productivity','AI meeting assistant that transcribes and summarizes your calls in real-time.','https://otter.ai',true,true,250000, freeTier:'300 monthly mins free', price:10, priceTier:'Pro monthly billed annually', tips:'AI-powered "OtterPilot" | Best for interviews and lectures | Reliable transcripts'),
    t('rev-ai-pro','Rev AI','video','Leading speech-to-text platform using AI for transcription and captions.','https://rev.com',true,true,180000, freeTier:'Free trial credits', price:0.25, priceTier:'Per minute of audio (AI)', tips:'The industry standard for captions | High accuracy AI | Integrated workflows'),
    t('trint-ai-pro','Trint','video','AI transcription platform for journalists and storytellers to turn audio into text.','https://trint.com',true,true,84000, freeTier:'7-day free trial', price:48, priceTier:'Starter monthly', tips:'Collaborative editing | AI-powered story builder | Trusted by top newsrooms'),

    // ━━━ AI FOR RETAIL & SALES v2 ━━━
    t('gorgias-ai-cx','Gorgias','marketing','The #1 helpdesk for e-commerce with AI-powered customer service.','https://gorgias.com',false,true,120000, freeTier:'7-day free trial', price:10, priceTier:'Starter monthly', tips:'Best for Shopify/BigCommerce | AI-powered "Automated Answers" | High ROI'),
    t('yotpo-ai-pro','Yotpo','marketing','E-commerce marketing platform using AI for reviews and loyalty.','https://yotpo.com',true,true,150000, freeTier:'Free basic plan forever', price:15, priceTier:'Growth monthly', tips:'AI-powered sentiment analysis | Best for increasing LTV | Global scale'),
    t('list-perfectly-ai','List Perfectly','ecommerce','Leading platform for reselling with AI-powered cross-posting and inventory.','https://listperfectly.com',false,true,45000, freeTier:'Demo available', price:29, priceTier:'Simple monthly', tips:'Cross-post to eBay/Poshmark/Mercari | AI-powered image background removal | Best for sellers'),
    t('sell-ai-pro','Veeqo (Amazon)','ecommerce','Inventory and shipping software for e-commerce with AI-powered forecasting.','https://veeqo.com',true,true,58000, freeTier:'Completely free for the core version', price:0, tips:'Owned by Amazon | Discounted shipping labels | AI identifies inventory needs'),
    t('shipstation-ai','ShipStation','ecommerce','The #1 shipping software for e-commerce with AI-powered automation.','https://shipstation.com',true,true,150000, freeTier:'30-day free trial', price:9, priceTier:'Starter monthly', tips:'Best for small businesses | AI identifies the cheapest shipping | 100+ integrations'),
    t('skio-ai-sub','Skio','ecommerce','Modern subscription platform for Shopify with AI-powered retention.','https://skio.com',false,true,12000, freeTier:'Demo available', price:299, priceTier:'Flat monthly plus fees', tips:'Industry disruptor | AI-powered "Surprise and Delight" | Focus on retention'),
    t('recharge-ai-pro','Recharge','ecommerce','Leading subscription platform for high-growth e-commerce brands.','https://rechargepayments.com',true,true,58000, freeTier:'Free until \$100k in sales', price:250, priceTier:'Pro monthly base', tips:'Best for custom subscriptions | AI-powered churn reduction | Secure and scalable'),
    t('attentive-ai-sms','Attentive','marketing','Leading personalized mobile messaging platform with AI-powered SMS.','https://attentive.com',false,true,45000, freeTier:'Demo available', price:0, tips:'Industry standard for SMS | AI-powered "Copywriter" | Highest engagement'),
    t('postscript-ai','Postscript','marketing','Leading SMS marketing for Shopify brands with AI-powered optimization.','https://postscript.io',true,true,35000, freeTier:'Free until \$1k in sales', price:100, priceTier:'Subscription per month starting', tips:'Compliance first | AI-powered "Sales Cloud" | Best for brand owners'),
    t('loop-returns-ai','Loop Returns','ecommerce','The leading exchange and returns platform for Shopify with AI.','https://loopreturns.com',false,true,28000, freeTier:'Demo available', price:0, tips:'Best for reducing returns | AI-powered "Exchanges" first | High trust'),

    // ━━━ AI FOR SMART HOME & IOT ━━━
    t('nest-ai-home','Google Nest (AI)','lifestyle','Smart home ecosystem with AI-powered security and energy saving.','https://nest.google.com',true,true,999999, freeTier:'Free app for users', price:0, tips:'AI-powered "Nest Aware" | Familiar face detection | Self-learning thermostat'),
    t('amazon-alexa-ai','Amazon Alexa','lifestyle','The world\'s most popular voice assistant with AI-powered smart home.','https://amazon.com/alexa',true,true,999999, freeTier:'Completely free to use', price:0, tips:'100k+ skills | AI-powered "Hunches" | Best for smart home control'),
    t('apple-homekit-ai','Apple HomeKit','lifestyle','Secure smart home management for Apple users with AI local processing.','https://apple.com/home-app',true,true,500000, freeTier:'Completely free for users', price:0, tips:'Privacy-first | AI-powered "Facial Recognition" | Best for iOS ecosystem'),
    t('sense-ai-energy','Sense','lifestyle','Monitor your home\'s energy use in real-time with AI-powered detection.','https://sense.com',false,true,25000, freeTier:'Hardware purchase required', price:0, tips:'AI identifies every appliance | Save hundreds on energy | High precision'),
    t('ecobee-ai-pro','ecobee','lifestyle','Smart thermostat and home security with AI-powered comfort and saving.','https://ecobee.com',false,true,45000, freeTier:'Hardware purchase required', price:5, priceTier:'Smart Security monthly', tips:'Best for multi-room comfort | AI-powered "Eco+" | HomeKit compatible'),
    t('ring-ai-pro','Ring','lifestyle','Leading home security platform with AI-powered video doorbells.','https://ring.com',true,true,999999, freeTier:'Free app for basic alerts', price:5, priceTier:'Protect Basic monthly', tips:'Owned by Amazon | AI-powered "Smart Alerts" | Largest neighborhood network'),
    t('arlo-ai-security','Arlo','lifestyle','High-end smart security cameras with AI-powered object detection.','https://arlo.com',true,true,120000, freeTier:'Free app for basic use', price:5, priceTier:'Standard monthly', tips:'AI identifies people/packages/cars | 4K resolution options | Battery powered'),
    t('wyze-ai-home','Wyze','lifestyle','Most affordable smart home devices with AI-powered detection and help.','https://wyze.com',true,true,250000, freeTier:'Free basic app alerts', price:3, priceTier:'Cam Plus monthly', tips:'Best value for money | AI-powered friendly price | Large ecosystem'),
    t('simplisafe-ai','SimpliSafe','lifestyle','Award-winning home security platform with AI-powered professional monitoring.','https://simplisafe.com',false,true,150000, freeTier:'Hardware purchase required', price:20, priceTier:'Standard Monitoring monthly', tips:'No contracts | AI-powered "Video Verification" | Top rated for ease of use'),
    t('august-home-ai','August Home','lifestyle','Leading smart lock platform with AI-powered auto-unlock and safety.','https://august.com',false,true,58000, freeTier:'Hardware purchase required', price:0, tips:'Auto-unlock with AI check | Guest access codes | Best design'),

    // ━━━ AI FOR EDUCATION v2 (University & Courses) ━━━
    t('coursera-ai-pro','Coursera','education','Learn from top universities with AI-powered course summaries and help.','https://coursera.org',true,true,500000, freeTier:'Thousands of free courses', price:39, priceTier:'Coursera Plus monthly', tips:'Earn professional certificates | AI-powered "Coach" | Best academic quality'),
    t('edx-ai-pro','edX','education','Leading nonprofit education platform with AI features from Harvard & MIT.','https://edx.org',true,true,350000, freeTier:'Free to audit courses', price:0, tips:'University-grade content | AI-powered "Xpert" assistant | High transparency'),
    t('udemy-ai-pro','Udemy','education','The largest marketplace for online courses with AI-powered learning.','https://udemy.com',true,true,999999, freeTier:'Free courses available', price:15, priceTier:'Avg per course starting', tips:'Skill-based learning | AI-powered search and recommendations | Global reach'),
    t('skillshare-ai-2','Skillshare (Pro)','education','Learn creative skills from experts with AI-powered course paths.','https://skillshare.com',true,true,150000, freeTier:'1-month free trial', price:14, priceTier:'Monthly billed annually', tips:'Best for design/art | AI-powered "Create" prompts | Community focus'),
    t('chegg-ai-pro','Chegg','education','Leading student hub for homework help and AI-powered tutor services.','https://chegg.com',true,true,250000, freeTier:'Free study resources', price:15, priceTier:'Study pack monthly', tips:'Step-by-step solutions | AI-powered "Cheggmate" | Integrated textbook rental'),
    t('scribd-ai-pro','Scribd (Everand)','education','Unlimited digital library with AI-powered reading recommendations.','https://scribd.com',true,true,180000, freeTier:'30-day free trial', price:12, priceTier:'Monthly subscription', tips:'Books/Audiobooks/Docs | AI-powered summaries | Best value for readers'),
    t('perlego-ai-pro','Perlego','education','The "Spotify for Textbooks" with AI-powered study and citation tools.','https://perlego.com',true,true,84000, freeTier:'7-day free trial', price:12, priceTier:'Monthly billed annually', tips:'1M+ academic textbooks | AI-powered search across books | Save on education'),
    t('wolfram-alpha-ai','Wolfram Alpha','science','Computational search engine using AI and logic for math and science.','https://wolframalpha.com',true,true,500000, freeTier:'Free basic version', price:5, priceTier:'Pro monthly', tips:'The gold standard for symbolic math | AI for data analysis | Trusted by scientists'),
    t('brilliant-ai-math','Brilliant (Math)','education','Master math and logic with interactive lessons and AI-powered help.','https://brilliant.org',true,true,150000, freeTier:'Free daily challenges', price:13, priceTier:'Premium monthly annual', tips:'Learn by doing | AI adapts to your level | Beautiful visual logic'),
    t('magoosh-gre-ai','Magoosh (GRE)','education','Effective GRE prep with AI-powered score prediction and tutoring.','https://magoosh.com/gre',true,true,84000, freeTier:'Free GRE prep tools', price:149, priceTier:'6-month plan', tips:'Best value for GRE | AI-powered study scheduler | High success rate'),

    // ━━━ AI FOR TRAVEL & NOMAD LIFE ━━━
    t('nordvpn-ai-pro','NordVPN','productivity','Leading VPN with AI-powered threat protection and security.','https://nordvpn.com',false,true,500000, freeTier:'30-day money back guarantee', price:4, priceTier:'Basic monthly billed 2yr', tips:'AI-powered malware block | Fastest speeds | Global server network'),
    t('surfshark-ai','Surfshark','productivity','Modern VPN with AI-powered data removal and private search.','https://surfshark.com',false,true,250000, freeTier:'30-day money back guarantee', price:2, priceTier:'Starter monthly billed 2yr', tips:'Unlimited devices | AI-powered "Search" tool | High value for money'),
    t('expressvpn-ai','ExpressVPN','productivity','Premium VPN with AI-powered security features and global access.','https://expressvpn.com',false,true,350000, freeTier:'30-day money back guarantee', price:8, priceTier:'Monthly billed annually', tips:'Most reliable for censored regions | AI-powered kill switch | Easy setup'),
    t('nomad-list-ai','Nomad List','travel','The #1 site for digital nomads to find places with AI-powered data.','https://nomadlist.com',true,true,84000, freeTier:'Free to browse basic data', price:99, priceTier:'One-time membership starting', tips:'AI-powered city rankings | Best nomad community | Real-time global data'),
    t('roam-around-ai','Roam Around','travel','AI-powered travel planner that builds detailed itineraries in seconds.','https://roamaround.io',true,true,120000, freeTier:'Completely free to use', price:0, tips:'Fastest itinerary gen | AI-powered "Local Hints" | Integrated with maps'),
    t('trip-it-ai-pro','TripIt','travel','Leaders in travel organization with AI-powered flight alerts and help.','https://tripit.com',true,true,180000, freeTier:'Free basic version', price:4, priceTier:'Pro monthly annual', tips:'Automatic travel itineraries | AI-powered "Inner Circle" alerts | Essential for flyers'),
    t('google-flights-ai','Google Flights','travel','Leading flight search engine using AI for price prediction and tracks.','https://google.com/flights',true,true,999999, freeTier:'Completely free for everyone', price:0, tips:'Best for price tracking | AI predicts cheapest time | Fast and clean'),
    t('hopper-ai-pro','Hopper','travel','Leading mobile travel app with AI-powered price freezing and help.','https://hopper.com',true,true,250000, freeTier:'Free app for users', price:0, tips:'95% accuracy in price prediction | AI-powered "Price Freeze" | Best on mobile'),
    t('away-ai-pro','Away (Travel)','travel','Leading luggage and travel brand with AI-powered packing and design.','https://awaytravel.com',true,true,84000, freeTier:'Free packing tips online', price:0, tips:'High quality gear | AI-powered "Packing List" generator | Lifetime warranty'),
    t('hotel-tonight-ai','HotelTonight','travel','Leading hotel booking app for last-minute deals with AI curation.','https://hoteltonight.com',true,true,150000, freeTier:'Free app for users', price:0, tips:'Best for last-minute stays | AI-powered "Daily Drop" | Exclusive rates'),

    // ━━━ AI FOR WELLNESS v2 (Mental Health & Sleep) ━━━
    t('calm-ai-pro','Calm','health','The world\'s #1 app for sleep and meditation with AI-powered music.','https://calm.com',true,true,999999, freeTier:'Free basic sessions', price:15, priceTier:'Premium monthly', tips:'Best sleep stories | AI-powered "Daily Calm" | Used by celebs'),
    t('headspace-ai-pro','Headspace','health','Leading mindfulness app with AI-powered coaching and meditations.','https://headspace.com',true,true,500000, freeTier:'Free basic sessions', price:13, priceTier:'Premium monthly', tips:'Scientifically proven | AI-powered "The Wakeup" | High quality animation'),
    t('woebot-ai-pro','Woebot','health','Your own AI-powered mental health ally for managing stress and mood.','https://woebothealth.com',true,true,120000, freeTier:'Completely free for users', price:0, tips:'CBT-based conversations | AI identifies clinical signs | Anonymous and safe'),
    t('wysa-ai-pro','Wysa','health','AI-powered emotional well-being assistant and coach for anxiety.','https://wysa.io',true,true,84000, freeTier:'Free basic conversations', price:15, priceTier:'Premium monthly starting', tips:'Clinically validated | AI for managing burnout | Used by 5M+ people'),
    t('youper-ai-pro','Youper','health','The AI-powered emotional health assistant developed by doctors.','https://youper.ai',true,true,58000, freeTier:'Free basic version', price:10, priceTier:'Premium monthly', tips:'Best for understanding emotions | AI-powered mood journaling | Private and secure'),
    t('aura-ai-wellness','Aura','health','The "Spotify for wellness" with AI-powered personalized coaching.','https://aurahealth.io',true,true,92000, freeTier:'Free for credits for trial', price:12, priceTier:'Premium monthly annual', tips:'Worlds largest library | AI-powered daily coaching | Multi-language'),
    t('sleep-cycle-ai-pro','Sleep Cycle','health','Leading smart alarm and sleep tracker using AI sound analysis.','https://sleepcycle.com',true,true,150000, freeTier:'Free basic version', price:30, priceTier:'Premium annual', tips:'Wake up feeling refreshed | AI identifies snoring | Detailed sleep reports'),
    t('oura-ring-ai','Oura Ring','health','Leading wearable smart ring with AI-powered recovery and sleep data.','https://ouraring.com',false,true,58000, freeTier:'Hardware purchase required', price:6, priceTier:'Membership monthly', tips:'Most accurate sleep tracker | AI-powered "Readiness Score" | High design'),
    t('whoop-ai-pro','WHOOP','health','High-performance fitness tracker with AI-powered strain and sleep.','https://whoop.com',false,true,120000, freeTier:'Subscription required', price:30, priceTier:'Monthly membership', tips:'Used by pro athletes | AI-powered "WHOOP Coach" | Detailed recovery metrics'),
    t('fitbit-ai-pro','Fitbit (Premium)','health','Leading health and fitness platform with AI-powered "Daily Readiness".','https://fitbit.com',true,true,999999, freeTier:'Free basic version', price:10, priceTier:'Premium monthly', tips:'Owned by Google | AI identifies sleep stages | Huge community'),
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
