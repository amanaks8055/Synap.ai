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

              // 2. Inner Content + Glass effect
              Container(
                width: widget.width,
                height: widget.height,
                margin: const EdgeInsets.all(0.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius - 1),
                  color: widget.backgroundColor.withOpacity(0.8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.borderRadius - 1),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: widget.padding,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(widget.borderRadius - 1),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.05),
                          width: 0.5,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.05),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Center(child: widget.child),
                    ),
                  ),
                ),
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
    final rect = Offset.zero & size;
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    final path = Path()..addRRect(rRect);

    final metricsList = path.computeMetrics().toList();
    if (metricsList.isEmpty) return;
    final metrics = metricsList.first;
    final totalLength = metrics.length;
    if (totalLength <= 0) return;

    final currentPos = (progress.value * totalLength).clamp(0.0, totalLength);

    // We draw a small trailing glow
    final glowLength = totalLength * 0.2; // 20% of the path is glowing
    
    Path extract;
    if (currentPos + glowLength <= totalLength) {
      extract = metrics.extractPath(currentPos, currentPos + glowLength);
    } else {
      // Handle the wrapping around the end of path
      extract = metrics.extractPath(currentPos, totalLength);
      extract.addPath(metrics.extractPath(0, (currentPos + glowLength) % totalLength), Offset.zero);
    }

    final tangent = metrics.getTangentForOffset(currentPos);
    if (tangent == null) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth * 4
      ..strokeCap = StrokeCap.round
      ..shader = RadialGradient(
        colors: [
          glowColor,
          glowColor.withOpacity(0.5),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(
        Rect.fromCircle(
          center: tangent.position,
          radius: glowLength / 2,
        ),
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawPath(extract, paint);
    
    // Core highlight
    final corePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withOpacity(0.8);
    
    canvas.drawPath(extract, corePaint);
  }

  @override
  bool shouldRepaint(_MovingBorderPainter oldDelegate) => true;
}
