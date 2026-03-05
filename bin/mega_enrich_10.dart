// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

Map<String, dynamic> t(String id, {String? freeTier, double? price, String? priceTier, String? tips}) {
  return {
    'id': id,
    'has_free_tier': freeTier != null,
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
    t('flux-ai', freeTier:'Free to explore on Fal.ai/Replicate', price:1, priceTier:'Per 1k images on Pro API', tips:'The world leader in realistic AI images | Best for human skin and text rendering | Extremely high fidelity'),
    t('zillow-ai', freeTier:'Completely free for buyers/sellers', price:0, tips:'The world\'s #1 real estate app | AI-powered "Zestimate" and "Natural Language" search for home finding'),
    t('redfin-ai', freeTier:'Completely free tools for public', price:0, tips:'Leading brokerage giant | AI-powered "Hot Home" predictions and automated tour scheduling'),
    t('trulia-ai', freeTier:'Completely free app and site', price:0, tips:'Best for neighborhood insights | AI-powered "Local" data and crime/school mapping for renters'),
    t('betterhelp-ai', freeTier:'Free consultation available', price:60, priceTier:'Weekly subscription starting', tips:'Leading online therapy platform | AI-powered "Matched" therapists based on deep questionnaires'),
    t('wysa', freeTier:'Free basic version available', price:10, priceTier:'Premium monthly annual', tips:'Leading AI emotional health buddy | AI-powered "Cognitive" techniques for anxiety and stress'),
    t('fitbod', freeTier:'3 free workouts trial', price:13, priceTier:'Monthly membership annual', tips:'Best for heavy lifting and gym | AI-powered "Muscle Recovery" and "Next Set" predictions'),
    t('freeletics', freeTier:'Free basic training journeys', price:10, priceTier:'Coach monthly annual', tips:'Leading bodyweight training app | AI-powered "Coach" adapts to your feedback in real-time'),
    t('hex-ai', freeTier:'Free for up to 3 users', price:30, priceTier:'Team monthly annual', tips:'Leading collaborative data workspace | AI-powered "Magic" SQL and Python generation'),
    t('equals-ai', freeTier:'Free trial for 14 days', price:28, priceTier:'Starter monthly per user', tips:'The first spreadsheet with built-in data connections | AI-powered "Analysis" and "Formula" help'),
    t('rows-ai', freeTier:'Free forever basic version', price:0, tips:'Modern spreadsheet for teams | AI-powered "Analyst" can summarize charts and tables instantly'),
    t('obviously-ai', freeTier:'7-day free trial on site', price:399, priceTier:'Basic monthly annual', tips:'Best for non-technical predictive analytics | AI-powered "AutoML" builds models in clicks'),
    t('matterport-ai', freeTier:'Free forever starter for 1 space', price:10, priceTier:'Starter monthly annual', tips:'The gold standard for 3D digital twins | AI-powered "Cortex" handles all 3D reconstruction'),
    t('sidechef-ai', freeTier:'Free basic version available', price:5, priceTier:'Premium monthly annual', tips:'Leading personalized recipe app | AI-powered "Meal Plan" and "Grocery" integration'),
    t('recipegpt', freeTier:'Free forever basic version', price:0, tips:'Best for converting ingredients into recipes | AI-powered "Custom" dish generation from scraps'),
    t('nutrify-ai', freeTier:'Free basic version available', price:0, tips:'Identify nutritional value from photos | AI-powered "Macro" tracking for healthy eating'),
    t('tastewise', freeTier:'Free trial for food brands', price:0, tips:'Leading AI for food industry trends | AI-powered "Flavor" and "Market" insights for product development'),
    t('akkio', freeTier:'Free trial available on site', price:0, tips:'Leading no-code data platform | AI-powered "Predictive" models for sales and marketing at scale'),
    t('polymer-ai', freeTier:'Free trial for 14 days', price:0, tips:'Best for creating professional databases from spreadsheets | AI-powered "Layout" generation'),
    t('motionit', freeTier:'Free basic version available', price:0, tips:'Leading platform for building animated presentations | AI-powered "Motion" and "Keyframe" help'),
    t('tessian', freeTier:'Institutional only', price:0, tips:'Owned by Proofpoint | Best for email security | AI-powered "Targeted Attack" prevention at scale'),
    t('clerk-io', freeTier:'Institutional only', price:0, tips:'Leading AI-powered personalization for e-commerce | Best for search and product recommendations'),
    t('decktopus', freeTier:'Free basic version available', price:10, priceTier:'Pro monthly annual', tips:'Leading AI presentation maker for sales teams | AI-powered "Template" generation is very fast'),
    t('prezo-ai', freeTier:'Free basic version available', price:0, tips:'Modern AI presentation tool for high-end decks | AI-powered "Layout" and "Visual" generation'),
    t('presentations-ai', freeTier:'Free trial for 3 decks', price:10, priceTier:'Pro monthly annual', tips:'The ultimate presentation generator | AI-powered "Visual" and "Text" generation from briefs'),
    t('accusonus', freeTier:'Discontinued / Part of Meta', price:0, tips:'The pioneer of high-end audio cleaning | Best for room reverb and noise removal in pro audio'),
    t('sonix-ai-pro', freeTier:'Free trial for 30 mins', price:10, priceTier:'Standard hourly', tips:'The industry standard for high-accuracy transcripts | AI-powered "Multi-speaker" detection'),
    t('drift-ai-chat', freeTier:'Free trial for sales teams', price:2500, priceTier:'Premium annual starting', tips:'Leading platform for conversational marketing | AI-powered "B2B Score" for visitors'),
    t('palette-fm', freeTier:'Free high speed preview', price:9, priceTier:'Pro monthly annual', tips:'The gold standard for colorizing black and white photos | AI-powered "Master" filters'),
    t('jamie-ai', freeTier:'Free basic version available', price:20, priceTier:'Pro monthly annual', tips:'Your personal AI meeting assistant | AI-powered "Summary" and "Action Items" without bots'),
  ];

  print('Total tools to enrich: ${tools.length}');

  for (var tool in tools) {
    String id = tool.remove('id');
    final supaPath = '$supabaseUrl/rest/v1/ai_tools?id=eq.$id';
    final bodyBytes = utf8.encode(jsonEncode(tool));

    try {
      final req = await client.patchUrl(Uri.parse(supaPath));
      req.headers.set('apikey', anonKey);
      req.headers.set('Authorization', 'Bearer $anonKey');
      req.headers.set('Content-Type', 'application/json; charset=utf-8');
      req.contentLength = bodyBytes.length;
      req.add(bodyBytes);
      final resp = await req.close();
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        print('OK: $id');
      } else {
        print('FAIL: $id [${resp.statusCode}]');
      }
    } catch (e) {
      print('ERR: $id - $e');
    }
  }

  client.close();
}
