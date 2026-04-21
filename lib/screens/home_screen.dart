import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/mic_fab.dart';
import '../widgets/news_icon_button.dart';

import '../data/mock_data.dart';
import '../models/tool_model.dart';
import '../services/news_service.dart';
import '../services/tool_service.dart';
import '../theme/app_theme.dart';
import '../widgets/tool_icon.dart';
import 'category_tools_screen.dart';
import '../widgets/moving_border_button.dart';
import '../services/recommendation_service.dart';
import '../widgets/tool_card_widget.dart';
import '../widgets/today_new_tools_widget.dart';
import '../widgets/hero_tools_carousel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  String _query = '';

  @override
  void initState() {
    super.initState();
    ToolService.toolsVersion.addListener(_onToolsRefreshed);
    WidgetsBinding.instance.addObserver(this);

    // 🚀 Fetch today's new tools from Product Hunt sync
    Future.microtask(() => ToolService.fetchTodayTools());

    // 🚀 Non-blocking news fetch: start in background WITHOUT waiting
    // This prevents the app from freezing when offline (10s timeouts × 10 sources)
    Future.microtask(() {
      // Fetch is async, doesn't block UI
      NewsService.fetchNews(); // Fire & forget
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    ToolService.toolsVersion.removeListener(_onToolsRefreshed);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh today's tools when app comes to foreground
      ToolService.fetchTodayTools();
    }
  }

  void _onToolsRefreshed() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F17), // Soft charcoal background
      body: SafeArea(
        child: _query.isNotEmpty ? _buildSearchResults() : _buildHomeFeed(),
      ),
      floatingActionButton: MicFAB(
        onTap: () => Navigator.pushNamed(context, '/voice'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // ─── HOME FEED ──────────────────────────────────
  Widget _buildHomeFeed() {
    final allTools = ToolService.getAllTools();

    // Show creative loading when tools haven't loaded yet
    if (allTools.isEmpty) {
      return _buildLoadingState();
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildSearchBar(),
          const SizedBox(height: 16),
          const HeroToolsCarousel(),
          const TodayNewToolsWidget(),
          _buildSection('🔥 Trending Now', ToolService.getTrendingTools()),
          // Removed StartupKitHomeCard (placed in bottom navigation instead)
          const SizedBox(height: 12),
          ...MockData.categories.map((cat) {
            final tools = ToolService.getToolsByCategory(cat.id, limit: 10);
            if (tools.isEmpty) return const SizedBox.shrink();
            return _buildSection(cat.name, tools, categoryId: cat.id);
          }),
          const SizedBox(height: 100), // Bottom padding for nav bar
        ],
      ),
    );
  }

  // ─── CREATIVE LOADING STATE ─────────────────────
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated cloud icon
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            builder: (_, val, child) => Opacity(opacity: val, child: child),
            child: Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF7B61FF), Color(0xFF00DCE8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00DCE8).withOpacity(0.25),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: const Color(0xFF7B61FF).withOpacity(0.15),
                    blurRadius: 40,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.cloud_queue_rounded,
                color: Colors.white,
                size: 42,
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Loading spinner
          SizedBox(
            width: 28, height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color(0xFF00DCE8).withOpacity(0.7),
              ),
            ),
          ),
          const SizedBox(height: 22),

          // Main message
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOut,
            builder: (_, val, child) => Opacity(
              opacity: val,
              child: Transform.translate(
                offset: Offset(0, 10 * (1 - val)),
                child: child,
              ),
            ),
            child: Text(
              'Making Personalised\nAI Cloud',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                height: 1.35,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Subtitle
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOut,
            builder: (_, val, child) => Opacity(opacity: val, child: child),
            child: Text(
              'Curating 2000+ AI tools just for you',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── HEADER: icon + Synap + premium badge ───────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: SynapColors.accent.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(color: SynapColors.accent.withOpacity(0.2), blurRadius: 10),
              ],
            ),
            child: SvgPicture.asset('assets/logo.svg'),
          ),
          const SizedBox(width: 10),
          Text('Synap', style: TextStyle(color: SynapStyles.textPrimary(context), fontSize: 24, fontWeight: FontWeight.w800)),
          Text('.AI', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/premium'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: SynapColors.accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: SynapColors.accent.withOpacity(0.4), width: 1),
              ),
              child: const Text(
                'PRO',
                style: TextStyle(
                  color: SynapColors.accent,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          NewsIconButton(onTap: () => Navigator.pushNamed(context, '/news')),
        ],
      ),
    );
  }

  // ─── SEARCH BAR ─────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: SynapMovingBorderButton(
        borderRadius: 22,
        height: 44,
        padding: EdgeInsets.zero,
        backgroundColor: SynapStyles.bgSecondary(context),
        glowColor: SynapColors.accent,
        duration: const Duration(seconds: 4),
        child: TextField(
          onChanged: (v) => setState(() => _query = v),
          style: TextStyle(color: SynapStyles.textPrimary(context), fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Search AI tools...',
            hintStyle: TextStyle(color: SynapStyles.textMuted(context), fontSize: 14),
            prefixIcon: Icon(Icons.search_rounded, color: SynapStyles.textMuted(context), size: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  // ─── SEARCH RESULTS ─────────────────────────────
  Widget _buildSearchResults() {
    final results = ToolService.searchTools(_query);
    return Column(
      children: [
        _buildHeader(),
        _buildSearchBar(),
        Expanded(
          child: results.isEmpty
              ? Center(child: Text('No tools found', style: TextStyle(color: SynapStyles.textMuted(context))))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  itemCount: results.length,
                  separatorBuilder: (_, __) => Divider(color: SynapStyles.divider(context), height: 1),
                  itemBuilder: (_, i) {
                    final t = results[i];
                    return _SearchTile(tool: t, onTap: () {
                      RecommendationService().record(t.id, UserEvent.viewed);
                      Navigator.pushNamed(context, '/toolDetail', arguments: t);
                    });
                  },
                ),
        ),
      ],
    );
  }

  // ─── SECTION (horizontal scroll) ────────────────
  Widget _buildSection(String title, List<ToolModel> tools, {String? categoryId}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(title, style: TextStyle(color: SynapStyles.textPrimary(context), fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.3),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
              if (categoryId != null)
                SynapMovingBorderButton(
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => CategoryToolsScreen(categoryId: categoryId, categoryName: title),
                  )),
                  borderRadius: 20,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  backgroundColor: Colors.white.withOpacity(0.05),
                  glowColor: SynapColors.accent,
                  duration: const Duration(seconds: 3),
                  child: const Text('See all', style: TextStyle(color: SynapColors.accent, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: tools.length,
            itemBuilder: (_, i) => ToolCardWidget(
              name: tools[i].name,
              imageUrl: tools[i].iconUrl,
              badge: tools[i].hasFreeTier ? 'FREE' : 'PAID',
              rating: tools[i].rating,
              onTap: () {
                RecommendationService().record(tools[i].id, UserEvent.viewed);
                Navigator.pushNamed(context, '/toolDetail', arguments: tools[i]);
              },
            ),
          ),
        ),
      ],
    );
  }
}


// ─── SEARCH TILE ──────────────────────────────────
class _SearchTile extends StatelessWidget {
  final ToolModel tool;
  final VoidCallback onTap;
  const _SearchTile({required this.tool, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            ToolIcon(name: tool.name, categoryId: tool.categoryId, iconUrl: tool.iconUrl, iconEmoji: tool.iconEmoji, size: 44, fontSize: 18, radius: 12),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tool.name, style: TextStyle(color: SynapStyles.textPrimary(context), fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(tool.description, style: TextStyle(color: SynapStyles.textSecondary(context), fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
