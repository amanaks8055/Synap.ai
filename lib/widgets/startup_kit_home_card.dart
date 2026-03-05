import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/startup/startup_kit_screen.dart';

class StartupKitHomeCard extends StatefulWidget {
  const StartupKitHomeCard({super.key});
  @override
  State<StartupKitHomeCard> createState() => _StartupKitHomeCardState();
}

class _StartupKitHomeCardState extends State<StartupKitHomeCard> with SingleTickerProviderStateMixin {
  late AnimationController _glowCtrl;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
  }

  @override
  void dispose() { _glowCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          HapticFeedback.mediumImpact();
          Navigator.push(context, PageRouteBuilder(
            pageBuilder: (_, anim, __) => FadeTransition(opacity: anim, child: const StartupKitScreen()),
            transitionDuration: const Duration(milliseconds: 400),
          ));
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedBuilder(
          animation: _glowCtrl,
          builder: (_, __) => AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            transform: Matrix4.identity()..scale(_pressed ? 0.97 : 1.0),
            transformAlignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFF1A1040), Color(0xFF0D2040), Color(0xFF0A1A30)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.3 + 0.15 * _glowCtrl.value)),
              boxShadow: [
                BoxShadow(color: const Color(0xFF6C63FF).withOpacity(0.1 + 0.08 * _glowCtrl.value), blurRadius: 20, offset: const Offset(0, 4)),
                BoxShadow(color: const Color(0xFF00D4AA).withOpacity(0.05), blurRadius: 30, offset: const Offset(0, 8)),
              ],
            ),
            child: Stack(children: [
              // Background particles
              Positioned.fill(child: ClipRRect(borderRadius: BorderRadius.circular(20),
                child: CustomPaint(painter: _MiniParticlePainter(_glowCtrl.value)))),

              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(children: [
                  // Left content
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // Badge
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: const Color(0xFF6C63FF).withOpacity(0.2), border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.4))),
                        child: const Text('🚀 FOUNDER RESOURCES', style: TextStyle(fontFamily: 'DM Sans', fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF6C63FF), letterSpacing: 1.0)),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: const Color(0xFFFFA940).withOpacity(0.15)),
                        child: const Text('FREE', style: TextStyle(fontFamily: 'DM Sans', fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFFFFA940))),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    const Text('Founder\nResources 🚀', style: TextStyle(fontFamily: 'Syne', fontSize: 17, fontWeight: FontWeight.w900, color: Colors.white, height: 1.2)),
                    const SizedBox(height: 6),
                    Text('4 AI-ready docs + tools + voice AI\nEverything founders need to launch', style: TextStyle(fontFamily: 'DM Sans', fontSize: 11, color: Colors.white.withOpacity(0.5), height: 1.4)),
                    const SizedBox(height: 12),
                    // Doc pills
                    Wrap(spacing: 6, runSpacing: 6, children: ['📋 PRD', '🏗️ SysDesign', '⚙️ Arch', '🚀 MVP'].map((d) =>
                      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Colors.white.withOpacity(0.05), border: Border.all(color: Colors.white.withOpacity(0.1))),
                        child: Text(d, style: TextStyle(fontFamily: 'DM Sans', fontSize: 9, color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w600)))).toList()),
                  ])),

                  const SizedBox(width: 12),

                  // Right — animated rocket + arrow
                  Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    AnimatedBuilder(
                      animation: _glowCtrl,
                      builder: (_, __) => Transform.translate(
                        offset: Offset(0, -4 * math.sin(_glowCtrl.value * math.pi)),
                        child: Container(
                          width: 64, height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF6C63FF).withOpacity(0.15),
                            border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.3)),
                            boxShadow: [BoxShadow(color: const Color(0xFF6C63FF).withOpacity(0.2 + 0.1 * _glowCtrl.value), blurRadius: 16)],
                          ),
                          child: const Center(child: Text('🚀', style: TextStyle(fontSize: 28))),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF6C63FF).withOpacity(0.2)),
                      child: const Icon(Icons.arrow_forward_rounded, color: Color(0xFF6C63FF), size: 16),
                    ),
                  ]),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class _MiniParticlePainter extends CustomPainter {
  final double t;
  _MiniParticlePainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(99);
    for (int i = 0; i < 15; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = rng.nextDouble() * 1.5 + 0.5;
      final alpha = 0.05 + rng.nextDouble() * 0.15 * (0.5 + 0.5 * math.sin(t * math.pi + i));
      canvas.drawCircle(Offset(x, y), r, Paint()..color = Colors.white.withOpacity(alpha));
    }
  }

  @override
  bool shouldRepaint(_MiniParticlePainter o) => o.t != t;
}
