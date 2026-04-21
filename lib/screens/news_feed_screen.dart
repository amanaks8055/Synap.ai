import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../services/news_service.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  int _selectedTab = 0;
  int _selectedNav = 0;
  bool _isLoading = true;
  List<NewsModel> _news = [];

  final List<String> _tabs = ['Latest', 'Business', 'Sports', 'Politics'];

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    setState(() => _isLoading = true);
    await NewsService.fetchNews(force: true);
    if (!mounted) return;
    setState(() {
      _news = NewsService.getNews();
      _isLoading = false;
    });
  }

  List<NewsModel> get _visibleNews {
    if (_selectedTab == 0) return _news;

    final tab = _tabs[_selectedTab].toLowerCase();
    return _news.where((n) {
      final text = '${n.title} ${n.summary} ${n.sourceName}'.toLowerCase();
      if (tab == 'business') {
        return text.contains('funding') ||
            text.contains('investment') ||
            text.contains('raises') ||
            text.contains('acquire') ||
            text.contains('acquisition') ||
            text.contains('valuation') ||
            text.contains('market');
      }
      if (tab == 'sports') {
        return text.contains('sport') ||
            text.contains('league') ||
            text.contains('tournament') ||
            text.contains('match') ||
            text.contains('football');
      }
      if (tab == 'politics') {
        return text.contains('policy') ||
            text.contains('government') ||
            text.contains('regulation') ||
            text.contains('law') ||
            text.contains('senate') ||
            text.contains('congress') ||
            text.contains('election') ||
            text.contains('eu');
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0B1226),
              Color(0xFF090F1C),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _isLoading
                    ? _buildLoading()
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeroCard(),
                            _buildTabs(),
                            _buildNewsList(),
                          ],
                        ),
                      ),
              ),
              _buildBottomNav(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'N',
                  style: TextStyle(
                    color: Color(0xFFE53935),
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    letterSpacing: -0.3,
                  ),
                ),
                TextSpan(
                  text: 'EWZIA',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFF151D30),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications_outlined,
                    color: Color(0xFFAABBCC), size: 18),
              ),
              Positioned(
                top: 6,
                right: 7,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF0C1120), width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    final article = _visibleNews.isNotEmpty ? _visibleNews.first : null;
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/publisher-profile'),
      child: Container(
        margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E3A5F), Color(0xFF2C5282)],
          ),
        ),
        child: Stack(
          children: [
            if (article?.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: CachedNetworkImage(
                  imageUrl: article!.imageUrl!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: const Color(0xFF1E3A5F)),
                  errorWidget: (_, __, ___) => Container(color: const Color(0xFF1E3A5F)),
                ),
              ),
            // Overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xDD000000)],
                  stops: [0.3, 1.0],
                ),
              ),
            ),
            // Bookmark
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.bookmark_border,
                    color: Colors.white, size: 16),
              ),
            ),
            // Content
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article != null
                          ? '${article.categoryLabel.toUpperCase()} · ${article.timeAgo}'
                          : 'LATEST · 5 MIN READ',
                      style: const TextStyle(
                        color: Color(0xFFAAAAAA),
                        fontSize: 9,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      article?.title ?? 'The UNESCO World Heritage Site with sky-high house prices',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE53935),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Center(
                            child: Text(
                              'BBC',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          article?.sourceName.toUpperCase() ?? 'BBC NEWS',
                          style: const TextStyle(
                            color: Color(0xFFAAAAAA),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          article?.timeAgo ?? '3 hours ago',
                          style: const TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_tabs.length, (i) {
            final isActive = _selectedTab == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedTab = i),
              child: Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFFE53935)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _tabs[i],
                  style: TextStyle(
                    color: isActive
                        ? Colors.white
                        : const Color(0xFF556677),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildNewsList() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      child: Column(
        children: _visibleNews
            .skip(_visibleNews.isNotEmpty ? 1 : 0)
            .map((item) => _buildNewsCard(item))
            .toList(),
      ),
    );
  }

  Widget _buildNewsCard(NewsModel item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF131B2E), width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: item.imageUrl == null
                ? Container(
                    width: 68,
                    height: 58,
                    color: const Color(0xFF1A2A3A),
                  )
                : CachedNetworkImage(
                    imageUrl: item.imageUrl!,
                    width: 68,
                    height: 58,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: 68,
                      height: 58,
                      color: const Color(0xFF1A2A3A),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      width: 68,
                      height: 58,
                      color: const Color(0xFF1A2A3A),
                    ),
                  ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.categoryLabel.toUpperCase()} · ${item.timeAgo}',
                  style: const TextStyle(
                    color: Color(0xFFAAAAAA),
                    fontSize: 8,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.title,
                  style: const TextStyle(
                    color: Color(0xFFDDEEFF),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E4D3A),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          item.sourceName.isNotEmpty
                              ? item.sourceName[0].toUpperCase()
                              : 'N',
                          style: const TextStyle(
                            color: Color(0xFF4ECB8C),
                            fontSize: 7,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      item.sourceName,
                      style: const TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 9,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      item.timeAgo,
                      style: const TextStyle(
                        color: Color(0xFF444444),
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Color(0xFFE53935),
      ),
    );
  }

  Widget _buildBottomNav() {
    final icons = [
      Icons.home_outlined,
      Icons.search,
      Icons.bookmark_border,
      Icons.person_outline,
    ];
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 8),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF131B2E))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(icons.length, (i) {
          final isActive = _selectedNav == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedNav = i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icons[i],
                  color: isActive
                      ? const Color(0xFFE53935)
                      : const Color(0xFF444444),
                  size: 22,
                ),
                if (isActive)
                  Container(
                    margin: const EdgeInsets.only(top: 3),
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE53935),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
