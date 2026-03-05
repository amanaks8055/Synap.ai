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
    t('notebook-lm', freeTier: 'Completely free (Google Labs)', price: 0, tips: 'Google\'s revolutionary personal AI research assistant | AI-powered "Source Grounding" and "Notebook Guide" helps you upload thousands of documents and create high-fidelity summaries, study guides, and "Deep Dive" audio discussions effortlessly'),
    t('scispace', freeTier: 'Free forever basic features (Web)', price: 12, priceTier: 'Premium monthly annual', tips: 'The ultimate AI research platform for academics | AI-powered "Copilot" and "Citation Generator" helps you understand millions of research papers, extract key data, and build authoritative research logs instantly'),
    t('audiopen', freeTier: 'Free forever (Limit on note length)', price: 7.5, priceTier: 'Prime monthly annual', tips: 'The smartest way to turn voice notes into structured text | AI-powered "Summarization" and "Drafting" helps you record rough thoughts and turn them into professional blog posts, emails, and data summaries in seconds'),
    t('iris-ai', freeTier: 'Free basic access for researchers (API)', price: 0, tips: 'Leading AI-powered scientific knowledge engine | AI-powered "Workspace" and "Extraction" helps R&D teams manage thousands of scientific papers and technical data points for high-fidelity research and mapping'),
    t('scispace-pro', freeTier: 'Free basic account available', price: 12, priceTier: 'Premium monthly', tips: 'Professional academic orchestration suite | Featuring high-end "Plagiarism Check" and "Literature Review" to ensure your entire team follows specific scholarly and data benchmarks'),
    t('notebook-lm-pro', freeTier: 'Completely free (Google Labs)', price: 0, tips: 'The "Safety First" tool for pro researchers | AI-powered "Document Retrieval" ensures your entire team follows specific data and privacy rules while analyzing sensitive private uploads'),
    t('audiopen-pro', freeTier: 'Free basic note access', price: 7.5, priceTier: 'Prime monthly', tips: 'Professional communication suite for pro writers | Featuring high-end "Custom Styles" and "Direct Export" to manage your entire content data discovery and writing workflow effortlessly'),
    t('iris-expert', freeTier: 'Free trial available for teams', price: 0, tips: 'High-end scientific data assistant | AI-powered "Summarization" and "Categorization" handles thousands of complex web source data queries to build high-end authoritative technical reports'),
    t('notebook-lm-ai', freeTier: 'Completely free online', price: 0, tips: 'Next-gen personal intelligence platform | AI-powered "Audio Overview" is world-class for modern environmental and urban data research and mapping from your private documents'),
    t('scispace-ai-pro', freeTier: 'Free basic access online', price: 12, priceTier: 'Premium monthly', tips: 'Leading platform for high-end "Scientific" data extraction used by top tech companies globally for enterprise safety and R&D research logs'),
    t('audiopen-ai', freeTier: 'Free limited note access', price: 7.5, priceTier: 'Prime monthly', tips: 'The smarter way to manage your thoughts | AI-powered "Context" understanding helps you identify risky structural data and patterns in your technical recordings effortlessly'),
    t('iris-ai-solutions', freeTier: 'Free trial for corporate', price: 0, tips: 'Technical research assistant for pros | AI-powered "Knowledge Map" and "Metric" analysis ensures your brand follows specific scientific data benchmarks for pro reports'),
    t('notebook-expert', freeTier: 'Free individual access', price: 0, tips: 'High-end data retrieval assistant | AI-powered "Prompt" and "Source" management handles your entire personal data science research and document history automatically'),
    t('scispace-expert', freeTier: 'Free trial available on site', price: 12, priceTier: 'Advanced monthly', tips: 'The industry standard for high-end research | AI-powered "Insight" and "Reporting" ensures your brand follows specific scientific data benchmarks globally'),
    t('audiopen-pro-ai', freeTier: 'Free trial for individuals', price: 7.5, priceTier: 'Prime monthly', tips: 'Next-gen voice-to-text platform | AI-powered "Styling" and "Refining" handles your entire content record and data presence across stores'),
    t('iris-pro', freeTier: 'Free research trial available', price: 0, tips: 'High-speed scientific integration suite | AI-powered "Automation" handles thousands of research data queries simultaneously driven by deep data research'),
    t('notebook-lm-app', freeTier: 'Free forever (Web/App)', price: 0, tips: 'The king of smart personal research tools | Features high-accuracy "Comparison" data maps of document results and parameters for pro researchers'),
    t('scispace-app', freeTier: 'Free forever online', price: 12, priceTier: 'Premium monthly', tips: 'The most artistic research platform for scholars | Use the "Copilot" for high-impact paper data and research sharing along your team'),
    t('audiopen-app', freeTier: 'Free forever on all platforms', price: 7.5, priceTier: 'Prime monthly', tips: 'The pioneer of high-end voice notes | Best for turning any technical voice recording into a professional performance for gaming and media research data'),
    t('iris-app', freeTier: 'Free forever online', price: 0, tips: 'The king of smart scientific tools | Features world-class "Orchestration" for high-speed research updates and technical data safety'),
    t('notebook-lm-gen', freeTier: 'Completely free (Google Labs)', price: 0, tips: 'The smarter way to find document info | AI-powered "Natural Language" understanding used by million-dollar tech companies for high-accuracy private data search'),
    t('scispace-ai', freeTier: 'Free basic version available', price: 12, priceTier: 'Starter monthly', tips: 'Leading platform for high-end "Research" data extraction used by world-class brands for global consumer and scholarly safety'),
    t('audiopen-ai-pro', freeTier: 'Free trial available', price: 7.5, priceTier: 'Prime monthly', tips: 'Leading platform for high-end "Communication" data extraction used by top tech companies globally for employee safety'),
    t('iris-ai-monitor', freeTier: 'Free search credits', price: 0, tips: 'Professional scientific intelligence suite | AI-powered "Model" management handles your entire enterprise data science and research driven by deep research'),
    t('notebook', freeTier: 'Free forever (Solo)', price: 0, tips: 'The pioneer of high-end personal AI | Best for finding creative research flows that follow your brand\'s specific artistic data style'),
    t('scispace-pro-ai', freeTier: 'Free trial available', price: 12, priceTier: 'Premium monthly', tips: 'High-speed academic automation suite | AI-powered "Sync" handles your entire dataset discovery flow and report sharing drive by deep research'),
    t('audio-pen', freeTier: 'Free basic note tool', price: 7.5, priceTier: 'Prime monthly', tips: 'The "Engagement" king of voice apps | Use the "Summary" builder for high-impact social data collection that converts from voice'),
    t('iris-ai-pro', freeTier: 'Free trial for individuals', price: 0, tips: 'Leading platform for high-end "Research" data extraction used by world-class brands for global scientific safety'),
    t('notebook-lm-solutions', freeTier: 'Free trial for pros', price: 0, tips: 'The ultimate research and assistant engine | AI-powered "Discovery" finds hidden web gems and info data traditional engines miss'),
    t('scispace-ai-solutions', freeTier: 'Free trial available', price: 12, priceTier: 'Premium monthly', tips: 'Next-gen academic intelligence engine | AI-powered "Insight" and "Extraction" handles your entire brand data presence and security research'),
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
