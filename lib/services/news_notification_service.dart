// ══════════════════════════════════════════════════════════════
// SYNAP — NewsNotificationService
// Sends local push notifications for new AI news articles
// Uses Workmanager for BACKGROUND execution (even when app is killed)
// ══════════════════════════════════════════════════════════════

import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'news_service.dart';

/// Background task name — must match in callbackDispatcher
const String _newsCheckTaskName = 'synap_news_check';
const String _newsCheckTaskTag = 'synap_news_periodic';
const String _notifQuotaDateKey = 'synap_notif_quota_date';
const String _notifQuotaCountKey = 'synap_notif_quota_count';
const int _notifDailyLimit = 3;

Future<bool> _consumeNotificationQuota() async {
  final prefs = await SharedPreferences.getInstance();
  final now = DateTime.now();
  final today = '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

  final savedDate = prefs.getString(_notifQuotaDateKey);
  var count = prefs.getInt(_notifQuotaCountKey) ?? 0;

  if (savedDate != today) {
    count = 0;
    await prefs.setString(_notifQuotaDateKey, today);
    await prefs.setInt(_notifQuotaCountKey, 0);
  }

  if (count >= _notifDailyLimit) {
    return false;
  }

  await prefs.setInt(_notifQuotaCountKey, count + 1);
  return true;
}

/// ── Top-level callback for Workmanager (MUST be top-level) ──
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    // In background isolates, Flutter plugins are not registered by default.
    // This must run before using SharedPreferences / notifications.
    WidgetsFlutterBinding.ensureInitialized();
    ui.DartPluginRegistrant.ensureInitialized();

    if (taskName == _newsCheckTaskName || taskName == Workmanager.iOSBackgroundTask) {
      try {
        debugPrint('[NewsNotification BG] 🔄 Background task started');
        await _BackgroundNewsChecker.checkAndNotify();
        debugPrint('[NewsNotification BG] ✅ Background task completed');
      } catch (e) {
        debugPrint('[NewsNotification BG] ❌ Background task error: $e');
      }
    }
    return Future.value(true);
  });
}

/// Helper class for background execution (no Flutter UI context)
class _BackgroundNewsChecker {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> checkAndNotify() async {
    // Initialize notifications plugin (needed in background isolate)
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _notifications.initialize(initSettings);

    final prefs = await SharedPreferences.getInstance();

    // Check if user has notifications enabled
    final notificationsEnabled = prefs.getBool('user_notifications_enabled') ?? true;
    if (!notificationsEnabled) return;

    // Fetch latest news
    final news = await NewsService.fetchNews(force: true);
    if (news.isEmpty) return;

    // Use ID-based tracking so we notify for truly new articles even if the RSS timestamp may be old.
    final lastNotifIds = prefs.getStringList('news_last_notif_ids') ?? [];
    final newArticles = news.where((n) => !lastNotifIds.contains(n.id)).toList();

    // If this is the first run, default to notifying for the latest batch (so the user sees activity)
    if (lastNotifIds.isEmpty && newArticles.length > 0) {
      // Keep at most 5 on first run to avoid spam.
      newArticles.removeRange(5, newArticles.length);
    }

    if (newArticles.isEmpty) {
      debugPrint('[NewsNotification BG] No new articles found (already seen ${lastNotifIds.length} IDs)');
      return;
    }

    // Send only one notification per cycle (prevents bursts).
    final breakingNews =
        newArticles.where((n) => n.category == 'breaking' || n.category == 'launch').toList();
    final top = breakingNews.isNotEmpty ? breakingNews.first : newArticles.first;
    await _sendNotification(
      title: '${top.categoryEmoji} ${top.sourceName}',
      body: top.title,
      id: top.id.hashCode.abs() % 100000,
    );

    // Remember which articles we've notified about.
    // Keep only the most recent 100 IDs to avoid unbounded storage growth.
    final updatedIds = [
      ...newArticles.map((n) => n.id),
      ...lastNotifIds,
    ];
    final uniqueIds = updatedIds.toSet().toList().take(100).toList();
    await prefs.setStringList('news_last_notif_ids', uniqueIds);

    debugPrint('[NewsNotification BG] Sent notifications for ${newArticles.length} new articles. Stored IDs: ${uniqueIds.length}');
  }

  static Future<void> _sendNotification({
    required String title,
    required String body,
    required int id,
  }) async {
    try {
      final allowed = await _consumeNotificationQuota();
      if (!allowed) {
        debugPrint('[NewsNotification BG] Daily notification limit reached ($_notifDailyLimit/day), skipping');
        return;
      }

      await _notifications.show(
        id,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'synap_ai_news',
            'AI News',
            channelDescription: 'Live AI news notifications from Synap',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
            icon: '@mipmap/ic_launcher',
            groupKey: 'synap_news',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
    } catch (e) {
      debugPrint('[NewsNotification BG] Send error: $e');
    }
  }
}

class NewsNotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  /// Initialize notification plugin + register background tasks
  static Future<void> init() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);
    await _notifications.cancelAll();
    _initialized = true;

    // Request permission on Android 13+
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // ── Register Workmanager for background execution ──
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );

    // Cancel any old tasks and re-register
    await Workmanager().cancelByTag(_newsCheckTaskTag);

    // Register periodic task — runs every 15 minutes (minimum for Workmanager)
    await Workmanager().registerPeriodicTask(
      _newsCheckTaskName,
      _newsCheckTaskName,
      tag: _newsCheckTaskTag,
      frequency: const Duration(minutes: 15),
      initialDelay: const Duration(minutes: 1),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      backoffPolicy: BackoffPolicy.linear,
      backoffPolicyDelay: const Duration(minutes: 5),
    );

    // Keep a single source of truth for notifications (background scheduler)
    // to avoid duplicate alerts while app is foreground + background active.

    debugPrint('[NewsNotification] ✅ Initialized with background tasks');
  }

  /// Clean up
  static void dispose() {
    // No-op: background scheduler managed by Workmanager.
  }
}
