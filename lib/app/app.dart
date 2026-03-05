import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_theme.dart';
import '../blocs/favorites/favorites_bloc.dart';
import '../blocs/favorites/favorites_event.dart';
import '../blocs/premium/premium_bloc.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/tracker/tracker_bloc.dart';
import '../config/router.dart';
import '../widgets/global_background.dart';

class SynapApp extends StatelessWidget {
  const SynapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FavoritesBloc()..add(LoadFavorites())),
        BlocProvider(create: (_) => PremiumBloc()),
        BlocProvider(create: (_) => TrackerBloc()),
        BlocProvider(create: (_) => ThemeBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Synap',
            debugShowCheckedModeBanner: false,
            theme: SynapTheme.lightTheme,
            darkTheme: SynapTheme.darkTheme,
            themeMode: themeState.isDark ? ThemeMode.dark : ThemeMode.light,
            initialRoute: '/',
            onGenerateRoute: AppRouter.onGenerateRoute,
            builder: (context, child) {
              return GlobalInterstellarBackground(
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
