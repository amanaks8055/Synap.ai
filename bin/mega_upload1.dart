// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'env.dart';

// Tool helper
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
    // ━━━ CHAT & LLM ━━━
    t('mistral-7b','Mistral 7B','chat','Open-source 7B parameter model beating larger models on benchmarks.','https://mistral.ai',true,false,5200, freeTier:'Free via API with rate limits', price:0, tips:'Best for fast inference | Use for coding tasks | Self-host with Ollama'),
    t('mixtral','Mixtral 8x7B','chat','Mixture of experts model from Mistral with 45B parameters effectively.','https://mistral.ai',true,false,4800, freeTier:'Free on HuggingFace and Groq', price:0, tips:'Excellent for multilingual tasks | Fast inference on Groq | Best OSS model for its size'),
    t('llama3-70b','Llama 3 70B','chat','Meta flagship open-source LLM matching GPT-4 on many benchmarks.','https://llama.meta.com',true,true,9200, freeTier:'Free to download and self-host', price:0, tips:'Run locally with Ollama | Use Groq for free fast inference | Best open-source model overall'),
    t('llama3-8b','Llama 3 8B','chat','Meta efficient 8B model for fast local inference on consumer hardware.','https://llama.meta.com',true,false,6800, freeTier:'Free to download and run locally', price:0, tips:'Runs on 8GB RAM GPU | Fastest local model | Great for code and chat'),
    t('phi-3','Phi-3 Mini','chat','Microsoft small language model with strong reasoning in 3.8B params.','https://microsoft.com/phi',true,false,4200, freeTier:'Free and open source', price:0, tips:'Runs on edge devices | Best small model for math | Available via Azure'),
    t('phi-4','Phi-4','chat','Microsoft latest small model with state-of-the-art reasoning abilities.','https://microsoft.com/phi',true,false,3800, freeTier:'Free and open source', price:0, tips:'14B params with GPT-4 quality on many tasks | Best for STEM | Self-hosted'),
    t('command-r','Command R Plus','chat','Cohere enterprise LLM optimized for RAG and tool use.','https://cohere.com',true,false,3600, freeTier:'Free trial with API key', price:20, priceTier:'Production API access with higher limits', tips:'Best for RAG applications | Excellent tool calling | Enterprise-ready'),
    t('qwen25','Qwen 2.5','chat','Alibaba latest open-source LLM family with strong multilingual support.','https://qwenlm.github.io',true,false,4400, freeTier:'Free and open source via HuggingFace', price:0, tips:'Best for Chinese and Asian languages | Strong coding model | Multiple sizes available'),
    t('gemma2','Gemma 2','chat','Google open-source model family with 2B, 9B, and 27B versions.','https://ai.google.dev/gemma',true,false,5600, freeTier:'Free and open source', price:0, tips:'Runs locally with Ollama | Best Google open model | Strong for instruction following'),
    t('deepseek-r1','DeepSeek R1','chat','DeepSeek reasoning model matching o1 on math and coding benchmarks.','https://deepseek.com',true,true,12000, freeTier:'Free on deepseek.com with limits', price:0, tips:'Best free reasoning model | Use for complex math | Comparable to o1 mini'),
    t('o1-mini','OpenAI o1 mini','chat','OpenAI reasoning model for STEM tasks at lower cost than o1.','https://openai.com',false,true,8400, freeTier:'Included in Plus plan', price:20, priceTier:'ChatGPT Plus includes o1 mini', tips:'Best for math and coding | Slower but more accurate | Use for complex problems'),
    t('o3-mini','OpenAI o3 mini','chat','OpenAI latest efficient reasoning model with configurable thinking.','https://openai.com',false,true,6800, freeTier:'Available in ChatGPT Plus', price:20, priceTier:'ChatGPT Plus', tips:'Faster than o1 at reasoning | Three effort levels | API available'),
    t('claude-haiku','Claude 3.5 Haiku','chat','Anthropic fastest and most affordable Claude model for simple tasks.','https://claude.ai',true,false,7200, freeTier:'Available in Claude free plan', price:20, priceTier:'Claude Pro includes Haiku', tips:'Fastest Claude model | Best for chatbots | Very low API cost'),
    t('claude-sonnet','Claude 3.7 Sonnet','chat','Anthropic latest Claude with extended thinking and coding ability.','https://claude.ai',true,true,18000, freeTier:'Free tier with limited messages', price:20, priceTier:'Pro: 5x more usage, priority access', tips:'Best for coding tasks | Extended thinking for hard problems | 200K context'),
    t('gemini-flash','Gemini 1.5 Flash','chat','Google fast multimodal model with 1M token context window.','https://gemini.google.com',true,false,8800, freeTier:'Free via Google AI Studio API', price:0, tips:'1M token context is massive | Free API generous limits | Great for document processing'),
    t('gemini-pro-latest','Gemini 2.0 Pro','chat','Google latest Gemini with agentic capabilities and native image generation.','https://gemini.google.com',false,true,9600, freeTier:'Available in Gemini Advanced', price:20, priceTier:'Google One AI Premium included', tips:'Best Google multimodal model | Native image generation | Real-time voice'),

    // ━━━ WRITING (more) ━━━
    t('ai-writer','AI Writer','writing','AI content writer producing factual articles with citations.','https://ai-writer.com',true,false,3200, freeTier:'2 articles per month free', price:29, priceTier:'Basic: 40 articles/month no watermark', tips:'Cites sources automatically | Good for factual content | SEO mode available'),
    t('closercopy','CloserCopy','writing','AI copywriting platform with sales frameworks and workflows.','https://closercopy.com',false,false,2400, freeTier:'No free tier', price:49, priceTier:'Unlimited plan with all features', tips:'Hundreds of copy templates | Sales-focused | Good for landing pages'),
    t('writecream','Writecream','writing','AI writing tool for cold emails, LinkedIn messages, and content.','https://writecream.com',true,false,1800, freeTier:'40 credits/month free', price:29, priceTier:'Standard: unlimited basic, 200 audio icebreakers', tips:'Personalized cold outreach | Audio and image icebreakers | LinkedIn optimization'),
    t('aiseo','AISEO','writing','AI writing and paraphrasing tool with bypass AI detection.','https://aiseo.ai',true,false,2200, freeTier:'Free plan limited daily usage', price:19, priceTier:'Pro: unlimited with SEO optimizer', tips:'Humanize AI text | Avoid AI detection tools | SEO optimization built in'),
    t('kafkai','Kafkai','writing','AI niche article writer trained on specific verticals for SEO.','https://kafkai.com',false,false,1400, freeTier:'No free plan', price:29, priceTier:'Starter: 40 articles per month', tips:'Built for SEO niches | Authentic-sounding content | Category-specific models'),
    t('nichesss','Nichesss','writing','AI content creator for niche websites with 40+ tools.','https://nichesss.com',true,false,1200, freeTier:'Limited free plan', price:19, priceTier:'Unlimited words per month', tips:'Amazon review generator | Blog post writer | Recipe creator'),
    t('wordai','WordAI','writing','AI article rewriter producing human-quality unique content.','https://wordai.com',false,false,1800, freeTier:'3-day free trial', price:57, priceTier:'Starter: unlimited rewrites and articles', tips:'Rewrites entire articles | Keeps original meaning | Best for bulk rewriting'),
    t('simplish','Simplish','writing','AI text simplifier making complex content easy to understand.','https://simplish.co',true,false,900, freeTier:'Free with limited rewrites', price:9, priceTier:'Pro: unlimited simplifications', tips:'Reduce reading level | Good for accessibility | Explains jargon'),
    t('writingassistant','Writing Assistant','writing','AI writing tool suggesting improvements for clarity and style.','https://writingassistant.app',true,false,800, freeTier:'5 checks per day free', price:9, priceTier:'Pro: unlimited checks', tips:'Grammar plus style suggestions | Tone analysis | Good browser extension'),
    t('typli','Typli.ai','writing','AI writing assistant with 50+ writing templates and plagiarism checker.','https://typli.ai',true,false,1600, freeTier:'5000 words per month free', price:29, priceTier:'Solo: unlimited words per month', tips:'Good for blog writing | Plagiarism check included | SEO mode'),

    // ━━━ CODE (more) ━━━
    t('warp-ai','Warp AI','code','AI terminal with natural language commands and debugging.','https://warp.dev',true,false,4800, freeTier:'Free for individuals forever', price:0, tips:'Type in English to run commands | AI explain errors | Excellent for developers'),
    t('ai-shell','AI Shell','code','CLI tool converting natural language to shell commands using AI.','https://github.com/BuilderIO/ai-shell',true,false,2200, freeTier:'Free open source', price:0, tips:'Uses GPT-4 API | Works in any terminal | Explain mode available'),
    t('gpt-pilot','GPT Pilot','code','AI developer that codes entire production-ready apps from scratch.','https://github.com/Pythagora-io/gpt-pilot',true,false,3600, freeTier:'Free open source', price:0, tips:'Builds full-stack apps | Asks clarifying questions | Better than simple code gen'),
    t('mutableai','Mutable AI','code','AI accelerated software development with codebase AI.','https://mutable.ai',true,false,2800, freeTier:'Free trial available', price:25, priceTier:'Pro: unlimited AI access', tips:'Repo-wide code understanding | AI-powered wiki generation | Quick refactoring'),
    t('codegeex','CodeGeeX','code','Free AI coding assistant supporting 300+ programming languages.','https://codegeex.cn',true,false,3200, freeTier:'Completely free for individuals', price:0, tips:'VS Code and JetBrains plugin | Multi-language support | Strong Python support'),
    t('duet-ai','Duet AI (Google)','code','Google AI assistance in Cloud IDE and Vertex with Gemini.','https://cloud.google.com/duet-ai',false,false,3800, freeTier:'Trial credits available', price:19, priceTier:'Per user subscription in Google Cloud', tips:'Integrated with Google Cloud services | Chat with your codebase | Deployment help'),
    t('bloop','Bloop','code','AI code search engine understanding natural language queries.','https://bloop.ai',true,false,2400, freeTier:'Free for open source repos', price:15, priceTier:'Pro: private repos unlimited', tips:'Ask questions about codebase | Find code by meaning | Cross-repo search'),
    t('phind-vscode','Phind VS Code','code','AI coding assistant in VS Code with web search integration.','https://phind.com',true,false,3400, freeTier:'Free for basic usage', price:20, priceTier:'Pro: unlimited fast queries', tips:'Uses Claude and GPT-4 | Searches web for latest info | Good debugging'),
    t('ai-code-reviewer','CodeReviewer AI','code','AI conducting automated code reviews with security analysis.','https://ai-codereviewer.com',true,false,1800, freeTier:'50 reviews per month free', price:15, priceTier:'Pro: unlimited reviews', tips:'GitHub integration | Security vulnerability detection | Style consistency'),
    t('ellipsis-dev','Ellipsis','code','AI code review and bug fix tool working in GitHub workflow.','https://ellipsis.dev',true,false,2000, freeTier:'Free for public repos', price:20, priceTier:'Pro: private repos and teams', tips:'Auto-creates fix PRs | Reviews every PR automatically | Explains changes'),
    t('greptile','Greptile','code','AI understanding entire GitHub codebases for Q&A and review.','https://greptile.com',true,false,2600, freeTier:'Free trial with limited repos', price:25, priceTier:'Pro: unlimited repos and queries', tips:'Ask any question about codebase | Onboard new devs faster | Good for large codebases'),
    t('fynix','Fynix','code','AI coding agent with multi-file editing and project understanding.','https://fynix.ai',true,false,1600, freeTier:'Free plan available', price:20, priceTier:'Pro: unlimited messages', tips:'Works across multiple files | Project-level context | Good for refactoring'),
    t('aide','AIDE','code','AI coding environment with autonomous debugging and testing.','https://aide.dev',true,false,2200, freeTier:'Free beta access', price:0, tips:'Full autonomy mode | Runs tests automatically | Uses Claude 3.5 Sonnet'),
    t('pear-ai','PearAI','code','Open-source AI code editor forked from Continue and VSCode.','https://trypear.ai',true,false,1800, freeTier:'Free and open source', price:0, tips:'Multiple model support | Privacy focused | Active community'),
    t('zed-ai','Zed AI','code','High-performance AI code editor with collaborative editing.','https://zed.dev',true,false,4200, freeTier:'Free with Claude integration', price:0, tips:'Fastest code editor available | Real-time collaboration | Built in Rust'),

    // ━━━ IMAGE (more) ━━━
    t('magnific-ai','Magnific AI','image','AI image upscaler and enhancer with hallucination controls.','https://magnific.ai',false,true,5200, freeTier:'No free tier', price:39, priceTier:'Pro: 1500 upscales per month', tips:'Industry best upscaling | Add fine details | Used by professional artists'),
    t('adetailer','ADetailer','image','Stable Diffusion extension fixing faces and hands automatically.','https://github.com/Bing-su/aDetailer',true,false,3800, freeTier:'Free open source extension', price:0, tips:'Fixes bad hands and faces | Works with any SD model | Essential SD extension'),
    t('controlnet','ControlNet','image','Stable Diffusion extension controlling image composition precisely.','https://github.com/lllyasviel/ControlNet',true,false,4800, freeTier:'Free open source', price:0, tips:'Control pose, depth, edges | Essential for consistent images | Many preprocessors'),
    t('invokeai','InvokeAI','image','Professional Stable Diffusion interface with node editor.','https://invoke.ai',true,false,3200, freeTier:'Free and open source', price:0, tips:'Professional workflow editor | ControlNet built in | Active development'),
    t('comfyui','ComfyUI','image','Node-based AI image generation workflow builder.','https://github.com/comfyanonymous/ComfyUI',true,false,5600, freeTier:'Free and open source', price:0, tips:'Most flexible SD interface | Complex workflow automation | Large node library'),
    t('automatic1111','Automatic1111 WebUI','image','The original Stable Diffusion web interface with huge ecosystem.','https://github.com/AUTOMATIC1111/stable-diffusion-webui',true,false,8200, freeTier:'Free and open source', price:0, tips:'Largest extension ecosystem | Best for beginners | Inpainting and upscaling'),
    t('forge-webui','SD Forge WebUI','image','Optimized Stable Diffusion fork using 50% less VRAM.','https://github.com/lllyasviel/stable-diffusion-webui-forge',true,false,3800, freeTier:'Free and open source', price:0, tips:'Better performance than AUTOMATIC1111 | Same extensions | Less VRAM needed'),
    t('draw-things','Draw Things','image','Free AI image generation app for iPhone, iPad, and Mac.','https://drawthings.ai',true,false,4200, freeTier:'Completely free forever', price:0, tips:'On-device generation | Privacy focused | Supports SD and FLUX models'),
    t('diffusionbee','DiffusionBee','image','Free Stable Diffusion app for Mac running fully locally.','https://diffusionbee.com',true,false,3600, freeTier:'Completely free for Mac', price:0, tips:'Easy Mac installation | Offline privacy | Good beginner interface'),
    t('mochi-diffusion','Mochi Diffusion','image','Free native Stable Diffusion app for Apple Silicon Macs.','https://github.com/godly-devotion/MochiDiffusion',true,false,2800, freeTier:'Free and open source', price:0, tips:'Uses Apple Neural Engine | Very fast on M1/M2/M3 | Beautiful interface'),
    t('dalle-3-gpt','DALL-E via ChatGPT','image','DALL-E 3 accessible through ChatGPT Plus interface.','https://chat.openai.com',false,true,18000, freeTier:'Limited in free tier', price:20, priceTier:'ChatGPT Plus required for best quality', tips:'Prompt directly in conversation | Best text rendering | Edit with revisions'),
    t('imagine-meta','Imagine with Meta AI','image','Free DALL-E quality image generation via WhatsApp and Facebook.','https://imagine.meta.com',true,false,5800, freeTier:'Completely free with Meta account', price:0, tips:'Available in WhatsApp | No watermarks | Good for quick social images'),
    t('copilot-designer','Microsoft Designer AI','designer','AI graphic design tool by Microsoft with DALL-E 3.','https://designer.microsoft.com',true,true,8200, freeTier:'Free with Microsoft account, limited boosts', price:0, tips:'DALL-E 3 image generation | Templates for socials | Integrated with Office'),
    t('ideogram-v2','Ideogram 2.0','image','Updated Ideogram with best-in-class text rendering in images.','https://ideogram.ai',true,true,8800, freeTier:'10 daily generations free', price:8, priceTier:'Plus: 400 priority generations per month', tips:'Best for text in images by far | Poster and logo generation | Magic Prompt helps'),
    t('recraft','Recraft','image','AI design tool for creating vectors, icons, and brand illustrations.','https://recraft.ai',true,false,3200, freeTier:'Free plan with watermark', price:12, priceTier:'Pro: 1000 images, brand styles, no watermark', tips:'Best for vector and SVG generation | Brand style consistency | Icon generation'),

    // ━━━ VIDEO (more) ━━━
    t('hailuo-video','Hailuo AI Video','video','MiniMax AI video generator with high motion quality.','https://hailuoai.video',true,false,6200, freeTier:'Free generations with daily limits', price:0, tips:'High quality motion | Good at realistic scenes | Fast generation'),
    t('wan-video','Wan 2.1','video','Open-source AI video generation model from Alibaba.','https://wan.video',true,false,4800, freeTier:'Free and open source', price:0, tips:'Self-host for unlimited | Strong open-source video model | High quality'),
    t('cogvideo','CogVideoX','video','Open-source AI video model from Zhipu AI running locally.','https://github.com/THUDM/CogVideo',true,false,3200, freeTier:'Free and open source', price:0, tips:'Run locally for free | Good quality for open source | Active development'),
    t('mochi-video','Mochi 1','video','High-quality open-source video generation by Genmo.','https://genmo.ai',true,false,2800, freeTier:'Free on Genmo platform', price:0, tips:'Exceptional motion quality | Open weights | Self-host capable'),
    t('openai-video','Sora API','video','OpenAI Sora via API for developers building video applications.','https://openai.com/sora',false,false,4200, freeTier:'Requires paid API access', price:0, tips:'Per-second pricing model | Best video quality | API access for developers'),
    t('framepack','FramePack','video','Open-source AI extending images into videos with ControlNet.','https://github.com/lllyasviel/FramePack',true,false,2400, freeTier:'Free and open source', price:0, tips:'Runs on consumer GPUs | Extends any image to video | Good motion control'),
    t('pixverse-v4','PixVerse v4','video','Latest PixVerse model with faster generation and better quality.','https://pixverse.ai',true,false,4600, freeTier:'Daily free credits with watermark', price:12, priceTier:'Starter: 500 credits per month', tips:'Best anime style videos | Character consistency | Fast generation'),
    t('veo2','Veo 2','video','Google DeepMind video generation model with cinematic quality.','https://deepmind.google/veo',false,true,7800, freeTier:'Limited access via VideoFX', price:0, tips:'Cinematic camera control | High quality motion | Understanding of physics'),
    t('ltx-video','LTX Video','video','Fast open-source video generation by Lightricks at 30fps.','https://ltx.studio',true,false,2600, freeTier:'Free cloud platform limited generations', price:15, priceTier:'Pro plan for more generations', tips:'Fastest video model | 30fps output | Realtime preview capability'),
    t('stepfun-video','Step-Video','video','Chinese AI video model with high resolution and long duration.','https://platform.stepfun.com',true,false,2200, freeTier:'API credits on signup', price:0, tips:'Up to 10 second videos at high quality | Strong physics understanding | API available'),
    t('video-stitch','VideoStitch AI','video','AI stitching multiple videos together seamlessly.','https://video-stitch.com',false,false,1400, freeTier:'Free trial available', price:19, priceTier:'Pro: unlimited stitching projects', tips:'360 video stitching | Eliminate seams automatically | Good for VR content'),
    t('visla-ai','Visla','video','AI video platform finding stock clips and creating scripts.','https://visla.us',true,false,3200, freeTier:'Free plan with watermark', price:19, priceTier:'Pro: no watermark, more recordings', tips:'Auto-finds relevant stock | Script to video instantly | Good narration'),
    t('movio','Movio','video','AI avatar video generator for marketing and presentations.','https://movio.la',false,false,2800, freeTier:'Free trial available', price:30, priceTier:'Starter: 200 credits monthly', tips:'100+ AI presenters | Brand customization | Multilingual support'),
    t('shuffle-ai','Shuffle AI','video','AI remixing and transforming existing videos into new styles.','https://shuffleai.art',true,false,1600, freeTier:'Free trials with account', price:15, priceTier:'Pro: unlimited transforms', tips:'Style transfer for video | Multiple artistic styles | Quick processing'),
    t('gling-ai','Gling AI','video','AI automatically editing YouTube videos removing silences and mistakes.','https://gling.ai',false,false,2400, freeTier:'Free trial 1 video', price:19, priceTier:'Creator: 10 hours/month auto-editing', tips:'Removes silences and umms | Exports EDL for Premiere | Saves hours of editing'),

    // ━━━ AUDIO (more) ━━━
    t('adobe-podcast','Adobe Podcast AI','audio','Free AI audio enhancer improving podcast and voice recording quality.','https://podcast.adobe.com',true,true,8400, freeTier:'Free - premium quality enhancement', price:0, tips:'Remove background noise | Studio quality from phone | Works on any recording'),
    t('descript-studio','Descript Studio Sound','audio','AI studio sound feature improving audio quality automatically.','https://descript.com',true,false,4600, freeTier:'Included in free Descript plan', price:24, priceTier:'Pro for more transcription hours', tips:'One-click audio enhancement | Background removal | Loudness normalization'),
    t('cleanvoice','Cleanvoice AI','audio','AI removing filler words, stutters, and background noise from audio.','https://cleanvoice.ai',true,false,2800, freeTier:'30 minutes free per month', price:11, priceTier:'30 hours per month', tips:'Removes ums and uhs automatically | Great for podcast editing | Multi-language'),
    t('auphonic','Auphonic','audio','AI audio post-production tool balancing levels and removing noise.','https://auphonic.com',true,false,3400, freeTier:'2 hours free per month', price:11, priceTier:'Standard: 9 hours per month', tips:'Professional broadcast standard | Loudness normalization | Multitrack support'),
    t('lalal-piano','LALAL Piano','audio','AI separating piano tracks from any mix with high accuracy.','https://lalal.ai',true,false,2200, freeTier:'10 minutes free split', price:15, priceTier:'100 minutes of stem separation', tips:'Piano isolation best in class | Good for music production | Karaoke creation'),
    t('moises-app','Moises App','audio','AI audio app for musicians separating and practicing with stems.','https://moises.ai',true,false,3800, freeTier:'5 songs per month free with watermark', price:8, priceTier:'Pro: 300 uploads per month', tips:'Karaoke track creation | Slow down any song | Transpose key instantly'),
    t('eleven-dubbing','ElevenLabs Dubbing','audio','AI dubbing studio translating video audio into any language.','https://elevenlabs.io/dubbing',true,false,5600, freeTier:'Free tier with limits', price:22, priceTier:'Starter: 100 min of dubbing', tips:'Preserves original voice timbre | 30+ languages | Lip sync support'),
    t('heygen-translate','HeyGen Video Translate','audio','AI translating any video with lip sync in 40+ languages.','https://heygen.com',true,false,4800, freeTier:'1 minute free video translation', price:29, priceTier:'Creator: 30 minutes/month translation', tips:'Best lip sync quality | Preserves speaker voice | Upload any video'),
    t('kapwing-dub','Kapwing Dub','audio','AI video dubbing and translation with Auto Translate feature.','https://kapwing.com',true,false,3600, freeTier:'Free trials included', price:24, priceTier:'Pro: unlimited dubbing minutes', tips:'Easy browser-based dubbing | Multiple target languages | Quick processing'),
    t('voicify-ai','Voicify AI','audio','AI music platform creating cover songs in any artist voice.','https://voicify.ai',true,false,2400, freeTier:'3 free AI covers per month', price:9, priceTier:'Starter: 25 AI covers per month', tips:'AI voice models of famous artists | Good for fun covers | Download as MP3'),
    t('so-vits','so-vits-svc','audio','Open-source AI singing voice conversion running locally.','https://github.com/svc-develop-team/so-vits-svc',true,false,2000, freeTier:'Free and open source', price:0, tips:'Train custom voice models | High quality singing conversion | Technical setup'),
    t('rvc-project','RVC (Retrieval VC)','audio','Popular open-source voice conversion with real-time capability.','https://github.com/RVC-Project/Retrieval-based-Voice-Conversion',true,false,3400, freeTier:'Free and open source', price:0, tips:'Real-time voice change | Train in 5-10 minutes | Low latency mode'),
    t('kits-ai','KITS AI','audio','AI voice creation for music with stem separation and conversion.','https://kits.ai',true,false,2200, freeTier:'Free account with limited conversions', price:10, priceTier:'Starter: 50 AI voice conversions', tips:'Licensed artist voices | Upload your own voice | Music production focus'),
    t('podcastle','Podcastle','audio','AI podcast recording platform with voice cloning and enhancement.','https://podcastle.ai',true,false,3200, freeTier:'Free recording up to 10 hours', price:12, priceTier:'Solo: unlimited recording and AI tools', tips:'Magic Dust enhances audio | Revoice clones your voice | Remote recording'),
    t('riverside-transcript','Riverside FM','audio','Professional podcast and video recording with AI transcription.','https://riverside.fm',true,false,4800, freeTier:'Free plan with 2 hours recording', price:15, priceTier:'Standard: 5 hours recording and editing', tips:'Local recording prevents internet drops | 4K video | Instant transcription'),

    // ━━━ RESEARCH (more) ━━━
    t('semantic-search','Semantic Scholar','research','AI academic paper search with semantic understanding across 200M papers.','https://semanticscholar.org',true,true,6800, freeTier:'Completely free forever', price:0, tips:'Semantic meaning search | Filter by recency | Great citation graph'),
    t('connected-papers-2','Connected Papers','research','Visualizing paper networks to discover related research visually.','https://connectedpapers.com',true,false,3600, freeTier:'5 free graphs per month', price:3, priceTier:'Premium: unlimited graphs', tips:'Find unknown related papers | Build on prior work | Visual research navigation'),
    t('inciteful','Inciteful','research','AI paper recommendation and citation network analysis tool.','https://inciteful.xyz',true,false,1800, freeTier:'Free forever', price:0, tips:'Link papers to find connections | Citation network visualization | Free and unlimited'),
    t('open-alex','OpenAlex','research','Free and open catalog of all scholarly research with AI capabilities.','https://openalex.org',true,false,2400, freeTier:'Free open API', price:0, tips:'200M+ scholarly works | REST API available | Filter by institution and field'),
    t('pubmed-ai','PubMed AI','research','National Library of Medicine biomedical literature search with AI.','https://pubmed.ncbi.nlm.nih.gov',true,false,4800, freeTier:'Free government resource', price:0, tips:'Best for medical research | Filter by study type | Free full text links'),
    t('arxiv-ai','arXiv Sanity','research','AI tool for finding and organizing preprints on arXiv efficiently.','https://arxiv-sanity-lite.com',true,false,3200, freeTier:'Free forever', price:0, tips:'Best for ML and physics | Recommendations based on saved papers | Filter recent'),
    t('google-scholar','Google Scholar AI','research','Google AI academic search covering papers, theses, and books.','https://scholar.google.com',true,true,12000, freeTier:'Completely free forever', price:0, tips:'Cited by count shows impact | Alerts for new citations | Free full text often'),
    t('dimensions-ai','Dimensions AI','research','Research intelligence platform with 200M+ publications and citations.','https://dimensions.ai',true,false,2800, freeTier:'Free institutional access', price:0, tips:'Better than Web of Science | Funding data linked | Patent connections'),
    t('lens-org','The Lens','research','Free AI patent and scholarly search aggregating all research.','https://lens.org',true,false,2000, freeTier:'Completely free forever', price:0, tips:'Patents plus papers in one | 250M records | Citation analytics free'),
    t('typeset-io','Typeset IO Scispace','research','AI reading scientific papers with explanation and search.','https://typeset.io',true,false,3400, freeTier:'Free plan with limited AI queries', price:20, priceTier:'Pro: unlimited AI explanations', tips:'Explain any paper | Math rendering | Find related research'),

    // ━━━ PRODUCTIVITY (more) ━━━
    t('notionai2','Notion AI Plus','research','Enhanced Notion AI with Q&A over workspace and external sources.','https://notion.so',false,false,9800, freeTier:'20 free responses then add-on needed', price:16, priceTier:'AI add-on: unlimited per member', tips:'Q&A over all your notes | Summarize meetings | Fill in database fields'),
    t('craft-docs','Craft Docs','research','Beautiful AI document editor with contextual assistant.','https://craft.do',true,false,2400, freeTier:'Free with 1GB storage', price:5, priceTier:'Pro: unlimited storage and AI', tips:'Beautiful typography | AI rewrite and suggest | Works on all Apple devices'),
    t('taskade-ai','Taskade AI','research','AI project management combining tasks, notes, and video chat.','https://taskade.com',true,false,3200, freeTier:'Free plan with 5 projects', price:8, priceTier:'Pro: unlimited AI and projects', tips:'AI generates project templates | Video calls built in | Real-time collaboration'),
    t('mem-ai','Mem.ai','research','AI self-organizing workspace organizing notes automatically.','https://mem.ai',false,false,2600, freeTier:'14-day free trial', price:14, priceTier:'Pro: unlimited notes and AI', tips:'AI tags and organizes automatically | Smart search | Finds connections between notes'),
    t('fibery-ai','Fibery AI','research','AI work management platform combining product and project tools.','https://fibery.io',true,false,1800, freeTier:'Free for 2 users with 5 databases', price:10, priceTier:'Standard: unlimited editors and databases', tips:'Build your own work OS | AI generates reports | Strong integration with GitHub'),
    t('height-pm','Height','research','AI project management with auto-triage and smart notifications.','https://height.app',true,false,2400, freeTier:'Free for unlimited projects', price:8, priceTier:'Team: AI features and analytics', tips:'AI prioritizes tasks | Bulk task editing | Good keyboard shortcuts'),
    t('linear-issues','Linear','research','Fast issue tracker with AI for software teams and products.','https://linear.app',true,false,5400, freeTier:'Free for up to 250 issues', price:8, priceTier:'Standard: unlimited issues and members', tips:'Fastest issue tracker | AI writes issue summaries | Powerful keyboard shortcuts'),
    t('plane-pm','Plane','research','Open-source project management alternative to Jira.','https://plane.so',true,false,2800, freeTier:'Free self-hosted or cloud free plan', price:6, priceTier:'Pro: advanced analytics and automation', tips:'Self-host for free | Jira import | Cycle analytics for sprints'),
    t('nifty-pm','Nifty','research','AI project management with milestones, tasks, and client portals.','https://niftypm.com',true,false,1800, freeTier:'Free for 2 members and projects', price:5, priceTier:'Starter: 10 members and unlimited projects', tips:'Client portal built in | Milestone tracker | Time tracking included'),
    t('basecamp3','Basecamp','research','Simple project management and team messaging in one place.','https://basecamp.com',false,false,3800, freeTier:'30-day free trial', price:15, priceTier:'Flat rate for unlimited people and projects', tips:'Excellent for client projects | Message boards replace email | Hill Charts unique'),

    // ━━━ MARKETING (more) ━━━
    t('surfer-ai','Surfer AI','marketing','AI SEO article writer integrated with Surfer content editor.','https://surferseo.com',false,false,5200, freeTier:'No free tier', price:89, priceTier:'Essential: 10 AI articles per month', tips:'Write and optimize simultaneously | NLP terms integration | Best SEO writing tool'),
    t('page-optimizer','Page Optimizer Pro','marketing','AI on-page SEO tool analyzing top results and giving recommendations.','https://pageoptimizer.pro',false,false,2800, freeTier:'Free trial available', price:22, priceTier:'Basic: 20 reports per month', tips:'TF-IDF analysis | Compare to top 10 | Schema recommendations'),
    t('neuronwriter','NeuronWriter','marketing','AI content optimizer using NLP and competitive SERP analysis.','https://neuronwriter.com',true,false,2400, freeTier:'Limited free plan', price:23, priceTier:'Bronze: 25 content analyses', tips:'Strong NLP optimization | Internal linking suggestions | Content scoring'),
    t('robinize','Robinize','marketing','AI content brief and optimization tool for SEO content teams.','https://robinize.com',true,false,1600, freeTier:'Free plan with basic features', price:19, priceTier:'Pro: unlimited content analyses', tips:'SERP analysis included | Entity extraction | AI writer integration'),
    t('rankmath-ai','RankMath AI','marketing','AI SEO plugin for WordPress with content AI module.','https://rankmath.com',true,false,4800, freeTier:'Free plugin with basic features', price:7, priceTier:'Pro: 100 AI credits per month', tips:'Best free WordPress SEO | Schema markup easy | AI content suggestions'),
    t('yoast-ai','Yoast AI','marketing','AI SEO plugin for WordPress with readability analysis.','https://yoast.com',true,false,5200, freeTier:'Free version solid', price:14, priceTier:'Premium: redirect manager and more suggestions', tips:'Most popular WordPress SEO | Focus keyphrase analysis | Internal link suggestions'),
    t('brightedge-ai','BrightEdge','marketing','Enterprise AI SEO platform with Data Cube and content intelligence.','https://brightedge.com',false,false,3200, freeTier:'No free tier', price:0, tips:'Enterprise pricing negotiated | Strong for large sites | Real-time recommendations'),
    t('conductor-ai','Conductor','marketing','AI enterprise SEO platform for content and organic traffic.','https://conductor.com',false,false,2800, freeTier:'No free tier', price:0, tips:'Content marketing planning | Team collaboration | Good reporting'),
    t('heropost','Heropost','marketing','AI social media scheduling with AI caption and hashtag generation.','https://heropost.io',true,false,1800, freeTier:'Free plan 10 posts per month', price:10, priceTier:'Pro: unlimited posts and platforms', tips:'AI caption generation | Best time to post analytics | Hashtag suggestions'),
    t('postly','Postly','marketing','AI social media tool with scheduling, analytics, and AI writing.','https://postly.ai',true,false,2000, freeTier:'Free plan with 3 channels', price:15, priceTier:'Starter: 10 channels and AI features', tips:'AI post writer | Team collaboration | Link shortener built in'),

    // ━━━ FINANCE (more) ━━━
    t('kensho-ai','Kensho AI','finance','S&P Global AI analytics for financial and government data.','https://kensho.com',false,false,2400, freeTier:'Enterprise only', price:0, tips:'NLP on earnings calls | Event analytics | Signals from unstructured data'),
    t('two-sigma','Two Sigma AI','finance','AI investment management firm using ML for quant trading.','https://twosigma.com',false,false,3200, freeTier:'No public product', price:0, tips:'Used by hedge funds | Machine learning alpha | Big data approach'),
    t('aidyia','Aidiya','finance','AI hedge fund using artificial general intelligence for trading.','https://aidyia.com',false,false,1800, freeTier:'No public product', price:0, tips:'Fully autonomous trading | No human traders | AI continuously learns'),
    t('rebellion-research','Rebellion Research','finance','AI investment firm using machine learning since 2007.','https://rebellionresearch.com',false,false,1600, freeTier:'Research reports available', price:0, tips:'Pioneered AI investing | Global equity coverage | Accessible research'),
    t('kavout-2','Kavout AI','finance','AI stock scoring with K Score and portfolio optimization.','https://kavout.com',false,false,2200, freeTier:'Limited free access', price:29, priceTier:'Investor: full AI signals and screener', tips:'K Score for stock ranking | Portfolio builder | Alternative data signals'),
    t('danelfin','Danelfin','finance','AI stock picking with explainable AI scores and analytics.','https://danelfin.com',true,false,1800, freeTier:'Free basic AI score access', price:20, priceTier:'Pro: full analytics and portfolio tools', tips:'AI explains its predictions | Works for US and European stocks | Portfolio risk assessment'),
    t('signalstack','SignalStack','finance','AI stock signal delivery to broker for automated execution.','https://signalstack.com',false,false,1400, freeTier:'No free tier', price:29, priceTier:'Basic: 100 trades per month', tips:'Connect TradingView alerts | Auto-execute trades | Works with many brokers'),
    t('tickeron-ai','Tickeron AI','finance','AI trading robot and pattern recognition for stocks and crypto.','https://tickeron.com',true,false,2600, freeTier:'Free basic access', price:90, priceTier:'Professional AI robots and signals', tips:'Pre-built AI robots | Pattern recognition | Backtesting tools'),
    t('trality','Trality','finance','AI trading bot creator with Python and rule-based builder.','https://trality.com',true,false,2000, freeTier:'Free paper trading', price:39, priceTier:'Starter: limited live trading volume', tips:'Code editor for Python bots | Visual rule builder | Good documentation'),
    t('coinrule','Coinrule','finance','AI crypto trading bot with rule-based automation for exchanges.','https://coinrule.com',true,false,2400, freeTier:'Free plan with 2 rules', price:29, priceTier:'Starter: 7 rules and more exchange connections', tips:'No coding needed | Pre-built strategies | Works with Binance and Coinbase'),

    // ━━━ HEALTHCARE (more) ━━━
    t('nabla','Nabla','healthcare','AI clinical assistant generating medical notes from consultations.','https://nabla.com',false,true,3600, freeTier:'Free trial for clinicians', price:0, tips:'HIPAA compliant | Integrates with EHR | Real-time note generation'),
    t('abridge','Abridge','healthcare','AI medical note generator trained specifically on clinical data.','https://abridge.com',false,false,2800, freeTier:'Free pilot for health systems', price:0, tips:'Used by major health systems | Epic integration | FDA cleared workflow'),
    t('suki-ai','Suki AI','healthcare','AI voice assistant creating clinical notes for physicians.','https://suki.ai',false,false,2400, freeTier:'No free tier', price:0, tips:'Voice-first clinical documentation | EHR integration | Reduces admin time 72%'),
    t('regard','Regard AI','healthcare','AI physician assistant suggesting diagnoses in EHR systems.','https://regard.com',false,false,1800, freeTier:'No free tier', price:0, tips:'Works inside Epic EHR | Diagnoses from clinical notes | Billing optimization'),
    t('nuance-dax','Nuance DAX','healthcare','Microsoft AI clinical documentation tool for doctors.','https://nuance.com',false,false,3200, freeTier:'No free tier', price:0, tips:'Ambient clinical documentation | Works in exam room | Epic and Cerner integration'),
    t('corti-ai','Corti AI','healthcare','AI medical decision support for emergency calls and triage.','https://corti.ai',false,false,1600, freeTier:'No free tier', price:0, tips:'Real-time call assistance | Cardiac arrest detection | 911 center deployment'),
    t('viz-stroke','Viz.ai Stroke','healthcare','AI detecting stroke in CT scans and alerting neurology teams.','https://viz.ai',false,false,2000, freeTier:'No free tier', price:0, tips:'Reduces time-to-treatment | Automatic specialist notification | FDA cleared'),
    t('butterfly','Butterfly Network AI','healthcare','AI ultrasound device using phone and pocket-sized probe.','https://butterflynetwork.com',false,false,2200, freeTier:'No free tier', price:0, tips:'AI guides ultrasound in real time | Works globally | Medical training tool'),
    t('merative','Merative AI (IBM)','healthcare','AI health analytics platform for clinical informatics.','https://merative.com',false,false,2400, freeTier:'No free tier', price:0, tips:'Population health management | Social determinants of health | Watson heritage'),
    t('health-gorilla','Health Gorilla AI','healthcare','AI health data network connecting providers with patient records.','https://healthgorilla.com',false,false,1800, freeTier:'No free tier', price:0, tips:'FHIR compliant | Lab and imaging integration | Care gap identification'),

    // ━━━ EDUCATION (more) ━━━
    t('synthesis-tutor','Synthesis','education','AI math tutor for K-12 students with game-based learning.','https://synthesis.com',false,false,2800, freeTier:'Free trial available', price:35, priceTier:'Monthly subscription per student', tips:'Strong for math reasoning | Game-based so kids enjoy | Real-time problem solving'),
    t('khan-kids','Khan Academy Kids','education','Free AI educational app for children ages 2-7.','https://khankids.org',true,false,4800, freeTier:'Completely free forever', price:0, tips:'No ads or subscriptions | Reading, math, social skills | Works offline'),
    t('dragonbox','DragonBox Math','education','AI gamified math learning for children K-12.','https://dragonbox.com',false,false,2200, freeTier:'Limited free content', price:8, priceTier:'Per game purchase or subscription', tips:'Makes algebra intuitive | Game-based learning | Strong for ages 5-12'),
    t('prodigy-math','Prodigy Math','education','AI math game adapting to student level in real time.','https://prodigygame.com',true,false,3600, freeTier:'Free basic version', price:5, priceTier:'Premium: deeper game content', tips:'Used in 100K+ classrooms | Adapts difficulty | Curriculum aligned'),
    t('formative-ai','Formative AI','education','AI assessment platform for teachers with real-time data.','https://goformative.com',true,false,2600, freeTier:'Free for basic usage', price:12, priceTier:'Gold: all features and premium assessments', tips:'Real-time student data | Auto-grading with AI | Google Classroom integration'),
    t('pear-practice','Pear Practice','education','AI adaptive practice platform for math and literacy.','https://peardeck.com',true,false,1800, freeTier:'Pear Deck free version', price:15, priceTier:'Premium: advanced interactive slides', tips:'Interactive slides for class | Real-time responses visible | Good engagement tool'),
    t('edulastic','Edulastic AI','education','AI assessment and data platform for K-12 schools.','https://edulastic.com',true,false,2200, freeTier:'Free plan for teachers', price:10, priceTier:'Premium: advanced question types and reporting', tips:'Align to state standards | Auto-grading | Good question bank'),
    t('newsela-ai','Newsela AI','education','AI platform adapting news articles to student reading levels.','https://newsela.com',true,false,3200, freeTier:'Free basic access', price:0, tips:'Non-fiction reading in class | Leveled text for ELL | Comprehension quizzes'),
    t('commonlit-ai','CommonLit AI','education','AI reading and writing platform for grades 3-12.','https://commonlit.org',true,false,2800, freeTier:'Completely free for teachers', price:0, tips:'Research-backed curriculum | Discussion questions | Excellent for ELA'),
    t('myon-ai','myON AI','education','AI personalized reading platform recommending books to students.','https://myon.com',false,false,1800, freeTier:'School license required', price:0, tips:'Personalized book recommendations | Real-time engagement data | News for students'),

    // ━━━ AUTOMATION (more) ━━━
    t('albato','Albato','automation','No-code automation platform similar to Zapier with 600+ apps.','https://albato.com',true,false,1600, freeTier:'Free plan with 300 operations/month', price:9, priceTier:'Basic: 3000 operations per month', tips:'More affordable than Zapier | Good for CRM integrations | EU data centers'),
    t('konnectzit','KonnectzIT','automation','AI workflow automation platform with visual builder.','https://konnectzit.com',true,false,1400, freeTier:'Free plan with 1000 tasks', price:10, priceTier:'Starter: 10000 tasks per month', tips:'Zapier alternative at lower cost | Visual flow builder | Good ecommerce support'),
    t('pabbly-connect','Pabbly Connect','automation','Affordable automation platform with unlimited workflows lifetime deal.','https://pabbly.com/connect',false,false,2800, freeTier:'No free plan', price:19, priceTier:'Starter: unlimited workflows with limits on tasks', tips:'Lifetime deal available | Unlimited workflows | More affordable than Zapier'),
    t('integrately','Integrately','automation','One-click automation platform with 20M+ pre-built automations.','https://integrately.com',true,false,1800, freeTier:'Free plan with 1000 tasks', price:19, priceTier:'Starter: 14000 tasks per month', tips:'Ready-made automations | Easy one-click setup | Good for non-technical users'),
    t('automate-io','Automate.io','automation','Cloud automation tool for business workflows with 200+ apps.','https://automate.io',true,false,1600, freeTier:'Free plan available', price:10, priceTier:'Starter: 2500 actions per month', tips:'Clean simple interface | Pre-built templates | Good for small business'),
    t('celigo','Celigo AI','automation','AI iPaaS platform for enterprise application integration.','https://celigo.com',false,false,2400, freeTier:'No free tier', price:0, tips:'NetSuite specialist | Pre-built connectors | Good for ERP integration'),
    t('mulesoft','MuleSoft AI','automation','Salesforce API-led connectivity and integration platform.','https://mulesoft.com',false,false,4200, freeTier:'No free tier', price:0, tips:'Enterprise standard | AI-generated integrations | Strong for complex flows'),
    t('boomi-ai','Boomi AI','automation','Dell enterprise iPaaS with AI-powered integration suggestions.','https://boomi.com',false,false,3600, freeTier:'No free tier', price:0, tips:'AI suggests mappings | Pre-built connectors library | Good data management'),
    t('camunda-ai','Camunda AI','automation','Open-source business process automation with AI process discovery.','https://camunda.com',true,false,2800, freeTier:'Community edition free', price:0, tips:'BPMN workflow standard | AI discovers processes | Good for enterprises'),
    t('temporal','Temporal','automation','Open-source workflow as code platform for durable execution.','https://temporal.io',true,false,3200, freeTier:'Open source self-host free', price:0, tips:'Code-first workflows | Automatic retries | Used by Stripe and Snap'),
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
