// lib/screens/voice_hub/widgets/thinking_dots.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ThinkingDots extends StatelessWidget {
  const ThinkingDots({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) => _dot(i)),
      ),
    );
  }

  Widget _dot(int index) {
    return Container(
      width: 7,
      height: 7,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.white.withOpacity(0.8),
            Colors.white.withOpacity(0.1),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true))
     .scaleXY(
        begin: 0.6, end: 1.3, 
        duration: 800.ms, 
        delay: (index * 250).ms, 
        curve: Curves.easeInOutQuad
      )
     .shimmer(
        duration: 2.seconds, 
        color: Colors.blueAccent.withOpacity(0.4),
      );
  }
}
