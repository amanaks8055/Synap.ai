// ══════════════════════════════════════════════════════════════
// SYNAP — Activation Screen
// CINEMATIC SPACE JOURNEY:
// 1) Falcon launches from Earth
// 2) Flies past the Sun (heat waves)
// 3) Approaches Blackhole (AI tools orbit it)
// 4) Touches Blackhole → flash
// 5) Returns to Earth
// Background: Milky Way galaxy + stars
// ══════════════════════════════════════════════════════════════

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActivationScreen extends StatefulWidget {
  final Future<void> dataReady;
  final VoidCallback onDone;
  const ActivationScreen(
      {super.key, required this.dataReady, required this.onDone});

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen>
    with TickerProviderStateMixin {
  // ── Master timeline (0.0 → 1.0 across full journey) ─────
  late AnimationController _timeline;
  // ── Looping animations ──────────────────────────────────
  late AnimationController _loop;       // stars twinkle, heat waves, orbit
  late AnimationController _fadeIn;
  late AnimationController _exitCtrl;
  late AnimationController _dotsCtrl;
  late AnimationController _progressCtrl;

  late Animation<double> _fadeInAnim;
  late Animation<double> _exitAnim;

  int _msgIdx = 0;
  static const _msgs = [
    'Launching into the AI universe',
    'Passing through solar flares',
    'Approaching the AI Blackhole',
    'Downloading AI tools',
    'Returning to Earth',
    'Almost ready',
  ];

  static const _aiTools = [
    ('🤖', 'ChatGPT'),
    ('🧠', 'Claude'),
    ('⚡', 'Gemini'),
    ('🔮', 'Midjourney'),
    ('💡', 'Copilot'),
    ('🎯', 'Jasper'),
    ('🚀', 'Runway'),
    ('✨', 'DALL·E'),
    ('🎨', 'Stable Diffusion'),
    ('📝', 'Notion AI'),
  ];

  @override
  void initState() {
    super.initState();

    // Master timeline: entire journey in 12 seconds
    _timeline = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..forward();

    // Looping for continuous effects
    _loop = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _fadeIn = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 800),
    );
    _fadeInAnim = CurvedAnimation(parent: _fadeIn, curve: Curves.easeOut);

    _dotsCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1500),
    )..repeat();

    _progressCtrl = AnimationController(
      vsync: this, duration: const Duration(seconds: 12),
    )..forward();

    _exitCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500),
    );
    _exitAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitCtrl, curve: Curves.easeIn),
    );

    _fadeIn.forward();
    _cycleMessages();
    _waitForData();
  }

  void _cycleMessages() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      setState(() => _msgIdx = (_msgIdx + 1) % _msgs.length);
    }
  }

  Future<void> _waitForData() async {
    await widget.dataReady;
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    _exitCtrl.forward().then((_) {
      if (mounted) widget.onDone();
    });
  }

  @override
  void dispose() {
    _timeline.dispose();
    _loop.dispose();
    _fadeIn.dispose();
    _dotsCtrl.dispose();
    _progressCtrl.dispose();
    _exitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF010105),
      body: FadeTransition(
        opacity: _exitAnim,
        child: FadeTransition(
          opacity: _fadeInAnim,
          child: Stack(
            children: [
              // ── The cinematic scene ───────────────────
              AnimatedBuilder(
                animation: Listenable.merge([_timeline, _loop]),
                builder: (_, __) => CustomPaint(
                  size: sz,
                  painter: _SpaceJourneyPainter(
                    timeline: _timeline.value,
                    loop: _loop.value,
                    aiTools: _aiTools,
                  ),
                ),
              ),

              // ── Bottom UI ─────────────────────────────
              Positioned(
                left: 0, right: 0,
                bottom: sz.height * 0.06,
                child: Column(children: [
                  _buildLogo(),
                  const SizedBox(height: 16),
                  _buildStatusText(),
                  const SizedBox(height: 20),
                  _buildProgress(),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _loop,
      builder: (_, __) {
        final p = _loop.value;
        return Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFF0A0A14),
            border: Border.all(color: const Color(0xFF00DCE8).withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00DCE8).withOpacity(0.06 + p * 0.08),
                blurRadius: 12 + p * 6,
              ),
            ],
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/logo.svg', width: 20, height: 20,
              colorFilter: ColorFilter.mode(
                const Color(0xFF00DCE8).withOpacity(0.8 + p * 0.2),
                BlendMode.srcIn,
              ),
              placeholderBuilder: (_) => Text('⚡',
                  style: TextStyle(fontSize: 14,
                      color: const Color(0xFF00DCE8).withOpacity(0.8))),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusText() {
    return Column(children: [
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(
                begin: const Offset(0, 0.12), end: Offset.zero)
                .animate(anim),
            child: child,
          ),
        ),
        child: Text(
          _msgs[_msgIdx],
          key: ValueKey(_msgIdx),
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(
            fontSize: 14, fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ),
      const SizedBox(height: 4),
      AnimatedBuilder(
        animation: _dotsCtrl,
        builder: (_, __) {
          final n = (_dotsCtrl.value * 4).floor() % 4;
          return Text('·' * n,
            style: GoogleFonts.dmSans(
              fontSize: 20,
              color: const Color(0xFF00DCE8).withOpacity(0.5),
              letterSpacing: 5,
            ),
          );
        },
      ),
    ]);
  }

  Widget _buildProgress() {
    return AnimatedBuilder(
      animation: _progressCtrl,
      builder: (_, __) {
        final p = Curves.easeOut.transform(_progressCtrl.value.clamp(0.0, 0.92));
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1),
              color: Colors.white.withOpacity(0.06),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: p,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7B61FF), Color(0xFF00DCE8)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00DCE8).withOpacity(0.35),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// MASTER PAINTER — draws entire space journey
// ═══════════════════════════════════════════════════════════════
class _SpaceJourneyPainter extends CustomPainter {
  final double timeline;  // 0.0 → 1.0 (entire journey)
  final double loop;      // 0.0 → 1.0 repeating
  final List<(String, String)> aiTools;

  _SpaceJourneyPainter({
    required this.timeline,
    required this.loop,
    required this.aiTools,
  });

  // ── Journey phases ──────────────────────────────────────
  // 0.00 - 0.15 : Falcon launches from Earth
  // 0.15 - 0.35 : Falcon flies through space, passes Sun
  // 0.35 - 0.60 : Falcon approaches Blackhole
  // 0.60 - 0.70 : Falcon touches Blackhole, flash
  // 0.70 - 0.90 : Falcon returns to Earth
  // 0.90 - 1.00 : Landing / settled

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    _drawMilkyWay(canvas, size);
    _drawStars(canvas, size);
    _drawEarth(canvas, size);
    _drawSun(canvas, size);
    _drawBlackhole(canvas, size);
    _drawAIToolsAroundBlackhole(canvas, size);
    _drawFalcon(canvas, size);
    _drawFlash(canvas, size);
  }

  // ═══════════════════════════════════════════════════════════
  // MILKY WAY — diagonal band of faint light
  // ═══════════════════════════════════════════════════════════
  void _drawMilkyWay(Canvas canvas, Size size) {
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);

    // Diagonal milky way band
    final path = Path()
      ..moveTo(0, size.height * 0.2)
      ..quadraticBezierTo(
          size.width * 0.3, size.height * 0.35,
          size.width * 0.6, size.height * 0.45)
      ..quadraticBezierTo(
          size.width * 0.85, size.height * 0.55,
          size.width, size.height * 0.7)
      ..lineTo(size.width, size.height * 0.6)
      ..quadraticBezierTo(
          size.width * 0.8, size.height * 0.45,
          size.width * 0.5, size.height * 0.38)
      ..quadraticBezierTo(
          size.width * 0.2, size.height * 0.3,
          0, size.height * 0.12)
      ..close();

    // Purple/blue milky way
    paint.color = const Color(0xFF2A1B4E).withOpacity(0.15 + loop * 0.05);
    canvas.drawPath(path, paint);
    paint.color = const Color(0xFF1A3A5C).withOpacity(0.1 + loop * 0.03);
    canvas.drawPath(path, paint);
  }

  // ═══════════════════════════════════════════════════════════
  // STARS — twinkling background
  // ═══════════════════════════════════════════════════════════
  void _drawStars(Canvas canvas, Size size) {
    final rng = Random(77);
    final paint = Paint();

    for (int i = 0; i < 60; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height * 0.75;
      final r = 0.3 + rng.nextDouble() * 1.5;
      final twinkle = (sin((loop + i * 0.06) * pi * 2) + 1) / 2;
      final baseAlpha = 0.1 + rng.nextDouble() * 0.4;
      paint.color = Colors.white.withOpacity(baseAlpha * (0.3 + twinkle * 0.7));
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  // ═══════════════════════════════════════════════════════════
  // EARTH — bottom-left, Falcon launches from here
  // ═══════════════════════════════════════════════════════════
  void _drawEarth(Canvas canvas, Size size) {
    // Earth visible in phase 0.0 - 0.20 and 0.75 - 1.0
    double earthOpacity = 0.0;
    if (timeline < 0.20) {
      earthOpacity = 1.0;
    } else if (timeline < 0.30) {
      earthOpacity = 1.0 - (timeline - 0.20) / 0.10;
    } else if (timeline > 0.75) {
      earthOpacity = (timeline - 0.75) / 0.15;
    }
    if (earthOpacity <= 0) return;

    final earthX = size.width * 0.22;
    final earthY = size.height * 0.62;
    final earthR = 55.0;

    // Earth glow
    canvas.drawCircle(
      Offset(earthX, earthY),
      earthR + 12,
      Paint()
        ..color = const Color(0xFF1E90FF).withOpacity(0.12 * earthOpacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
    );

    // Earth body
    canvas.drawCircle(
      Offset(earthX, earthY),
      earthR,
      Paint()..color = const Color(0xFF0A3D6B).withOpacity(0.9 * earthOpacity),
    );

    // Continents (abstract green patches)
    final continentPaint = Paint()
      ..color = const Color(0xFF1B7A3D).withOpacity(0.6 * earthOpacity);
    canvas.drawCircle(Offset(earthX - 15, earthY - 10), 18, continentPaint);
    canvas.drawCircle(Offset(earthX + 20, earthY + 5), 14, continentPaint);
    canvas.drawCircle(Offset(earthX - 5, earthY + 20), 12, continentPaint);

    // Atmosphere ring
    canvas.drawCircle(
      Offset(earthX, earthY),
      earthR,
      Paint()
        ..color = const Color(0xFF4FC3F7).withOpacity(0.3 * earthOpacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    // Cloud wisps
    canvas.drawArc(
      Rect.fromCircle(center: Offset(earthX, earthY), radius: earthR - 8),
      -0.5, 1.2,
      false,
      Paint()
        ..color = Colors.white.withOpacity(0.2 * earthOpacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // SUN — upper area, with heat waves
  // ═══════════════════════════════════════════════════════════
  void _drawSun(Canvas canvas, Size size) {
    // Sun visible in phase 0.15 - 0.45
    double sunOpacity = 0.0;
    if (timeline > 0.12 && timeline < 0.20) {
      sunOpacity = (timeline - 0.12) / 0.08;
    } else if (timeline >= 0.20 && timeline < 0.38) {
      sunOpacity = 1.0;
    } else if (timeline >= 0.38 && timeline < 0.48) {
      sunOpacity = 1.0 - (timeline - 0.38) / 0.10;
    }
    if (sunOpacity <= 0) return;

    final sunX = size.width * 0.75;
    final sunY = size.height * 0.18;
    final sunR = 35.0;

    // Outer glow
    for (int i = 3; i >= 0; i--) {
      canvas.drawCircle(
        Offset(sunX, sunY),
        sunR + 15 + i * 12,
        Paint()
          ..color = const Color(0xFFFF6B00)
              .withOpacity(0.04 * (4 - i) * sunOpacity)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10.0 + i * 8),
      );
    }

    // Sun body
    canvas.drawCircle(
      Offset(sunX, sunY),
      sunR,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFE135).withOpacity(sunOpacity),
            const Color(0xFFFF8C00).withOpacity(0.9 * sunOpacity),
            const Color(0xFFFF4500).withOpacity(0.7 * sunOpacity),
          ],
          stops: const [0.0, 0.6, 1.0],
        ).createShader(Rect.fromCircle(center: Offset(sunX, sunY), radius: sunR)),
    );

    // Heat waves — expanding rings
    for (int i = 0; i < 4; i++) {
      final wavePhase = (loop + i * 0.25) % 1.0;
      final waveR = sunR + 20 + wavePhase * 60;
      final waveAlpha = (1.0 - wavePhase) * 0.25 * sunOpacity;
      canvas.drawCircle(
        Offset(sunX, sunY),
        waveR,
        Paint()
          ..color = const Color(0xFFFF6B00).withOpacity(waveAlpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }

    // Solar flares
    for (int i = 0; i < 6; i++) {
      final angle = (i * pi / 3) + loop * pi * 2;
      final flareLen = 12 + sin(loop * pi * 2 + i) * 8;
      final flareEnd = Offset(
        sunX + cos(angle) * (sunR + flareLen),
        sunY + sin(angle) * (sunR + flareLen),
      );
      canvas.drawLine(
        Offset(sunX + cos(angle) * sunR, sunY + sin(angle) * sunR),
        flareEnd,
        Paint()
          ..color = const Color(0xFFFFD700).withOpacity(0.5 * sunOpacity)
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════
  // BLACKHOLE — center-right, with accretion disk
  // ═══════════════════════════════════════════════════════════
  void _drawBlackhole(Canvas canvas, Size size) {
    // Visible in phase 0.35 - 0.80
    double bhOpacity = 0.0;
    if (timeline > 0.30 && timeline < 0.40) {
      bhOpacity = (timeline - 0.30) / 0.10;
    } else if (timeline >= 0.40 && timeline < 0.72) {
      bhOpacity = 1.0;
    } else if (timeline >= 0.72 && timeline < 0.82) {
      bhOpacity = 1.0 - (timeline - 0.72) / 0.10;
    }
    if (bhOpacity <= 0) return;

    final bhX = size.width * 0.65;
    final bhY = size.height * 0.32;
    final bhR = 28.0;

    // Accretion disk glow
    for (int i = 4; i >= 0; i--) {
      final diskR = bhR + 20 + i * 14.0;
      canvas.drawCircle(
        Offset(bhX, bhY),
        diskR,
        Paint()
          ..color = const Color(0xFF7B61FF).withOpacity(0.06 * (5 - i) * bhOpacity)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8.0 + i * 5),
      );
    }

    // Accretion ring (elliptical)
    canvas.save();
    canvas.translate(bhX, bhY);
    canvas.rotate(0.3);
    canvas.scale(1.0, 0.35);
    for (int r = 0; r < 3; r++) {
      final ringR = bhR + 25.0 + r * 12;
      final ringPhase = (loop + r * 0.33) % 1.0;
      canvas.drawCircle(
        Offset.zero,
        ringR,
        Paint()
          ..color = Color.lerp(
            const Color(0xFFFF6B00),
            const Color(0xFF7B61FF),
            r / 3.0,
          )!.withOpacity((0.25 + sin(ringPhase * pi * 2) * 0.15) * bhOpacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5 - r * 0.5,
      );
    }
    canvas.restore();

    // Black center
    canvas.drawCircle(
      Offset(bhX, bhY),
      bhR,
      Paint()..color = const Color(0xFF020208).withOpacity(bhOpacity),
    );

    // Event horizon glow
    canvas.drawCircle(
      Offset(bhX, bhY),
      bhR + 3,
      Paint()
        ..color = const Color(0xFF7B61FF).withOpacity(0.4 * bhOpacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Gravitational lensing effect (distorted light ring)
    canvas.drawCircle(
      Offset(bhX, bhY),
      bhR + 8,
      Paint()
        ..color = const Color(0xFFFFD700).withOpacity(0.15 * bhOpacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  // ═══════════════════════════════════════════════════════════
  // AI TOOLS orbiting around blackhole
  // ═══════════════════════════════════════════════════════════
  void _drawAIToolsAroundBlackhole(Canvas canvas, Size size) {
    double toolOpacity = 0.0;
    if (timeline > 0.38 && timeline < 0.45) {
      toolOpacity = (timeline - 0.38) / 0.07;
    } else if (timeline >= 0.45 && timeline < 0.68) {
      toolOpacity = 1.0;
    } else if (timeline >= 0.68 && timeline < 0.75) {
      toolOpacity = 1.0 - (timeline - 0.68) / 0.07;
    }
    if (toolOpacity <= 0) return;

    final bhX = size.width * 0.65;
    final bhY = size.height * 0.32;

    for (int i = 0; i < 8; i++) {
      final angle = (i * pi * 2 / 8) + loop * pi * 2;
      final orbitR = 70.0 + sin(i * 0.7) * 15;
      final x = bhX + cos(angle) * orbitR;
      final y = bhY + sin(angle) * orbitR * 0.55; // elliptical orbit
      final tool = aiTools[i % aiTools.length];

      // Tool circle
      final toolAlpha = toolOpacity * (0.5 + sin(angle + loop * pi) * 0.3).clamp(0.2, 0.9);

      // Background circle
      canvas.drawCircle(
        Offset(x, y),
        14,
        Paint()
          ..color = const Color(0xFF0A0A18).withOpacity(0.8 * toolAlpha)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );

      // Border glow
      canvas.drawCircle(
        Offset(x, y),
        14,
        Paint()
          ..color = const Color(0xFF00DCE8).withOpacity(0.3 * toolAlpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );

      // We can't draw text with emoji easily in CustomPainter,
      // so draw a small glowing dot for each tool
      canvas.drawCircle(
        Offset(x, y),
        4,
        Paint()..color = Color.lerp(
          const Color(0xFF00DCE8),
          const Color(0xFF7B61FF),
          i / 8.0,
        )!.withOpacity(0.7 * toolAlpha),
      );
      canvas.drawCircle(
        Offset(x, y),
        6,
        Paint()
          ..color = const Color(0xFF00DCE8).withOpacity(0.15 * toolAlpha)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
    }
  }

  // ═══════════════════════════════════════════════════════════
  // FALCON SPACESHIP — follows journey path
  // ═══════════════════════════════════════════════════════════
  void _drawFalcon(Canvas canvas, Size size) {
    // Calculate Falcon position based on timeline
    final pos = _getFalconPosition(size);
    final angle = _getFalconAngle();
    final thrust = timeline < 0.70; // fire on during travel

    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    canvas.rotate(angle);

    // ── Thrust flame (behind rocket) ──────────────────
    if (thrust) {
      final flameLen = 18.0 + sin(loop * pi * 8) * 8;
      final flamePath = Path()
        ..moveTo(-4, 14)
        ..lineTo(0, 14 + flameLen)
        ..lineTo(4, 14)
        ..close();

      // Outer flame (orange)
      canvas.drawPath(
        flamePath,
        Paint()
          ..color = const Color(0xFFFF6B00).withOpacity(0.7)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );

      // Inner flame (yellow)
      final innerFlame = Path()
        ..moveTo(-2, 14)
        ..lineTo(0, 14 + flameLen * 0.6)
        ..lineTo(2, 14)
        ..close();
      canvas.drawPath(
        innerFlame,
        Paint()..color = const Color(0xFFFFD700).withOpacity(0.9),
      );

      // Flame glow
      canvas.drawCircle(
        Offset(0, 14 + flameLen * 0.3),
        8,
        Paint()
          ..color = const Color(0xFFFF4500).withOpacity(0.15)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
    }

    // ── Rocket body ───────────────────────────────────
    // Main body
    final bodyPath = Path()
      ..moveTo(0, -18) // nose
      ..quadraticBezierTo(8, -8, 7, 10) // right curve
      ..lineTo(-7, 10)
      ..quadraticBezierTo(-8, -8, 0, -18) // left curve
      ..close();

    canvas.drawPath(bodyPath, Paint()..color = const Color(0xFFD0D0D8));
    canvas.drawPath(
      bodyPath,
      Paint()
        ..color = const Color(0xFF1A1A2B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );

    // Red stripe
    canvas.drawLine(
      const Offset(-3, -5),
      const Offset(-3, 8),
      Paint()
        ..color = const Color(0xFFCC0000)
        ..strokeWidth = 1.5,
    );

    // Window
    canvas.drawCircle(
      const Offset(0, -6),
      3,
      Paint()..color = const Color(0xFF4FC3F7).withOpacity(0.8),
    );
    canvas.drawCircle(
      const Offset(0, -6),
      3,
      Paint()
        ..color = const Color(0xFF00DCE8).withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );

    // Fins
    final leftFin = Path()
      ..moveTo(-7, 8)
      ..lineTo(-14, 16)
      ..lineTo(-7, 14)
      ..close();
    final rightFin = Path()
      ..moveTo(7, 8)
      ..lineTo(14, 16)
      ..lineTo(7, 14)
      ..close();

    canvas.drawPath(leftFin, Paint()..color = const Color(0xFFB0B0B8));
    canvas.drawPath(rightFin, Paint()..color = const Color(0xFFB0B0B8));

    canvas.restore();
  }

  Offset _getFalconPosition(Size size) {
    final t = timeline;

    // Phase 1: Launch from Earth upward (0.0 → 0.15)
    if (t < 0.15) {
      final p = t / 0.15;
      final ex = size.width * 0.22;
      final ey = size.height * 0.62;
      return Offset(
        ex + p * (size.width * 0.3 - ex),
        ey - 30 - p * (ey - size.height * 0.25),
      );
    }

    // Phase 2: Fly toward Sun area (0.15 → 0.35)
    if (t < 0.35) {
      final p = (t - 0.15) / 0.20;
      return Offset(
        size.width * 0.3 + p * (size.width * 0.55 - size.width * 0.3),
        size.height * 0.25 + sin(p * pi) * -40,
      );
    }

    // Phase 3: Sun → Blackhole (0.35 → 0.60)
    if (t < 0.60) {
      final p = (t - 0.35) / 0.25;
      return Offset(
        size.width * 0.55 + p * (size.width * 0.65 - size.width * 0.55),
        size.height * 0.25 + p * (size.height * 0.32 - size.height * 0.25),
      );
    }

    // Phase 4: At blackhole (0.60 → 0.70)
    if (t < 0.70) {
      final p = (t - 0.60) / 0.10;
      // Spiral into blackhole
      final angle = p * pi * 2;
      final r = 40 * (1 - p);
      return Offset(
        size.width * 0.65 + cos(angle) * r,
        size.height * 0.32 + sin(angle) * r * 0.5,
      );
    }

    // Phase 5: Return to Earth (0.70 → 0.90)
    if (t < 0.90) {
      final p = (t - 0.70) / 0.20;
      return Offset(
        size.width * 0.65 - p * (size.width * 0.65 - size.width * 0.22),
        size.height * 0.32 + p * (size.height * 0.55 - size.height * 0.32),
      );
    }

    // Phase 6: Near Earth (0.90 → 1.0)
    final p = (t - 0.90) / 0.10;
    return Offset(
      size.width * 0.22 + sin(p * pi * 2) * 5,
      size.height * 0.55 + p * 5,
    );
  }

  double _getFalconAngle() {
    final t = timeline;
    if (t < 0.15) return -pi / 2 + (t / 0.15) * 0.8; // launching up → tilting right
    if (t < 0.35) return -pi / 2 + 0.8; // flying right-ish
    if (t < 0.60) return -pi / 4; // heading toward blackhole
    if (t < 0.70) return (t - 0.60) / 0.10 * pi * 2; // spiraling
    if (t < 0.90) return pi / 2 + pi / 4; // heading back down-left
    return pi / 2; // pointing down (landing)
  }

  // ═══════════════════════════════════════════════════════════
  // FLASH — when Falcon touches Blackhole
  // ═══════════════════════════════════════════════════════════
  void _drawFlash(Canvas canvas, Size size) {
    if (timeline < 0.62 || timeline > 0.72) return;

    final flashProgress = ((timeline - 0.62) / 0.10).clamp(0.0, 1.0);
    final flashAlpha = sin(flashProgress * pi) * 0.6;

    canvas.drawCircle(
      Offset(size.width * 0.65, size.height * 0.32),
      flashProgress * 150,
      Paint()
        ..color = Colors.white.withOpacity(flashAlpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}
