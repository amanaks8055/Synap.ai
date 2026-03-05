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
  final Tool tool;
  const ToolDetailScreen({super.key, required this.tool});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header ────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_rounded, color: SynapStyles.textPrimary(context)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  BlocBuilder<FavoritesBloc, FavoritesState>(
                    builder: (context, state) {
                      final isFav = state.isFavorite(tool.id);
                      return IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isFav ? SynapColors.accentRed : SynapStyles.textSecondary(context),
                        ),
                        onPressed: () {
                          final prem = context.read<PremiumBloc>().state;
                          if (!isFav && state.isAtFreeLimit && !prem.isPremium) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: SynapStyles.bgCard(context),
                                content: Text('Free limit reached (5). Upgrade to Pro for unlimited.', style: TextStyle(color: SynapStyles.textPrimary(context))),
                              ),
                            );
                            return;
                          }
                          context.read<FavoritesBloc>().add(ToggleFavorite(tool.id));
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            // ─── Content (scrollable) ──────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),
                    // Centered Logo
                    ToolIcon(name: tool.name, categoryId: tool.categoryId, iconUrl: tool.iconUrl, size: 90, fontSize: 40, radius: 24),
                    const SizedBox(height: 20),
                    // Title
                    Text(tool.name, 
                      style: TextStyle(color: SynapStyles.textPrimary(context), fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -1),
                    ),
                    const SizedBox(height: 8),
                    // Short Description
                    Text(tool.description,
                      style: TextStyle(color: SynapStyles.textSecondary(context), fontSize: 16, height: 1.4, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // ── Meta Chips (Rating & Category) ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _metaChip(context, Icons.star_rounded, '${tool.rating}', const Color(0xFFFFD700)),
                        const SizedBox(width: 12),
                        _metaChip(context, Icons.category_rounded, tool.categoryId, SynapColors.accent),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // ── Free Tier Card (Poe Style) ──
                    if (tool.freeLimitDescription != null && tool.freeLimitDescription!.isNotEmpty)
                      _infoCard(
                        context: context,
                        icon: tool.hasFreeTier ? Icons.check_circle_rounded : Icons.lock_rounded,
                        color: tool.hasFreeTier ? const Color(0xFF00C853) : const Color(0xFFFF5252),
                        label: tool.hasFreeTier ? 'Free Tier' : 'Paid Only',
                        value: tool.freeLimitDescription!,
                      ),

                    // ── Pricing Card (Poe Style) ──
                    if (tool.paidPriceMonthly != null && tool.paidPriceMonthly! > 0)
                      _infoCard(
                        context: context,
                        icon: Icons.credit_card_rounded,
                        color: const Color(0xFF2196F3),
                        label: 'Pricing',
                        value: '\$${tool.paidPriceMonthly!.toStringAsFixed(0)}/month — ${tool.paidTierDescription ?? 'Pro Plan'}',
                      ),

                    // ── Optimization Tips Card (Poe Style - Light Blue) ──
                    if (tool.optimizationTips.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _tipsCard(context, tool.optimizationTips),
                    ],

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // ─── CTA Button ────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton(
                  onPressed: () => _openUrl(context, tool.websiteUrl),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SynapColors.accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 0,
                  ),
                  child: const Text('Open Website', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                ),
              ),
            ),

            // ─── Banner ad (free users only) ───────
            // Uses StatefulWidget with proper initState/dispose
            BlocBuilder<PremiumBloc, PremiumState>(
              builder: (context, state) {
                if (state.isPremium) return const SizedBox(height: 16);
                return const AdBannerPlaceholder();
              },
            ),
          ],
        ),
      ),
    );
  }

  // ─── Info card widget ───────────────────────────
  Widget _infoCard({required BuildContext context, required IconData icon, required Color color, required String label, required String value}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, // Match reference image white card
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.2)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(
                  color: Color(0xFF1A1A2E), // Dark text for white card
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Tips card widget ───────────────────────────
  Widget _tipsCard(BuildContext context, List<String> tips) {
    const accentColor = Color(0xFF03A9F4);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.05), // Match reference light blue
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accentColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded, color: accentColor, size: 20),
              const SizedBox(width: 10),
              Text('Optimization Tips', style: TextStyle(color: accentColor, fontSize: 16, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 16),
          ...tips.map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(color: accentColor, fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(tip, style: TextStyle(color: accentColor.withOpacity(0.9), fontSize: 14, fontWeight: FontWeight.w600, height: 1.4)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // ─── Meta chip widget ──────────────────────────
  Widget _metaChip(BuildContext context, IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  // ─── URL launcher (safe + context.mounted check) ─
  Future<void> _openUrl(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        // CRASH PREVENTION: Check context is still valid after async gap
        if (!context.mounted) return;
        // Track usage
        UserProfileService.incrementToolsUsed();
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('⚠️ Could not open URL: $e');
    }
  }
}
