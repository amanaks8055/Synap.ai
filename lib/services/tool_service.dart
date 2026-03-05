// ══════════════════════════════════════════════════════════════
// SYNAP — ToolService
// Fetches tools from Supabase (primary) with MockData fallback
// ══════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/mock_data.dart';
import '../models/tool_model.dart';

class ToolService {
  // ── In-memory cache ──────────────────────────────────────
  static List<Tool>? _cachedTools;
  static bool _isLoading = false;

  /// Get all tools (cached). Call [loadTools] first on app start.
  static List<Tool> getAllTools() => _cachedTools ?? MockData.tools;

  /// Load tools from Supabase. Falls back to MockData on error.
  /// Safe to call multiple times — only fetches once.
  static Future<List<Tool>> loadTools() async {
    if (_cachedTools != null) return _cachedTools!;
    if (_isLoading) {
      // Wait for ongoing load to finish
      while (_isLoading) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return _cachedTools ?? MockData.tools;
    }

    _isLoading = true;

    try {
      final sb = Supabase.instance.client;

      // Try fetching from 'ai_tools' table (no row limit — fetch ALL)
      // Supabase default limit is 1000, so we use range() to get all
      final List<dynamic> allRows = [];
      const batchSize = 1000;
      int offset = 0;

      // Try 'ai_tools' table first, then fallback to 'tools'
      final tableNames = ['ai_tools', 'tools'];
      
      for (final tableName in tableNames) {
        try {
          final testBatch = await sb.from(tableName).select().limit(1);
          if (testBatch.isNotEmpty) {
            // Found the right table! Now fetch ALL rows with pagination
            debugPrint('[ToolService] Using table: $tableName');
            
            while (true) {
              final batch = await sb
                  .from(tableName)
                  .select()
                  .range(offset, offset + batchSize - 1)
                  .order('name', ascending: true);

              allRows.addAll(batch);
              if (batch.length < batchSize) break;
              offset += batchSize;
            }
            break; // Stop trying other table names
          }
        } catch (_) {
          continue; // Try next table name
        }
      }

      if (allRows.isNotEmpty) {
        _cachedTools = allRows
            .map((row) => Tool.fromJson(row as Map<String, dynamic>))
            .toList();
        debugPrint('[ToolService] ✅ Loaded ${_cachedTools!.length} tools from Supabase');
      } else {
        // Table exists but empty — fall back to MockData
        debugPrint('[ToolService] ⚠️ No tools in Supabase, using MockData');
        _cachedTools = MockData.tools;
      }
    } catch (e) {
      // Table might not exist or network error — use MockData
      debugPrint('[ToolService] ⚠️ Supabase fetch failed: $e');
      debugPrint('[ToolService] Falling back to MockData (${MockData.tools.length} tools)');
      _cachedTools = MockData.tools;
    }

    _isLoading = false;
    return _cachedTools!;
  }

  /// Force refresh from Supabase (e.g., pull-to-refresh)
  static Future<List<Tool>> refreshTools() async {
    _cachedTools = null;
    return loadTools();
  }

  // ── Query helpers (use cached data) ─────────────────────
  static List<Tool> getFeaturedTools() =>
      getAllTools().where((t) => t.isFeatured).toList();

  /// Curated list of the most famous, high-retention AI tools worldwide.
  /// These are the tools everyone searches for — highest DAU / MAU globally.
  static List<Tool> getTrendingTools() {
    const trendingIds = [
      'chatgpt',          // OpenAI — #1 AI chatbot globally
      'midjourney',       // MidJourney — #1 AI art platform
      'claude',           // Anthropic Claude — fastest growing LLM
      'gemini',           // Google Gemini — massive user base
      'cursor_ai',        // Cursor — #1 AI code editor
      'perplexity',       // Perplexity — AI-first search engine
      'copilot',          // GitHub Copilot — most used dev AI
      'dall_e',           // DALL-E 3 — OpenAI image gen
      'suno',             // Suno — #1 AI music gen
      'eleven_labs',      // ElevenLabs — #1 AI voice clone
      'notion_ai',        // Notion AI — largest productivity AI
      'runway',           // RunwayML — leading video AI
      'stable_audio',     // Stable Audio — gen AI music
      'agent_gpt',        // AgentGPT — autonomous AI agents
      'cloudflare_ai',    // Cloudflare AI — edge AI inference
      'framer_ai',        // Framer AI — AI web design
      'clickup_ai',       // ClickUp AI — productivity giant
      'zapier_ai',        // Zapier — workflow automation king
      'remove_bg',        // Remove.bg — most used background tool
      'ada_health',       // Ada Health — top health AI
    ];
    final all = getAllTools();
    final trendingList = <Tool>[];
    for (final id in trendingIds) {
      final match = all.where((t) => t.id == id);
      if (match.isNotEmpty) trendingList.add(match.first);
    }
    // If we couldn't find enough by ID, fill with featured tools
    if (trendingList.length < 10) {
      final featured = all.where((t) => t.isFeatured && !trendingList.contains(t));
      trendingList.addAll(featured.take(20 - trendingList.length));
    }
    return trendingList;
  }

  static List<Tool> getToolsByCategory(String categoryId) =>
      getAllTools().where((t) => t.categoryId == categoryId).toList();

  static List<Tool> searchTools(String query) {
    final q = query.toLowerCase();
    return getAllTools().where((t) =>
      t.name.toLowerCase().contains(q) ||
      t.description.toLowerCase().contains(q)
    ).toList();
  }

  static List<Tool> filterTools({
    String? categoryId,
    String? query,
    bool? freeOnly,
  }) {
    var list = getAllTools().toList();

    if (categoryId != null && categoryId != 'all') {
      list = list.where((t) => t.categoryId == categoryId).toList();
    }

    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      list = list.where((t) =>
        t.name.toLowerCase().contains(q) ||
        t.description.toLowerCase().contains(q)
      ).toList();
    }

    if (freeOnly == true) {
      list = list.where((t) => t.hasFreeTier).toList();
    }

    return list;
  }

  // ── Stats ───────────────────────────────────────────────
  static int get totalCount => getAllTools().length;
  static int getToolCountForCategory(String categoryId) =>
      getToolsByCategory(categoryId).length;
  static int getFreeToolCountForCategory(String categoryId) =>
      getToolsByCategory(categoryId).where((t) => t.hasFreeTier).length;
}
