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
    t('vidiq-ai', freeTier:'Free basic version available', price:7, priceTier:'Pro monthly annual', tips:'The world leader in YouTube growth | AI-powered "Title" and "Idea" generation derived from real-time viral data'),
    t('tubebuddy', freeTier:'Free forever basic version', price:3, priceTier:'Pro monthly annual', tips:'Best for YouTube SEO and A/B testing | AI-powered "Thumbnail Analyzer" and "Keyword Explorer"'),
    t('boomy', freeTier:'Free to create and save songs', price:9, priceTier:'Premium monthly annual', tips:'Leading platform for AI-generated music | Best for creating unique background tracks for streaming services like Spotify'),
    t('beatoven', freeTier:'Free basic version available', price:20, priceTier:'Pro monthly annual', tips:'Best for mood-based background music | AI-powered "Emotional" score for video content and games'),
    t('soundraw', freeTier:'Free to create and save tracks', price:16, priceTier:'Creator monthly annual', tips:'Leading customizable AI music platform | AI-powered "Length" and "Mood" editing for pro video editors'),
    t('deepgram', freeTier:'\$200 free trial credits', price:0, tips:'Leading speech-to-text API for enterprises | AI-powered "Voice" and "Language" models are extremely fast and accurate'),
    t('natural-reader', freeTier:'Free basic version online', price:9, priceTier:'Premium monthly annual', tips:'The world leader in high-fidelity text to speech | AI-powered "Humanoid" voices for reading papers and books'),
    t('resemble', freeTier:'Free trial credits initially', price:0, tips:'Leading AI voice cloning for games and film | AI-powered "Emotion" and "Speech-to-Speech" transformations are elite'),
    t('dify', freeTier:'Free forever (self-hosted)', price:59, priceTier:'Cloud Pro monthly', tips:'Leading open source LLMOps platform | Best for building RAG applications and AI agents with complex data flows'),
    t('relevance-ai', freeTier:'Free forever for 1 project', price:199, priceTier:'Team monthly annual', tips:'Leading platform for building specialized AI workforces | Best for automated sales and support agents at scale'),
    t('haiper', freeTier:'Free basic daily credits', price:24, priceTier:'Pro monthly credits', tips:'Leading AI video generation lab | Best for high-accuracy motion and realistic artistic physics in clips'),
    t('type-studio', freeTier:'Free trial for 20 mins', price:12, priceTier:'Basic monthly annual', tips:'Best for text-based video editing | AI-powered "Subtitle" and "Social" video repurposing is very fast'),
    t('predis', freeTier:'Free for up to 15 posts/mo', price:20, priceTier:'Lite monthly annual', tips:'The "Canva + AI" for social media | Generates complete posts with captions and hashtags from a simple prompt'),
    t('recently-ai', freeTier:'7-day free trial on site', price:49, priceTier:'Professional monthly starting', tips:'Leading platform for repurposing content | AI-powered "Vibe" analysis turns long-form blogs into social posts'),
    t('copy-smith', freeTier:'7-day free trial on site', price:19, priceTier:'Starter monthly annual', tips:'Best for e-commerce copywriting | AI-powered "Bulk" product description generation for large stores'),
    t('ghostwriter', freeTier:'Free basic credits daily', price:10, priceTier:'Pro monthly annual', tips:'Leading AI plugin for Microsoft Word | Best for professional book and article writing with context'),
    t('dragonfly', freeTier:'Institutional only', price:0, tips:'Leading AI for visual attention mapping | Best for predictive heatmap analysis on ads and packaging'),
    t('whisper-ai', freeTier:'Completely free open source', price:0, tips:'OpenAI\'s gold standard for audio | Use "Whisper Large-V3" for extremely accurate multi-lingual transcription'),
    t('descript-overdub', freeTier:'Free basic version available', price:12, priceTier:'Creator monthly annual', tips:'The world leader in AI voice cloning from text | Best for fixing audio mistakes without re-recording'),
    t('speechlab', freeTier:'Free trial available on site', price:0, tips:'Leading platform for automated video dubbing | AI-powered "Lip-sync" and "Language" translation is elite'),
    t('writeseo', freeTier:'Free for 1 article/mo', price:19, priceTier:'Starter monthly annual', tips:'Best for long-form SEO optimization | AI-powered "Keyword" and "Content" data for high-ranking blogs'),
    t('natural-reader-ai', freeTier:'Free basic online version', price:9, priceTier:'Pro monthly', tips:'The industry standard for lifelike text-to-speech | Best for accessibility and reading long documents'),
    t('deep-gram-ai', freeTier:'Free trial with credits', price:0, tips:'Leading enterprise speech recognition | AI-powered "Live Transcription" for developers at scale'),
    t('sound-raw-ai', freeTier:'Free creation tier', price:16, priceTier:'Creator monthly', tips:'High-end AI music for content creators | Use the "Mood" filters to find perfect tracks for your brand'),
    t('resemble-ai', freeTier:'Free trial available', price:0, tips:'Pioneer of deepfake-level voice synthesis | Best for high-quality clones and emotional speech'),
    t('predis-ai', freeTier:'Free for personal use', price:20, priceTier:'Pro monthly', tips:'All-in-one social media assistant | AI-powered "Designer" and "Scheduler" in one place'),
    t('vid-iq', freeTier:'Free basic tools', price:7, priceTier:'Pro monthly', tips:'The king of YouTube growth tools | AI-powered "Keyword" and "Historical" data visualization'),
    t('boomy-ai', freeTier:'Free to create tracks', price:9, priceTier:'Premium monthly', tips:'The "Instant" music generator | Best for royalty-free tracks for your YouTube and social content'),
    t('beatoven-ai', freeTier:'Free basic access', price:20, priceTier:'Pro monthly', tips:'Specialized AI music for video and film | AI-powered "Cinematic" mood generation'),
    t('naturalreader-ai', freeTier:'Free basic access', price:9, priceTier:'Plus monthly', tips:'High-quality AI voice narrator | Best for turning newsletters and blogs into podcasts'),
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
