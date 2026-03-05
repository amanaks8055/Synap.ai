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
    // ━━━ AI FOR ENTERTAINMENT & STREAMING ━━━
    t('netflix-ai-pro','Netflix (AI)','entertainment','Leading streaming platform using AI for personalized content recommendations.','https://netflix.com',true,true,999999, freeTier:'Free trial available (region dependent)', price:7, priceTier:'Standard with ads monthly', tips:'AI perfectly predicts what you want to watch | Best content library | Seamless UX'),
    t('hulu-ai-pro','Hulu','entertainment','Leading streaming service using AI to personalize your TV and movie experience.','https://hulu.com',true,true,350000, freeTier:'1-month free trial', price:8, priceTier:'Basic with ads monthly', tips:'Best for current TV shows | AI-powered personalized hub | Part of Disney'),
    t('disney-plus-ai','Disney+','entertainment','Home of Disney, Pixar, and Marvel with AI-powered discovery and profiles.','https://disneyplus.com',false,true,500000, freeTier:'No free tier', price:8, priceTier:'Basic with ads monthly', tips:'Best for families | AI-powered content signals | Secure and safe for kids'),
    t('max-ai-pro','Max (HBO)','entertainment','Premium streaming service using AI for high-end content recommendations.','https://max.com',false,true,250000, freeTier:'No free tier', price:10, priceTier:'Basic with ads monthly', tips:'Home of HBO and Warner Bros | AI-powered discovery | Premium quality'),
    t('peacock-ai-pro','Peacock (NBC)','entertainment','Leading streaming service using AI for sports and entertainment data.','https://peacocktv.com',true,true,180000, freeTier:'Free basic version available', price:6, priceTier:'Premium monthly', tips:'Best for live news and sports | AI-powered "Catch Up" | Part of NBCUniversal'),
    t('paramount-plus-ai','Paramount+','entertainment','Leading streaming service using AI for its vast library of movies and TV.','https://paramountplus.com',true,true,150000, freeTier:'1-week free trial', price:6, priceTier:'Essential monthly', tips:'Home of CBS and Star Trek | AI-powered recommendation engine | Reliable'),
    t('apple-tv-plus-ai','Apple TV+','entertainment','Original stories from the best minds using AI for premium discovery.','https://tv.apple.com',true,true,250000, freeTier:'7-day free trial', price:10, priceTier:'Monthly subscription', tips:'Award-winning originals | AI-powered "Up Next" | Best integrated on iOS'),
    t('prime-video-ai','Prime Video','entertainment','Leading streaming and rental platform with AI-powered "X-Ray" data.','https://primevideo.com',true,true,999999, freeTier:'30-day free trial (Prime)', price:9, priceTier:'Standalone monthly', tips:'AI-powered "X-Ray" for cast/songs | Massive rental library | Part of Amazon'),
    t('youtube-premium-ai','YouTube Premium','entertainment','The world\'s largest video platform with AI-powered ad-free and music.','https://youtube.com/premium',true,true,999999, freeTier:'1-month free trial', price:14, priceTier:'Individual monthly', tips:'AI-powered "Smart Downloads" | Ad-free experience | Includes YouTube Music'),
    t('twitch-ai-pro','Twitch','entertainment','Leading live streaming platform with AI-powered moderation and search.','https://twitch.tv',true,true,999999, freeTier:'Completely free to use', price:0, tips:'Best for gaming and live talk | AI-powered "Automod" | Huge global community'),

    // ━━━ AI FOR PODCASTING & SOCIAL AUDIO ━━━
    t('spotify-podcast-ai','Spotify for Podcasters','audio','Leading podcast platform with AI-powered distribution and analytics.','https://podcasters.spotify.com',true,true,500000, freeTier:'Completely free to host', price:0, tips:'AI-powered "Automated Ads" | Direct distribution to Spotify | Easy to use'),
    t('apple-podcast-ai','Apple Podcasts (Connect)','audio','The world\'s largest podcast library with AI-powered discovery.','https://podcasts.apple.com',true,true,250000, freeTier:'Free to listen and host', price:0, tips:'Industry standard | AI-powered "Smart Play" | Seamless on all Apple devices'),
    t('libsyn-ai-pro','Libsyn','audio','The gold standard for professional podcast hosting with AI tools.','https://libsyn.com',false,true,45000, freeTier:'Demo available', price:5, priceTier:'Basic monthly', tips:'Longest running host | AI-powered "Ads" marketplace | Reliable and stable'),
    t('simplecast-ai-pro','Simplecast','audio','Leading podcast hosting and analytics platform with AI-powered player.','https://simplecast.com',true,true,35000, freeTier:'14-day free trial', price:15, priceTier:'Basic monthly', tips:'Beautiful player design | AI-powered analytics | Acquired by SiriusXM'),
    t('transistor-ai-pro','Transistor','audio','Professional podcast hosting for brands and teams with AI-powered site.','https://transistor.fm',true,true,25000, freeTier:'14-day free trial', price:19, priceTier:'Starter monthly', tips:'Unlimited podcasts on one plan | AI-powered "Private" pods | Great for teams'),
    t('podbean-ai-pro','Podbean','audio','All-in-one podcast platform with AI-powered monetization and live.','https://podbean.com',true,true,58000, freeTier:'Free basic plan forever', price:9, priceTier:'Unlimited Audio monthly', tips:'Best for monetization | AI-powered "Dynamic Ad Insertion" | Easy to use'),
    t('buzzsprout-ai-pro','Buzzsprout','audio','The easiest way to start a podcast with AI-powered "Magic Mastering".','https://buzzsprout.com',true,true,84000, freeTier:'Free for up to 2hrs/month', price:12, priceTier:'Standard monthly', tips:'AI-powered "Magic Mastering" for pro sound | Easy to use | Great support'),
    t('riverside-ai-pro','Riverside.fm','audio','The #1 platform for recording studio-quality podcasts and videos with AI.','https://riverside.fm',true,true,120000, freeTier:'Free basic version', price:15, priceTier:'Standard monthly annual', tips:'AI-powered "Magic Clips" | Local recording in 4K | Best for remote interviews'),
    t('squadcast-ai-pro','SquadCast','audio','Professional remote recording platform for high-end audio and AI.','https://squadcast.fm',true,true,45000, freeTier:'7-day free trial', price:20, priceTier:'Producer monthly (Descript)', tips:'Acquired by Descript | AI-powered backup | Professional audio quality'),
    t('castmagic-ai-pro','Castmagic','audio','AI-powered platform that turns podcast audio into show notes and posts.','https://castmagic.io',true,true,58000, freeTier:'Free trial available', price:39, priceTier:'Hobby monthly', tips:'Best for content repurposing | AI writes summaries/titles/tweets | Fast'),

    // ━━━ AI FOR MUSIC DISCOVERY & DATA ━━━
    t('shazam-ai-pro','Shazam','audio','Identify any song in seconds with your microphone and AI.','https://shazam.com',true,true,999999, freeTier:'Completely free forever', price:0, tips:'Owned by Apple | AI-powered "Charts" | Identify music anywhere'),
    t('last-fm-ai-pro','Last.fm','audio','The world\'s largest music database with AI-powered "Scrobbling" and help.','https://last.fm',true,true,250000, freeTier:'Completely free basic version', price:3, priceTier:'Pro monthly', tips:'Track Every song you hear | AI-powered "Discovery" weekly | Deep music data'),
    t('genius-music-ai','Genius','audio','The world\'s largest collection of song lyrics and AI-powered crowdsource.','https://genius.com',true,true,500000, freeTier:'Completely free for everyone', price:0, tips:'Verified artist annotations | AI-powered "News" | Deep meaning for songs'),
    t('musixmatch-ai','Musixmatch','audio','World\'s leading music metadata company with AI-powered lyrics for apps.','https://musixmatch.com',true,true,180000, freeTier:'Free basic version', price:5, priceTier:'Pro monthly', tips:'The power behind Apple/Spotify lyrics | AI-powered translation | Pro sync tools'),
    t('setlist-fm-ai','Setlist.fm','audio','The world\'s largest wiki for concert setlists using AI for data clean.','https://setlist.fm',true,true,84000, freeTier:'Completely free to use', price:0, tips:'Owned by Live Nation | AI-powered stats for concerts | Best for music fans'),
    t('songkick-ai-pro','Songkick','entertainment','Track your favorite artists and get concert alerts with AI discovery.','https://songkick.com',true,true,150000, freeTier:'Completely free to use', price:0, tips:'AI-powered "Live" alerts | Integrated with Spotify | Huge global database'),
    t('bandsintown-ai','Bandsintown','entertainment','Leading live music discovery platform with AI-powered "For You" tours.','https://bandsintown.com',true,true,180000, freeTier:'Completely free to use', price:0, tips:'Track 500k+ artists | AI-powered concert recommendations | Industry leader'),
    t('ticketmaster-ai','Ticketmaster','entertainment','The world\'s largest ticket marketplace with AI-powered verified fan.','https://ticketmaster.com',true,true,999999, freeTier:'Free to join', price:0, tips:'AI-powered "Verified Fan" to beat bots | Massive scale | Official partner of NFL'),
    t('stubhub-ai-pro','StubHub','entertainment','Leading secondary ticket marketplace with AI-powered price alerts.','https://stubhub.com',true,true,500000, freeTier:'Free to search tickets', price:0, tips:'Best for last-minute tickets | AI-powered "Seat View" | Secure and trusted'),
    t('seat-geek-ai-pro','SeatGeek','entertainment','Leading mobile ticket platform with AI-powered "Deal Score" and maps.','https://seatgeek.com',true,true,350000, freeTier:'Free to search tickets', price:0, tips:'Best mobile ticket app | AI-powered value pricing | High-res stadium maps'),

    // ━━━ AI FOR E-LEARNING & CODING v2 ━━━
    t('khan-academy-ai','Khan Academy (Khanmigo)','education','Non-profit education platform with the new AI-powered tutor Khanmigo.','https://khanacademy.org',true,true,999999, freeTier:'Completely free core version', price:4, priceTier:'Khanmigo monthly contribution', tips:'Best for K-12 students | AI-powered tutor guides don\'t give answers | Safe'),
    t('duolingo-ai-pro','Duolingo (Max)','education','Learn languages with the new AI-powered "Max" for roleplay.','https://duolingo.com',true,true,999999, freeTier:'Free basic version forever', price:15, priceTier:'Max monthly', tips:'AI-powered "Explain my Answer" | Gamified learning | Most popular in world'),
    t('babbel-ai-pro','Babbel','education','Science-based language learning with AI-powered live classes.','https://babbel.com',true,true,250000, freeTier:'Free first lesson', price:15, priceTier:'Monthly subscription', tips:'Best for serious learners | AI-powered "Review Manager" | High success rate'),
    t('rosetta-stone-ai','Rosetta Stone','education','The gold standard for language learning with AI-powered TruAccent.','https://rosettastone.com',true,true,180000, freeTier:'Free trial for 3 days', price:12, priceTier:'Monthly billed annually', tips:'Immersion-based learning | AI-powered speech recognition | Trusted for decades'),
    t('masterclass-ai','MasterClass','education','Learn from the world\'s best with AI-powered learning paths.','https://masterclass.com',false,true,350000, freeTier:'No free tier', price:10, priceTier:'Monthly billed annually', tips:'Celebrity-led classes | AI-powered "Search" across all videos | Premium production'),
    t('pluralsight-ai','Pluralsight','code','Leading tech learning platform with AI-powered skill assessments.','https://pluralsight.com',true,true,120000, freeTier:'10-day free trial', price:29, priceTier:'Standard monthly', tips:'Best for tech teams | AI-powered "Skill IQ" | Massive library of code/IT'),
    t('data-camp-ai-pro','DataCamp','code','Master data science and AI with interactive lessons and help.','https://datacamp.com',true,true,150000, freeTier:'First chapter of every course free', price:12, priceTier:'Premium monthly annual', tips:'Learn SQL/Python/AI | AI-powered tutor built-in | High quality labs'),
    t('codecademy-ai-pro','Codecademy','code','Leading interactive platform to learn coding with AI-powered support.','https://codecademy.com',true,true,250000, freeTier:'Free basic version', price:15, priceTier:'Plus monthly annual', tips:'Learn by doing | AI-powered "Explanation" for errors | Huge community'),
    t('freecodecamp-ai','freeCodeCamp','code','Non-profit community that helps you learn to code for free with AI.','https://freecodecamp.org',true,true,999999, freeTier:'Completely free forever', price:0, tips:'Largest free coding resource | AI-powered forum help | Earn certifications'),
    t('w3schools-ai-pro','W3Schools','code','The world\'s largest web developer site with AI-powered tutorials.','https://w3schools.com',true,true,999999, freeTier:'Completely free to learn', price:0, tips:'Best for quick reference | AI-powered "Spaces" for hosting | Easy to understand'),

    // ━━━ FINAL GEMS v7 ━━━
    t('vercel-v0-ai','Vercel v0','code','Generative UI platform from Vercel that turns text into React components.','https://v0.dev',true,true,150000, freeTier:'Free basic credits monthly', price:20, priceTier:'Premium monthly', tips:'Best for frontend devs | AI generates Tailwind/Shadcn code | Seamless deploy'),
    t('shadcn-ui-ai','shadcn/ui','code','Beautifully designed components you can copy and paste into your apps.','https://ui.shadcn.com',true,true,250000, freeTier:'Completely free open source', price:0, tips:'The industry standard for React UI | AI-powered documentation | Highly customizable'),
    t('clerk-auth-ai','Clerk','code','The easiest way to add authentication and user management with AI.','https://clerk.com',true,true,84000, freeTier:'Free for up to 10k users', price:25, priceTier:'Pro monthly base', tips:'Best for Next.js devs | AI-powered "Components" | Fast and secure'),
    t('resend-email-ai','Resend','code','The email platform for developers with AI-powered delivery and help.','https://resend.com',true,true,58000, freeTier:'Free for 3,000 emails/month', price:20, priceTier:'Pro monthly', tips:'Modern and fast API | AI-powered "React Email" | Created by team behind Zen'),
    t('lemon-squeezy-ai','Lemon Squeezy','ecommerce','Leading platform for selling digital products with AI-powered taxes.','https://lemonsqueezy.com',true,true,45000, freeTier:'Free to join', price:0, tips:'Acquired by Stripe | Managed taxes and fraud with AI | Best for SaaS devs'),
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
