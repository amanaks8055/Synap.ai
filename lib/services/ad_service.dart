// ═══════════════════════════════════════════
//  services/ad_service.dart
//
//  Singleton service — app start pe init karo.
//  Banner + Native ads load aur cache karta hai.
// ═══════════════════════════════════════════

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/ad_config.dart';

class AdService extends ChangeNotifier {
  // ── Singleton ─────────────────────────────
  static final AdService _i = AdService._();
  factory AdService() => _i;
  AdService._();

  bool _initialized = false;
  bool get isInitialized => _initialized;

  // Native ad pool (preload karke rakhte hain)
  final List<NativeAd> _nativePool = [];
  final List<NativeAd> _readyNatives = [];
  static const int _poolSize = 3;

  // ── Init (main.dart mein call karo) ───────
  Future<void> initialize() async {
    if (_initialized) return;

    // Web pe google_mobile_ads supported nahi hai
    if (kIsWeb) {
      _initialized = true;
      debugPrint('⏭️ AdMob skipped on web');
      return;
    }

    await MobileAds.instance.initialize();

    // Request config (GDPR / CCPA ke liye — optional)
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        testDeviceIds: AdConfig.useTestAds ? ['YOUR_TEST_DEVICE_ID'] : [],
        tagForChildDirectedTreatment: TagForChildDirectedTreatment.unspecified,
      ),
    );

    _initialized = true;
    debugPrint('✅ AdMob initialized');

    // Native pool preload
    _preloadNativePool();
  }

  // ── Banner Ad ─────────────────────────────
  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: AdConfig.bannerAdUnitId,
      size: AdSize.banner, // 320x50
      request: _buildRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => debugPrint('🟢 Banner loaded'),
        onAdFailedToLoad: (ad, err) {
          debugPrint('🔴 Banner failed: ${err.message}');
          ad.dispose();
        },
      ),
    );
  }

  // ── Native Ad Pool ─────────────────────────
  Future<void> _preloadNativePool() async {
    for (int i = 0; i < _poolSize; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      _loadOneNative();
    }
  }

  void _loadOneNative() {
    final ad = NativeAd(
      adUnitId: AdConfig.nativeAdUnitId,
      request: _buildRequest(),
      // Factory ID must match Android/iOS registration
      // Android: NativeAdFactory registered in MainActivity.kt
      // iOS: registered in AppDelegate.swift
      factoryId: 'synapNativeAd',
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          _readyNatives.add(ad as NativeAd);
          notifyListeners();
          debugPrint('🟢 Native loaded (pool: ${_readyNatives.length})');
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('🔴 Native failed: ${err.message}');
          ad.dispose();
        },
        onAdImpression: (_) => debugPrint('📊 Native impression'),
        onAdClicked: (_) => debugPrint('👆 Native clicked'),
      ),
    )..load();

    _nativePool.add(ad);
  }

  // Get a ready native ad (and refill pool)
  NativeAd? getReadyNativeAd() {
    if (_readyNatives.isEmpty) return null;
    final ad = _readyNatives.removeAt(0);
    _loadOneNative(); // Replace consumed ad
    return ad;
  }

  int get readyNativeCount => _readyNatives.length;

  // ── Ad Request ────────────────────────────
  AdRequest _buildRequest() => const AdRequest(
    keywords: ['AI', 'technology', 'productivity', 'software', 'apps'],
    nonPersonalizedAds: false,
  );

  // ── Cleanup ───────────────────────────────
  void disposeAll() {
    for (final ad in _nativePool) {
      ad.dispose();
    }
    _nativePool.clear();
    _readyNatives.clear();
  }
}
