import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth_service.dart';
import '../services/extension_sync_service.dart';
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

  @override
  void initState() {
    super.initState();
    _syncService = ExtensionSyncService(trackerBloc: context.read<TrackerBloc>());
    const testUserId = 'synap_test_user';
    _syncService.start(testUserId);
  }

  @override
  void dispose() {
    _syncService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return SplashScreen(onDone: () {
        if (mounted) setState(() => _showSplash = false);
      });
    }
    if (AuthService.isLoggedIn) {
      return const MainNavigation();
    }
    return const AuthScreen();
  }
}
