import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/tool_model.dart';
import '../services/recommendation_service.dart';
import '../screens/comparison_screen.dart';
import '../blocs/premium/premium_bloc.dart';
import '../data/tools_data.dart';

class ToolDetailSheet extends StatefulWidget {
  final ToolModel tool;
  const ToolDetailSheet({super.key, required this.tool});

  @override
  State<ToolDetailSheet> createState() => _ToolDetailSheetState();
}

class _ToolDetailSheetState extends State<ToolDetailSheet> {
  @override
  Widget build(BuildContext context) {
    final isFav = RecommendationService().isFavorite(widget.tool.id);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A1F),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(color: Colors.black54, blurRadius: 40, spreadRadius: 10),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Color(widget.tool.color).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(widget.tool.iconEmoji,
                      style: const TextStyle(fontSize: 32)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.tool.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.tool.category.emoji + ' ' + widget.tool.category.label,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.5), fontSize: 13),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        RecommendationService().toggleFavorite(widget.tool.id);
                      });
                    },
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.redAccent : Colors.white38,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Description
          Text(
            widget.tool.description,
            style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
                height: 1.5),
          ),
          const SizedBox(height: 24),

          // Compare Picker — Professional only
          BlocBuilder<PremiumBloc, PremiumState>(
            builder: (context, premState) {
              if (premState.isProfessional) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'COMPARE WITH',
                      style: TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1),
                    ),
                    const SizedBox(height: 10),
                    ComparePickerWidget(sourceTool: widget.tool),
                    const SizedBox(height: 24),
                  ],
                );
              }
              // Locked state for Free / Student users
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/premium');
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF7B61FF).withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lock_outline_rounded,
                          color: const Color(0xFF7B61FF).withOpacity(0.6), size: 20),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Compare Tools',
                                style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w700)),
                            SizedBox(height: 2),
                            Text('Upgrade to Professional',
                                style: TextStyle(color: Color(0xFF7B61FF), fontSize: 11, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded,
                          color: Color(0xFF7B61FF), size: 14),
                    ],
                  ),
                ),
              );
            },
          ),

          // Action Button — fixed to open website
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () async {
                final uri = Uri.parse(widget.tool.websiteUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B61FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text('Try it Now',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class ComparePickerWidget extends StatefulWidget {
  final ToolModel sourceTool;
  const ComparePickerWidget({super.key, required this.sourceTool});

  @override
  State<ComparePickerWidget> createState() => _ComparePickerWidgetState();
}

class _ComparePickerWidgetState extends State<ComparePickerWidget> {
  ToolModel? selectedTool;

  @override
  Widget build(BuildContext context) {
    final otherTools = ToolsData.all
        .where((t) => t.id != widget.sourceTool.id)
        .toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ToolModel>(
          value: selectedTool,
          hint: const Text('Select a tool to compare...',
              style: TextStyle(color: Colors.white24, fontSize: 13)),
          dropdownColor: const Color(0xFF15152F),
          icon: const Icon(Icons.compare_arrows, color: Color(0xFF7B61FF)),
          isExpanded: true,
          items: otherTools.map((t) {
            return DropdownMenuItem(
              value: t,
              child: Row(
                children: [
                  Text(t.iconEmoji),
                  const SizedBox(width: 10),
                  Text(t.name,
                      style: const TextStyle(color: Colors.white, fontSize: 14)),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              Navigator.pop(context); // Close sheet
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ComparisonScreen(
                    toolA: widget.sourceTool,
                    toolB: val,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
