import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blocs/premium/premium_bloc.dart';
import '../blocs/theme/theme_bloc.dart';
import '../services/auth_service.dart';

import '../theme/app_theme.dart';
import '../widgets/tracker/tracker_home_widget.dart';
import '../services/user_profile_service.dart';
import 'startup/startup_kit_screen.dart';

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
                    icon: Icons.rocket_launch_outlined,
                    title: 'Founder Resources',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StartupKitScreen())),
                  ));

                  items.add(_MenuItem(
                    icon: Icons.bar_chart_rounded,
                    title: 'Free Tier Tracker',
                    onTap: () => Navigator.pushNamed(context, '/tracker'),
                  ));

                  items.add(_MenuItem(
                    icon: Icons.mic_none_rounded,
                    title: 'Voice Hub',
                    onTap: () => Navigator.pushNamed(context, '/voice'),
                  ));

                  items.add(_MenuItem(
                    icon: Icons.shield_outlined,
                    title: 'Privacy Policy',
                    onTap: () => _openUrl(context, 'https://synap.app/privacy'),
                  ));

                  items.add(_MenuItem(
                    icon: Icons.mail_outline_rounded,
                    title: 'Contact',
                    onTap: () => _openUrl(context, 'mailto:contact@synap.app'),
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
      debugPrint('⚠️ Could not open URL: $e');
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
                          if (premiumState.isPremium) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'PRO',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
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
