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
    // ━━━ AI FOR PROJECT MANAGEMENT & SAAS (Iconic) ━━━
    t('monday-ai-pro','monday.com','business','Leading work OS with AI-powered "monday AI" for task automation.','https://monday.com',true,true,999999, freeTier:'Free for up to 2 seats', price:8, priceTier:'Basic monthly per seat', tips:'Best for visual project management | AI-powered "Assistant" | Global leader'),
    t('asana-ai-pro','Asana (AI)','business','leading enterprise project management with AI-powered "Intelligent" status.','https://asana.com',true,true,500000, freeTier:'Free forever personal basic', price:11, priceTier:'Premium monthly per seat', tips:'Focus on goals and OKRs with AI | Clean and robust UI | Industry standard'),
    t('trello-ai-pro','Trello (Atlassian)','business','The original Kanban board with AI-powered "Butler" automation.','https://trello.com',true,true,999999, freeTier:'Free forever for anyone', price:5, priceTier:'Standard monthly', tips:'Best for simple workflows | AI-powered "Card" automation | Owned by Atlassian'),
    t('jira-ai-pro-dev','Jira (Atlassian)','code','Leading tool for agile software teams with AI-powered "Intelligent" help.','https://atlassian.com/jira',true,true,999999, freeTier:'Free for up to 10 users', price:0, tips:'Industry standard for dev teams | AI-powered "JSM" for service | Scale'),
    t('confluence-ai','Confluence','productivity','Leading team workspace with AI-powered content summaries and help.','https://atlassian.com/confluence',true,true,500000, freeTier:'Free for up to 10 users', price:0, tips:'Best for team wiki and docs | AI-powered "Atlassian Intelligence" | Robust'),
    t('clickup-ai-pro','ClickUp','business','The "All-in-One" productivity tool with powerful AI-powered "Brain".','https://clickup.com',true,true,350000, freeTier:'Free forever basic version', price:7, priceTier:'Unlimited monthly per seat', tips:'Replaces multiple apps with AI | AI-powered "Summaries" | fast growing'),
    t('smartsheet-ai','Smartsheet','business','Leading enterprise platform for work management with AI data.','https://smartsheet.com',true,true,180000, freeTier:'30-day free trial on site', price:7, priceTier:'Pro per user monthly', tips:'Best for spreadsheet-style work | AI-powered "Charts" | High trust'),
    t('wrike-ai-pro','Wrike','business','Leading collaborative work management with AI-powered risk prediction.','https://wrike.com',true,true,120000, freeTier:'Free forever basic version', price:10, priceTier:'Team per user monthly', tips:'Best for marketing teams | AI-powered "Gantt" charts | robust and secure'),
    t('airtable-ai-pro','Airtable','business','Leading platform for building custom apps with AI-powered field data.','https://airtable.com',true,true,250000, freeTier:'Free forever basic version', price:20, priceTier:'Team per user monthly', tips:'Best for custom databases | AI-powered "Extension" builder | modern UI'),
    t('basecamp-ai-pro','Basecamp','business','The original simple project management for small teams with AI help.','https://basecamp.com',true,true,150000, freeTier:'30-day free trial on site', price:15, priceTier:'Per user monthly', tips:'Best for focused collaboration | No-nonsense UI | legendary brand'),

    // ━━━ AI FOR PHOTOGRAPHY & DESIGN v3 ━━━
    t('adobe-fire-fly','Adobe Firefly','design','Adobe\'s family of generative AI models for images and text effects.','https://adobe.com/firefly',true,true,999999, freeTier:'Free basic web credits', price:5, priceTier:'Premium monthly', tips:'Responsible AI training | Deeply integrated in Photoshop | World class quality'),
    t('lightroom-ai-pro','Adobe Lightroom (AI)','design','Leading photo editor with AI-powered "Lens Blur" and "Generative Remove".','https://lightroom.com',true,true,999999, freeTier:'Free app for mobile users', price:10, priceTier:'Creative Cloud monthly', tips:'Best for professional photographers | AI-powered "Denoise" | sync across devices'),
    t('capture-one-ai','Capture One','design','Pro-grade photo editing and tethering with AI-powered masking.','https://captureone.com',true,false,84000, freeTier:'30-day free trial', price:24, priceTier:'Subscription monthly', tips:'Best for studio photography | AI-powered "Correct" tools | High precision'),
    t('skylum-luminar-ai','Luminar Neo','design','Creative photo editor using AI for sky replacement and relighting.','https://skylum.com',false,true,120000, freeTier:'Free trial available', price:15, priceTier:'Monthly membership starting', tips:'AI-powered "GenErase" | Best for artistic edits | fast and easy'),
    t('pixelmator-ai','Pixelmator Pro','design','Leading macOS photo editor with AI-powered "Super Resolution" and mask.','https://pixelmator.com',true,true,150000, freeTier:'Free trial on App Store', price:50, priceTier:'One-time purchase', tips:'Best for Mac users | AI-powered "Remove Background" | Clean design'),
    t('darkroom-ai-pro','Darkroom','design','Leading mobile and Mac photo editor with AI-powered curves and masks.','https://darkroom.co',true,true,120000, freeTier:'Free basic version', price:5, priceTier:'Plus monthly', tips:'Apple Design Award winner | AI-powered "Face" detect | High performance'),
    t('halide-ai-camera','Halide','design','Pro camera app for iPhone using AI-powered "Process Zero".','https://lux.camera',true,true,84000, freeTier:'Free trial on App Store', price:3, priceTier:'Monthly subscription', tips:'Best for RAW photography | AI-powered "Spatial" tools | Cleanest UI'),
    t('vsco-ai-pro','VSCO','design','Leading photo and video editor for creators using AI-powered presets.','https://vsco.co',true,true,500000, freeTier:'Free basic version', price:8, priceTier:'Pro monthly', tips:'Best for film-like aesthetics | AI-powered "Search" | Massive community'),
    t('picsart-ai-pro','Picsart','design','The #1 mobile creative platform with AI-powered image generation.','https://picsart.com',true,true,999999, freeTier:'Free basic version with ads', price:13, priceTier:'Gold monthly starting', tips:'Best for Gen Z creatives | AI-powered "Magic" tools | Viral content hub'),
    t('canva-ai-magic','Canva (Magic Studio)','design','The world\'s most popular design app with AI-powered "Magic Media".','https://canva.com',true,true,999999, freeTier:'Free forever basic version', price:15, priceTier:'Pro monthly', tips:'AI-powered "Brand Voice" | Best for non-designers | Huge template library'),

    // ━━━ AI FOR NGO & PHILANTHROPY ━━━
    t('charity-nav-ai','Charity Navigator','business','Leading charity rater using AI for deep data on non-profit impact.','https://charitynavigator.org',true,true,250000, freeTier:'Completely free to use', price:0, tips:'Identify the best charities with AI | High trust | Non-profit itself'),
    t('guide-star-ai','GuideStar (Candid)','business','The world\'s largest database of non-profits with AI-powered data.','https://guidestar.org',true,true,180000, freeTier:'Free basic search', price:0, tips:'Owned by Candid | AI-powered "Transparency" seals | Essential for donors'),
    t('global-giving-ai','GlobalGiving','business','Leading crowdfunding for non-profits using AI for project matching.','https://globalgiving.org',true,true,120000, freeTier:'Completely free for the public', price:0, tips:'AI-powered "Vetting" | Best for global disasters | High impact'),
    t('donors-choose-ai','DonorsChoose','education','Helping public school teachers get materials with AI-powered matching.','https://donorschoose.org',true,true,84000, freeTier:'Completely free for the public', price:0, tips:'Sponsor a classroom with AI | Best for educational impact | trusted'),
    t('kiva-ai-pro-give','Kiva','business','Leading micro-lending platform using AI for borrower matching.','https://kiva.org',true,true,150000, freeTier:'Lend as little as \$25', price:0, tips:'AI-powered "Security" check | Best for supporting entrepreneurs | Global'),
    t('bill-mel-gates-ai','Gates Foundation (AI)','science','The world\'s largest private foundation with high-end AI health research.','https://gatesfoundation.org',true,false,58000, freeTier:'Free resources online', price:0, tips:'AI-powered "Malaria" tracking | Global health leader | Massive research spend'),
    t('wellcome-ai-pro','Wellcome Trust','science','Leading global health foundation with AI-powered data science labs.','https://wellcome.org',true,false,35000, freeTier:'Free for researchers', price:0, tips:'UK based global leader | AI-powered "Climate" health | Research focused'),
    t('direct-relief-ai','Direct Relief','health','Humanitarian aid organization using AI for logistics during disasters.','https://directrelief.org',true,true,45000, freeTier:'Completely free to donor', price:0, tips:'0% overhead on donations | AI-powered "Disaster" maps | high reliability'),
    t('unicef-ai-pro','UNICEF (Digital)','health','Global children\'s organization with AI-powered monitoring and data.','https://unicef.org',true,true,500000, freeTier:'Complete free for the public', price:0, tips:'AI-powered "Innovation" fund | Best for children\'s rights | Global leader'),
    t('oxfam-ai-pro','Oxfam (Digital)','business','Global confederation working to end poverty with AI-powered data help.','https://oxfam.org',true,false,120000, freeTier:'Completely free for the public', price:0, tips:'AI-powered "Inequality" reports | Best for social impact | Strategic'),

    // ━━━ AI FOR CIVIC TECH & GOV v2 ━━━
    t('census-gov-ai','US Census (AI)','science','Leading provider of population data with AI-powered digitization.','https://census.gov',true,true,500000, freeTier:'Completely free open data', price:0, tips:'Access trillions of data points | AI-powered "Microdata" search | Essential'),
    t('data-gov-ai-pro','Data.gov','science','The home of the US Government’s open data with AI-powered search help.','https://data.gov',true,true,350000, freeTier:'Completely free forever', price:0, tips:'250k+ datasets | AI-powered "Topic" search | Open data standard'),
    t('usa-gov-ai-pro','USA.gov','business','The official guide to government services using AI for citizen help.','https://usa.gov',true,true,999999, freeTier:'Completely free forever', price:0, tips:'AI-powered "Benefits" search | Best for civic help | High trust'),
    t('vote-gov-ai-pro','Vote.gov','business','Leading platform for US voter registration with AI-powered local help.','https://vote.gov',true,true,999999, freeTier:'Completely free forever', price:0, tips:'Official government portal | AI-powered "State" guides | Crucial'),
    t('gov-uk-ai-pro','GOV.UK','business','Leading global standard for digital government with AI-powered search.','https://gov.uk',true,true,999999, freeTier:'Completely free forever', price:0, tips:'Best-in-class UI design | AI-powered "User Search" | Industry leader'),
    t('estonia-gov-ai','e-Estonia','business','The world\'s most advanced digital society using AI for citizenship.','https://e-estonia.com',true,true,58000, freeTier:'Completely free basic info', price:0, tips:'AI-powered "Bureau" services | First e-residency with AI | Futuristic'),
    t('singapore-gov-ai','Smart Nation (SG)','business','Singapore\'s vision for a digital first city using AI for public services.','https://smartnation.gov.sg',true,true,84000, freeTier:'Free for citizens', price:0, tips:'AI-powered "Parking" and "Transit" | Global leader in civic tech | Pro'),
    t('digital-india-ai','Digital India','business','Massive government program using AI for rural connectivity and data.','https://digitalindia.gov.in',true,true,250000, freeTier:'Free for citizens', price:0, tips:'Millions of users | AI-powered "UPI" and "DigiLocker" | Massive potential'),
    t('eu-data-ai-pro','European Data Portal','science','Leading source of open data in the EU with AI-powered translations.','https://data.europa.eu',true,false,150000, freeTier:'Completely free forever', price:0, tips:'Best for EU researchers | AI-powered "Data Analytics" | Open focus'),
    t('world-bank-ai','World Bank (Data)','business','Leading global data source for development and AI-powered indicators.','https://data.worldbank.org',true,true,500000, freeTier:'Completely free open data', price:0, tips:'Track global progress with AI | Best for economists | industry standard'),

    // ━━━ FINAL GEMS v23 (Modern Security) ━━━
    t('one-pass-ai-pro','1Password','productivity','Leading secure password manager with AI-powered "Passkeys" and search.','https://1password.com',true,true,500000, freeTier:'14-day free trial on site', price:3, priceTier:'Individual monthly annual', tips:'AI-powered "Watchtower" for breaches | Best for teams | High security'),
    t('bit-warden-ai-pro','Bitwarden','productivity','Leading open-source password manager with AI-powered security help.','https://bitwarden.com',true,true,350000, freeTier:'Free forever for individuals', price:1, priceTier:'Premium monthly annual', tips:'Completely open source | AI-powered "Secrets" manager | highly trusted'),
    t('last-pass-ai-pro','LastPass','productivity','Leading security platform for passwords with AI-powered monitoring.','https://lastpass.com',true,true,500000, freeTier:'Free basic version for users', price:3, priceTier:'Premium monthly', tips:'Best for simple families | AI-powered "Security Dash" | established'),
    t('dash-lane-ai-pro','Dashlane','productivity','Leading secure credential manager with AI-powered "Auto-Fill" and data.','https://dashlane.com',true,true,180000, freeTier:'Free for up to 25 passwords', price:5, priceTier:'Premium monthly', tips:'AI-powered "Phishing" alerts | fast and clean | high reliability'),
    t('okta-ai-pro-auth','Okta (AI)','code','Leading identity platform with AI-powered "Identity Threat Protection".','https://okta.com',true,true,250000, freeTier:'Free for up to 100 users (developer)', price:0, tips:'The enterprise standard for auth | AI-powered "Risk" scoring | scale'),
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
