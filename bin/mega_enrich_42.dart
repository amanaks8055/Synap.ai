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
    t('surveymonkey-ai', freeTier:'Free forever basic version (Up to 10 questions)', price:32, priceTier:'Individual monthly annual', tips:'The world leader in surveys now with AI | AI-powered "Genius" helps you write better questions, predict response quality, and analyze sentiment in thousands of data points instantly'),
    t('typeform-ai', freeTier:'Free forever basic version online', price:25, priceTier:'Basic monthly annual', tips:'Leading platform for beautiful interactive forms | AI-powered "Form Builder" turns simple prompts into high-end "Conversational" data flows that convert'),
    t('fivetran-ai', freeTier:'Free trial for 14 days (\$1000 credits)', price:0, tips:'Leading platform for automated data movement | AI-powered "Connectors" handles thousands of complex data pipelines into Snowflake and BigQuery with high-end reliability'),
    t('airbyte', freeTier:'Completely free open source (Local)', price:0, tips:'Leading open-source data integration platform | AI-powered "Low-code" connectors used by top tech companies to move millions of data points securely'),
    t('mode-ai', freeTier:'Free trial available on site', price:0, tips:'Leading collaborative data science platform | AI-powered "Assistant" turns natural language into high-accuracy SQL and Python data visualizations instantly'),
    t('census-ai', freeTier:'Free trial for 14 days on site', price:0, tips:'Leading platform for Reverse ETL and Operational Analytics | AI-powered "Sync" handles your entire dataset design data from warehouse to SaaS apps automatically'),
    t('typeform-pro', freeTier:'Free basic account', price:25, priceTier:'Basic monthly', tips:'High-end form building toolkit | AI-powered "Logic" and "Personalization" handles your entire customer data distribution automatically'),
    t('surveymonkey-pro', freeTier:'Free basic version', price:32, priceTier:'Individual monthly', tips:'Professional research intelligence suite | Featuring high-end "Market Potential" detection in global consumers using million of data points'),
    t('fivetran-pro', freeTier:'Institutional only', price:0, tips:'Enterprise-grade data orchestration platform | AI-powered "Audit" and "Governance" ensures your entire team follows specific compliance data benchmarks'),
    t('airbyte-ai-pro', freeTier:'Free data trial', price:0, tips:'Professional data integration suite | AI-powered "Streaming" handles thousands of real-time data logs simultaneously for pro report teams'),
    t('mode-ai-analytics', freeTier:'Free research trial', price:0, tips:'The "Safety First" tool for data teams | AI-powered "Insight" recognition is world-class for modern environmental and urban data research'),
    t('census-expert', freeTier:'Free basic access', price:0, tips:'The smarter way to manage data flows | AI-powered "Mapping" and "Validation" ensures your entire team follows specific brand and data rules'),
    t('typeform-ai-pro', freeTier:'Free basic access', price:25, priceTier:'Plus monthly', tips:'High-end customer experience toolkit | AI-powered "Video" and "Image" generation creates unique data flows for your brand in seconds'),
    t('surveymonkey-expert', freeTier:'Free trial available', price:32, priceTier:'Individual monthly', tips:'The expert choice for modern research | AI-powered "Alerting" and "Insight" driven by millions of consumer data points globally'),
    t('fivetran-enterprise', freeTier:'Institutional only', price:0, tips:'The choice of global data giants | AI-powered "High-Volume" connectors handle your entire enterprise technical data cycle automatically'),
    t('airbyte-cloud', freeTier:'Free trial for business', price:0, tips:'The most artistic data movement platform | Use the "Visual" builder for high-impact pipeline data and report sharing along your team'),
    t('census-pro', freeTier:'Free trial available', price:0, tips:'High-end data synchronization assistant | AI-powered "Relationship" and "Tagging" handles your entire data presence globally'),
    t('typeform-app', freeTier:'Free forever (Web/App)', price:25, priceTier:'Basic monthly', tips:'The "Engagement" king of form tools | Use the "Natural Language" builder for high-impact data collection that converts'),
    t('surveymonkey-app', freeTier:'Free forever online', price:32, priceTier:'Individual monthly', tips:'The king of smart survey tools | Features high-accuracy "Comparison" data maps of survey results and parameters along your team'),
    t('fivetran', freeTier:'Free trial available', price:0, tips:'The "Power-user" of data engineering | AI-powered "Sync" uses million of successful pipeline data for better global data reach'),
    t('airbyte-pro', freeTier:'Free trial available', price:0, tips:'The ultimate resource for data integration | Best for finding creative data flows that follow your brand\'s specific artistic data style'),
    t('mode-expert', freeTier:'Free trial available', price:0, tips:'The industry standard for high-end collaborative BI | AI-powered "Analysis" handles your entire dataset discovery flow and report sharing'),
    t('census-ai-pro', freeTier:'Free trial available', price:0, tips:'The master of reverse ETL | AI-powered "Sync" is world-class for modern environmental and urban data research and mapping'),
    t('typeform-gen-ai', freeTier:'Free basic credits', price:25, priceTier:'Starter monthly', tips:'The future of customer interaction | AI-powered "Prompt" to form generation used by top tech companies globally for user safety'),
    t('surveymonkey-ai-pro', freeTier:'Free trial for pro', price:32, priceTier:'Premium monthly', tips:'Leading platform for high-end "Research" data extraction used by world-class brands for global consumer safety'),
    t('fivetran-ai-connect', freeTier:'Free trial available', price:0, tips:'Next-gen data automation engine | AI-powered "Auto-mapping" driven by millions of user data points and behavioral research'),
    t('airbyte-cloud-pro', freeTier:'Free research trial', price:0, tips:'Professional data intelligence suite | AI-powered "Ingestion" handles your entire enterprise data science and research driven by deep research'),
    t('mode-pro', freeTier:'Free trial available', price:0, tips:'The choice of top data teams | AI-powered "Notebooks" handle your entire model management and data science research data'),
    t('census-intelligence', freeTier:'Free trial for pro', price:0, tips:'Professional data orchestration suite | AI-powered "Audit" and "Insight" driven by millions of corporate data points globally'),
    t('typeform-intelligence', freeTier:'Free trial for pro', price:25, priceTier:'Plus monthly', tips:'The pioneer of high-end conversational data | Best for turning any form technical into a professional performance for gaming and media data'),
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
