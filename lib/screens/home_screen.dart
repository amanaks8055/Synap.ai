import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/mic_fab.dart';
import '../widgets/startup_kit_home_card.dart';

import '../blocs/premium/premium_bloc.dart';
import '../data/mock_data.dart';
import '../models/tool_model.dart';
import '../services/tool_service.dart';
import '../theme/app_theme.dart';
import '../widgets/tool_icon.dart';
import 'category_tools_screen.dart';
import '../widgets/moving_border_button.dart';
import '../services/recommendation_service.dart';
import '../widgets/tool_card_widget.dart';
// tool_detail_sheet.dart import removed — all taps now go to ToolDetailScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildSection('🔥 Trending', ToolService.getTrendingTools()),
          // Removed StartupKitHomeCard (placed in bottom navigation instead)
          const SizedBox(height: 12),
          ...MockData.categories.map((cat) {
            final tools = ToolService.getToolsByCategory(cat.id);
            if (tools.isEmpty) return const SizedBox.shrink();
            return _buildSection(cat.name, tools, categoryId: cat.id);
          }),
          const SizedBox(height: 100), // Bottom padding for nav bar
        ],
      ),
    );
  }

  // ─── HEADER: icon + Synap + premium badge ───────
  Widget _buildHeader() {
    final isPremium = context.read<PremiumBloc>().state.isPremium;
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
          const Spacer(),
          if (!isPremium)
            SynapMovingBorderButton(
              onTap: () => Navigator.pushNamed(context, '/premium'),
              borderRadius: 8,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              backgroundColor: SynapColors.accent.withOpacity(0.15),
              glowColor: SynapColors.accent,
              duration: const Duration(seconds: 4),
              child: const Text('PRO', style: TextStyle(color: SynapColors.accent, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
            ),
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
  Widget _buildSection(String title, List<Tool> tools, {String? categoryId}) {
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
  final Tool tool;
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
            ToolIcon(name: tool.name, categoryId: tool.categoryId, iconUrl: tool.iconUrl, size: 44, fontSize: 18, radius: 12),
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
