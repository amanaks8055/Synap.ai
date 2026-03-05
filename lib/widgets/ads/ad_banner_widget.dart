// ═══════════════════════════════════════════
//  widgets/ads/ad_banner_widget.dart
//
//  Tool Detail Screen ke bottom mein use karo.
//  Auto-load, auto-dispose, loading shimmer sab
//  handle karta hai.
//
//  Usage:
//    const AdBannerWidget()  ← bas itna
// ═══════════════════════════════════════════

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../config/ad_config.dart';
import '../../services/ad_service.dart';

class AdBannerWidget extends StatefulWidget {
  final bool isProUser;
  const AdBannerWidget({super.key, this.isProUser = false});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _adLoaded = false;
  bool _adFailed = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb && !widget.isProUser && AdConfig.showAdsForFree) {
      _loadAd();
    }
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: AdConfig.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(
        keywords: ['AI', 'technology', 'productivity', 'software', 'apps'],
      ),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _adLoaded = true);
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('🔴 Banner failed: ${err.message}');
          ad.dispose();
          if (mounted) setState(() => _adFailed = true);
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Pro user ya ads disabled → nothing
    if (kIsWeb || widget.isProUser || !AdConfig.showAdsForFree) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A18),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.06))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // "Advertisement" label — App Store guidelines ke liye required
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 2),
            child: Text(
              'ADVERTISEMENT',
              style: TextStyle(
                color: Colors.white.withOpacity(0.2),
                fontSize: 9,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Ad container
          SizedBox(
            width: AdSize.banner.width.toDouble(),
            height: AdSize.banner.height.toDouble(),
            child: _buildAdContent(),
          ),

          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildAdContent() {
    if (_adFailed) return const SizedBox.shrink();

    if (!_adLoaded) {
      // Shimmer placeholder while loading
      return const _BannerShimmer();
    }

    return AdWidget(ad: _bannerAd!);
  }
}

// ── Shimmer while banner loads ─────────────
class _BannerShimmer extends StatefulWidget {
  const _BannerShimmer();

  @override
  State<_BannerShimmer> createState() => _BannerShimmerState();
}

class _BannerShimmerState extends State<_BannerShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 0.6).animate(_ctrl);
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
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(_anim.value * 0.08),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
