import 'dart:ui';
import 'package:flutter/material.dart';

/// ═══════════════════════════════════════════════════════════════
/// SYNAP — MOVING BORDER BUTTON
/// Inspired by Aceternity UI. High-energy animated glow border.
/// ═══════════════════════════════════════════════════════════════

class SynapMovingBorderButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double borderRadius;
  final double borderWidth;
  final Duration duration;
  final Color glowColor;
  final Color backgroundColor;
  final EdgeInsets padding;
  final bool isAnimating;
  final double? width;
  final double? height;

  const SynapMovingBorderButton({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = 16,
    this.borderWidth = 1.5,
    this.duration = const Duration(seconds: 3),
    this.glowColor = const Color(0xFF6C63FF),
    this.backgroundColor = const Color(0xFF0D1420),
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.isAnimating = true,
    this.width,
    this.height,
  });

  @override
  State<SynapMovingBorderButton> createState() => _SynapMovingBorderButtonState();
}

class _SynapMovingBorderButtonState extends State<SynapMovingBorderButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(SynapMovingBorderButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      if (widget.isAnimating) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: widget.width,
          height: widget.height,
          padding: const EdgeInsets.all(1.5), // Space for the border glow
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: Colors.transparent,
          ),
          child: Stack(
            children: [
              // 1. Moving Glow Layer
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: AnimatedOpacity(
                    opacity: widget.isAnimating ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: _MovingBorderPainter(
                        progress: _controller,
                        glowColor: widget.glowColor,
                        borderWidth: widget.borderWidth,
                        borderRadius: widget.borderRadius,
                      ),
                    ),
                  ),
                ),
              ),

              // 2. Inner Content
              Container(
                width: widget.width,
                height: widget.height,
                margin: EdgeInsets.all(widget.borderWidth),
                padding: widget.padding,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius - 1),
                  color: widget.backgroundColor,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.05),
                    width: 0.5,
                  ),
                ),
                child: Center(child: widget.child),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MovingBorderPainter extends CustomPainter {
  final Animation<double> progress;
  final Color glowColor;
  final double borderWidth;
  final double borderRadius;

  _MovingBorderPainter({
    required this.progress,
    required this.glowColor,
    required this.borderWidth,
    required this.borderRadius,
  }) : super(repaint: progress);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final rect = Offset.zero & size;
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    // The glowing tail is drawn as a SweepGradient
    final sweepGradient = SweepGradient(
      colors: [
        Colors.transparent,
        glowColor.withOpacity(0.5),
        glowColor,
        Colors.white, // Head of the glow
        Colors.transparent,
      ],
      stops: const [0.0, 0.2, 0.45, 0.5, 0.51],
      transform: GradientRotation(progress.value * 2 * 3.141592653589793),
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth * 2.5
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
      ..shader = sweepGradient.createShader(rect);

    // Draw the main glowing border
    canvas.drawRRect(rRect, paint);
    
    // Draw an inner solid crisp head
    final headGradient = SweepGradient(
      colors: [
        Colors.transparent,
        Colors.transparent,
        Colors.white.withOpacity(0.6),
        Colors.white,
        Colors.transparent,
      ],
      stops: const [0.0, 0.45, 0.49, 0.5, 0.505],
      transform: GradientRotation(progress.value * 2 * 3.141592653589793),
    );
    
    final corePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round
      ..shader = headGradient.createShader(rect);
      
    canvas.drawRRect(rRect, corePaint);
  }

  @override
  bool shouldRepaint(_MovingBorderPainter oldDelegate) => true;
}
