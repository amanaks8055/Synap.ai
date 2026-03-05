import 'package:flutter/material.dart';
import 'app/app.dart';
import 'services/supabase_service.dart';
import 'services/user_profile_service.dart';
import 'services/recommendation_service.dart';
import 'services/ad_service.dart';
import 'services/tool_service.dart';
import 'services/data_migration_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Parallel Initialization ──────────────────
  // Launching core services concurrently to reduce blocking startup time.
  final initFutures = [
    SupabaseService.initialize(),
    AdService().initialize(),
    UserProfileService.init(),
    RecommendationService().init(),
  ];
  
  await Future.wait(initFutures);

  // ── Migration & Loading ──────────────────────
  final prefs = await SharedPreferences.getInstance();
  if (!(prefs.getBool('synap_tools_migrated_v3') ?? false)) {
    await DataMigrationService.migrateToolsToSupabase();
    await prefs.setBool('synap_tools_migrated_v3', true);
  }

  await ToolService.loadTools();
  runApp(const SynapApp());
}
