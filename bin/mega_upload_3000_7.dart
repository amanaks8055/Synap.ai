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
    // ━━━ AI FOR NICHE HOBBIES (Pro/Passion) ━━━
    t('stellarium-plus-ai','Stellarium Plus','science','A powerful planetarium app for astronomy fans with AI-powered sky simulation.','https://stellarium-labs.com',true,true,120000, freeTier:'Free web version available', price:10, priceTier:'Plus one-time purchase', tips:'Identify any star with your phone camera | AI-powered "Telescope" control | Best UI'),
    t('sky-view-ai-sky','SkyView','science','Identify stars and constellations in real-time using AI and augmented reality.','https://terminaleleven.com',true,true,250000, freeTier:'Free basic version available', price:2, priceTier:'Explore one-time', tips:'Best for casual stargazing | AI-powered "Time Travel" to see past sky | Fun'),
    t('magic-pro-ai-tools','Theory11 (Magic)','entertainment','Leading production for magic tools and instructional data with AI search.','https://theory11.com',true,true,58000, freeTier:'Free articles on magic history', price:0, tips:'Industry standard for pro magicians | AI-powered "Forum" | High-end production'),
    t('ellusionist-ai','Ellusionist','entertainment','Pioneer in high-end magic training and tools with AI-powered discovery.','https://ellusionist.com',true,false,45000, freeTier:'Free tutorials daily', price:0, tips:'Curated for modern magicians | AI-powered "Training" paths | Best for tricks'),
    t('board-game-geek-ai','BoardGameGeek','entertainment','The world\'s largest board game database with AI-powered "For You" lists.','https://boardgamegeek.com',true,true,999999, freeTier:'Completely free to use', price:0, tips:'Track 100k+ games | AI-powered "Ranking" system | Massive community wiki'),
    t('chess-pro-ai-coach','Chess.com (AI)','entertainment','The #1 place to play chess online with AI-powered "Game Review" and bots.','https://chess.com',true,true,999999, freeTier:'Free unlimited games', price:8, priceTier:'Gold monthly', tips:'AI-powered "Review" explains every move | play against Grandmaster bots | Pro choice'),
    t('lichess-ai-pro','Lichess','entertainment','Free and open-source chess platform with AI-powered analysis engines.','https://lichess.org',true,true,500000, freeTier:'Completely free forever', price:0, tips:'No ads ever | AI-powered "Stockfish" for analysis | Best for hardcore players'),
    t('fish-brain-ai','Fishbrain','lifestyle','The world\'s most popular fishing app with AI-powered "What to catch" data.','https://fishbrain.com',true,true,180000, freeTier:'Free basic version available', price:10, priceTier:'Pro monthly', tips:'Track catch locations with AI | Best for local fishing reports | Huge community'),
    t('all-trails-ai-hiking','AllTrails','lifestyle','Leading hiking and trail app with AI-powered path reviews and safety.','https://alltrails.com',true,true,999999, freeTier:'Free basic version forever', price:3, priceTier:'Plus monthly annual', tips:'Find Every trail in the world | AI-powered "Navigator" | Offline GPS pro'),
    t('komoot-ai-advent','komoot','lifestyle','Leading route planner for cycling and hiking with AI-powered "Highlights".','https://komoot.com',true,true,350000, freeTier:'Free first region forever', price:5, priceTier:'Premium monthly', tips:'Best for unique European adventures | AI-powered road surfaces | Clean UI'),

    // ━━━ AI FOR ADULT EDUCATION & PHD PREP ━━━
    t('scholar-ai-pro','Scholarcy','education','Leading AI-powered summarizer for academic papers and PhD research.','https://scholarcy.com',true,true,45000, freeTier:'Free basic chrome extension', price:8, priceTier:'Personal monthly', tips:'Turn long papers into summary flashcards with AI | Best for grad students | Fast'),
    t('scite-ai-research','scite','education','Leading AI-powered citation tool that explains how papers cite each other.','https://scite.ai',true,true,58000, freeTier:'Free trial available', price:20, priceTier:'Individual monthly', tips:'AI verifies scientific claims | Smart citations | High academic trust'),
    t('elicit-ai-scientist','Elicit','science','The AI research assistant that automates literature review and data extraction.','https://elicit.com',true,true,120000, freeTier:'Free trial credits', price:12, priceTier:'Plus monthly annual', tips:'AI-powered "Literature Review" | Best for PhDs | High accuracy on science'),
    t('consensus-ai-pro','Consensus','science','Search engine that uses AI to find answers based on peer-reviewed research.','https://consensus.app',true,true,84000, freeTier:'Free basic version', price:9, priceTier:'Premium monthly annual', tips:'Evidence-based search with AI | Best for health and science | No fluff'),
    t('perplexity-pro-sci','Perplexity (Pro)','productivity','Leading AI search engine with specialized "Academic" mode for research.','https://perplexity.ai',true,true,999999, freeTier:'Free unlimited basic search', price:20, priceTier:'Pro monthly', tips:'AI cites all sources | Academic focus | Fastest way to learn anything'),
    t('connected-papers','Connected Papers','science','Visual tool to help researchers find and explore related academic papers.','https://connectedpapers.com',true,true,45000, freeTier:'Free basic graph search', price:0, tips:'Map your niche with AI-powered graphs | Discover hidden papers | Clean UI'),
    t('zotero-ai-cite','Zotero','education','Leading open-source reference manager with AI-powered bibliography help.','https://zotero.org',true,true,250000, freeTier:'Completely free open source', price:0, tips:'Industry standard for academics | Thousands of plugins | Private and secure'),
    t('mendeley-ai-pro','Mendeley (Elsevier)','education','Leading academic social network and reference manager with AI data.','https://mendeley.com',true,true,350000, freeTier:'Free basic account and 2GB space', price:0, tips:'Owned by Elsevier | AI-powered "Reader" | Best for large libraries'),
    t('research-gate-ai','ResearchGate','science','The professional network for scientists with AI-powered data sharing.','https://researchgate.net',true,true,999999, freeTier:'Completely free for researchers', price:0, tips:'Connect with 25M+ scientists | AI-powered "Stats" for your work | Essential'),
    t('academia-edu-pro','Academia.edu','education','Global platform for sharing academic research with AI-powered alerts.','https://academia.edu',true,true,500000, freeTier:'Free basic account', price:10, priceTier:'Premium monthly', tips:'Best for finding niche papers | AI-powered mentions tracking | Massive scale'),

    // ━━━ AI FOR REAL ESTATE v4 (Europe & LATAM) ━━━
    t('idealista-ai-pro','idealista','business','Leading real estate portal in Italy, Spain, and Portugal with AI data.','https://idealista.com',true,true,350000, freeTier:'Completely free to browse', price:0, tips:'Southern Europe leader | AI-powered price analysis | Mobile first'),
    t('immobiliare-ai-pro','Immobiliare.it','business','The #1 real estate portal in Italy with AI-powered valuation and search.','https://immobiliare.it',true,true,180000, freeTier:'Completely free for users', price:0, tips:'Best for Italian property | AI-powered neighborhood data | High trust'),
    t('seloger-ai-pro','SeLoger','business','The most popular real estate portal in France using AI for listings.','https://seloger.com',true,true,250000, freeTier:'Completely free to use', price:0, tips:'French market leader | AI-powered "Estimation" | Large and reliable'),
    t('immoscout-ai-pro','ImmoScout24','business','Leading real estate marketplace in Germany with AI-powered tools.','https://immobilienscout24.de',true,true,500000, freeTier:'Completely free to browse', price:15, priceTier:'Plus monthly', tips:'Germany\'s giant | AI-powered "Schufa" integration | Best for rentals'),
    t('vivareal-ai-pro','VivaReal','business','Leading real estate platform in Brazil with AI-powered "Smart Match".','https://vivareal.com.br',true,true,150000, freeTier:'Completely free for users', price:0, tips:'Brazil\'s market leader | AI-powered location data | Reliable and fast'),
    t('zap-imoveis-ai','ZAP Imóveis','business','Leading property portal in Brazil with AI-powered valuations.','https://zapimoveis.com.br',true,true,120000, freeTier:'Completely free to use', price:0, tips:'Part of OLX Group | AI-powered "ZAP Estimate" | Huge database'),
    t('metroscubicos-ai','Metroscúbicos','business','Leading real estate portal in Mexico using AI for market trends and data.','https://metroscubicos.com',true,false,84000, freeTier:'Completely free to browse', price:0, tips:'Owned by Mercado Libre | AI-powered search | Mexican market leader'),
    t('inmuebles24-ai-pro','Inmuebles24','business','Leading property platform in Mexico and Argentina with AI search.','https://inmuebles24.com',true,false,58000, freeTier:'Completely free to use', price:0, tips:'Part of QuintoAndar | AI-powered neighborhood data | Reliable'),
    t('properati-ai-pro','Properati','business','Leading real estate portal in Colombia and Ecuador with AI stats.','https://properati.com.co',true,false,45000, freeTier:'Completely free to browse', price:0, tips:'Best for Andean region | AI-powered data visualization | high trust'),
    t('urbania-ai-pro','Urbania','business','Leading real estate platform in Peru using AI for verified listings.','https://urbania.pe',true,false,35000, freeTier:'Completely free to use', price:0, tips:'Market leader in Peru | AI-powered "Urbania" valuation | fast and clean'),

    // ━━━ AI FOR CRYPTO & WEB3 v3 ━━━
    t('binance-ai-pro','Binance (AI)','business','The world\'s largest crypto exchange with AI-powered "Sensei" tutor.','https://binance.com',true,true,999999, freeTier:'Free basic exchange account', price:0, tips:'AI-powered "Sensei" chatbot for learning | Deep market data | Highest liquidity'),
    t('coinbase-ai-pro','Coinbase (AI)','business','Leading US crypto platform with AI-powered security and data help.','https://coinbase.com',true,true,999999, freeTier:'Free basic account for users', price:30, priceTier:'Coinbase One monthly', tips:'Most trusted in US | AI-powered "Security Balance" | Easy to use for beginners'),
    t('kraken-ai-pro','Kraken','business','Leading secure crypto exchange with AI-powered trading and data.','https://kraken.com',true,true,350000, freeTier:'Free basic trading account', price:0, tips:'Best for security enthusiasts | AI-powered "Pro" tools | Global presence'),
    t('coingecko-ai-pro','CoinGecko','business','Leading crypto market data platform with AI-powered "GeckoTerminal".','https://coingecko.com',true,true,500000, freeTier:'Completely free to use', price:10, priceTier:'Premium monthly', tips:'Best for new token data | AI-powered "Candy" rewards | Millions of users'),
    t('coinmarketcap-ai','CoinMarketCap','business','The most popular crypto data site with AI-powered "Search" and news.','https://coinmarketcap.com',true,true,999999, freeTier:'Completely free for everyone', price:0, tips:'Owned by Binance | AI-powered "Price Estimates" | Industry standard'),
    t('nansen-ai-pro','Nansen','business','High-end blockchain analytics platform using AI for "Smart Money" labels.','https://nansen.ai',true,true,84000, freeTier:'Free basic dashboard online', price:99, priceTier:'Standard monthly base', tips:'Best for pro traders | AI identifies whale wallets | High alpha signal'),
    t('dune-ai-pro','Dune Analytics','business','Community-powered crypto data with AI-powered "DuneSQL" tools.','https://dune.com',true,true,150000, freeTier:'Free basic public dashboards', price:400, priceTier:'Pro monthly base', tips:'Best for custom reports | AI generates SQL for you | Open data focus'),
    t('chainalysis-ai','Chainalysis','business','Leading crypto investigation platform used by gov and banks with AI.','https://chainalysis.com',false,true,45000, freeTier:'Institutional only', price:0, tips:'Industry standard for compliance | AI identies illicit flow | highly secure'),
    t('arkham-ai-pro','Arkham Intelligence','business','Crypto intelligence platform using AI to "Deanonymize" the blockchain.','https://arkhamintelligence.com',true,true,120000, freeTier:'Completely free for users (Beta)', price:0, tips:'AI-powered "ULTRA" engine | Track any entity with AI | Viral and high tech'),
    t('the-graph-ai-pro','The Graph','code','Decentralized indexing protocol for Web3 with AI-powered "Subgraphs".','https://thegraph.com',true,true,58000, freeTier:'Free for developers credits', price:0, tips:'The Google of Web3 | AI-powered data queries | Crucial for dApps'),

    // ━━━ FINAL GEMS v17 (SaaS Tools) ━━━
    t('intercom-fin-ai','Intercom Fin','marketing','Leading customer service AI bot that resolves 50%+ of issues instantly.','https://intercom.com/fin',true,true,180000, freeTier:'Free trial available', price:0, tips:'Most advanced customer AI | AI-powered "Articles" helper | Integrated in chat'),
    t('zendesk-ai-pro','Zendesk AI','marketing','The industry standard for customer support with AI-powered "Advantage".','https://zendesk.com',true,true,250000, freeTier:'30-day free trial', price:19, priceTier:'Self-service monthly', tips:'AI-powered "Macro" suggestions | Huge scale | Best for enterprise'),
    t('freshdesk-ai-pro','Freshdesk (Freddy)','marketing','Omnichannel customer support with AI-powered Freddy for automation.','https://freshworks.com/freshdesk',true,true,150000, freeTier:'Free for up to 10 agents', price:15, priceTier:'Growth monthly', tips:'Part of Freshworks | AI-powered "Snooze" and "Tagging" | easy and clean'),
    t('drift-ai-chat-pro','Drift','marketing','Leading conversational marketing platform using AI for lead gen.','https://drift.com',false,true,84000, freeTier:'Demo available', price:0, tips:'AI-powered "Buid with AI" bots | High performance sales | Strategic'),
    t('front-ai-mailbox','Front','marketing','Collaborative customer operations platform with AI-powered triage.','https://front.com',true,true,58000, freeTier:'7-day free trial on site', price:19, priceTier:'Starter per seat monthly', tips:'Best for shared inboxes | AI-powered "Drafts" | clean and fast'),
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
