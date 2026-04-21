// ══════════════════════════════════════════════════════════════
// SYNAP — Pricing Plans with Renewal Logic
// Student:      ₹17/2mo | ₹14/7mo | ₹59/yr
// Professional: ₹5/1mo | ₹19/6mo | ₹34/yr
//
// ⚠️ These IDs must match EXACTLY what you create in Play Console
//    Go to: Play Console → Monetize → Subscriptions → Create
// ══════════════════════════════════════════════════════════════

class SynapPlans {
  // ── STUDENT TIER ────────────────────────────────────────
  static const String student2Month  = 'synap_student_2month';   // ₹17 • auto-renew
  static const String student7Month  = 'synap_student_7month';   // ₹14 • auto-renew
  static const String studentYearly  = 'synap_student_yearly';   // ₹59 • auto-renew

  // ── PROFESSIONAL TIER ───────────────────────────────────
  static const String pro1Month      = 'synap_pro_1month';       // ₹5 • auto-renew
  static const String pro6Month      = 'synap_pro_6month';       // ₹19 • auto-renew
  static const String proYearly      = 'synap_pro_yearly';       // ₹34 • auto-renew

  // All product IDs for querying
  static const Set<String> allIds = {
    student2Month,
    student7Month,
    studentYearly,
    pro1Month,
    pro6Month,
    proYearly,
  };

  // Plan renewal types (ALL subscriptions auto-renew)
  static const Map<String, bool> autoRenewing = {
    student2Month: true,     // auto-renew
    student7Month: true,     // auto-renew
    studentYearly: true,     // auto-renew
    pro1Month: true,         // auto-renew
    pro6Month: true,         // auto-renew
    proYearly: true,         // auto-renew
  };

  // Plan duration in days
  static const Map<String, int> durationDays = {
    student2Month: 60,       // 2 months ≈ 60 days
    student7Month: 210,      // 7 months ≈ 210 days
    studentYearly: 365,      // 1 year = 365 days
    pro1Month: 30,           // 1 month ≈ 30 days
    pro6Month: 180,          // 6 months ≈ 180 days
    proYearly: 365,          // 1 year = 365 days
  };

  // Helper to check if a product ID is a Professional tier plan
  static bool isPro(String id) => id == pro1Month || id == pro6Month || id == proYearly;
  
  // Helper to check if plan auto-renews
  static bool isAutoRenewing(String id) => autoRenewing[id] ?? false;
  
  // Helper to get duration in days
  static int getDurationDays(String id) => durationDays[id] ?? 30;

  // Static plan definitions (shown before Play Store responds)
  static const List<PlanDefinition> studentPlans = [
    PlanDefinition(
      id: student2Month,
      tier: PlanTier.student,
      label: 'Student Plan',
      price: '₹17',
      priceValue: 17,
      period: '2 months',
      perMonth: '₹8.5/mo',
      highlight: 'STARTER',
    ),
    PlanDefinition(
      id: student7Month,
      tier: PlanTier.student,
      label: '7 Months',
      price: '₹14',
      oldPrice: '₹49',
      priceValue: 14,
      period: '7 months',
      perMonth: '₹2/mo',
      highlight: 'LIMITED TIME',
    ),
    PlanDefinition(
      id: studentYearly,
      tier: PlanTier.student,
      label: '1 Year',
      price: '₹59',
      priceValue: 59,
      period: '1 year',
      perMonth: '₹4.9/mo',
      highlight: 'BEST VALUE',
    ),
  ];

  static const List<PlanDefinition> proPlans = [
    PlanDefinition(
      id: pro1Month,
      tier: PlanTier.professional,
      label: '1 Month',
      price: '₹5',
      priceValue: 5,
      period: '1 month',
      perMonth: '₹5/mo',
      highlight: 'BEST REFILL',
    ),
    PlanDefinition(
      id: pro6Month,
      tier: PlanTier.professional,
      label: 'Professional Plan',
      price: '₹19',
      priceValue: 19,
      period: '6 months',
      perMonth: '₹3.16/mo',
      highlight: 'PRO ACCESS',
    ),
    PlanDefinition(
      id: proYearly,
      tier: PlanTier.professional,
      label: '1 Year',
      price: '₹34',
      priceValue: 34,
      period: '1 year',
      perMonth: '₹2.8/mo',
      highlight: 'BEST VALUE',
    ),
  ];
}


enum PlanTier { student, professional }

class PlanDefinition {
  final String id;
  final PlanTier tier;
  final String label;
  final String price;
  final String? oldPrice;
  final double priceValue;
  final String period;
  final String perMonth;
  final String? highlight; // badge text

  const PlanDefinition({
    required this.id,
    required this.tier,
    required this.label,
    required this.price,
    this.oldPrice,
    required this.priceValue,
    required this.period,
    required this.perMonth,
    this.highlight,
  });

  bool get isStudent      => tier == PlanTier.student;
  bool get isProfessional => tier == PlanTier.professional;
}
