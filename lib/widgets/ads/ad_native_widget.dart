// ═══════════════════════════════════════════
//  widgets/ads/ad_native_widget.dart
//
//  Explore Screen ki list mein use karo.
//  App ke dark theme se match karta hai.
//  "Sponsored" label clearly dikhta hai.
//
//  Usage:
//    AdNativeWidget()
// ═══════════════════════════════════════════

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../services/ad_service.dart';
import '../../config/ad_config.dart';

class AdNativeWidget extends StatefulWidget {
  final bool isProUser;
  const AdNativeWidget({super.key, this.isProUser = false});

  @override
  State<AdNativeWidget> createState() => _AdNativeWidgetState();
}

class _AdNativeWidgetState extends State<AdNativeWidget> {
  NativeAd? _nativeAd;
  bool _adLoaded = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb && !widget.isProUser && AdConfig.showAdsForFree) {
      _loadAd();
    }
  }

  void _loadAd() {
    // Try pool first (instant)
    final poolAd = AdService().getReadyNativeAd();
    if (poolAd != null) {
      setState(() {
        _nativeAd = poolAd;
        _adLoaded = true;
      });
      return;
    }

    // Pool empty — load fresh
    _nativeAd = NativeAd(
      adUnitId: AdConfig.nativeAdUnitId,
      factoryId: 'synapNativeAd',
      request: const AdRequest(
        keywords: ['AI tools', 'productivity', 'technology', 'apps'],
      ),
      listener: NativeAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _adLoaded = true);
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('🔴 Native inline failed: ${err.message}');
          ad.dispose();
          _nativeAd = null;
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || widget.isProUser || !AdConfig.showAdsForFree) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: _adLoaded && _nativeAd != null
          ? _AdCard(nativeAd: _nativeAd!)
          : const _NativeShimmerCard(),
    );
  }
}

// ── The actual dark-themed native ad card ──
class _AdCard extends StatelessWidget {
  final NativeAd nativeAd;
  const _AdCard({required this.nativeAd});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        // Slightly different from tool cards so user knows it's ad
        color: const Color(0xFF0D0A1A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF7B61FF).withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // AdMob native ad content
          AdWidget(ad: nativeAd),

          // "Sponsored" badge — required by AdMob policy
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF7B61FF).withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    color: const Color(0xFF7B61FF).withOpacity(0.4)),
              ),
              child: const Text(
                'Sponsored',
                style: TextStyle(
                  color: Color(0xFF7B61FF),
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shimmer card while native loads ───────
class _NativeShimmerCard extends StatefulWidget {
  const _NativeShimmerCard();

  @override
  State<_NativeShimmerCard> createState() => _NativeShimmerCardState();
}

class _NativeShimmerCardState extends State<_NativeShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03 + _anim.value * 0.03),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          // Icon placeholder
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05 + _anim.value * 0.04),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 12,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06 + _anim.value * 0.04),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 10,
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04 + _anim.value * 0.03),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 10,
                  width: 140,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03 + _anim.value * 0.02),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
