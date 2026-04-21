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
    // ━━━ AI FOR CREATIVE APPS (Iconic) ━━━
    t('procreate-ai-pro','Procreate','design','Leading digital illustration app for iPad with powerful AI-powered brushes.','https://procreate.com',false,true,999999, freeTier:'No free tier', price:13, priceTier:'One-time purchase', tips:'Best for digital artists | AI-powered "Streamline" | Apple Design winner'),
    t('sketch-book-ai','Sketchbook','design','Professional sketching app for everyone with AI-powered stroke help.','https://sketchbook.com',true,true,500000, freeTier:'Free basic version available', price:2, priceTier:'Pro one-time', tips:'Best for conceptual art | AI-powered "Perspective" guide | Clean UI'),
    t('affinity-ai-pro','Affinity Photo','design','Leading professional photo editor with AI-powered non-destructive tools.','https://serif.com',true,true,350000, freeTier:'30-day free trial', price:70, priceTier:'One-time purchase', tips:'Owned by Canva | AI-powered "Selection" | no subscription model'),
    t('clip-studio-ai','Clip Studio Paint','design','The world\'s #1 comic and manga creation software using AI for poses.','https://clipstudio.net',true,true,250000, freeTier:'Free trial available', price:5, priceTier:'Monthly starting', tips:'AI-powered "Pose" generator | Best for manga artists | Millions of users'),
    t('corel-draw-ai','CorelDRAW (AI)','design','Leading vector illustration with AI-powered "LiveSketch" and images.','https://coreldraw.com',true,true,180000, freeTier:'15-day free trial on site', price:35, priceTier:'Subscription monthly', tips:'Industry standard for signs | AI-powered "Vector" help | Robust'),
    t('paint-shop-ai','PaintShop Pro','design','Powerful photo editor using AI to upscale and denoise at scale.','https://paintshoppro.com',false,true,120000, freeTier:'Free trial available', price:80, priceTier:'One-time purchase', tips:'Owned by Corel | AI-powered "Face" tools | established brand'),
    t('manga-studio-ai','Manga Studio (Legacy)','design','The original professional manga creation tool with AI-powered speed.','https://mangastudio.com',false,false,45000, freeTier:'Legacy support only', price:0, tips:'Industry legend | AI-powered "Screen Tone" | reliable'),
    t('art-rage-ai-pro','ArtRage','design','Natural media digital painting app with AI-powered oil and canvas physics.','https://artrage.com',true,true,58000, freeTier:'Free basic version available', price:80, priceTier:'One-time purchase', tips:'Identify as a real artist | AI-powered "Canvas" feel | high quality'),
    t('k-rita-ai-pro','Krita','design','Leading professional open-source painting program with AI plugins.','https://krita.org',true,true,500000, freeTier:'Completely free forever', price:0, tips:'Best for concept artists | AI-powered "Stabilizers" | Community focused'),
    t('ink-scape-ai-pro','Inkscape','design','Leading open-source vector graphics editor with AI-powered path tools.','https://inkscape.org',true,true,350000, freeTier:'Completely free forever', price:0, tips:'The SVG gold standard | AI-powered "Node" editing | Global community'),

    // ━━━ AI FOR REAL ESTATE & TRAVEL (Global Niche) ━━━
    t('property-finder-ai','Property Finder','business','Leading real estate portal in MENA (UAE, Qatar) with AI-powered data.','https://propertyfinder.ae',true,true,250000, freeTier:'Completely free to browse', price:0, tips:'Middle East market leader | AI-powered "Verified" listings | High trust'),
    t('bayut-ai-pro-uae','Bayut','business','Leading property portal in UAE with AI-powered "TruCheck" and visuals.','https://bayut.com',true,true,180000, freeTier:'Completely free for the public', price:0, tips:'Best for Dubai property | AI-powered "Floor Plans" | Revolutionary'),
    t('dubizzle-ai-pro','dubizzle','business','Leading classifieds in UAE using AI for fraud detection and auctions.','https://dubizzle.com',true,true,350000, freeTier:'Completely free basic listings', price:0, tips:'Best for motors and property | AI-powered "Fair Price" | Massive reach'),
    t('property-guru-ai','PropertyGuru','business','Leading real estate portal in Singapore, Malaysia, and SEA.','https://propertyguru.com.sg',true,true,250000, freeTier:'Completely free for users', price:0, tips:'Southeast Asia leader | AI-powered "Market Insights" | High trust'),
    t('ddproperty-ai','DDproperty','business','Leading property search in Thailand using AI for local neighborhood data.','https://ddproperty.com',true,true,120000, freeTier:'Completely free to use', price:0, tips:'Thailand market leader | AI-powered "Search" | Reliable'),
    t('rumah-123-ai-pro','Rumah123','business','Indonesia\'s leading property platform using AI for personalized discovery.','https://rumah123.com',true,false,84000, freeTier:'Completely free to browse', price:0, tips:'Indonesia marketplace leader | AI-powered "Chat" | Huge database'),
    t('proptr-ai-india','PropertyTiger','business','Leading property search and data in India with AI-powered price tools.','https://propertytiger.in',true,false,45000, freeTier:'Completely free for users', price:0, tips:'Best for new Indian developments | AI-powered "Trends" | High trust'),
    t('makaan-ai-pro','Makaan','business','Digital real estate marketplace in India using AI for property scores.','https://makaan.com',true,true,150000, freeTier:'Completely free to use', price:0, tips:'Owned by PropTiger/REA | AI-powered "Seller" ratings | Clean UI'),
    t('traveloka-ai-pro','Traveloka','lifestyle','Southeast Asia\'s leading travel platform for flight and stay using AI.','https://traveloka.com',true,true,500000, freeTier:'Free app for users', price:0, tips:'Best for SEA travel | AI-powered "PayLater" | Multi-service Giant'),
    t('ctrip-ai-pro-trip','Trip.com (Ctrip)','lifestyle','Leading global travel agency giant with AI-powered 24/7 service.','https://trip.com',true,true,999999, freeTier:'Free app and membership', price:0, tips:'World\'s largest OTA | AI-powered "Price Match" | Best for China/Asia'),

    // ━━━ AI FOR MINORITY LANGUAGES & LINGUISTICS ━━━
    t('first-voices-ai','FirstVoices','education','Leading platform for Indigenous language archiving with AI-powered search.','https://firstvoices.com',true,true,12000, freeTier:'Completely free forever', price:0, tips:'Saves endangered languages with AI | Community driven | Global jewel'),
    t('indig-ai-lang','Indig-AI','education','AI-powered platform for revitalization of Indigenous languages globally.','https://indigai.com',true,false,8400, freeTier:'Completely free for communities', price:0, tips:'AI-powered "Chat" in native tongues | Cultural focus | Revolutionary'),
    t('say-it-ai-lang','Say It (Aboriginal)','education','AI-powered app for learning Aboriginal and Torres Strait Islander languages.','https://sayit.com.au',true,false,5600, freeTier:'Free for educational use', price:0, tips:'Best for Oz indigenous languages | AI-powered "Pronounce" | high trust'),
    t('tato-eba-ai-lang','Tatoeba','education','Massive open database of sentences and translations with AI help.','https://tatoeba.org',true,true,120000, freeTier:'Completely free forever', price:0, tips:'Infinite language examples | AI-powered "Correction" | Community wiki'),
    t('etym-online-ai','Etymonline','education','The world\'s #1 etymology search engine using AI for complex histories.','https://etymonline.com',true,true,999999, freeTier:'Completely free to search', price:0, tips:'Identify word origins in seconds | AI-powered "Related" words | Iconic'),
    t('wiktionary-ai-pro','Wiktionary','education','The collaborative dictionary project with AI-powered translation tools.','https://wiktionary.org',true,true,999999, freeTier:'Completely free forever', price:0, tips:'Access 7M+ definitions | AI-powered "Language" links | Global community'),
    t('urban-dict-ai-pro','Urban Dictionary','lifestyle','Leading source for slang and cultural language using AI for discovery.','https://urbandictionary.com',true,true,999999, freeTier:'Completely free to use', price:0, tips:'Stay current with AI-powered "Trends" | Crowdsourced and viral | essential'),
    t('ethnologue-ai-pro','Ethnologue','science','The world standard for language data and health using high-end AI labs.','https://ethnologue.com',true,true,35000, freeTier:'Limited free data online', price:480, priceTier:'Full access yearly', tips:'Most authoritative language data | AI-powered "Viability" scores | SIL Global'),
    t('sil-global-ai','SIL International','science','Leading non-profit using AI/linguistics to serve minority communities.','https://sil.org',true,true,58000, freeTier:'Completely free resources', price:0, tips:'AI-powered "Translation" software | Global leader in linguistics | Non-profit'),
    t('glotto-log-ai-pro','Glottolog','science','Comprehensive database of world languages with AI-powered bibliography.','https://glottolog.org',true,false,12000, freeTier:'Completely free forever', price:0, tips:'Academic standard for language ID | AI-powered "Mapping" | MPI based'),

    // ━━━ AI FOR GOVERNMENT & PATENTS v2 ━━━
    t('wipo-ai-pro-data','WIPO (Digital)','business','World Intellectual Property Organization with AI-powered patent search.','https://wipo.int',true,true,250000, freeTier:'Completely free open data', price:0, tips:'AI-powered "PatentScope" | Global trademark database | International leader'),
    t('uspto-ai-pro-data','USPTO (AI)','business','US Patent and Trademark Office using AI for search and examination.','https://uspto.gov',true,true,500000, freeTier:'Completely free open archives', price:0, tips:'Official US portal | AI-powered "Image" trademark search | Essential'),
    t('google-patents-ai','Google Patents','business','The easiest way to search global patents with AI-powered prior art help.','https://patents.google.com',true,true,999999, freeTier:'Completely free forever', price:0, tips:'AI-powered "Prior Art" search | Best UI in intellectual property | Reliable'),
    t('espacenet-ai-pro','Espacenet (EPO)','business','European Patent Office platform with AI-powered translations and search.','https://worldwide.espacenet.com',true,true,250000, freeTier:'Completely free open data', price:0, tips:'Access 150M+ patents | AI-powered "Smart Search" | European leader'),
    t('lens-org-ai-pro','The Lens','science','Leading open platform for patent and scholarly data using AI analytics.','https://lens.org',true,true,84000, freeTier:'Completely free for the public', price:0, tips:'Find links between science and patents | AI-powered "Metrics" | Non-profit'),

    // ━━━ FINAL GEMS v25 (Modern Commerce) ━━━
    t('shopify-magic-ai','Shopify Magic','code','Built-in AI toolkit for product copy, store operations, and commerce workflows.','https://shopify.com/magic',true,true,58000, freeTier:'Included with Shopify plans', price:29, priceTier:'Basic monthly', tips:'Native Shopify integration | AI product and marketing assist | Reliable brand assets'),
    t('vendure-ai-pro-dev','Vendure','code','Headless commerce framework in TypeScript with AI-powered search help.','https://vendure.io',true,true,35000, freeTier:'Completely free open source', price:0, tips:'Best for Next.js e-com | AI-powered "Product" data | Developer focus'),
    t('strapi-ai-pro-cms','Strapi','code','Leading open-source headless CMS with AI-powered content and SEO help.','https://strapi.io',true,true,180000, freeTier:'Free forever community version', price:0, tips:'The industry standard for headless | AI-powered "API" help | Clean and fast'),
    t('payload-ai-pro-cms','Payload CMS','code','Modern TypeScript headless CMS and app framework with AI-powered sync.','https://payloadcms.com',true,true,58000, freeTier:'Free for individuals and projects', price:0, tips:'Best for engineering teams | AI-powered "Database" help | blazingly fast'),
    t('ghost-ai-pro-pub','Ghost','marketing','The world\'s #1 open-source publishing platform with AI-powered SEO help.','https://ghost.org',true,true,250000, freeTier:'Free open source for self host', price:9, priceTier:'Starter monthly', tips:'Best for newsletters and blogs | AI-powered "Member" insights | Premium UI'),
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
