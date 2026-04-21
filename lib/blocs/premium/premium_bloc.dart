// ══════════════════════════════════════════════════════════════
// SYNAP — PremiumBloc
// Full Google Play Billing via in_app_purchase
// + Supabase server-side purchase verification (Layer 2)
// Handles: Student + Professional tiers, restore, errors
// ══════════════════════════════════════════════════════════════

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';
import '../../services/secure_storage_service.dart';
import 'premium_event.dart';
import 'premium_state.dart';
import 'premium_plans.dart';

export 'premium_state.dart';
export 'premium_event.dart';
export 'premium_plans.dart';

// SharedPreferences keys
const _kIsPremium      = 'synap_is_premium';
const _kActivePlan     = 'synap_active_plan';
const _kActiveTier     = 'synap_active_tier';
const _kPurchaseToken  = 'synap_purchase_token';
const _kPremiumUserId  = 'synap_premium_user_id';
const _kExpiryDate     = 'synap_expiry_date';
const _kIsAutoRenewing = 'synap_is_auto_renewing';
const Set<String> _kOwnerEmails = {
  'zaptime.official@gmail.com',
  'zaptime@gmail.com',
};

class PremiumBloc extends Bloc<PremiumEvent, PremiumState> {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;
  Completer<void>? _restoreCompleter;

  PremiumBloc() : super(PremiumState.initial()) {
    on<PremiumInitialized>(_onInit);
    on<PremiumPurchaseStarted>(_onPurchaseStarted);
    on<PremiumPurchaseUpdated>(_onPurchaseUpdated);
    on<PremiumPurchaseRestored>(_onRestore);
    on<PremiumPurchaseError>(_onError);
    on<PremiumUnlocked>(_onUnlocked);

    add(PremiumInitialized());
  }

  // ══════════════════════════════════════════════════════════
  // 1. INITIALIZE
  // ══════════════════════════════════════════════════════════
  Future<void> _onInit(
    PremiumInitialized event,
    Emitter<PremiumState> emit,
  ) async {
    emit(state.copyWith(status: PremiumStatus.loading));

    // ── Step 1: Check cached premium (only if it belongs to current user) ──
    final prefs = await SharedPreferences.getInstance();
    final currentUserId = AuthService.userId;
    final cachedPremium = prefs.getBool(_kIsPremium) ?? false;
    final cachedPlan    = prefs.getString(_kActivePlan);
    final cachedTierStr = prefs.getString(_kActiveTier);
    final cachedUserId  = prefs.getString(_kPremiumUserId);
    final cachedExpiryStr = prefs.getString(_kExpiryDate);
    final cachedIsAutoRenewing = prefs.getBool(_kIsAutoRenewing) ?? false;
    
    final cachedExpiryDate = cachedExpiryStr != null 
        ? DateTime.tryParse(cachedExpiryStr)
        : null;
    
    final currentEmail  = Supabase.instance.client.auth.currentUser?.email?.toLowerCase().trim();
    final cachedTier    = cachedTierStr == 'professional'
        ? PlanTier.professional
        : cachedTierStr == 'student'
            ? PlanTier.student
            : null;

    final isOwner = currentEmail != null && _kOwnerEmails.contains(currentEmail);

    // Owner account always has full access
    if (isOwner) {
      await prefs.setBool(_kIsPremium, true);
      await prefs.setString(_kActivePlan, SynapPlans.proYearly);
      await prefs.setString(_kActiveTier, 'professional');
      if (currentUserId != null) {
        await prefs.setString(_kPremiumUserId, currentUserId);
      }
      final ownerExpiry = DateTime.now().add(const Duration(days: 36500)); // 100 years
      await prefs.setString(_kExpiryDate, ownerExpiry.toIso8601String());
      await prefs.setBool(_kIsAutoRenewing, true);
      
      emit(state.copyWith(
        isPremium: true,
        activeProductId: SynapPlans.proYearly,
        activeTier: PlanTier.professional,
        expiryDate: ownerExpiry,
        isAutoRenewing: true,
        status: PremiumStatus.idle,
      ));
    }

    final cacheBelongsToCurrentUser =
        cachedPremium &&
        (
          // Logged-in user should match cached owner
          (currentUserId != null && cachedUserId != null && cachedUserId == currentUserId) ||
          // Guest/local entitlement should remain valid on the same device
          (currentUserId == null)
        );

    if (isOwner) {
      // keep owner override as source of truth
    } else if (cacheBelongsToCurrentUser) {
        // If no expiry is stored, keep entitlement instead of forcing false.
        final isStillValid = cachedExpiryDate == null ||
          DateTime.now().isBefore(cachedExpiryDate);
      
      emit(state.copyWith(
        isPremium: isStillValid,
        activeProductId: cachedPlan,
        activeTier: cachedTier,
        expiryDate: cachedExpiryDate,
        isAutoRenewing: cachedIsAutoRenewing,
        status: PremiumStatus.idle,
      ));
    } else {
      await _clearLocalPremiumCache(prefs);
      emit(state.copyWith(
        isPremium: false,
        status: PremiumStatus.idle,
        clearActive: true,
      ));
    }

    // ── Step 2: Verify from Supabase for logged-in users ─────
    if (!isOwner) {
      await _checkSupabasePremium(emit);
    }


    // ── Step 3: Check billing availability ──────────────────
    final available = await _iap.isAvailable();
    if (!available) {
      emit(state.copyWith(
        status: PremiumStatus.error,
        errorMessage: 'Google Play Billing not available.',
        billingAvailable: false,
      ));
      return;
    }

    emit(state.copyWith(billingAvailable: true));

    // ── Step 4: Subscribe to purchase stream ────────────────
    _purchaseSub?.cancel();
    _purchaseSub = _iap.purchaseStream.listen(
      (list) => add(PremiumPurchaseUpdated(list)),
      onError: (e) => add(PremiumPurchaseError(e.toString())),
    );

    // ── Step 5: Load products from Play Store ───────────────
    await _loadProducts(emit);
  }

  Future<void> _loadProducts(Emitter<PremiumState> emit) async {
    try {
      final response = await _iap.queryProductDetails(SynapPlans.allIds);

      if (response.error != null) {
        // Non-fatal — UI still works with static prices
        emit(state.copyWith(
          status: PremiumStatus.idle,
          errorMessage: null, // don't show to user
        ));
        return;
      }

      emit(state.copyWith(
        status: PremiumStatus.idle,
        products: response.productDetails,
        clearError: true,
      ));
    } catch (e) {
      // Non-fatal — static prices will be used
      emit(state.copyWith(status: PremiumStatus.idle));
    }
  }

  // ══════════════════════════════════════════════════════════
  // 2. PURCHASE STARTED
  // ══════════════════════════════════════════════════════════
  Future<void> _onPurchaseStarted(
    PremiumPurchaseStarted event,
    Emitter<PremiumState> emit,
  ) async {
    emit(state.copyWith(
      status: PremiumStatus.purchasing,
      clearError: true,
    ));

    try {
      // ── If products list is empty, retry loading first ───────
      if (state.products.isEmpty) {
        try {
          final response = await _iap.queryProductDetails(SynapPlans.allIds);
          if (response.productDetails.isNotEmpty) {
            emit(state.copyWith(products: response.productDetails));
          }
        } catch (_) {}
      }

      // Find product details
      ProductDetails? product;
      try {
        product = state.products.firstWhere((p) => p.id == event.productId);
      } catch (_) {
        // Product still not found — diagnose why
        final bool billingOk = await _iap.isAvailable();
        emit(state.copyWith(
          status: PremiumStatus.error,
          errorMessage: !billingOk
              ? 'Google Play Billing not available on this device.'
              : 'Plan not available.\n\nCheck Play Console → Subscriptions:\nProduct ID: "${event.productId}"\nInstall app from Play Internal/Closed testing link (not sideload APK).',
        ));
        return;
      }

      final param = PurchaseParam(productDetails: product);


      // Buy consumable/non-consumable based on logic
      final success = await _iap.buyNonConsumable(purchaseParam: param);

      if (!success) {
        emit(state.copyWith(
          status: PremiumStatus.error,
          errorMessage: 'Failed to initiate purchase. Please try again.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: PremiumStatus.error,
        errorMessage: _friendlyError(e.toString()),
      ));
    }
  }

  // ══════════════════════════════════════════════════════════
  // 3. PURCHASE STREAM UPDATES
  // ══════════════════════════════════════════════════════════
  Future<void> _onPurchaseUpdated(
    PremiumPurchaseUpdated event,
    Emitter<PremiumState> emit,
  ) async {
    for (final purchase in event.purchases) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          emit(state.copyWith(status: PremiumStatus.purchasing));
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _deliver(purchase, emit);
          break;

        case PurchaseStatus.error:
          final code = purchase.error?.code ?? '';
          if (code == 'BillingResponse.userCanceled' || code == '1') {
            emit(state.copyWith(status: PremiumStatus.idle));
          } else {
            emit(state.copyWith(
              status: PremiumStatus.error,
              errorMessage: _friendlyError(purchase.error?.message ?? 'Purchase failed'),
            ));
          }
          break;

        case PurchaseStatus.canceled:
          emit(state.copyWith(status: PremiumStatus.idle, clearError: true));
          break;
      }

      if (purchase.pendingCompletePurchase) {
        // ── RACE CONDITION FIX ──
        // Only complete non-success states here. 
        // Success states (purchased/restored) will be completed inside _deliver 
        // AFTER successful server-side confirmation.
        if (purchase.status != PurchaseStatus.purchased && 
            purchase.status != PurchaseStatus.restored) {
          await _iap.completePurchase(purchase);
        }
      }

      // ── Signal restore completion ──
      if (purchase.status == PurchaseStatus.restored || 
          purchase.status == PurchaseStatus.error) {
        if (_restoreCompleter != null && !_restoreCompleter!.isCompleted) {
          _restoreCompleter!.complete();
        }
      }
    }
  }

  // ══════════════════════════════════════════════════════════
  // 4. DELIVER PURCHASE (unlock premium)
  // ══════════════════════════════════════════════════════════
  Future<void> _deliver(
    PurchaseDetails purchase,
    Emitter<PremiumState> emit,
  ) async {
    final productId = purchase.productID;
    final tier = SynapPlans.isPro(productId) ? PlanTier.professional : PlanTier.student;
    final purchaseToken = purchase.verificationData.serverVerificationData;
    final isAutoRenewing = SynapPlans.isAutoRenewing(productId);
    final durationDays = SynapPlans.getDurationDays(productId);

    // ─── SECURITY: Validate purchase token ───────────────────
    if (purchaseToken.isEmpty) {
      emit(state.copyWith(
        status: PremiumStatus.error,
        errorMessage: 'Invalid purchase verification. Please try again.',
      ));
      return;
    }

    // ─── Calculate expiry date ───────────────────────────────
    final expiryDate = DateTime.now().add(Duration(days: durationDays));

    // ─── Server-side: Save to Supabase (with timeout) ────────
    // IMPORTANT: User already paid! We MUST complete the purchase 
    // even if server verification times out. Server can re-verify later.
    try {
      await _syncToSupabase(
        productId: productId,
        tier: tier,
        purchaseToken: purchaseToken,
        purchaseId: purchase.purchaseID,
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          // Server verification timed out, but payment is already processed
          // Complete the purchase anyway - user will resync when network is back
          return false;
        },
      );
    } catch (e) {
      // Server verification failed but user paid - continue anyway
      if (kDebugMode) debugPrint('[PremiumBloc] Server sync error: $e');
    }

    // ─── ALWAYS complete the purchase (user already paid!) ────
    if (purchase.pendingCompletePurchase) {
      await _iap.completePurchase(purchase);
    }

    // ─── Persist locally ─────────────────────────────────────
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kIsPremium, true);
    await prefs.setString(_kActivePlan, productId);
    await prefs.setString(_kActiveTier, tier == PlanTier.professional ? 'professional' : 'student');
    
    // SECURITY: Store purchase token securely (encrypted)
    await SecureStorageService.savePurchaseToken(purchaseToken);
    await SecureStorageService.savePurchaseId(purchase.purchaseID ?? '');
    
    await prefs.setString(_kExpiryDate, expiryDate.toIso8601String());
    await prefs.setBool(_kIsAutoRenewing, isAutoRenewing);
    final currentUserId = AuthService.userId;
    if (currentUserId != null) {
      await prefs.setString(_kPremiumUserId, currentUserId);
      await SecureStorageService.saveUserId(currentUserId);
    }

    // ─── Emit success (payment complete!) ────────────────────
    emit(state.copyWith(
      isPremium: true,
      status: PremiumStatus.success,
      activeProductId: productId,
      activeTier: tier,
      expiryDate: expiryDate,
      isAutoRenewing: isAutoRenewing,
      clearError: true,
    ));
  }

  // ══════════════════════════════════════════════════════════
  // 5. RESTORE PURCHASES
  // ══════════════════════════════════════════════════════════
  Future<void> _onRestore(
    PremiumPurchaseRestored event,
    Emitter<PremiumState> emit,
  ) async {
    emit(state.copyWith(status: PremiumStatus.restoring, clearError: true));

    try {
      _restoreCompleter = Completer<void>();

      await _iap.restorePurchases();
      
      // Wait for the stream to signal completion (via _onPurchaseUpdated)
      // or timeout after 10 seconds if no purchases are found
      await _restoreCompleter!.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () {

        },
      );

      _restoreCompleter = null;

      if (!state.isPremium) {
        await _checkSupabasePremium(emit);
        
        if (!state.isPremium) {
          emit(state.copyWith(
            status: PremiumStatus.error,
            errorMessage: 'No previous purchase found for this account.',
          ));
        }
      }
    } catch (e) {
      emit(state.copyWith(
        status: PremiumStatus.error,
        errorMessage: 'Restore failed: ${_friendlyError(e.toString())}',
      ));
    } finally {
      _restoreCompleter = null;
    }
  }

  // ══════════════════════════════════════════════════════════
  // 6. FORCE UNLOCK (after server validation if needed)
  // ══════════════════════════════════════════════════════════
  Future<void> _onUnlocked(
    PremiumUnlocked event,
    Emitter<PremiumState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final tier  = SynapPlans.isPro(event.productId) ? PlanTier.professional : PlanTier.student;
    await prefs.setBool(_kIsPremium, true);
    await prefs.setString(_kActivePlan, event.productId);
    await prefs.setString(_kActiveTier, tier == PlanTier.professional ? 'professional' : 'student');
    final currentUserId = AuthService.userId;
    if (currentUserId != null) {
      await prefs.setString(_kPremiumUserId, currentUserId);
    }

    emit(state.copyWith(
      isPremium: true,
      status: PremiumStatus.success,
      activeProductId: event.productId,
      activeTier: tier,
    ));
  }

  // ══════════════════════════════════════════════════════════
  // 7. ERROR
  // ══════════════════════════════════════════════════════════
  void _onError(PremiumPurchaseError event, Emitter<PremiumState> emit) {
    emit(state.copyWith(
      status: PremiumStatus.error,
      errorMessage: _friendlyError(event.message),
    ));
  }

  // ══════════════════════════════════════════════════════════
  // SERVER-SIDE: Sync purchase to Supabase
  // ══════════════════════════════════════════════════════════
  Future<bool> _syncToSupabase({
    required String productId,
    required PlanTier tier,
    required String purchaseToken,
    String? purchaseId,
  }) async {
    try {
      final userId = AuthService.userId;
      if (userId == null) return false;


      
      final res = await Supabase.instance.client.functions.invoke(
        'verify-purchase',
        body: {
          'productId': productId,
          'purchaseToken': purchaseToken,
          'package_name': 'com.synap.synap', 
        },
        headers: { 'x-user-id': userId },
      );

      if (res.status == 200) {

        return true;
      } else {

        return false;
      }
    } catch (e) {

      return false;
    }
  }

  // ══════════════════════════════════════════════════════════
  // SERVER-SIDE: Check Supabase for existing subscription
  // ══════════════════════════════════════════════════════════
  Future<void> _checkSupabasePremium(Emitter<PremiumState> emit) async {
    try {
      final userId = AuthService.userId;
      if (userId == null) return;

      final sb = Supabase.instance.client;
      final res = await sb.from('subscriptions')
          .select()
          .eq('user_id', userId)
          .eq('status', 'active')
          .maybeSingle();

      if (res != null) {
        final productId = (res['product_id'] as String?) ?? SynapPlans.pro6Month;
        final tierFromDb = res['tier'];
        final tierStr = (tierFromDb is String && tierFromDb.isNotEmpty)
            ? tierFromDb
            : (SynapPlans.isPro(productId) ? 'professional' : 'student');
        final tier = tierStr == 'professional'
            ? PlanTier.professional
            : PlanTier.student;

        // Save to local cache
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_kIsPremium, true);
        await prefs.setString(_kActivePlan, productId);
        await prefs.setString(_kActiveTier, tierStr);
        await prefs.setString(_kPremiumUserId, userId);

        emit(state.copyWith(
          isPremium: true,
          activeProductId: productId,
          activeTier: tier,
          status: PremiumStatus.idle,
        ));


      } else {
        final prefs = await SharedPreferences.getInstance();
        final localPremium = prefs.getBool(_kIsPremium) ?? false;
        final localExpiryStr = prefs.getString(_kExpiryDate);
        final localExpiry = localExpiryStr != null ? DateTime.tryParse(localExpiryStr) : null;
        final localStillValid = localPremium && (localExpiry == null || DateTime.now().isBefore(localExpiry));

        if (!localStillValid) {
          await _clearLocalPremiumCache(prefs);
          emit(state.copyWith(
            isPremium: false,
            status: PremiumStatus.idle,
            clearActive: true,
          ));
        } else {
          // Do not downgrade a valid local purchase if server sync is delayed.
          emit(state.copyWith(status: PremiumStatus.idle));
        }
      }
    } catch (e) {
      // Non-fatal: will fall back to Google Play restore

    }
  }

  Future<void> _clearLocalPremiumCache(SharedPreferences prefs) async {
    await prefs.remove(_kIsPremium);
    await prefs.remove(_kActivePlan);
    await prefs.remove(_kActiveTier);
    await prefs.remove(_kPurchaseToken);
    await prefs.remove(_kPremiumUserId);
    await prefs.remove(_kExpiryDate);
    await prefs.remove(_kIsAutoRenewing);
    
    // SECURITY: Clear encrypted secure storage
    await SecureStorageService.clearSecureData();
  }

  String _friendlyError(String raw) {
    final r = raw.toLowerCase();
    if (r.contains('cancel') || r.contains('usercanceled') || r.contains('user canceled')) {
      return 'Purchase was cancelled.';
    }
    if (r.contains('network') || r.contains('service_unavailable') || r.contains('billing_unavailable')) {
      return 'Billing service unavailable. Check internet and Play Store, then retry.';
    }
    if (r.contains('item_unavailable')) {
      return 'This plan is not active in Play Console for your current test track.';
    }
    if (r.contains('already_owned')) {
      return 'You already own this plan. Try "Restore Purchase".';
    }
    if (r.contains('developer_error') || r.contains('not configured for billing through google play')) {
      return 'This build is not linked to Play Billing. Install the app from Play Internal/Closed testing and use a license tester account.';
    }
    return raw.length > 80 ? '${raw.substring(0, 80)}...' : raw;
  }

  // ══════════════════════════════════════════════════════════
  // 8. COMPLIANCE: Subscription Management
  // ══════════════════════════════════════════════════════════
  static Future<void> openSubscriptionManagement() async {
    final url = Uri.parse('https://play.google.com/store/account/subscriptions');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Future<void> close() {
    _purchaseSub?.cancel();
    return super.close();
  }
}
