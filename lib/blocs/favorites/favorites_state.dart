class FavoritesState {
  final List<String> favoriteIds;
  final int maxFree;

  const FavoritesState({
    this.favoriteIds = const [],
    this.maxFree = 10,
  });

  bool isFavorite(String id) => favoriteIds.contains(id);
  bool get isAtFreeLimit => favoriteIds.length >= maxFree;

  FavoritesState copyWith({List<String>? favoriteIds}) {
    return FavoritesState(
      favoriteIds: List<String>.from(favoriteIds ?? this.favoriteIds),
      maxFree: maxFree,
    );
  }
}
