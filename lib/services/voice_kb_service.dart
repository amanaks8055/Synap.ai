// lib/services/voice_kb_service.dart

import '../models/voice_tool_model.dart';
import '../models/tool_model.dart';
import '../services/tool_service.dart';

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

  /// Get all known tools from the directory service.
  /// Dynamically references ToolService for up-to-date directory access.
  static List<Tool> get allTools => ToolService.getAllTools();

  static List<VoiceToolModel> getTools(String query) {
    final q = query.toLowerCase();
    List<Tool> filteredTools = [];

    if (_matches(q, ['video','edit','reels','shorts','clip','banao'])) {
      filteredTools = allTools.where((tool) => tool.category == ToolCategory.video || tool.category == ToolCategory.audio).toList();
    } else if (_matches(q, ['image','photo','picture','tasveer','generate','draw','design'])) {
      filteredTools = allTools.where((tool) => tool.category == ToolCategory.image || tool.category == ToolCategory.design).toList();
    } else if (_matches(q, ['code','coding','program','developer','script'])) {
      filteredTools = allTools.where((tool) => tool.category == ToolCategory.code).toList();
    } else if (_matches(q, ['music','song','audio','gana','beat'])) {
      filteredTools = allTools.where((tool) => tool.category == ToolCategory.audio || tool.category == ToolCategory.video).toList();
    } else if (_matches(q, ['chatgpt','gpt','alternative','replace'])) {
      filteredTools = allTools.where((tool) => tool.category == ToolCategory.chat).toList();
    } else if (_matches(q, ['resume','cv','job','naukri'])) {
      filteredTools = allTools.where((tool) => tool.category == ToolCategory.education || tool.category == ToolCategory.productivity).toList();
    } else if (_matches(q, ['write','writing','likhna','content','blog'])) {
      filteredTools = allTools.where((tool) => tool.category == ToolCategory.writing).toList();
    } else if (_matches(q, ['present','presentation','slides'])) {
      filteredTools = allTools.where((tool) => tool.category == ToolCategory.design || tool.category == ToolCategory.research).toList();
    } else if (_matches(q, ['search','find','dhundh','research'])) {
      filteredTools = allTools.where((tool) => tool.category == ToolCategory.research || tool.category == ToolCategory.chat).toList();
    } else if (_matches(q, ['voice','speech','tts','bolna'])) {
      filteredTools = allTools.where((tool) => tool.category == ToolCategory.audio).toList();
    } else {
      filteredTools = allTools; // Default to all tools if no specific category matches
    }

    // Convert Tool objects to VoiceToolModel objects
    return filteredTools.map((tool) => VoiceToolModel(
      name: tool.name,
      emoji: tool.iconEmoji,
      isFree: tool.hasFreeTier,
      category: tool.category.label,
      url: tool.websiteUrl,
      description: tool.description,
    )).toList();
  }

  static bool _matches(String q, List<String> keywords) =>
      keywords.any((k) => q.contains(k));

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
