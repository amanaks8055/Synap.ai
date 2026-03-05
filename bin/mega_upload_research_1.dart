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
    // ━━━ SCIENTIFIC RESEARCH & ACADEMIC AI ━━━
    t('elicit-ai','Elicit','research','AI research assistant that automates literature reviews and data extraction from papers.','https://elicit.org',true,true,84000, freeTier:'Free basic credits', price:10, priceTier:'Plus monthly', tips:'Find relevant papers and summarize findings | Extract data from 200M+ papers | Best for academics'),
    t('scite-ai','Scite','research','AI platform that helps you find and analyze scientific citations for any claim.','https://scite.ai',true,true,58000, freeTier:'Free trial for 7 days', price:20, priceTier:'Individual monthly', tips:'See if a claim has been supported or contrasted | AI Assistant for evidence | Trusted by 10M+ users'),
    t('semantic-scholar-ai','Semantic Scholar','research','AI-powered research tool from AI2 for scientific literature search and discovery.','https://semanticscholar.org',true,true,250000, freeTier:'Completely free forever', price:0, tips:'AI-powered "TLDR" summaries | Citations that matter | Personalized research feed'),
    t('consensus-ai','Consensus','research','Search engine that uses AI to find answers in scientific research papers.','https://consensus.app',true,true,92000, freeTier:'Free basic search', price:10, priceTier:'Premium monthly', tips:'Get answers based on actual studies | High transparency | Trustworthy AI search'),
    t('research-rabbit-ai','Research Rabbit','research','AI-powered discovery engine for scientific papers with a "Spotify for research" feel.','https://researchrabbit.ai',true,true,45000, freeTier:'Completely free for researchers', price:0, tips:'Visualize connections between papers | Follow authors and topics | Collaborative collections'),
    t('litmaps-ai','Litmaps','research','AI tool to visualize the landscape of scientific literature through interactive maps.','https://litmaps.com',true,true,38000, freeTier:'Free for up to 100 papers', price:15, priceTier:'Pro: unlimited maps monthly', tips:'Discover relevant papers you missed | Map your bibliography | Integrated with Zotero'),
    t('connected-papers-ai','Connected Papers','research','Visual tool to help researchers find and explore relevant academic papers.','https://connectedpapers.com',true,true,84000, freeTier:'Free for up to 5 graphs/month', price:3, priceTier:'Academic monthly', tips:'See the direct graph of a paper\'s field | Find seminal works | Great UX'),
    t('paperpal-ai','Paperpal','writing','AI writing assistant specifically designed for academic and scientific researchers.','https://paperpal.com',true,true,56000, freeTier:'Free basic check', price:12, priceTier:'Prime monthly', tips:'Academic language suggestions | Plagiarism check | Integrated with MS Word'),
    t('writefull-ai','Writefull','writing','AI tools for academic writing to improve grammar, style, and terminology.','https://writefull.com',true,true,42000, freeTier:'Free basic version', price:15, priceTier:'Premium monthly', tips:'Specific to scientific disciplines | Overleaf integration | AI title generator'),
    t('scholarcy-ai','Scholarcy','research','AI-powered summarizer that breaks down complex research papers into key points.','https://scholarcy.com',true,true,35000, freeTier:'Free browser extension', price:8, priceTier:'Library monthly', tips:'Generate interactive flashcards | Highlight key findings | Export to your PKM'),

    // ━━━ CYBERSECURITY AI (Deep Tech) ━━━
    t('darktrace-ai','Darktrace','business','The leader in autonomous AI for cybersecurity and threat detection.','https://darktrace.com',false,true,45000, freeTier:'Demo and report available', price:0, tips:'Self-learning AI infrastructure | "Cyber AI Loop" for prevention | Industrial security leader'),
    t('sentinelone-ai','SentinelOne','business','Leading autonomous AI endpoint security platform for enterprise.','https://sentinelone.com',false,true,58000, freeTier:'Demo available', price:0, tips:'AI-powered XDR (Extended Detection & Response) | Automated remediations | Best for large scale'),
    t('crowdstrike-ai','CrowdStrike Falcon','business','Cloud-native endpoint protection using AI to stop breaches.','https://crowdstrike.com',false,true,120000, freeTier:'15-day free trial', price:8, priceTier:'Per endpoint starting monthly', tips:'AI-powered threat hunting | Huge community of researchers | High degree of automation'),
    t('snyk-ai-security','Snyk','code','Developer-first security platform using AI to find and fix vulnerabilities.','https://snyk.io',true,true,84000, freeTier:'Free forever for open source', price:25, priceTier:'Team plan per dev monthly', tips:'AI code analysis | Integrate into GitHub/GitLab | Fix vulnerabilities with one click'),
    t('recorded-future-ai','Recorded Future','business','The world\'s largest threat intelligence platform using AI for risk scoring.','https://recordedfuture.com',false,true,32000, freeTier:'Free daily newsletter', price:0, tips:'AI-powered brand protection | Geopolitical risk analysis | Strategic intelligence'),
    t('trellix-ai','Trellix','business','Integrated XDR platform using AI for advanced threat intelligence and detection.','https://trellix.com',false,false,15000, freeTier:'Demo available', price:0, tips:'Adaptive cybersecurity | Dynamic threat hunting | Large enterprise focus'),
    t('tanium-ai-pro','Tanium','business','The industry standard for real-time visibility and control of endpoints with AI.','https://tanium.com',false,true,25000, freeTier:'Demo available', price:0, tips:'Manage 1M+ endpoints instantly | AI-powered asset discovery | Secure and compliant'),
    t('splunk-ai','Splunk (Machine Learning)','business','Data-to-everything platform using AI for operational intelligence and security.','https://splunk.com',true,true,150000, freeTier:'Free for up to 500MB/day', price:150, priceTier:'Cloud monthly starting', tips:'The gold standard for log analysis | AI-powered anomaly detection | Robust dashboarding'),
    t('vectra-ai','Vectra AI','business','AI-powered network detection and response for hybrid cloud.','https://vectra.ai',false,false,12000, freeTier:'Demo available', price:0, tips:'Identify attackers in real-time | AI-powered threat prioritization | AWS/Azure specialist'),
    t('bitsight-ai','BitSight','business','Leading cybersecurity rating platform using AI to calculate risk.','https://bitsight.com',false,false,9200, freeTier:'Free self-assessment', price:0, tips:'Industry standard for vendor risk | AI-powered risk scoring | Global coverage'),

    // ━━━ DATA SCIENCE & BI AI ━━━
    t('datarobot-ai','DataRobot','code','Leading enterprise AI platform for automated machine learning (AutoML).','https://datarobot.com',false,true,18000, freeTier:'Demo and trial available', price:0, tips:'Automate the entire data science pipeline | AI for generating models | Enterprise focus'),
    t('h2o-ai','H2O.ai','code','Open source AI platform for data science and automated machine learning.','https://h2o.ai',true,true,35000, freeTier:'Free open source edition', price:0, tips:'World-class AutoML | Used by top data scientists | High performance G2/H2O'),
    t('alteryx-ai','Alteryx','business','Analytical process automation platform with AI-powered data prep.','https://alteryx.com',false,true,45000, freeTier:'Free Designer trial', price:150, priceTier:'Monthly billed annually', tips:'Best for low-code data scientists | AI-powered cleanup | Integrated with Tableu/Excel'),
    t('tableau-ai-pulse','Tableau AI','business','Leading visual analytics platform with AI-powered "Pulse" insights.','https://tableau.com',true,true,180000, freeTier:'Free trial available', price:15, priceTier:'Tableau Viewer per month', tips:'AI explains data trends | Beautiful visualizations | Industry standard for BI'),
    t('powerbi-ai','Microsoft Power BI','business','Unified BI and analytics platform with AI-powered Q&A and insights.','https://powerbi.microsoft.com',true,true,250000, freeTier:'Free for personal use Desktop', price:10, priceTier:'Pro per user monthly', tips:'Deep integration with Excel and Azure | AI-powered data visualization | Best for business users'),
    t('knime-ai-pro','KNIME','code','Open source data analytics platform for low-code data science and AI.','https://knime.com',true,true,25000, freeTier:'Free open source version Desktop', price:0, tips:'Visual workflow builder | Huge library of extensions | Great for pharma/science'),
    t('rapidminer-ai','RapidMiner','code','Leading data science platform for teams with AI-powered model building.','https://rapidminer.com',false,true,15000, freeTier:'Free educational license', price:0, tips:'End-to-end data lifecycle | Visual and code-based | Enterprise governance'),
    t('thoughtspot-ai','ThoughtSpot','business','AI-powered search and analytics platform for modern BI teams.','https://thoughtspot.com',false,false,12000, freeTier:'30-day free trial', price:0, tips:'Ask questions in natural language | AI-powered "SpotIQ" | Scalable data cloud'),
    t('looker-ai-pro','Looker (Google Cloud)','business','Modern BI and data platform using AI for modeling and visualization.','https://looker.com',false,true,32000, freeTier:'Demo available', price:0, tips:'Powerful LookML modeling | Integrated with BigQuery | Part of Google Cloud'),
    t('sisense-ai','Sisense','business','AI-driven analytics platform for infusing insights into apps and workflows.','https://sisense.com',false,false,18000, freeTier:'Demo and trial available', price:0, tips:'Best for embedded analytics | AI-powered trend detection | Robust API first'),

    // ━━━ MEDIA & SYNTHETIC MEDIA AI ━━━
    t('suno-ai-audio','Suno AI','audio','Leading AI for generating high-quality songs and music from text descriptions.','https://suno.com',true,true,250000, freeTier:'Free basic daily credits', price:8, priceTier:'Pro monthly', tips:'Create full songs with vocals | Best in class quality | Highly viral'),
    t('udio-ai-audio','Udio','audio','AI music generator that creates high-fidelity songs and audio from text.','https://udio.com',true,true,150000, freeTier:'Free basic daily credits', price:10, priceTier:'Premium monthly', tips:'High resolution music | Best for complex arrangements | New industry favorite'),
    t('elevenlabs-ai','ElevenLabs','audio','Leading AI voice platform for ultra-realistic speech and narration.','https://elevenlabs.io',true,true,180000, freeTier:'Free for 10k characters/month', price:5, priceTier:'Starter monthly', tips:'The most realistic AI voices | Multilingual support | API for developers'),
    t('resemble-ai-pro','Resemble.ai','audio','Enterprise AI voice platform for cloning and real-time speech generation.','https://resemble.ai',true,true,45000, freeTier:'Free trial available', price:0.006, priceTier:'Pay per second of audio', tips:'High quality voice clones | Real-time low latency | AI-powered deepfake detection'),
    t('voice-ai-app','Voice.ai','audio','Leading free real-time voice changer for gaming and social media.','https://voice.ai',true,true,120000, freeTier:'Completely free basic', price:0, tips:'Huge library of user voices | Works on Discord and Twitch | AI-powered conversion'),
    t('heygen-ai-pro','HeyGen','video','AI video generation platform for creating high-quality avatars and translations.','https://heygen.com',true,true,84000, freeTier:'1 free credit for trial', price:24, priceTier:'Starter monthly', tips:'Video translation with lip-sync | Custom AI avatars | Best for marketing and training'),
    t('synthesia-ai-pro','Synthesia','video','Leading AI video generation platform for creating videos with AI avatars.','https://synthesia.io',false,true,150000, freeTier:'Demo available', price:22, priceTier:'Starter monthly', tips:'Professional AI avatars | 120+ languages | Industry standard for enterprise'),
    t('d-id-ai-pro','D-ID','video','AI platform for creating interactive and talking avatars from photos.','https://d-id.com',true,true,92000, freeTier:'Free for credits for trial', price:6, priceTier:'Lite monthly', tips:'Animate family photos | Create digital humans | API for interactive chat'),
    t('colossyan-ai','Colossyan','video','AI video platform for corporate training with realistic AI avatars.','https://colossyan.com',true,false,35000, freeTier:'Free version for personal', price:28, priceTier:'Starter monthly', tips:'Best for HR and compliance training | Document to video | High quality output'),
    t('pi-ai-talk','Pi (Inflection AI)','productivity','A personal AI designed to be supportive, smart, and available anytime.','https://pi.ai',true,true,250000, freeTier:'Completely free for now', price:0, tips:'The best voice interaction | Emotional intelligence focus | Deep and flowing conversations'),

    // ━━━ LOCAL LLM & DEV TOOLS ━━━
    t('ollama-ai-local','Ollama','code','The easiest way to get up and running with Llama 3, Mistral, and more locally.','https://ollama.com',true,true,150000, freeTier:'Completely free open source', price:0, tips:'Single command setup | Support for Mac/Linux/Windows | API for local apps'),
    t('lm-studio-ai','LM Studio','code','Discover, download, and run local LLMs on your Mac or PC with ease.','https://lmstudio.ai',true,true,120000, freeTier:'Completely free forever', price:0, tips:'Beautiful UI for local models | Built-in chat and playground | Hardware optimized'),
    t('gpt4all-ai-pro','GPT4All','code','Free-to-use, locally running, privacy-aware chatbot and model ecosystem.','https://gpt4all.io',true,true,84000, freeTier:'Completely free open source', price:0, tips:'Runs on normal CPUs | No internet required | Search your local documents'),
    t('text-generation-webui','Oobabooga Text WebUI','code','A Gradio web UI for running Large Language Models like Llama and Orca.','https://github.com/oobabooga/text-generation-webui',true,false,45000, freeTier:'Completely free open source', price:0, tips:'The most feature-rich local UI | Extensions and API support | High customizability'),
    t('localai-pro','LocalAI','code','The free, open-source OpenAI alternative for self-hosting AI locally.','https://localai.io',true,false,15000, freeTier:'Completely free open source', price:0, tips:'OpenAI-compatible API | CPU and GPU support | Run audio/image/text models'),

    // ━━━ OTHER HIGH IMPACT AI ━━━
    t('starship-ai-delivery','Starship Technologies','business','Leading autonomous delivery robots for food and groceries.','https://starship.xyz',true,true,58000, freeTier:'Free app for users', price:0, tips:'Self-driving delivery | Millions of successful deliveries | Best for college campuses'),
    t('nuance-ai','Nuance (Microsoft)','health','Leader in AI-powered ambient clinical intelligence and voice.','https://nuance.com',false,true,45000, freeTier:'Institutional only', price:0, tips:'Owned by Microsoft | Best for medical transcription (Dragon) | Healthcare leader'),
    t('zebra-medical-ai','Zebra Medical Vision','health','AI platform for medical imaging analysis and radiology automation.','https://zebra-med.com',false,false,18000, freeTier:'Institutional only', price:0, tips:'High accuracy for X-rays and CT | FDA cleared | Part of Nanox'),
    t('path-ai-pro','PathAI','health','Leading AI platform for improving pathology and drug development.','https://pathai.com',false,false,12000, freeTier:'Institutional only', price:0, tips:'AI for cancer diagnosis | Clinical trial support | Best for laboratories'),
    t('tempus-ai','Tempus','health','Data-driven precision medicine platform using AI for personalized care.','https://tempus.com',false,true,35000, freeTier:'Institutional only', price:0, tips:'Genomic sequencing with AI | Real-world clinical data | Focused on oncology'),
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
