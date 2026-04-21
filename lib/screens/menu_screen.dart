import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blocs/premium/premium_bloc.dart';
import '../services/auth_service.dart';

import '../theme/app_theme.dart';
import '../widgets/tracker/tracker_home_widget.dart';
import '../services/user_profile_service.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            children: [
              // Title
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 14, 16, 20),
                child: Center(
                  child: Text('Menu', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                ),
              ),

              // ─── MENU ITEMS ──────────────────────
              BlocBuilder<PremiumBloc, PremiumState>(
                builder: (context, state) {
                  final items = <Widget>[];

                  // ─── PROFILE AREA ───────────────────
                  items.add(const _UserProfileCard());
                  items.add(const SizedBox(height: 12));

                  // Status: Tracker summary
                  items.add(const TrackerHomeWidget());
                  items.add(const SizedBox(height: 8));

                  if (!state.isPremium) {
                    items.add(_MenuItem(
                      icon: Icons.diamond_outlined,
                      title: 'Upgrade to Pro',
                      accent: true,
                      onTap: () => Navigator.pushNamed(context, '/premium'),
                    ));
                  }


                  items.add(_MenuItem(
                    icon: Icons.bar_chart_rounded,
                    title: 'Free Tier Tracker',
                    onTap: () => Navigator.pushNamed(context, '/tracker'),
                  ));

                  items.add(_MenuItem(
                    icon: Icons.language_rounded,
                    title: 'Website',
                    onTap: () => _openUrl(context, 'https://synap-muse.lovable.app'),
                  ));

                  items.add(_MenuItem(
                    icon: Icons.shield_outlined,
                    title: 'Privacy Policy',
                    onTap: () => _openUrl(context, 'https://synap-ac981.web.app/privacy-policy.html'),
                  ));

                  items.add(_MenuItem(
                    icon: Icons.mail_outline_rounded,
                    title: 'Contact',
                    onTap: () => _openUrl(context, 'mailto:zaptime.official@gmail.com'),
                  ));

                  items.add(_MenuItem(
                    icon: Icons.star_outline_rounded,
                    title: 'Rate on Play Store',
                    onTap: () => _openUrl(context, 'https://play.google.com/store/apps/details?id=com.synap.synap'),
                  ));

                  items.add(_MenuItem(
                    icon: Icons.share_outlined,
                    title: 'Share App',
                    onTap: () => _openUrl(context, 'https://play.google.com/store/apps/details?id=com.synap.synap'),
                  ));

                  // Upcoming features section (informational)
                  items.add(const SizedBox(height: 16));
                  items.add(const _UpcomingFeaturesCard());

                  items.add(const _SignOutButton());

                  return _MenuGroup(children: items);
                },
              ),

              const SizedBox(height: 24),

              // App version
              const Text(
                'Synap v1.0.0',
                style: TextStyle(color: SynapColors.textMuted, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        if (!context.mounted) return;
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {

    }
  }
}

// ─── REUSABLE MENU WIDGETS ────────────────────────
class _MenuGroup extends StatelessWidget {
  final List<Widget> children;
  const _MenuGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: SynapStyles.bgSecondary(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: List.generate(
          children.length * 2 - 1,
          (i) {
            if (i.isOdd) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(color: SynapStyles.divider(context), height: 1),
              );
            }
            return children[i ~/ 2];
          },
        ),
      ),
    );
  }
}

class _UpcomingFeaturesCard extends StatelessWidget {
  const _UpcomingFeaturesCard();

  void _openDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: SynapStyles.bgSecondary(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      isScrollControlled: true,
      builder: (context) => const _UpcomingFeaturesSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _openDetails(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: SynapStyles.bgCard(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: SynapStyles.border(context), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Features',
              style: TextStyle(
                color: SynapStyles.textPrimary(context),
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'These will unlock your personal AI workspace. Keep Synap installed so your templates, workflows, and progress stay saved.',
              style: TextStyle(
                color: SynapStyles.textMuted(context),
                fontSize: 11,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            _FeatureRow(label: 'Smart Prompt Composer', icon: Icons.auto_fix_high_outlined),
            const SizedBox(height: 10),
            _FeatureRow(label: 'One‑Tap Workflow Chains', icon: Icons.link_rounded),
            const SizedBox(height: 10),
            _FeatureRow(label: 'Adaptive Personal Feed', icon: Icons.dynamic_feed_rounded),
            const SizedBox(height: 10),
            _FeatureRow(label: 'Voice Assistant Mode', icon: Icons.mic_external_on_outlined),
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(Icons.lock_outline, size: 16, color: SynapColors.accent.withOpacity(0.8)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Uninstalling removes your saved workflows and templates—keep Synap to keep your work.',
                    style: TextStyle(color: SynapStyles.textMuted(context), fontSize: 11),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingFeaturesSheet extends StatelessWidget {
  const _UpcomingFeaturesSheet();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, controller) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                SynapStyles.bgSecondary(context),
                SynapStyles.bgSecondary(context).withOpacity(0.85),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: SynapColors.textMuted.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'What’s coming next',
                style: TextStyle(
                  color: SynapStyles.textPrimary(context),
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  controller: controller,
                  children: [
                    const _FeatureSectionHeader(title: 'Power User Essentials'),
                    _FeatureCard(
                      icon: Icons.auto_fix_high_rounded,
                      title: 'Smart Prompt Composer',
                      description: 'Turn plain language into high‑quality prompts optimized for any tool.',
                    ),
                    _FeatureCard(
                      icon: Icons.link_rounded,
                      title: 'One‑Tap Workflow Chains',
                      description: 'Run multi‑step tool sequences like a true AI agent with a single tap.',
                    ),
                    _FeatureCard(
                      icon: Icons.dynamic_feed_rounded,
                      title: 'Adaptive Personal Feed',
                      description: 'Home screen learns your usage and recommends tools you actually need.',
                    ),
                    _FeatureCard(
                      icon: Icons.mic_external_on_outlined,
                      title: 'Voice Assistant Mode',
                      description: 'Tell Synap what you want; it selects the best tool and fills the prompt for you.',
                    ),
                    const SizedBox(height: 14),
                    const _FeatureSectionHeader(title: 'Creator + Team Engine'),
                    _FeatureCard(
                      icon: Icons.dashboard_customize_rounded,
                      title: 'Progress & Productivity Dashboard',
                      description: 'Track your time saved, streaks, and productivity metrics.',
                    ),
                    _FeatureCard(
                      icon: Icons.offline_bolt_rounded,
                      title: 'Offline Toolkit + Smart Cache',
                      description: 'Continue working even without internet by caching your core tools.',
                    ),
                    _FeatureCard(
                      icon: Icons.dashboard_customize_rounded,
                      title: 'Creator Inspiration Board',
                      description: 'Save collections of prompts and tools as boards for future campaigns.',
                    ),
                    _FeatureCard(
                      icon: Icons.group_work_rounded,
                      title: 'Multi‑User Workspaces',
                      description: 'Share templates and workflows with your team, with access controls.',
                    ),
                    _FeatureCard(
                      icon: Icons.api_rounded,
                      title: 'Custom API Tool Connectors',
                      description: 'Connect internal APIs (CRM, docs, database) as AI tools.',
                    ),
                    _FeatureCard(
                      icon: Icons.receipt_long_rounded,
                      title: 'Audit Log & History',
                      description: 'Track who ran what and when for compliance and transparency.',
                    ),
                    _FeatureCard(
                      icon: Icons.verified_user_rounded,
                      title: 'Governance & Output Controls',
                      description: 'Enforce company policies by blocking risky output automatically.',
                    ),
                    _FeatureCard(
                      icon: Icons.style_rounded,
                      title: 'Brand Voice Engine',
                      description: 'Ensure every output always matches your brand tone and guidelines.',
                    ),
                    _FeatureCard(
                      icon: Icons.developer_mode_rounded,
                      title: 'API + SDK Access',
                      description: 'Embed Synap workflows into your own apps and systems.',
                    ),
                    _FeatureCard(
                      icon: Icons.analytics_rounded,
                      title: 'Real‑Time ROI Dashboard',
                      description: 'Measure time saved, usage patterns, and team productivity.',
                    ),
                    const SizedBox(height: 20),
                    _FeatureAlert(
                      message: 'Your saved workflows and progress will stay safe only as long as the app is installed.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FeatureSectionHeader extends StatelessWidget {
  final String title;

  const _FeatureSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: SynapStyles.textPrimary(context),
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Container(
            width: 48,
            height: 28,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [SynapColors.accent, SynapColors.accent.withOpacity(0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(Icons.star, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SynapStyles.bgCard(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: SynapStyles.border(context), width: 0.6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [SynapColors.accent.withOpacity(0.9), SynapColors.accent.withOpacity(0.4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: SynapStyles.textPrimary(context),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    color: SynapStyles.textMuted(context),
                    fontSize: 12,
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
}

class _FeatureRow extends StatelessWidget {
  final String label;
  final IconData icon;

  const _FeatureRow({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: SynapColors.accent),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: SynapStyles.textPrimary(context), fontSize: 13),
          ),
        ),
      ],
    );
  }
}

class _FeatureAlert extends StatelessWidget {
  final String message;

  const _FeatureAlert({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: SynapStyles.bgCard(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: SynapStyles.border(context), width: 0.6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: SynapColors.accent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: SynapStyles.textMuted(context), fontSize: 12, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserProfileCard extends StatelessWidget {
  const _UserProfileCard();

  @override
  Widget build(BuildContext context) {
    final List<String> emojis = ['😊', '😎', '🐱', '🤖', '🦊', '🚀', '🌈'];

    return BlocBuilder<PremiumBloc, PremiumState>(
      builder: (context, premiumState) {
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/profile'),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: SynapStyles.bgCard(context),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: SynapStyles.border(context), width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: UserProfileService.avatarIndexNotifier,
                  builder: (context, index, _) {
                    return Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: SynapColors.accent.withOpacity(0.1),
                        border: Border.all(color: SynapColors.accent.withOpacity(0.2)),
                      ),
                      child: Center(
                        child: Text(
                          emojis[index % emojis.length],
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: ValueListenableBuilder<String>(
                              valueListenable: UserProfileService.nameNotifier,
                              builder: (context, name, _) {
                                return Text(
                                  name,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Synap AI Enthusiast',
                        style: TextStyle(
                          color: SynapStyles.textMuted(context),
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: SynapStyles.textMuted(context), size: 14),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SignOutButton extends StatelessWidget {
  const _SignOutButton();

  @override
  Widget build(BuildContext context) {
    if (AuthService.isGuest) return const SizedBox.shrink();

    return _MenuItem(
      icon: Icons.logout_rounded,
      title: 'Sign Out',
      onTap: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sign Out'),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Sign Out', style: TextStyle(color: SynapColors.accentRed)),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          await AuthService.signOut();
          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
          }
        }
      },
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool accent;
  final VoidCallback onTap;

  const _MenuItem({required this.icon, required this.title, this.accent = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: accent ? SynapColors.accent : SynapStyles.textSecondary(context), size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: accent ? SynapColors.accent : SynapStyles.textPrimary(context),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: accent ? SynapColors.accent : SynapStyles.textMuted(context),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
