// lib/services/voice_kb_service.dart

import '../models/voice_tool_model.dart';

class VoiceKBService {
  static String getResponse(String query) {
    final q = query.toLowerCase();
    if (_matches(q, ['video','edit','reels','shorts','clip'])) {
      return 'Best free tools for video editing:';
    }
    if (_matches(q, ['image','photo','picture','generate','draw','design'])) {
      return 'Try these for free image generation:';
    }
    if (_matches(q, ['code','coding','program','developer','script','develop'])) {
      return 'Best free AI tools for coding:';
    }
    if (_matches(q, ['music','song','audio','beat','sound'])) {
      return 'For free music generation:';
    }
    if (_matches(q, ['chatgpt','gpt','alternative','replace'])) {
      return 'Best free alternatives to ChatGPT:';
    }
    if (_matches(q, ['resume','cv','job','interview'])) {
      return 'For resume and job applications:';
    }
    if (_matches(q, ['write','writing','content','blog','article'])) {
      return 'Best free AI tools for writing:';
    }
    if (_matches(q, ['present','presentation','slides','deck'])) {
      return 'To create presentations:';
    }
    if (_matches(q, ['search','find','research','information'])) {
      return 'For research and search:';
    }
    if (_matches(q, ['voice','speech','tts','text to speech','speak'])) {
      return 'For voice and text-to-speech:';
    }
    return 'Here are popular free AI tools that can help:';
  }

  static List<VoiceToolModel> getTools(String query) {
    final q = query.toLowerCase();
    if (_matches(q, ['video','edit','reels','shorts','clip','banao'])) {
      return _videoTools;
    }
    if (_matches(q, ['image','photo','picture','tasveer','generate','draw','design'])) {
      return _imageTools;
    }
    if (_matches(q, ['code','coding','program','developer','script'])) {
      return _codeTools;
    }
    if (_matches(q, ['music','song','audio','gana','beat'])) {
      return _musicTools;
    }
    if (_matches(q, ['chatgpt','gpt','alternative','replace'])) {
      return _chatTools;
    }
    if (_matches(q, ['resume','cv','job','naukri'])) {
      return _resumeTools;
    }
    if (_matches(q, ['write','writing','likhna','content','blog'])) {
      return _writingTools;
    }
    if (_matches(q, ['present','presentation','slides'])) {
      return _presentationTools;
    }
    if (_matches(q, ['search','find','dhundh','research'])) {
      return _searchTools;
    }
    if (_matches(q, ['voice','speech','tts','bolna'])) {
      return _voiceTools;
    }
    return _defaultTools;
  }

  static bool _matches(String q, List<String> keywords) =>
      keywords.any((k) => q.contains(k));

  // ── Tool lists ──────────────────────────────────────────────
  static const _videoTools = [
    VoiceToolModel(name:'CapCut AI',    emoji:'✂️', isFree:true,  category:'Video', url:'capcut.com',    description:'Free AI video editing, auto-captions, effects. Best for Reels & Shorts.'),
    VoiceToolModel(name:'Runway Gen-3', emoji:'🎬', isFree:false, category:'Video', url:'runwayml.com',  description:'125 free credits/month. AI video generation from text.'),
    VoiceToolModel(name:'Pika Labs',    emoji:'🎞️', isFree:false, category:'Video', url:'pika.art',      description:'250 free credits. Text to video, easy to use.'),
  ];

  static const _imageTools = [
    VoiceToolModel(name:'Ideogram',        emoji:'🎨', isFree:true,  category:'Image', url:'ideogram.ai',     description:'Unlimited free images with perfect text rendering.'),
    VoiceToolModel(name:'Adobe Firefly',   emoji:'🔥', isFree:false, category:'Image', url:'firefly.adobe.com',description:'25 free credits/month. Commercially safe AI images.'),
    VoiceToolModel(name:'Microsoft Designer',emoji:'💎',isFree:true, category:'Image', url:'designer.microsoft.com',description:'Free AI image generation using DALL-E 3.'),
  ];

  static const _codeTools = [
    VoiceToolModel(name:'Cursor AI',       emoji:'⌨️', isFree:false, category:'Code', url:'cursor.sh',       description:'2000 free completions/month. Best AI code editor available.'),
    VoiceToolModel(name:'GitHub Copilot',  emoji:'🐙', isFree:false, category:'Code', url:'github.com',      description:'Free for students. AI code completion in VS Code and more.'),
    VoiceToolModel(name:'Replit AI',       emoji:'💻', isFree:true,  category:'Code', url:'replit.com',      description:'Free AI coding assistant with cloud IDE. No setup needed.'),
  ];

  static const _musicTools = [
    VoiceToolModel(name:'Suno AI',    emoji:'🎵', isFree:false, category:'Audio', url:'suno.com',     description:'50 free credits/day. Create full songs with lyrics from text.'),
    VoiceToolModel(name:'Udio',       emoji:'🎶', isFree:false, category:'Audio', url:'udio.com',     description:'1200 free credits/month. High quality AI music generation.'),
    VoiceToolModel(name:'Soundraw',   emoji:'🎸', isFree:false, category:'Audio', url:'soundraw.io',  description:'5 free songs/day. Royalty-free background music.'),
  ];

  static const _chatTools = [
    VoiceToolModel(name:'Claude',      emoji:'✦',  isFree:false, category:'Chat', url:'claude.ai',         description:'40 free messages/day. Best for long documents and analysis.'),
    VoiceToolModel(name:'Gemini',      emoji:'♊',  isFree:true,  category:'Chat', url:'gemini.google.com', description:'60 free queries/day. Google integrated, great for research.'),
    VoiceToolModel(name:'Perplexity',  emoji:'🔍', isFree:false, category:'Search',url:'perplexity.ai',    description:'5 Pro searches/day free. Best AI-powered search engine.'),
  ];

  static const _resumeTools = [
    VoiceToolModel(name:'Kickresume',  emoji:'📄', isFree:false, category:'Career', url:'kickresume.com',  description:'Free AI resume builder. ATS-optimized templates.'),
    VoiceToolModel(name:'Resume.io',   emoji:'📋', isFree:false, category:'Career', url:'resume.io',       description:'AI suggestions for better resume writing.'),
    VoiceToolModel(name:'ChatGPT',     emoji:'🤖', isFree:false, category:'Chat',   url:'chat.openai.com', description:'Paste your resume, ask for improvements. Free tier: 40 msgs/3h.'),
  ];

  static const _writingTools = [
    VoiceToolModel(name:'Claude',      emoji:'✦',  isFree:false, category:'Writing', url:'claude.ai',       description:'Best for long-form writing. 40 free messages daily.'),
    VoiceToolModel(name:'Writesonic',  emoji:'✍️', isFree:false, category:'Writing', url:'writesonic.com',  description:'Free tier available. Blog posts, ads, social media copy.'),
    VoiceToolModel(name:'Copy.ai',     emoji:'📝', isFree:false, category:'Writing', url:'copy.ai',         description:'2000 words free/month. Marketing copy and content.'),
  ];

  static const _presentationTools = [
    VoiceToolModel(name:'Gamma',       emoji:'📊', isFree:false, category:'Slides', url:'gamma.app',       description:'10 free credits/month. AI presentations in seconds.'),
    VoiceToolModel(name:'Canva AI',    emoji:'🎨', isFree:true,  category:'Design', url:'canva.com',       description:'Free AI presentation templates and design tools.'),
    VoiceToolModel(name:'Beautiful.ai',emoji:'✨', isFree:false, category:'Slides', url:'beautiful.ai',    description:'Smart slide templates that design themselves.'),
  ];

  static const _searchTools = [
    VoiceToolModel(name:'Perplexity',  emoji:'🔍', isFree:false, category:'Search', url:'perplexity.ai',   description:'5 Pro searches/day. Cites sources, accurate answers.'),
    VoiceToolModel(name:'Gemini',      emoji:'♊',  isFree:true,  category:'Search', url:'gemini.google.com',description:'Google-powered AI search. 60 queries/day free.'),
    VoiceToolModel(name:'You.com',     emoji:'🌐', isFree:true,  category:'Search', url:'you.com',         description:'Free unlimited AI search with source citations.'),
  ];

  static const _voiceTools = [
    VoiceToolModel(name:'ElevenLabs',  emoji:'🎙️', isFree:false, category:'Voice', url:'elevenlabs.io',   description:'10,000 free characters/month. Most realistic AI voices.'),
    VoiceToolModel(name:'Murf AI',     emoji:'🔊', isFree:false, category:'Voice', url:'murf.ai',         description:'10 mins free voice generation. 120+ AI voices.'),
    VoiceToolModel(name:'PlayHT',      emoji:'📢', isFree:false, category:'Voice', url:'play.ht',         description:'12,500 free characters/month. Voice cloning available.'),
  ];

  static const _defaultTools = [
    VoiceToolModel(name:'ChatGPT',     emoji:'🤖', isFree:false, category:'Chat',  url:'chat.openai.com', description:'40 messages/3h on GPT-4o. Best all-rounder AI assistant.'),
    VoiceToolModel(name:'Claude',      emoji:'✦',  isFree:false, category:'Chat',  url:'claude.ai',       description:'40 messages/day. Excellent for writing and analysis.'),
    VoiceToolModel(name:'Gemini',      emoji:'♊',  isFree:true,  category:'Chat',  url:'gemini.google.com',description:'60 queries/day free. Google integrated AI assistant.'),
  ];

  // ── Track command parser ────────────────────────────────────
  static Map<String, dynamic>? parseTrackCommand(String text) {
    final t = text.toLowerCase();
    String? toolId;
    if (t.contains('chatgpt') || t.contains('gpt'))    toolId = 'chatgpt_gpt4o';
    if (t.contains('claude'))                           toolId = 'claude';
    if (t.contains('gemini'))                           toolId = 'gemini';
    if (t.contains('perplexity'))                       toolId = 'perplexity';
    if (t.contains('suno'))                             toolId = 'suno';
    if (t.contains('midjourney'))                       toolId = 'midjourney';
    if (t.contains('cursor'))                           toolId = 'cursor';
    if (toolId == null) return null;

    final numMatch = RegExp(r'\d+').firstMatch(t);
    final count    = numMatch != null ? int.parse(numMatch.group(0)!) : 1;

    // Reset command
    final isReset = t.contains('reset') || t.contains('clear') ||
                    t.contains('zero')  || t.contains('shuru');

    return {'toolId': toolId, 'count': count, 'isReset': isReset};
  }
}
