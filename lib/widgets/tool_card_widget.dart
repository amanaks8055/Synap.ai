import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';

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
    final finalUrl = _getFinalUrl();
    final borderRadius = BorderRadius.circular(26);

    return Container(
      width: 112,
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Glass icon container ──
              Container(
                width: 104,
                height: 104,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      SynapStyles.bgSecondary(context).withValues(alpha: 0.55),
                      SynapStyles.bgCard(context).withValues(alpha: 0.25),
                    ],
                  ),
                  border: Border.all(
                    color: SynapColors.accent.withValues(alpha: 0.18),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.22),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: borderRadius,
                  child: finalUrl.isEmpty
                      ? _buildFallback(context, 100)
                      : _buildNetworkImage(context, finalUrl, isSecondary: false),
                ),
              ),
              const SizedBox(height: 10),

              // ── Tool Name (Centered) ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  name,
                  style: TextStyle(
                    color: SynapStyles.textPrimary(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.15,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getFinalUrl() {
    if (imageUrl.isEmpty) return '';
    final domain = _cleanDomain(imageUrl);
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

  Widget _buildNetworkImage(BuildContext context, String url, {required bool isSecondary}) {
    return CachedNetworkImage(
      imageUrl: url,
      width: 100,
      height: 100,
      cacheKey: url, // Ensures consistent caching
      placeholder: (context, url) => _buildShimmer(),
      errorWidget: (context, url, error) {
        if (!isSecondary) {
          final domain = _cleanDomain(imageUrl);
          return _buildNetworkImage(context, _googleUrl(domain), isSecondary: true);
        }
        return _buildFallback(context, 100);
      },
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      useOldImageOnUrlChange: true, // Keep old image while loading new one
      memCacheWidth: 400,
      memCacheHeight: 400,
    );
  }

  Widget _buildShimmer() {
    return Container(
      width: 100,
      height: 100,
      color: SynapColors.bgSecondary,
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: SynapColors.accent,
        ),
      ),
    );
  }

  Widget _buildFallback(BuildContext context, double size) {
    return Container(
      width: size,
      height: size,
      color: SynapColors.bgTertiary,
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: TextStyle(
            color: SynapColors.textSecondary.withValues(alpha: 0.5),
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  String _brandUrl(String domain) => 'https://logo.clearbit.com/$domain?size=256';

  String _googleUrl(String domain) => 'https://www.google.com/s2/favicons?domain=$domain&sz=128';
}
