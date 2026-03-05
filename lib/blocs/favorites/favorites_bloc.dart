import 'package:flutter_bloc/flutter_bloc.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';
import '../../services/user_profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  static const String _storageKey = 'synap_favorites_v2';

  FavoritesBloc() : super(const FavoritesState()) {
    on<LoadFavorites>(_onLoad);
    on<ToggleFavorite>(_onToggle);
    on<RemoveFavorite>(_onRemove);
  }

  Future<void> _onLoad(LoadFavorites event, Emitter<FavoritesState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_storageKey) ?? [];
    emit(state.copyWith(favoriteIds: ids));
    UserProfileService.refreshFavoritesCount(ids.length);
  }

  Future<void> _onToggle(ToggleFavorite event, Emitter<FavoritesState> emit) async {
    final ids = List<String>.from(state.favoriteIds);
    if (ids.contains(event.toolId)) {
      ids.remove(event.toolId);
    } else {
      ids.add(event.toolId);
    }
    emit(state.copyWith(favoriteIds: ids));
    await _save(ids);
  }

  Future<void> _onRemove(RemoveFavorite event, Emitter<FavoritesState> emit) async {
    final ids = List<String>.from(state.favoriteIds)..remove(event.toolId);
    emit(state.copyWith(favoriteIds: ids));
    await _save(ids);
  }

  Future<void> _save(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, ids);
    UserProfileService.refreshFavoritesCount(ids.length);
  }
}
