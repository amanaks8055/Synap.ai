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
    // ━━━ ENTERTAINMENT & VIDEO (Scaling) ━━━
    t('netflix-ai-curation','Netflix (AI Recommendation)','entertainment','The world\'s leading streaming service with AI-powered movie and show suggestions.','https://netflix.com',false,true,999999, freeTier:'No free tier available', price:15, priceTier:'Standard monthly', tips:'AI understands your exact taste | Industry standard for recommendations | High quality content'),
    t('disney-plus-ai','Disney+','entertainment','Stream the best stories from Disney, Pixar, Marvel, Star Wars with AI.','https://disneyplus.com',false,true,500000, freeTier:'Free trial in some regions', price:8, priceTier:'Basic with ads monthly', tips:'Best for families | High quality 4K streaming | AI-powered personal watchlist'),
    t('hbo-max-ai','Max (HBO)','entertainment','Premium streaming service with AI-powered discovery for iconic movies and series.','https://max.com',false,true,450000, freeTier:'No free tier', price:10, priceTier:'With ads monthly', tips:'High quality HBO originals | AI suggests deeper cuts | Top tier interface'),
    t('hulu-ai-pro','Hulu','entertainment','Stream current episodes, movies, and originals with AI-powered ad targeting.','https://hulu.com',true,true,380000, freeTier:'30-day free trial', price:8, priceTier:'With ads monthly', tips:'Best for TV shows | Live TV option available | AI-curated "My Stuff"'),
    t('paramount-plus-ai','Paramount+','entertainment','A mountain of entertainment with AI-powered sports and movie discovery.','https://paramountplus.com',true,true,250000, freeTier:'7-day free trial', price:6, priceTier:'Essential monthly', tips:'Best for live news and sports | AI-powered personal feed | Affordable'),

    // ━━━ EDUCATION GEMS (Extra) ━━━
    t('brilliant-ai-pro','Brilliant','education','Learn math, science, and computer science through interactive AI-powered lessons.','https://brilliant.org',true,true,150000, freeTier:'Free basic daily puzzles', price:13, priceTier:'Monthly billed annually', tips:'Visual and hands-on learning | AI-powered paths | Best for STEM enthusiasts'),
    t('skillshare-ai-pro','Skillshare','education','Online learning community for creators with AI-powered course matching.','https://skillshare.com',true,true,180000, freeTier:'Free limited content', price:32, priceTier:'Membership monthly', tips:'Best for creative fields | Project-based learning | High quality production'),
    t('masterclass-ai','MasterClass','education','Learn from the world\'s best actors, chefs, and writers with AI guidance.','https://masterclass.com',false,true,120000, freeTier:'No free tier', price:15, priceTier:'Monthly billed annually', tips:'Cinematic video quality | Learn from Gordon Ramsay, Natalie Portman | Expert insights'),
    t('linkedin-learning-ai','LinkedIn Learning','education','Access 20,000+ courses with AI-powered career path recommendations.','https://linkedin.com/learning',true,true,250000, freeTier:'1-month free trial', price:30, priceTier:'Monthly subscription', tips:'Best for professional growth | Certificates on profile | Integrated with LinkedIn'),
    t('pluralsight-ai-pro','Pluralsight','education','The tech skills platform with AI-powered "Role IQ" and "Skill IQ" assessments.','https://pluralsight.com',true,true,84000, freeTier:'Free limited content for teams', price:29, priceTier:'Standard monthly', tips:'Deep technical courses | AI assessments identify gaps | Best for IT pros'),

    // ━━━ BUSINESS & CRM (Essential) ━━━
    t('hubspot-crm-ai','HubSpot CRM','marketing','Leading CRM for growing teams with AI-powered sales and marketing tools.','https://hubspot.com',true,true,250000, freeTier:'Completely free basic CRM', price:15, priceTier:'Starter seat monthly', tips:'Best all-in-one platform | AI "ChatSpot" assistant | Integrated email marketing'),
    t('salesforce-einstein','Salesforce (Einstein)','marketing','The world\'s #1 CRM platform with AI built for every team and industry.','https://salesforce.com',false,true,180000, freeTier:'30-day free trial', price:25, priceTier:'Starter per user monthly', tips:'Most powerful CRM | AI predicts sales outcomes | Huge ecosystem of apps'),
    t('pipedrive-ai-pro','Pipedrive','marketing','Sales CRM designed by salespeople with AI-powered deal tracking and tips.','https://pipedrive.com',false,true,92000, freeTier:'14-day free trial', price:15, priceTier:'Essential monthly', tips:'Visual sales pipeline | AI "Sales Assistant" | Easy mobile app'),
    t('zoho-crm-ai','Zoho CRM','marketing','The comprehensive CRM for teams of all sizes with AI-powered "Zia".','https://zoho.com/crm',true,true,120000, freeTier:'Free for up to 3 users', price:14, priceTier:'Standard monthly', tips:'Best value for money | AI-powered sales forecasting | Integrated suite of 50+ apps'),
    t('copper-crm-ai','Copper','marketing','The CRM for Google Workspace that uses AI to organize your relationships.','https://copper.com',false,false,35000, freeTier:'14-day free trial', price:25, priceTier:'Basic monthly', tips:'Native Google Workspace integration | No manual data entry | Fast and clean UI'),

    // ━━━ DESIGN ASSETS (Patterns & Mockups) ━━━
    t('angle-sh-ai','Angle.sh','design','Vector mockups for iPhone, Android and Mac with AI perspective.','https://angle.sh',true,false,15000, freeTier:'Free mockups available', price:50, priceTier:'Full version unlock', tips:'Over 1000 vector mockups | Sketch/Figma/Adobe XD | High resolution'),
    t('uifaces-ai','UI Faces','design','AI-generated avatars for your user interface prototypes and mockups.','https://uifaces.co',true,true,45000, freeTier:'Completely free to use', price:0, tips:'Filter by age, gender, and emotion | Integrated with Figma/Sketch | High quality shots'),
    t('placeit-ai-pro','Placeit (Envato)','design','Easiest mockup generator with AI for logos, videos, and social media.','https://placeit.net',true,true,84000, freeTier:'Free mockups available', price:15, priceTier:'Unlimited subscription monthly', tips:'50k+ templates | No design skills needed | Best for e-commerce owners'),
    t('mrmockup-ai-pro','Mr. Mockup','design','Premium design assets and high-end mockups for professional branding.','https://mrmockup.com',true,false,28000, freeTier:'Free section available', price:19, priceTier:'Avg per mockup bundle', tips:'Highest craftmanship | Unique and creative layouts | Photoshop focus'),
    t('yellow-images-ai','Yellow Images','design','The largest marketplace for high-quality 3D object mockups and fonts.','https://yellowimages.com',true,false,35000, freeTier:'Free items weekly', price:15, priceTier:'Membership monthly', tips:'Object mockups with AI layers | Unique fonts | High-end creative community'),

    // ━━━ DEVELOPER GEMS (Auth & Security) ━━━
    t('clerk-ai-pro','Clerk','code','The most comprehensive UIs and APIs for user management with AI safety.','https://clerk.com',true,true,58000, freeTier:'Free for up to 10k monthly active users', price:25, priceTier:'Pro: more users and features', tips:'Easiest auth to implement | Pre-built components for React/Next.js | Enterprise ready'),
    t('kinde-ai-pro','Kinde','code','Modern auth and user management for developers with AI-powered analytics.','https://kinde.com',true,true,35000, freeTier:'Free for up to 10k MAUs', price:25, priceTier:'Pro plan monthly', tips:'Beautiful UI | Feature flags built-in | Fast and scalable'),
    t('stytch-ai-pro','Stytch','code','Developer-first authentication with AI-powered fraud prevention.','https://stytch.com',true,false,25000, freeTier:'Free for up to 5k MAUs', price:0.10, priceTier:'Pay per active user', tips:'Passwordless focus | Advanced bot detection | Flexible SDKs'),
    t('descope-ai-pro','Descope','code','Drag-and-drop authentication and user management with AI protection.','https://descope.com',true,false,18000, freeTier:'Free for up to 7500 MAUs', price:0, tips:'Visual workflow builder | Identity orchestration | Enterprise grade'),
    t('frontegg-ai-pro','Frontegg','code','The customer management platform for B2B SaaS with AI and self-service.','https://frontegg.com',true,false,12000, freeTier:'Free for up to 30 tenants', price:99, priceTier:'Starter monthly', tips:'Best for B2B multi-tenancy | Powerful admin portal | Secure and scalable'),

    // ━━━ PRODUCTIVITY (Tools) ━━━
    t('mural-ai-pro','Mural','productivity','Collaborative intelligence platform for teams to brainstorm with AI.','https://mural.co',true,true,58000, freeTier:'Free for up to 3 murals', price:12, priceTier:'Team+ per user monthly', tips:'Best for remote workshops | AI-powered grouping | Infinite canvas'),
    t('miro-ai-pro','Miro','productivity','Leading visual workspace for innovation with AI-powered diagramming.','https://miro.com',true,true,150000, freeTier:'Free for up to 3 boards', price:10, priceTier:'Starter per user monthly', tips:'Best for product management | AI "Miro Assist" | Massive integration library'),
    t('whimsical-ai-pro','Whimsical','productivity','Unified workspace for thinking visually with AI-powered flowcharts.','https://whimsical.com',true,true,84000, freeTier:'Free for up to 3 boards', price:12, priceTier:'Pro: unlimited boards and 더', tips:'Fastest flowcharting tool | AI-powered mind maps | Beautiful and clean UI'),
    t('lucidchart-ai','Lucidchart','productivity','Leading intelligent diagramming application with AI-powered layout.','https://lucidchart.com',true,true,92000, freeTier:'Free for up to 3 documents', price:8, priceTier:'Individual monthly', tips:'Enterprise standard | AI converts text to diagrams | Robust data linking'),
    t('diagrams-net-ai','diagrams.net (draw.io)','productivity','Completely free, high-quality diagramming software for everyone.','https://diagrams.net',true,true,250000, freeTier:'Completely free forever', price:0, tips:'Open source and private | No account needed | Integration with Drive/GitHub'),

    // ━━━ LIFESTYLE & COOKING (Extra) ━━━
    t('delish-ai','Delish','food','Viral recipes, cooking tips, and party food with AI-powered discovery.','https://delish.com',true,true,120000, freeTier:'Free basic recipes', price:0, tips:'Great for easy dinners | AI-powered meal search | High community interaction'),
    t('epicurious-ai','Epicurious','food','The professional-grade food resource with AI-powered recipe search.','https://epicurious.com',true,true,92000, freeTier:'Free for browsing', price:0, tips:'Cook with confidence | AI-powered "Kitchen Timer" | Expert reviews'),
    t('food-network-ai','Food Network Kitchen','food','Learn from top TV chefs with AI-powered live and on-demand classes.','https://foodnetwork.com',true,true,150000, freeTier:'Free previews available', price:5, priceTier:'Premium monthly', tips:'Watch and cook along | Grocery lists built-in | Best for Food Network fans'),
    t('allrecipes-ai','Allrecipes','food','The world\'s largest community-driven food site with AI-powered search.','https://allrecipes.com',true,true,250000, freeTier:'Completely free for users', price:0, tips:'User-reviewed recipes | AI suggests based on ratings | Best for home cooks'),
    t('hellofresh-ai','HelloFresh','food','Leader in meal kits with AI-powered personalized recipe choices.','https://hellofresh.com',false,true,180000, freeTier:'First box discount', price:60, priceTier:'Avg per box starting', tips:'Cook at home with pre-portioned items | AI remembers what you like | High quality'),

    // ━━━ UTILITIES (File GEMS) ━━━
    t('wetransfer-ai','WeTransfer','productivity','The easiest way to send large files globally with AI-powered speed.','https://wetransfer.com',true,true,250000, freeTier:'Free for up to 2GB', price:10, priceTier:'Pro: up to 200GB and 더', tips:'Beautiful artist wallpapers | No account needed to send | Global delivery'),
    t('dropbox-ai-pro','Dropbox','productivity','Modern cloud storage and collaboration with AI-powered search and docs.','https://dropbox.com',true,true,250000, freeTier:'Free up to 2GB storage', price:12, priceTier:'Plus monthly 2TB', tips:'AI "Dropbox Dash" search | Secure and reliable | Integrated with every app'),
    t('box-ai-pro','Box','productivity','Enterprise content management with AI-powered security and data gov.','https://box.com',true,true,150000, freeTier:'Free for personal (10GB)', price:15, priceTier:'Business per user monthly', tips:'Leading for enterprise security | AI metadata tagging | HIPAA and SOC2 compliant'),
    t('google-drive-ai','Google Drive','productivity','Access and share your files on all your devices with AI-powered search.','https://drive.google.com',true,true,999999, freeTier:'Free for up to 15GB (shared)', price:2, priceTier:'Basic 100GB monthly', tips:'Industry standard | AI suggests files you need | Integrated with Google Workspace'),
    t('onedrive-ai','Microsoft OneDrive','productivity','The intelligent storage and sharing solution for teams with AI.','https://onedrive.live.com',true,true,250000, freeTier:'Free for up to 5GB', price:2, priceTier:'Basic 100GB monthly', tips:'Best for Windows users | AI-powered photo tagging | Integrated with Office 365'),

    // ━━━ OTHER INNOVATIONS ━━━
    t('peloton-app-ai','Peloton App','health','The world-class fitness app with AI-powered strength and cardio.','https://onepeloton.com/app',true,true,150000, freeTier:'Free for limited content', price:13, priceTier:'App One monthly', tips:'Best music in fitness | AI-powered "Just Work Out" | No equipment needed'),
    t('apple-fitness-plus','Apple Fitness+','health','Award-winning fitness classes for every body with AI integration.','https://apple.com/apple-fitness-plus',false,true,120000, freeTier:'Free with Apple Watch (3 months)', price:10, priceTier:'Monthly subscription', tips:'Metrics on screen | High quality 4K video | Integrated with Apple Health'),
    t('zwift-ai','Zwift','health','The fitness app that makes indoor cycling and running fun with AI.','https://zwift.com',false,true,84000, freeTier:'7-day free trial', price:15, priceTier:'Monthly subscription', tips:'Virtual world for cyclists | Real-time racing | Used by pros'),
    t('nike-run-club-ai','Nike Run Club','health','Your perfect running partner with AI-powered coaching and social.','https://nike.com/nrc',true,true,150000, freeTier:'Completely free forever', price:0, tips:'Guided runs by elite coaches | AI-powered plans | Massive global community'),
    t('nike-training-club','Nike Training Club','health','The ultimate personal trainer app with AI-powered workout plans.','https://nike.com/ntc',true,true,120000, freeTier:'Completely free forever', price:0, tips:'World-class trainers | AI-powered programs | No gym required'),
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
