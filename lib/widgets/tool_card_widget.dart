import 'package:flutter/material.dart';

class ToolCardWidget extends StatelessWidget {
  final String name;
  final String imageUrl; // This is actually the tool logo/domain from the model
  final String badge;
  final double rating;
  final VoidCallback onTap;

  const ToolCardWidget({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.badge,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isFree = badge.toUpperCase() == 'FREE';
    final finalUrl = _getFinalUrl();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110, // Width for the avatar + padding
        margin: const EdgeInsets.only(right: 12),
        decoration: const BoxDecoration(
          color: Colors.transparent, // Floating style
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center everything
          children: [
            // ── Large Squircle Icon (Poe style) ──
            ClipRRect(
              borderRadius: BorderRadius.circular(28), // Deep squircle rounding
              child: finalUrl.isEmpty
                  ? _buildFallback(context, 100)
                  : _buildNetworkImage(context, finalUrl, isSecondary: false),
            ),

            const SizedBox(height: 10),

            // ── Tool Name (Centered) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFinalUrl() {
    if (imageUrl.isEmpty) return '';
    final domain = _cleanDomain(imageUrl);
    return _brandUrl(domain);
  }

  String _cleanDomain(String raw) {
    String domain = raw;
    if (raw.startsWith('http')) {
      try {
        final uri = Uri.parse(raw);
        if (raw.contains('logo.clearbit.com')) {
          domain = uri.pathSegments.last;
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

  Widget _buildNetworkImage(BuildContext context, String url, {required bool isSecondary}) {
    return Image.network(
      url,
      width: 100,
      height: 100,
      cacheWidth: 200, // 2x for sharp but safe memory usage
      cacheHeight: 200,
      filterQuality: FilterQuality.medium, // Balanced quality for stability
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) {
          return Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8), // Reduced padding to make logo larger
            child: child,
          );
        }
        return _buildShimmer();
      },
      errorBuilder: (context, error, stackTrace) {
        if (!isSecondary) {
          final domain = _cleanDomain(imageUrl);
          return _buildNetworkImage(context, _googleUrl(domain), isSecondary: true);
        }
        return _buildFallback(context, 100);
      },
    );
  }

  Widget _buildShimmer() {
    return Container(
      width: 100,
      height: 100,
      color: const Color(0xFF1A1A2E),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xFF7B61FF),
        ),
      ),
    );
  }

  Widget _buildFallback(BuildContext context, double size) {
    return Container(
      width: size,
      height: size,
      color: const Color(0xFF2A2A3E),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(color: Colors.white38, fontSize: 32, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  String _brandUrl(String domain) => 'https://logo.clearbit.com/$domain?size=256'; // Stable 256px resolution

  String _googleUrl(String domain) => 'https://www.google.com/s2/favicons?domain=$domain&sz=128';
}
