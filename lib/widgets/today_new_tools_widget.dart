
// ══════════════════════════════════════════════════════════════
// SYNAP — TodayNewToolsWidget
// Horizontal scroll section showing today's newly added AI tools
// FIXED: CachedNetworkImage + favicon chain (no dead Clearbit)
// ══════════════════════════════════════════════════════════════

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/tool_model.dart';
import '../services/tool_service.dart';
import '../services/recommendation_service.dart';
import '../theme/app_theme.dart';

/// Category-based placeholder colors
const Map<String, Color> _catColors = {
  'code': Color(0xFF1E3A5F),
  'video': Color(0xFF3D1A1A),
  'writing': Color(0xFF1A3D2B),
  'chat': Color(0xFF2D1B4E),
  'image': Color(0xFF3D2800),
  'productivity': Color(0xFF1A2D1A),
  'research': Color(0xFF1A2D1A),
  'seo': Color(0xFF3D3D00),
  'marketing': Color(0xFF3D3D00),
  'business': Color(0xFF1A1A3D),
  'finance': Color(0xFF1A1A3D),
  'audio': Color(0xFF2D1B4E),
  'automation': Color(0xFF1E3A5F),
  'design': Color(0xFF3D2800),
  'education': Color(0xFF1A3D2B),
  'healthcare': Color(0xFF3D1A1A),
  'legal': Color(0xFF1A1A3D),
  'security': Color(0xFF1E3A5F),
  'data': Color(0xFF2D1B4E),
  'fun': Color(0xFF3D2800),
  'hr': Color(0xFF1A3D2B),
};

class TodayNewToolsWidget extends StatelessWidget {
  const TodayNewToolsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = ToolService.getTodayTools();
    if (tools.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  SynapColors.accent.withOpacity(0.12),
                  SynapStyles.bgSecondary(context).withOpacity(0.34),
                ],
              ),
              border: Border.all(
                color: SynapColors.accent.withOpacity(0.22),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: SynapColors.accent.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: SynapColors.accent.withOpacity(0.2),
                    border: Border.all(
                      color: SynapColors.accent.withOpacity(0.45),
                      width: 0.8,
                    ),
                  ),
                  child: const Icon(Icons.travel_explore_rounded,
                      size: 18, color: SynapColors.accent),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Worldwide Discoveries',
                        style: GoogleFonts.syne(
                          color: SynapColors.accent,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.25,
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'New Launch',
                        style: GoogleFonts.dmSans(
                          color: SynapStyles.textMuted(context),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                          height: 1.12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: SynapColors.accent.withOpacity(0.12),
                    border: Border.all(
                      color: SynapColors.accent.withOpacity(0.38),
                      width: 0.9,
                    ),
                  ),
                  child: Text(
                    'DAILY',
                    style: GoogleFonts.dmSans(
                      color: SynapColors.accent,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.65,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 238,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: tools.length,
            itemBuilder: (context, index) {
              final tool = tools[index];
              return _TodayToolCard(
                tool: tool,
                onTap: () {
                  RecommendationService().record(tool.id, UserEvent.viewed);
                  Navigator.pushNamed(context, '/toolDetail', arguments: tool);
                },
              );
            },
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

// ── Individual Tool Card ──────────────────────────────────────
class _TodayToolCard extends StatelessWidget {
  final ToolModel tool;
  final VoidCallback onTap;

  const _TodayToolCard({required this.tool, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(22);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 182,
        margin: const EdgeInsets.only(right: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              SynapStyles.bgSecondary(context).withOpacity(0.35),
              SynapStyles.bgSecondary(context).withOpacity(0.15),
            ],
          ),
          border: Border.all(
            color: SynapColors.accent.withOpacity(0.14),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: SynapColors.accent.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: SynapColors.accent.withOpacity(0.4),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    'NEW',
                    style: GoogleFonts.dmSans(
                      color: SynapColors.accent,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(Icons.bolt_rounded,
                    color: SynapColors.accent.withOpacity(0.85), size: 16),
              ],
            ),
            const SizedBox(height: 10),

            // ── Tool Icon / Thumbnail ──
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: _getCatColor().withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: _buildToolImage(size: 72),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ── Tool Name ──
            Text(
              tool.name,
              style: TextStyle(
                color: SynapStyles.textPrimary(context),
                fontSize: 14,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            Text(
              tool.description,
              style: TextStyle(
                color: SynapStyles.textMuted(context).withOpacity(0.92),
                fontSize: 11,
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),

            // ── Category badge ──
            Row(
              children: [
                Flexible(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCatColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      tool.category.label.toUpperCase(),
                      style: TextStyle(
                        color: _getCatColor().withOpacity(0.95),
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.open_in_new_rounded,
                  color: SynapStyles.textMuted(context),
                  size: 13,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolImage({double size = 50}) {
    final url = _resolveIconUrl();
    if (url == null) return _buildPlaceholder(size: size);

    return CachedNetworkImage(
      imageUrl: url,
      width: size,
      height: size,
      memCacheWidth: (size * 4).toInt(),
      memCacheHeight: (size * 4).toInt(),
      filterQuality: FilterQuality.high,
      fit: BoxFit.cover,
      imageBuilder: (context, imageProvider) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(6),
        child: Image(image: imageProvider, fit: BoxFit.contain),
      ),
      placeholder: (context, url) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: _getCatColor(),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: Colors.white38),
          ),
        ),
      ),
      errorWidget: (context, url, error) =>
          _buildFallbackOrPlaceholder(size: size),
    );
  }

  /// Try original icon URL as fallback before showing letter placeholder
  Widget _buildFallbackOrPlaceholder({double size = 50}) {
    final fallback =
        (tool.iconUrl.isNotEmpty && tool.iconUrl.startsWith('http'))
            ? tool.iconUrl
            : null;
    if (fallback == null) return _buildPlaceholder(size: size);

    return Image.network(
      fallback,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stack) => _buildPlaceholder(size: size),
      loadingBuilder: (context, child, progress) {
        if (progress == null) {
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(6),
            child: child,
          );
        }
        return _buildPlaceholder(size: size);
      },
    );
  }

  /// Determine best URL to load upfront (no nested fallbacks)
  String? _resolveIconUrl() {
    // Check if a URL is valid and not a Product Hunt / Clearbit URL
    bool _isUsable(String url) {
      if (url.isEmpty || !url.startsWith('http')) return false;
      if (url.contains('logo.clearbit.com')) return false;
      if (url.contains('producthunt.com')) return false;
      return true;
    }

    // 1. thumbnailUrl (highest quality)
    if (_isUsable(tool.thumbnailUrl)) return tool.thumbnailUrl;

    // 2. Check ToolService for PH thumbnail (set during fetchTodayTools)
    final phThumb = ToolService.getTodayToolThumbnail(tool.name);
    if (phThumb != null && _isUsable(phThumb)) return phThumb;

    // 3. iconUrl
    if (_isUsable(tool.iconUrl)) return tool.iconUrl;

    // 4. Google Favicon V2 — skip producthunt.com domain
    String? domain = _domainFrom(tool.iconUrl) ?? _domainFrom(tool.websiteUrl);
    if (domain != null && domain.contains('producthunt.com')) domain = null;
    if (domain != null && domain.isNotEmpty) return _faviconUrl(domain);

    return null;
  }

  Color _getCatColor() {
    return _catColors[tool.categoryId.toLowerCase()] ?? const Color(0xFF2D1B4E);
  }

  Widget _buildPlaceholder({double size = 50}) {
    final catColor = _getCatColor();
    final lighterColor = Color.lerp(catColor, Colors.white, 0.18) ?? catColor;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [lighterColor, catColor],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          tool.name.isNotEmpty ? tool.name[0].toUpperCase() : '?',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.42,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  String? _domainFrom(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    if (raw.contains('logo.clearbit.com')) {
      try {
        final uri = Uri.parse(raw);
        if (uri.pathSegments.isNotEmpty) {
          String d = uri.pathSegments.last.split('?').first;
          if (d.startsWith('www.')) d = d.replaceFirst('www.', '');
          return d.isNotEmpty ? d : null;
        }
      } catch (_) {}
      final match = RegExp(r'clearbit\.com/([^?]+)').firstMatch(raw);
      return match?.group(1);
    }
    String domain = raw;
    if (raw.startsWith('http')) {
      try {
        domain = Uri.parse(raw).host;
      } catch (_) {}
    }
    domain = domain
        .replaceAll('https://', '')
        .replaceAll('http://', '')
        .split('/')
        .first;
    if (domain.startsWith('www.')) domain = domain.replaceFirst('www.', '');
    return domain.isNotEmpty ? domain : null;
  }

  /// Direct Google Favicon V2 URL — returns 200 immediately (no 301 redirect)
  String _faviconUrl(String domain) =>
      'https://t3.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=http://$domain&size=256';
}
