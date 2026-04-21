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
    // ━━━ LOGISTICS & SHIPPING (Specialized) ━━━
    t('parcel-tracking-ai','AfterShip','business','AI-powered shipment tracking and post-purchase platform for e-commerce.','https://aftership.com',true,true,12000, freeTier:'Free for up to 50 shipments/month', price:11, priceTier:'Essentials monthly', tips:'Best for Shopify and Amazon | Dynamic delivery ETAs | Automated notifications'),
    t('shippo-ai','Shippo','business','Multi-carrier shipping software with AI for rate optimization and labels.','https://goshippo.com',true,true,15000, freeTier:'Free for personal use', price:10, priceTier:'Professional monthly (unlimited labels)', tips:'Best for small businesses | Deep discounts on USPS/UPS | Easy API integration'),
    t('shipstation-ai','ShipStation','business','Leading shipping automation for e-commerce with AI batch processing.','https://shipstation.com',false,true,18000, freeTier:'30-day free trial', price:10, priceTier:'Starter plan monthly', tips:'Best for high volume shippers | Support for 100+ carriers | Custom packing slips'),
    t('easypost-ai','EasyPost','business','Modern shipping API for developers with AI-powered address verification.','https://easypost.com',true,false,8400, freeTier:'Free for up to 120 labels/year', price:0.01, priceTier:'Pay per label over limit', tips:'Most flexible shipping API | SmartRate optimization | Integrated tracking'),
    t('narvar-ai','Narvar','business','Enterprise post-purchase platform with AI for returns and tracking.','https://narvar.com',false,false,5600, freeTier:'Demo available', price:0, tips:'Used by Nike and Sephora | Best for luxury brands | AI manages returns policy'),

    // ━━━ TRAVEL (Visas & Services) ━━━
    t('ivisa-ai','iVisa','travel','AI-powered global visa processing and travel documentation service.','https://ivisa.com',true,true,8400, freeTier:'Free visa requirement check', price:20, priceTier:'Service fee varies by country', tips:'Get visas in 24-48 hours | 100% government compliant | 24/7 customer support'),
    t('atlys-ai','Atlys','travel','Modern mobile app for getting visas in minutes with AI photo checks.','https://atlys.com',true,true,12000, freeTier:'Free app for checking visas', price:15, priceTier:'Flat service fee per visa', tips:'Takes the stress out of visas | AI-powered photo upload | Guaranteed processing times'),
    t('world-nomads-ai','World Nomads','travel','Global travel insurance for independent travelers with AI claims.','https://worldnomads.com',false,true,15000, freeTier:'Free quotes online', price:0, tips:'Best for adventurous travelers | AI handles claims faster | Covers 150+ activities'),
    t('safety-wing-ai','SafetyWing','travel','Nomad insurance and remote health insurance with AI support.','https://safetywing.com',false,true,18000, freeTier:'Quote based on age/duration', price:45, priceTier:'Monthly subscription for nomads', tips:'Cheapest for digital nomads | Global coverage (excluding home) | Easy automated billing'),
    t('priority-pass-pro','Priority Pass','travel','Global airport lounge network with AI-powered lounge discovery.','https://prioritypass.com',false,true,120000, freeTier:'Often free with credit cards', price:99, priceTier:'Standard annual members', tips:'1500+ lounges globally | Includes dining and spa | Best for frequent flyers'),

    // ━━━ HOME SERVICES (Apps) ━━━
    t('thumbtack-ai','Thumbtack','social','Leading platform for hiring local professionals with AI matches.','https://thumbtack.com',true,true,45000, freeTier:'Completely free for consumers', price:0, tips:'Get quotes in minutes | Reliable reviews | Best for home repairs and cleaning'),
    t('handy-ai','Handy','social','Leading platform for connecting with top-rated home cleaners.','https://handy.com',true,true,38000, freeTier:'Free app for users', price:0, tips:'Book in 60 seconds | Background checked pros | Satisfaction guarantee'),
    t('taskrabbit-ai','TaskRabbit','social','Connect with "Taskers" for furniture assembly, moving, and more.','https://taskrabbit.com',true,true,58000, freeTier:'Free app for users', price:0, tips:'Best for IKEA assembly | Same-day help available | Secure payment via app'),
    t('angi-ai','Angi (Angie\'s List)','social','The trusted name for finding and booking local home service pros.','https://angi.com',true,true,62000, freeTier:'Free for consumers', price:0, tips:'150+ categories of service | Verified reviews | Official price guides'),
    t('rover-ai','Rover','social','The world\'s largest network of 5-star pet sitters and dog walkers.','https://rover.com',true,true,92000, freeTier:'Free app for users', price:0, tips:'Best for dog boarding | 24/7 vet support | GPS tracking during walks'),

    // ━━━ SOCIAL IMPACT & NON-PROFIT ━━━
    t('charity-navigator-ai','Charity Navigator','research','AI-powered charity ratings for transparency and impact.','https://charitynavigator.org',true,true,18000, freeTier:'Completely free for donors', price:0, tips:'Ensure your donation has maximum impact | Tax receipts kept in one place | unbiased ratings'),
    t('global-giving-ai','GlobalGiving','research','Crowdfunding platform for non-profits with AI-powered matching.','https://globalgiving.org',true,true,15000, freeTier:'Free for donors', price:0, tips:'Best for supporting disaster relief | Verified projects globally | Gift cards for charity'),
    t('gofundme-ai','GoFundMe','social','The world\'s #1 fundraising platform for personal and social causes.','https://gofundme.com',true,true,150000, freeTier:'Free for donors and organizers', price:0, tips:'Safest fundraising platform | AI monitors for fraud | Trusted globally'),
    t('one-tree-planted-ai','One Tree Planted','science','Non-profit for global reforestation using AI for tracking impact.','https://onetreeplanted.org',true,true,45000, freeTier:'Donation based (\$1 = 1 tree)', price:0, tips:'Plant trees in 43+ countries | Business partnerships available | Very high transparency'),
    t('kiva-ai','Kiva','finance','Micro-lending platform for entrepreneurs in developing nations.','https://kiva.org',true,true,38000, freeTier:'Free to join (\$25 minimum loan)', price:0, tips:'96% repayment rate | Empower entrepreneurs directly | Money is returned to you'),

    // ━━━ RETAIL TECH (Advanced) ━━━
    t('shopify-pos-ai','Shopify POS','business','The most powerful retail point of sale with AI-driven inventory.','https://shopify.com/pos',true,true,45000, freeTier:'Free trial available', price:29, priceTier:'POS Pro per location', tips:'Seamlessly sync with online store | AI helps with inventory forecasting | Best for growing brands'),
    t('square-pos-ai','Square','business','Leading POS for small business with AI-powered payments and loans.','https://square.com',true,true,120000, freeTier:'Free basic POS software', price:29, priceTier:'Plus for retail/restaurants', tips:'Accept payments in minutes | No monthly fees for basic | Integrated hardware'),
    t('lightspeed-ai','Lightspeed','business','Enterprise cloud-based POS system for retailers and restaurants.','https://lightspeedhq.com',false,false,15000, freeTier:'Demo available', price:69, priceTier:'Starter annually', tips:'Powerful inventory for bike/jewelry shops | Multi-location support | Pro analytics'),
    t('clover-ai','Clover','business','Unified POS and payment system with AI for local business growth.','https://clover.com',false,false,12000, freeTier:'Hardware purchase required', price:15, priceTier:'Monthly software starting', tips:'Integrated hardware and software | 500+ apps in market | Best for local merchants'),
    t('toast-ai','Toast','business','The leading restaurant management and POS system with AI.','https://pos.toasttab.com',false,true,18000, freeTier:'Free "Pay-as-you-go" starter', price:165, priceTier:'Professional monthly per terminal', tips:'Best for busy restaurants | AI-powered menu management | Handheld ordering (Toast Go)'),

    // ━━━ LUXURY & STYLE (Niche) ━━━
    t('chrono24-ai','Chrono24','fashion','The leading global marketplace for luxury watches with AI valuation.','https://chrono24.com',true,true,45000, freeTier:'Free to browse and use', price:0, tips:'AI-powered "Watch Scanner" | Authenticated transactions | Best for Rolex/Omega'),
    t('farfetch-ai','Farfetch','fashion','Leading platform for world-class luxury fashion with AI discovery.','https://farfetch.com',true,true,38000, freeTier:'Free to browse', price:0, tips:'Access to 1000s of boutiques | AI-powered visual search | Loyalty rewards'),
    t('net-a-porter-ai','Net-a-Porter','fashion','World\'s premier online luxury fashion destination with AI curation.','https://net-a-porter.com',true,true,32000, freeTier:'Free to browse', price:0, tips:'EHP personal styling | Luxurious packaging | Editorial-led shopping'),
    t('sothebys-ai','Sotheby\'s','fashion','Global leader in art and luxury auctions with AI-powered valuation.','https://sothebys.com',true,true,18000, freeTier:'Free to browse auctions', price:0, tips:'Bid on world-class art and cars | Private sales available | Most prestigious auction house'),
    t('jamesedition-ai','JamesEdition','fashion','The world\'s luxury marketplace for real estate, cars, and jets.','https://jamesedition.com',true,false,12000, freeTier:'Free to browse', price:0, tips:'High quality listings only | Global search for jets and yachts | Luxury real estate focus'),

    // ━━━ AUTO SERVICES (Maintenance) ━━━
    t('repair-pal-ai','RepairPal','automotive','AI-powered estimates and network of certified repair shops.','https://repairpal.com',true,true,25000, freeTier:'Free estimates online', price:0, tips:'Know the fair price before you go | Guaranteed quality | Huge network of shops'),
    t('kelley-blue-book-ai','KBB (Kelley Blue Book)','automotive','The industry standard for car valuation and pricing with AI.','https://kbb.com',true,true,58000, freeTier:'Completely free for consumers', price:0, tips:'Get your car\'s instant value | Compare new vs used | Accurate local prices'),
    t('carfax-ai','CARFAX','automotive','Leading vehicle history reports with AI for detecting odometer fraud.','https://carfax.com',false,true,45000, freeTier:'Free basic info', price:45, priceTier:'One report starting', tips:'Check for accidents and floods | Essential for used car buyers | AI-verified service history'),
    t('autotrader-ai','AutoTrader','automotive','The #1 car marketplace for buying and selling with AI research.','https://autotrader.com',true,true,42000, freeTier:'Free to browse', price:0, tips:'Largest inventory of cars | AI-powered price comparison | Safe selling tools'),
    t('jiffy-lube-ai','Jiffy Lube','automotive','Leading oil change and routine maintenance with AI tracking.','https://jiffylube.com',true,false,15000, freeTier:'Free digital inspections', price:0, tips:'Fastest oil changes | AI tracks your service schedule | National warranty'),

    // ━━━ PETS (Specialized) ━━━
    t('chewy-ai','Chewy','pets','Leading online pet store with AI-powered subscriptions and vet.','https://chewy.com',true,true,150000, freeTier:'Free shipping on \$49+', price:0, tips:'Auto-ship saves money | 24/7 vet chat for members | Incredible customer service'),
    t('petco-ai','Petco','pets','Unified pet health and wellness platform with AI-powered vet.','https://petco.com',true,true,84000, freeTier:'Free to browse', price:0, tips:'Vital Care membership | Grooming and training in-store | High quality diet focus'),
    t('petsmart-ai','PetSmart','pets','Largest retailer of pet supplies and services with AI styling.','https://petsmart.com',true,true,82000, freeTier:'Free to browse', price:0, tips:'Best in-store grooming | Doggie Day Camp | Massive selection of brands'),
    t('trupanion-ai','Trupanion','pets','Top-rated medical insurance for pets with AI-powered payouts.','https://trupanion.com',false,true,35000, freeTier:'Free quotes', price:0, tips:'Direct pay to vets | No payout limits | Covers hereditary conditions'),
    t('petfinder-ai','Petfinder','pets','The world\'s largest pet adoption database with AI breed matching.','https://petfinder.com',true,true,120000, freeTier:'Completely free forever', price:0, tips:'Adopt from 11k+ shelters | AI helps find the right dog | Save a life'),

    // ━━━ SPIRITUALITY (Deep Niche) ━━━
    t('insight-timer-ai','Insight Timer','spiritual','The #1 free meditation app with AI for personalized courses.','https://insighttimer.com',true,true,58000, freeTier:'Free forever basic', price:10, priceTier:'Member Plus monthly', tips:'Largest library of free meditations | Connect with friends | High quality teachers'),
    t('aura-health-ai','Aura Health','spiritual','AI-powered emotional health and sleep app personalized for you.','https://aurahealth.io',true,true,25000, freeTier:'7-day free trial', price:12, priceTier:'Monthly billed annually', tips:'Short 3-minute exercises | Personal AI coach | High focus on sleep'),
    t('ten-percent-happier','10% Happier','spiritual','Meditation for skeptics with world-class teachers and AI.','https://tenpercent.com',true,true,18000, freeTier:'Free basic course', price:15, priceTier:'Annual membership monthly', tips:'Dan Harris\'s project | Practical meditation | AI assists with questions'),
    t('balance-ai','Balance','spiritual','The personal meditation app that adapts to you every day with AI.','https://balanceapp.com',true,true,45000, freeTier:'Free first year for new users', price:12, priceTier:'Monthly subscription', tips:'Plans adapt to your progress | Beautiful audio quality | Very high user ratings'),
    t('waking-up-ai','Waking Up','spiritual','Sam Harris\'s meditation app focused on philosophy and neuroscience.','https://wakingup.com',true,true,35000, freeTier:'Free limited sessions', price:20, priceTier:'Monthly membership', tips:'Deeper philosophical content | High intellectual focus | Best for skeptics'),
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
