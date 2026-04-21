// ═══════════════════════════════════════════
//  config/ad_config.dart
//
//  ⚠️  RELEASE SE PEHLE:
//  _useTestAds = false karo
//  Apne real AdMob IDs replace karo
//  AdMob console: https://admob.google.com
// ═══════════════════════════════════════════

import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

class AdConfig {
  AdConfig._();

  // ────────────────────────────────────────
  //  APP IDs  (AndroidManifest.xml mein bhi add karo)
  // ────────────────────────────────────────
  static const String androidAppId = 'ca-app-pub-8234387534313891~6123199685';
  static const String iosAppId     = 'ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX';

  // ────────────────────────────────────────
  //  Google Official Test IDs
  // ────────────────────────────────────────
  static const _tBannerA = 'ca-app-pub-3940256099942544/6300978111';
  static const _tBannerI = 'ca-app-pub-3940256099942544/2934735716';
  static const _tNativeA = 'ca-app-pub-3940256099942544/2247696110';
  static const _tNativeI = 'ca-app-pub-3940256099942544/3986624511';

  // ────────────────────────────────────────
  //  Your Production IDs
  // ────────────────────────────────────────
  static const _pBannerA = 'ca-app-pub-8234387534313891/3235799004';
  static const _pBannerI = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const _pNativeA = 'ca-app-pub-8234387534313891/8296553993';
  static const _pNativeI = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';

  // ────────────────────────────────────────
  //  Master toggle
  // ────────────────────────────────────────
  static const bool useTestAds = true;

  // ────────────────────────────────────────
  //  Web pe ads supported nahi hain
  // ────────────────────────────────────────
  static bool get isSupported => !kIsWeb;

  static bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  // ────────────────────────────────────────
  //  Getters (web pe dummy return)
  // ────────────────────────────────────────
  static String get bannerAdUnitId {
    if (kIsWeb) return '';
    return _isAndroid
        ? (useTestAds ? _tBannerA : _pBannerA)
        : (useTestAds ? _tBannerI : _pBannerI);
  }

  static String get nativeAdUnitId {
    if (kIsWeb) return '';
    return _isAndroid
        ? (useTestAds ? _tNativeA : _pNativeA)
        : (useTestAds ? _tNativeI : _pNativeI);
  }

  // ────────────────────────────────────────
  //  Behavior Settings
  // ────────────────────────────────────────
  static const int  nativeAdEvery      = 5;
  static const bool showAdsForPro      = false;
  static const bool showAdsForFree     = true;
}
