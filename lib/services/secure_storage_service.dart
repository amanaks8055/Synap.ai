// ══════════════════════════════════════════════════════════════
// SYNAP — Secure Storage Service
// Encrypts sensitive data (purchase tokens, user IDs) using platform security
// ══════════════════════════════════════════════════════════════

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _instance = FlutterSecureStorage(
    aOptions: AndroidOptions(
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
      resetOnError: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Purchase-related keys
  static const _kPurchaseToken = 'synap_purchase_token_secure';
  static const _kPurchaseId = 'synap_purchase_id_secure';
  static const _kUserId = 'synap_user_id_secure';

  // ── Write Methods ──────────────────────────────────────────
  static Future<void> savePurchaseToken(String token) async {
    if (token.isEmpty) return;
    await _instance.write(key: _kPurchaseToken, value: token);
  }

  static Future<void> savePurchaseId(String id) async {
    if (id.isEmpty) return;
    await _instance.write(key: _kPurchaseId, value: id);
  }

  static Future<void> saveUserId(String userId) async {
    if (userId.isEmpty) return;
    await _instance.write(key: _kUserId, value: userId);
  }

  // ── Read Methods ───────────────────────────────────────────
  static Future<String?> getPurchaseToken() async {
    try {
      return await _instance.read(key: _kPurchaseToken);
    } catch (e) {
      return null;
    }
  }

  static Future<String?> getPurchaseId() async {
    try {
      return await _instance.read(key: _kPurchaseId);
    } catch (e) {
      return null;
    }
  }

  static Future<String?> getUserId() async {
    try {
      return await _instance.read(key: _kUserId);
    } catch (e) {
      return null;
    }
  }

  // ── Delete Methods ─────────────────────────────────────────
  static Future<void> deletePurchaseToken() async {
    await _instance.delete(key: _kPurchaseToken);
  }

  static Future<void> deleteAll() async {
    await _instance.deleteAll();
  }

  // ── Clear Cache ────────────────────────────────────────────
  /// Call this on logout to clear all sensitive data
  static Future<void> clearSecureData() async {
    await deletePurchaseToken();
    await _instance.delete(key: _kPurchaseId);
    await _instance.delete(key: _kUserId);
  }
}
