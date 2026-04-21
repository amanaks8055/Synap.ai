import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../services/auth_service.dart';
import '../services/extension_sync_service.dart';
import '../services/tool_service.dart';
import '../services/user_profile_service.dart';
import '../blocs/tracker/tracker_bloc.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/main_navigation.dart';

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  bool _showSplash = true;
  late ExtensionSyncService _syncService;
  StreamSubscription? _authSub;

  @override
  void initState() {
    super.initState();
    _syncService =
        ExtensionSyncService(trackerBloc: context.read<TrackerBloc>());

    _authSub = AuthService.authStateChanges.listen((state) async {
      await UserProfileService.syncFromAuthState();

      final userId = state.session?.user.id;
      if (userId == null) {
        _syncService.stop();
        return;
      }
      _syncService.start(userId);
    });

    final userId = AuthService.userId;
    if (userId != null) {
      _syncService.start(userId);
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _syncService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return SplashScreen(
        dataReady: ToolService.loadingComplete,
        onDone: () {
          if (mounted) setState(() => _showSplash = false);
        },
      );
    }
    if (AuthService.isLoggedIn) {
      return const MainNavigation();
    }
    return const AuthScreen();
  }
}
