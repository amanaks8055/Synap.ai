import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../blocs/favorites/favorites_bloc.dart';
import '../blocs/favorites/favorites_event.dart';
import '../blocs/favorites/favorites_state.dart';
import '../blocs/premium/premium_bloc.dart';
import '../models/tool_model.dart';
import '../theme/app_theme.dart';
import '../widgets/ad_banner.dart';
import '../widgets/tool_icon.dart';
import '../services/user_profile_service.dart';

class ToolDetailScreen extends StatelessWidget {
  final ToolModel tool;
  const ToolDetailScreen({super.key, required this.tool});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header (← Back) ───────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_rounded, color: SynapStyles.textPrimary(context)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            // ─── Scrollable Content ────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // ① Icon + Name + Category
                    _buildHeroSection(context),

                    const SizedBox(height: 16),

                    // ② Badge Row: [+ NEW TODAY] [Freemium]
                    _buildBadgeRow(context),

                    const SizedBox(height: 20),

                    // ③ Three Stat Boxes: RATING | VOTES | USERS
                    _buildStatBoxes(context),

                    const SizedBox(height: 24),

                    // ④ WHY IT'S TRENDING
                    if (tool.whyTrending != null && tool.whyTrending!.isNotEmpty)
                      _buildWhyTrending(context),

                    // ⑤ ABOUT
                    _buildAboutSection(context),

                    const SizedBox(height: 24),

                    // ⑥ KEY FEATURES
                    if (tool.features.isNotEmpty)
                      _buildKeyFeatures(context),

                    // ⑦ BEST FOR
                    if (tool.tags.isNotEmpty)
                      _buildBestFor(context),

                    // ⑧ Free Tier Card
                    if (tool.freeLimitDescription != null && tool.freeLimitDescription!.isNotEmpty)
                      _buildInfoCard(
                        context: context,
                        icon: tool.hasFreeTier ? Icons.check_circle_rounded : Icons.lock_rounded,
                        color: tool.hasFreeTier ? const Color(0xFF00C853) : const Color(0xFFFF5252),
                        label: tool.hasFreeTier ? 'Free Tier' : 'Paid Only',
                        value: tool.freeLimitDescription!,
                      ),

                    // ⑨ Pricing Card
                    if (tool.paidPriceMonthly != null && tool.paidPriceMonthly! > 0)
                      _buildInfoCard(
                        context: context,
                        icon: Icons.credit_card_rounded,
                        color: const Color(0xFF2196F3),
                        label: 'Pricing',
                        value: '\$${tool.paidPriceMonthly!.toStringAsFixed(0)}/month — ${tool.paidTierDescription ?? 'Pro Plan'}',
                      ),

                    // ⑩ 💡 PRO TIPS
                    if (tool.optimizationTips.isNotEmpty)
                      _buildProTips(context),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ─── Bottom CTA Bar ────────────────────
            _buildBottomCTA(context),

            // ─── Ad Banner (free users) ────────────
            BlocBuilder<PremiumBloc, PremiumState>(
              builder: (context, state) {
                if (state.isPremium) return const SizedBox(height: 8);
                return const AdBannerPlaceholder();
              },
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════
  // ① HERO: Icon + Name + Category Badge
  // ══════════════════════════════════════════════════
  Widget _buildHeroSection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ToolIcon(
          name: tool.name,
          categoryId: tool.categoryId,
          iconUrl: tool.iconUrl,
          iconEmoji: tool.iconEmoji,
          size: 72,
          fontSize: 32,
          radius: 20,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tool.name,
                style: TextStyle(
                  color: SynapStyles.textPrimary(context),
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              // Category pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: SynapColors.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${tool.category.emoji} ${tool.category.label}',
                  style: const TextStyle(
                    color: SynapColors.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════
  // ② BADGE ROW: [+ NEW TODAY] [Freemium]
  // ══════════════════════════════════════════════════
  Widget _buildBadgeRow(BuildContext context) {
    final isNewToday = tool.addedAt != null &&
        DateTime.now().toUtc().difference(tool.addedAt!.toUtc()).inDays < 7;

    final pricingLabel = tool.hasFreeTier
        ? 'Freemium'
        : (tool.pricing != null && tool.pricing!.toLowerCase().contains('free'))
            ? 'Free'
            : 'Paid';

    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: [
        if (isNewToday)
          _badge('+ NEW TODAY', SynapColors.accentGreen),
        _badge(pricingLabel, SynapColors.accent),
      ],
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════
  // ③ THREE STAT BOXES: RATING | VOTES | USERS
  // ══════════════════════════════════════════════════
  Widget _buildStatBoxes(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _statBox(
            context,
            '${tool.rating}',
            'RATING',
            Icons.star_rounded,
            const Color(0xFFFFD700),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statBox(
            context,
            _formatCount(tool.votes),
            'VOTES',
            Icons.arrow_upward_rounded,
            SynapColors.accentGreen,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statBox(
            context,
            '${_formatCount(tool.reviewCount)}+',
            'USERS',
            Icons.people_rounded,
            SynapColors.accent,
          ),
        ),
      ],
    );
  }

  Widget _statBox(BuildContext context, String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: SynapStyles.textMuted(context),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════
  // ④ WHY IT'S TRENDING
  // ══════════════════════════════════════════════════
  Widget _buildWhyTrending(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            SynapColors.accentOrange.withOpacity(0.08),
            SynapColors.accentOrange.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: SynapColors.accentOrange.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: SynapColors.accentOrange.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Text('💡', style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'WHY IT\'S TRENDING',
                  style: TextStyle(
                    color: SynapColors.accentOrange,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  tool.whyTrending!,
                  style: TextStyle(
                    color: SynapStyles.textPrimary(context),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════
  // ⑤ ABOUT
  // ══════════════════════════════════════════════════
  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ABOUT',
          style: TextStyle(
            color: SynapStyles.textMuted(context),
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          tool.description,
          style: TextStyle(
            color: SynapStyles.textPrimary(context),
            fontSize: 15,
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════
  // ⑥ KEY FEATURES (green bullets)
  // ══════════════════════════════════════════════════
  Widget _buildKeyFeatures(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'KEY FEATURES',
            style: TextStyle(
              color: SynapStyles.textMuted(context),
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: tool.features.take(6).map((feature) {
              return Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.42,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 5),
                      decoration: const BoxDecoration(
                        color: SynapColors.accentGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        feature,
                        style: TextStyle(
                          color: SynapStyles.textPrimary(context),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════
  // ⑦ BEST FOR (pill chips)
  // ══════════════════════════════════════════════════
  Widget _buildBestFor(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BEST FOR',
            style: TextStyle(
              color: SynapStyles.textMuted(context),
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tool.tags.take(8).map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: SynapColors.accent.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: SynapColors.accent.withOpacity(0.18)),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: SynapStyles.textPrimary(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════
  // ⑧ 💡 PRO TIPS
  // ══════════════════════════════════════════════════
  Widget _buildProTips(BuildContext context) {
    final catColor = _getCategoryColor(tool.category);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            catColor.withOpacity(0.06),
            SynapColors.accent.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: catColor.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: catColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.lightbulb_rounded, color: catColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 PRO TIPS',
                      style: TextStyle(
                        color: catColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'How to Get the Most from ${tool.name}',
                      style: TextStyle(
                        color: SynapStyles.textSecondary(context),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Tip cards
          ...tool.optimizationTips.asMap().entries.map((entry) {
            final idx = entry.key;
            final tip = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: catColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: catColor.withOpacity(0.08)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: catColor.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${idx + 1}',
                          style: TextStyle(color: catColor, fontSize: 12, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        tip,
                        style: TextStyle(
                          color: SynapStyles.textPrimary(context),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════
  // ⑨ BOTTOM CTA: Gradient "Visit [tool]" + ❤
  // ══════════════════════════════════════════════════
  Widget _buildBottomCTA(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          // Gradient CTA button
          Expanded(
            child: GestureDetector(
              onTap: () => _openUrl(context, tool.websiteUrl),
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF4FC3F7)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🚀', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Visit ${tool.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Heart favorite button
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              final isFav = state.isFavorite(tool.id);
              return GestureDetector(
                onTap: () {
                  final prem = context.read<PremiumBloc>().state;
                  if (!isFav && state.isAtFreeLimit && !prem.isPremium) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: SynapStyles.bgCard(context),
                        content: Text(
                          'Free limit reached (5). Upgrade to Pro for unlimited.',
                          style: TextStyle(color: SynapStyles.textPrimary(context)),
                        ),
                      ),
                    );
                    return;
                  }
                  context.read<FavoritesBloc>().add(ToggleFavorite(tool.id));
                },
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: isFav
                        ? SynapColors.accentRed.withOpacity(0.15)
                        : SynapColors.accent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isFav
                          ? SynapColors.accentRed.withOpacity(0.3)
                          : SynapColors.accent.withOpacity(0.15),
                    ),
                  ),
                  child: Icon(
                    isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: isFav ? SynapColors.accentRed : SynapStyles.textSecondary(context),
                    size: 24,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════
  // ⑩ INFO CARD (Free Tier / Pricing)
  // ══════════════════════════════════════════════════
  Widget _buildInfoCard({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: SynapStyles.textPrimary(context),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────

  String _formatCount(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }

  Color _getCategoryColor(ToolCategory cat) {
    switch (cat) {
      case ToolCategory.chat:         return const Color(0xFF00E5FF);
      case ToolCategory.writing:      return const Color(0xFFE040FB);
      case ToolCategory.image:        return const Color(0xFFFF6D00);
      case ToolCategory.code:         return const Color(0xFF00E676);
      case ToolCategory.video:        return const Color(0xFFFF1744);
      case ToolCategory.audio:        return const Color(0xFF651FFF);
      case ToolCategory.productivity: return const Color(0xFF2979FF);
      case ToolCategory.seo:          return const Color(0xFFFFD600);
      case ToolCategory.business:     return const Color(0xFF00BFA5);
      default:                        return SynapColors.accent;
    }
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        if (!context.mounted) return;
        UserProfileService.incrementToolsUsed();
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }
}
