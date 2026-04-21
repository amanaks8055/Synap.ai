// lib/screens/voice_hub/widgets/waveform_bars.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

class WaveformBars extends StatefulWidget {
  const WaveformBars({super.key});

  @override
  State<WaveformBars> createState() => _WaveformBarsState();
}

class _WaveformBarsState extends State<WaveformBars> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(30, (index) {
            // Siri/Google style mirror oscillation
            final normalizedIndex = (index - 15).abs() / 15;
            final t = _controller.value;
            final phase = (t + index * 0.05) % 1.0;
            
            // Central bars are taller
            final baseAmplitude = 24.0 * (1.0 - normalizedIndex * 0.7);
            final height = 4.0 + (baseAmplitude * math.sin(phase * 2 * math.pi).abs());
            
            return Container(
              width: 2.5,
              height: height,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.lerp(Colors.blueAccent, Colors.purpleAccent, normalizedIndex)!,
                    Color.lerp(Colors.purpleAccent, Colors.pinkAccent, normalizedIndex)!.withOpacity(0.4),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.lerp(Colors.blueAccent, Colors.purpleAccent, normalizedIndex)!.withOpacity(0.2),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
