import 'package:equatable/equatable.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
  @override
  List<Object?> get props => [];
}

class ThemeToggled extends ThemeEvent {
  const ThemeToggled();
}

class ThemeSetDark extends ThemeEvent {
  const ThemeSetDark();
}

class ThemeSetLight extends ThemeEvent {
  const ThemeSetLight();
}
