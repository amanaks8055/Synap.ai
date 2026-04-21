// ══════════════════════════════════════════════════════════════
// SYNAP — ConnectivityService
// Monitors internet connectivity and shows offline UI
// ══════════════════════════════════════════════════════════════

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ConnectivityService {
  static final ValueNotifier<bool> isOnline = ValueNotifier<bool>(true);
  static bool _isChecking = false;
  static DateTime? _lastCheck;
  static int _failureStreak = 0;

  /// Check if device has internet connection
  static Future<bool> isConnected() async {
    bool connected = false;
    try {
      // DNS preflight avoids unnecessary HTTP checks when device is fully offline.
      final lookup = await InternetAddress.lookup('one.one.one.one')
          .timeout(const Duration(seconds: 3));
      if (lookup.isEmpty || lookup.first.rawAddress.isEmpty) {
        connected = false;
      } else {
        connected = await _hasHttpInternet();
      }
    } on SocketException {
      connected = false;
    } on TimeoutException {
      connected = false;
    } catch (_) {
      connected = false;
    }

    _updateStatusDebounced(connected);
    return isOnline.value;
  }

  static Future<bool> _hasHttpInternet() async {
    final endpoints = <Uri>[
      Uri.parse('https://clients3.google.com/generate_204'),
      Uri.parse('https://www.gstatic.com/generate_204'),
      Uri.parse('https://www.cloudflare.com/cdn-cgi/trace'),
    ];

    for (final uri in endpoints) {
      try {
        final response = await http.head(uri).timeout(const Duration(seconds: 3));
        if (response.statusCode >= 200 && response.statusCode < 400) {
          return true;
        }
      } catch (_) {
        // Try next endpoint.
      }
    }
    return false;
  }

  /// Continuous monitoring (call once on app start)
  static void startMonitoring() {
    _checkConnection();
    // Keep checks frequent enough for UX, but not too noisy.
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 8));
      await _checkConnection();
      return true;
    });
  }

  static Future<void> _checkConnection() async {
    if (_isChecking) return;

    // Skip if already checked within 2 seconds
    if (_lastCheck != null &&
        DateTime.now().difference(_lastCheck!).inSeconds < 2) {
      return;
    }

    _isChecking = true;
    await isConnected();
    _isChecking = false;
  }

  static void _updateStatusDebounced(bool connected) {
    if (connected) {
      _failureStreak = 0;
      if (!isOnline.value) {
        isOnline.value = true;
        debugPrint('[🟢 ONLINE] Internet restored');
      }
      _lastCheck = DateTime.now();
      return;
    }

    // Avoid false OFFLINE flips on transient packet loss / DNS hiccups.
    _failureStreak += 1;
    if (isOnline.value && _failureStreak < 2) {
      _lastCheck = DateTime.now();
      return;
    }

    if (isOnline.value) {
      isOnline.value = false;
      debugPrint('[🔴 OFFLINE] No internet connection');
    }
    _lastCheck = DateTime.now();
  }

  /// Manual retry check
  static Future<bool> retry() async {
    debugPrint('[🔄 RETRY] Checking internet...');
    return isConnected();
  }
}
