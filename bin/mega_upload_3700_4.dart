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
    // ━━━ AI FOR STREAMING & ENTERTAINMENT (Iconic) ━━━
    t('just-watch-ai-pro','JustWatch','entertainment','Leading streaming guide using AI to find where to watch any movie or show.','https://justwatch.com',true,true,999999, freeTier:'Completely free for users', price:0, tips:'Access 1k+ streaming catalogs | AI-powered "Personal" watchlists | Global leader'),
    t('reel-good-ai-pro','Reelgood','entertainment','Leading all-in-one streaming guide with AI-powered personalized ratings.','https://reelgood.com',true,true,500000, freeTier:'Completely free to use', price:0, tips:'Best for combined Netflix/Hulu viewing | AI-powered "Roulette" | US leader'),
    t('letterboxd-ai-pro','Letterboxd','entertainment','The world\'s #1 social network for film lovers with AI-powered "Stats".','https://letterboxd.com',true,true,999999, freeTier:'Completely free basic version', price:19, priceTier:'Pro yearly annual', tips:'Track Every movie you watch | AI-powered "Member" lists | High visual UI'),
    t('trakt-tv-ai-pro','Trakt.tv','entertainment','Leading tool for automatically tracking your TV and movie history with AI.','https://trakt.tv',true,true,350000, freeTier:'Free forever basic version', price:30, priceTier:'VIP yearly annual', tips:'AI-powered "Calendar" for episodes | Best for power users | robust data'),
    t('tv-time-ai-pro-go','TV Time','entertainment','The world\'s most popular TV guide using AI for community and predictions.','https://tvtime.com',true,true,500000, freeTier:'Completely free to use', price:0, tips:'AI-powered "Next to Watch" | Best for episode reactions | Huge community'),
    t('imdb-ai-pro-data','IMDb (AI)','entertainment','The world\'s most authoritative movie data source with AI-powered search.','https://imdb.com',true,true,999999, freeTier:'Completely free for the public', price:0, tips:'Owned by Amazon | AI-powered "What to Watch" | The gold standard data'),
    t('rotten-tom-ai-pro','Rotten Tomatoes','entertainment','Leading source for movie reviews using AI to summarize the "Tomatometer".','https://rottentomatoes.com',true,true,999999, freeTier:'Completely free to browse', price:0, tips:'AI-powered "Review" sentiment | Best for critic scores | Industry standard'),
    t('metacritic-ai-pro','Metacritic','entertainment','Leading source for movie, game, and music scores with AI weights.','https://metacritic.com',true,true,500000, freeTier:'Completely free forever', price:0, tips:'Best weighted average scores | AI-powered "Critics" rank | reliable'),
    t('fandango-ai-pro-tix','Fandango','entertainment','Leading movie ticket platform using AI for local seat and show help.','https://fandango.com',true,true,999999, freeTier:'Free app and rewards', price:0, tips:'AI-powered "Movie" alerts | Best for theater goers | US market leader'),
    t('atom-tickets-ai','Atom Tickets','entertainment','Modern movie ticketing with AI-powered "Smart" group orders and data.','https://atomtickets.com',true,true,180000, freeTier:'Free app for users', price:0, tips:'Best for social movie nights | AI-powered "Pre-order" snacks | clean UI'),

    // ━━━ AI FOR SAILING & MARINE v2 ━━━
    t('navionics-ai-sea','Navionics (Garmin)','lifestyle','The world\'s #1 marine maps using AI for "SonarChart" and routing.','https://navionics.com',true,true,250000, freeTier:'Free trial for 2 weeks', price:50, priceTier:'Yearly subscription starting', tips:'AI-powered "Auto-Routing" | Best for boaters | Industry standard maps'),
    t('predict-wind-ai-sea','PredictWind','lifestyle','Leading global wind and weather for sailors with AI-powered routing.','https://predictwind.com',true,true,150000, freeTier:'Free forever basic version', price:0, tips:'Best for blue water sailors | AI-powered "PWE" models | High accuracy'),
    t('marine-traffic-ai','MarineTraffic','lifestyle','The world\'s #1 ship tracking platform using AI for ETA and voyage help.','https://marinetraffic.com',true,true,500000, freeTier:'Free basic tracking online', price:0, tips:'AI-powered "Vessel" data is elite | Best for global maritime | high trust'),
    t('vessel-finder-ai','VesselFinder','lifestyle','Leading vessel tracking with AI-powered historical data and photos.','https://vesselfinder.com',true,true,350000, freeTier:'Completely free basic search', price:0, tips:'Best alternative to MarineTraffic | AI-powered "Port" calls | reliable'),
    t('windy-ai-sea-pro','Windy.app','lifestyle','Professional wind and weather for water sports with AI-powered maps.','https://windy.app',true,true,180000, freeTier:'Free basic version available', price:10, priceTier:'Pro monthly annual', tips:'Best for kiters and sailors | AI-powered "Forecast" | Beautiful visuals'),

    // ━━━ AI FOR MINUTE SCIENCE (Entomology & Birds v2) ━━━
    t('merlin-bird-id-ai','Merlin Bird ID','science','The world\'s #1 bird app using AI for sound and photo identification.','https://merlin.allaboutbirds.org',true,true,999999, freeTier:'Completely free forever', price:0, tips:'Joint project of Cornell Lab | AI-powered "Sound ID" is magic | Global Jewel'),
    t('e-bird-ai-pro-data','eBird','science','The world\'s largest biodiversity-related citizen science project with AI.','https://ebird.org',true,true,999999, freeTier:'Completely free forever', price:0, tips:'Access 1B+ bird sightings | AI-powered "Trends" | World standard data'),
    t('audubon-bird-ai','Audubon Bird Guide','science','Leading field guide for North American birds with AI-powered search.','https://audubon.org/app',true,true,500000, freeTier:'Completely free for the public', price:0, tips:'Official Audubon society tool | AI-powered "Sightings" | High trust'),
    t('picture-insect-ai','Picture Insect','science','Identify bug species instantly using AI-powered visual recognition.','https://pictureinsect.com',true,true,150000, freeTier:'Free basic identification', price:20, priceTier:'Premium yearly annual', tips:'AI-powered "Bite" risk alerts | Best for hikers | high accuracy'),
    t('bug-id-ai-pro-sci','BugID','science','Leading community driven insect identification using AI and data logs.','https://bugid.com',true,false,45000, freeTier:'Free basic version', price:0, tips:'Best for professional entomologists | AI-powered "Species" search | reliable'),

    // ━━━ AI FOR TRADITIONAL ARTS (Pottery & Jewelry) ━━━
    t('pottery-log-ai-pro','Pottery Log','lifestyle','The digital notebook for potters using AI to track glazes and firings.','https://potterylog.com',true,true,35000, freeTier:'Free basic version available', price:0, tips:'AI-powered "Glaze" calculator | Best for studio management | Niche favorite'),
    t('meshy-ai-pro-design','Meshy AI','design','AI 3D design platform for creating assets from text and images quickly.','https://meshy.ai',true,true,15000, freeTier:'Free monthly credits available', price:16, priceTier:'Pro monthly', tips:'Great for 3D product concepts | AI text-to-3D workflow | Fast export formats'),
    t('diamond-ai-pro-val','Diamond AI','business','AI-powered valuation and grading for diamonds and precious stones.','https://diamond.ai',false,false,12000, freeTier:'Institutional only', price:0, tips:'AI-powered "Clarity" grading | Used by wholesalers | High trust'),
    t('bead-ai-pro-design','Bead Architect','lifestyle','AI-powered design and pattern help for beading and jewelry artists.','https://beadarchitect.com',true,false,15000, freeTier:'Free basic version', price:0, tips:'AI-powered "Color" matching | Best for hobbyists | clean UI'),
    t('stained-glass-ai','Stained Glass (AI)','design','AI-powered pattern generator and design helper for stained glass artists.','https://stainedglasspatterns.com',true,false,18000, freeTier:'Free basic patterns', price:0, tips:'AI-powered "Cut" optimization | Best for glass artists | Creative'),

    // ━━━ FINAL GEMS v30 (Modern Logistics) ━━━
    t('flexport-ai-pro-log','Flexport','business','The modern freight forwarder using high-end AI labs for global logistics.','https://flexport.com',false,true,180000, freeTier:'Institutional only', price:0, tips:'AI-powered "Supply Chain" visibility | Best for global shippers | Revolutionary'),
    t('convi-ai-pro-log','Convoy','business','Leading digital freight network using AI to match trucks with shippers.','https://convoy.com',false,true,120000, freeTier:'Acquired by Flexport', price:0, tips:'AI-powered "Empty" mile reduction | Best for truckers | High efficiency'),
    t('uber-freight-ai','Uber Freight','business','Leading logistics giant using AI for real-time rates and driver matching.','https://uberfreight.com',true,true,350000, freeTier:'Free app for carriers', price:0, tips:'AI-powered "Quick Pay" | Global scale | Best for mid-size shippers'),
    t('ship-station-ai-pro','ShipStation','business','Leading shipping software for e-commerce with AI-powered automation.','https://shipstation.com',true,true,250000, freeTier:'30-day free trial on site', price:9, priceTier:'Starter monthly annual', tips:'Best for Shopify sellers | AI-powered "Rate" compare | Industry standard'),
    t('stamps-ai-pro-mail','Stamps.com','business','Leading digital postage platform with AI-powered mailing help.','https://stamps.com',true,true,350000, freeTier:'4-week free trial on site', price:19, priceTier:'Premium monthly', tips:'Best for US mail | AI-powered "Address" verify | reliable and fast'),
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
