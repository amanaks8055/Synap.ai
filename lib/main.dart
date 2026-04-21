import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/app.dart';
import 'services/supabase_service.dart';
import 'services/user_profile_service.dart';
import 'services/recommendation_service.dart';
import 'services/ad_service.dart';
import 'services/tool_service.dart';
import 'services/data_migration_service.dart';
import 'services/news_service.dart';
import 'services/news_notification_service.dart';
import 'services/connectivity_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Global Error Handlers ────────────────────
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('[Synap] Flutter Error: ${details.exception}');
    debugPrint('[Synap] Stack: ${details.stack?.toString().split('\n').take(5).join('\n')}');
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('[Synap] Platform Error: $error');
    debugPrint('[Synap] Stack: ${stack.toString().split('\n').take(5).join('\n')}');
    return true;
  };

  // ── Load environment config ──────────────────
  await dotenv.load(fileName: '.env');

  // ── Only Supabase is critical before first frame ─────────
  await SupabaseService.initialize();

  // ── Start tool loading in parallel with splash ───────────
  ToolService.startBackgroundLoad();

  // ── Deferred: non-critical services (run during splash) ──
  _initDeferredServices();

  runApp(
    const ProviderScope(
      child: SynapApp(),
    ),
  );
}

/// Non-critical services — run in background during splash screen.
void _initDeferredServices() {
  // Start connectivity monitoring
  ConnectivityService.startMonitoring();
  
  Future.wait([
    AdService().initialize(),
    UserProfileService.init(),
    RecommendationService().init(),
    NewsService.init(),
    NewsNotificationService.init(),
  ]).then((_) async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool('synap_tools_migrated_v3') ?? false)) {
      await DataMigrationService.migrateToolsToSupabase();
      await prefs.setBool('synap_tools_migrated_v3', true);
    }
  });
}
