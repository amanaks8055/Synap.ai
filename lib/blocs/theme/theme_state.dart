import 'package:equatable/equatable.dart';

enum AppThemeMode { dark, light }

class ThemeState extends Equatable {
  final AppThemeMode mode;

  const ThemeState({this.mode = AppThemeMode.dark});

  bool get isDark => mode == AppThemeMode.dark;
  bool get isLight => mode == AppThemeMode.light;

  ThemeState copyWith({AppThemeMode? mode}) {
    return ThemeState(mode: mode ?? this.mode);
  }

  @override
  List<Object?> get props => [mode];
}
