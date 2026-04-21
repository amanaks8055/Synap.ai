// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'env.dart';

void main() async {
  final supabaseUrl = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;
  final client = HttpClient();

  // ── Fetch all tools with full data ──
  print('Fetching tools...');
  final getReq = await client.getUrl(
    Uri.parse('$supabaseUrl/rest/v1/ai_tools?select=*&limit=2000'),
  );
  getReq.headers.set('apikey', anonKey);
  final getResp = await getReq.close();
  final body = await getResp.transform(utf8.decoder).join();
  final List<dynamic> tools = jsonDecode(body);
  print('Found ${tools.length} tools');

  // ── Update each tool with icon_url from Clearbit ──
  final updates = <Map<String, dynamic>>[];
  for (final tool in tools) {
    final id = tool['id'] as String;
    final name = tool['name'] as String;
    final url = (tool['website_url'] as String?) ?? '';
    if (url.isEmpty) continue;

    String domain;
    try {
      domain = Uri.parse(url).host;
      if (domain.isEmpty) {
        domain = url.replaceAll('https://', '').replaceAll('http://', '').split('/').first;
      }
    } catch (_) {
      domain = url.replaceAll('https://', '').replaceAll('http://', '').split('/').first;
    }

    final iconUrl = 'https://logo.clearbit.com/$domain';

    // MUST include all required fields (id + name) for upsert
    updates.add({
      'id': id,
      'name': name,
      'icon_url': iconUrl,
    });
  }

  print('Updating ${updates.length} tools with logos...');

  const batchSize = 50;
  var done = 0;
  for (var i = 0; i < updates.length; i += batchSize) {
    final end = (i + batchSize > updates.length) ? updates.length : i + batchSize;
    final batch = updates.sublist(i, end);
    final jsonBody = utf8.encode(jsonEncode(batch));

    final req = await client.postUrl(Uri.parse('$supabaseUrl/rest/v1/ai_tools'));
    req.headers.set('apikey', anonKey);
    req.headers.set('Authorization', 'Bearer $anonKey');
    req.headers.set('Content-Type', 'application/json; charset=utf-8');
    req.headers.set('Prefer', 'resolution=merge-duplicates');
    req.contentLength = jsonBody.length;
    req.add(jsonBody);

    final resp = await req.close();
    final respBody = await resp.transform(utf8.decoder).join();
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      done += batch.length;
      print('Logo $done/${updates.length}');
    } else {
      print('FAIL [${resp.statusCode}] $respBody');
    }
  }

  // ── Rich data for popular tools ──
  print('Adding rich data to top tools...');

  final richData = <Map<String, dynamic>>[
    {'id': 'poe', 'name': 'Poe', 'free_limit_description': '3000 compute points/day, limited GPT-4 & Claude access', 'paid_price_monthly': 20, 'paid_tier_description': 'Unlimited GPT-4o, Claude 3.5, Gemini Pro, and 100+ bots', 'optimization_tips': 'Use smaller models for simple tasks | Save compute points for complex queries | Create custom bots for repetitive tasks'},
    {'id': 'microsoft-copilot', 'name': 'Microsoft Copilot', 'free_limit_description': 'Unlimited GPT-4 chat with Bing search, image generation', 'paid_price_monthly': 20, 'paid_tier_description': 'Pro: Priority access, faster responses, DALL-E 3 boosts', 'optimization_tips': 'Use Edge browser for best integration | Try image generation with Designer | Use Copilot in Word, Excel, PowerPoint'},
    {'id': 'google-bard', 'name': 'Google Gemini', 'free_limit_description': 'Unlimited Gemini Pro chat, image analysis, Google integration', 'paid_price_monthly': 20, 'paid_tier_description': 'Advanced: Gemini Ultra, 1M token context, Gems, Deep Research', 'optimization_tips': 'Connect Google Workspace for context | Use Gems for specialized tasks | Try Deep Research for complex topics'},
    {'id': 'deepseek-chat', 'name': 'DeepSeek Chat', 'free_limit_description': 'Free unlimited chat with DeepSeek-V3 and R1 reasoning', 'paid_price_monthly': 0, 'paid_tier_description': 'Free with API pricing at \$0.14/M input tokens', 'optimization_tips': 'Use R1 for math and coding problems | Switch to V3 for faster general chat | DeepThink mode for step-by-step reasoning'},
    {'id': 'meta-ai', 'name': 'Meta AI', 'free_limit_description': 'Unlimited free chat across WhatsApp, Instagram, Facebook', 'paid_price_monthly': 0, 'paid_tier_description': 'Completely free with Meta account', 'optimization_tips': 'Use in WhatsApp for quick answers | Generate images with Imagine | Ask follow-up questions for deeper answers'},
    {'id': 'grok', 'name': 'Grok (xAI)', 'free_limit_description': '10 Grok-2 and 3 Grok-3 messages every 2 hours on X', 'paid_price_monthly': 8, 'paid_tier_description': 'X Premium: Higher limits, early access to new models', 'optimization_tips': 'Use for real-time X/Twitter data analysis | Try DeepSearch for research | Best for current events and trending topics'},
    {'id': 'character-ai', 'name': 'Character.AI', 'free_limit_description': 'Unlimited character chats, community characters', 'paid_price_monthly': 10, 'paid_tier_description': 'c.ai+: Priority chat, skip waiting, faster responses', 'optimization_tips': 'Create detailed character descriptions | Use memory feature for continuity | Try roleplay scenarios for creative writing'},
    {'id': 'groq', 'name': 'Groq Chat', 'free_limit_description': 'Free API with rate limits, 30 req/min on Llama 3', 'paid_price_monthly': 0, 'paid_tier_description': 'Free with rate limits, pay-as-you-go for higher volume', 'optimization_tips': 'Fastest inference available | Great for Llama 3 70B at 300+ tok/sec | Use for real-time chatbot apps'},
    {'id': 'ollama', 'name': 'Ollama', 'free_limit_description': 'Completely free and open source, run models locally', 'paid_price_monthly': 0, 'paid_tier_description': 'Free forever, runs on your hardware', 'optimization_tips': 'Use smaller models 7B for faster responses | Run Llama 3 or Mistral for best quality | Combine with Open WebUI'},
    {'id': 'grammarly', 'name': 'Grammarly', 'free_limit_description': 'Basic grammar, spelling, and punctuation unlimited', 'paid_price_monthly': 12, 'paid_tier_description': 'Premium: Tone, clarity, full-sentence rewrites, plagiarism', 'optimization_tips': 'Install browser extension everywhere | Use tone detector for emails | Set language preferences for your region'},
    {'id': 'quillbot', 'name': 'QuillBot', 'free_limit_description': '125 words per paraphrase, 3 modes, limited summarizer', 'paid_price_monthly': 10, 'paid_tier_description': 'Premium: Unlimited words, all 9 modes, faster processing', 'optimization_tips': 'Use Standard mode for academic writing | Fluency mode for non-native speakers | Combine with grammar checker'},
    {'id': 'ideogram', 'name': 'Ideogram', 'free_limit_description': '10 generations per day with standard speed', 'paid_price_monthly': 8, 'paid_tier_description': 'Plus: 400 priority generations/month, private mode', 'optimization_tips': 'Best AI for text in images | Use Magic Prompt for better results | Specify fonts and styles for text rendering'},
    {'id': 'canva-ai', 'name': 'Canva AI', 'free_limit_description': '50 image generations per month, basic templates', 'paid_price_monthly': 13, 'paid_tier_description': 'Pro: 500 gen/month, brand kit, premium templates, 100GB', 'optimization_tips': 'Use Magic Write for copy | Magic Eraser removes objects | Create brand kits for consistency'},
    {'id': 'remove-bg', 'name': 'Remove.bg', 'free_limit_description': 'Free previews, 1 free HD download per account', 'paid_price_monthly': 9, 'paid_tier_description': '40 credits/month for HD downloads, API access', 'optimization_tips': 'Works on people, products, and animals | Use API for batch | Combine with Canva for quick designs'},
    {'id': 'cursor', 'name': 'Cursor', 'free_limit_description': '2000 completions/month, 50 premium requests', 'paid_price_monthly': 20, 'paid_tier_description': 'Pro: 500 fast premium requests, unlimited slow', 'optimization_tips': 'Use Cmd+K for inline edits | @codebase to search project | Composer for multi-file changes'},
    {'id': 'github-copilot', 'name': 'GitHub Copilot', 'free_limit_description': 'Free for students and open-source maintainers', 'paid_price_monthly': 10, 'paid_tier_description': 'Individual: Unlimited suggestions, chat, CLI assistant', 'optimization_tips': 'Write clear comments before functions | Accept with Tab | Use chat for complex refactoring'},
    {'id': 'codeium', 'name': 'Codeium', 'free_limit_description': 'Free unlimited code completion for individuals forever', 'paid_price_monthly': 0, 'paid_tier_description': 'Teams: \$12/user/month for team features', 'optimization_tips': 'Supports 70+ languages | Install in VS Code and JetBrains | Use chat for code explanations'},
    {'id': 'bolt', 'name': 'Bolt.new', 'free_limit_description': 'Limited free messages, basic project generation', 'paid_price_monthly': 20, 'paid_tier_description': 'Pro: 10M tokens, unlimited projects, deploy credits', 'optimization_tips': 'Great for full-stack web apps | Uses latest frameworks | Deploy directly to Netlify'},
    {'id': 'sora', 'name': 'Sora (OpenAI)', 'free_limit_description': '50 generations/month at 480p with Plus plan', 'paid_price_monthly': 20, 'paid_tier_description': 'Pro: 500 priority gens, 1080p, unlimited relaxed', 'optimization_tips': 'Use detailed scene descriptions | Specify camera angles | Start with shorter clips then extend'},
    {'id': 'opus-clip', 'name': 'Opus Clip', 'free_limit_description': '10 clips from one video, watermarked output', 'paid_price_monthly': 19, 'paid_tier_description': 'Starter: 100 clips/month, no watermark, auto-captions', 'optimization_tips': 'Upload long-form for best clip detection | AI scores identify moments | Auto captions included'},
    {'id': 'descript', 'name': 'Descript', 'free_limit_description': '1 hour transcription, 5 AI actions, screen recording', 'paid_price_monthly': 24, 'paid_tier_description': 'Pro: 20hrs transcription, unlimited AI, 4K export', 'optimization_tips': 'Edit video by editing text | Clone voice with Overdub | Remove filler words in one click'},
    {'id': 'udio', 'name': 'Udio', 'free_limit_description': '1200 free credits/month for song generation', 'paid_price_monthly': 10, 'paid_tier_description': 'Standard: 1200 credits/month, commercial license, stems', 'optimization_tips': 'Specify genre, mood, instruments | Use negative tags | Extend songs with continuations'},
    {'id': 'speechify', 'name': 'Speechify', 'free_limit_description': 'Limited free TTS with basic voices and 150 WPM', 'paid_price_monthly': 12, 'paid_tier_description': 'Premium: 30+ HD voices, OCR, speed up to 900 WPM', 'optimization_tips': 'Read articles and docs aloud | Chrome extension for any page | Adjust speed for learning'},
    {'id': 'krisp', 'name': 'Krisp', 'free_limit_description': '60 min/day noise cancellation for calls', 'paid_price_monthly': 8, 'paid_tier_description': 'Pro: Unlimited noise cancel, meeting notes, summaries', 'optimization_tips': 'Works with Zoom, Teams, Meet | Background voice cancel | Enable for all calls'},
    {'id': 'gamma', 'name': 'Gamma App', 'free_limit_description': '400 free AI credits, unlimited presentations with watermark', 'paid_price_monthly': 10, 'paid_tier_description': 'Plus: Unlimited AI, no watermark, custom fonts', 'optimization_tips': 'Paste outline for structured presentations | Export to PDF/PowerPoint | Card layouts for modern look'},
    {'id': 'notion-ai', 'name': 'Notion AI', 'free_limit_description': '20 free AI responses then requires add-on', 'paid_price_monthly': 10, 'paid_tier_description': 'AI Add-on: Unlimited AI blocks per member', 'optimization_tips': 'Summarize meeting notes auto | Generate action items | AI-fill database properties'},
    {'id': 'otter-ai', 'name': 'Otter.ai', 'free_limit_description': '300 min/month transcription, 30 min per session', 'paid_price_monthly': 17, 'paid_tier_description': 'Pro: 1200 min/month, 90 min sessions, AI chat', 'optimization_tips': 'Auto-joins Zoom/Teams | Search across meetings | Export summaries to Slack'},
    {'id': 'deepl', 'name': 'DeepL', 'free_limit_description': '500,000 characters/month free translation', 'paid_price_monthly': 9, 'paid_tier_description': 'Pro: Unlimited translation, documents, API access', 'optimization_tips': 'Best accuracy for European languages | Glossary for terms | Translate docs with formatting'},
    {'id': 'semrush-ai', 'name': 'Semrush AI', 'free_limit_description': '10 free keyword searches/day, limited site audit', 'paid_price_monthly': 130, 'paid_tier_description': 'Pro: 500 keywords, 10k results, 5 projects', 'optimization_tips': 'Keyword Magic Tool for long-tail | Track competitor rankings | Content AI for SEO articles'},
    {'id': 'jasper-ai', 'name': 'Jasper AI', 'free_limit_description': '7-day free trial with full access', 'paid_price_monthly': 39, 'paid_tier_description': 'Creator: 1 brand voice, SEO mode, unlimited AI words', 'optimization_tips': 'Train brand voice for consistency | Templates for formats | Campaigns plan content strategy'},
    {'id': 'khanmigo', 'name': 'Khanmigo', 'free_limit_description': 'Free for all learners with Khan Academy account', 'paid_price_monthly': 0, 'paid_tier_description': 'Free, supported by philanthropy', 'optimization_tips': 'Step-by-step explanations | Socratic method for learning | Math, science, humanities'},
    {'id': 'duolingo-ai', 'name': 'Duolingo Max', 'free_limit_description': 'Free basic lessons with ads and hearts', 'paid_price_monthly': 7, 'paid_tier_description': 'Max: AI roleplay, explanations, no ads, unlimited hearts', 'optimization_tips': 'Daily streak for consistency | Roleplay for conversation | Mistake explanations show grammar'},
    {'id': 'autogpt', 'name': 'AutoGPT', 'free_limit_description': 'Open source, free to self-host and run', 'paid_price_monthly': 0, 'paid_tier_description': 'Free, requires your own LLM API keys', 'optimization_tips': 'Best for multi-step automated tasks | Set clear goals | Monitor to prevent loops'},
    {'id': 'julius-ai', 'name': 'Julius AI', 'free_limit_description': 'Limited free data analysis and charts', 'paid_price_monthly': 20, 'paid_tier_description': 'Pro: Unlimited analysis, advanced charts, exports', 'optimization_tips': 'Upload Excel/CSV for insights | Ask in plain English | Publication-ready visualizations'},
    {'id': 'cleo', 'name': 'Cleo AI', 'free_limit_description': 'Free budget tracking, spending insights, roast mode', 'paid_price_monthly': 6, 'paid_tier_description': 'Plus: Cash advance up to 250, credit building', 'optimization_tips': 'Use roast mode for honest feedback | Budget categories | Auto-save builds emergency fund'},
    {'id': 'ada-health', 'name': 'Ada Health', 'free_limit_description': 'Unlimited free symptom assessments', 'paid_price_monthly': 0, 'paid_tier_description': 'Free for consumers', 'optimization_tips': 'Answer honestly for accuracy | Not a doctor replacement | Track symptoms over time'},
    {'id': 'framer-ai', 'name': 'Framer AI', 'free_limit_description': 'Free with Framer branding, 1000 visitors/month', 'paid_price_monthly': 5, 'paid_tier_description': 'Mini: Custom domain, 10K visitors, 150 CMS items', 'optimization_tips': 'AI generates full website from text | Publish instantly | Use components for consistency'},
    {'id': 'looka', 'name': 'Looka', 'free_limit_description': 'Free logo previews, pay for high-res downloads', 'paid_price_monthly': 0, 'paid_tier_description': 'Basic Logo: \$20 one-time, Premium: \$65 brand kit', 'optimization_tips': 'Try many logo variations first | Brand kit with social templates | SVG for scalable logos'},
    {'id': 'adobe-firefly', 'name': 'Adobe Firefly', 'free_limit_description': '25 generative credits per month for images', 'paid_price_monthly': 5, 'paid_tier_description': 'Premium: 100 credits/month, high res, commercial license', 'optimization_tips': 'Structure Reference for consistency | Commercially safe | Integrate with Photoshop'},
    {'id': 'chatpdf', 'name': 'ChatPDF', 'free_limit_description': '2 PDFs/day, 120 pages max, 50 questions/day', 'paid_price_monthly': 5, 'paid_tier_description': 'Plus: 50 PDFs/day, 2000 pages, 1000 questions/day', 'optimization_tips': 'Upload papers for instant Q&A | Summarize sections | Compare documents'},
    {'id': 'consensus', 'name': 'Consensus', 'free_limit_description': '20 free AI searches per month', 'paid_price_monthly': 7, 'paid_tier_description': 'Premium: Unlimited searches, GPT-4 summaries', 'optimization_tips': 'Evidence-based research | Copilot synthesizes papers | Consensus Meter for conclusions'},
    {'id': 'replit-ai', 'name': 'Replit AI', 'free_limit_description': 'Free basic completions and chat in browser IDE', 'paid_price_monthly': 25, 'paid_tier_description': 'Pro: Advanced AI, private repos, boosted deploys', 'optimization_tips': 'Use Agent for full app generation | Instant web deploy | Great for rapid prototyping'},
    {'id': 'v0', 'name': 'v0 by Vercel', 'free_limit_description': '200 free credits monthly for components', 'paid_price_monthly': 20, 'paid_tier_description': 'Premium: 5000 credits, faster gen, priority access', 'optimization_tips': 'Best for React and Next.js UI | Uses Shadcn/Tailwind | Copy code to project directly'},
    {'id': 'invideo-ai', 'name': 'InVideo AI', 'free_limit_description': '10 min/week AI generation, watermarked exports', 'paid_price_monthly': 25, 'paid_tier_description': 'Plus: 50 min/week, no watermark, premium stock', 'optimization_tips': 'Type topic for full video | Edit with text commands | Export for YouTube, TikTok'},
    {'id': 'fathom', 'name': 'Fathom AI', 'free_limit_description': 'Unlimited recording and transcription for calls', 'paid_price_monthly': 0, 'paid_tier_description': 'Free forever for individuals', 'optimization_tips': 'Auto-highlights key moments | One-click summary copy | CRM integration for sales'},
    {'id': 'miro-ai', 'name': 'Miro AI', 'free_limit_description': 'Free for up to 3 editable boards, basic features', 'paid_price_monthly': 8, 'paid_tier_description': 'Starter: Unlimited boards, AI features, templates', 'optimization_tips': 'AI generates mind maps from prompts | Summarize sticky notes | Ideal for team brainstorming'},
    {'id': 'tradingview-ai', 'name': 'TradingView AI', 'free_limit_description': 'Free charts, 1 indicator, basic alerts', 'paid_price_monthly': 13, 'paid_tier_description': 'Pro: 5 indicators, 20 alerts, no ads, extended hrs', 'optimization_tips': 'Pine Script for custom indicators | Alerts for price moves | Multiple timeframes'},
  ];

  var richDone = 0;
  for (var i = 0; i < richData.length; i += 25) {
    final end = (i + 25 > richData.length) ? richData.length : i + 25;
    final batch = richData.sublist(i, end);
    final jsonBody = utf8.encode(jsonEncode(batch));

    final req = await client.postUrl(Uri.parse('$supabaseUrl/rest/v1/ai_tools'));
    req.headers.set('apikey', anonKey);
    req.headers.set('Authorization', 'Bearer $anonKey');
    req.headers.set('Content-Type', 'application/json; charset=utf-8');
    req.headers.set('Prefer', 'resolution=merge-duplicates');
    req.contentLength = jsonBody.length;
    req.add(jsonBody);

    final resp = await req.close();
    final respBody = await resp.transform(utf8.decoder).join();
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      richDone += batch.length;
      print('Rich data: $richDone/${richData.length}');
    } else {
      print('Rich FAIL [${resp.statusCode}] $respBody');
    }
  }

  client.close();
  print('DONE! Logos: $done | Rich data: $richDone');
}
