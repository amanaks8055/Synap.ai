import 'dart:math';
import 'package:flutter/material.dart';

class WaveformBars extends StatelessWidget {
  final double value;
  const WaveformBars({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final heights = [8.0, 16, 24, 32, 38, 30, 22, 14, 8, 18, 28, 36, 26, 16, 8];
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: heights.asMap().entries.map((e) {
        final phase = (value + e.key * 0.07) % 1.0;
        final h = e.value * (0.4 + 0.6 * sin(phase * pi));
        return Container(
          width: 3, height: h,
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: const Color(0xFF00C8E8).withOpacity(0.7),
          ),
        );
      }).toList(),
    );
  }
}
