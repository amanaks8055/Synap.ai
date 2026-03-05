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
    t('planet-labs', freeTier:'Free trial for researchers and public data', price:0, tips:'The world leader in satellite imagery and AI analysis | AI-powered "Planetary Variables" provides high-resolution data on land use, climate, and infrastructure changes globally for pro researchers'),
    t('uptake-ai', freeTier:'Institutional only', price:0, tips:'Leading AI for industrial asset performance and predictive maintenance | AI-powered "Analytics" prevents downtime for power plants and heavy machinery using real-time sensor data'),
    t('prospera-ai', freeTier:'Institutional only (Valmont)', price:0, tips:'Leading AI for smart irrigation and crop health | AI-powered "Center Pivot" monitoring used by global farmers to optimize water and data-driven field harvest reports instantly'),
    t('sight-machine', freeTier:'Institutional only', price:0, tips:'Leading platform for manufacturing data intelligence | AI-powered "Production" dashboard turns raw factory info into actionable business insights and efficiency targets'),
    t('terrawatch-ai', freeTier:'Free forever basic newsletter and insights', price:0, tips:'Leading research platform for Earth Observation and Geospatial AI | Best for finding high-end startup data and trends in the space and climate tech ecosystem'),
    t('regrow-ag', freeTier:'Institutional only', price:0, tips:'Leading platform for sustainable agriculture and carbon monitoring | AI-powered "Resilience" tools help food companies track and reduce their specific environmental data footprint'),
    t('trace-genomics', freeTier:'Institutional only', price:0, tips:'Leading AI for soil DNA analysis and health | Best for industrial-scale agronomy finding the best nutrients and data-driven crop placements for global agribusiness'),
    t('rex-ai', freeTier:'Free trial available on site', price:0, tips:'Leading AI assistant for real estate investment and analysis | Best for identifying property value data trends and localized market research instantly in the US'),
    t('planet-labs-ai', freeTier:'Free research credentials', price:0, tips:'High-end satellite intelligence suite | AI-powered "Object Detection" handles thousands of global square kilometers for infrastructure and naval data reports'),
    t('uptake-pro', freeTier:'Institutional only', price:0, tips:'Enterprise-grade industrial intelligence platform | Features incredibly "Asset Health" scores driven by millions of historical failure data points and research'),
    t('prospera-ai-pro', freeTier:'Institutional only', price:0, tips:'Professional agricultural intelligence suite | AI-powered "Vision" for crop scouting reverses the effects of pests and disease driven by deep field data'),
    t('sight-machine-pro', freeTier:'Institutional only', price:0, tips:'The "Command Center" for digital manufacturing | AI-powered "Stream" processing handles thousands of sensor data points simultaneously for global shops'),
    t('terrawatch-pro', freeTier:'Free basic access', price:0, tips:'The "Search Engine for Earth Data" | AI-powered "Market Synthesis" driven by millions of satellite data points and space sector research'),
    t('regrow-ai-pro', freeTier:'Institutional only', price:0, tips:'The choices of global food giants (Kellogg\'s, General Mills) | AI-powered "Supply Chain" handles your entire technical field and harvest data cycle'),
    t('trace-genomics-ai', freeTier:'Institutional only', price:0, tips:'The smarter way to manage soil | AI-powered "DNA" sequencing and data mapping used by top tech companies globally for chemical safety'),
    t('rex-ai-pro', freeTier:'Free basic version', price:0, tips:'The ultimate real estate growth platform | AI-powered "Pricing" and "Networking" automation used by top executives to manage their property data'),
    t('uptake-ai-software', freeTier:'Institutional only', price:0, tips:'The industry standard for industrial ML | Features world-class "Knowledge Base" of machine data used by world-class brands (Caterpillar, Rolls-Royce)'),
    t('prospera-app', freeTier:'Free basic version', price:0, tips:'The smartest way to scale farming | AI-powered "Workflow" automation saves thousands of agriculture hours on repetitive data tasks'),
    t('sight-machine-ai', freeTier:'Institutional only', price:0, tips:'Next-gen manufacturing intelligence suite | AI-powered "Analytic" engine ensures your entire shop follows specific data quality benchmarks'),
    t('planet-pro', freeTier:'Free trial available', price:0, tips:'High-end geospatial data assistant | AI-powered "Change" detection handles your entire map data discovery and mapping automatically'),
    t('uptake-intelligence', freeTier:'Institutional only', price:0, tips:'Leading platform for high-end asset management | AI-powered "Risk" and "Opportunity" reports handles your public image data across global infra'),
    t('planet-labs-pro', freeTier:'Free data trial', price:0, tips:'Professional earth observation suite | AI-powered "Land Use" classification is world-class for modern environmental and urban data research'),
    t('sight-machine-pro-ai', freeTier:'Institutional only', price:0, tips:'The choices of global manufacturing giants | AI-powered "Cycle" optimization handles your entire technical production data cycle automatically'),
    t('uptake-software', freeTier:'Institutional only', price:0, tips:'The choices of high-performance energy teams | AI-powered "Reliability" and "Safety" alerts handles your entire hardware data globally'),
    t('planet-intelligence', freeTier:'Free basic access', price:0, tips:'The ultimate tool for geo-spatial researchers | AI-powered "Planetary Variables" handles thousands of global data points for your reports'),
    t('uptake', freeTier:'Institutional only', price:0, tips:'The "Engagement" king of machine apps | Use the "Vibration" sensor for high-impact maintenance data tracking that converts'),
    t('sightmachine', freeTier:'Institutional only', price:0, tips:'The pioneer of digital twin manufacturing | Best for turning any real-world factory into a professional performance for gaming, film, and media data'),
    t('regrow-ag-pro', freeTier:'Institutional only', price:0, tips:'The smartest way to reduce climate impact | AI-powered "Regenerative" models driven by millions of soil science data points'),
    t('trace-genomics-pro', freeTier:'Institutional only', price:0, tips:'Next-gen soil intelligence suite | AI-powered "Attribute" extraction handles your entire field data presence globally for agro-pros'),
    t('planet-engine', freeTier:'Free research trial', price:0, tips:'Leading platform for building Earth AI models | Features incredible "Cloud" and "Motion" capture for high-fidelity planetary data'),
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
