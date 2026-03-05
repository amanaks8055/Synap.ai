import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/tracker/tracker_bloc.dart';
import '../../blocs/tracker/tracker_event.dart';
import '../../blocs/tracker/tracker_state.dart';
import '../../blocs/theme/theme_bloc.dart';
import '../../models/tracker_tool.dart';
import '../../theme/app_theme.dart';
import '../../widgets/maintenance_banner.dart';

class FreeTierTrackerScreen extends StatefulWidget {
  const FreeTierTrackerScreen({super.key});
  @override
  State<FreeTierTrackerScreen> createState() => _FreeTierTrackerScreenState();
}

class _FreeTierTrackerScreenState extends State<FreeTierTrackerScreen> with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(reverse: true);
    _tick = Timer.periodic(const Duration(seconds: 1), (_) { if (mounted) setState(() {}); });
  }

  @override
  void dispose() { _pulseCtrl.dispose(); _tick?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeBloc>().state.isDark;
    return BlocConsumer<TrackerBloc, TrackerState>(
      listenWhen: (p, c) => c.alertToolId != null && p.alertToolId != c.alertToolId,
      listener: (ctx, state) {
        if (state.alertToolId == null) return;
        final tool = state.tools.firstWhere((t) => t.id == state.alertToolId, orElse: () => state.tools.first);
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(tool.isExhausted ? '🔴 ${tool.name} limit reached! Switch to ${tool.switchTo}' : '⚠️ ${tool.name} running low'),
          backgroundColor: tool.isExhausted ? const Color(0xFF3D0011) : const Color(0xFF2D1B00),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ));
      },
      builder: (ctx, state) => Scaffold(
        backgroundColor: isDark ? const Color(0xFF0A0E17) : SynapColors.bgPrimaryLight,
        body: SafeArea(child: Column(children: [
          const MaintenanceBanner(),
          _topBar(ctx, isDark),
          Expanded(child: state.status == TrackerStatus.loading
            ? const Center(child: CircularProgressIndicator(color: SynapColors.accent))
            : ListView(physics: const BouncingScrollPhysics(), padding: const EdgeInsets.fromLTRB(16, 6, 16, 100), children: [
                _summaryRow(state, isDark),
                const SizedBox(height: 16),
                if (state.bestToolNow != null) ...[_smartBanner(state, isDark), const SizedBox(height: 14)],
                if (state.activeTools.isNotEmpty) ...[_label('PROVIDERS', isDark), const SizedBox(height: 8)],
                ...state.activeTools.asMap().entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _CodexCard(
                    tool: e.value, index: e.key, pulseCtrl: _pulseCtrl, isDark: isDark,
                    onLog: (n) => ctx.read<TrackerBloc>().add(TrackerUsageLogged(e.value.id, count: n)),
                    onSet: (n) => ctx.read<TrackerBloc>().add(TrackerUsageSet(e.value.id, n)),
                    onReset: () => ctx.read<TrackerBloc>().add(TrackerManualReset(e.value.id)),
                    onPin: () => ctx.read<TrackerBloc>().add(TrackerToolPinned(e.value.id)),
                    onRemove: () => ctx.read<TrackerBloc>().add(TrackerToolToggled(e.value.id)),
                  ),
                )),
                if (state.activeTools.isEmpty) _empty(isDark),
                if (state.catalogTools.isNotEmpty) ...[
                  const SizedBox(height: 20), _label('ADD TOOLS', isDark), const SizedBox(height: 8),
                  _catalogGrid(ctx, state, isDark),
                ],
              ])),
        ])),
        floatingActionButton: FloatingActionButton(
          backgroundColor: SynapColors.accent,
          onPressed: () => _addSheet(ctx, isDark),
          child: const Icon(Icons.add, color: Color(0xFF05080F), size: 24),
        ),
      ),
    );
  }

  Widget _topBar(BuildContext ctx, bool isDark) => Padding(
    padding: const EdgeInsets.fromLTRB(8, 8, 16, 4),
    child: Row(children: [
      IconButton(icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? const Color(0xFF5A6A80) : SynapColors.textSecondaryLight, size: 18), onPressed: () => Navigator.pop(ctx)),
      Text('Free Tier Tracker', style: TextStyle(fontFamily: 'Syne', fontSize: 18, fontWeight: FontWeight.w800, color: isDark ? Colors.white : SynapColors.textPrimaryLight)),
      const Spacer(),
      AnimatedBuilder(animation: _pulseCtrl, builder: (_, __) => Container(width: 8, height: 8,
        decoration: BoxDecoration(shape: BoxShape.circle, color: SynapColors.accentGreen.withOpacity(0.5 + 0.5 * _pulseCtrl.value),
          boxShadow: [BoxShadow(color: SynapColors.accentGreen.withOpacity(0.3), blurRadius: 6)]))),
      const SizedBox(width: 6),
      Text('LIVE', style: TextStyle(fontFamily: 'DM Sans', fontSize: 10, fontWeight: FontWeight.w700, color: SynapColors.accentGreen.withOpacity(0.8), letterSpacing: 1.2)),
    ]),
  );

  Widget _summaryRow(TrackerState s, bool isDark) => Row(children: [
    _Chip(label: 'Tracking', value: '${s.activeTools.length}', color: SynapColors.accent, isDark: isDark),
    const SizedBox(width: 8),
    _Chip(label: 'Exhausted', value: '${s.exhaustedTools.length}', color: const Color(0xFFEF4444), isDark: isDark),
    const SizedBox(width: 8),
    _Chip(label: 'Healthy', value: '${s.healthyTools.length}', color: const Color(0xFF10B981), isDark: isDark),
  ]);

  Widget _smartBanner(TrackerState s, bool isDark) {
    final best = s.bestToolNow!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: isDark ? const Color(0xFF0D1420) : const Color(0xFFEDF9FB), border: Border.all(color: SynapColors.accent.withOpacity(0.25))),
      child: Row(children: [
        Container(width: 36, height: 36, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: best.color.withOpacity(0.15)), child: Center(child: Text(best.emoji, style: const TextStyle(fontSize: 18)))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('⚡ BEST RIGHT NOW', style: TextStyle(fontFamily: 'DM Sans', fontSize: 9, fontWeight: FontWeight.w700, color: SynapColors.accent, letterSpacing: 1.0)),
          const SizedBox(height: 2),
          Text('${best.name} — ${best.remaining} ${best.unitShort} left', style: TextStyle(fontFamily: 'Syne', fontSize: 13, fontWeight: FontWeight.w700, color: isDark ? Colors.white : SynapColors.textPrimaryLight)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: SynapColors.accent.withOpacity(0.15), border: Border.all(color: SynapColors.accent.withOpacity(0.3))),
          child: Text('${(100 - best.usagePct * 100).toInt()}%', style: const TextStyle(fontFamily: 'DM Sans', fontSize: 11, color: SynapColors.accent, fontWeight: FontWeight.w700)),
        ),
      ]),
    );
  }

  Widget _label(String t, bool isDark) => Text(t, style: TextStyle(fontFamily: 'DM Sans', fontSize: 11, fontWeight: FontWeight.w700, color: isDark ? Colors.white.withOpacity(0.25) : SynapColors.textMutedLight, letterSpacing: 1.5));

  Widget _empty(bool isDark) => Padding(padding: const EdgeInsets.symmetric(vertical: 60), child: Column(children: [
    Container(width: 72, height: 72, decoration: BoxDecoration(shape: BoxShape.circle, color: isDark ? const Color(0xFF0D1420) : SynapColors.bgTertiaryLight, border: Border.all(color: isDark ? const Color(0xFF1A2336) : SynapColors.borderLight)), child: const Center(child: Text('📊', style: TextStyle(fontSize: 30)))),
    const SizedBox(height: 16),
    Text('No providers tracked yet', style: TextStyle(fontFamily: 'Syne', fontSize: 17, fontWeight: FontWeight.w700, color: isDark ? Colors.white : SynapColors.textPrimaryLight)),
    const SizedBox(height: 6),
    Text('Add tools below to start monitoring', style: TextStyle(fontFamily: 'DM Sans', fontSize: 13, color: isDark ? Colors.white.withOpacity(0.3) : SynapColors.textMutedLight)),
  ]));

  Widget _catalogGrid(BuildContext ctx, TrackerState s, bool isDark) => Wrap(spacing: 10, runSpacing: 10,
    children: s.catalogTools.map((t) => _CatalogChip(tool: t, isDark: isDark, onAdd: () { HapticFeedback.lightImpact(); ctx.read<TrackerBloc>().add(TrackerToolToggled(t.id)); })).toList());

  void _addSheet(BuildContext ctx, bool isDark) {
    final nc = TextEditingController(), lc = TextEditingController();
    showModalBottomSheet(context: ctx, isScrollControlled: true, backgroundColor: isDark ? const Color(0xFF0D1420) : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom + 20, left: 20, right: 20, top: 16), child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 36, height: 4, decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: const Color(0xFF1A2336))),
        const SizedBox(height: 18),
        Text('Add Custom Tool', style: TextStyle(fontFamily: 'Syne', fontSize: 17, fontWeight: FontWeight.w800, color: isDark ? Colors.white : SynapColors.textPrimaryLight)),
        const SizedBox(height: 18),
        _field(nc, 'Tool name', Icons.apps_rounded, isDark),
        const SizedBox(height: 10),
        _field(lc, 'Free limit (e.g. 100)', Icons.speed_rounded, isDark, num: true),
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, height: 48, child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: SynapColors.accent, foregroundColor: const Color(0xFF05080F), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
          onPressed: () { if (nc.text.trim().isEmpty) return; ctx.read<TrackerBloc>().add(TrackerCustomToolAdded(name: nc.text.trim(), emoji: '🤖', freeLimit: int.tryParse(lc.text) ?? 100)); Navigator.pop(ctx); },
          child: const Text('Add Tool', style: TextStyle(fontFamily: 'Syne', fontSize: 15, fontWeight: FontWeight.w700)),
        )),
      ])));
  }

  Widget _field(TextEditingController c, String hint, IconData icon, bool isDark, {bool num = false}) => Container(
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: isDark ? const Color(0xFF111826) : const Color(0xFFF3F4F6), border: Border.all(color: isDark ? const Color(0xFF1A2336) : SynapColors.borderLight)),
    child: TextField(controller: c, keyboardType: num ? TextInputType.number : TextInputType.text,
      style: TextStyle(fontFamily: 'DM Sans', color: isDark ? Colors.white : SynapColors.textPrimaryLight, fontSize: 14),
      decoration: InputDecoration(hintText: hint, hintStyle: TextStyle(color: isDark ? const Color(0xFF3A4A60) : SynapColors.textMutedLight, fontSize: 13), prefixIcon: Icon(icon, color: isDark ? const Color(0xFF3A4A60) : SynapColors.textMutedLight, size: 18), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 14))));
}

// ═══════════════════════════════════════════════════════════════
// _CodexCard — EXACT CodexBar layout
// ═══════════════════════════════════════════════════════════════
class _CodexCard extends StatefulWidget {
  final TrackerTool tool; final int index; final AnimationController pulseCtrl; final bool isDark;
  final void Function(int) onLog, onSet; final VoidCallback onReset, onPin, onRemove;
  const _CodexCard({required this.tool, required this.index, required this.pulseCtrl, required this.isDark, required this.onLog, required this.onSet, required this.onReset, required this.onPin, required this.onRemove});
  @override State<_CodexCard> createState() => _CodexCardState();
}

class _CodexCardState extends State<_CodexCard> with SingleTickerProviderStateMixin {
  bool _exp = false;
  late AnimationController _bar;
  late Animation<double> _sa, _wa;

  @override
  void initState() {
    super.initState();
    _bar = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _sa = Tween<double>(begin: 0, end: widget.tool.usagePct).animate(CurvedAnimation(parent: _bar, curve: Curves.easeOutCubic));
    _wa = Tween<double>(begin: 0, end: widget.tool.weeklyPercent).animate(CurvedAnimation(parent: _bar, curve: Curves.easeOutCubic));
    _bar.forward();
  }

  @override
  void didUpdateWidget(_CodexCard o) {
    super.didUpdateWidget(o);
    if (o.tool.usagePct != widget.tool.usagePct || o.tool.weeklyPercent != widget.tool.weeklyPercent) {
      _sa = Tween<double>(begin: _sa.value, end: widget.tool.usagePct).animate(CurvedAnimation(parent: _bar, curve: Curves.easeOutCubic));
      _wa = Tween<double>(begin: _wa.value, end: widget.tool.weeklyPercent).animate(CurvedAnimation(parent: _bar, curve: Curves.easeOutCubic));
      _bar.forward(from: 0);
    }
  }

  @override void dispose() { _bar.dispose(); super.dispose(); }

  static Color _paceCol(double p) {
    if (p < 0.3) return const Color(0xFF10B981);
    if (p < 0.7) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  static String _paceStr(double p, bool exhausted) {
    if (exhausted) return 'EXHAUSTED';
    if (p < 0.3) return 'RESERVE';
    if (p < 0.7) return 'ON PACE';
    return 'DEFICIT';
  }

  static String _countdown(DateTime? dt) {
    if (dt == null) return '';
    final diff = dt.difference(DateTime.now());
    if (diff.isNegative) return 'Resetting...';
    final d = diff.inDays; final h = diff.inHours % 24; final m = diff.inMinutes % 60;
    if (d > 0) return 'Resets in ${d}d ${h}h';
    if (h > 0) return 'Resets in ${h}h ${m}m';
    return 'Resets in ${m}m';
  }

  static String _paceSign(double p) { final d = ((p - 0.5) * 100).round(); return d >= 0 ? '+$d%' : '$d%'; }

  @override
  Widget build(BuildContext context) {
    final t = widget.tool; final isDark = widget.isDark;
    final bg = isDark ? const Color(0xFF0D1420) : Colors.white;
    final div = isDark ? const Color(0xFF161D2B) : const Color(0xFFE8EBF0);
    final muted = isDark ? const Color(0xFF5A6A80) : SynapColors.textSecondaryLight;
    final textMain = isDark ? Colors.white : SynapColors.textPrimaryLight;
    final barCol = t.isExhausted ? const Color(0xFFEF4444) : t.isLow ? const Color(0xFFF59E0B) : t.color;

    return TweenAnimationBuilder<double>(
      key: ValueKey(t.id), tween: Tween(begin: 0, end: 1), duration: Duration(milliseconds: 400 + widget.index * 80), curve: Curves.easeOutCubic,
      builder: (_, v, child) => Opacity(opacity: v.clamp(0, 1), child: Transform.translate(offset: Offset(0, 16 * (1 - v)), child: child)),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: bg,
          border: Border.all(color: t.color.withOpacity(isDark ? 0.18 : 0.22)),
          boxShadow: [BoxShadow(color: t.color.withOpacity(0.07), blurRadius: 14, offset: const Offset(0, 3))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // ── HEADER ────────────────────────────────────────
          Padding(padding: const EdgeInsets.fromLTRB(14, 14, 14, 12), child: Row(children: [
            // Icon
            AnimatedBuilder(animation: widget.pulseCtrl, builder: (_, __) => Container(width: 44, height: 44,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: t.color.withOpacity(0.13), border: Border.all(color: t.color.withOpacity(0.28)),
                boxShadow: t.isExhausted ? [BoxShadow(color: const Color(0xFFEF4444).withOpacity(0.12 + 0.08 * widget.pulseCtrl.value), blurRadius: 12)] : null),
              child: Center(child: Text(t.emoji, style: const TextStyle(fontSize: 20))))),
            const SizedBox(width: 12),
            // Name + "Updated just now"
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t.name, style: TextStyle(fontFamily: 'Syne', fontSize: 15, fontWeight: FontWeight.w800, color: textMain)),
              const SizedBox(height: 2),
              Text('Updated just now', style: TextStyle(fontFamily: 'DM Sans', fontSize: 10, color: muted)),
            ])),
            // Plan badge
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: t.color.withOpacity(0.13)),
              child: Text(t.source == 'api' ? 'Max' : 'Free', style: TextStyle(fontFamily: 'DM Sans', fontSize: 10, fontWeight: FontWeight.w700, color: t.color))),
            const SizedBox(width: 8),
            // +1 tap
            GestureDetector(onTap: () { HapticFeedback.lightImpact(); widget.onLog(1); },
              child: Container(width: 38, height: 38,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: t.color.withOpacity(0.13), border: Border.all(color: t.color.withOpacity(0.28))),
                child: Icon(Icons.add_rounded, color: t.color, size: 20))),
          ])),

          Container(height: 1, color: div),

          // ── SESSION ───────────────────────────────────────
          AnimatedBuilder(animation: _bar, builder: (_, __) =>
            Padding(padding: const EdgeInsets.fromLTRB(14, 12, 14, 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('Session', style: TextStyle(fontFamily: 'DM Sans', fontSize: 12, fontWeight: FontWeight.w700, color: textMain)),
                const Spacer(),
                Text('${(_sa.value * 100).toInt()}% used', style: TextStyle(fontFamily: 'DM Sans', fontSize: 11, color: muted)),
                const SizedBox(width: 10),
                Text(_countdown(t.resetAt).isNotEmpty ? _countdown(t.resetAt) : t.resetPeriodLabel, style: TextStyle(fontFamily: 'DM Sans', fontSize: 11, color: muted)),
              ]),
              const SizedBox(height: 8),
              _GradBar(progress: _sa.value, color: barCol, isDark: isDark),
              const SizedBox(height: 5),
              Text('${t.sessionUsed} / ${t.sessionLimit}', style: TextStyle(fontFamily: 'DM Sans', fontSize: 11, color: muted)),
            ])),
          ),

          // ── WEEKLY (only if weeklyLimit > 0) ──────────────
          if (t.weeklyLimit > 0) ...[
            Container(height: 0.5, margin: const EdgeInsets.symmetric(horizontal: 14), color: div),
            AnimatedBuilder(animation: _bar, builder: (_, __) =>
              Padding(padding: const EdgeInsets.fromLTRB(14, 12, 14, 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text('Weekly', style: TextStyle(fontFamily: 'DM Sans', fontSize: 12, fontWeight: FontWeight.w700, color: textMain)),
                  const Spacer(),
                  Text('${(_wa.value * 100).toInt()}% used', style: TextStyle(fontFamily: 'DM Sans', fontSize: 11, color: muted)),
                  const SizedBox(width: 10),
                  Text(_countdown(t.weeklyResetAt).isNotEmpty ? _countdown(t.weeklyResetAt) : 'Resets in 7d', style: TextStyle(fontFamily: 'DM Sans', fontSize: 11, color: muted)),
                ]),
                const SizedBox(height: 8),
                _GradBar(progress: _wa.value, color: _paceCol(t.weeklyPercent), isDark: isDark),
                const SizedBox(height: 6),
                // Pace row — exact CodexBar "Pace: Behind (-42%) · Lasts to reset"
                Row(children: [
                  Container(width: 7, height: 7, decoration: BoxDecoration(shape: BoxShape.circle, color: _paceCol(t.weeklyPercent))),
                  const SizedBox(width: 5),
                  Text('Pace: ${_paceStr(t.weeklyPercent, t.isExhausted)}', style: TextStyle(fontFamily: 'DM Sans', fontSize: 11, fontWeight: FontWeight.w600, color: _paceCol(t.weeklyPercent))),
                  const SizedBox(width: 4),
                  Text('(${_paceSign(t.weeklyPercent)}) · Lasts to reset', style: TextStyle(fontFamily: 'DM Sans', fontSize: 11, color: muted)),
                ]),
                const SizedBox(height: 4),
                Text('${t.weeklyUsed} / ${t.weeklyLimit}', style: TextStyle(fontFamily: 'DM Sans', fontSize: 11, color: muted)),
              ])),
            ),
          ],

          // ── SONNET model row (if available) ───────────────
          if (t.models.containsKey('sonnet')) ...[
            Container(height: 0.5, margin: const EdgeInsets.symmetric(horizontal: 14), color: div),
            Padding(padding: const EdgeInsets.fromLTRB(14, 12, 14, 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Sonnet', style: TextStyle(fontFamily: 'DM Sans', fontSize: 12, fontWeight: FontWeight.w700, color: textMain)),
              const SizedBox(height: 8),
              _GradBar(progress: ((t.models['sonnet']?['used'] ?? 0) / ((t.models['sonnet']?['limit'] ?? 1) as num)).clamp(0.0, 1.0).toDouble(), color: t.color, isDark: isDark),
              const SizedBox(height: 5),
              Text('${(((t.models['sonnet']?['used'] ?? 0) / ((t.models['sonnet']?['limit'] ?? 1) as num)).clamp(0.0, 1.0) * 100).toInt()}% used', style: TextStyle(fontFamily: 'DM Sans', fontSize: 11, color: muted)),
            ])),
          ],

          // ── Expand toggle ─────────────────────────────────
          GestureDetector(
            onTap: () => setState(() => _exp = !_exp),
            child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: div))),
              child: Icon(_exp ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, color: muted, size: 18)),
          ),

          // ── Expanded actions ──────────────────────────────
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _Actions(tool: t, accent: t.color, isDark: isDark, onLog: widget.onLog, onSet: widget.onSet, onReset: widget.onReset, onPin: widget.onPin, onRemove: widget.onRemove),
            crossFadeState: _exp ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250), sizeCurve: Curves.easeOutCubic,
          ),
        ]),
      ),
    );
  }
}

// ── Gradient bar with glow tip ───────────────────────────────
class _GradBar extends StatelessWidget {
  final double progress; final Color color; final bool isDark;
  const _GradBar({required this.progress, required this.color, required this.isDark});
  @override
  Widget build(BuildContext context) => SizedBox(height: 7,
    child: ClipRRect(borderRadius: BorderRadius.circular(4),
      child: CustomPaint(painter: _BarP(p: progress, c: color, t: isDark ? const Color(0xFF161D2B) : const Color(0xFFE8EBF0)), size: const Size(double.infinity, 7))));
}

class _BarP extends CustomPainter {
  final double p; final Color c, t;
  _BarP({required this.p, required this.c, required this.t});
  @override void paint(Canvas canvas, Size s) {
    final r = Radius.circular(s.height / 2);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, s.width, s.height), r), Paint()..color = t);
    if (p <= 0) return;
    final w = s.width * p.clamp(0.0, 1.0);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, s.height), r),
      Paint()..shader = LinearGradient(colors: [c, c.withOpacity(0.65)]).createShader(Rect.fromLTWH(0, 0, w, s.height)));
    if (w > 5) canvas.drawCircle(Offset(w - 2, s.height / 2), 3.5, Paint()..color = c.withOpacity(0.35)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
  }
  @override bool shouldRepaint(_BarP o) => o.p != p || o.c != c;
}

// ── Actions ──────────────────────────────────────────────────
class _Actions extends StatefulWidget {
  final TrackerTool tool; final Color accent; final bool isDark;
  final void Function(int) onLog, onSet; final VoidCallback onReset, onPin, onRemove;
  const _Actions({required this.tool, required this.accent, required this.isDark, required this.onLog, required this.onSet, required this.onReset, required this.onPin, required this.onRemove});
  @override State<_Actions> createState() => _ActionsState();
}
class _ActionsState extends State<_Actions> {
  final _c = TextEditingController();
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final muted = isDark ? const Color(0xFF5A6A80) : SynapColors.textSecondaryLight;
    return Padding(padding: const EdgeInsets.fromLTRB(14, 0, 14, 14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text('Quick:', style: TextStyle(fontFamily: 'DM Sans', fontSize: 11, color: muted)),
        const SizedBox(width: 8),
        for (final n in [2, 5, 10]) ...[
          GestureDetector(onTap: () => widget.onLog(n),
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: widget.accent.withOpacity(0.1), border: Border.all(color: widget.accent.withOpacity(0.2))),
              child: Text('+$n', style: TextStyle(fontFamily: 'DM Sans', fontSize: 12, color: widget.accent, fontWeight: FontWeight.w600)))),
          const SizedBox(width: 6),
        ],
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: Container(height: 38,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: isDark ? const Color(0xFF111826) : const Color(0xFFF3F4F6), border: Border.all(color: isDark ? const Color(0xFF1A2336) : SynapColors.borderLight)),
          child: TextField(controller: _c, keyboardType: TextInputType.number,
            style: TextStyle(fontFamily: 'DM Sans', color: isDark ? Colors.white : SynapColors.textPrimaryLight, fontSize: 13),
            decoration: InputDecoration(hintText: 'Set exact usage', hintStyle: TextStyle(color: muted, fontSize: 12), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10))))),
        const SizedBox(width: 8),
        GestureDetector(onTap: () { final v = int.tryParse(_c.text); if (v != null) { widget.onSet(v); _c.clear(); } },
          child: Container(height: 38, width: 52,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: widget.accent.withOpacity(0.12), border: Border.all(color: widget.accent.withOpacity(0.25))),
            child: Center(child: Text('Set', style: TextStyle(fontFamily: 'DM Sans', color: widget.accent, fontSize: 13, fontWeight: FontWeight.w600))))),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        _P(icon: Icons.refresh_rounded, label: 'Reset', color: const Color(0xFF10B981), isDark: isDark, onTap: widget.onReset),
        const SizedBox(width: 6),
        _P(icon: widget.tool.isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined, label: widget.tool.isPinned ? 'Unpin' : 'Pin', color: SynapColors.accent, isDark: isDark, onTap: widget.onPin),
        const SizedBox(width: 6),
        _P(icon: Icons.remove_circle_outline_rounded, label: 'Remove', color: const Color(0xFFEF4444), isDark: isDark, onTap: widget.onRemove),
      ]),
      if (widget.tool.isLow || widget.tool.isExhausted) ...[
        const SizedBox(height: 10),
        Container(padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xFFF59E0B).withOpacity(0.08), border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.2))),
          child: Row(children: [const Text('💡', style: TextStyle(fontSize: 13)), const SizedBox(width: 8), Expanded(child: Text(widget.tool.tipWhenLow, style: const TextStyle(fontFamily: 'DM Sans', fontSize: 12, color: Color(0xFFF59E0B), height: 1.4)))])),
      ],
    ]));
  }
}

class _P extends StatelessWidget {
  final IconData icon; final String label; final Color color; final bool isDark; final VoidCallback onTap;
  const _P({required this.icon, required this.label, required this.color, required this.isDark, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onTap,
    child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: color.withOpacity(0.08), border: Border.all(color: color.withOpacity(0.18))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: color, size: 13), const SizedBox(width: 4), Text(label, style: TextStyle(fontFamily: 'DM Sans', fontSize: 11, color: color, fontWeight: FontWeight.w600))])));
}

// ── Summary Chip ─────────────────────────────────────────────
class _Chip extends StatelessWidget {
  final String label, value; final Color color; final bool isDark;
  const _Chip({required this.label, required this.value, required this.color, required this.isDark});
  @override
  Widget build(BuildContext context) => Expanded(child: Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: color.withOpacity(isDark ? 0.06 : 0.08), border: Border.all(color: color.withOpacity(isDark ? 0.16 : 0.2))),
    child: Column(children: [
      Text(value, style: TextStyle(fontFamily: 'Syne', fontSize: 22, fontWeight: FontWeight.w800, color: color)),
      const SizedBox(height: 2),
      Text(label, style: TextStyle(fontFamily: 'DM Sans', fontSize: 10, fontWeight: FontWeight.w500, color: isDark ? const Color(0xFF5A6A80) : SynapColors.textSecondaryLight)),
    ])));
}

// ── Catalog Chip ─────────────────────────────────────────────
class _CatalogChip extends StatefulWidget {
  final TrackerTool tool; final bool isDark; final VoidCallback onAdd;
  const _CatalogChip({required this.tool, required this.isDark, required this.onAdd});
  @override State<_CatalogChip> createState() => _CatalogChipState();
}
class _CatalogChipState extends State<_CatalogChip> {
  bool _p = false;
  @override
  Widget build(BuildContext context) {
    final c = widget.tool.color; final isDark = widget.isDark;
    return GestureDetector(
      onTapDown: (_) => setState(() => _p = true), onTapUp: (_) { setState(() => _p = false); widget.onAdd(); }, onTapCancel: () => setState(() => _p = false),
      child: AnimatedContainer(duration: const Duration(milliseconds: 100), transform: Matrix4.identity()..scale(_p ? 0.96 : 1.0), transformAlignment: Alignment.center,
        width: (MediaQuery.of(context).size.width - 42) / 2, padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: isDark ? const Color(0xFF0D1420) : Colors.white, border: Border.all(color: c.withOpacity(isDark ? 0.14 : 0.18))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(width: 36, height: 36, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: c.withOpacity(0.12)), child: Center(child: Text(widget.tool.emoji, style: const TextStyle(fontSize: 18)))),
            Container(width: 24, height: 24, decoration: BoxDecoration(shape: BoxShape.circle, color: c.withOpacity(0.12), border: Border.all(color: c.withOpacity(0.25))), child: Icon(Icons.add_rounded, color: c, size: 14)),
          ]),
          const SizedBox(height: 12),
          Text(widget.tool.name, style: TextStyle(fontFamily: 'Syne', fontSize: 13, fontWeight: FontWeight.w700, color: isDark ? Colors.white : SynapColors.textPrimaryLight), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text('${widget.tool.freeLimit} ${widget.tool.unitShort} free', style: TextStyle(fontFamily: 'DM Sans', fontSize: 11, color: isDark ? const Color(0xFF5A6A80) : SynapColors.textSecondaryLight)),
        ])));
  }
}
