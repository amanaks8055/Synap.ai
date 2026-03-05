import 'package:flutter/material.dart';
import '../../../models/voice_tool_model.dart';

class ToolResultCard extends StatelessWidget {
  final VoiceToolModel tool;
  const ToolResultCard({super.key, required this.tool});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: const Color(0xFF0C1019),
      border: Border.all(color: const Color(0xFF131B27)),
    ),
    child: Row(children: [
      Container(
        width: 46, height: 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF090D16),
          border: Border.all(color: const Color(0xFF1A2336)),
        ),
        child: Center(child: Text(tool.emoji,
          style: const TextStyle(fontSize: 22))),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tool.name, style: const TextStyle(
            fontFamily: 'Syne', fontSize: 14,
            fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 3),
          Text(tool.description, style: const TextStyle(
            fontFamily: 'DM Sans', fontSize: 11,
            color: Color(0xFF7A8FA8), height: 1.4),
            maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: tool.isFree
                    ? const Color(0xFF00D68F).withOpacity(0.1)
                    : const Color(0xFF00C8E8).withOpacity(0.08),
                border: Border.all(
                  color: tool.isFree
                      ? const Color(0xFF00D68F).withOpacity(0.25)
                      : const Color(0xFF00C8E8).withOpacity(0.2)),
              ),
              child: Text(
                tool.isFree ? 'FREE' : 'FREE TIER',
                style: TextStyle(fontFamily: 'DM Sans', fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: tool.isFree
                      ? const Color(0xFF00D68F)
                      : const Color(0xFF00C8E8),
                  letterSpacing: 0.4)),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xFF131B27),
              ),
              child: Text(tool.category, style: const TextStyle(
                fontFamily: 'DM Sans', fontSize: 9,
                color: Color(0xFF3A4A60),
                fontWeight: FontWeight.w600)),
            ),
          ]),
        ],
      )),
      const Icon(Icons.arrow_forward_ios,
        color: Color(0xFF2E3E54), size: 12),
    ]),
  );
}
