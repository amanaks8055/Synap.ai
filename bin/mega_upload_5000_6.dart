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
    // ━━━ AI FOR FINTECH & PAYMENTS (Iconic) ━━━
    t('stripe-ai-pro','Stripe (AI)','business','The world\'s #1 payment platform using AI for fraud detection (Radar) and data.','https://stripe.com',true,true,999999, freeTier:'Free to join, pay per transaction', price:0, tips:'AI-powered "Radar" is the fraud gold standard | Best for global e-com | Iconic'),
    t('addy-ai-pro-fin','Adyen (AI)','business','Leading global payment infrastructure using AI for high-end conversion and data.','https://adyen.com',true,true,500000, freeTier:'Self-service access', price:0, tips:'AI-powered "RevenueProtect" is elite | Best for enterprise scale | Industry leader'),
    t('paypal-ai-pro','PayPal (AI)','business','Global payment giant using AI for automated security, support, and "Honey" labs.','https://paypal.com',true,true,999999, freeTier:'Completely free to join', price:0, tips:'AI-powered "Risk" models | Best for consumer trust | Global reach'),
    t('revolut-ai-pro-fin','Revolut (AI)','business','Leading neobank using AI-powered "Fraud Detection" andpersonalized wealth tips.','https://revolut.com',true,true,350000, freeTier:'Free basic account available', price:13, priceTier:'Premium monthly', tips:'Best for international travel | AI-powered "Budgeting" | Modern tech bank'),
    t('plaid-ai-pro-data','Plaid (AI)','code','Leading financial data platform using AI to link bank accounts to apps safely.','https://plaid.com',true,true,250000, freeTier:'Free for personal starters', price:0, tips:'The bridge of modern fintech | AI-powered "Enrichment" | High data trust'),

    // ━━━ AI FOR CYBERSECURITY (Ops v2) ━━━
    t('cloud-flare-ai','Cloudflare (AI)','code','Leading CDN and security giant using AI for "Bot" mitigation and WAF.','https://cloudflare.com',true,true,999999, freeTier:'Free forever for personal sites', price:20, priceTier:'Pro monthly', tips:'AI-powered "Edge" is revolutionary | Best for web privacy | Global leader'),
    t('okta-ai-pro-sec','Okta (AI)','code','Leading identity platform using AI-powered "Identity Threat Protection" and labs.','https://okta.com',true,true,350000, freeTier:'Free developer version available', price:0, tips:'The enterprise standard for auth | AI-powered "Risk" scores | robust'),
    t('z-scaler-ai-pro','Zscaler (AI)','code','Leading cloud security giant using AI-powered "Zero Trust" and data logs.','https://zscaler.com',false,true,180000, freeTier:'Institutional only', price:0, tips:'Best for corporate networks | AI-powered "Brave" defense | High end'),
    t('fort-inet-ai-pro','Fortinet (FortiGuard)','code','Leading network security company using AI-powered "Security Fabric" and data.','https://fortinet.com',false,true,250000, freeTier:'Institutional only', price:0, tips:'Industry standard for firewalls | AI-powered "Thread" detect | Highly reliable'),
    t('palo-alto-ai-cloud','Prisma Cloud (Palo Alto)','code','Leading cloud-native security platform using high-end AI for CNAPP.','https://paloaltonetworks.com/prisma',false,true,150000, freeTier:'Institutional only', price:0, tips:'Best for multi-cloud security | AI-powered "Code-to-Cloud" | World leader'),

    // ━━━ AI FOR CREATIVE WRITING & FICTION (Pro) ━━━
    t('scrivener-ai-pro','Scrivener','education','The world\'s #1 writing software for novelists and screenwriters with data help.','https://literatureandlatte.com',true,true,350000, freeTier:'30-day free trial on site', price:59, priceTier:'Full license one-time', tips:'Best for complex books | AI-powered "Metadata" and structure | The pro choice'),
    t('pro-writing-aid','ProWritingAid','education','Leading AI-powered writing coach with high-end style and grammar labs.','https://prowritingaid.com',true,true,250000, freeTier:'Free basic version available', price:10, priceTier:'Premium monthly annual', tips:'AI-powered "Style" suggestions | Best for fiction writers | Robust and deep'),
    t('plot-tr-ai-pro','Plottr','lifestyle','Leading visual book planning software with AI-powered "Plot" templates.','https://plottr.com',true,true,84000, freeTier:'Free trial for 30 days', price:15, priceTier:'Starter monthly annual', tips:'Best for mapping your story | AI-powered "Timeline" generator | High reach'),
    t('vellum-ai-pro','Vellum','design','The world\'s most beautiful book formatting software with AI-powered layout.','https://vellum.pub',true,true,120000, freeTier:'Free to design and preview', price:199, priceTier:'One-time purchase license', tips:'Best for Kindle and Print | AI-powered "Typography" | Mac only and elite'),
    t('final-draft-ai','Final Draft','entertainment','The world\'s #1 screenwriting software for Hollywood with AI-powered help.','https://finaldraft.com',true,true,350000, freeTier:'30-day free trial on site', price:199, priceTier:'Full license one-time', tips:'The Hollywood industry standard | AI-powered "ScriptNotes" | Iconic'),

    // ━━━ AI FOR 3D PRINTING & FABRICATION (Iconic) ━━━
    t('cura-ai-pro-print','Ultimaker Cura','design','The world\'s most popular open source 3D printing slicer with AI help.','https://ultimaker.com/cura',true,true,999999, freeTier:'Completely free forever', price:0, tips:'Best for FDM printing | AI-powered "Tree Supports" | Industry giant'),
    t('prus-a-ai-pro-sl','PrusaSlicer','design','Leading open-source 3D printing software using AI-powered "Smart" layers.','https://prusa3d.com',true,true,500000, freeTier:'Completely free forever', price:0, tips:'Best for Prusa users | AI-powered "Organic" supports | High trust'),
    t('bambu-ai-pro-st','Bambu Studio','design','Leading 3D printing slicer optimized for speed using high-end AI logs.','https://bambulab.com',true,true,350000, freeTier:'Completely free for users', price:0, tips:'AI-powered "Auto-calibration" | Best for high speed printing | Swedish tech'),
    t('form-labs-ai-pro','Formlabs PreForm','design','Leading professional resin 3D printing software with AI-powered support.','https://formlabs.com',true,true,150000, freeTier:'Free for Formlabs owners', price:0, tips:'Best for SLA/High res | AI-powered "Auto-orient" | Pro gold standard'),
    t('octo-print-ai-ops','OctoPrint','design','Leading open source 3D printer remote control with AI-powered failure detect.','https://octoprint.org',true,true,250000, freeTier:'Completely free forever', price:0, tips:'Best for remote monitoring | AI-powered "Spaghetti Detective" | Iconic'),

    // ━━━ FINAL GEMS v46 (Modern AI Observability) ━━━
    t('honey-comb-ai-pro','Honeycomb','code','Leading observability platform for high-end AI "Tracing" and debugging events.','https://honeycomb.io',true,true,120000, freeTier:'Free forever with 20M events', price:0, tips:'Pioneer of observability | AI-powered "Query" help | best for complex backends'),
    t('log-rocket-ai-pro','LogRocket','code','Leading session replay and error tracking with AI-powered "Customer" context.','https://logrocket.com',true,true,150000, freeTier:'Free for up to 1k sessions/mo', price:99, priceTier:'Team monthly annual', tips:'Best for frontend apps | AI-powered "Issue" prioritization | High visibility'),
    t('sentry-ai-pro-err','Sentry','code','The world\'s #1 error tracking platform with new AI-powered "Issue" summaries.','https://sentry.io',true,true,999999, freeTier:'Free for personal starters', price:26, priceTier:'Team monthly annual', tips:'Best for every dev | AI-powered "Autofix" (preview) is magic | Industry standard'),
    t('ak-ita-ai-pro-api','Akita (Postman)','code','Leading API observability and mapping using AI-powered "No-code" tracking.','https://akitasoftware.com',true,true,84000, freeTier:'Free trial available on Postman', price:0, tips:'Owned by Postman | AI-powered "API" maps | Best for legacy system maps'),
    t('check-ly-ai-pro','Checkly','code','Modern monitoring for APIs and Playwright with AI-powered "Test" generation.','https://checklyhq.com',true,true,120000, freeTier:'Free for up to 50k runs', price:80, priceTier:'Team monthly annual', tips:'Best for E2E monitoring | AI-powered "Script" help | clean UI'),
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
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        uploaded += batch.length;
        print('OK $uploaded/${tools.length}');
      } else {
        final respBody = await utf8.decodeStream(resp);
        print('FAIL at $i [${resp.statusCode}]: $respBody');
      }
    } catch (e) {
      print('ERR at $i: $e');
    }
  }

  client.close();
  print('DONE! Uploaded $uploaded tools with full pricing data');
}
