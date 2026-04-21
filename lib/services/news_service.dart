// ══════════════════════════════════════════════════════════════
// SYNAP — NewsService
// Fetches AI news from FREE RSS feeds (TechCrunch, Verge, etc.)
// Auto-filters last 24 hours only, caches locally
// ══════════════════════════════════════════════════════════════

import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/news_model.dart';

class NewsService {
  static List<NewsModel>? _cachedNews;
  static bool _isLoading = false;
  static DateTime? _lastFetch;
  static final Map<String, int> _sourceFailureCounts = <String, int>{};
  static final Map<String, DateTime> _sourceBlockedUntil = <String, DateTime>{};

  /// Notifier for UI rebuild when news changes
  static final ValueNotifier<int> newsVersion = ValueNotifier<int>(0);

  /// Notifier for unread count (red dot on icon)
  static final ValueNotifier<int> unreadCount = ValueNotifier<int>(0);

  static const int _failuresBeforeBackoff =
      1; // Immediate backoff for any failure
  static const Duration _sourceBackoff = Duration(hours: 6); // Longer backoff
  static const Duration _forbiddenBackoff = Duration(hours: 24);

  // ── FREE RSS Feed Sources (Verified AI News) ──────────
  static const List<_RssSource> _sources = [
    _RssSource(
      url: 'https://techcrunch.com/category/artificial-intelligence/feed/',
      name: 'TechCrunch',
      isVerified: true,
    ),
    _RssSource(
      url: 'https://www.theverge.com/rss/ai-artificial-intelligence/index.xml',
      name: 'The Verge',
      isVerified: true,
    ),
    _RssSource(
      url: 'https://venturebeat.com/category/ai/feed/',
      name: 'VentureBeat',
      isVerified: true,
    ),
    _RssSource(
      url: 'https://blog.google/technology/ai/rss/',
      name: 'Google AI',
      isVerified: true,
    ),
    _RssSource(
      url: 'https://www.wired.com/feed/tag/ai/latest/rss',
      name: 'WIRED',
      isVerified: true,
    ),
    _RssSource(
      url: 'https://feeds.arstechnica.com/arstechnica/features',
      name: 'Ars Technica',
      isVerified: true,
    ),
    // Additional reliable AI/Tech news sources
    // _RssSource( // REMOVED: Consistently returns 403 Forbidden
    //   url: 'https://www.fastcompany.com/technology/feed',
    //   name: 'Fast Company',
    //   isVerified: true,
    // ),
    // _RssSource( // REMOVED: DNS lookup consistently fails
    //   url: 'https://feeds2.bloomberg.com/technology/news.rss',
    //   name: 'Bloomberg Tech',
    //   isVerified: true,
    // ),
    _RssSource(
      url: 'https://www.cnbc.com/id/100003114/device/rss/rss.html',
      name: 'CNBC Tech',
      isVerified: true,
    ),
    // Alternative reliable sources
    _RssSource(
      url: 'https://feeds.feedburner.com/TechCrunch/',
      name: 'TechCrunch (Alt)',
      isVerified: true,
    ),
    _RssSource(
      url: 'https://www.wired.com/feed/rss',
      name: 'WIRED (Alt)',
      isVerified: true,
    ),
    // _RssSource( // REMOVED: DNS lookup consistently fails
    //   url: 'https://feeds.reuters.com/reuters/technologyNews',
    //   name: 'Reuters Tech',
    //   isVerified: true,
    // ),
  ];

  /// Get cached news sorted by image presence first, then by date
  static List<NewsModel> getNews() {
    if (_cachedNews == null) return [];

    // Filter to last 3 days
    final cutoff3d = DateTime.now().subtract(const Duration(days: 3));
    final filtered =
        _cachedNews!.where((n) => n.publishedAt.isAfter(cutoff3d)).toList();

    // Sort: Articles WITH images first, then by date (newest first)
    filtered.sort((a, b) {
      // Priority 1: Has image vs no image
      final aHasImage = a.imageUrl != null && a.imageUrl!.isNotEmpty;
      final bHasImage = b.imageUrl != null && b.imageUrl!.isNotEmpty;

      if (aHasImage && !bHasImage) return -1; // a comes first (has image)
      if (!aHasImage && bHasImage) return 1; // b comes first (has image)

      // Priority 2: If both have/don't have images, sort by date (newest first)
      return b.publishedAt.compareTo(a.publishedAt);
    });

    return filtered;
  }

  /// Get the top-ranked news (most important/relevant) limited to [limit].
  ///
  /// This is used for compact views (home preview / notifications) so users
  /// only see the most useful headlines.
  static List<NewsModel> getTopNews({int limit = 3}) {
    final news = getNews();
    if (news.isEmpty) return [];

    final scored = news.map((n) => MapEntry(n, _scoreNews(n))).toList()
      ..sort((a, b) {
        // Primary: higher score
        final cmp = b.value.compareTo(a.value);
        if (cmp != 0) return cmp;
        // Secondary: newest first
        return b.key.publishedAt.compareTo(a.key.publishedAt);
      });

    return scored.take(limit).map((e) => e.key).toList();
  }

  /// Check if we have any news
  static bool get hasNews => getNews().isNotEmpty;

  static int _scoreNews(NewsModel news) {
    var score = 0;

    // 🎯 HIGHEST PRIORITY: Articles with images go to top
    if (news.imageUrl != null && news.imageUrl!.isNotEmpty) {
      score += 100; // Massive boost for image presence
    }

    // Breaking / launches are highest priority
    if (news.category == 'breaking' || news.category == 'launch') score += 60;

    // Verified sources get a boost
    if (news.isVerified) score += 20;

    // Keywords that often signal important updates
    final titleLower = news.title.toLowerCase();
    const keywordScores = {
      'openai': 15,
      'chatgpt': 15,
      'gpt': 12,
      'bard': 12,
      'microsoft': 10,
      'google': 10,
      'anthropic': 10,
      'ai': 8,
      'open source': 8,
      'milestone': 8,
      'acquire': 8,
      'acquisition': 8,
      'funding': 7,
      'launch': 7,
      'partnership': 6,
    };

    for (final entry in keywordScores.entries) {
      if (titleLower.contains(entry.key)) score += entry.value;
    }

    return score;
  }

  /// Fetch news from all RSS sources
  /// Caches result, won't re-fetch within 5 minutes (so feed can keep refreshing)
  static Future<List<NewsModel>> fetchNews({bool force = false}) async {
    // Don't re-fetch within 5 minutes unless forced
    if (!force &&
        _cachedNews != null &&
        _lastFetch != null &&
        DateTime.now().difference(_lastFetch!).inMinutes < 5) {
      return getNews();
    }

    if (_isLoading) {
      // Wait for current fetch to complete
      while (_isLoading) {
        await Future.delayed(const Duration(milliseconds: 200));
      }
      return getNews();
    }

    _isLoading = true;

    try {
      // Fast preflight: if DNS/network is unavailable, skip source fan-out and use cache.
      final hasNetwork = await _hasNetwork();
      if (!hasNetwork) {
        debugPrint(
            '[NewsService] ⚠️ Network/DNS unavailable, using cached news');
        await _loadFromCache();
        _isLoading = false;
        return getNews();
      }

      final allNews = <NewsModel>[];

      final activeSources = _sources
          .where((source) => !_isSourceBlocked(source))
          .toList(growable: false);

      debugPrint(
          '[NewsService] Active sources: ${activeSources.map((s) => s.name).join(', ')}');
      debugPrint(
          '[NewsService] Blocked sources: ${_sources.where((s) => _isSourceBlocked(s)).map((s) => s.name).join(', ')}');

      if (activeSources.isEmpty) {
        debugPrint(
            '[NewsService] ⚠️ All feeds are temporarily blocked, using cache');
        await _loadFromCache();
        _isLoading = false;
        return getNews();
      }

      // Fetch from active sources in parallel
      final futures = activeSources.map((source) => _fetchFromSource(source));
      final results = await Future.wait(futures);

      for (final articles in results) {
        allNews.addAll(articles);
      }

      // Sort by published date (newest first)
      allNews.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

      debugPrint(
          '[NewsService] Total articles from all sources: ${allNews.length}');

      // Initial filter: grab last 3 days
      final cutoff3d = DateTime.now().subtract(const Duration(days: 3));
      final freshNews =
          allNews.where((n) => n.publishedAt.isAfter(cutoff3d)).toList();

      debugPrint(
          '[NewsService] After 3-day filter: ${freshNews.length} articles');

      // Deduplicate by title similarity
      final deduped = _deduplicateNews(freshNews);

      _cachedNews = deduped;
      _lastFetch = DateTime.now();

      // Calculate unread count
      await _updateUnreadCount(deduped);

      // Cache to SharedPreferences for offline
      await _cacheLocally(deduped);

      newsVersion.value++;
      debugPrint(
          '[NewsService] ✅ Fetched ${deduped.length} news articles (3-day window)');

      _isLoading = false;
      return deduped;
    } catch (e) {
      debugPrint('[NewsService] ❌ Fetch error: $e');
      // Try loading from local cache
      await _loadFromCache();
      _isLoading = false;
      return getNews();
    }
  }

  /// Fetch articles from a single RSS source
  static Future<List<NewsModel>> _fetchFromSource(_RssSource source) async {
    try {
      debugPrint('[📥 START] Fetching ${source.name} from ${source.url}');

      final response = await http.get(
        Uri.parse(source.url),
        headers: {'User-Agent': 'Synap-AI-App/1.0'},
      ).timeout(const Duration(
          seconds: 5)); // Reduced from 10s to 5s for faster offline failure

      debugPrint(
          '[📡 HTTP] ${source.name}: Status ${response.statusCode} | Body size: ${response.body.length} bytes');

      if (response.statusCode != 200) {
        debugPrint(
            '[❌ ERROR] ${source.name}: HTTP ${response.statusCode} - FAILED');
        _recordSourceFailure(source, statusCode: response.statusCode);
        return [];
      }

      if (response.body.isEmpty) {
        debugPrint('[⚠️ EMPTY] ${source.name}: Response body is empty!');
        _recordSourceFailure(source);
        return [];
      }

      final articles = _parseRss(response.body, source);
      debugPrint(
          '[✅ SUCCESS] ${source.name}: Fetched ${articles.length} articles');
      _recordSourceSuccess(source);

      return articles;
    } on SocketException catch (e) {
      // Avoid noisy stack traces for expected offline DNS failures.
      debugPrint('[❌ DNS] ${source.name}: ${e.message}');
      _recordSourceFailure(source);
      return [];
    } on TimeoutException {
      debugPrint('[⏱️ TIMEOUT] ${source.name}: request timed out');
      _recordSourceFailure(source);
      return [];
    } catch (e) {
      debugPrint('[❌ EXCEPTION] ${source.name}: $e');
      _recordSourceFailure(source);
      return [];
    }
  }

  static bool _isSourceBlocked(_RssSource source) {
    final until = _sourceBlockedUntil[source.url];
    if (until == null) return false;

    if (DateTime.now().isAfter(until)) {
      _sourceBlockedUntil.remove(source.url);
      _sourceFailureCounts.remove(source.url);
      return false;
    }

    return true;
  }

  static void _recordSourceSuccess(_RssSource source) {
    _sourceFailureCounts.remove(source.url);
    _sourceBlockedUntil.remove(source.url);
    _saveBackoffState(); // Persist the cleared state
  }

  static void _recordSourceFailure(_RssSource source, {int? statusCode}) {
    final next = (_sourceFailureCounts[source.url] ?? 0) + 1;
    _sourceFailureCounts[source.url] = next;

    final bool hardBlock = statusCode == 403;
    final bool dnsFailure =
        statusCode == null; // DNS failures don't have status codes

    if (hardBlock || dnsFailure || next >= _failuresBeforeBackoff) {
      final duration = hardBlock ? _forbiddenBackoff : _sourceBackoff;
      _sourceBlockedUntil[source.url] = DateTime.now().add(duration);
      debugPrint(
        '[NewsService] 💤 Backing off ${source.name} for ${duration.inHours}h (${hardBlock ? '403 forbidden' : dnsFailure ? 'DNS failure' : 'repeated failures'})',
      );
      _saveBackoffState(); // Persist the backoff state
    }
  }

  static Future<bool> _hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('one.one.one.one')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Parse RSS XML into NewsModel list
  static List<NewsModel> _parseRss(String xml, _RssSource source) {
    final articles = <NewsModel>[];

    try {
      // Extract <item> or <entry> blocks
      final itemPattern = RegExp(
        r'<item[\s>](.*?)</item>|<entry[\s>](.*?)</entry>',
        dotAll: true,
      );

      final matches = itemPattern.allMatches(xml).toList();
      debugPrint(
          '[🔍 PARSE] ${source.name}: Found ${matches.length} items in RSS feed');

      if (matches.isEmpty) {
        debugPrint(
            '[⚠️ WARNING] ${source.name}: No items found in RSS! Xml length: ${xml.length}');
        debugPrint(
            '[DEBUG-XML] First 500 chars: ${xml.substring(0, (500).clamp(0, xml.length))}');
        return [];
      }

      for (final match in matches) {
        try {
          final content = match.group(1) ?? match.group(2) ?? '';

          final title = _extractTag(content, 'title') ?? '';
          if (title.isEmpty) continue;

          final link = _extractLink(content);
          final description = _extractDescription(content);
          final pubDate = _extractTag(content, 'pubDate') ??
              _extractTag(content, 'published') ??
              _extractTag(content, 'updated') ??
              '';
          final imageUrl = _extractImageUrl(content);

          // Use parsed date or fallback to now (so article still shows)
          final publishedAt = _parseDate(pubDate) ?? DateTime.now();

          // Determine category based on keywords
          final category = _categorize(title, description);
          final cleanDesc = _cleanHtml(description);
          final safeSummary = cleanDesc.length > 200
              ? '${cleanDesc.substring(0, 200)}...'
              : cleanDesc;

          articles.add(NewsModel(
            id: '${source.name}_${title.hashCode}',
            title: _cleanHtml(title),
            summary: safeSummary,
            imageUrl: imageUrl,
            sourceUrl: link,
            sourceName: source.name,
            category: category,
            publishedAt: publishedAt,
            isVerified: source.isVerified,
            isBreaking: category == 'breaking',
          ));
        } catch (e) {
          debugPrint('[NewsService] ${source.name} item parse error: $e');
          continue;
        }
      }
    } catch (e) {
      debugPrint('[NewsService] RSS parse error for ${source.name}: $e');
    }

    debugPrint(
        '[📦 RESULT] ${source.name}: Successfully parsed ${articles.length} articles');
    return articles;
  }

  // ── XML Helpers ────────────────────────────────────────

  static String? _extractTag(String xml, String tag) {
    // Try CDATA first
    final cdataPattern = RegExp(
      '<$tag[^>]*>\\s*<!\\[CDATA\\[(.*?)\\]\\]>\\s*</$tag>',
      dotAll: true,
    );
    final cdataMatch = cdataPattern.firstMatch(xml);
    if (cdataMatch != null) return cdataMatch.group(1)?.trim();

    // Regular tag
    final pattern = RegExp('<$tag[^>]*>(.*?)</$tag>', dotAll: true);
    final match = pattern.firstMatch(xml);
    return match?.group(1)?.trim();
  }

  static String _extractLink(String content) {
    // Try <link> tag
    final link = _extractTag(content, 'link');
    if (link != null && link.isNotEmpty && link.startsWith('http')) return link;

    // Try <link href="..."/> (Atom format)
    final hrefPattern =
        RegExp(r'''<link[^>]*href=["\']([^"\']+)["\']''', dotAll: true);
    final hrefMatch = hrefPattern.firstMatch(content);
    if (hrefMatch != null) return hrefMatch.group(1) ?? '';

    // Try <guid>
    final guid = _extractTag(content, 'guid');
    if (guid != null && guid.startsWith('http')) return guid;

    return '';
  }

  static String _extractDescription(String content) {
    return _extractTag(content, 'description') ??
        _extractTag(content, 'summary') ??
        _extractTag(content, 'content:encoded') ??
        _extractTag(content, 'content') ??
        '';
  }

  static String? _extractImageUrl(String content) {
    // Try media:content
    final mediaPattern =
        RegExp(r'''<media:content[^>]*url=["\']([^"\']+)["\']''');
    final mediaMatch = mediaPattern.firstMatch(content);
    if (mediaMatch != null) return mediaMatch.group(1);

    // Try media:thumbnail
    final thumbPattern =
        RegExp(r'''<media:thumbnail[^>]*url=["\']([^"\']+)["\']''');
    final thumbMatch = thumbPattern.firstMatch(content);
    if (thumbMatch != null) return thumbMatch.group(1);

    // Try enclosure
    final enclosurePattern =
        RegExp(r'''<enclosure[^>]*url=["\']([^"\']+)["\']''');
    final encMatch = enclosurePattern.firstMatch(content);
    if (encMatch != null) return encMatch.group(1);

    // Try first <img> in content
    final imgPattern = RegExp(r'''<img[^>]*src=["\']([^"\']+)["\']''');
    final imgMatch = imgPattern.firstMatch(content);
    if (imgMatch != null) return imgMatch.group(1);

    // Try srcset (take first candidate)
    final srcsetPattern =
        RegExp(r'''<img[^>]*srcset=["\']([^"\']+)["\']''', dotAll: true);
    final srcsetMatch = srcsetPattern.firstMatch(content);
    if (srcsetMatch != null) {
      final srcset = srcsetMatch.group(1) ?? '';
      final first = srcset.split(',').first.trim();
      final url = first.split(' ').first.trim();
      if (url.isNotEmpty) return url;
    }

    // Try data-src (lazy-loaded images)
    final dataSrcPattern = RegExp(r'''<img[^>]*data-src=["\']([^"\']+)["\']''');
    final dataSrcMatch = dataSrcPattern.firstMatch(content);
    if (dataSrcMatch != null) return dataSrcMatch.group(1);

    return null;
  }

  static DateTime? _parseDate(String dateStr) {
    if (dateStr.isEmpty) return null;

    try {
      return DateTime.parse(dateStr);
    } catch (_) {}

    // Try RFC 822 format (common in RSS)
    try {
      return HttpDate.parse(dateStr);
    } catch (_) {}

    // Manual parse for common RSS date formats
    try {
      // "Thu, 13 Mar 2025 10:30:00 +0000"
      final parts = dateStr.trim().split(' ');
      if (parts.length >= 5) {
        final months = {
          'Jan': '01',
          'Feb': '02',
          'Mar': '03',
          'Apr': '04',
          'May': '05',
          'Jun': '06',
          'Jul': '07',
          'Aug': '08',
          'Sep': '09',
          'Oct': '10',
          'Nov': '11',
          'Dec': '12',
        };
        final day = parts[1].padLeft(2, '0');
        final month = months[parts[2]] ?? '01';
        final year = parts[3];
        final time = parts[4];
        return DateTime.parse('$year-$month-${day}T$time');
      }
    } catch (_) {}

    return null;
  }

  static String _cleanHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]+>'), '')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#039;', "'")
        .replaceAll('&nbsp;', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Categorize news by keyword analysis
  static String _categorize(String title, String description) {
    final text = '$title $description'.toLowerCase();

    if (text.contains('breaking') ||
        text.contains('just announced') ||
        text.contains('urgent') ||
        text.contains('breaking:')) {
      return 'breaking';
    }
    if (text.contains('launch') ||
        text.contains('releases') ||
        text.contains('introduces') ||
        text.contains('debuts') ||
        text.contains('unveils') ||
        text.contains('announces')) {
      return 'launch';
    }
    if (text.contains('research') ||
        text.contains('paper') ||
        text.contains('study') ||
        text.contains('findings')) {
      return 'research';
    }
    if (text.contains('raises') ||
        text.contains('funding') ||
        text.contains('valuation') ||
        text.contains('investment') ||
        text.contains('million') ||
        text.contains('billion')) {
      return 'funding';
    }
    if (text.contains('open source') ||
        text.contains('open-source') ||
        text.contains('github') ||
        text.contains('free')) {
      return 'opensource';
    }
    return 'update';
  }

  /// Remove duplicate articles (same title from different sources)
  static List<NewsModel> _deduplicateNews(List<NewsModel> news) {
    final seen = <String>{};
    final deduped = <NewsModel>[];

    for (final article in news) {
      // Normalize title for comparison
      final normalized =
          article.title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
      final key = normalized.substring(0, normalized.length.clamp(0, 50));

      if (seen.add(key)) {
        deduped.add(article);
      }
    }
    return deduped;
  }

  // ── Unread Tracking ────────────────────────────────────

  static Future<void> _updateUnreadCount(List<NewsModel> news) async {
    final prefs = await SharedPreferences.getInstance();
    final lastSeen = prefs.getString('news_last_seen_time');
    final lastSeenTime = lastSeen != null
        ? DateTime.tryParse(lastSeen) ??
            DateTime.now().subtract(const Duration(hours: 24))
        : DateTime.now().subtract(const Duration(hours: 24));

    final unread =
        news.where((n) => n.publishedAt.isAfter(lastSeenTime)).length;
    unreadCount.value = unread;
  }

  /// Mark all news as read (clears red dot)
  static Future<void> markAllRead() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'news_last_seen_time', DateTime.now().toIso8601String());
    unreadCount.value = 0;
  }

  // ── Local Cache ────────────────────────────────────────

  static Future<void> _cacheLocally(List<NewsModel> news) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = news.map((n) => jsonEncode(n.toJson())).toList();
      await prefs.setStringList('cached_news', jsonList);
      await prefs.setString(
          'news_cache_time', DateTime.now().toIso8601String());
    } catch (e) {
      debugPrint('[NewsService] Cache save error: $e');
    }
  }

  static Future<void> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList('cached_news');
      if (jsonList == null || jsonList.isEmpty) return;

      final news =
          jsonList.map((s) => NewsModel.fromJson(jsonDecode(s))).toList();

      // Still filter to 3 days
      final cutoff = DateTime.now().subtract(const Duration(days: 3));
      _cachedNews = news.where((n) => n.publishedAt.isAfter(cutoff)).toList();
      await _updateUnreadCount(_cachedNews!);

      // Persist the cleaned cache (removes items older than 3 days) so storage doesn't grow indefinitely.
      await _cacheLocally(_cachedNews!);

      newsVersion.value++;
      debugPrint('[NewsService] 📦 Loaded ${_cachedNews!.length} from cache');
    } catch (e) {
      debugPrint('[NewsService] Cache load error: $e');
    }
  }

  // ── Backoff State Persistence ───────────────────────────

  static Future<void> _saveBackoffState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final failureCounts = _sourceFailureCounts.map((k, v) => MapEntry(k, v));
      final blockedUntil =
          _sourceBlockedUntil.map((k, v) => MapEntry(k, v.toIso8601String()));

      await prefs.setString('news_source_failures', jsonEncode(failureCounts));
      await prefs.setString('news_source_blocked', jsonEncode(blockedUntil));
    } catch (e) {
      debugPrint('[NewsService] Backoff save error: $e');
    }
  }

  static Future<void> _loadBackoffState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final failuresJson = prefs.getString('news_source_failures');
      final blockedJson = prefs.getString('news_source_blocked');

      if (failuresJson != null) {
        final failures = jsonDecode(failuresJson) as Map<String, dynamic>;
        _sourceFailureCounts
            .addAll(failures.map((k, v) => MapEntry(k, v as int)));
      }

      if (blockedJson != null) {
        final blocked = jsonDecode(blockedJson) as Map<String, dynamic>;
        _sourceBlockedUntil.addAll(
            blocked.map((k, v) => MapEntry(k, DateTime.parse(v as String))));
      }

      // Clean up expired blocks
      final now = DateTime.now();
      _sourceBlockedUntil.removeWhere((url, until) => now.isAfter(until));
      _sourceFailureCounts
          .removeWhere((url, count) => !_sourceBlockedUntil.containsKey(url));

      debugPrint(
          '[NewsService] Loaded backoff state: ${_sourceBlockedUntil.length} blocked sources');
    } catch (e) {
      debugPrint('[NewsService] Backoff load error: $e');
    }
  }

  /// Initialize — load cache + start background fetch
  static Future<void> init() async {
    await _loadFromCache();
    await _loadBackoffState(); // Load persisted backoff state
    // Start background fetch (don't await — let it run)
    fetchNews();
  }
}

// ── RSS Source Model ──────────────────────────────────────
class _RssSource {
  final String url;
  final String name;
  final bool isVerified;

  const _RssSource({
    required this.url,
    required this.name,
    this.isVerified = false,
  });
}

/// HTTP date parser for RFC 822 dates
class HttpDate {
  static DateTime parse(String date) {
    final months = {
      'jan': 1,
      'feb': 2,
      'mar': 3,
      'apr': 4,
      'may': 5,
      'jun': 6,
      'jul': 7,
      'aug': 8,
      'sep': 9,
      'oct': 10,
      'nov': 11,
      'dec': 12,
    };

    // Remove day name prefix like "Thu, "
    final cleaned = date.replaceFirst(RegExp(r'^[A-Za-z]+,?\s*'), '').trim();
    final parts = cleaned.split(RegExp(r'\s+'));

    if (parts.length < 4) throw FormatException('Invalid date: $date');

    final day = int.parse(parts[0]);
    final month = months[parts[1].toLowerCase().substring(0, 3)] ?? 1;
    final year = int.parse(parts[2]);
    final timeParts = parts[3].split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final second = timeParts.length > 2 ? int.parse(timeParts[2]) : 0;

    return DateTime.utc(year, month, day, hour, minute, second);
  }
}
