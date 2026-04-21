import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_event.dart';
import 'theme_state.dart';

export 'theme_event.dart';
export 'theme_state.dart';

const _kThemeMode = 'synap_theme_mode';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<ThemeToggled>(_onToggle);
    on<ThemeSetDark>(_onSetDark);
    on<ThemeSetLight>(_onSetLight);
    on<ThemeInitRequested>(_onInit);
    add(const ThemeInitRequested());
  }

  Future<void> _onInit(ThemeInitRequested event, Emitter<ThemeState> emit) async {
    // Force dark mode by default
    emit(const ThemeState(mode: AppThemeMode.dark));
  }

  Future<void> _onToggle(ThemeToggled event, Emitter<ThemeState> emit) async {
    final newMode =
        state.isDark ? AppThemeMode.light : AppThemeMode.dark;
    emit(state.copyWith(mode: newMode));
    await _save(newMode);
  }

  Future<void> _onSetDark(ThemeSetDark event, Emitter<ThemeState> emit) async {
    emit(state.copyWith(mode: AppThemeMode.dark));
    await _save(AppThemeMode.dark);
  }

  Future<void> _onSetLight(
      ThemeSetLight event, Emitter<ThemeState> emit) async {
    emit(state.copyWith(mode: AppThemeMode.light));
    await _save(AppThemeMode.light);
  }

  Future<void> _save(AppThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kThemeMode, mode == AppThemeMode.dark ? 'dark' : 'light');
    } catch (_) {}
  }
}
