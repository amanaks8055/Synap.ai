
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class UserProfileService {
  static const String _nameKey = 'user_full_name';
  static const String _avatarIndexKey = 'user_avatar_index';
  static const String _favoritesCountKey = 'user_favorites_count';
  static const String _toolsUsedCountKey = 'user_tools_used_count';
  static const String _notificationsEnabledKey = 'user_notifications_enabled';

  static final ValueNotifier<String> nameNotifier = ValueNotifier<String>('Synap Explorer');
  static final ValueNotifier<int> avatarIndexNotifier = ValueNotifier<int>(0);
  static final ValueNotifier<int> favoritesCountNotifier = ValueNotifier<int>(0);
  static final ValueNotifier<int> toolsUsedCountNotifier = ValueNotifier<int>(0);
  static final ValueNotifier<bool> notificationsEnabledNotifier = ValueNotifier<bool>(true);

  static String _nameFromAuthUser() {
    final user = AuthService.currentUser;
    if (user == null) return 'Synap Explorer';

    final meta = user.userMetadata;
    final fromFullName = meta?['full_name'] as String?;
    final fromName = meta?['name'] as String?;
    final fromEmail = user.email;

    if (fromFullName != null && fromFullName.trim().isNotEmpty) {
      return fromFullName.trim();
    }
    if (fromName != null && fromName.trim().isNotEmpty) {
      return fromName.trim();
    }
    if (fromEmail != null && fromEmail.trim().isNotEmpty) {
      return fromEmail.split('@').first;
    }
    return 'Synap Explorer';
  }

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    // Prefer live auth metadata, fallback to locally stored custom name.
    final metaName = _nameFromAuthUser();
    final savedName = prefs.getString(_nameKey);
    nameNotifier.value = metaName != 'Synap Explorer' ? metaName : (savedName ?? 'Synap Explorer');

    if (metaName != 'Synap Explorer' && savedName != metaName) {
      await prefs.setString(_nameKey, metaName);
    }

    avatarIndexNotifier.value = prefs.getInt(_avatarIndexKey) ?? 0;
    favoritesCountNotifier.value = prefs.getInt(_favoritesCountKey) ?? 0;
    toolsUsedCountNotifier.value = prefs.getInt(_toolsUsedCountKey) ?? 0;
    notificationsEnabledNotifier.value = prefs.getBool(_notificationsEnabledKey) ?? true;
  }

  static Future<void> syncFromAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final metaName = _nameFromAuthUser();

    if (AuthService.isLoggedIn) {
      nameNotifier.value = metaName;
      await prefs.setString(_nameKey, metaName);
      return;
    }

    nameNotifier.value = prefs.getString(_nameKey) ?? 'Synap Explorer';
  }

  static Future<void> updateName(String newName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, newName);
    nameNotifier.value = newName;
    
    // Plan: Sync with Supabase if logged in
  }

  static Future<void> updateAvatarIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_avatarIndexKey, index);
    avatarIndexNotifier.value = index;
  }

  static Future<void> incrementToolsUsed() async {
    final prefs = await SharedPreferences.getInstance();
    toolsUsedCountNotifier.value++;
    await prefs.setInt(_toolsUsedCountKey, toolsUsedCountNotifier.value);
  }

  static Future<void> refreshFavoritesCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    favoritesCountNotifier.value = count;
    await prefs.setInt(_favoritesCountKey, count);
  }

  static Future<void> toggleNotifications(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, enabled);
    notificationsEnabledNotifier.value = enabled;
  }
}
