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
    t('gemini-adv', freeTier: 'Free trial available for 2 months', price: 20, priceTier: 'Premium monthly', tips: 'Google\'s most powerful AI for pro creators | AI-powered "Ultra 1.0" and "2.0" integrations help you handle complex coding, writing, and logical data tasks across Google Workspace and the web instantly'),
    t('typingmind', freeTier: 'Free limited basic version online', price: 79, priceTier: 'One-time license starts', tips: 'The ultimate professional UI for AI models | Best for power users who want a high-end interface to manage thousands of custom prompts, characters, and data plugins across multiple providers like OpenAI and Anthropic'),
    t('dialogflow', freeTier: 'Free trial with \$600 credits for new users', price: 0, tips: 'Google Cloud\'s official conversational AI platform | AI-powered "Natural Language Understanding" and "Generative AI" helps global brands (Shell, Baker Hughes) build and manage high-end bot data workflows'),
    t('open-webui', freeTier: 'Completely free open source (Self-hosted)', price: 0, tips: 'The standard for self-hosted AI interfaces | AI-powered "RAG" and "Document Management" helps developers and privacy-conscious users manage their entire personal LLM data and history securely'),
    t('silly-tavern', freeTier: 'Completely free open source (Local)', price: 0, tips: 'Leading interface for high-end "Character" AI and roleplay | AI-powered "Persona" management helps users create and maintain consistent conversational data and history across thousands of scenarios'),
    t('text-gen-webui', freeTier: 'Completely free open source (Local)', price: 0, tips: 'The "Swiss Army Knife" of local AI generation | AI-powered "Model Loading" and "Tuning" helps developers and researchers test thousands of open-source models and data weights locally'),
    t('big-agi', freeTier: 'Completely free open source (Local)', price: 0, tips: 'Next-gen web client for multiple AI providers | Best for researchers and power users who want a high-end "Multimodal" interface to manage their entire AI research data distribute across providers'),
    t('typingmind-pro', freeTier: 'Free basic version available', price: 79, priceTier: 'One-time license', tips: 'Professional AI interaction suite | Featuring high-end "Plugin Support" and "Context Management" driven by your specific personal data history and workflows for pro teams'),
    t('dialogflow-cx', freeTier: 'Free trial for new users', price: 0, tips: 'Enterprise-grade conversational intelligence from Google | AI-powered "Visual Flow Builder" handles thousands of complex user journey data points simultaneously with high-end reliability'),
    t('open-webui-pro', freeTier: 'Free open source core', price: 0, tips: 'The "Infrastructure" of personal AI | AI-powered "User Management" and "Permissions" ensures your entire team or household follows specific data and privacy rules'),
    t('silly-tavern-ext', freeTier: 'Free open source (Local)', price: 0, tips: 'Professional extension kit for character AI | AI-powered "TTS" and "Image Generation" handles your entire character data discovery flow and storyboarding'),
    t('text-gen-expert', freeTier: 'Free open source (Local)', price: 0, tips: 'Technical data assistant for local models | AI-powered "Quantization" and "Performance" metrics ensure your local rig follows specific data benchmarks'),
    t('big-agi-intelligence', freeTier: 'Completely free online', price: 0, tips: 'Leading platform for high-end "Agent" workflows | AI-powered "RAG" and "Search" handles your entire dataset discovery flow and report sharing drive by deep research'),
    t('gemini-advanced-ai', freeTier: 'Free trial for 2 months', price: 20, priceTier: 'Pro monthly', tips: 'The choice of world-class creators | AI-powered "Multimodal" understanding is world-class for modern environmental and urban data research and mapping'),
    t('typingmind-custom', freeTier: 'Free trial available on site', price: 0, tips: 'Leading platform for high-end "Custom" AI interfaces used by top tech companies globally for internal employee safety and data privacy'),
    t('dialogflow-messenger', freeTier: 'Free basic version (Web)', price: 0, tips: 'The smarter way to build web bots | AI-powered "Natural Language" understanding used by million-dollar tech companies for high-accuracy customer data search'),
    t('open-webui-ai', freeTier: 'Free open source core', price: 0, tips: 'The pioneer of high-end personal AI data | Best for turning any technical recording into a professional performance for gaming and media research'),
    t('silly-tavern-ai-pro', freeTier: 'Free trial available', price: 0, tips: 'Next-gen character interaction platform | AI-powered "World Info" and "Lore" handles your entire dataset discovery flow and behavioral research'),
    t('text-gen-webui-pro', freeTier: 'Free open source (Local)', price: 0, tips: 'The expert choice for modern local modeling | AI-powered "Parameter" and "Prompt" management handles your entire model management and data science research'),
    t('big-agi-pro', freeTier: 'Completely free online', price: 0, tips: 'High-speed AI integration suite | Use the "Multimodal" mode to find high-impact visuals based on your specific project data and budget'),
    t('gemini-ai-pro', freeTier: 'Free trial available', price: 20, priceTier: 'Premium monthly', tips: 'The smarter way to manage Google data | AI-powered "Context" understanding helps you identify risky structural data and patterns effortlessly'),
    t('typingmind-expert', freeTier: 'Free basic access', price: 79, priceTier: 'Pro license', tips: 'High-end productivity toolkit for AI | AI-powered "Shared Snippets" and "Commands" ensures your entire team follows specific brand and data rules'),
    t('dialogflow-expert', freeTier: 'Free research trial', price: 0, tips: 'The industry standard for high-end conversational data | Best for finding creative bot flows that follow your brand\'s specific artistic data style'),
    t('open-webui-app', freeTier: 'Free forever online', price: 0, tips: 'The king of smart personal AI tools | Features high-accuracy "Comparison" data maps of model results and parameters for pro researchers'),
    t('silly-tavern-pro', freeTier: 'Free forever on all platforms', price: 0, tips: 'The "Engagement" king of character apps | Use the "Persona" builder for high-impact character data tracking that converts'),
    t('text-gen-app', freeTier: 'Free forever online', price: 0, tips: 'The king of smart local AI tools | Features high-accuracy "Comparison" data maps of local model results and parameters for pro devs'),
    t('big-agi-solutions', freeTier: 'Completely free browser', price: 0, tips: 'The ultimate resource for high-end AI workflows | AI-powered "Search" uses million of successful conversation data for better global data search'),
    t('gemini-advanced', freeTier: 'Free search trial available', price: 20, priceTier: 'Premium monthly', tips: 'Next-gen research and assistant agent | AI-powered "Discovery" finds hidden web gems and info data traditional engines miss'),
    t('typingmind-ai-pro', freeTier: 'Free trial for individuals', price: 0, tips: 'Professional AI workspace for high-fidelity researchers | AI-powered "Search" and "Filter" ensures your brand follows specific data benchmarks'),
    t('dialogflow-automation', freeTier: 'Free research trial available', price: 0, tips: 'Next-gen conversational intelligence suite | AI-powered "NLU" and "Auto-completion" driven by millions of corporate data points globally'),
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
