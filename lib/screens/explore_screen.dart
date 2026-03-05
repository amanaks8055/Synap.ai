// ═══════════════════════════════════════════
//  screens/explore_screen.dart
//
//  Tools list + Inline Native Ad every 5 items
//  Banner Ad at the bottom (fixed)
//  Tap → ToolDetailScreen with proper navigation
// ═══════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/premium/premium_bloc.dart';
import '../data/mock_data.dart';
import '../models/tool_model.dart';
import '../services/tool_service.dart';
import '../services/recommendation_service.dart';
import '../config/ad_config.dart';
import '../theme/app_theme.dart';
import '../widgets/tool_icon.dart';
import '../widgets/ads/ad_banner_widget.dart';
import '../widgets/ads/ad_native_widget.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _selectedChip = 'All';
  String _query = '';
  bool _freeOnly = false;

  List<String> get _chips => ['All', ...MockData.categories.map((c) => c.name)];

  List<Tool> get _filtered {
    final catId = _selectedChip == 'All'
        ? null
        : MockData.categories.firstWhere((c) => c.name == _selectedChip).id;

    return ToolService.filterTools(
      categoryId: catId,
      query: _query,
      freeOnly: _freeOnly,
    );
  }

  // Build items list with ads injected every N tools (free users)
  List<_ListItem> _buildItems(List<Tool> tools, bool isPremium) {
    final items = <_ListItem>[];
    for (int i = 0; i < tools.length; i++) {
      items.add(_ListItem.tool(tools[i]));
      // Inject ad after every N tools (not at the very end)
      final isAdSlot = (i + 1) % AdConfig.nativeAdEvery == 0;
      final isNotLast = i < tools.length - 1;
      if (isAdSlot && isNotLast && !isPremium) {
        items.add(_ListItem.ad());
      }
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final tools = _filtered;
    final premiumState = context.read<PremiumBloc>().state;
    final isPremium = premiumState.isPremium;
    final items = _buildItems(tools, isPremium);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
              child: Center(
                child: Text('Explore',
                    style: TextStyle(
                        color: SynapStyles.textPrimary(context),
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5)),
              ),
            ),

            // ── Free Only toggle (Premium Only) ──
            if (isPremium)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Row(
                  children: [
                    Text('Free Only',
                        style: TextStyle(
                            color: SynapStyles.textSecondary(context),
                            fontSize: 13)),
                    const Spacer(),
                    SizedBox(
                      height: 24,
                      child: Switch(
                        value: _freeOnly,
                        onChanged: (v) => setState(() => _freeOnly = v),
                        activeColor: SynapColors.accent,
                      ),
                    ),
                  ],
                ),
              ),

            // ── Search ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  style: TextStyle(
                      color: SynapStyles.textPrimary(context), fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Search AI tools...',
                    hintStyle: TextStyle(
                        color: SynapStyles.textMuted(context), fontSize: 14),
                    prefixIcon: Icon(Icons.search_rounded,
                        color: SynapStyles.textMuted(context), size: 20),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            // ── Category chips ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _chips.map((chip) {
                    final sel = _selectedChip == chip;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedChip = chip),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: sel
                              ? SynapColors.accent.withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: sel
                                  ? SynapColors.accent
                                  : SynapStyles.border(context)),
                        ),
                        child: Text(chip,
                            style: TextStyle(
                              color: sel
                                  ? SynapColors.accent
                                  : SynapStyles.textSecondary(context),
                              fontSize: 12,
                              fontWeight:
                                  sel ? FontWeight.w600 : FontWeight.w400,
                            )),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // ── List with inline native ads ──
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text('No tools found',
                          style: TextStyle(
                              color: SynapStyles.textMuted(context))))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 12),
                      itemCount: items.length,
                      itemBuilder: (context, i) {
                        final item = items[i];
                        if (item.isAd) {
                          return AdNativeWidget(isProUser: isPremium);
                        }
                        return _buildToolTile(item.tool!);
                      },
                    ),
            ),

            // ── Fixed bottom banner ad ──
            AdBannerWidget(isProUser: isPremium),
          ],
        ),
      ),
    );
  }

  Widget _buildToolTile(Tool tool) {
    return GestureDetector(
      onTap: () {
        // Record view event for recommendations
        RecommendationService().record(tool.id, UserEvent.viewed);
        Navigator.pushNamed(context, '/toolDetail', arguments: tool);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(
              color: SynapColors.accent.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            ToolIcon(
                name: tool.name,
                categoryId: tool.categoryId,
                iconUrl: tool.iconUrl,
                size: 48,
                fontSize: 20,
                radius: 12),

            const SizedBox(width: 16),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tool.name,
                      style: TextStyle(
                          color: SynapStyles.textPrimary(context),
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(tool.description,
                      style: TextStyle(
                          color: SynapStyles.textSecondary(context),
                          fontSize: 12,
                          height: 1.2),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('⭐ ${tool.rating}',
                          style: TextStyle(
                              color: SynapStyles.textMuted(context),
                              fontSize: 11)),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                            color: tool.hasFreeTier
                                ? SynapColors.accentGreen.withOpacity(0.1)
                                : Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          tool.hasFreeTier ? 'FREE' : 'PAID',
                          style: TextStyle(
                              color: tool.hasFreeTier
                                  ? SynapColors.accentGreen
                                  : SynapStyles.textMuted(context),
                              fontSize: 10,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Icon(Icons.chevron_right_rounded,
                color: SynapStyles.textMuted(context), size: 20),
          ],
        ),
      ),
    );
  }
}

class _ListItem {
  final Tool? tool;
  final bool isAd;
  const _ListItem._({this.tool, required this.isAd});
  factory _ListItem.tool(Tool t) => _ListItem._(tool: t, isAd: false);
  factory _ListItem.ad() => const _ListItem._(isAd: true);
}
