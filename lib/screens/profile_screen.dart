import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/moving_border_button.dart';
import '../theme/app_theme.dart';
import '../services/user_profile_service.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<String> _emojis = ['😊', '😎', '🐱', '🤖', '🦊', '🚀', '🌈'];
  late TextEditingController _nameController;
  bool _isEditingName = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: UserProfileService.nameNotifier.value);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveName() {
    if (_nameController.text.trim().isNotEmpty) {
      UserProfileService.updateName(_nameController.text.trim());
      setState(() => _isEditingName = false);
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06090E),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 0,
            pinned: true,
            backgroundColor: const Color(0xFF06090E),
            elevation: 0,
            title: const Text('Edit Profile', style: TextStyle(fontFamily: 'Syne', fontWeight: FontWeight.w800)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildAvatarPickerCard(),
                  const SizedBox(height: 30),
                  ValueListenableBuilder<int>(
                    valueListenable: UserProfileService.toolsUsedCountNotifier,
                    builder: (context, toolsUsed, _) {
                      return ValueListenableBuilder<int>(
                        valueListenable: UserProfileService.favoritesCountNotifier,
                        builder: (context, favorites, _) {
                          return Row(
                            children: [
                              _statItem('Tools Used', toolsUsed.toString()),
                              const SizedBox(width: 16),
                              _statItem('Favorites', favorites.toString()),
                              const SizedBox(width: 16),
                              _statItem('AI Credit', '840'),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  _buildNotificationSection(),
                  const SizedBox(height: 20),
                  _buildLogoutButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarPickerCard() {
    return ValueListenableBuilder<int>(
      valueListenable: UserProfileService.avatarIndexNotifier,
      builder: (context, selectedIndex, _) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF0D141C),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            children: [
              Container(
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFF161B22),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -50),
                child: Column(
                  children: [
                    SynapMovingBorderButton(
                      onTap: () {},
                      borderRadius: 100,
                      width: 120,
                      height: 120,
                      backgroundColor: const Color(0xFF0D141C),
                      glowColor: SynapColors.accent,
                      duration: const Duration(seconds: 4),
                      padding: EdgeInsets.zero,
                      child: Center(
                        child: Text(
                          _emojis[selectedIndex % _emojis.length],
                          style: const TextStyle(fontSize: 50),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildNameField(),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 50,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: _emojis.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final isSelected = selectedIndex == index;
                          return GestureDetector(
                            onTap: () {
                              UserProfileService.updateAvatarIndex(index);
                              HapticFeedback.selectionClick();
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: isSelected ? 48 : 40,
                              height: isSelected ? 48 : 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? SynapColors.accent.withOpacity(0.1) : const Color(0xFF161B22),
                                border: Border.all(
                                  color: isSelected ? SynapColors.accent : Colors.white.withOpacity(0.05),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Center(
                                child: Text(_emojis[index], style: TextStyle(fontSize: isSelected ? 22 : 18)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isEditingName) ...[
                ValueListenableBuilder<String>(
                  valueListenable: UserProfileService.nameNotifier,
                  builder: (context, name, _) {
                    return Text(
                      name,
                      style: const TextStyle(fontFamily: 'Syne', fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit_rounded, color: SynapColors.accent, size: 18),
                  onPressed: () => setState(() => _isEditingName = true),
                ),
              ] else ...[
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
                      border: UnderlineInputBorder(borderSide: BorderSide(color: SynapColors.accent)),
                    ),
                    onSubmitted: (_) => _saveName(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.check_circle_rounded, color: Colors.greenAccent),
                  onPressed: _saveName,
                ),
              ],
            ],
          ),
          Text(
            'Synap AI Enthusiast',
            style: TextStyle(fontFamily: 'DM Sans', fontSize: 12, color: Colors.white.withOpacity(0.3)),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0D141C),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.03)),
        ),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontFamily: 'Syne', fontSize: 18, fontWeight: FontWeight.w800, color: SynapColors.accent)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontFamily: 'DM Sans', fontSize: 9, color: Colors.white.withOpacity(0.4), fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D141C),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active_rounded, color: SynapColors.accent, size: 24),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Daily Picks', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                Text('Get notified about new tools', style: TextStyle(color: Colors.white60, fontSize: 11)),
              ],
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: UserProfileService.notificationsEnabledNotifier,
            builder: (context, enabled, _) {
              return Switch(
                value: enabled,
                activeColor: SynapColors.accent,
                onChanged: (v) {
                  UserProfileService.toggleNotifications(v);
                  HapticFeedback.selectionClick();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () async {
        await AuthService.signOut();
        if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/auth', (r) => false);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.redAccent.withOpacity(0.1)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
            SizedBox(width: 8),
            Text('Sign Out', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
