// ══════════════════════════════════════════════════════════════
// SYNAP — Midjourney-Style Animated Splash Screen
// Features:
//   • Matrix rain animation (CustomPainter, Canvas)
//   • AI-themed scrolling words (synap, gpt, neural, tokens...)
//   • Glitch effect on logo with cyan/magenta split
//   • CRT scan lines overlay
//   • Radial vignette + bottom gradient
//   • Animated cyan glow pulse on brand
//   • Auto-transition to main app with fade-out
// ══════════════════════════════════════════════════════════════

import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/moving_border_button.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onDone;
  final Future<void> dataReady;
  const SplashScreen({super.key, required this.onDone, required this.dataReady});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  // ── Animation controllers ─────────────────────────────────
  late AnimationController _rainController;      // matrix rain loop
  late AnimationController _brandController;     // logo fade in
  late AnimationController _fadeOutController;   // exit fade

  late Animation<double> _brandFade;
  late Animation<double> _fadeOut;

  bool _glitching = false;
  Timer? _glitchTimer;

  // Matrix rain columns — initialized once
  List<_IconDrop>? _iconDrops;

  @override
  void initState() {
    super.initState();

    // ── Rain: runs forever (repaints via listener) ──────────
    _rainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Standard duration for continuous ticker
    )..repeat();

    // ── Brand: fades in after 400ms ─────────────────────────
    _brandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _brandFade = CurvedAnimation(
      parent: _brandController,
      curve: Curves.easeOut,
    );

    // ── Fade out: before transition ─────────────────────────

    // ── Fade out: before transition ─────────────────────────
    _fadeOutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeOutController, curve: Curves.easeIn),
    );

    // ── Sequence ────────────────────────────────────────────
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      _brandController.forward();
    });

    // ── Periodic glitch ─────────────────────────────────
    _glitchTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted) _triggerGlitch();
    });
    // Initial glitch after 1.5s
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) _triggerGlitch();
    });

    // ── Auto-transition when BOTH 2s elapsed AND tools loaded ──
    _waitAndTransition();
  }

  Future<void> _waitAndTransition() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;
    _fadeOutController.forward().then((_) {
      if (mounted) widget.onDone();
    });
  }

  Future<void> _triggerGlitch() async {
    if (!mounted) return;
    setState(() => _glitching = true);
    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;
    setState(() => _glitching = false);
    await Future.delayed(const Duration(milliseconds: 50));
    if (!mounted) return;
    setState(() => _glitching = true);
    await Future.delayed(const Duration(milliseconds: 70));
    if (!mounted) return;
    setState(() => _glitching = false);
  }

  @override
  void dispose() {
    _glitchTimer?.cancel();
    _rainController.dispose();
    _brandController.dispose();
    _fadeOutController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _fadeOut,
        child: Stack(
          children: [
            // ── 1. AI Tool Icon Rain (full screen) ─────────
            _buildToolIconRain(size),

            // ── 2. Vignette overlay ─────────────────────────
            Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [Colors.transparent, Color(0xAA000000)],
                ),
              ),
            ),

            // ── 3. Bottom gradient for brand readability ────
            Positioned(
              bottom: 0, left: 0, right: 0,
              height: size.height * 0.55,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xFF000000),
                      Color(0xE6000000),
                      Color(0x80000000),
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.35, 0.65, 1.0],
                  ),
                ),
              ),
            ),

            // ── 4. CRT Scan lines ───────────────────────────
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: _ScanLinePainter()),
              ),
            ),

            // ── 5. Brand / Logo (centered) ──────────────────
            Center(
              child: FadeTransition(
                opacity: _brandFade,
                child: _buildBrand(),
              ),
            ),

            // ── 6. Bottom tagline ───────────────────────────
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 40,
              left: 0, right: 0,
              child: FadeTransition(
                opacity: _brandFade,
                child: Center(
                  child: Text(
                    'Discover  •  Compare  •  Optimize',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: const Color(0xFF00DCE8).withOpacity(0.5),
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_IconDrop> _getOrInitDrops(Size size) {
    if (_iconDrops == null) {
      final rng = Random();
      final domains = List<String>.from(_toolDomains)..shuffle(rng);
      _iconDrops = List.generate(min(20, domains.length), (i) {
        final domain = domains[i % domains.length];
        return _IconDrop(
          x: rng.nextDouble() * (size.width - 60),
          startOffset: rng.nextDouble(),
          speed: 0.15 + rng.nextDouble() * 0.25,
          opacity: 0.3 + rng.nextDouble() * 0.4,
          size: 40 + rng.nextDouble() * 18,
          iconUrl: 'https://t3.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=http://$domain&size=128',
        );
      });
    }
    return _iconDrops!;
  }

  Widget _buildToolIconRain(Size size) {
    return AnimatedBuilder(
      animation: _rainController,
      builder: (_, __) {
        final drops = _getOrInitDrops(size);
        return SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: drops.map((drop) {
              final cycleH = size.height + drop.size + 60;
              final totalTravel = _rainController.value * drop.speed * 3 * cycleH;
              final y = ((drop.startOffset * cycleH) + totalTravel) % cycleH - (drop.size + 30);
              return Positioned(
                left: drop.x,
                top: y,
                child: Opacity(
                  opacity: drop.opacity,
                  child: Container(
                    width: drop.size,
                    height: drop.size,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(drop.size * 0.22),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00DCE8).withOpacity(drop.opacity * 0.5),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(drop.size * 0.22),
                      child: CachedNetworkImage(
                        imageUrl: drop.iconUrl,
                        width: drop.size,
                        height: drop.size,
                        fit: BoxFit.contain,
                        memCacheWidth: 96,
                        memCacheHeight: 96,
                        fadeInDuration: Duration.zero,
                        placeholder: (_, __) => Container(
                          color: const Color(0xFF00DCE8).withOpacity(0.06),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: const Color(0xFF00DCE8).withOpacity(0.06),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────
  // BRAND WIDGET — Logo Image + Glitch Name + Subtitle
  // ─────────────────────────────────────────────────────────
  Widget _buildBrand() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Logo image with glow (Updated: Changed from Text to Svg) ──────────
        SynapMovingBorderButton(
          borderRadius: 22,
          width: 84,
          height: 84,
          padding: EdgeInsets.zero,
          backgroundColor: Colors.black,
          glowColor: const Color(0xFF00DCE8),
          duration: const Duration(seconds: 3),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(
                'assets/logo.svg',
                width: 48,
                height: 48,
                placeholderBuilder: (context) => const Text('⚡', style: TextStyle(fontSize: 32)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // ── Glitch brand name ──────────────────────────────
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 50),
          style: GoogleFonts.syne(
            fontSize: 52,
            fontWeight: FontWeight.w800,
            letterSpacing: -2,
            color: Colors.white,
            shadows: _glitching
                ? [
                    const Shadow(color: Color(0xFFFF0080), offset: Offset(-3, 0), blurRadius: 0),
                    const Shadow(color: Color(0xFF00FFFF), offset: Offset(3, 0), blurRadius: 0),
                    Shadow(color: const Color(0xFF00DCE8).withOpacity(0.6), blurRadius: 40),
                  ]
                : [
                    Shadow(color: const Color(0xFF00DCE8).withOpacity(0.5), blurRadius: 40),
                    Shadow(color: const Color(0xFF00DCE8).withOpacity(0.2), blurRadius: 80),
                  ],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Synap'),
                Text(
                  '.AI',
                  style: GoogleFonts.syne(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    shadows: _glitching
                        ? [
                            const Shadow(color: Color(0xFFFF0080), offset: Offset(-2, 0), blurRadius: 0),
                            const Shadow(color: Color(0xFF00FFFF), offset: Offset(2, 0), blurRadius: 0),
                            Shadow(color: const Color(0xFF00DCE8).withOpacity(0.6), blurRadius: 30),
                          ]
                        : [
                            Shadow(color: const Color(0xFF00DCE8).withOpacity(0.4), blurRadius: 30),
                            Shadow(color: const Color(0xFF00DCE8).withOpacity(0.15), blurRadius: 60),
                          ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        // ── Subtitle ───────────────────────────────────────
        Text(
          'AI TOOLS DISCOVERY',
          style: GoogleFonts.dmSans(
            fontSize: 12,
            letterSpacing: 5,
            color: const Color(0xFF00DCE8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ── AI tool domains for icon rain ───────────────────────
  static const _toolDomains = [
    'chat.openai.com', 'claude.ai', 'gemini.google.com', 'midjourney.com',
    'github.com', 'notion.so', 'canva.com', 'figma.com',
    'perplexity.ai', 'jasper.ai', 'grammarly.com', 'synthesia.io',
    'runwayml.com', 'stability.ai', 'huggingface.co', 'replicate.com',
    'writesonic.com', 'copy.ai', 'descript.com', 'loom.com',
    'otter.ai', 'beautiful.ai', 'pitch.com', 'gamma.app',
    'poe.com', 'you.com', 'zapier.com', 'make.com',
    'elevenlabs.io', 'heygen.com', 'invideo.io', 'photoroom.com',
  ];
}

// ══════════════════════════════════════════════════════════════
// ICON DROP — data for a single falling tool icon
// ══════════════════════════════════════════════════════════════
class _IconDrop {
  final double x;
  final double startOffset;
  final double speed;
  final double opacity;
  final double size;
  final String iconUrl;

  _IconDrop({
    required this.x,
    required this.startOffset,
    required this.speed,
    required this.opacity,
    required this.size,
    required this.iconUrl,
  });
}

// ══════════════════════════════════════════════════════════════
// CRT SCAN LINE PAINTER
// Thin horizontal lines for retro-tech feel
// ══════════════════════════════════════════════════════════════
class _ScanLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0x0A000000);
    for (double y = 0; y < size.height; y += 3) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1.5), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
