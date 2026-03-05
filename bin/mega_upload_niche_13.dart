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
    // ━━━ AI FOR CONSUMER TECH & LIFESTYLE (Pro/Paid) ━━━
    t('framer-ai-pro','Framer (AI Design)','design','Leading web design platform with AI-powered site generation and layouts.','https://framer.com',true,true,180000, freeTier:'Free basic version', price:15, priceTier:'Mini monthly', tips:'Draw or type to create sites with AI | Best for creative portfolios | Blazing fast'),
    t('webflow-ai-pro','Webflow (AI)','design','The standard for professional web design with new AI-powered styling help.','https://webflow.com',true,true,250000, freeTier:'Free starter version', price:14, priceTier:'Basic monthly billed annual', tips:'Best for visual developers | AI-powered "Style Panels" | Enterprise grade'),
    t('bubble-ai-pro','Bubble (AI)','code','Leading no-code platform with AI-powered logic and DB generation.','https://bubble.io',true,true,150000, freeTier:'Free to learn and build', price:29, priceTier:'Starter monthly', tips:'Build complex apps without code | AI-powered "Page" builder | Huge community'),
    t('glide-ai-apps','Glide','code','Build professional business apps from your data with AI-powered tools.','https://glideapps.com',true,true,120000, freeTier:'Free for personal use', price:25, priceTier:'Starter monthly', tips:'Turn spreadsheets into apps with AI | Best for internal tools | Sleek design'),
    t('softr-ai-pro','Softr','code','The easiest way to build portals and internal apps using AI for data.','https://softr.io',true,true,84000, freeTier:'Free basic version', price:49, priceTier:'Basic monthly', tips:'Best for Airtable/Google Sheets users | AI-powered app generation | Fast'),
    t('airtable-ai-pro','Airtable (AI)','business','The power of a relational database with the ease of a spreadsheet and AI.','https://airtable.com',true,true,500000, freeTier:'Free for individuals/small teams', price:20, priceTier:'Team monthly billed annual', tips:'AI-powered "Summary" and "Extractor" fields | Best for ops | High trust'),
    t('monday-ai-pro','monday.com','business','Leading work OS that helps teams automate workflows with built-in AI.','https://monday.com',true,true,350000, freeTier:'Free for up to 2 users', price:8, priceTier:'Basic per seat monthly', tips:'Highly customizable dashboards | AI-powered "Automation" blocks | robust'),
    t('asana-ai-pro','Asana','business','Leading project management for teams with AI-powered "Intelligence" help.','https://asana.com',true,true,280000, freeTier:'Free for individuals/small teams', price:10, priceTier:'Starter per user monthly', tips:'AI-powered "Smart Goals" and "Status" | Best for enterprise planning | Reliable'),
    t('clickup-ai-pro','ClickUp (AI)','productivity','The one app to replace them all with AI-powered writing and tasks.','https://clickup.com',true,true,180000, freeTier:'Free forever basic version', price:7, priceTier:'Unlimited per user monthly', tips:'AI writes task descriptions and summaries | Best for small teams | High value'),
    t('trello-ai-pro','Trello (Atlassian)','productivity','Visual project management with AI-powered "Butler" automation.','https://trello.com',true,true,999999, freeTier:'Free for solo and small teams', price:5, priceTier:'Standard per user monthly', tips:'Best for Kanban boards | AI-powered "Strategy" cards | Part of Atlassian'),

    // ━━━ AI FOR CREATIVE TOOLS (Pro) ━━━
    t('photoshop-ai-fill','Photoshop (Generative Fill)','design','Leading photo editor with world-class AI-powered "Generative Fill".','https://adobe.com/photoshop',true,true,999999, freeTier:'7-day free trial', price:20, priceTier:'Single app monthly', tips:'The gold standard for photo editing | AI-powered retouching | Commercial safe'),
    t('illustrator-ai-vec','Illustrator (Vector AI)','design','Leading vector design software with AI-powered text-to-vector.','https://adobe.com/illustrator',true,true,500000, freeTier:'7-day free trial', price:20, priceTier:'Single app monthly', tips:'Create logos and icons with AI | High resolution vector output | Pro standard'),
    t('indesign-ai-pro','InDesign (Digital)','design','Pro layout and page design using AI for text formatting and images.','https://adobe.com/indesign',true,true,250000, freeTier:'7-day free trial', price:20, priceTier:'Single app monthly', tips:'Best for magazines and books | AI-powered "Auto Style" | Integrated with fonts'),
    t('lightroom-ai-pro','Lightroom','design','Professional photo editing and organization with AI-powered masking.','https://adobe.com/lightroom',true,true,350000, freeTier:'7-day free trial', price:10, priceTier:'Photography plan monthly', tips:'Best for photographers | AI-powered "Selection" | Cloud sync for all devices'),
    t('canva-magic-ai','Canva (Magic Studio)','design','The easiest way to design anything with AI-powered Magic Media.','https://canva.com',true,true,999999, freeTier:'Free forever basic version', price:12, priceTier:'Pro monthly', tips:'AI-powered background removal | Thousands of templates | Best for social media'),
    t('picsart-ai-pro','Picsart','design','Leading mobile photo and video editor with AI-powered stickers and tools.','https://picsart.com',true,true,250000, freeTier:'Free basic version', price:5, priceTier:'Gold monthly', tips:'Best for Gen Z creators | AI-powered "Replay" | Huge community assets'),
    t('photoroom-ai-pro','PhotoRoom','ecommerce','AI-powered background removal and product photo studio for mobile.','https://photoroom.com',true,true,180000, freeTier:'Free basic version', price:9, priceTier:'Pro monthly', tips:'Best for Etsy/eBay sellers | AI-powered "Instant Backgrounds" | High quality'),
    t('pixelcut-ai-pro','Pixelcut','ecommerce','E-commerce photo studio with AI-powered background removal and batch.','https://pixelcut.ai',true,true,120000, freeTier:'Free basic version', price:10, priceTier:'Pro monthly', tips:'Best for product photography | AI-powered "Shadows" | Fast and easy'),
    t('vance-ai-pro','VanceAI','design','High-end AI-powered photo enhancement and upscaling tools for web.','https://vanceai.com',true,false,45000, freeTier:'Free credits for trial', price:4, priceTier:'Basic monthly (credits)', tips:'Best for restoring old photos | AI-powered sharping | High accuracy'),
    t('lets-enhance-ai','Let\'s Enhance','design','Leading AI-powered image upscaler and quality enhancement platform.','https://letsenhance.io',true,true,58000, freeTier:'10 free credits for trial', price:9, priceTier:'Starter monthly', tips:'Upscale to 4K/8K with AI | Best for printing | Clean and fast UI'),

    // ━━━ AI FOR SALES & CRM v2 ━━━
    t('salesforce-ai-pro','Salesforce (Einstein)','business','The world\'s #1 CRM with AI-powered Einstein for sales and service.','https://salesforce.com',false,true,999999, freeTier:'30-day free trial', price:25, priceTier:'Starter monthly', tips:'Industry standard for enterprise | AI-powered "Next Best Action" | Massive scale'),
    t('hubspot-ai-pro','HubSpot','business','Leading CRM platform for scaling businesses with AI-powered marketing.','https://hubspot.com',true,true,500000, freeTier:'Free CRM and tools version', price:20, priceTier:'Starter monthly', tips:'Most user-friendly CRM | AI-powered "ChatSpot" | Huge education resource'),
    t('zoho-ai-pro','Zoho (Zia)','business','All-in-one business suite with AI-powered personal assistant Zia.','https://zoho.com',true,true,250000, freeTier:'Free basic version for small teams', price:12, priceTier:'Standard monthly', tips:'Best value for money | AI-powered "Data Analyst" | 50+ integrated apps'),
    t('pipedrive-ai-pro','Pipedrive','marketing','Leading sales CRM for small teams with AI-powered sales assistant.','https://pipedrive.com',true,true,150000, freeTier:'14-day free trial', price:14, priceTier:'Essential monthly', tips:'Focused on closing deals | AI-powered "Smart Data" | Easy to use for sales'),
    t('freshsales-ai-pro','Freshsales (Freshworks)','marketing','Modern Sales CRM with AI-powered lead scoring and contact management.','https://freshworks.com/freshsales-crm',true,true,120000, freeTier:'Free basic version for 3 users', price:15, priceTier:'Growth monthly', tips:'Part of Freshworks suite | AI-powered "Freddy" assistant | clean and fast'),
    t('apollo-ai-pro','Apollo.io','marketing','Leading sales intelligence and engagement platform with AI data.','https://apollo.io',true,true,180000, freeTier:'Free basic version (credits)', price:49, priceTier:'Basic monthly', tips:'Access 275M+ contacts | AI-powered "Search" and "Writing" | Best for outbound'),
    t('zoom-info-ai','ZoomInfo','business','The gold standard for B2B data and intelligence using high-end AI.','https://zoominfo.com',false,true,84000, freeTier:'Institutional only', price:0, tips:'Most accurate B2B phone/email | AI-powered "Intent" scores | Strategic focus'),
    t('seamless-ai-pro','Seamless.ai','marketing','Leading sales search engine using AI to find contact info in real-time.','https://seamless.ai',true,true,45000, freeTier:'Free trial available (credits)', price:147, priceTier:'Pro monthly', tips:'Real-time verified data | AI-powered lead discovery | Best for high-growth'),
    t('lush-ai-pro','Lusha','marketing','The easiest way to find B2B contact info with AI-powered verification.','https://lusha.com',true,true,58000, freeTier:'Free basic credits monthly', price:29, priceTier:'Pro per user monthly', tips:'Leading data compliance | AI-powered LinkedIn extension | trusted by 800k+'),
    t('hunter-ai-pro','Hunter.io','marketing','Leading email discovery and verification platform with AI data.','https://hunter.io',true,true,120000, freeTier:'Free basic credits monthly', price:34, priceTier:'Starter monthly', tips:'Best for cold email prep | AI-powered "Domain Search" | High accuracy'),

    // ━━━ AI FOR E-COMMERCE & DROPSHIPPING ━━━
    t('shopify-magic-ai','Shopify (Magic)','ecommerce','Leading e-commerce platform with AI-powered product writing and help.','https://shopify.com',true,true,999999, freeTier:'3-day free trial + \$1/month', price:39, priceTier:'Basic monthly', tips:'The gold standard for e-commerce | AI-powered "Sidekick" | Massive app store'),
    t('big-commerce-ai','BigCommerce','ecommerce','Modern enterprise e-commerce platform with AI-powered scale.','https://bigcommerce.com',false,true,58000, freeTier:'15-day free trial', price:29, priceTier:'Standard monthly', tips:'Best for headless commerce | AI-powered search and merch | Robust API'),
    t('woo-commerce-ai','WooCommerce (Automattic)','ecommerce','Leading open source e-commerce for WordPress with AI plugins.','https://woocommerce.com',true,true,999999, freeTier:'Completely free open source', price:0, tips:'Full control and ownership | Thousands of AI plugins | Largest community'),
    t('wix-ai-ecommerce','Wix (ADIs)','ecommerce','E-commerce and site building with AI-powered "Magic" store tools.','https://wix.com',true,true,500000, freeTier:'Free basic version (Wix ads)', price:16, priceTier:'Light monthly', tips:'Easiest site builder | AI-powered "Site Builder" | Best for small biz'),
    t('squarespace-ai-pro','Squarespace','ecommerce','Beautiful e-commerce and site building with AI-powered layouts.','https://squarespace.com',true,true,350000, freeTier:'14-day free trial', price:16, priceTier:'Personal monthly', tips:'Best for visual brands | AI-powered "Blueprint" builder | Integrated domain'),
    t('ali-express-ai','AliExpress (Digital)','ecommerce','Global marketplace for sourcing with AI-powered visual search.','https://aliexpress.com',true,true,999999, freeTier:'Completely free for users', price:0, tips:'Find products via photo | AI-powered translation | Best for dropshippers'),
    t('alibaba-ai-pro','Alibaba (Digital)','ecommerce','Largest B2B sourcing platform using AI for supplier matching.','https://alibaba.com',true,true,500000, freeTier:'Free to browse and search', price:0, tips:'Source anything from factories | AI-powered "RFQ" tools | Global commerce'),
    t('amazon-seller-ai','Amazon Seller (Digital)','ecommerce','Leading platform for selling on Amazon with AI-powered listing data.','https://sellercentral.amazon.com',true,true,999999, freeTier:'Free basic individual account', price:39, priceTier:'Professional monthly', tips:'Huge global fulfillment (FBA) | AI-powered "Growth" tips | Best scale'),
    t('ebay-ai-center','eBay (Seller)','ecommerce','Leading open marketplace with AI-powered background removal and info.','https://ebay.com',true,true,999999, freeTier:'Free to list (limited)', price:0, tips:'AI-powered "Terapeak" research | Best for used items | Global audience'),
    t('etsy-ai-seller','Etsy (Seller)','ecommerce','Largest marketplace for handmade and vintage with AI-powered discovery.','https://etsy.com',true,true,500000, freeTier:'Free to join and browse', price:0, tips:'AI-powered search ranking | Best for creators | Support small artists'),

    // ━━━ FINAL GEMS v6 ━━━
    t('raycast-pro-ai','Raycast (Pro)','productivity','Modern Mac launcher and productivity tool with high-end AI built-in.','https://raycast.com',true,true,120000, freeTier:'Free basic version', price:8, priceTier:'Pro monthly', tips:'The best Mac tool | AI-powered "Completions" | Huge library of extensions'),
    t('warp-terminal-ai','Warp','code','The modern terminal with AI-powered search and collaboration.','https://warp.dev',true,true,84000, freeTier:'Free for individuals', price:12, priceTier:'Team per user monthly', tips:'AI writes terminal commands | Collaborative workflows | Blazing fast (Rust)'),
    t('cursor-ai-code','Cursor','code','Leading AI code editor based on VS Code with deep AI integration.','https://cursor.com',true,true,150000, freeTier:'Free basic version', price:20, priceTier:'Pro monthly', tips:'Best AI coding experience | Deep context awareness | Fast and familiar'),
    t('replit-ai-pro','Replit (Ghostwriter)','code','Collaborative online IDE with AI-powered code generation and hosting.','https://replit.com',true,true,250000, freeTier:'Free basic version', price:15, priceTier:'Replit Core monthly', tips:'Best for hosting prototypes | AI-powered "Deployment" | Great for beginners'),
    t('github-copilot-dev','GitHub Copilot','code','The world\'s most popular AI pair programmer directly in your IDE.','https://github.com/features/copilot',true,true,999999, freeTier:'Free for students/OSS maintainers', price:10, priceTier:'Individual monthly', tips:'Industry standard | AI-powered code completion | Huge language support'),
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
