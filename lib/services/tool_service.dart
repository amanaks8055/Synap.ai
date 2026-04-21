// ══════════════════════════════════════════════════════════════
// SYNAP — ToolService
// Fetches tools from Supabase 'tools' table
// REQUIRED: Pagination support, proper limits, NO MockData fallback
// ══════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tool_model.dart';
import '../data/tools_data.dart';

class ToolService {
  // ── In-memory cache ──────────────────────────────────────
  static List<Tool>? _cachedTools;
  static bool _isLoading = false;

  // ── Tools to exclude from UI rows (keep in DB but not shown in trending/category rows)
  static const _excludedToolIds = <String>{
    // Tools with missing/poor icons that should not appear in row previews.
    'curio', // chat/conversation
    'fathom', // audio/voice
    'storybird-ai',
    'lovo-fitness',
    'caption_health',
    'livongo',
    'tiller-money-ai',
    'palo-alto-cortex',
    'trm-labs-ai',
    // Explicit removals requested
    'legaleze',
    'legalze',
    'legalese',
    'chainalysis',
    'tailbox',
    'weedone20',
  };

  // Strict global removals requested by user: hide everywhere (rows/search/category/all)
  static const _globallyBlockedToolIds = <String>{
    'legaleze',
    'legalze',
    'legalese',
    'chainalysis',
    'tailbox',
    'weedone20',
  };

  static String _normalizeKey(String raw) => raw
      .toLowerCase()
      .trim()
      .replaceAll(RegExp(r'[^a-z0-9]'), '');

  static bool _isExcludedTool(Tool tool) {
    final id = tool.id.toLowerCase().trim();
    final name = tool.name.toLowerCase().trim();
    final idNorm = _normalizeKey(id);
    final nameNorm = _normalizeKey(name);

    if (_excludedToolIds.contains(id) || _excludedToolIds.contains(name)) {
      return true;
    }

    for (final blocked in _excludedToolIds) {
      final blockedNorm = _normalizeKey(blocked);
      if (blockedNorm.isEmpty) continue;
      if (idNorm.contains(blockedNorm) || nameNorm.contains(blockedNorm)) {
        return true;
      }
    }
    return false;
  }

  static bool _isGloballyBlockedTool(Tool tool) {
    final idNorm = _normalizeKey(tool.id);
    final nameNorm = _normalizeKey(tool.name);
    for (final blocked in _globallyBlockedToolIds) {
      final blockedNorm = _normalizeKey(blocked);
      if (blockedNorm.isEmpty) continue;
      if (idNorm == blockedNorm || nameNorm == blockedNorm) {
        return true;
      }
      if (idNorm.contains(blockedNorm) || nameNorm.contains(blockedNorm)) {
        return true;
      }
    }
    return false;
  }

  // ── Background loading future (for parallel splash) ──────
  static Future<void>? _loadFuture;

  /// Starts loading tools in the background. Returns immediately.
  /// Use [loadingComplete] to await the result.
  static void startBackgroundLoad() {
    _loadFuture ??= loadTools();
  }

  /// Completes when background tool loading is done.
  static Future<void> get loadingComplete => _loadFuture ?? Future.value();

  /// Notifier that increments when tools are refreshed (for UI rebuild)
  static final ValueNotifier<int> toolsVersion = ValueNotifier<int>(0);

  /// Get all tools (cached). Call [loadTools] first on app start.
  static List<Tool> getAllTools() {
    final all = _cachedTools ?? [];
    return all.where((t) => !_isGloballyBlockedTool(t)).toList();
  }

  /// Get all known tools from the directory service.
  /// Returns dynamic data from ToolService instead of static MockData.
  static List<Tool> get allTools => ToolService.getAllTools();

  /// Load tools from Supabase with specific limits.
  /// Fetches tools from 'ai_tools' and ensures today's tools are present.
  static Future<List<Tool>> loadTools() async {
    if (_cachedTools != null) return _cachedTools!;
    if (_isLoading) {
      while (_isLoading) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return _cachedTools ?? [];
    }

    _isLoading = true;

    try {
      final sb = Supabase.instance.client;

      // 1. Fetch ALL tools from 'ai_tools' in chunks of 1000
      // Supabase .range() is inclusive, so range(0,999) = 1000 rows
      // Retry up to 5 times with exponential backoff on network errors
      final List<dynamic> allRows = [];
      bool finished = false;
      int offset = 0;
      const int maxRetries = 5;
      
      while (!finished && allRows.length < 15000) {
        bool chunkSuccess = false;
        for (int attempt = 1; attempt <= maxRetries; attempt++) {
          try {
            final rows = await sb
                .from('ai_tools')
                .select()
                .range(offset, offset + 999);
            
            debugPrint('[ToolService] Chunk at offset $offset → ${rows.length} rows');
            
            if (rows.isEmpty) {
              finished = true;
            } else {
              allRows.addAll(rows as List);
              offset += rows.length;
              if (rows.length < 1000) finished = true;
            }
            chunkSuccess = true;
            break; // success, exit retry loop
          } catch (chunkErr) {
            debugPrint('[ToolService] Chunk error at offset $offset (attempt $attempt/$maxRetries): $chunkErr');
            if (attempt < maxRetries) {
              final delay = Duration(seconds: attempt * 3); // 3s, 6s, 9s, 12s
              debugPrint('[ToolService] Retrying in ${delay.inSeconds}s...');
              await Future.delayed(delay);
            }
          }
        }
        if (!chunkSuccess) {
          debugPrint('[ToolService] All $maxRetries retries failed at offset $offset — stopping fetch');
          finished = true;
        }
      }

      debugPrint('[ToolService] Total rows fetched from Supabase: ${allRows.length}');

      if (allRows.isNotEmpty) {
        // ── Debug: log actual DB columns from first row ──
        final firstRow = allRows.first as Map<String, dynamic>;
        debugPrint('[ToolService] DB Columns: ${firstRow.keys.toList()}');
        debugPrint('[ToolService] Sample row[0]: rating=${firstRow['rating']}, review_count=${firstRow['review_count']}, votes=${firstRow['votes']}, added_at=${firstRow['added_at']}, created_at=${firstRow['created_at']}, name=${firstRow['name']}');
        if (allRows.length > 100) {
          final row100 = allRows[100] as Map<String, dynamic>;
          debugPrint('[ToolService] Sample row[100]: rating=${row100['rating']}, review_count=${row100['review_count']}, votes=${row100['votes']}, name=${row100['name']}');
        }

        final List<Tool> parsedTools = [];
        int parseErrors = 0;
        for (final row in allRows) {
          try {
            final tool = Tool.fromJson(row as Map<String, dynamic>);
            parsedTools.add(tool);
          } catch (e) {
            parseErrors++;
            if (parseErrors <= 5) {
              debugPrint('[ToolService] Parse error #$parseErrors: $e | row keys: ${(row as Map).keys.take(8)}');
            }
          }
        }
        
        if (parseErrors > 0) {
          debugPrint('[ToolService] Total parse errors: $parseErrors / ${allRows.length}');
        }
        // Sort in-memory (safe — doesn't rely on DB column)
        parsedTools.removeWhere(_isGloballyBlockedTool);
        parsedTools.sort((a, b) => b.votes.compareTo(a.votes));
        _cachedTools = parsedTools;
        toolsVersion.value++;
        debugPrint('[ToolService] ✅ Loaded ${_cachedTools!.length} tools from ai_tools');

        // ── Icon URL diagnostics ──
        _debugIconStats(parsedTools);

        // ── Fetch today's tools from 'tools' table (has added_at) ──
        await fetchTodayTools();
      } else {
        debugPrint('[ToolService] No tools from Supabase — using local fallback (${ToolsData.all.length} tools)');
        _cachedTools = List<Tool>.from(ToolsData.all)
          ..removeWhere(_isGloballyBlockedTool);
        // Schedule background retry after 10s
        _scheduleBackgroundRetry();
      }
    } catch (e, stack) {
      debugPrint('[ToolService] ❌ Supabase error: $e');
      debugPrint('[ToolService] Stack: ${stack.toString().split('\n').take(5).join('\n')}');
      _cachedTools = List<Tool>.from(ToolsData.all)
        ..removeWhere(_isGloballyBlockedTool);
      // Schedule background retry after 10s
      _scheduleBackgroundRetry();
    }

    _isLoading = false;
    return _cachedTools!;
  }

  /// Background retry: if initial load failed, keep trying every 15s up to 3 more times
  static int _bgRetryCount = 0;
  static void _scheduleBackgroundRetry() {
    if (_bgRetryCount >= 3) {
      debugPrint('[ToolService] Background retries exhausted');
      return;
    }
    _bgRetryCount++;
    final delaySec = 10 + (_bgRetryCount * 5); // 15s, 20s, 25s
    debugPrint('[ToolService] 🔄 Background retry #$_bgRetryCount scheduled in ${delaySec}s');
    Future.delayed(Duration(seconds: delaySec), () async {
      if (_cachedTools != null && _cachedTools!.length > 100) {
        debugPrint('[ToolService] Already have ${_cachedTools!.length} tools, skip bg retry');
        return;
      }
      debugPrint('[ToolService] 🔄 Background retry #$_bgRetryCount starting...');
      _cachedTools = null;
      _isLoading = false;
      await loadTools();
      if (_cachedTools != null && _cachedTools!.length > 100) {
        debugPrint('[ToolService] 🔄 Background retry SUCCESS: ${_cachedTools!.length} tools');
      } else {
        _scheduleBackgroundRetry();
      }
    });
  }

  /// Force refresh from Supabase
  static Future<List<Tool>> refreshTools() async {
    _cachedTools = null;
    return loadTools();
  }

  // ── Query helpers (use cached data) ─────────────────────
  
    static List<Tool> getFeaturedTools() => getAllTools()
      .where((t) => t.isFeatured && !_isExcludedTool(t) && _hasClearIcon(t))
      .toList();

  /// Today's newly added tools — limited to top 20 by votes.
  /// Fetches from 'tools' table which has 'added_at' column.
  static List<Tool>? _cachedTodayTools;

  /// Map of tool name → Product Hunt thumbnail URL (from 'tools' table)
  static final Map<String, String> _todayToolThumbnails = {};

  /// Get PH thumbnail URL for a tool by name (used as icon fallback)
  static String? getTodayToolThumbnail(String name) => _todayToolThumbnails[name.toLowerCase()];

  static List<Tool> getTodayTools() {
    // Return cached today tools if already fetched
    if (_cachedTodayTools != null && _cachedTodayTools!.isNotEmpty) {
      debugPrint('[ToolService] getTodayTools → CACHED (${_cachedTodayTools!.length}): ${_cachedTodayTools!.map((t) => t.name).take(3).toList()}');
      return _cachedTodayTools!
          .where((t) => !_isExcludedTool(t) && _hasClearIcon(t))
          .toList();
    }
    debugPrint('[ToolService] getTodayTools → FALLBACK (cached is ${_cachedTodayTools == null ? "null" : "empty"})');

    // Fallback: use cached all tools sorted by name hash
    final all = getAllTools();
    if (all.isEmpty) return [];
    final sorted = List<Tool>.from(all)
      ..removeWhere((t) => _isExcludedTool(t) || !_hasClearIcon(t))
      ..sort((a, b) => b.votes.compareTo(a.votes));
    return sorted.take(20).toList();
  }

  /// Async fetch of today's tools:
  /// Step 1 — get recently added tool names from 'tools' table (has added_at)
  /// Step 2 — fetch full Tool objects from 'ai_tools' by matching names
  static Future<void> fetchTodayTools() async {
    try {
      final sb = Supabase.instance.client;

      // Step 1: get recently synced tool names + thumbnail_url from Product Hunt 'tools' table
      final recentRows = await sb
          .from('tools')
          .select('name, thumbnail_url')
          .order('added_at', ascending: false)
          .limit(30);

      if (recentRows.isEmpty) {
        debugPrint('[ToolService] ⚠️ No recent tools in tools table');
        return;
      }

      // Store PH thumbnail URLs so widget can use them as icon fallback
      _todayToolThumbnails.clear();
      for (final r in recentRows) {
        final name = r['name']?.toString() ?? '';
        final thumb = r['thumbnail_url']?.toString() ?? '';
        if (name.isNotEmpty && thumb.isNotEmpty) {
          _todayToolThumbnails[name.toLowerCase()] = thumb;
        }
      }

      final names = recentRows
          .map((r) => r['name']?.toString() ?? '')
          .where((n) => n.isNotEmpty)
          .toList();

      debugPrint('[ToolService] Recent tool names from PH: $names');

      // Step 2: fetch matching full Tool objects from ai_tools
      final rows = await sb
          .from('ai_tools')
          .select()
          .inFilter('name', names);

      debugPrint('[ToolService] Matched in ai_tools: ${rows.length}');

      if (rows.isNotEmpty) {
        final parsed = <Tool>[];
        for (final row in rows) {
          try {
            parsed.add(Tool.fromJson(row));
          } catch (e) {
            debugPrint('[ToolService] ⚠️ Parse error: $e | name=${row['name']}');
          }
        }
        // For today tools: allow tools with PH thumbnail even if ai_tools icon is empty
        parsed.removeWhere((t) {
          if (_isGloballyBlockedTool(t) || _isExcludedTool(t)) return true;
          // Keep if has clear icon OR has a PH thumbnail we fetched
          final hasPhThumb = _todayToolThumbnails.containsKey(t.name.toLowerCase());
          return !_hasClearIcon(t) && !hasPhThumb;
        });
        parsed.sort((a, b) => b.votes.compareTo(a.votes));
        _cachedTodayTools = parsed.take(20).toList();
        toolsVersion.value++;
        debugPrint('[ToolService] ✅ Today tools: ${_cachedTodayTools!.length} — ${_cachedTodayTools!.map((t) => t.name).take(5).toList()}');
      } else {
        debugPrint('[ToolService] ⚠️ No matching tools found in ai_tools for recent PH names');
      }
    } catch (e) {
      debugPrint('[ToolService] fetchTodayTools error: $e');
    }
  }

  /// Editor's Picks — top tool from each category, rotating daily.
  static List<Tool> getEditorPicks() {
    final all = getAllTools();
    if (all.isEmpty) return [];

    // Use day-of-year as seed so picks change daily
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year)).inDays;

    const pickCategories = [
      'chat', 'code', 'image', 'writing', 'video',
      'design', 'automation', 'research', 'marketing', 'audio',
    ];

    final picks = <Tool>[];
    for (final catId in pickCategories) {
      final catTools = all.where((t) => t.categoryId == catId).toList();
      if (catTools.isEmpty) continue;
      catTools.sort((a, b) => b.votes.compareTo(a.votes));
      // Rotate through top 10 of each category based on day
      final topN = catTools.take(10).toList();
      final idx = dayOfYear % topN.length;
      picks.add(topN[idx]);
    }
    final base = picks.take(5).toList();
    return _fillWithFamousTools(base, 5);
  }

  /// Well-known AI tools that users expect to see in trending
  static const _famousTools = <String>{
    'chatgpt', 'claude', 'gemini', 'midjourney', 'perplexity',
    'copilot', 'github copilot', 'cursor', 'dall-e', 'dall·e',
    'stable diffusion', 'runway', 'elevenlabs', 'jasper', 'notion ai',
    'grammarly', 'canva ai', 'adobe firefly', 'suno', 'pika',
    'v0', 'replit', 'devin', 'windsurf', 'bolt',
    'copy.ai', 'writesonic', 'synthesia', 'heygen', 'descript',
    'otter.ai', 'gamma', 'beautiful.ai', 'pitch', 'murf ai',
    'leonardo ai', 'ideogram', 'luma', 'kling', 'sora',
  };

  static bool _hasClearIcon(Tool tool) {
    final icon = tool.iconUrl.trim().toLowerCase();
    final website = tool.websiteUrl.trim().toLowerCase();
    final hasIcon = icon.isNotEmpty && icon != 'null';
    final hasWebsite = website.isNotEmpty && website != 'null';
    return hasIcon || hasWebsite;
  }

  static List<Tool> _famousToolList() {
    final all = getAllTools();
    return all.where((t) {
      final name = t.name.toLowerCase().trim();
      if (_isExcludedTool(t)) return false;
      return _famousTools.contains(name) && _hasClearIcon(t);
    }).toList()
      ..sort((a, b) => b.votes.compareTo(a.votes));
  }

  static List<Tool> _fillWithFamousTools(List<Tool> base, int limit, {String? categoryId}) {
    final seenNames = <String>{};
    final result = <Tool>[];

    // Keep only tools that have clear icons, are not excluded, and dedupe by name
    for (final tool in base) {
      final nameKey = tool.name.toLowerCase().trim();
      if (_isExcludedTool(tool)) continue;
      if (!_hasClearIcon(tool)) continue;
      if (nameKey.isEmpty || seenNames.contains(nameKey)) continue;
      result.add(tool);
      seenNames.add(nameKey);
    }

    // If we're still short, prioritize famous tools, preferring the same category when provided.
    final famous = _famousToolList();
    for (final tool in famous) {
      if (result.length >= limit) break;
      final nameKey = tool.name.toLowerCase().trim();
      if (nameKey.isEmpty || seenNames.contains(nameKey)) continue;
      if (categoryId != null && tool.categoryId != categoryId) continue;
      result.add(tool);
      seenNames.add(nameKey);
    }

    // If still short, allow famous tools from other categories
    if (result.length < limit) {
      for (final tool in famous) {
        if (result.length >= limit) break;
        final nameKey = tool.name.toLowerCase().trim();
        if (nameKey.isEmpty || seenNames.contains(nameKey)) continue;
        result.add(tool);
        seenNames.add(nameKey);
      }
    }

    // If still short, fill with any remaining tools that have icons.
    if (result.length < limit) {
      final all = getAllTools();
      for (final tool in all) {
        if (result.length >= limit) break;
        final nameKey = tool.name.toLowerCase().trim();
        if (nameKey.isEmpty || seenNames.contains(nameKey)) continue;
        if (_isExcludedTool(tool)) continue;
        if (!_hasClearIcon(tool)) continue;
        result.add(tool);
        seenNames.add(nameKey);
      }
    }

    return result.take(limit).toList();
  }

  /// Trending tools based on votes, featured status, and fame.
  static List<Tool> getTrendingTools() {
    final all = getAllTools();
    if (all.isEmpty) return [];

    final scoredTools = all.map((tool) {
      double score = tool.votes * 1.0;
      if (tool.isFeatured) score += 500;
      if (tool.whyTrending != null && tool.whyTrending!.isNotEmpty) score += 200;
      if (_famousTools.contains(tool.name.toLowerCase().trim())) score += 10000;
      return MapEntry(tool, score);
    }).toList();

    scoredTools.sort((a, b) => b.value.compareTo(a.value));

    // Dedup by name (keep highest scored entry)
    final seen = <String>{};
    final deduped = <Tool>[];
    for (final e in scoredTools) {
      final key = e.key.name.toLowerCase().trim();
      if (seen.add(key)) deduped.add(e.key);
    }

    return _fillWithFamousTools(deduped, 20);
  }

  /// Get tools by category - limited to 50 tools, sorted by votes.
  static List<Tool> getToolsByCategory(String categoryId, {int limit = 50}) {
    final tools = getAllTools().where((t) => t.categoryId == categoryId).toList();
    tools.sort((a, b) => b.votes.compareTo(a.votes));
    return _fillWithFamousTools(tools, limit, categoryId: categoryId);
  }

  /// Get ALL tools for a category from the currently loaded set.
  static List<Tool> getAllToolsByCategory(String categoryId) {
    final tools = getAllTools().where((t) => t.categoryId == categoryId).toList();
    tools.sort((a, b) => b.votes.compareTo(a.votes));
    return tools;
  }

  /// Paginated fetch for a category from the local cache.
  static List<Tool> getToolsByCategoryPaginated(
    String categoryId, {
    int offset = 0,
    int limit = 20,
  }) {
    final all = getAllToolsByCategory(categoryId);
    if (offset >= all.length) return [];
    final end = (offset + limit).clamp(0, all.length);
    return all.sublist(offset, end);
  }

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

  static int get totalCount => getAllTools().length;
  static int getToolCountForCategory(String categoryId) =>
      getAllTools().where((t) => t.categoryId == categoryId).length;
  static int getFreeToolCountForCategory(String categoryId) =>
      getAllTools().where((t) => t.categoryId == categoryId && t.hasFreeTier).length;

  /// Debug: Analyze icon URL coverage across all tools
  static void _debugIconStats(List<Tool> tools) {
    int hasIconUrl = 0;
    int hasClearbitIcon = 0;
    int hasWebsiteUrl = 0;
    int hasThumbnailUrl = 0;
    int canResolveDomain = 0;
    int noIconAtAll = 0;
    final List<String> noIconNames = [];

    for (final t in tools) {
      if (t.iconUrl.isNotEmpty) hasIconUrl++;
      if (t.iconUrl.contains('logo.clearbit.com')) hasClearbitIcon++;
      if (t.websiteUrl.isNotEmpty) hasWebsiteUrl++;
      if (t.thumbnailUrl.isNotEmpty) hasThumbnailUrl++;

      // Simulate _resolveIconUrl logic
      String? resolvedUrl;

      // 1. thumbnailUrl
      if (t.thumbnailUrl.isNotEmpty &&
          t.thumbnailUrl.startsWith('http') &&
          !t.thumbnailUrl.contains('logo.clearbit.com')) {
        resolvedUrl = t.thumbnailUrl;
      }
      // 2. iconUrl (non-Clearbit)
      if (resolvedUrl == null &&
          t.iconUrl.isNotEmpty &&
          t.iconUrl.startsWith('http') &&
          !t.iconUrl.contains('logo.clearbit.com')) {
        resolvedUrl = t.iconUrl;
      }
      // 3. Domain extraction
      if (resolvedUrl == null) {
        String? domain;
        if (t.iconUrl.contains('logo.clearbit.com')) {
          try {
            final uri = Uri.parse(t.iconUrl);
            if (uri.pathSegments.isNotEmpty) {
              domain = uri.pathSegments.last.split('?').first;
              if (domain.startsWith('www.')) domain = domain.replaceFirst('www.', '');
            }
          } catch (_) {}
        }
        if ((domain == null || domain.isEmpty) && t.websiteUrl.isNotEmpty) {
          try {
            domain = Uri.parse(t.websiteUrl).host;
            if (domain.startsWith('www.')) domain = domain.replaceFirst('www.', '');
          } catch (_) {}
        }
        if (domain != null && domain.isNotEmpty) {
          resolvedUrl = 'gstatic:$domain';
          canResolveDomain++;
        }
      }

      if (resolvedUrl == null) {
        noIconAtAll++;
        if (noIconNames.length < 20) {
          noIconNames.add('${t.name} | icon=${t.iconUrl} | web=${t.websiteUrl} | thumb=${t.thumbnailUrl}');
        }
      }
    }

    debugPrint('═══ ICON DIAGNOSTICS ═══');
    debugPrint('Total tools: ${tools.length}');
    debugPrint('Has iconUrl: $hasIconUrl');
    debugPrint('  ↳ Clearbit URLs: $hasClearbitIcon');
    debugPrint('Has websiteUrl: $hasWebsiteUrl');
    debugPrint('Has thumbnailUrl: $hasThumbnailUrl');
    debugPrint('Can resolve domain (gstatic): $canResolveDomain');
    debugPrint('NO icon at all (placeholder): $noIconAtAll');
    if (noIconNames.isNotEmpty) {
      debugPrint('── First ${noIconNames.length} tools with NO icon: ──');
      for (final n in noIconNames) {
        debugPrint('  • $n');
      }
    }
    debugPrint('═══ END ICON DIAGNOSTICS ═══');
  }
}

