import 'package:flutter/material.dart';
import '../models/tool_model.dart';
import '../services/tool_service.dart';
import '../theme/app_theme.dart';
import '../widgets/tool_icon.dart';

/// Full category tools screen with pagination (lazy-loading).
/// Opens from "See all" button on home screen.
class CategoryToolsScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  const CategoryToolsScreen({super.key, required this.categoryId, required this.categoryName});

  @override
  State<CategoryToolsScreen> createState() => _CategoryToolsScreenState();
}

class _CategoryToolsScreenState extends State<CategoryToolsScreen> {
  final List<ToolModel> _tools = [];
  final ScrollController _scrollController = ScrollController();
  static const int _pageSize = 20;
  bool _hasMore = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMore();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;

    final batch = ToolService.getToolsByCategoryPaginated(
      widget.categoryId,
      offset: _tools.length,
      limit: _pageSize,
    );

    setState(() {
      _tools.addAll(batch);
      _hasMore = batch.length == _pageSize;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalCount = ToolService.getToolCountForCategory(widget.categoryId);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
              child: Row(children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_rounded, color: SynapStyles.textPrimary(context)),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    widget.categoryName,
                    style: TextStyle(
                      color: SynapStyles.textPrimary(context),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Tool count badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: SynapColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$totalCount tools',
                    style: TextStyle(
                      color: SynapColors.accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ]),
            ),
            Expanded(
              child: _tools.isEmpty && !_isLoading
                  ? Center(child: Text('No tools in this category', style: TextStyle(color: SynapStyles.textMuted(context))))
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                      itemCount: _tools.length + (_hasMore ? 1 : 0),
                      itemBuilder: (context, i) {
                        if (i >= _tools.length) {
                          // Loading indicator at bottom
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }
                        return _tile(context, _tools[i]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, ToolModel tool) {
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
            iconEmoji: tool.iconEmoji,
            size: 48,
            fontSize: 20,
            radius: 12,
          ),
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
                    if (tool.votes > 0) ...[
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_upward_rounded, size: 12, color: SynapStyles.textMuted(context)),
                      Text(
                        '${tool.votes}',
                        style: TextStyle(
                          color: SynapStyles.textMuted(context),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              color: SynapStyles.textMuted(context), size: 20),
        ]),
      ),
    );
  }
}
