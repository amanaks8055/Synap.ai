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
    // ━━━ AI AGENTS & FRAMEWORKS ━━━
    t('crew-ai-framework','CrewAI','code','Role-based multi-agent framework to build sophisticated AI teams.','https://crewai.com',true,true,35000, freeTier:'Completely free open source', price:0, tips:'Define agents with roles and goals | Orchestrate complex tasks | Python-first'),
    t('autogpt-ai-pro','AutoGPT','code','An experimental open-source attempt to make GPT-4 fully autonomous.','https://autogpt.net',true,true,150000, freeTier:'Completely free open source', price:0, tips:'Self-writing and executing code | Connects to internet and local files | Leading in autonomous AI'),
    t('baby-agi-ai','BabyAGI','code','Task-driven autonomous agent system using OpenAI and vector databases.','https://github.com/yoheinakajima/babyagi',true,true,58000, freeTier:'Completely free open source', price:0, tips:'Simple and powerful task management | Python-based | Great for agent researchers'),
    t('super-agi-ai','SuperAGI','code','Infrastructure for developers to build, manage and run autonomous AI agents.','https://superagi.com',true,true,45000, freeTier:'Free open source edition', price:0, tips:'Enterprise-grade agents | Multi-model support | Built-in agent marketplace'),
    t('agent-gpt-ai','AgentGPT','code','Platform to assemble, configure, and deploy autonomous AI agents in the browser.','https://agentgpt.reworkd.ai',true,true,120000, freeTier:'Free basic version (3 runs/day)', price:15, priceTier:'Pro: unlimited agents and 더', tips:'No-code agent builder | Shareable agent links | Browser-based'),

    // ━━━ HEALTH & SUPPLEMENTS AI ━━━
    t('examine-ai-pro','Examine.com','health','Independent, science-based source on nutrition and supplements with AI.','https://examine.com',true,true,150000, freeTier:'Free basic info', price:29, priceTier:'Plus monthly', tips:'Most cited supplement research | AI-curated "Human Effect Matrix" | unbiased analysis'),
    t('labcorps-ai','Labcorp','health','Leading global life sciences company using AI for clinical laboratory.','https://labcorp.com',true,true,84000, freeTier:'Free access to results', price:0, tips:'AI-powered pathology | Direct-to-consumer testing | Massive diagnostic database'),
    t('quest-diagnostics-ai','Quest Diagnostics','health','Diagnostic information services company using AI for test optimization.','https://questdiagnostics.com',true,true,82000, freeTier:'Free results portal', price:0, tips:'World leader in lab tests | AI for patient risk assessment | Integrated health records'),
    t('calm-health-ai','Calm Health','health','Mental health solution for organizations and individuals with AI support.','https://calm.com/health',false,true,32000, freeTier:'Institutional only', price:0, tips:'Clinically-validated content | AI for stress monitoring | HIPAA compliant'),
    t('modern-fertility-ai','Modern Fertility (Ro)','health','Personalized fertility tests and AI-powered reproductive tracking.','https://modernfertility.com',false,true,45000, freeTier:'Free app for tracking', price:159, priceTier:'Hormone test kit one-time', tips:'Owned by Ro | Physician-reviewed results | Empowering reproductive health'),

    // ━━━ DEVELOPER TOOLS (Scaling) ━━━
    t('postman-ai-pro','Postman','code','API platform for developers to design, build, and test APIs with AI.','https://postman.com',true,true,250000, freeTier:'Free for small teams', price:15, priceTier:'Basic per user monthly', tips:'AI "Postbot" drafts tests | Centralized API repository | Industry standard'),
    t('insomnia-ai-pro','Insomnia','code','The API design and test platform for GraphQL, gRPC and REST with AI.','https://insomnia.rest',true,true,58000, freeTier:'Free for individuals', price:10, priceTier:'Individual: cloud sync and more monthly', tips:'Kong company project | Very clean UI | Powerful plugin system'),
    t('ngrok-ai-pro','ngrok','code','Unified ingress platform for developers using AI-powered edge security.','https://ngrok.com',true,true,84000, freeTier:'Free basic ingress', price:25, priceTier:'Pro: custom domains and 더', tips:'Instant public URL for local servers | AI-powered traffic inspection | Zero trust security'),
    t('localtunnel-ai','localtunnel','code','Expose your local web server to the internet using a simple CLI.','https://localtunnel.github.io/www',true,false,45000, freeTier:'Completely free open source', price:0, tips:'Quickest way to test webhooks | No setup required | Node.js based'),
    t('tailscale-ai-pro','Tailscale','code','Zero config VPN for teams that just works using AI-powered routing.','https://tailscale.com',true,true,120000, freeTier:'Free for up to 3 users and 100 devices', price:6, priceTier:'Starter per user monthly', tips:'Built on WireGuard | No firewall config | Secure and private networking'),

    // ━━━ DESIGN ASSETS (Patterns) ━━━
    t('tally-ai-pro','Tally','marketing','The simplest way to create forms for free with AI writing.','https://tally.so',true,true,58000, freeTier:'Free for unlimited forms and submissions', price:29, priceTier:'Pro: custom domains and 더', tips:'No-code form builder | Notion-like UI | Privacy-friendly'),
    t('heroicons-ai','Heroicons','design','Beautiful hand-crafted SVG icons by the makers of Tailwind CSS.','https://heroicons.com',true,true,120000, freeTier:'Completely free open source', price:0, tips:'Perfectly suited for Tailwind projects | 200+ icons in 3 styles | High quality craftsmanship'),
    t('lucide-ai','Lucide','design','Beautiful and consistent icons made by the community, for everyone.','https://lucide.dev',true,true,150000, freeTier:'Completely free open source', price:0, tips:'Fork of Feather icons | 1400+ icons | Support for React/Vue/Svelte'),
    t('feather-icons-ai','Feather','design','Simply beautiful open source icons for designers and developers.','https://feathericons.com',true,true,92000, freeTier:'Completely free open source', price:0, tips:'Minimalist design | 280+ icons | Clean and consistent SVG'),
    t('remix-icon-ai','Remix Icon','design','Open source neutral style system symbols for designers and developers.','https://remixicon.com',true,false,45000, freeTier:'Completely free open source', price:0, tips:'2200+ icons in various categories | High quality SVG/Font | No attribution required'),

    // ━━━ MARKETING (Cold Email) ━━━
    t('lemlist-ai-pro','lemlist','marketing','Leading personalized cold email and sales engagement platform with AI.','https://lemlist.com',false,true,35000, freeTier:'14-day free trial', price:59, priceTier:'Standard monthly', tips:'Personalized image generation | AI copy writing | Warm-up tool included'),
    t('instantly-ai-pro','Instantly.ai','marketing','Leading cold email outreach and deliverability platform using AI.','https://instantly.ai',false,true,45000, freeTier:'14-day free trial', price:37, priceTier:'Growth monthly', tips:'Unlimited email accounts | AI-powered warm-up | Best for large scale outreach'),
    t('woodpecker-ai-pro','Woodpecker','marketing','Cold email software for B2B companies to find and connect with leads.','https://woodpecker.co',false,true,18000, freeTier:'7-day free trial', price:49, priceTier:'Standard monthly', tips:'Best for B2B sales teams | AI-driven deliverability | Integrated CRM'),
    t('reply-io-ai-pro','Reply.io','marketing','All-in-one sales engagement platform for B2B teams with AI assistant.','https://reply.io',true,true,15000, freeTier:'Free trial for 14 days', price:60, priceTier:'Personal monthly', tips:'AI-powered multichannel outreach | Cloud-based | Integrated lead database'),
    t('apollo-io-ai','Apollo.io','marketing','Leading B2B sales intelligence and engagement platform with AI.','https://apollo.io',true,true,150000, freeTier:'Free for up to 10k email credits', price:49, priceTier:'Basic monthly', tips:'Largest B2B database | AI-powered lead scoring | Integrated dialer and email'),

    // ━━━ SOCIAL & DATING AI ━━━
    t('bumble-ai','Bumble','social','Dating app focused on female-led connections with AI safety tools.','https://bumble.com',true,true,250000, freeTier:'Free basic matching', price:15, priceTier:'Premium weekly', tips:'"Deception Detector" AI | Women make the first move | BFF and Bizz modes'),
    t('tinder-ai','Tinder','social','The world\'s most popular dating app with AI-powered photo verification.','https://tinder.com',true,true,500000, freeTier:'Free basic matching', price:10, priceTier:'Plus monthly', tips:'"Super Like" AI suggestions | Global matching | High volume of users'),
    t('hinge-ai','Hinge','social','The dating app "designed to be deleted" with AI-powered "Most Compatible".','https://hinge.co',true,true,180000, freeTier:'Free basic matching', price:20, priceTier:'Preferred: unlimited likes', tips:'Personalized questions and prompts | AI picks your best match daily | High conversion'),
    t('inner-circle-ai','Inner Circle','social','Curated dating app for professionals with AI-powered background checks.','https://theinnercircle.co',true,false,45000, freeTier:'Free basic browsing', price:5, priceTier:'Premium weekly', tips:'High quality community | Exclusive events | Verified profiles'),
    t('ok-cupid-ai','OkCupid','social','In-depth dating app with AI-powered matching based on thousands of questions.','https://okcupid.com',true,true,92000, freeTier:'Free basic matching', price:10, priceTier:'Premium monthly', tips:'Most comprehensive matching algorithm | Diverse filters | Long-standing brand'),

    // ━━━ UTILITIES (Security GEMS) ━━━
    t('proton-mail-ai','Proton Mail','productivity','Privacy-focused email service with end-to-end encryption and AI.','https://proton.me/mail',true,true,150000, freeTier:'Free basic account (1GB)', price:10, priceTier:'Mail Plus monthly', tips:'Swiss-based security | Zero access encryption | Part of Proton ecosystem'),
    t('proton-vpn-ai','Proton VPN','productivity','High-speed, free, and secure VPN from the makers of Proton Mail.','https://proton.me/vpn',true,true,120000, freeTier:'Completely free unlimited bandwidth version', price:10, priceTier:'Plus monthly', tips:'No-logs policy | Open source and audited | "NetShield" AI-powered ad blocker'),
    t('duckduckgo-ai','DuckDuckGo','productivity','Privacy-first search engine and browser with AI-powered tracker block.','https://duckduckgo.com',true,true,250000, freeTier:'Completely free forever', price:0, tips:'No personal tracking | AI-powered answers | "Burn" button for browsing history'),
    t('signal-app-ai','Signal','productivity','Leading secure and private messaging app with AI-powered cryptography.','https://signal.org',true,true,180000, freeTier:'Completely free non-profit', price:0, tips:'The privacy standard | No ads, no trackers | Trusted by Edward Snowden'),
    t('ghostry-ai','Ghostery','productivity','Powerful browser extension that blocks ads and trackers using AI.','https://ghostery.com',true,true,84000, freeTier:'Free basic version', price:5, priceTier:'Contributor: advanced stats', tips:'See who is tracking you | Fast and lightweight | Open source powered'),

    // ━━━ OFFICE & DOCS (Extra) ━━━
    t('zapier-ai','Zapier','productivity','The leader in no-code automation with AI-powered app connectors.','https://zapier.com',true,true,250000, freeTier:'Free for up to 100 tasks/month', price:20, priceTier:'Starter monthly', tips:'6000+ app integrations | AI "Natural Language" triggers | Automated workflows'),
    t('make-ai-pro','Make (formerly Integromat)','productivity','Visual automation platform for building complex workflows with AI.','https://make.com',true,true,120000, freeTier:'Free for up to 1000 ops/month', price:9, priceTier:'Core plan monthly', tips:'Visual scenario builder | More powerful than Zapier for techies | Great pricing'),
    t('bubble-ai-pro','Bubble','code','Leading no-code platform for building complex web apps with AI.','https://bubble.io',true,true,84000, freeTier:'Free to build on sub-domain', price:32, priceTier:'Starter monthly for custom domain', tips:'Full-stack no-code | Scalable cloud infrastructure | Huge active community'),
    t('webflow-ai-pro','Webflow','design','The site builder that gives you total design control with AI.','https://webflow.com',true,true,150000, freeTier:'Free to build and publish on Webflow', price:14, priceTier:'Basic: custom domain monthly', tips:'Professional grade design | CMS and E-commerce built-in | High performance hosting'),
    t('framer-ai-pro','Framer','design','The fastest browser-based site builder for high-end landing pages with AI.','https://framer.com',true,true,120000, freeTier:'Free to learn and publish on sub-domain', price:10, priceTier:'Basic: custom domain monthly', tips:'Best for animations | AI "Site Generation" from text | Figma-like UI'),

    // ━━━ OTHER INNOVATIONS ━━━
    t('github-copilot-chat','GitHub Copilot Chat','code','AI pair programmer that understands your entire workspace.','https://github.com/features/copilot',false,true,180000, freeTier:'Free for students/OSS maintainers', price:10, priceTier:'Individual monthly', tips:'Integrated in VS Code/JetBrains | Massive productivity boost | Reliable code gen'),
    t('cursor-ai-pro','Cursor','code','The AI code editor designed for pair programming with an LLM.','https://cursor.com',true,true,84000, freeTier:'Free forever basic usage', price:20, priceTier:'Pro: unlimited and 더', tips:'Fork of VS Code | AI understands your whole codebase | Fastest coding experience'),
    t('warp-terminal-ai','Warp','code','The modern, AI-powered terminal for developers and teams.','https://warp.dev',true,true,58000, freeTier:'Free for individuals', price:0, tips:'AI "Natural Language" commands | Collaborative workflows | Rust-powered speed'),
    t('iterm2-ai','iTerm2 (AI Integration)','code','Leading macOS terminal replacement with AI-powered command help.','https://iterm2.com',true,false,92000, freeTier:'Completely free open source', price:0, tips:'The mac developer standard | Powerful customization | AI search integration'),
    t('oh-my-zsh-ai','Oh My Zsh','code','The community framework for managing Zsh configurations with AI plugins.','https://ohmyz.sh',true,true,150000, freeTier:'Completely free open source', price:0, tips:'100s of plugins and themes | Makes CLI fun | Essential for mac devs'),
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
