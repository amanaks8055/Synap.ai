import 'package:flutter/material.dart';

/// Play Store safe tool icon — uses gradient + first letter as default.
/// Gracefully handles network logos with white backgrounds only when loaded.
class ToolIcon extends StatelessWidget {
  final String name;
  final String categoryId;
  final String iconUrl;
  final String iconEmoji;
  final double size;
  final double fontSize;
  final double radius;

  const ToolIcon({
    super.key,
    required this.name,
    required this.categoryId,
    this.iconUrl = '',
    this.iconEmoji = '',
    this.size = 48,
    this.fontSize = 20,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final String finalUrl = _getFinalUrl();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: finalUrl.isEmpty
            ? _buildPlaceholder()
            : _buildNetworkImage(finalUrl, isSecondary: false),
      ),
    );
  }

  String _getFinalUrl() {
    if (iconUrl.isEmpty) return '';
    final domain = _cleanDomain(iconUrl);
    if (domain.isEmpty) return '';
    return _brandUrl(domain);
  }

  String _cleanDomain(String raw) {
    String domain = raw;
    if (raw.startsWith('http')) {
      try {
        final uri = Uri.parse(raw);
        if (raw.contains('logo.clearbit.com')) {
          final segs = uri.pathSegments.where((e) => e.isNotEmpty).toList();
          domain = segs.isNotEmpty ? segs.last : '';
        } else {
          domain = uri.host;
        }
      } catch (_) {}
    }
    domain = domain
        .replaceAll('https://', '')
        .replaceAll('http://', '')
        .split('/')
        .first;
    if (domain.startsWith('www.')) domain = domain.replaceFirst('www.', '');
    return domain;
  }

  String _brandUrl(String domain) =>
      'https://logo.clearbit.com/$domain?size=256';

  Widget _buildNetworkImage(String url, {required bool isSecondary}) {
    if (url.isEmpty) return _buildPlaceholder();

    return Image.network(
      url,
      fit: BoxFit.contain,
      cacheWidth:
          (size * 4).toInt(), // 4x for extreme sharpness on high-res displays
      cacheHeight: (size * 4).toInt(),
      filterQuality: FilterQuality.high,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return Container(
            color: Colors.white,
            padding: EdgeInsets.all(size * 0.15),
            child: child,
          );
        }
        return Center(
          child: SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: Colors.white.withValues(alpha: 0.5)),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        if (!isSecondary) {
          final domain = _cleanDomain(iconUrl);
          return _buildNetworkImage(_googleUrl(domain), isSecondary: true);
        }
        return Container(
          color: Colors.white.withValues(alpha: 0.05),
          child: Center(
            child: Icon(Icons.broken_image_rounded,
                size: size * 0.4, color: Colors.white24),
          ),
        );
      },
    );
  }

  String _googleUrl(String domain) =>
      'https://www.google.com/s2/favicons?domain=$domain&sz=128';

  Widget _buildPlaceholder() {
    final display = iconEmoji.isNotEmpty
        ? iconEmoji
        : (name.isNotEmpty ? name[0].toUpperCase() : '?');
    return Center(
      child: Text(
        display,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.5),
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          fontFamily: 'Syne',
        ),
      ),
    );
  }
}
