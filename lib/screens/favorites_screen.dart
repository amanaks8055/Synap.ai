import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/favorites/favorites_bloc.dart';
import '../blocs/favorites/favorites_event.dart';
import '../blocs/favorites/favorites_state.dart';
import '../blocs/premium/premium_bloc.dart';
import '../services/tool_service.dart';
import '../theme/app_theme.dart';
import '../widgets/tool_icon.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Center(child: Text('Favorites', style: TextStyle(color: SynapStyles.textPrimary(context), fontSize: 20, fontWeight: FontWeight.w700))),
            ),
            Expanded(
              child: BlocBuilder<FavoritesBloc, FavoritesState>(
                builder: (context, favState) {
                  final isPremium = context.read<PremiumBloc>().state.isPremium;

                  if (favState.favoriteIds.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.favorite_border_rounded, size: 56, color: SynapStyles.textMuted(context)),
                          const SizedBox(height: 16),
                          Text('No favorites yet', style: TextStyle(color: SynapStyles.textPrimary(context), fontSize: 18, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          Text('Tap ❤️ on any tool to save it here', style: TextStyle(color: SynapStyles.textMuted(context), fontSize: 14)),
                        ],
                      ),
                    );
                  }

                  final tools = favState.favoriteIds
                      .map((id) => ToolService.getAllTools().where((t) => t.id == id))
                      .where((m) => m.isNotEmpty)
                      .map((m) => m.first)
                      .toList();

                  return Column(
                    children: [
                      if (!isPremium)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(color: SynapStyles.bgSecondary(context), borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                const Icon(Icons.favorite_rounded, color: SynapColors.accent, size: 18),
                                const SizedBox(width: 10),
                                Text('${favState.favoriteIds.length} / ${favState.maxFree} saved', style: TextStyle(color: SynapStyles.textSecondary(context), fontSize: 13)),
                                const Spacer(),
                                if (favState.isAtFreeLimit)
                                  const Text('Upgrade for unlimited', style: TextStyle(color: SynapColors.accent, fontSize: 12, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                          itemCount: tools.length,
                          separatorBuilder: (_, __) => Divider(color: SynapStyles.divider(context), height: 1),
                          itemBuilder: (context, i) {
                            final tool = tools[i];
                            return GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/toolDetail', arguments: tool),
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  children: [
                                    ToolIcon(name: tool.name, categoryId: tool.categoryId, iconUrl: tool.iconUrl, size: 44, fontSize: 18, radius: 12),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(tool.name, style: TextStyle(color: SynapStyles.textPrimary(context), fontSize: 15, fontWeight: FontWeight.w600)),
                                          const SizedBox(height: 2),
                                          Text(tool.hasFreeTier ? 'Free tier available' : 'Paid only', style: TextStyle(color: SynapStyles.textSecondary(context), fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => context.read<FavoritesBloc>().add(RemoveFavorite(tool.id)),
                                      child: Icon(Icons.close_rounded, color: SynapStyles.textMuted(context), size: 18),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
