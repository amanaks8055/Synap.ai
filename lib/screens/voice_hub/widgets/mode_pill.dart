import 'package:flutter/material.dart';

class ModePill extends StatelessWidget {
  final String icon, label;
  final bool active;
  final VoidCallback onTap;
  
  const ModePill({
    super.key,
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: active
              ? const Color(0xFF00C8E8).withOpacity(0.08)
              : const Color(0xFF090D16),
          border: Border.all(
            color: active
                ? const Color(0xFF00C8E8).withOpacity(0.3)
                : const Color(0xFF131B27)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(
              fontFamily: 'Syne', fontSize: 13,
              fontWeight: FontWeight.w700,
              color: active
                  ? const Color(0xFF00C8E8)
                  : const Color(0xFF3A4A60))),
          ],
        ),
      ),
    ),
  );
}
