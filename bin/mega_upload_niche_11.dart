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
    // ━━━ AI FOR PATENTS, IP & IP LAW ━━━
    t('anaqua-ai-pro','Anaqua','business','Leading IP management and strategy software with AI-powered analytics and search.','https://anaqua.com',false,true,18000, freeTier:'Institutional only', price:0, tips:'Manage world-class patent portfolios with AI | Integrated IP law data | Global scale'),
    t('clarivate-ai-pro','Clarivate (Derwent)','business','Global leader in trusted intelligence and patent search using high-end AI.','https://clarivate.com',false,true,45000, freeTier:'Demo available', price:0, tips:'Best for academic and patent research | AI-powered "Web of Science" | Reliable data'),
    t('patsnap-ai-pro','PatSnap','business','Connected innovation intelligence platform using AI for patent analysis.','https://patsnap.com',false,true,25000, freeTier:'Free basic version available', price:0, tips:'AI-powered product R&D insights | Map global technology trends | Fast and visual'),
    t('iam-ai-patent','IAM (Patent Intelligence)','business','Leading data and community for the global patent industry with AI tools.','https://iam-media.com',true,false,12000, freeTier:'Free news and basic data', price:0, tips:'Strategic patent intelligence | AI-powered market alerts | Best for IP pros'),
    t('lexis-nexis-ip','LexisNexis PatentSight','business','High-end patent professional software using AI to value global portfolios.','https://lexisnexisip.com',false,true,15000, freeTier:'Institutional only', price:0, tips:'"Patent Asset Index" pioneer | AI identifies high-value patents | Data-driven'),
    t('questel-ai-pro','Questel','business','Comprehensive IP and innovation platform using AI for managing assets.','https://questel.com',false,false,9200, freeTier:'Demo available', price:0, tips:'Leading in patent translation and filing | AI-powered search | European leader'),
    t('innography-ai','Innography (CPA Global)','business','Leading patent search and IP analytics software with AI-powered data mining.','https://innography.com',false,false,5600, freeTier:'Institutional only', price:0, tips:'AI-powered semantic search | Best for IP litigation support | High reliability'),
    t('orbit-intelligence','Orbit Intelligence','business','Leading platform for global research and IP analytics using AI for search.','https://orbit.com',false,true,12000, freeTier:'7-day free trial on request', price:0, tips:'Access 100M+ patents | AI-powered "Family" tracking | Part of Questel'),
    t('ip-checkups-ai','IP Checkups','business','Strategic patent analytics and management using AI for custom reports.','https://ipcheckups.com',false,false,3500, freeTier:'Demo available', price:0, tips:'Best for high-growth tech firms | AI identifies competitors | Data-driven strategy'),
    t('patent-cloud-ai','Patentcloud','business','Cloud-based patent intelligence platform with AI-powered search and value.','https://patentcloud.com',true,true,12000, freeTier:'Free basic version available', price:0, tips:'Powered by InQuartik | AI-powered "Patent Quality" scores | Fast and clean'),

    // ━━━ AI FOR BIOTECH & DRUG DISCOVERY v2 ━━━
    t('insilico-med-2','Insilico Medicine (Pro)','science','Generative AI for target discovery and clinical trial prediction in pharma.','https://insilico.com',false,true,35000, freeTier:'Institutional only', price:0, tips:'First AI-discovered drug in clinical trials | Leading generative biology | Strategic'),
    t('Recursion-ai-pro','Recursion','science','Decoding biology by integrating technology and high-end AI labs at scale.','https://recursion.com',false,true,18000, freeTier:'Institutional only', price:0, tips:'AI-powered drug discovery | Massive industrial scale genomics | Innovative tech'),
    t('schrodinger-ai','Schrödinger','science','Leading platform for molecular simulation and drug discovery using AI.','https://schrodinger.com',false,true,25000, freeTier:'Institutional only', price:0, tips:'The gold standard for chemistry simulation | AI-powered physics models | Reliable'),
    t('atomwise-ai-pro','Atomwise','science','AI-powered platform for small molecule drug discovery using deep learning.','https://atomwise.com',false,true,12000, freeTier:'Institutional only', price:0, tips:'Pioneer in AI for structural biology | Virtual screening at scale | Global partner'),
    t('exscientia-ai','Exscientia','science','Full-stack AI drug discovery company building the hardware and software.','https://exscientia.ai',false,true,15000, freeTier:'Institutional only', price:0, tips:'AI-powered design and clinical trials | Leading in precision medicine | UK based'),
    t('valora-ai-health','Valo Health','health','The first digital pharmacy and health data platform using AI for R&D.','https://valohealth.com',false,false,8400, freeTier:'Institutional only', price:0, tips:'AI-powered "Opal" platform | Real-world data focus | High performance'),
    t('benevolent-ai-pro','BenevolentAI','science','Leading clinical-stage AI platform for discovering medicines for rare diseases.','https://benevolent.com',false,true,12000, freeTier:'Institutional only', price:0, tips:'AI-powered knowledge graph for biology | UK tech leader | Disease focus'),
    t('vir-biotech-ai','Vir Biotechnology','science','Integrating AI and immunology to treat and prevent serious infectious diseases.','https://vir.bio',false,false,9200, freeTier:'Institutional only', price:0, tips:'Leading in monoclonal antibodies with AI | Global health focus | Data-driven'),
    t('deep-genomics-ai','Deep Genomics','science','Combining AI and RNA biology to program the next generation of medicines.','https://deepgenomics.com',false,false,5600, freeTier:'Institutional only', price:0, tips:'AI-powered "AI Workbench" | Deep understanding of genetics | Innovative'),
    t('gritstone-ai-pro','Gritstone Bio','science','AI-powered platform for developing personalized immunotherapies for cancer.','https://gritstonebio.com',false,false,4200, freeTier:'Institutional only', price:0, tips:'AI-powered neoantigen identification | Clinical stage | Cutting-edge biology'),

    // ━━━ AI FOR SPORTS v3 (Betting & Fan Experience) ━━━
    t('bet-on-ai-pro','Action Network (AI)','entertainment','Leading platform for sports betting data and AI-powered "Pro" tools.','https://actionnetwork.com',true,true,250000, freeTier:'Free basic score tracking', price:10, priceTier:'Premium monthly', tips:'AI-powered "PRO" signals | Track every bet | Verified expert insights'),
    t('oddsshark-ai-pro','Odds Shark','entertainment','Leading source for sports betting odds and AI-powered statistical models.','https://oddsshark.com',true,true,180000, freeTier:'Completely free for users', price:0, tips:'Best for NFL and NBA data | AI-powered "Pick" generator | Trusted for 10+ years'),
    t('covers-ai-pro','Covers','entertainment','Sports betting community and data platform with AI-powered tools.','https://covers.com',true,true,150000, freeTier:'Completely free for users', price:0, tips:'Verified betting contests | AI-powered "Streak" contests | Massive community'),
    t('sportradar-ai','Sportradar','business','Global leader in sports data and AI-powered insights for betting.','https://sportradar.com',false,true,84000, freeTier:'Institutional only', price:0, tips:'Official data partner of NBA/NHL/MLB | AI-powered integrity services | Industry leader'),
    t('genius-sports-ai','Genius Sports','business','Leading sports data and technology company with AI-powered fan eng.','https://geniussports.com',false,true,45000, freeTier:'Institutional only', price:0, tips:'Official partner of the NFL | AI-powered tracking and media | Fast data'),
    t('fanduel-ai-pro','FanDuel','entertainment','Leading US sports betting and daily fantasy platform with AI support.','https://fanduel.com',true,true,999999, freeTier:'Free-to-play contests online', price:0, tips:'Best mobile betting UI | AI-powered personalized offers | Fast payouts'),
    t('draftkings-ai','DraftKings','entertainment','Leading platform for daily fantasy sports and betting with AI-powered lines.','https://draftkings.com',true,true,999999, freeTier:'Free basic contests weekly', price:0, tips:'Most famous brand in DFS | AI-powered "DK" assistant | High security'),
    t('bet365-ai-pro','bet365','entertainment','The world\'s most popular online sports betting company with AI-powered app.','https://bet365.com',true,true,999999, freeTier:'Free app for users', price:0, tips:'Largest selection of bets | AI-powered "Bet Builder" | Global leader'),
    t('the-score-ai-pro','theScore','entertainment','Leading sports news and betting app using AI for personalized scores.','https://thescore.com',true,true,500000, freeTier:'Completely free news app', price:0, tips:'Best mobile notification system | AI-powered betting integration | Top tier UX'),
    t('bleacher-report-ai','Bleacher Report','entertainment','Fun and fast-paced sports news and culture app with AI-powered feed.','https://bleacherreport.com',true,true,250000, freeTier:'Completely free news app', price:0, tips:'Personalized by your favorite teams | AI-powered viral summaries | Huge social reach'),

    // ━━━ AI FOR KITCHEN & SMART HOTELS ━━━
    t('june-oven-ai','June Oven','lifestyle','The smart convection oven that uses AI and a camera to cook anything.','https://juneoven.com',false,true,45000, freeTier:'Hardware purchase required', price:10, priceTier:'Premium monthly for recipes', tips:'AI recognizes over 100 foods | Controlled via mobile app | Consistent quality'),
    t('brava-ai-oven','Brava Oven','lifestyle','Leading smart oven using light/heat and AI to cook complete meals.','https://brava.com',false,true,35000, freeTier:'Hardware purchase required', price:0, tips:'3 zones of cooking at once | AI-powered temperature probes | Luxury design'),
    t('tovala-ai-meals','Tovala','lifestyle','Smart oven and meal service with AI-powered QR code cooking.','https://tovala.com',false,true,58000, freeTier:'Hardware purchase required', price:12, priceTier:'Avg per meal starting', tips:'No prep cooking with AI | Scan the barcode and walk away | High quality meals'),
    t('smart-things-ai','Samsung SmartThings','lifestyle','Global smart home platform using AI to automate your appliances.','https://smartthings.com',true,true,999999, freeTier:'Free app for all Samsung users', price:0, tips:'Connect thousands of devices | AI-powered "Smart Hub" | Global industry leader'),
    t('lg-thinq-ai','LG ThinQ','lifestyle','Smart home and appliance platform using AI to anticipate your needs.','https://lg.com/thinq',true,true,500000, freeTier:'Free app for LG owners', price:0, tips:'AI-powered energy saving | Voice control for TV and fridge | Reliable'),
    t('vincit-ai-hotel','Vincit (Hospitality)','business','AI-powered platform for smart hotel automation and guest experience.','https://vincit.com',false,false,5600, freeTier:'Demo available', price:0, tips:'Personalized guest rooms with AI | Automation for cleaning | Modern tech'),
    t('hospitality-ai-net','Hospitality.ai','business','Leading platform for AI-powered chatbots and automation for hotels.','https://hospitality.ai',false,false,4200, freeTier:'Demo available', price:0, tips:'Increase direct bookings with AI | Available in 100+ languages | Fast setup'),
    t('guest-line-ai','Guestline','business','Multi-award winning cloud PMS for hotels with AI-powered revenue.','https://guestline.com',false,false,8400, freeTier:'Demo available', price:0, tips:'Best for independent hotels | AI-powered channel manager | 25+ years exp'),
    t('hotel-hero-ai','HotelHero','business','Leading search and discovery platform for hotel tech using AI.','https://hotelhero.tech',true,false,9200, freeTier:'Completely free to use', price:0, tips:'Find the best hotel software with AI | Comparison tool | Huge community'),
    t('beonprice-ai-pro','Beonprice','business','Leading AI-powered platform for sustainable hotel revenue management.','https://beonprice.com',false,false,3500, freeTier:'Demo available', price:0, tips:'AI-powered "HQI" score | Optimize pricing by guest value | European leader'),

    // ━━━ AI FOR RETAIL v4 (Fraud & Price) ━━━
    t('signifyd-ai-pro','Signifyd','business','Leading 100% guaranteed fraud protection for e-commerce using AI.','https://signifyd.com',false,true,32000, freeTier:'Demo available', price:0, tips:'Approvd or your money back | AI-powered risk signals | Trusted by big brands'),
    t('riskified-ai-pro','Riskified','business','Leading e-commerce fraud prevention and chargeback protection with AI.','https://riskified.com',false,true,28000, freeTier:'Demo available', price:0, tips:'Increase approval rates with AI | frictionless checkout | Global insurance'),
    t('feedvisor-ai-pro','Feedvisor','business','The "Amazon Success" platform using AI for algorithmic pricing.','https://feedvisor.com',false,true,12000, freeTier:'Demo available', price:0, tips:'Best for large Amazon sellers | AI-powered business intel | High performance'),
    t('repricerexpress-ai','Repricer.com','business','The fastest Amazon and eBay repricer using AI to win the buy box.','https://repricer.com',true,true,18000, freeTier:'14-day free trial', price:79, priceTier:'Plus monthly annual', tips:'Formerly RepricerExpress | AI-powered rules | Sync across channels'),
    t('seller-snap-ai','Seller Snap','business','Premium Amazon repricer using high-end game theory and AI tool.','https://sellersnap.io',false,true,9200, freeTier:'15-day free trial', price:250, priceTier:'Standard monthly', tips:'The most advanced logic for Amazon | AI-powered analytics | Win at high price'),
    t('blue-yonder-ai','Blue Yonder (Luminate)','business','World leader in digital supply chain and retail planning with AI.','https://blueyonder.com',false,true,15000, freeTier:'Institutional only', price:0, tips:'Formerly JDA Software | AI-powered retail planning | Massive global scale'),
    t('manhattan-ai-pro','Manhattan Associates','business','Leading supply chain commerce and retail technology with AI.','https://manh.com',false,true,12000, freeTier:'Institutional only', price:0, tips:'Industry standard for high-end warehouse | AI-powered omni-channel | Reliable'),
    t('relex-ai-pro','RELEX Solutions','business','Leading retail and supply chain planning using high-end AI and data.','https://relexsolutions.com',false,true,8400, freeTier:'Institutional only', price:0, tips:'Optimize inventory with AI | Unified retail planning | European leader'),
    t('symphony-ai-pro','SymphonyAI (Retail)','business','Enterprise AI company building solutions for retail and CPG.','https://symphonyai.com',false,false,5600, freeTier:'Institutional only', price:0, tips:'AI-powered store operations | Predictive analytics | Strategic focus'),
    t('standard-ai-checkout','Standard AI','business','Autonomous checkout for retail using computer vision and AI.','https://standard.ai',false,false,4200, freeTier:'Demo available', price:0, tips:'No-checkout shopping with AI | Retrofit existing stores | Privacy first'),

    // ━━━ FINAL GEMS v4 ━━━
    t('groq-ai-fast','Groq (LPU)','code','Leading high-speed AI inference platform for running LLMs at 500+ tok/s.','https://groq.com',true,true,250000, freeTier:'Free basic API playground', price:0, tips:'Fastest AI in the world | Built on LPU technology | Cheap and scalable API'),
    t('together-ai-pro','Together AI','code','Leading platform for training and running open source AI at scale.','https://together.ai',true,true,84000, freeTier:'Free trial credits for devs', price:0, tips:'Run Llama and Mistral with best price | Fast and reliable | High end GPU clouds'),
    t('fireworks-ai-pro','Fireworks AI','code','Leading high-speed inference for generative AI with low latency.','https://fireworks.ai',true,true,58000, freeTier:'Free trial credits for devs', price:0, tips:'Blazing fast API | Developer focused | Robust scaling'),
    t('lambda-labs-ai','Lambda Labs','code','Leading GPU cloud for deep learning and AI trainers with high-end cards.','https://lambdalabs.com',false,true,45000, freeTier:'No free tier', price:0.50, priceTier:'Per hour for A10/A100', tips:'The gold standard for AI hardware | Best prices for NVIDIA GPUs | Trusted by researchers'),
    t('modal-ai-pro','Modal','code','Leading serverless platform for running AI and data workloads at scale.','https://modal.com',true,true,35000, freeTier:'\$30 free monthly credits', price:0, tips:'Python-native infra | Deploy AI in seconds | High performance engineering'),
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
