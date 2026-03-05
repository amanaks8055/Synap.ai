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
    t('gen3', freeTier:'Free basic credits for exploration', price:12, priceTier:'Standard monthly annual', tips:'Runway\'s gold standard for AI video | Features world-class "Gen-3 Alpha" for ultra-realistic physics and cinematics used by Hollywood studios'),
    t('gptzero', freeTier:'Free basic detection (up to 5k chars)', price:10, priceTier:'Essential monthly annual', tips:'The world leader in AI content detection | Best for teachers and editors verifying academic and journalistic integrity with high-accuracy data logs'),
    t('originality-ai', freeTier:'Free browser extension basic', price:15, priceTier:'Pay-as-you-go credits', tips:'Leading platform for professional web publishers | Best for detecting AI content, plagiarism, and fact-checking at massive scale'),
    t('studio-d-id', freeTier:'Free trial for 5 minutes of video', price:5, priceTier:'Lite monthly annual', tips:'Leading platform for talking head avatars | Best for turning any photo into a realistic speaking video for corporate training and social media'),
    t('vidu', freeTier:'Free beta access available', price:0, tips:'Next-gen Chinese AI video leader | Best for high-complexity human motion and cinematic lighting in 16:9 and 9:16 formats'),
    t('rask-ai', freeTier:'Free 1-minute video trial', price:49, priceTier:'Basic monthly annual', tips:'The gold standard for automated video dubbing | AI-powered "Voice Cloning" and "Lip-Sync" supports 130+ languages for global content reach'),
    t('zerogpt', freeTier:'Completely free online tool', price:0, tips:'Popular AI content detector | Best for fast checks on student essays and blog posts to find GPT-4 and Llama generated text'),
    t('sapling-ai', freeTier:'Free forever basic version', price:25, priceTier:'Pro monthly annual', tips:'Leading AI assistant for customer support teams | Best for automated grammar, tone, and data snippets inside CRMs like Salesforce and Zendesk'),
    t('studio-d-id-pro', freeTier:'Free basic video', price:5, priceTier:'Lite monthly', tips:'High-end AI avatar studio | Use the "Agent" mode to build interactive talking bots based on your custom knowledge data'),
    t('gpt-zero-pro', freeTier:'Free basic access', price:10, priceTier:'Pro monthly', tips:'The "Safety First" tool for educators | Features world-class "Handwriting" and "Source" detection to verify human creativity'),
    t('originality-pro', freeTier:'Free tool access', price:30, priceTier:'Monthly subscription', tips:'The ultimate SEO integrity toolkit | Best for managing large content teams and verifying hundreds of articles monthly for AI footprints'),
    t('vidu-ai', freeTier:'Free beta credits', price:0, tips:'Shengshu AI\'s powerhouse video model | Features incredible "Multimodal" understanding and physical consistency in generated clips'),
    t('rask-ai-pro', freeTier:'Free video trial', price:49, priceTier:'Basic monthly', tips:'The "All-in-one" video localization suite | AI-powered "Subtitle" and "Translation" used by top YouTube creators worldwide'),
    t('vocalize', freeTier:'Free basic version available', price:0, tips:'Leading platform for AI-powered voice transformations | Best for turning any audio into high-quality professional voiceovers'),
    t('zero-gpt-pro', freeTier:'Free online detector', price:0, tips:'The "Reliable" choice for fast content verification | Used by millions of writers to maintain authentic human-voice standards'),
    t('sapling-pro', freeTier:'Free basic extension', price:25, priceTier:'Individual monthly', tips:'The smartest writing assistant for business | AI-powered "Autocomplete" and data snippets used by top B2B sales teams'),
    t('runway-gen3', freeTier:'Free credits initially', price:12, priceTier:'Standard monthly', tips:'The pioneer of high-end AI cinema | Best for professional directors and creative researchers building new visual worlds'),
    t('d-id-studio', freeTier:'Free video credits', price:5, priceTier:'Lite monthly', tips:'The easiest way to animate historical or generated photos | Features world-class "Deep Nostalgia" and speaking data mapping'),
    t('vmake-ai', freeTier:'Free forever basic version', price:10, priceTier:'Pro monthly credits', tips:'Leading AI for fashion and product photography | Best for turning flat clothing photos into high-end "Model" shots instantly'),
    t('carrd-ai', freeTier:'Free to build on Carrd domain', price:19, priceTier:'Pro Lite yearly', tips:'Leading platform for ultra-fast landing pages | AI-powered "Layout" and "Design" help for one-page business sites'),
    t('splitter-ai-pro', freeTier:'Free basic online version', price:0, tips:'Best for musicians and producers | AI-powered "Stem" separation isolates vocals and instruments with high-fidelity for remixing'),
    t('vocalize-ai', freeTier:'Free trial available', price:0, tips:'Leading platform for high-end voice cloning and synthesis | Best for gaming and podcast voiceovers with deep emotional data'),
    t('hourone-video-pro', freeTier:'Free trial available', price:25, priceTier:'Lite monthly', tips:'Enterprise-grade AI personas for business | AI-powered "Video" generation from text briefs used by top HR and sales departments'),
    t('listnr-pro', freeTier:'Free trial for 2 voices', price:9, priceTier:'Individual monthly annual', tips:'Leading platform for high-accuracy text-to-speech for podcasters | Best for turning blogs into premium audio content'),
    t('cliptv-ai', freeTier:'Free trial for 3 videos', price:20, priceTier:'Starter monthly annual', tips:'Best for repurposing long podcasts into viral shorts | AI-powered "Smart Crop" and "Subtitle" generation for TikTok/Reels'),
    t('biteable', freeTier:'Free trial for 14 days', price:49, priceTier:'Pro monthly annual', tips:'The easiest way to make professional business videos | AI-powered "Template" and "Media" matching for internal comms'),
    t('wisecut-pro', freeTier:'Free basic version available', price:10, priceTier:'Starter monthly annual', tips:'Leading platform for automated jump-cut video editing | AI-powered "Voice" and "Silence" removal for fast talking-head videos'),
    t('papercup-ai', freeTier:'Institutional only', price:0, tips:'Leading AI for dubbing long-form content for media giants | Best for TV shows and high-end YouTube channels (Sky News, Discovery)'),
    t('vmake', freeTier:'Free simple tools', price:10, priceTier:'Pro monthly', tips:'The "Power-user" tool for e-commerce visual design | AI-powered "Background" and "Model" generation for Shopify stores'),
    t('carrd', freeTier:'Free Forever (3 sites)', price:19, priceTier:'Pro Lite yearly', tips:'The king of simple landing pages | AI-powered "Template" customization and SEO data management for mobile sites'),
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
