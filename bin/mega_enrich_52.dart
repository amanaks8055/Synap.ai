// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'env.dart';

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
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
  final client = HttpClient();

  final tools = <Map<String, dynamic>>[
    t('jan-ai', freeTier: 'Completely free open source (Desktop App)', price: 0, tips: 'The world leader in local AI desktop clients | AI-powered "Model Hub" and "History" helps you run LLMs (Llama, Mistral) locally and manage all your private research data without any cloud or internet dependency'),
    t('librechat', freeTier: 'Completely free open source (Self-hosted)', price: 0, tips: 'The ultimate professional UI for multiple AI models | Best for teams who want a high-end interface to manage their entire organization\'s prompt data, history, and user settings across OpenAI, Anthropic, and local models'),
    t('jetson', freeTier: 'Hardware purchase required (Community OS free)', price: 0, tips: 'NVIDIA\'s premier platform for Edge AI and Robotics | AI-powered "DeepStream" and "Isaac" helps hardware engineers manage thousands of sensor data points and real-time vision tasks on compact, high-performance hardware'),
    t('alexa-ai', freeTier: 'Free with Amazon devices and app', price: 0, tips: 'The world\'s most popular smart home assistant | AI-powered "Skills" and "Smart Home" automation helps you manage your entire household data, shopping, and entertainment using high-end voice research logs'),
    t('google-home-ai', freeTier: 'Free with Google devices and Home app', price: 0, tips: 'Leading smart home ecosytem with deep AI | AI-powered "Gemini" and "Routines" handles your entire smart device data and personal scheduling across your household and mobile devices effortlessly'),
    t('coral-ai', freeTier: 'Hardware purchase required (Tools free)', price: 0, tips: 'Google\'s official platform for high-speed Edge AI | AI-powered "Edge TPU" and "TensorFlow Lite" helps developers build high-fidelity vision and audio data apps on low-power, compact industrial hardware'),
    t('koboldai', freeTier: 'Completely free open source (Local)', price: 0, tips: 'Leading interface for high-end local text generation and storytelling | AI-powered "Authoring" tools help users create and maintain consistent conversational data and fictional history across thousands of scenarios'),
    t('librechat-pro', freeTier: 'Free open source core', price: 0, tips: 'Professional AI team management suite | Featuring high-end "User Roles" and "Admin Dashboard" to ensure your entire organization follows specific data sharing and privacy rules'),
    t('jan-ai-pro', freeTier: 'Free open source (Local)', price: 0, tips: 'High-end local AI discovery suite for pro teams | AI-powered "API Builder" handles your entire enterprise data science and research driven by deep research logs'),
    t('jetson-ai-plus', freeTier: 'Hardware focus (SDKs free)', price: 0, tips: 'Professional edge intelligence suite | Featuring high-end "Edge AI" in complex industrial environments using deep camera and sensor data research'),
    t('alexa-pro', freeTier: 'Free basic access on devices', price: 0, tips: 'The "Safety First" tool for smart homes | AI-powered "Guard" and "Alerting" handles your entire household security and data presence globally via enterprise voice'),
    t('google-home-pro', freeTier: 'Free basic access on devices', price: 0, tips: 'The choice of global smart device giants | AI-powered "Automation" handles your entire team\'s technical resource data cycle automatically driven by deep research'),
    t('coral-expert', freeTier: 'Hardware focus (Tools free)', price: 0, tips: 'High-speed Edge AI research toolkit | AI-powered "Compiler" and "Tuning" ensures your local rig follows specific data benchmarks for high-impact results'),
    t('koboldai-pro', freeTier: 'Free open source (Local)', price: 0, tips: 'Technical data assistant for local storage | AI-powered "Memory" and "Context" management handles your entire character data science research and fictional history'),
    t('librechat-ai-solutions', freeTier: 'Free open source (Self-hosted)', price: 0, tips: 'The smarter way to build enterprise AI apps | AI-powered "Search" and "RAG" handles your entire dataset discovery flow and report sharing drive by deep research'),
    t('jan-expert', freeTier: 'Free open source (Local)', price: 0, tips: 'Professional local AI assistant | AI-powered "Optimization" handles thousands of model data queries and parameters for pro researchers'),
    t('jetson-enterprise', freeTier: 'Hardware focus', price: 0, tips: 'Leading platform for high-end "Vision" data extraction used by top tech companies globally for autonomous machine safety'),
    t('alexa-ai-pro', freeTier: 'Free trial available', price: 0, tips: 'Professional conversational automation suite | Featuring high-end "Routine" matching in complex home environments using deep data research and history'),
    t('google-home-ai-pro', freeTier: 'Free trial for devices', price: 0, tips: 'Next-gen smart home intelligence engine | AI-powered "Gemini" insights driven by millions of user data points and behavioral research'),
    t('coral-ai-pro', freeTier: 'Hardware focus', price: 0, tips: 'The utility-first edge AI tool | Best for turning any technical site recording into a professional performance for gaming and media research'),
    t('kobold-ai', freeTier: 'Free open source (Local)', price: 0, tips: 'The "Engagement" king of character storage | Use the "Prompt" builder for high-impact social data flows and character sharing along your team'),
    t('librechat-app', freeTier: 'Free forever online (Self-hosted)', price: 0, tips: 'The king of smart professional AI tools | Features high-accuracy "Comparison" data maps of model results and parameters for pro analysts'),
    t('jan-app', freeTier: 'Free forever (Web/App)', price: 0, tips: 'The most artistic local AI platform | Use the "Artistic" filters for high-impact chat data and model sharing along your team'),
    t('jetson-pro', freeTier: 'Hardware focus', price: 0, tips: 'The "Power-user" of robotics | AI-powered "Deployment" management uses million of successful machine data for better global hardware reach'),
    t('alexa', freeTier: 'Free basic tool', price: 0, tips: 'The industry standard for high-end voice automation | AI-powered "Analytics" and "Reporting" ensures your brand follows specific data benchmarks'),
    t('google-home', freeTier: 'Free basic tool', price: 0, tips: 'The pioneer of high-end home AI | AI-powered "Relationship" and "Tagging" handles your entire data presence and security research'),
    t('coral', freeTier: 'Hardware focus', price: 0, tips: 'The ultimate resource for high-end edge AI hardware | Best for finding creative data flows that follow your brand\'s specific artistic data style'),
    t('koboldai-expert', freeTier: 'Free open source (Local)', price: 0, tips: 'Professional local storytelling assistant | AI-powered "Lorebook" and "Scenarios" ensure your brand follows specific data benchmarks'),
    t('libre-chat', freeTier: 'Free trial available', price: 0, tips: 'Leading platform for high-end "Enterprise" data extraction used by top tech companies globally for internal data safety'),
    t('jan-ai-solutions', freeTier: 'Free open source (Local)', price: 0, tips: 'The pioneer of high-end local AI software | Best for turning any technical recording into a professional performance for gaming and media data'),
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
