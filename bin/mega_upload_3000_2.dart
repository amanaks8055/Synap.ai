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
    // ━━━ AI FOR WEATHER & CLIMATE v2 ━━━
    t('accu-weather-ai','AccuWeather','science','Global weather leader using AI for high-res minute-by-minute forecasts.','https://accuweather.com',true,true,999999, freeTier:'Completely free for users', price:0, tips:'AI-powered "RealFeel" and "MinuteCast" | Best for severe weather | Global leader'),
    t('the-weather-channel-ai','The Weather Channel','science','World\'s most accurate weather app using AI-powered "Deep Thunder".','https://weather.com',true,true,999999, freeTier:'Completely free with ads', price:0, tips:'Owned by IBM | AI-powered local forecasts | Most trusted and accurate'),
    t('windy-ai-pro','Windy.com','science','Leading visual weather platform with AI-powered GFS and ECMWF models.','https://windy.com',true,true,500000, freeTier:'Completely free basic version', price:3, priceTier:'Premium monthly', tips:'Best for pilots and sailors | AI-powered satellite visuals | Beautiful UI'),
    t('climacell-ai-pro','Tomorrow.io','science','Leading weather intelligence platform for business using high-end AI.','https://tomorrow.io',true,true,45000, freeTier:'Free basic version for users', price:0, tips:'Formerly ClimaCell | AI-powered "Weather-as-a-Service" | High precision'),
    t('weather-under-ai','Weather Underground','science','Crowdsourced weather data using AI to power hyper-local forecasts.','https://wunderground.com',true,true,350000, freeTier:'Free basic version', price:0, tips:'250k+ personal weather stations | AI-powered "Smart Forecast" | Reliable'),
    t('ventusky-ai-pro','Ventusky','science','Beautiful weather maps and animations using AI for global predictions.','https://ventusky.com',true,false,45000, freeTier:'Free basic version online', price:0, tips:'Real-time wind and rain visuals | AI-powered weather fronts | Clean design'),
    t('meteoblue-ai-pro','meteoblue','science','High-precision weather data for business and sports using Swiss AI.','https://meteoblue.com',true,false,35000, freeTier:'Free for personal use', price:0, tips:'Best for mountaineering | AI-powered "History" data | High accuracy'),
    t('storm-radar-ai','Storm Radar','science','Advanced tracking and visualization for severe storms using AI data.','https://weather.com/apps/storm',true,true,120000, freeTier:'Completely free to use', price:0, tips:'Real-time lightning and hail tracking | AI-powered "Forecast Line" | Fast'),
    t('earth-null-school','Earth Nullschool','science','Interactive 3D globe showing global weather using AI and real-time data.','https://earth.nullschool.net',true,true,180000, freeTier:'Completely free for everyone', price:0, tips:'Most beautiful global wind visuals | AI-powered data from GFS | Open source'),
    t('climatiq-ai-pro','Climatiq','business','Leading carbon tracking API for building climate-friendly software with AI.','https://climatiq.io',true,false,12000, freeTier:'Free for personal/research', price:50, priceTier:'Essential monthly', tips:'AI-powered "Emission Factor" search | Open data focus | Best for devs'),

    // ━━━ AI FOR GENEALOGY & HISTORY v2 ━━━
    t('ancestry-ai-pro','Ancestry.com','lifestyle','The world\'s largest genealogy platform with AI-powered record matching.','https://ancestry.com',true,true,999999, freeTier:'Free guest account search', price:25, priceTier:'Monthly starting', tips:'AI-powered "Hints" for your tree | Millions of digitized records | DNA integration'),
    t('my-heritage-ai','MyHeritage','lifestyle','Leading global genealogy service with AI-powered photo animation.','https://myheritage.com',true,true,500000, freeTier:'Free basic tree to 250 people', price:15, priceTier:'Premium monthly annual', tips:'AI-powered "Deep Nostalgia" for photos | Best for European records | DNA focus'),
    t('family-search-ai','FamilySearch','lifestyle','The world\'s largest free genealogy platform with AI-powered record reading.','https://familysearch.org',true,true,999999, freeTier:'Completely free forever', price:0, tips:'Non-profit and massive scale | AI-powered "Index helper" | Global collaborative tree'),
    t('wikitree-ai-pro','WikiTree','lifestyle','Global collaborative genealogy platform focusing on high-accuracy trees.','https://wikitree.com',true,false,84000, freeTier:'Completely free forever', price:0, tips:'One tree for the world | AI-powered collaborative tools | Privacy focused'),
    t('find-my-past-ai','Findmypast','lifestyle','Leading British and Irish genealogy platform using AI for data search.','https://findmypast.com',true,true,150000, freeTier:'Free basic search', price:10, priceTier:'Monthly starting', tips:'Best for UK census records | AI-powered newspapers search | reliable'),
    t('geneanet-ai-pro','Geneanet','lifestyle','Largest European genealogy community with AI-powered data sharing.','https://geneanet.org',true,false,58000, freeTier:'Free basic version', price:0, tips:'Best for French and continental records | AI-powered wiki | Community focus'),
    t('billion-graves-ai','BillionGraves','lifestyle','The world\'s largest platform for GPS cemetery records using AI image tech.','https://billiongraves.com',true,true,120000, freeTier:'Completely free for the public', price:0, tips:'Identify headstones with AI | Precise GPS data | Massive crowdsourced data'),
    t('find-a-grave-ai','Find a Grave','lifestyle','Massive global database of cemetery records and photos with AI search.','https://findagrave.com',true,true,250000, freeTier:'Completely free forever', price:0, tips:'Owned by Ancestry | Over 200M memorials | Community of volunteers'),
    t('living-dna-ai-pro','Living DNA','health','Leading DNA testing for ancestry and health with AI-powered precision.','https://livingdna.com',false,false,15000, freeTier:'No free tier', price:79, priceTier:'Ancestry kit once', tips:'Best for UK/Ireland regional data | AI-powered "Sub-regions" | High trust'),
    t('23andme-ai-pro','23andMe','health','The pioneer in personal genetics using AI to predict health risks.','https://23andme.com',true,true,999999, freeTier:'Free health traits quiz online', price:99, priceTier:'Ancestry kit once', tips:'FDA cleared reports | AI-powered "Relative" matching | World class research'),

    // ━━━ AI FOR GARDENING & NATURE v2 ━━━
    t('picture-this-ai','PictureThis','lifestyle','Identify any plant in seconds with your camera and AI-powered data.','https://picturethisai.com',true,true,500000, freeTier:'Free basic identification', price:30, priceTier:'Premium yearly', tips:'98% accuracy on 400k+ species | AI-powered "Care Tips" | Best for plant parents'),
    t('plant-net-ai-pro','Pl@ntNet','science','Large-scale citizen science project for plant identification using AI.','https://plantnet.org',true,true,250000, freeTier:'Completely free forever', price:0, tips:'Scientific accuracy | AI matches against world herbariums | Non-profit'),
    t('seek-ai-nature','Seek (iNaturalist)','science','Identify plants and animals with a fun, gamified AI app from iNaturalist.','https://inaturalist.org/pages/seek',true,true,180000, freeTier:'Completely free for everyone', price:0, tips:'Safe for kids | AI identifies via live camera | Earn badges for nature'),
    t('picture-insect-ai','Picture Insect','lifestyle','Identify any bug or insect in seconds using your phone camera and AI.','https://pictureinsect.com',true,true,120000, freeTier:'Free basic identification', price:20, priceTier:'Premium yearly', tips:'AI-powered "Bite" risk assessment | Best for gardeners | High quality data'),
    t('picture-bird-ai','Picture Bird','lifestyle','Identify birds by their song or photo using AI-powered audio matching.','https://picturebirdai.com',true,true,84000, freeTier:'Free basic version', price:0, tips:'Identify over 10k bird species | AI-powered "Bird Call" tech | Fun for families'),
    t('merlin-bird-id-ai','Merlin Bird ID','science','The gold standard for birding using AI from Cornell Lab of Ornithology.','https://merlin.allaboutbirds.org',true,true,250000, freeTier:'Completely free forever', price:0, tips:'AI-powered "Sound ID" is incredible | Best for serious birders | High accuracy'),
    t('ebird-ai-pro','eBird','science','The world\'s largest biodiversity-related citizen science project using AI.','https://ebird.org',true,true,150000, freeTier:'Completely free forever', price:0, tips:'Track your life list | AI-powered "Abundance" maps | Global data'),
    t('inaturalist-ai-pro','iNaturalist','science','Leading community for naturalists using AI-powered identification support.','https://inaturalist.org',true,true,180000, freeTier:'Completely free forever', price:0, tips:'Join 3M+ naturalists | AI identifies everything in nature | Scientific data'),
    t('smart-gardener-ai','Smart Gardener','lifestyle','AI-powered garden planning tool that helps you grow organic food.','https://smartgardener.com',true,false,35000, freeTier:'Free basic plan', price:0, tips:'Custom garden layouts with AI | Best for home veggies | Easy to follow'),
    t('garden-planner-ai','Garden Planner (Old Farmer\'s)','lifestyle','The world\'s most popular garden planning app using regional AI data.','https://gardenplanner.almanac.com',true,true,58000, freeTier:'7-day free trial on site', price:29, priceTier:'Yearly membership', tips:'AI-powered "Succession" planting | Best for serious growers | Iconic brand'),

    // ━━━ AI FOR MENTAL WELLNESS & SLEEP ━━━
    t('calm-ai-pro','Calm','health','The world\'s #1 app for sleep, meditation and relaxation using AI.','https://calm.com',true,true,999999, freeTier:'Free basic meditations and tracks', price:15, priceTier:'Monthly billed annually', tips:'AI-powered "Daily Calm" | Sleep stories with celebrities | Global leader'),
    t('headspace-ai-pro','Headspace','health','Leading mindfulness and meditation app with AI-powered personal paths.','https://headspace.com',true,true,999999, freeTier:'14-day free trial', price:13, priceTier:'Monthly billed annually', tips:'Best for beginners | AI-powered "Stress" relief | Science-backed'),
    t('insight-timer-ai','Insight Timer','health','The world\'s largest library of free meditations with AI-powered search.','https://insighttimer.com',true,true,500000, freeTier:'Completely free core library', price:10, priceTier:'Member Plus monthly', tips:'200k+ free tracks | AI-powered "Yoga" and "Sleep" | Global community'),
    t('aura-ai-wellness','Aura','health','The "Spotify" for mental health using AI to match you with coaches.','https://aurahealth.io',true,true,150000, freeTier:'Free basic sessions', price:12, priceTier:'Premium monthly', tips:'AI-powered matching in 30 seconds | High engagement | Personal and fast'),
    t('ten-percent-ai','10% Happier','health','Meditation for skeptics - simple, science-based AI-powered guidance.','https://tenpercent.com',true,true,120000, freeTier:'Free basic course', price:15, priceTier:'Monthly subscription', tips:'Led by Dan Harris | AI-powered "Review" | best for busy people'),
    t('sleep-cycle-ai','Sleep Cycle','health','The world\'s most popular smart alarm clock using AI to track sleep.','https://sleepcycle.com',true,true,500000, freeTier:'Free basic alarm and analysis', price:3, priceTier:'Premium monthly annual', tips:'AI identifies snoring and coughing | Wake up in light sleep | Data-rich'),
    t('reclaim-ai-sleep','Reclaim (Sleep)','health','AI-powered sleep tracking and coaching for better recovery.','https://reclaim.com',true,false,45000, freeTier:'Free for basic version', price:0, tips:'Optimize your schedule for sleep | AI-powered insights | High performance'),
    t('loftie-ai-alarm','Loftie','lifestyle','Smart alarm clock and lamp using AI for better sleep hygiene.','https://byloftie.com',false,true,28000, freeTier:'Hardware purchase required', price:0, tips:'AI-powered "Dream" generated sounds | No screen bedroom | Luxury design'),
    t('hatch-ai-sleep','Hatch','lifestyle','Leading smart sleep lamps and clocks with AI-powered light rituals.','https://hatch.co',false,true,84000, freeTier:'Hardware purchase required', price:5, priceTier:'Beacon monthly member', tips:'World class light science | AI-powered "Restore" | Best for babies and adults'),
    t('ouro-ring-ai-pro','Oura Ring','health','Leading smart ring for health and sleep tracking with high-end AI.','https://ouraring.com',false,true,150000, freeTier:'Hardware purchase required', price:6, priceTier:'Monthly membership', tips:'The gold standard for sleep data | AI-powered "Readiness" score | Discreet'),

    // ━━━ FINAL GEMS v12 (Deep Tech Foundations) ━━━
    t('open-cv-ai-pro','OpenCV','code','The world\'s largest library for computer vision and image AI.','https://opencv.org',true,true,999999, freeTier:'Completely free open source', price:0, tips:'The industry standard for vision | 2500+ algorithms | Huge community'),
    t('pytorch-ai-pro','PyTorch','code','Leading open source machine learning framework from Meta and contributors.','https://pytorch.org',true,true,999999, freeTier:'Completely free open source', price:0, tips:'The researcher\'s favorite | Dynamic graph computation | Massive ecosystem'),
    t('tensor-flow-ai','TensorFlow','code','Google\'s platform for building and deploying AI models end-to-end.','https://tensorflow.org',true,true,999999, freeTier:'Completely free open source', price:0, tips:'Best for production scale | Deep integration with Google Cloud | Mature'),
    t('scikit-learn-ai','Scikit-learn','code','Leading Python library for classical machine learning and data mining.','https://scikit-learn.org',true,true,500000, freeTier:'Completely free open source', price:0, tips:'Simple and efficient | Built on NumPy and SciPy | Best for beginners'),
    t('pandas-ai-pro','Pandas','code','The fundamental library for data manipulation and analysis in Python.','https://pandas.pydata.org',true,true,999999, freeTier:'Completely free open source', price:0, tips:'Essential for AI data prep | Powerful dataframes | Industry standard'),
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
