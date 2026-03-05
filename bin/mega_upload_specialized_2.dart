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
    // ━━━ BUSINESS & FOUNDER TOOLS ━━━
    t('y-combinator-library','YC Library','business','The official Y Combinator library of startup wisdom and videos.','https://ycombinator.com/library',true,true,45000, freeTier:'Completely free open access', price:0, tips:'The "Bible" for startup founders | High quality content from top VCs | Community focus'),
    t('indie-hackers-ai','Indie Hackers','business','The leading community of independent developers sharing revenue and ideas.','https://indiehackers.com',true,true,35000, freeTier:'Free to join and browse', price:0, tips:'Transparency of revenue | Connect with other founders | Great for solo devs'),
    t('crunchbase-ai','Crunchbase','business','Leader in corporate information and AI-powered prospecting for startups.','https://crunchbase.com',true,true,18000, freeTier:'Free basic profile browsing', price:29, priceTier:'Starter: track up to 10 companies', tips:'Best for startup research | Funding data is unmatched | AI signals for buyers'),
    t('pitch-ai','Pitch','business','Beautiful, collaborative presentation software with AI for deck generation.','https://pitch.com',true,true,15000, freeTier:'Free for up to 2 presentations', price:8, priceTier:'Pro: unlimited and exporting', tips:'Best design in presentation space | Professional templates | Real-time collaboration'),
    t('beautiful-ai-pro','Beautiful.ai','business','AI presentation software that automatically formats your slides.','https://beautiful.ai',false,true,12000, freeTier:'14-day free trial', price:12, priceTier:'Pro per user monthly', tips:'Slides design themselves | Focus on content, not pixels | AI generated charts'),
    t('slidebean-ai','Slidebean','business','AI-powered pitch deck platform specifically for startups raising capital.','https://slidebean.com',true,false,8400, freeTier:'Free to create (watermark)', price:29, priceTier:'All-access monthly', tips:'Investor-ready templates | AI deck optimization | Track investor interest'),
    t('capbase-ai','Capbase (Carta)','business','Automated equity management and legal incorporation for startups.','https://capbase.com',false,false,4800, freeTier:'Demo available', price:0, tips:'Acquired by Carta | Automate cap tables | Legal standard for Silicon Valley'),

    // ━━━ CREATIVE ASSETS (AI) ━━━
    t('unsplash-ai','Unsplash','design','The world\'s most used free image site with AI-powered search.','https://unsplash.com',true,true,150000, freeTier:'Completely free for personal/commercial', price:4, priceTier:'Unsplash+ for exclusive content', tips:'Highest quality free photos | Simple license | API used by 10k+ apps'),
    t('pexels-ai','Pexels','design','Free stock photos and videos with AI-powered discovery and trending.','https://pexels.com',true,true,120000, freeTier:'Completely free forever', price:0, tips:'Best high-res vertical videos | Good for social media | Community of creators'),
    t('pixabay-ai','Pixabay','design','Over 4M+ high-quality stock images, videos, and music for free.','https://pixabay.com',true,false,98000, freeTier:'Completely free for all', price:0, tips:'Huge variety (photos, vectors, music) | No attribution required | Very fast'),
    t('flaticon-ai','Flaticon','design','Largest database of free icons with AI-powered search and generator.','https://flaticon.com',true,true,84000, freeTier:'Free with attribution', price:10, priceTier:'Premium: ad-free and no attribution', tips:'Icons in SVG, PNG, EPS | Built-in icon editor | Part of Freepik'),
    t('freepik-ai','Freepik','design','Leading high-quality photos, vectors, and AI generation tools.','https://freepik.com',true,true,150000, freeTier:'Free with attribution', price:10, priceTier:'Premium: unlimited everything', tips:'Best for vector designers | AI Image Generator is fast | Daily limit of downloads'),
    t('icons8-ai','Icons8','design','Professional icons, photos, and music with AI-powered design tools.','https://icons8.com',true,false,45000, freeTier:'Free with attribution', price:13, priceTier:'Pro per asset category', tips:'Native desktop apps | AI background remover | Beautiful icons (Pichon)'),
    t('noun-project-ai','The Noun Project','design','Diverse collection of icons and photos documenting everything.','https://thenounproject.com',true,false,38000, freeTier:'Free with attribution', price:3, priceTier:'Pro: ad-free and unlimited', tips:'Most iconic designs | Very high standard | Used by designers globally'),

    // ━━━ FONTS & TYPOGRAPHY ━━━
    t('google-fonts-ai','Google Fonts','design','Open source library of 1600+ font families and icons for the web.','https://fonts.google.com',true,true,250000, freeTier:'Completely free forever', price:0, tips:'Fastest font delivery | Variable fonts support | Essential for web devs'),
    t('adobe-fonts-ai','Adobe Fonts','design','Premium font library with thousands of professional typefaces.','https://fonts.adobe.com',true,true,120000, freeTier:'Included in Creative Cloud', price:0, tips:'Sync with desktop apps | Best for high-end design | Web and print rights included'),
    t('fontshare-ai','Fontshare','design','Free-to-use professional grade fonts from Indian Type Foundry.','https://fontshare.com',true,false,35000, freeTier:'Completely free high-end fonts', price:0, tips:'Incredible font quality | Variable font support | Minimalist and modern'),
    t('dafont-ai','DaFont','design','The largest community-driven font archive for personal use.','https://dafont.com',true,false,150000, freeTier:'Free for personal use', price:0, tips:'Check licenses for commercial use | Huge variety of styles | Fast previews'),
    t('typewolf-ai','Typewolf','design','The ultimate resource for what\'s trending in typography on the web.','https://typewolf.com',true,true,25000, freeTier:'Free to browse and learn', price:0, tips:'Best for typography inspiration | Identify fonts on websites | Modern trends'),

    // ━━━ DEV MOCKUPS & PROTOTYPING ━━━
    t('ls-graphics-ai','LS Graphics','design','Premium design assets, mockups, and UI kits for professionals.','https://ls.graphics',true,false,18000, freeTier:'Free mockups available', price:15, priceTier:'Unlimited access monthly', tips:'Highest quality mockups in the world | Apple device specialists | Beautiful UI kits'),
    t('shots-so','Shots.so','design','AI-powered mockup generator for beautiful social media and app shots.','https://shots.so',true,true,35000, freeTier:'Completely free online', price:0, tips:'Best for Product Hunt shots | Multiple device frames | High customization'),
    t('previewed-ai','Previewed','design','The all-in-one mockup generator for promotional app graphics.','https://previewed.app',true,false,12000, freeTier:'Free for basic exports', price:12, priceTier:'Pro: 4K exports and more templates', tips:'3D app screenshots | Panoramic views | Very high resolution'),
    t('mockup-world-ai','Mockup World','design','The original biggest source of free photo-realistic mockups.','https://mockupworld.co',true,false,45000, freeTier:'Completely free to download', price:0, tips:'Links to many external sources | Hand-picked quality | Photoshop focus'),
    t('smartmockups-ai','Smartmockups (Canva)','design','Instant mockup generator inside the browser and Canva.','https://smartmockups.com',true,true,58000, freeTier:'Free starting mockups', price:9, priceTier:'Pro: 15k+ premium mockups', tips:'Owned by Canva | One-click mockup creation | No Photoshop needed'),

    // ━━━ LIFESTYLE & GIFTS ━━━
    t('giftmode-ai','Gift Mode (Etsy)','social','AI-powered gift finder that suggests unique items from Etsy.','https://etsy.com/gift-mode',true,true,15000, freeTier:'Completely free to use', price:0, tips:'Best for unique handmade gifts | AI understands relationships | Fast shipping'),
    t('uncommon-goods-ai','Uncommon Goods','social','Marketplace for creative and unique gifts with AI recommendations.','https://uncommongoods.com',true,false,28000, freeTier:'Free to browse', price:0, tips:'Discover items you won\'t find elsewhere | High quality curation | Great for birthdays'),
    t('gift-hero-ai','Gift Hero','social','AI-powered wish list and gift registry for any occasion.','https://gifthero.com',true,false,12000, freeTier:'Completely free platform', price:0, tips:'Add any item from any site | Group gifting | Avoid duplicate gifts'),
    t('elfster-ai','Elfster','social','AI-powered secret santa generator and gift exchange platform.','https://elfster.com',true,true,45000, freeTier:'Completely free platform', price:0, tips:'The #1 secret santa app | Wishlist generation | Automated invites'),
    t('registry-ai','The Knot (Registry)','social','Leading wedding registry with AI-powered planning tools.','https://theknot.com',true,true,58000, freeTier:'Completely free to use', price:0, tips:'Best for weddings | Unified registry from all stores | Guest list AI'),

    // ━━━ FASHION & STYLING ━━━
    t('stitch-fix-ai','Stitch Fix','fashion','Personal styling service using AI and human stylists to send clothes.','https://stitchfix.com',false,true,120000, freeTier:'Style fee applies', price:20, priceTier:'Styling fee (credited toward buy)', tips:'AI learns your style | Data-driven clothing picks | No subscription required'),
    t('trunk-club-ai','Trunk Club (Nordstrom)','fashion','Premium styling service from Nordstrom using high-end brands.','https://nordstrom.com/trunk-club',false,false,45000, freeTier:'Nordstrom points rewarded', price:0, tips:'Stylist-curated boxes | High-end brands focus | Free shipping and returns'),
    t('rent-the-runway-ai','Rent the Runway','fashion','Designer clothing rental with AI-powered fit and style suggestions.','https://renttherunway.com',true,true,84000, freeTier:'Free trial available', price:94, priceTier:'8 items per month plan', tips:'Unlimited designer styles | Best for special events | Eco-friendly fashion'),
    t('thredup-ai','ThredUp','fashion','Largest online thrift store with AI-powered quality and style checks.','https://thredup.com',true,true,150000, freeTier:'Free to browse', price:0, tips:'Factories-worth of used clothes | AI search by photo | Sustainable shopping'),
    t('the-realreal-ai','The RealReal','fashion','Authenticated luxury consignment with AI-powered valuation.','https://therealreal.com',true,true,72000, freeTier:'Free to browse', price:0, tips:'Best for luxury resale | In-house authentication | Significant discounts'),

    // ━━━ RECIPES & COOKING ━━━
    t('yummly-ai','Yummly','food','Leading recipe app with AI for personalized meal plans and shop.','https://yummly.com',true,true,92000, freeTier:'Free basic recipes', price:5, priceTier:'Pro: guided cooking and more', tips:'AI personalized to allergies | Guided video recipes | Sync with Instacart'),
    t('tasty-ai','Tasty (BuzzFeed)','food','The world\'s largest food network with AI-powered recipes.','https://tasty.co',true,true,150000, freeTier:'Completely free app', price:0, tips:'Viral video recipes | Easy to follow steps | Community metrics'),
    t('paprika-ai','Paprika','food','Recipe manager and meal planner with AI for web scraping recipes.','https://paprikaapp.com',false,true,45000, freeTier:'Free trial for cloud sync', price:5, priceTier:'One-time purchase (iOS/Android)', tips:'Best recipe manager | One-tap recipe download | Grocery list sync'),
    t('supercook-ai','SuperCook','food','AI recipe search engine that finds meals you can make with what you have.','https://supercook.com',true,true,58000, freeTier:'Completely free forever', price:0, tips:'Reduce food waste | Enter your pantry items | Instant recipe finding'),
    t('chefsteps-ai','ChefSteps','food','High-end cooking resource with AI-powered guides and science.','https://chefsteps.com',true,false,18000, freeTier:'Free basic recipes', price:7, priceTier:'Studio monthly', tips:'Sous-vide specialists | Molecular gastronomy | Very high video quality'),

    // ━━━ TRAVEL ACCESSORIES ━━━
    t('priority-pass-ai','Priority Pass','travel','Global airport lounge network with AI-powered lounge discovery.','https://prioritypass.com',false,true,120000, freeTier:'Included with many credit cards', price:99, priceTier:'Standard annual price', tips:'1500+ lounges globally | AI suggests best lounge nearby | Includes spa and dining'),
    t('loungebuddy-ai','LoungeBuddy (Amex)','travel','AI-powered airport lounge access and community reviews.','https://loungebuddy.com',true,true,45000, freeTier:'Free to use on web/app', price:0, tips:'Owned by Amex | Check lounge access rules | Book one-time passes'),
    t('mobile-passport-ai','Mobile Passport Control','travel','Official US Customs app with AI for faster border entry.','https://cbp.gov/travel',true,true,58000, freeTier:'Completely free forever', price:0, tips:'Skip the line at many US airports | Official government app | Secure and fast'),
    t('airhelp-ai','AirHelp','travel','AI-powered flight compensation service for delayed or canceled flights.','https://airhelp.com',true,false,35000, freeTier:'Free to check eligibility', price:35, priceTier:'Service fee on success (35%)', tips:'Get up to \$650 back | AI handles the legal work | No win, no fee'),
    t('seatguru-ai','SeatGuru (TripAdvisor)','travel','AI-powered airplane seating maps and advice for travelers.','https://seatguru.com',true,false,62000, freeTier:'Completely free forever', price:0, tips:'Identify the best/worst seats | Links to flight alerts | Travel community expert'),
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
