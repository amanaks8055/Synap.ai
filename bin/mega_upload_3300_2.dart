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
    // ━━━ AI FOR SPORTS ANALYTICS v3 ━━━
    t('espn-ai-stats','ESPN (AI)','entertainment','Leading sports network with AI-powered "Predictor" and game stats.','https://espn.com',true,true,999999, freeTier:'Completely free to use', price:0, tips:'AI-powered win probabilities | Live scores and news | World leader in sports data'),
    t('nba-ai-pro-data','NBA (AI)','entertainment','Official NBA platform with AI-powered "CourtOptix" and advanced data.','https://nba.com',true,true,500000, freeTier:'Free basic stats and news', price:0, tips:'AI-powered player movement data | Best for basketball fans | reliable'),
    t('nfl-ai-next-gen','NFL Next Gen Stats','entertainment','Leading football data platform using AI and AWS for real-time tracking.','https://nfl.com/nextgenstats',true,true,350000, freeTier:'Completely free for the public', price:0, tips:'Powered by AWS | AI measures speed and separation | Pro football standard'),
    t('mlb-ai-pro-data','MLB (AI)','entertainment','Leading baseball platform with AI-powered "StatCast" and player help.','https://mlb.com',true,true,250000, freeTier:'Free basic stats', price:0, tips:'AI-powered pitch and hit tracking | Best for baseball nerds | Reliable'),
    t('pff-ai-pro-stats','PFF (Pro Football Focus)','entertainment','The world\'s most thorough football data using AI-powered grading.','https://pff.com',true,true,120000, freeTier:'Free basic articles', price:10, priceTier:'Premium monthly', tips:'The gold standard for NFL/CFB grades | AI-powered "Mock Draft" | high trust'),
    t('draft-kings-ai','DraftKings (AI)','entertainment','Leading gaming platform with AI-powered "Predictive" betting and help.','https://draftkings.com',true,true,500000, freeTier:'Free to join and browse', price:0, tips:'AI-powered "Live Betting" | Best for DFS and Sportsbook | Secure and fast'),
    t('fan-duel-ai-pro','FanDuel','entertainment','Leading mobile gaming giant using AI for fantasy and sportsbook data.','https://fanduel.com',true,true,450000, freeTier:'Free to join', price:0, tips:'AI-powered "Smart Pick" | Best for casual and pro players | Global reach'),
    t('action-network-ai','Action Network','entertainment','Leading sports betting data platform with AI-powered "Pro" tools.','https://actionnetwork.com',true,true,150000, freeTier:'Free basic tracking', price:20, priceTier:'Pro monthly', tips:'Best for betting analytics | AI-powered "Line Movements" | Pro level signals'),
    t('bet-mgm-ai-pro','BetMGM','entertainment','Leading casino and sports betting platform with AI-powered security.','https://betmgm.com',true,true,180000, freeTier:'Free to join', price:0, tips:'Part of MGM Resorts | AI-powered Personalized offers | Trusted brand'),
    t('caesar-sports-ai','Caesars Sportsbook','entertainment','Iconic gaming brand with AI-powered loyalty and betting features.','https://williamhill.com',true,false,120000, freeTier:'Free to browse', price:0, tips:'Best for rewards members | AI-powered "Odds" boost | Reliable'),

    // ━━━ AI FOR POKER & SKILL GAMES ━━━
    t('gtowizard-ai-pro','GTO Wizard','entertainment','The world\'s #1 poker solver platform using high-end AI for GTO play.','https://gtowizard.com',true,true,84000, freeTier:'1 free solution per day', price:49, priceTier:'Starter monthly', tips:'The gold standard for pro poker | AI-powered "Trainer" is incredible | High speed'),
    t('solver-ai-pro','Solver+','entertainment','Powerful mobile poker solver using AI to calculate optimal strategies.','https://solverplus.com',true,false,35000, freeTier:'Free basic version', price:15, priceTier:'Premium monthly', tips:'Best for on-the-go study | AI-powered "Rang" charts | robust and clean'),
    t('poker-tracker-ai','PokerTracker','entertainment','Leading tool for tracking and analyzing your poker hands with AI.','https://pokertracker.com',false,true,58000, freeTier:'30-day free trial on site', price:100, priceTier:'One-time purchase license', tips:'Industry standard since 2001 | AI-powered "Leak Tracker" | Robust data'),
    t('holdem-manager-ai','Hold\'em Manager','entertainment','Leading poker analytics and HUD software with AI-powered insights.','https://holdemmanager.com',false,true,45000, freeTier:'30-day free trial', price:100, priceTier:'One-time purchase license', tips:'Best for pro multi-tabling | AI-powered "Opponent" analysis | reliable'),
    t('run-it-once-ai','Run It Once (Training)','education','Learn from the world\'s best poker pros with AI-powered study tools.','https://runitonce.com',true,true,35000, freeTier:'Free basic videos', price:25, priceTier:'Essential monthly', tips:'Founded by Phil Galfond | AI-powered "Vision" solver | Best for high stakes'),
    t('upswing-poker-ai','Upswing Poker','education','Leading poker training site with AI-powered "Preflop" and GTO tools.','https://upswingpoker.com',true,true,28000, freeTier:'Free basic quizzes', price:99, priceTier:'Monthly membership', tips:'Home of Doug Polk | AI-powered "Postflop" training | high quality focus'),
    t('solve-for-why-ai','Solve For Why','education','Unique poker training focused on logic and AI-powered strategy.','https://solveforwhy.io',true,false,12000, freeTier:'Free basic videos', price:0, tips:'Led by Matt Berkey | AI-powered "Academy" | Intellectual poker focus'),
    t('poker-stars-ai','PokerStars (AI)','entertainment','The world\'s largest online poker room with AI-powered security.','https://pokerstars.com',true,true,999999, freeTier:'Completely free play money', price:0, tips:'Best for global tournaments | AI-powered "Game Integrity" | Iconic'),
    t('gg-poker-ai-pro','GGPoker','entertainment','Fastest growing poker site with AI-powered "Smart HUD" and data.','https://ggpoker.com',true,true,500000, freeTier:'Free play money available', price:0, tips:'Best mobile app UI | AI-powered "Staking" system | Viral events'),
    t('party-poker-ai','PartyPoker','entertainment','Leading secure poker platform with AI-powered fair-play tech.','https://partypoker.com',true,false,150000, freeTier:'Free to join and play', price:0, tips:'Focus on recreational players | AI-powered "Identity" check | safe'),

    // ━━━ AI FOR CREATORS & SOCIAL v3 ━━━
    t('link-tree-ai-pro','Linktree','marketing','The original link-in-bio platform with AI-powered customization.','https://linktr.ee',true,true,999999, freeTier:'Completely free basic version', price:5, priceTier:'Starter monthly', tips:'Used by 40M+ creators | AI-powered "Analytic" insights | The industry standard'),
    t('be-acons-ai-pro','Beacons','marketing','AI-powered creator platform for link-in-bio, shops, and email.','https://beacons.ai',true,true,250000, freeTier:'Free forever basic plan', price:10, priceTier:'Pro monthly', tips:'Best for Gen Z creators | AI-powered "Media Kit" builder | fast growing'),
    t('stan-store-ai','Stan Store','marketing','The "All-in-One" creator store using AI for simple sales and data.','https://stan.store',true,true,180000, freeTier:'14-day free trial on site', price:29, priceTier:'Creator monthly', tips:'Best for TikTok and IG sellers | AI-powered "Courses" | clean and fast'),
    t('clipp-ai-pro-crea','Klap','marketing','Leading AI tool that turns long videos into viral TikToks and Reels.','https://klap.app',true,true,84000, freeTier:'Free basic trial', price:29, priceTier:'Startup monthly', tips:'AI picks the most viral moments | Best for podcasters | High engagement'),
    t('opus-clip-ai-pro','OpusClip','marketing','The #1 AI video repurposing tool for short-form video creation.','https://opus.pro',true,true,250000, freeTier:'Free basic credits monthly', price:9, priceTier:'Starter monthly annual', tips:'AI identifies "Hooks" automatically | Best for YouTube creators | Robust'),
    t('captions-ai-pro','Captions.ai','marketing','Leading AI-powered camera app for creators with eye contact and subs.','https://captions.ai',true,true,150000, freeTier:'Free basic version available', price:10, priceTier:'Pro monthly', tips:'AI-powered "Eye Contact" fix is magic | Best for talking heads | High quality'),
    t('vid-yo-ai-pro','Vidyo.ai','marketing','Leading tool for making short videos from long content with AI.','https://vidyo.ai',true,true,120000, freeTier:'Free basic tier (75 mins/mo)', price:15, priceTier:'Pro monthly annual', tips:'Best for LinkedIn and Twitter video | AI-powered "Subtitles" | Reliable'),
    t('sub-magic-ai-pro','Submagic','marketing','AI-powered captions and emojis for viral short-form videos.','https://submagic.co',true,false,84000, freeTier:'Free basic version online', price:20, priceTier:'Basic monthly annual', tips:'Best visual style for Alex Hormozi style subs | AI-powered "Hook" text'),
    t('munch-ai-pro-vid','Munch','marketing','AI-powered video platform for social media growth and monetization.','https://getmunch.com',true,false,58000, freeTier:'Free basic trial', price:49, priceTier:'Pro monthly base', tips:'AI tracks current trends | Best for marketing agencies | high performance'),
    t('jupitrr-ai-pro','Jupitrr','marketing','AI-powered video creator for stock footage and "B-Roll" automation.','https://jupitrr.com',true,false,35000, freeTier:'Free basic version', price:0, tips:'Best for making videos without showing face | AI-powered "B-roll" search'),

    // ━━━ AI FOR E-COMMERCE & RETAIL v3 ━━━
    t('shopify-ai-magic','Shopify Magic','business','Leading e-commerce platform with built-in AI for copy and images.','https://shopify.com/magic',true,true,999999, freeTier:'Included with all Shopify plans', price:39, priceTier:'Basic monthly', tips:'AI-powered "Sidekick" for stores | Best for all e-com | Industry standard'),
    t('amazon-ai-seller','Amazon Seller Central','business','The world\'s largest marketplace tools using AI for listing and data.','https://sellercentral.amazon.com',true,true,999999, freeTier:'Free basic account (pay per sale)', price:40, priceTier:'Professional monthly', tips:'AI-powered "Product Titles" | Most powerful retail data | Global reach'),
    t('ebay-ai-seller','eBay (AI Solutions)','business','Leading marketplace using AI to automate photo background and copy.','https://ebay.com',true,true,999999, freeTier:'Completely free to list basic', price:0, tips:'AI-powered "Magical" listings | Best for vintage and unique | reliable'),
    t('etsy-ai-search','Etsy (AI)','lifestyle','Leading handmade marketplace using AI for visual search and help.','https://etsy.com',true,true,500000, freeTier:'Completely free for buyers', price:0, tips:'AI-powered "Gift Mode" | Best for unique items | Global creator community'),
    t('mercari-ai-sell','Mercari','lifestyle','The "Selling App" with AI-powered instant listing and valuation.','https://mercari.com',true,true,180000, freeTier:'Completely free for the public', price:0, tips:'Best for used home goods | AI-powered photo recognition | Fast selling'),
    t('poshmark-ai-pro','Poshmark','lifestyle','Leading social e-commerce for fashion with AI-powered trends.','https://poshmark.com',true,true,150000, freeTier:'Completely free to browse', price:0, tips:'Best for fashion community | AI-powered "Style" tags | Huge social reach'),
    t('depop-ai-search','Depop','lifestyle','The fashion marketplace for Gen Z with AI-powered discovery.','https://depop.com',true,true,120000, freeTier:'Completely free to use', price:0, tips:'Best for vintage and thrift | AI-powered "Vibe" lists | Viral potential'),
    t('klarna-ai-shop','Klarna','business','Leading BNPL giant using AI for a personalized shopping feed and help.','https://klarna.com',true,true,500000, freeTier:'Completely free app for users', price:0, tips:'AI-powered "Personal Shopper" | Best for deals and budget | European leader'),
    t('affirm-ai-pro','Affirm','business','Leading transparent credit for shopping with AI-powered approvals.','https://affirm.com',true,true,350000, freeTier:'Completely free for the public', price:0, tips:'Best for big ticket items | AI-powered "Risk" scoring | Highly trusted'),
    t('afterpay-ai-shop','Afterpay (Cash App)','business','Leading global retail payments with AI-powered discovery and data.','https://afterpay.com',true,true,250000, freeTier:'Completely free for users', price:0, tips:'Owned by Block | AI-powered "Pulse" rewards | Global scale'),

    // ━━━ FINAL GEMS v21 (Modern Hosting) ━━━
    t('vercel-ai-pro','Vercel','code','The frontend cloud for developers with built-in AI (V0) and speed.','https://vercel.com',true,true,500000, freeTier:'Free for personal hobby use', price:20, priceTier:'Pro per user monthly', tips:'Best for Next.js | AI-powered "V0" UI generator | The gold standard for web'),
    t('netlify-ai-pro','Netlify','code','Leading platform for web development with AI-powered deploy and scale.','https://netlify.com',true,true,350000, freeTier:'Free for personal starters', price:19, priceTier:'Pro per user monthly', tips:'Best for static sites | AI-powered "Composable" tools | Fast and reliable'),
    t('render-ai-pro-cloud','Render','code','The easiest cloud for building and scaling any application with AI.','https://render.com',true,true,180000, freeTier:'Free for personal hobby use', price:0, tips:'Best for full stack apps | AI-powered "Deploy" | modern and simple'),
    t('railway-ai-cloud','Railway','code','Beautiful and simple cloud hosting for developers with AI-powered infra.','https://railway.app',true,true,120000, freeTier:'Free trial with credits', price:5, priceTier:'Developer monthly base', tips:'Fastest way to deploy | AI-powered "Environment" | Blazing fast UI'),
    t('fly-io-ai-edge','Fly.io','code','Deploy app servers close to your users effortlessly with AI help.','https://fly.io',true,true,150000, freeTier:'Free trial for new users', price:0, tips:'Best for low-latency apps | AI-powered "Machines" | Global edge fleet'),
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
