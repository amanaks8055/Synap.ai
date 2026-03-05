import 'dart:math';
import 'package:flutter/material.dart';

// ══════════════════════════════════════════════
//  GLOBAL SUBTLE SPACE BACKGROUND
//  Static, barely visible dots + subtle top gradient
//  Vision: "Poe Meets Dark Space"
// ══════════════════════════════════════════════
class GlobalInterstellarBackground extends StatelessWidget {
  final Widget child;
  const GlobalInterstellarBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF0A0A12), // matching SynapColors.bgPrimary
      child: Stack(
        children: [
          // ── Layer 1: Barely visible static star dots ──
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _StarFieldPainter(),
              ),
            ),
          ),

          // ── Layer 2: Very subtle top purple gradient ──
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

          // ── Layer 3: App UI ──
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
    final paint = Paint()..color = Colors.white.withOpacity(0.05); // 5% opacity

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
