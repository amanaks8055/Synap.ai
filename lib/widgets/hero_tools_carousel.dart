import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/tool_model.dart';
import '../services/tool_service.dart';
import '../services/recommendation_service.dart';
import '../theme/app_theme.dart';

class HeroToolsCarousel extends StatefulWidget {
  const HeroToolsCarousel({super.key});

  @override
  State<HeroToolsCarousel> createState() => _HeroToolsCarouselState();
}

class _HeroToolsCarouselState extends State<HeroToolsCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.92);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final tools = ToolService.getEditorPicks();
    if (tools.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: tools.length,
            itemBuilder: (context, index) {
              final tool = tools[index];
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    value = (1 - (value.abs() * 0.1)).clamp(0.0, 1.0);
                  }
                  return Center(
                    child: SizedBox(
                      height: Curves.easeOut.transform(value) * 260,
                      width: Curves.easeOut.transform(value) * 420,
                      child: child,
                    ),
                  );
                },
                child: _HeroCard(
                  tool: tool,
                  onTap: () {
                    RecommendationService().record(tool.id, UserEvent.viewed);
                    Navigator.pushNamed(context, '/toolDetail', arguments: tool);
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        _buildPageIndicator(tools.length),
      ],
    );
  }

  Widget _buildPageIndicator(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 6,
        width: _currentPage == i ? 18 : 6,
        decoration: BoxDecoration(
          color: _currentPage == i ? SynapColors.accent : SynapColors.accent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(3),
        ),
      )),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final ToolModel tool;
  final VoidCallback onTap;

  const _HeroCard({required this.tool, required this.onTap});

  // Per-category gradient palettes for premium feel
  static const _categoryGradients = <String, List<Color>>{
    'chat':       [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
    'code':       [Color(0xFF0D1117), Color(0xFF161B22), Color(0xFF1A2332)],
    'image':      [Color(0xFF1A0A2E), Color(0xFF2D1B4E), Color(0xFF1A1040)],
    'writing':    [Color(0xFF1B2838), Color(0xFF1E3A5F), Color(0xFF0A1628)],
    'video':      [Color(0xFF2A0A0A), Color(0xFF3D1515), Color(0xFF1A0808)],
    'design':     [Color(0xFF0A1A2A), Color(0xFF0F2940), Color(0xFF081420)],
    'automation': [Color(0xFF0A2A1A), Color(0xFF0F4028), Color(0xFF081E12)],
    'research':   [Color(0xFF1A1A0A), Color(0xFF2A2A10), Color(0xFF14140A)],
    'marketing':  [Color(0xFF2A1A0A), Color(0xFF3D2510), Color(0xFF1E1208)],
    'audio':      [Color(0xFF1A0A1A), Color(0xFF2E102E), Color(0xFF140A14)],
  };

  static const _categoryAccents = <String, Color>{
    'chat':       Color(0xFF00E5FF),
    'code':       Color(0xFF58A6FF),
    'image':      Color(0xFFBB86FC),
    'writing':    Color(0xFF64FFDA),
    'video':      Color(0xFFFF6B6B),
    'design':     Color(0xFF00B4D8),
    'automation': Color(0xFF22C55E),
    'research':   Color(0xFFFFD93D),
    'marketing':  Color(0xFFF97316),
    'audio':      Color(0xFFE879F9),
  };

  @override
  Widget build(BuildContext context) {
    final catId = tool.categoryId;
    final gradientColors = _categoryGradients[catId] ?? _categoryGradients['chat']!;
    final accentColor = _categoryAccents[catId] ?? const Color(0xFF00E5FF);
    final iconUrl = _resolveIconUrl();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          border: Border.all(
            color: accentColor.withOpacity(0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // ── Accent glow orbs (aurora effect) ──────────
              Positioned(
                top: -30,
                right: -20,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        accentColor.withOpacity(0.2),
                        accentColor.withOpacity(0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -40,
                left: -30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        accentColor.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // ── Subtle dot pattern overlay ────────────────
              Positioned.fill(
                child: CustomPaint(
                  painter: _DotPatternPainter(accentColor.withOpacity(0.04)),
                ),
              ),

              // ── Main content ──────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    // ── Left: text content ──────────────────
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Category pill
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: accentColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: accentColor.withOpacity(0.2), width: 0.5),
                            ),
                            child: Text(
                              'EDITOR\'S PICK • ${tool.category.label.toUpperCase()}',
                              style: GoogleFonts.dmSans(
                                color: accentColor,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Tool name
                          Text(
                            tool.name,
                            style: GoogleFonts.syne(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              height: 1.1,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          // Description
                          Text(
                            tool.description,
                            style: GoogleFonts.dmSans(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          // Rating + pricing row
                          Row(
                            children: [
                              Icon(Icons.star_rounded, color: Colors.amber.shade400, size: 14),
                              const SizedBox(width: 3),
                              Text(
                                tool.rating.toStringAsFixed(1),
                                style: GoogleFonts.dmSans(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 10),
                              if (tool.hasFreeTier)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF22C55E).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'FREE',
                                    style: GoogleFonts.dmSans(
                                      color: const Color(0xFF22C55E),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // ── Right: icon showcase ────────────────
                    _buildIconShowcase(iconUrl, accentColor),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconShowcase(String? iconUrl, Color accentColor) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withOpacity(0.07),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // Glass bg
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.03),
                  ],
                ),
              ),
            ),
            // Icon
            Center(
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: iconUrl != null
                      ? CachedNetworkImage(
                          imageUrl: iconUrl,
                          fit: BoxFit.contain,
                          memCacheWidth: 208,
                          memCacheHeight: 208,
                          filterQuality: FilterQuality.high,
                          placeholder: (_, __) => _iconFallback(accentColor),
                          errorWidget: (_, __, ___) => _iconFallback(accentColor),
                        )
                      : _iconFallback(accentColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconFallback(Color accentColor) {
    return Container(
      color: accentColor.withOpacity(0.1),
      child: Center(
        child: Text(
          tool.name.isNotEmpty ? tool.name[0].toUpperCase() : '?',
          style: GoogleFonts.syne(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: accentColor,
          ),
        ),
      ),
    );
  }

  /// Resolve icon URL using gstatic favicon (same pattern as ToolIcon)
  String? _resolveIconUrl() {
    if (tool.thumbnailUrl.isNotEmpty &&
        tool.thumbnailUrl.startsWith('http') &&
        !tool.thumbnailUrl.contains('logo.clearbit.com')) {
      return tool.thumbnailUrl;
    }
    if (tool.iconUrl.isNotEmpty &&
        tool.iconUrl.startsWith('http') &&
        !tool.iconUrl.contains('logo.clearbit.com')) {
      return tool.iconUrl;
    }
    final domain = _resolveDomain();
    if (domain != null && domain.isNotEmpty) {
      return 'https://t3.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=http://$domain&size=256';
    }
    return null;
  }

  String? _resolveDomain() {
    if (tool.iconUrl.contains('logo.clearbit.com')) {
      try {
        final uri = Uri.parse(tool.iconUrl);
        if (uri.pathSegments.isNotEmpty) {
          String d = uri.pathSegments.last.split('?').first;
          if (d.startsWith('www.')) d = d.replaceFirst('www.', '');
          if (d.isNotEmpty) return d;
        }
      } catch (_) {}
    }
    if (tool.websiteUrl.isNotEmpty) {
      try {
        String d = Uri.parse(tool.websiteUrl).host;
        if (d.startsWith('www.')) d = d.replaceFirst('www.', '');
        if (d.isNotEmpty) return d;
      } catch (_) {}
    }
    return null;
  }
}

// ── Subtle dot grid pattern for premium texture ─────────────
class _DotPatternPainter extends CustomPainter {
  final Color color;
  _DotPatternPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    const spacing = 20.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 0.8, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
