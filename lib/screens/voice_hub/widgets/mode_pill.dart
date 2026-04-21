// lib/screens/voice_hub/widgets/mode_pill.dart
import 'package:flutter/material.dart';

class ModePill extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  final IconData icon;

  const ModePill({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: active ? Colors.white.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: active ? Colors.white24 : Colors.white.withOpacity(0.05),
          ),
          boxShadow: active 
            ? [BoxShadow(color: Colors.white.withOpacity(0.02), blurRadius: 10)] 
            : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon, 
              size: 16, 
              color: active ? Colors.white : Colors.white38
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : Colors.white38,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
