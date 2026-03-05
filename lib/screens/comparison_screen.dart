import 'package:flutter/material.dart';
import '../models/tool_model.dart';
import '../services/recommendation_service.dart';

class ComparisonScreen extends StatelessWidget {
  final ToolModel toolA;
  final ToolModel toolB;

  const ComparisonScreen({
    super.key,
    required this.toolA,
    required this.toolB,
  });

  @override
  Widget build(BuildContext context) {
    // Record comparison event
    RecommendationService().record(toolA.id, UserEvent.compared);
    RecommendationService().record(toolB.id, UserEvent.compared);

    return Scaffold(
      backgroundColor: const Color(0xFF03030F),
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──
          SliverAppBar(
            backgroundColor: const Color(0xFF0A0520),
            pinned: true,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Compare Tools',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),

          // ── Content ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _ToolHeaders(toolA: toolA, toolB: toolB),
                  const SizedBox(height: 24),

                  _CompareSection(
                    title: '⭐ Rating',
                    rowA: _RatingBar(tool: toolA),
                    rowB: _RatingBar(tool: toolB),
                  ),
                  const SizedBox(height: 16),

                  _CompareSection(
                    title: '💰 Pricing',
                    rowA: _InfoChip(
                      text: toolA.pricing ?? (toolA.isFree ? 'Free' : 'Paid'),
                      color: toolA.isFree
                          ? const Color(0xFF00E676)
                          : const Color(0xFFFF8C42),
                    ),
                    rowB: _InfoChip(
                      text: toolB.pricing ?? (toolB.isFree ? 'Free' : 'Paid'),
                      color: toolB.isFree
                          ? const Color(0xFF00E676)
                          : const Color(0xFFFF8C42),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _CompareSection(
                    title: '🎯 Ease of Use',
                    rowA: _EaseChip(ease: toolA.ease),
                    rowB: _EaseChip(ease: toolB.ease),
                  ),
                  const SizedBox(height: 16),

                  _CompareSection(
                    title: '🔌 API',
                    rowA: _InfoChip(
                      text: toolA.apiAvailable ?? 'No',
                      color: toolA.apiAvailable == 'Yes'
                          ? const Color(0xFF00E676)
                          : toolA.apiAvailable == 'Beta'
                              ? const Color(0xFFFFD700)
                              : Colors.red.shade400,
                    ),
                    rowB: _InfoChip(
                      text: toolB.apiAvailable ?? 'No',
                      color: toolB.apiAvailable == 'Yes'
                          ? const Color(0xFF00E676)
                          : toolB.apiAvailable == 'Beta'
                              ? const Color(0xFFFFD700)
                              : Colors.red.shade400,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _CompareSection(
                    title: '📱 Platforms',
                    rowA: Text(
                      toolA.platforms ?? '-',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    rowB: Text(
                      toolB.platforms ?? '-',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _FeatureCompareTable(toolA: toolA, toolB: toolB),
                  const SizedBox(height: 24),

                  _ProsConsSection(title: '👍 Pros', toolA: toolA, toolB: toolB, isPros: true),
                  const SizedBox(height: 16),

                  _ProsConsSection(title: '👎 Cons', toolA: toolA, toolB: toolB, isPros: false),
                  const SizedBox(height: 24),

                  _VerdictCard(toolA: toolA, toolB: toolB),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolHeaders extends StatelessWidget {
  final ToolModel toolA, toolB;
  const _ToolHeaders({required this.toolA, required this.toolB});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _ToolHeaderCard(tool: toolA, accent: const Color(0xFF7B61FF))),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text('VS',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 13)),
        ),
        const SizedBox(width: 4),
        Expanded(child: _ToolHeaderCard(tool: toolB, accent: const Color(0xFF00E5FF))),
      ],
    );
  }
}

class _ToolHeaderCard extends StatelessWidget {
  final ToolModel tool;
  final Color accent;
  const _ToolHeaderCard({required this.tool, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Color(tool.color).withOpacity(0.8),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(tool.iconEmoji, style: const TextStyle(fontSize: 26)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tool.name,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            tool.category.emoji + ' ' + tool.category.label,
            style: TextStyle(
                color: Colors.white.withOpacity(0.4), fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CompareSection extends StatelessWidget {
  final String title;
  final Widget rowA, rowB;
  const _CompareSection(
      {required this.title, required this.rowA, required this.rowB});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Center(
              child: Text(title,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(child: Center(child: rowA)),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.white.withOpacity(0.08),
                ),
                Expanded(child: Center(child: rowB)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  final ToolModel tool;
  const _RatingBar({required this.tool});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          tool.rating.toStringAsFixed(1),
          style: const TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 22,
              fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (i) {
            return Icon(
              i < tool.rating.floor()
                  ? Icons.star
                  : (i < tool.rating ? Icons.star_half : Icons.star_outline),
              color: const Color(0xFFFFD700),
              size: 12,
            );
          }),
        ),
        const SizedBox(height: 2),
        Text(
          '${(tool.reviewCount / 1000).toStringAsFixed(0)}k reviews',
          style:
              TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String text;
  final Color color;
  const _InfoChip({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(text,
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.w700)),
    );
  }
}

class _EaseChip extends StatelessWidget {
  final String ease;
  const _EaseChip({required this.ease});

  Color get _color {
    switch (ease) {
      case 'Beginner':     return const Color(0xFF00E676);
      case 'Intermediate': return const Color(0xFFFFD700);
      case 'Advanced':     return const Color(0xFFFF5252);
      default:             return Colors.white54;
    }
  }

  @override
  Widget build(BuildContext context) =>
      _InfoChip(text: ease, color: _color);
}

class _FeatureCompareTable extends StatelessWidget {
  final ToolModel toolA, toolB;
  const _FeatureCompareTable({required this.toolA, required this.toolB});

  @override
  Widget build(BuildContext context) {
    final allFeatures = {
      ...toolA.features,
      ...toolB.features,
    }.toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Expanded(
                    child: Text('🛠️ Features',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                            fontWeight: FontWeight.w600))),
                SizedBox(
                  width: 60,
                  child: Center(
                    child: Text(toolA.iconEmoji,
                        style: const TextStyle(fontSize: 18)),
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Center(
                    child: Text(toolB.iconEmoji,
                        style: const TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
          ...allFeatures.map((feature) {
            final hasA = toolA.features.contains(feature);
            final hasB = toolB.features.contains(feature);
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: Colors.white.withOpacity(0.05))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(feature,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12)),
                  ),
                  SizedBox(
                    width: 60,
                    child: Center(
                      child: Icon(
                        hasA ? Icons.check_circle : Icons.cancel,
                        color: hasA
                            ? const Color(0xFF00E676)
                            : Colors.white.withOpacity(0.15),
                        size: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: Center(
                      child: Icon(
                        hasB ? Icons.check_circle : Icons.cancel,
                        color: hasB
                            ? const Color(0xFF00E5FF)
                            : Colors.white.withOpacity(0.15),
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ProsConsSection extends StatelessWidget {
  final String title;
  final ToolModel toolA, toolB;
  final bool isPros;
  const _ProsConsSection(
      {required this.title,
      required this.toolA,
      required this.toolB,
      required this.isPros});

  @override
  Widget build(BuildContext context) {
    final listA = isPros ? toolA.pros : toolA.cons;
    final listB = isPros ? toolB.pros : toolB.cons;
    final color = isPros ? const Color(0xFF00E676) : const Color(0xFFFF5252);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Center(
                child: Text(title,
                    style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w700))),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _PointList(points: listA, color: color)),
                Container(
                    width: 1,
                    height: 100,
                    color: Colors.white.withOpacity(0.06),
                    margin: const EdgeInsets.symmetric(horizontal: 8)),
                Expanded(child: _PointList(points: listB, color: color)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PointList extends StatelessWidget {
  final List<String> points;
  final Color color;
  const _PointList({required this.points, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: points
          .map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4, right: 6),
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                          color: color, shape: BoxShape.circle),
                    ),
                    Expanded(
                      child: Text(p,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 11)),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class _VerdictCard extends StatelessWidget {
  final ToolModel toolA, toolB;
  const _VerdictCard({required this.toolA, required this.toolB});

  @override
  Widget build(BuildContext context) {
    final winner = toolA.rating >= toolB.rating ? toolA : toolB;
    final winnerAccent = toolA.rating >= toolB.rating
        ? const Color(0xFF7B61FF)
        : const Color(0xFF00E5FF);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            winnerAccent.withOpacity(0.15),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: winnerAccent.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text('🏆 Our Verdict',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(winner.iconEmoji, style: const TextStyle(fontSize: 30)),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(winner.name,
                      style: TextStyle(
                          color: winnerAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                  Text('Higher rated • ${winner.rating}/5',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.5), fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${winner.name} beats ${winner.id == toolA.id ? toolB.name : toolA.name} '
            'in overall rating and review count. '
            '${winner.isFree ? "Aur ye free hai!" : "Premium features justify karta hai price."}',
            style: TextStyle(
                color: Colors.white.withOpacity(0.6), fontSize: 12, height: 1.6),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
