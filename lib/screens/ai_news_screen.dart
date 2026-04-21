// ══════════════════════════════════════════════════════════════
// SYNAP — AI News Screen
// Live AI news feed from verified sources (last 24 hours)
// ══════════════════════════════════════════════════════════════

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news_model.dart';
import '../services/news_service.dart';

class AiNewsScreen extends StatefulWidget {
  const AiNewsScreen({super.key});

  @override
  State<AiNewsScreen> createState() => _AiNewsScreenState();
}

class _AiNewsScreenState extends State<AiNewsScreen> with TickerProviderStateMixin {
  bool _isLoading = true;
  String _selectedFilter = 'all';
  late AnimationController _pulseController;
  Timer? _refreshTimer;

  static const Color _bg = Color(0xFF12080D);
  static const Color _bgElevated = Color(0xFF1A0B0F);
  static const Color _card = Color(0xFF17111B);
  static const Color _chip = Color(0xFF1D1420);
  static const Color _chipBorder = Color(0xFF2A1C2E);
  static const Color _textMuted = Color(0xFF8B90A8);
  static const Color _textSoft = Color(0xFF9AA0B5);
  static const Color _accent = Color(0xFF6E5BFF);

  final List<String> _filters = ['all', 'breaking', 'launch', 'funding', 'research', 'opensource', 'update'];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _loadNews();
    NewsService.markAllRead();

    // Periodically refresh news while screen is open (every 5 minutes)
    _refreshTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      _loadNews();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadNews() async {
    setState(() => _isLoading = true);
    await NewsService.fetchNews(force: true);
    if (mounted) setState(() => _isLoading = false);
  }

  List<NewsModel> get _filteredNews {
    final news = NewsService.getNews();
    if (_selectedFilter == 'all') return news;
    return news.where((n) => n.category == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF2A0A10),
                  Color(0xFF16090E),
                  Color(0xFF0C0D15),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.2,
                    colors: [
                      Color(0x3DFF3B3B),
                      Color(0x1AFF3B3B),
                      Color(0x00000000),
                    ],
                    stops: [0.0, 0.35, 1.0],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                _buildFilterChips(),
                Expanded(
                  child: _isLoading
                      ? _buildLoadingState()
                      : _filteredNews.isEmpty
                          ? _buildEmptyState()
                          : _buildNewsList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _bg,
            _bgElevated,
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _chip,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.arrow_back_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI News',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Live updates from verified AI sources',
                  style: TextStyle(
                    color: _textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _loadNews,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _chip,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.refresh_rounded,
                color: _accent,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Filter Chips ──────────────────────────────────────
  Widget _buildFilterChips() {
    final labels = {
      'all': 'All',
      'breaking': 'Breaking',
      'launch': 'Launches',
      'funding': 'Funding',
      'research': 'Research',
      'opensource': 'Open Source',
      'update': 'Updates',
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SizedBox(
        height: 44,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          itemBuilder: (context, index) {
            final filter = _filters[index];
            final isSelected = filter == _selectedFilter;

            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () => setState(() => _selectedFilter = filter),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _accent
                        : _chip,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected
                          ? _accent
                          : _chipBorder,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      if (filter == 'all') ...[
                        Icon(Icons.public, size: 14, color: isSelected ? Colors.white : _textSoft),
                        const SizedBox(width: 6),
                      ] else if (filter == 'breaking') ...[
                        Icon(Icons.bolt, size: 14, color: isSelected ? Colors.white : _textSoft),
                        const SizedBox(width: 6),
                      ] else if (filter == 'launch') ...[
                        Icon(Icons.rocket_launch, size: 14, color: isSelected ? Colors.white : _textSoft),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        labels[filter] ?? filter,
                        style: TextStyle(
                          color: isSelected ? Colors.white : _textSoft,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── News List ─────────────────────────────────────────
  Widget _buildNewsList() {
    final news = _filteredNews;

    return RefreshIndicator(
      onRefresh: _loadNews,
      color: _accent,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        itemCount: news.length,
        itemBuilder: (context, index) {
          final article = news[index];

          // First item gets the full “card with hero image” treatment.
          if (index == 0) {
            return _buildHeroNewsCard(article);
          }

          return _buildNewsCard(article);
        },
      ),
    );
  }

  // ── Hero Card (first article) ─────────────────────────
  Widget _buildHeroNewsCard(NewsModel article) {
    return GestureDetector(
      onTap: () => _openArticle(article),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: _card,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero image with overlay ──
            if (article.imageUrl != null)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: CachedNetworkImage(
                      imageUrl: article.imageUrl!,
                      height: 190,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        height: 190,
                        color: _chip,
                        child: Center(
                          child: Icon(Icons.image, color: _textMuted, size: 40),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        height: 190,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _accent.withOpacity(0.25),
                              _accent.withOpacity(0.12),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(Icons.image_not_supported, color: _textMuted, size: 40),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.0),
                            Colors.black.withOpacity(0.65),
                          ],
                        ),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildCategoryBadge(article),
                            const SizedBox(width: 8),
                            if (article.isVerified)
                              Icon(Icons.verified_rounded, color: _accent, size: 14),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          article.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            height: 1.25,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            // ── Below-image meta row ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Row(
                children: [
                  Text(
                    article.sourceName,
                    style: TextStyle(
                      color: _textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    article.timeAgo,
                    style: TextStyle(
                      color: _textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Regular News Card ─────────────────────────────────
  Widget _buildNewsCard(NewsModel article) {
    return GestureDetector(
      onTap: () => _openArticle(article),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _chipBorder,
            width: 0.8,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: category & time
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
              child: Row(
                children: [
                  _buildCategoryBadge(article),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      article.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  if (article.isVerified) ...[
                    Icon(Icons.verified_rounded, color: _accent, size: 12),
                    const SizedBox(width: 6),
                  ],
                  Expanded(
                    child: Text(
                      article.sourceName,
                      style: TextStyle(
                        color: _textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    article.timeAgo,
                    style: TextStyle(
                      color: _textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Optional thumbnail with overlay
            if (article.imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
                child: CachedNetworkImage(
                  imageUrl: article.imageUrl!,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    height: 140,
                    color: _chip,
                    child: Center(
                      child: Icon(Icons.image, color: _textMuted, size: 36),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _accent.withOpacity(0.16),
                          _accent.withOpacity(0.08),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(Icons.broken_image_rounded, color: _textMuted, size: 36),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Category Badge ────────────────────────────────────
  Widget _buildCategoryBadge(NewsModel article) {
    Color badgeColor;
    switch (article.category) {
      case 'breaking':
        badgeColor = const Color(0xFFFF5C5C);
        break;
      case 'launch':
        badgeColor = const Color(0xFF3DDC84);
        break;
      case 'funding':
        badgeColor = const Color(0xFFFFB547);
        break;
      case 'research':
        badgeColor = const Color(0xFF7C5CFF);
        break;
      case 'opensource':
        badgeColor = const Color(0xFF34D399);
        break;
      default:
        badgeColor = _accent;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '${article.categoryEmoji} ${article.categoryLabel}',
        style: TextStyle(
          color: badgeColor,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  // ── Loading State ─────────────────────────────────────
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: _accent,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Fetching latest AI news...',
            style: TextStyle(
              color: _textMuted,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'TechCrunch • The Verge • VentureBeat',
            style: TextStyle(
              color: _textMuted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty State ───────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📰', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            'No news in the last 24 hours',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pull down to refresh',
            style: TextStyle(
              color: _textMuted,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _loadNews,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: _accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Refresh',
                style: TextStyle(
                  color: _accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Open Article ──────────────────────────────────────
  Future<void> _openArticle(NewsModel article) async {
    try {
      final uri = Uri.parse(article.sourceUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('[AiNewsScreen] Open URL error: $e');
    }
  }
}
