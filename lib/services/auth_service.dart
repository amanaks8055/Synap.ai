// lib/services/auth_service.dart
// ══════════════════════════════════════════════════════════════
// SYNAP — Auth Service
// Google, Apple, Email, Guest — sab handle karta hai
// ══════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final _sb = Supabase.instance.client;

  // ── GOOGLE CLIENT IDs ──────────────────────────
  static const webClientId =
      '832924787145-d68ebhsl53u3sr7fjhtbtm9ejqbp8o0o.apps.googleusercontent.com';
  static const iosClientId =
      '832924787145-iul36b14gm1mt536grcpmtle448f0rka.apps.googleusercontent.com';

  static final _googleSignIn = GoogleSignIn(
    clientId: kIsWeb
        ? webClientId
        : (defaultTargetPlatform == TargetPlatform.iOS ? iosClientId : null),
    serverClientId: kIsWeb ? null : webClientId,
  );
  // ── Current user ─────────────────────────────────────────
  static User? get currentUser => _sb.auth.currentUser;
  static bool  get isLoggedIn  => currentUser != null;
  static bool  get isGuest     => currentUser == null;
  static String? get userId    => currentUser?.id;

  // ── Auth state stream (listen for changes) ───────────────
  static Stream<AuthState> get authStateChanges =>
      _sb.auth.onAuthStateChange;

  // ══════════════════════════════════════════════════════════
  // GOOGLE SIGN IN
  // ══════════════════════════════════════════════════════════
  static Future<AuthResult> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        debugPrint('[Auth] Starting Google OAuth (Web Redirect Flow)');
        await _sb.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo: kDebugMode 
              ? 'http://localhost:3000' 
              : 'https://synap-ac981.web.app',
        );
        // On web, signInWithOAuth triggers a redirect.
        return AuthResult._(success: true, cancelled: false); 
      }

      // Mobile Flow (Native)
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return AuthResult.cancelled();
      }

      final googleAuth = await googleUser.authentication;
      final idToken    = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null) {
        return AuthResult.error('Google sign in failed (no token)');
      }

      final res = await _sb.auth.signInWithIdToken(
        provider:    OAuthProvider.google,
        idToken:     idToken,
        accessToken: accessToken,
      );

      if (res.user != null) {
        await _updateProfile(
          name:   googleUser.displayName,
          avatar: googleUser.photoUrl,
        );
        return AuthResult.success(res.user!);
      }
      
      return AuthResult.error('Failed to sign in to Supabase');
    } catch (e) {
      debugPrint('[Auth] Google error: $e');
      return AuthResult.error(e.toString());
    }
  }

  // ══════════════════════════════════════════════════════════
  // EMAIL SIGN UP
  // ══════════════════════════════════════════════════════════
  static Future<AuthResult> signUp({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final fullName = [firstName, lastName]
          .where((s) => s != null && s.isNotEmpty).join(' ');

      final res = await _sb.auth.signUp(
        email:    email,
        password: password,
        data:     { 'full_name': fullName },
      );

      if (res.user == null) {
        return AuthResult.error('Sign up failed');
      }

      return AuthResult.success(res.user!);
    } on AuthException catch (e) {
      return AuthResult.error(_friendlyError(e.message));
    } catch (e) {
      return AuthResult.error(e.toString());
    }
  }

  // ══════════════════════════════════════════════════════════
  // EMAIL SIGN IN
  // ══════════════════════════════════════════════════════════
  static Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _sb.auth.signInWithPassword(
        email:    email,
        password: password,
      );

      if (res.user == null) {
        return AuthResult.error('Sign in failed');
      }

      return AuthResult.success(res.user!);
    } on AuthException catch (e) {
      return AuthResult.error(_friendlyError(e.message));
    } catch (e) {
      return AuthResult.error(e.toString());
    }
  }

  // ══════════════════════════════════════════════════════════
  // FORGOT PASSWORD
  // ══════════════════════════════════════════════════════════
  static Future<bool> sendPasswordReset(String email) async {
    try {
      await _sb.auth.resetPasswordForEmail(email);
      return true;
    } catch (_) {
      return false;
    }
  }

  // ══════════════════════════════════════════════════════════
  // GUEST MODE
  // ══════════════════════════════════════════════════════════
  static Future<String> getOrCreateGuestId() async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('synap_guest_id');
    if (id != null) return id;
    id = 'guest_${DateTime.now().millisecondsSinceEpoch}';
    await prefs.setString('synap_guest_id', id);
    return id;
  }

  static Future<void> saveFavoriteAsGuest(
      String toolId, String toolName, String emoji) async {
    try {
      final guestId = await getOrCreateGuestId();
      await _sb.from('favorites').upsert({
        'guest_id':   guestId,
        'tool_id':    toolId,
        'tool_name':  toolName,
        'tool_emoji': emoji,
      });
    } catch (e) {
      // Offline: save locally
      final prefs  = await SharedPreferences.getInstance();
      final local  = prefs.getStringList('local_favorites') ?? [];
      if (!local.contains(toolId)) {
        local.add(toolId);
        await prefs.setStringList('local_favorites', local);
      }
    }
  }

  static Future<List<String>> getGuestFavorites() async {
    try {
      final guestId = await getOrCreateGuestId();
      final res = await _sb.from('favorites')
          .select('tool_id')
          .eq('guest_id', guestId);
      return (res as List)
          .map((r) => r['tool_id'] as String)
          .toList();
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList('local_favorites') ?? [];
    }
  }

  // ══════════════════════════════════════════════════════════
  // FAVORITES (logged in users)
  // ══════════════════════════════════════════════════════════
  static Future<void> saveFavorite(
      String toolId, String toolName, String emoji) async {
    if (!isLoggedIn) {
      await saveFavoriteAsGuest(toolId, toolName, emoji);
      return;
    }
    await _sb.from('favorites').upsert({
      'user_id':    userId,
      'tool_id':    toolId,
      'tool_name':  toolName,
      'tool_emoji': emoji,
    });
  }

  static Future<void> removeFavorite(String toolId) async {
    if (!isLoggedIn) return;
    await _sb.from('favorites')
        .delete()
        .eq('user_id', userId!)
        .eq('tool_id', toolId);
  }

  static Future<List<Map<String, dynamic>>> getFavorites() async {
    if (!isLoggedIn) {
      final ids = await getGuestFavorites();
      return ids.map((id) => {'tool_id': id}).toList();
    }
    final res = await _sb.from('favorites')
        .select()
        .eq('user_id', userId!)
        .order('added_at', ascending: false);
    return List<Map<String, dynamic>>.from(res);
  }

  // ══════════════════════════════════════════════════════════
  // SIGN OUT
  // ══════════════════════════════════════════════════════════
  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _sb.auth.signOut();
  }

  // ══════════════════════════════════════════════════════════
  // HELPERS
  // ══════════════════════════════════════════════════════════
  static Future<void> _updateProfile({
    String? name, String? avatar}) async {
    try {
      if (userId == null) return;
      final updates = <String, dynamic>{};
      if (name   != null) updates['full_name']  = name;
      if (avatar != null) updates['avatar_url'] = avatar;
      if (updates.isEmpty) return;
      updates['updated_at'] = DateTime.now().toIso8601String();
      await _sb.from('profiles').upsert({
        'id': userId, ...updates,
      });
    } catch (e) {
      // Non-fatal: profile table may not exist yet
      debugPrint('[Auth] Profile update skipped: $e');
    }
  }

  static String _friendlyError(String msg) {
    if (msg.contains('Invalid login'))    return 'Wrong email or password';
    if (msg.contains('Email not confirmed')) return 'Please verify your email first';
    if (msg.contains('already registered')) return 'Account already exists — sign in instead';
    if (msg.contains('Password should'))  return 'Password must be at least 6 characters';
    return msg;
  }
}

// ── Result type ───────────────────────────────────────────────
class AuthResult {
  final bool    success;
  final User?   user;
  final String? error;
  final bool    cancelled;

  const AuthResult._({
    required this.success,
    this.user,
    this.error,
    this.cancelled = false,
  });

  factory AuthResult.success(User user) =>
      AuthResult._(success: true, user: user);

  factory AuthResult.error(String msg) =>
      AuthResult._(success: false, error: msg);

  factory AuthResult.cancelled() =>
      AuthResult._(success: false, cancelled: true);

  String get userName =>
      user?.userMetadata?['full_name'] as String? ?? '';
}
