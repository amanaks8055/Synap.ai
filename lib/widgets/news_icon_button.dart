// ══════════════════════════════════════════════════════════════
// SYNAP — NewsIconButton
// Globe news logo with pulsing red dot for unread
// ══════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../services/news_service.dart';

class NewsIconButton extends StatefulWidget {
  final VoidCallback onTap;

  const NewsIconButton({super.key, required this.onTap});

  @override
  State<NewsIconButton> createState() => _NewsIconButtonState();
}

class _NewsIconButtonState extends State<NewsIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ── User-provided news logo ──
            Container(
              width: 46,
              height: 46,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF00E8FF).withOpacity(0.35),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E8FF).withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Image.asset(
                  'assets/image.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.article_rounded,
                    color: Colors.white,
                    size: 19,
                  ),
                ),
              ),
            ),

            // ── Pulsing Red Dot (unread indicator) ──
            ValueListenableBuilder<int>(
              valueListenable: NewsService.unreadCount,
              builder: (context, unread, _) {
                if (unread == 0) return const SizedBox.shrink();

                return Positioned(
                  top: -3,
                  right: -3,
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      final scale = 1.0 + (_pulseController.value * 0.2);
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF3B30),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF3B30).withValues(alpha: 0.4),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              unread > 9 ? '9+' : '$unread',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
