// ══════════════════════════════════════════════════════════════
// SYNAP — DataMigrationService
// One-time migration: uploads MockData.tools → Supabase ai_tools
// Call migrateToolsToSupabase() once, then never again.
// ══════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_data.dart';

class DataMigrationService {
  static const _migrationKey = 'synap_tools_migrated_v1';

  /// Upload all MockData.tools to Supabase ai_tools table.
  /// Safe to call multiple times — uses upsert so no duplicates.
  static Future<MigrationResult> migrateToolsToSupabase() async {
    try {
      final sb = Supabase.instance.client;
      final tools = MockData.tools;

      debugPrint('[Migration] Starting: ${tools.length} tools to upload...');

      // Convert Tool objects → JSON rows for Supabase
      // Upload in batches of 50 to avoid timeouts
      const batchSize = 50;
      int uploaded = 0;

      for (int i = 0; i < tools.length; i += batchSize) {
        final batch = tools.skip(i).take(batchSize).toList();

        final rows = batch.map((t) {
          return <String, dynamic>{
            'id': t.id,
            'name': t.name,
            'slug': t.slug,
            'category_id': t.categoryId,
            'description': t.description,
            'icon_emoji': t.iconEmoji,
            'icon_url': t.iconUrl,
            'website_url': t.websiteUrl,
            'affiliate_url': t.affiliateUrl,
            'has_free_tier': t.hasFreeTier,
            'free_limit_description': t.freeLimitDescription,
            'free_limit_details': t.freeLimitDetails,
            'paid_price_monthly': t.paidPriceMonthly,
            'paid_price_yearly': t.paidPriceYearly,
            'paid_tier_description': t.paidTierDescription,
            'optimization_tips': t.optimizationTips.join(' | '),
            'is_featured': t.isFeatured,
            'is_new': t.isNew,
            'click_count': t.clickCount,
          };
        }).toList();

        await sb.from('ai_tools').upsert(rows, onConflict: 'id');
        uploaded += batch.length;

        debugPrint('[Migration] Progress: $uploaded / ${tools.length}');
        
        // Yield to allow main thread to process frames
        await Future.delayed(Duration.zero);
      }

      debugPrint('[Migration] ✅ Done! $uploaded tools uploaded to Supabase.');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_migrationKey, true);
      return MigrationResult(success: true, count: uploaded);

    } catch (e) {
      debugPrint('[Migration] ❌ Failed: $e');
      return MigrationResult(success: false, error: e.toString());
    }
  }
}

class MigrationResult {
  final bool success;
  final int count;
  final String? error;
  const MigrationResult({required this.success, this.count = 0, this.error});
}
