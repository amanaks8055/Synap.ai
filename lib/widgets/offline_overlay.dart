// ══════════════════════════════════════════════════════════════
// SYNAP — Offline Overlay Widget
// Shows WiFi offline message at bottom of screen
// ══════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../services/connectivity_service.dart';

class OfflineOverlay extends StatefulWidget {
  final Widget child;

  const OfflineOverlay({super.key, required this.child});

  @override
  State<OfflineOverlay> createState() => _OfflineOverlayState();
}

class _OfflineOverlayState extends State<OfflineOverlay> {
  bool _showOverlay = false;
  bool _isRetrying = false;
  DateTime? _overlayShownAt;
  DateTime? _lastRecoveryToastAt;

  @override
  void initState() {
    super.initState();
    ConnectivityService.isOnline.addListener(_onConnectivityChanged);
    // Initial check
    Future.microtask(() async {
      final connected = await ConnectivityService.isConnected();
      if (!connected && mounted) {
        setState(() => _showOverlay = true);
      }
    });
  }

  @override
  void dispose() {
    ConnectivityService.isOnline.removeListener(_onConnectivityChanged);
    super.dispose();
  }

  void _onConnectivityChanged() {
    final isOnline = ConnectivityService.isOnline.value;
    if (!isOnline && !_showOverlay) {
      _overlayShownAt = DateTime.now();
      setState(() => _showOverlay = true);
    } else if (isOnline && _showOverlay) {
      setState(() => _showOverlay = false);

      // Show recovery only when offline state was visible for a moment,
      // otherwise transient network jitters become noisy.
      final shownFor = _overlayShownAt == null
          ? const Duration(seconds: 0)
          : DateTime.now().difference(_overlayShownAt!);

      final now = DateTime.now();
      final recentlyShown = _lastRecoveryToastAt != null &&
          now.difference(_lastRecoveryToastAt!) < const Duration(seconds: 12);

      if (shownFor >= const Duration(seconds: 2) && !recentlyShown) {
        _lastRecoveryToastAt = now;
        _showRecoveryMessage();
      }
    }
  }

  Future<void> _retry() async {
    setState(() => _isRetrying = true);
    await ConnectivityService.retry();
    if (mounted) setState(() => _isRetrying = false);
  }

  void _showRecoveryMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF00C851),
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Text('Internet Connected ✓',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showOverlay)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildOfflineBar(),
          ),
      ],
    );
  }

  Widget _buildOfflineBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        border: Border(
          top: BorderSide(
              color: const Color(0xFFFF3B30).withOpacity(0.3), width: 2),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF3B30).withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // WiFi icon with pulse animation
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFF3B30).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(
                Icons.wifi_off_rounded,
                color: Color(0xFFFF3B30),
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'You are Offline',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Check your WiFi or mobile data',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Retry button
          GestureDetector(
            onTap: _isRetrying ? null : _retry,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF3B30).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFFF3B30).withOpacity(0.4),
                  width: 1,
                ),
              ),
              child: _isRetrying
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(
                            Colors.white.withOpacity(0.6)),
                      ),
                    )
                  : const Text(
                      'Retry',
                      style: TextStyle(
                        color: Color(0xFFFF3B30),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
