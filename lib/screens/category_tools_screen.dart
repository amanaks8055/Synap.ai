import 'package:flutter/material.dart';
import '../models/tool_model.dart';
import '../services/tool_service.dart';
import '../theme/app_theme.dart';
import '../widgets/tool_icon.dart';

class CategoryToolsScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  const CategoryToolsScreen({super.key, required this.categoryId, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final tools = ToolService.getToolsByCategory(categoryId);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
              child: Row(children: [
                IconButton(icon: Icon(Icons.arrow_back_rounded, color: SynapStyles.textPrimary(context)), onPressed: () => Navigator.pop(context)),
                Text(categoryName, style: TextStyle(color: SynapStyles.textPrimary(context), fontSize: 18, fontWeight: FontWeight.w600)),
              ]),
            ),
            Expanded(
              child: tools.isEmpty
                  ? Center(child: Text('No tools in this category', style: TextStyle(color: SynapStyles.textMuted(context))))
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                      itemCount: tools.length,
                      separatorBuilder: (_, __) => Divider(color: SynapStyles.divider(context), height: 1),
                      itemBuilder: (context, i) => _tile(context, tools[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, Tool tool) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/toolDetail', arguments: tool),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.07)),
          boxShadow: [
            BoxShadow(
              color: SynapColors.accent.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(children: [
          ToolIcon(
              name: tool.name,
              categoryId: tool.categoryId,
              iconUrl: tool.iconUrl,
              size: 48,
              fontSize: 20,
              radius: 12),
          const SizedBox(width: 16),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(tool.name,
                    style: TextStyle(
                        color: SynapStyles.textPrimary(context),
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(tool.description,
                    style: TextStyle(
                        color: SynapStyles.textSecondary(context),
                        fontSize: 12,
                        height: 1.2),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('⭐ ${tool.rating}',
                        style: TextStyle(
                            color: SynapStyles.textMuted(context),
                            fontSize: 11)),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: tool.hasFreeTier
                              ? SynapColors.accentGreen.withOpacity(0.1)
                              : Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(tool.hasFreeTier ? 'FREE' : 'PAID',
                          style: TextStyle(
                              color: tool.hasFreeTier
                                  ? SynapColors.accentGreen
                                  : SynapStyles.textMuted(context),
                              fontSize: 10,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ])),
          Icon(Icons.chevron_right_rounded,
              color: SynapStyles.textMuted(context), size: 20),
        ]),
      ),
    );
  }
}
