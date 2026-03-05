import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'moving_border_button.dart';
import 'ai_loader.dart';
import '../theme/app_theme.dart';

class MicFAB extends StatefulWidget {
  final VoidCallback onTap;
  const MicFAB({super.key, required this.onTap});
  @override
  State<MicFAB> createState() => _MicFABState();
}

class _MicFABState extends State<MicFAB> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
        builder: (_, __) => Stack(alignment: Alignment.center, children: [
          // Outer pulse ring
          Transform.scale(
            scale: 1.0 + 0.2 * _ctrl.value,
            child: Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: SynapColors.accent.withOpacity(0.2),
                boxShadow: [
                  BoxShadow(color: SynapColors.accent.withOpacity(0.3), blurRadius: 15),
                ],
              ),
            ),
          ),
          // Main Button with Moving Border
          SynapMovingBorderButton(
            onTap: () {
              HapticFeedback.mediumImpact();
              widget.onTap();
            },
            borderRadius: 36, // Circular
            width: 54,
            height: 54,
            backgroundColor: const Color(0xFF00C8E8),
            glowColor: Colors.white,
            duration: const Duration(seconds: 2),
            padding: EdgeInsets.zero,
            child: const SynapAiLoader(
              size: 54,
              text: '', // No text for FAB
            ),
          ),
        ]),
      );
  }
}
