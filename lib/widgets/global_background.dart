import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// ══════════════════════════════════════════════
//  GLOBAL SUBTLE SPACE BACKGROUND
//  Dark mode: Static star dots + subtle top gradient
//  Light mode: Clean light background with soft accent tint
//  Vision: "Poe Meets Dark Space" (dark) / "Clean Minimal" (light)
// ══════════════════════════════════════════════
class GlobalInterstellarBackground extends StatelessWidget {
  final Widget child;
  const GlobalInterstellarBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final routeName = ModalRoute.of(context)?.settings.name;
    // In some wrappers (e.g., MaterialApp.builder), ModalRoute can be null.
    // Treat that as Home so the home-tint renders reliably.
    final isHomeRoute = routeName == null || routeName == '/' || routeName == '/home';

    if (!isDark) {
      // ── LIGHT MODE: Clean background, no stars ──
      return Material(
        color: const Color(0xFFF5F5F7), // SynapColors.bgPrimaryLight
        child: Stack(
          children: [
            // Subtle top accent gradient for light mode
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.35],
                      colors: [
                        Color(0x0D7B61FF), // 5% purple tint
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // App UI
            child,
          ],
        ),
      );
    }

    // ── DARK MODE: Original space background ──
    return Material(
      // Slightly lighter grey on Home to feel less heavy.
      // Keep other screens on the deeper “void” background.
      color: isHomeRoute ? const Color(0xFF101018) : const Color(0xFF0A0A12),
      child: Stack(
        children: [
          // Layer 1: Barely visible static star dots
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _StarFieldPainter(),
              ),
            ),
          ),

          // Layer 2: Very subtle top purple gradient
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.4],
                    colors: [
                      Color(0x1A7B61FF), // 10% purple
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Layer 2.5: Home-only top blur tint (brand-style)
          if (isHomeRoute)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 300,
              child: IgnorePointer(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            SynapColors.accentSecondary.withAlpha(46),
                            SynapColors.accent.withAlpha(26),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.45, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Layer 2.6: Home-only radial bloom (helps the tint read)
          if (isHomeRoute)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0.0, -1.0),
                      radius: 1.1,
                      colors: [
                        SynapColors.accentSecondary.withAlpha(41),
                        SynapColors.accent.withAlpha(26),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.35, 1.0],
                    ),
                  ),
                ),
              ),
            ),

          // Layer 3: App UI
          child,
        ],
      ),
    );
  }
}

class _StarFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42); // deterministic for static feel
    final paint = Paint()..color = Colors.white.withAlpha(13); // ~5% opacity

    for (int i = 0; i < 200; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final s = rng.nextDouble() * 1.5 + 0.5;
      canvas.drawCircle(Offset(x, y), s, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
