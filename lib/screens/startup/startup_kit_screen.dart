import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
// google_fonts used via pubspec theme
import 'pro_kit_screen.dart';
import '../../blocs/premium/premium_bloc.dart';
import '../../blocs/premium/premium_plans.dart';
import '../../widgets/moving_border_button.dart';

// ═══════════════════════════════════════════════════════════════
// SYNAP — STARTUP KIT SCREEN v6 (Appointy-style Premium UI)
// ═══════════════════════════════════════════════════════════════

// ── Design Tokens ────────────────────────────────────────────
const _kBgTop    = Color(0xFF1A0A4A);
const _kBgMid    = Color(0xFF0D0825);
const _kBgBot    = Color(0xFF07080F);
const _kPurple   = Color(0xFF7C3AED);
const _kPurpleL  = Color(0xFF9F6FFF);
const _kCyan     = Color(0xFF00D4FF);
const _kGold     = Color(0xFFFFB800);
const _kGreen    = Color(0xFF00E5A0);
const _kCard     = Color(0xFF130D35);
const _kCardBd   = Color(0xFF2A1F5A);
const _kTextDim  = Color(0xFF8B7FC0);
const _kTextMid  = Color(0xFFBBB0E8);

// ── Data Models (unchanged) ───────────────────────────────────
class _Doc {
  final String title, subtitle, emoji, filename;
  final Color color;
  final List<String> sections;
  final List<Map<String, String>> content;
  const _Doc({required this.title, required this.subtitle, required this.emoji, required this.filename, required this.color, required this.sections, required this.content});
}

const List<_Doc> _docs = [
  _Doc(title: 'PRD', subtitle: 'Product Requirements Doc', emoji: '📋', filename: 'PRD', color: Color(0xFF6C63FF),
    sections: ['💗 Target Users', '👥 Problem Statement', '✨ Core Features', '📊 Success Metrics', '🗓️ Timeline', '⚠️ Risks'],
    content: [
      {'heading': 'Problem Statement', 'body': 'Describe the core problem your product solves.\nWho faces this problem? How painful is it?\nWhat existing solutions fail and why?'},
      {'heading': 'Target Users', 'body': 'Primary: [User persona 1 — age, role, pain]\nSecondary: [User persona 2]\nUser stories:\n• As a [user], I want to [action] so that [benefit].\n• As a [user], I need [feature] because [reason].'},
      {'heading': 'Core Features (MVP)', 'body': 'P0 (Must Have):\n• Feature 1 — reason why essential\n• Feature 2 — reason why essential\n\nP1 (Should Have):\n• Feature 4\n• Feature 5\n\nP2 (Nice to Have):\n• Feature 6'},
      {'heading': 'Success Metrics', 'body': 'Acquisition: DAU target, MAU target\nActivation: % users completing onboarding (target: 60%+)\nRetention: D7 retention (target: 40%+), D30 (20%+)\nRevenue: MRR target at 3 months, 6 months, 12 months\nNPS: Target score 50+'},
      {'heading': 'Timeline & Milestones', 'body': 'Week 1-2: Discovery + design\nWeek 3-4: MVP development sprint 1\nWeek 5-6: MVP development sprint 2\nWeek 7: Internal testing + bug fixes\nWeek 8: Beta launch (100 users)\nWeek 10: Public launch\nWeek 12: First revenue milestone'},
      {'heading': 'Assumptions & Risks', 'body': 'Assumptions:\n• Users will pay [price] for [value]\n• Market size is large enough\n\nRisks:\n• Competitor launches similar product\n• Regulatory changes in market\n• Tech dependency / API changes'},
    ]),
  _Doc(title: 'System Design', subtitle: 'Architecture Blueprint', emoji: '🏗️', filename: 'SystemDesign', color: Color(0xFF00D4AA),
    sections: ['🔌 API Design', '🗄️ Database Schema', '📡 Data Flow', '⚡ Scalability'],
    content: [
      {'heading': 'API Design', 'body': 'Type: REST API (or GraphQL if complex queries needed)\nBase URL: https://api.yourapp.com/v1\n\nEndpoints:\nPOST  /auth/login\nPOST  /auth/signup\nGET   /users/:id\nPUT   /users/:id\n\nAuth: JWT Bearer tokens, 24h expiry, refresh tokens'},
      {'heading': 'Database Schema', 'body': 'Primary DB: PostgreSQL (via Supabase)\n\nCore Tables:\nusers (\n  id UUID PRIMARY KEY,\n  email TEXT UNIQUE,\n  name TEXT,\n  created_at TIMESTAMPTZ\n)\n\nsessions (\n  id UUID, user_id UUID,\n  token TEXT, expires_at TIMESTAMPTZ\n)'},
      {'heading': 'Data Flow', 'body': 'User → Flutter App → Supabase API → PostgreSQL DB\n\nReal-time: Supabase Realtime WebSockets\nCaching: Local Hive cache for offline support\nCDN: Supabase Storage for media files'},
      {'heading': 'Scalability Plan', 'body': 'Phase 1 (0 to 1K users):\n• Supabase free/pro tier\n• Single region deployment\n\nPhase 2 (1K+ users):\n• Supabase Pro + connection pooling\n• Add Redis for hot data'},
    ]),
  _Doc(title: 'Architecture', subtitle: 'Technical Structure', emoji: '⚙️', filename: 'Architecture', color: Color(0xFFFF6B6B),
    sections: ['📁 Folder Structure', '🧩 Design Patterns', '🔗 Dependencies', '🧪 Testing'],
    content: [
      {'heading': 'Flutter Folder Structure', 'body': 'lib/\n├── core/\n├── data/\n├── presentation/\n└── main.dart'},
      {'heading': 'Design Patterns', 'body': 'State Management: flutter_bloc (BLoC pattern)\nRepository Pattern: abstract data sources\nDependency Injection: get_it singleton'},
      {'heading': 'Key Dependencies', 'body': 'Core:\n• flutter_bloc: ^8.x\n• supabase_flutter: ^2.x\n• go_router: ^13.x\n\nNetwork: dio, json_serializable\nStorage: hive_flutter'},
      {'heading': 'Testing Strategy', 'body': 'Unit Tests: BLoC, repositories, utils\nWidget Tests: Reusable components\nIntegration Tests: Auth, core flows'},
    ]),
  _Doc(title: 'MVP TechDoc', subtitle: 'Launch Checklist', emoji: '🚀', filename: 'MVPTechDoc', color: Color(0xFFFFA940),
    sections: ['✅ MVP Scope', '🏃 Sprint Plan', '🛠️ Tech Stack', '🔢 Integrations'],
    content: [
      {'heading': 'MVP Scope Definition', 'body': 'IN SCOPE:\n✅ User authentication\n✅ Core main value prop\n✅ Basic user profile\n✅ Push notifications\n\nOUT OF SCOPE:\n❌ Advanced analytics\n❌ Team features\n❌ Desktop app'},
      {'heading': 'Sprint Breakdown (6 weeks)', 'body': 'Sprint 1: Foundation (Auth, DB, project setup)\nSprint 2: Core Feature implementation\nSprint 3: Polish, bug fixes, store assets & submission'},
      {'heading': 'Complete Tech Stack', 'body': 'Mobile: Flutter\nBackend: Supabase (Auth, DB, Storage)\nAnalytics: Mixpanel\nCI/CD: Codemagic'},
      {'heading': 'API Integrations', 'body': 'Required: Supabase, Firebase FCM\nRecommended: Sentry, Mixpanel\nOptional: Stripe, OpenAI'},
    ]),
];

class _Tool {
  final String name, url, emoji, desc, category;
  final bool isHot, isNew;
  const _Tool({required this.name, required this.url, required this.emoji, required this.desc, required this.category, this.isHot = false, this.isNew = false});
}

const List<_Tool> _allTools = [
  _Tool(name: 'Validator AI', url: 'https://validatorai.com', emoji: '✅', desc: 'AI feedback on your startup idea instantly', category: 'Validate', isHot: true),
  _Tool(name: 'IdeaBuddy', url: 'https://ideabuddy.com', emoji: '💭', desc: 'Guided idea development & validation', category: 'Validate'),
  _Tool(name: 'Upmetrics', url: 'https://upmetrics.co', emoji: '📊', desc: 'AI business plan builder with financials', category: 'Validate', isHot: true),
  _Tool(name: 'Strategyzer', url: 'https://strategyzer.com', emoji: '🎯', desc: 'Business model canvas & value proposition', category: 'Validate', isHot: true),
  _Tool(name: 'Plannit AI', url: 'https://plannit.ai', emoji: '🗓️', desc: 'AI-powered startup roadmap generator', category: 'Validate', isNew: true),
  _Tool(name: 'Namelix', url: 'https://namelix.com', emoji: '💡', desc: 'AI business name generator with logos', category: 'Brand', isHot: true),
  _Tool(name: 'Looka', url: 'https://looka.com', emoji: '🎨', desc: 'AI logo & complete brand identity kit', category: 'Brand', isHot: true),
  _Tool(name: 'GitHub Copilot', url: 'https://github.com/features/copilot', emoji: '🤖', desc: 'AI pair programmer in your editor', category: 'Build', isHot: true),
  _Tool(name: 'Cursor AI', url: 'https://cursor.com', emoji: '⌨️', desc: 'AI-first code editor for fast shipping', category: 'Build', isHot: true),
  _Tool(name: 'Framer AI', url: 'https://framer.com', emoji: '🖌️', desc: 'AI web design to production site', category: 'Build', isHot: true),
  _Tool(name: 'Supabase', url: 'https://supabase.com', emoji: '🗄️', desc: 'Open-source Firebase alternative', category: 'Build', isHot: true),
  _Tool(name: 'Gamma AI', url: 'https://gamma.app', emoji: '📊', desc: 'AI pitch deck and docs builder for founders', category: 'Grow', isHot: true),
  _Tool(name: 'Apollo.io', url: 'https://apollo.io', emoji: '🎯', desc: 'AI sales intelligence & prospecting', category: 'Grow', isHot: true),
  _Tool(name: 'Instantly AI', url: 'https://instantly.ai', emoji: '📧', desc: 'AI cold email at scale', category: 'Grow', isHot: true),
  _Tool(name: 'Causal AI', url: 'https://causal.app', emoji: '📉', desc: 'Financial modeling & scenario planning', category: 'Finance', isHot: true),
];

const List<String> _purposes = ['📱 Mobile App', '🌐 Web / SaaS', '🛒 E-Commerce', '🤖 AI Product', '🏢 Enterprise', '🎮 Game', '📚 EdTech', '🏥 HealthTech'];

// ── PDF Generator (unchanged) ─────────────────────────────────
class _PdfGen {
  static PdfColor _pc(Color c) => PdfColor(c.r / 255, c.g / 255, c.b / 255);
  static pw.Widget _section(String heading, String body, Color color) => pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
    pw.Container(width: double.infinity, padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 10), decoration: pw.BoxDecoration(color: _pc(color).shade(0.15), borderRadius: const pw.BorderRadius.only(topLeft: pw.Radius.circular(6), topRight: pw.Radius.circular(6))), child: pw.Text(heading, style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: _pc(color)))),
    pw.Container(width: double.infinity, padding: const pw.EdgeInsets.all(14), decoration: pw.BoxDecoration(border: pw.Border.all(color: _pc(color).shade(0.3)), borderRadius: const pw.BorderRadius.only(bottomLeft: pw.Radius.circular(6), bottomRight: pw.Radius.circular(6))), child: pw.Text(body, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey800, lineSpacing: 3))),
    pw.SizedBox(height: 14),
  ]);

  static Future<String> generateDoc(_Doc doc, String purpose) async {
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(pageFormat: PdfPageFormat.a4, margin: const pw.EdgeInsets.all(40),
      header: (ctx) => pw.Container(padding: const pw.EdgeInsets.all(16), margin: const pw.EdgeInsets.only(bottom: 16), decoration: pw.BoxDecoration(color: _pc(doc.color), borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8))),
        child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('SYNAP STARTUP KIT', style: pw.TextStyle(fontSize: 9, color: PdfColors.white, fontWeight: pw.FontWeight.bold, letterSpacing: 1.5)),
            pw.SizedBox(height: 4),
            pw.Text('${doc.title} — ${doc.subtitle}', style: pw.TextStyle(fontSize: 18, color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
          ]),
          pw.Container(padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: pw.BoxDecoration(color: const PdfColor(1, 1, 1, 0.2), borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4))), child: pw.Text(purpose, style: pw.TextStyle(fontSize: 10, color: PdfColors.white, fontWeight: pw.FontWeight.bold))),
        ])),
      build: (ctx) => [
        pw.Container(padding: const pw.EdgeInsets.all(12), margin: const pw.EdgeInsets.only(bottom: 20), decoration: pw.BoxDecoration(color: PdfColors.blue50, borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)), border: pw.Border.all(color: PdfColors.blue200)),
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('How to use with AI', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
            pw.Text('Upload this to Claude/ChatGPT and ask: "Complete this ${doc.title} for my $purpose startup."', style: const pw.TextStyle(fontSize: 10, color: PdfColors.blue800)),
          ])),
        ...doc.content.map((s) => _section(s['heading']!, s['body']!, doc.color)),
      ],
    ));
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/Synap_${doc.filename}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }
}

// ── Main Screen ───────────────────────────────────────────────
class StartupKitScreen extends StatefulWidget {
  const StartupKitScreen({super.key});
  @override State<StartupKitScreen> createState() => _StartupKitScreenState();
}

class _StartupKitScreenState extends State<StartupKitScreen> with TickerProviderStateMixin {
  late AnimationController _floatCtrl;
  late AnimationController _enterCtrl;
  late Animation<double> _floatAnim;
  late Animation<double> _enterAnim;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -6, end: 6).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
    _enterCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();
    _enterAnim = CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOut);
    context.read<PremiumBloc>().add(PremiumInitialized());
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _enterCtrl.dispose();
    super.dispose();
  }

  void _showDownloadSheet({_Doc? single}) {
    HapticFeedback.selectionClick();
    String? selected;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(builder: (ctx, setS) => Container(
        decoration: const BoxDecoration(color: _kCard, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 40),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 36, height: 4, decoration: BoxDecoration(color: _kCardBd, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 18),
          const Text('🚀 Choose Your Niche', style: TextStyle(fontFamily: 'Syne', fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 20),
          Wrap(spacing: 8, runSpacing: 8, children: _purposes.map((p) => ChoiceChip(
            label: Text(p, style: TextStyle(color: selected == p ? Colors.white : _kTextMid, fontSize: 12)),
            selected: selected == p,
            onSelected: (v) => setS(() => selected = p),
            backgroundColor: _kCard,
            selectedColor: _kPurple,
            side: BorderSide(color: selected == p ? _kPurple : _kCardBd),
          )).toList()),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: selected == null ? null : () async {
                Navigator.pop(context);
                final path = await _PdfGen.generateDoc(single ?? _docs[0], selected!);
                OpenFilex.open(path);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _kPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Download PDF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
            ),
          ),
        ]),
      )),
    );
  }

  void _startProPurchase() {
    HapticFeedback.heavyImpact();
    context.read<PremiumBloc>().add(PremiumPurchaseStarted(SynapPlans.pro6Month));
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<PremiumBloc, PremiumState>(
    builder: (context, state) {
      final isUnlocked = state.isPremium;
      return Scaffold(
        backgroundColor: _kBgBot,
        body: FadeTransition(
          opacity: _enterAnim,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHero(isUnlocked)),
              SliverToBoxAdapter(child: _buildCTA(isUnlocked)),
              SliverToBoxAdapter(child: _buildBundleSection(isUnlocked)),
              SliverToBoxAdapter(child: _buildDivider()),
              SliverToBoxAdapter(child: _buildSectionHeader('🚀  Free Starter Kit', 'Essential docs to build your MVP')),
              SliverToBoxAdapter(child: _buildStarterGrid(isUnlocked)),
              SliverToBoxAdapter(child: _buildSectionHeader('🔧  Essential Tools', 'Curated list for early stages')),
              SliverToBoxAdapter(child: _buildToolsList(isUnlocked)),
              const SliverToBoxAdapter(child: SizedBox(height: 60)),
            ],
          ),
        ),
      );
    },
  );

  // ── HERO ─────────────────────────────────────────────────
  Widget _buildHero(bool isUnlocked) => Container(
    height: 500,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [_kBgTop, _kBgMid, _kBgBot],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.0, 0.6, 1.0],
      ),
    ),
    child: Stack(clipBehavior: Clip.none, children: [
      // Glow blobs
      Positioned(top: -40, right: -40, child: _glowBlob(200, _kPurple, 0.25)),
      Positioned(top: 100, left: -60, child: _glowBlob(160, _kCyan, 0.10)),
      Positioned(bottom: 50, right: 30, child: _glowBlob(120, _kGold, 0.08)),

      // Top text (logo badge + heading + subtitle)
      Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 24, right: 24,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: _kPurple.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _kPurple.withValues(alpha: 0.4)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: const [
              Icon(Icons.rocket_launch_rounded, color: _kPurpleL, size: 13),
              SizedBox(width: 6),
              Text('STARTUP HUB', style: TextStyle(color: _kPurpleL, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.4)),
            ]),
          ),
          const SizedBox(height: 14),
          const Text('Smart, Simple\nLaunch Anytime.', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white, height: 1.2, letterSpacing: -0.5)),
          const SizedBox(height: 8),
          const Text('Everything you need to build,\nlaunch & grow your startup.',style: TextStyle(color: _kTextMid, fontSize: 13, height: 1.5)),
        ]),
      ),

      // Phone + floating cards
      Positioned(
        bottom: 0, left: 0, right: 0,
        child: _buildPhoneMockup(isUnlocked),
      ),
    ]),
  );

  Widget _glowBlob(double size, Color color, double opacity) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(colors: [color.withValues(alpha: opacity), Colors.transparent]),
    ),
  );

  // ── PHONE MOCKUP + FLOATING CARDS ────────────────────────
  Widget _buildPhoneMockup(bool isUnlocked) => SizedBox(
    height: 280,
    child: AnimatedBuilder(
      animation: _floatAnim,
      builder: (_, __) => Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Phone frame (center)
          Transform.translate(
            offset: Offset(0, _floatAnim.value * 0.3),
            child: _phoneFrame(isUnlocked),
          ),
          // Card 1 — Earning Lab (top-left)
          Positioned(left: 12, top: 10,
            child: Transform.translate(
              offset: Offset(-6, _floatAnim.value * 0.9),
              child: Transform.rotate(angle: -0.18,
                child: _floatingCard(icon: '🛠️', title: 'Earning Lab', subtitle: '50+ Pro AI Tools', color: _kPurple)),
            ),
          ),
          // Card 2 — Founder Pack (top-right)
          Positioned(right: 12, top: 5,
            child: Transform.translate(
              offset: Offset(8, _floatAnim.value * 1.1),
              child: Transform.rotate(angle: 0.15,
                child: _floatingCard(icon: '🚀', title: 'Founder Pack', subtitle: '₹1L in 48 Hours', color: const Color(0xFF0D6EFD))),
            ),
          ),
          // Card 3 — Free kit (bottom-left, small)
          Positioned(left: 20, bottom: 20,
            child: Transform.translate(
              offset: Offset(-4, _floatAnim.value * 0.7),
              child: Transform.rotate(angle: -0.10,
                child: _floatingCard(icon: '🎯', title: 'Free Kit', subtitle: 'PRD & Docs', color: _kGreen, isSmall: true)),
            ),
          ),
          // Card 4 — Bundle (bottom-right, small)
          Positioned(right: 18, bottom: 28,
            child: Transform.translate(
              offset: Offset(6, _floatAnim.value * 0.8),
              child: Transform.rotate(angle: 0.12,
                child: _floatingCard(icon: '💰', title: isUnlocked ? 'Pro Active' : 'Buy Synap Pro', subtitle: isUnlocked ? 'Unlocked' : '₹19 Access', color: _kGold, isSmall: true)),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _phoneFrame(bool isUnlocked) => Container(
    width: 130, height: 230,
    decoration: BoxDecoration(
      color: _kCard.withValues(alpha: 0.8),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: _kPurple.withValues(alpha: 0.3), width: 1.5),
      boxShadow: [
        BoxShadow(color: _kPurple.withValues(alpha: 0.15), blurRadius: 40, spreadRadius: 0),
        BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 10)),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Column(children: [
          const SizedBox(height: 10),
          Container(width: 40, height: 6, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(3))),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(children: [
              _miniRow('🛠️', 'Earning Lab'),
              const SizedBox(height: 8),
              _miniRow('🚀', 'Founder Pack'),
              const SizedBox(height: 8),
              _miniRow('🎯', 'Free Kit'),
              const SizedBox(height: 12),
              Container(
                width: double.infinity, height: 28,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [_kPurple, _kPurpleL]),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: _kPurple.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
                ),
                child: Center(child: Text(isUnlocked ? 'Startup Kit Ready' : 'Buy Synap Pro',
                  style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700))),
              ),
            ]),
          ),
        ]),
      ),
    ),
  );

  Widget _miniRow(String emoji, String label) => Row(children: [
    Text(emoji, style: const TextStyle(fontSize: 10)),
    const SizedBox(width: 6),
    Expanded(child: Container(height: 6, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(3)))),
    const SizedBox(width: 4),
    Container(width: 15, height: 6, decoration: BoxDecoration(color: _kPurple.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(3))),
  ]);

  Widget _floatingCard({required String icon, required String title, required String subtitle, required Color color, bool isSmall = false}) {
    final w = isSmall ? 115.0 : 135.0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: w,
          padding: EdgeInsets.all(isSmall ? 12 : 14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white.withValues(alpha: 0.12), Colors.white.withValues(alpha: 0.02)],
            ),
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 8)),
            ],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                width: isSmall ? 30 : 34, height: isSmall ? 30 : 34,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Center(child: Text(icon, style: TextStyle(fontSize: isSmall ? 14 : 16))),
              ),
              const Spacer(),
              Container(
                width: 6, height: 6,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: color, blurRadius: 6)],
                ),
              ),
            ]),
            SizedBox(height: isSmall ? 8 : 10),
            Text(title, style: TextStyle(color: Colors.white, fontSize: isSmall ? 11 : 12, fontWeight: FontWeight.w800, letterSpacing: -0.2)),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: isSmall ? 9 : 10, fontWeight: FontWeight.w500)),
          ]),
        ),
      ),
    );
  }

  // ── CTA BUTTON ───────────────────────────────────────────
  Widget _buildCTA(bool isUnlocked) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
    child: Column(children: [
      SynapMovingBorderButton(
        onTap: isUnlocked
            ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProKitScreen()))
            : _startProPurchase,
        borderRadius: 20,
        backgroundColor: _kPurple,
        glowColor: _kPurpleL,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            isUnlocked ? 'ACCESS STARTUP KIT ✅' : 'BUY SYNAP PRO',
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 0.8),
          ),
          if (!isUnlocked) ...[
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2), 
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: const Text('₹19', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900)),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 14),
          ],
        ]),
      ),
      const SizedBox(height: 12),
      Text('Unlock Startup Kit with Synap Pro (₹19)', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 12, fontWeight: FontWeight.w600)),
    ]),
  );

  // ── BUNDLE CARDS SECTION ──────────────────────────────────
  Widget _buildBundleSection(bool isUnlocked) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 36, 24, 0),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const Text('📦  What\'s Inside', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
        const Spacer(),
        Text('PRO BUNDLE', style: TextStyle(color: _kPurpleL.withValues(alpha: 0.8), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
      ]),
      const SizedBox(height: 20),
      // Earning Lab card
      GestureDetector(
        onTap: isUnlocked
            ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProKitScreen(initialIndex: 1)))
            : _startProPurchase,
        child: _premiumCard(
          icon: '🛠️', title: 'Earning Lab', subtitle: '50+ Pro AI Tools Arsenal',
          tag: 'TOOLS', tagColor: _kGold,
          desc: 'Curated AI tools for writing, design, code & automation to supercharge your workflow.',
          features: ['AI Writing', 'SEO Tools', 'Automation'],
          accentColor: _kGold,
          isUnlocked: isUnlocked,
        ),
      ),
      const SizedBox(height: 14),
      // Chain link
      Center(child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: _kPurple.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: _kPurple.withValues(alpha: 0.3), width: 1.5),
        ),
        child: const Icon(Icons.add_rounded, color: _kPurpleL, size: 24),
      )),
      const SizedBox(height: 14),
      // Founder Pack card
      GestureDetector(
        onTap: isUnlocked
            ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProKitScreen(initialIndex: 0)))
            : _startProPurchase,
        child: _premiumCard(
          icon: '🚀', title: 'Founder Pack', subtitle: 'Earn ₹1L in 48 Hours Roadmap',
          tag: 'ROADMAP', tagColor: _kGreen,
          desc: 'Tested step-by-step guide to launch fast, acquire users and earn your first ₹1 Lakh.',
          features: ['48hr Plan', 'Revenue Tips', 'Launch Kit'],
          accentColor: _kGreen,
          isUnlocked: isUnlocked,
        ),
      ),
      const SizedBox(height: 20),
      // Bundle strip
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            isUnlocked ? '✨  ALL-IN-ONE MASTERMIND UNLOCKED ✅' : '✨  BUY SYNAP PRO TO UNLOCK',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.2),
          ),
          if (!isUnlocked) ...[
            const SizedBox(width: 8),
            const Text('₹19', style: TextStyle(color: _kGreen, fontSize: 20, fontWeight: FontWeight.w900, shadows: [Shadow(color: _kGreen, blurRadius: 8)])),
          ],
        ]),
      ),
    ]),
  );

  Widget _premiumCard({
    required String icon, required String title, required String subtitle,
    required String tag, required Color tagColor, required String desc,
    required List<String> features, required Color accentColor, required bool isUnlocked,
  }) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: _kCard.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: isUnlocked ? _kGreen.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.08)),
      boxShadow: [
        BoxShadow(color: accentColor.withValues(alpha: 0.05), blurRadius: 30, offset: const Offset(0, 10)),
      ],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [accentColor.withValues(alpha: 0.25), accentColor.withValues(alpha: 0.05)],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: accentColor.withValues(alpha: 0.2)),
          ),
          child: Center(child: Text(icon, style: const TextStyle(fontSize: 28))),
        ),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900, letterSpacing: -0.2)),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: tagColor.withValues(alpha: 0.12), 
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: tagColor.withValues(alpha: 0.3)),
              ),
              child: Text(tag, style: TextStyle(color: tagColor, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
            ),
          ]),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 12, fontWeight: FontWeight.w500)),
        ])),
      ]),
      const SizedBox(height: 16),
      Text(desc, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14, height: 1.5)),
      const SizedBox(height: 18),
      Container(height: 1, color: Colors.white.withValues(alpha: 0.05)),
      const SizedBox(height: 14),
      Row(children: features.map((f) => Expanded(child: Row(children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(color: accentColor.withValues(alpha: 0.2), shape: BoxShape.circle),
          child: Icon(Icons.check_rounded, color: accentColor, size: 10),
        ),
        const SizedBox(width: 8),
        Flexible(child: Text(f, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12, fontWeight: FontWeight.w500))),
      ]))).toList()),
    ]),
  );

  // ── DIVIDER ──────────────────────────────────────────────
  Widget _buildDivider() => Padding(
    padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
    child: Row(children: [
      Expanded(child: Container(height: 1, color: Colors.white.withValues(alpha: 0.05))),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text('FREE RESOURCES', style: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 2)),
      ),
      Expanded(child: Container(height: 1, color: Colors.white.withValues(alpha: 0.05))),
    ]),
  );

  Widget _buildSectionHeader(String title, String sub) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
      const SizedBox(height: 6),
      Text(sub, style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 14, fontWeight: FontWeight.w500)),
    ]),
  );

  // ── FREE STARTER KIT GRID ────────────────────────────────
  Widget _buildStarterGrid(bool isUnlocked) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 14, mainAxisSpacing: 14,
      childAspectRatio: 0.95,
      children: _docs.asMap().entries.map((e) {
        final isLocked = !isUnlocked;
        final accents = [_kPurpleL, _kCyan, _kGold, _kGreen];
        return GestureDetector(
          onTap: () {
            if (isLocked) {
              _startProPurchase();
              return;
            }
            _showDownloadSheet(single: e.value);
          },
          child: _kitTile(e.value.emoji, e.value.title, e.value.subtitle, accents[e.key % accents.length], isLocked),
        );
      }).toList(),
    ),
  );

  Widget _kitTile(String emoji, String title, String sub, Color accent, bool isLocked) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.03),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: accent.withValues(alpha: 0.15)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.1), 
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accent.withValues(alpha: 0.2)),
          ),
          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 24))),
        ),
        if (isLocked)
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.2), shape: BoxShape.circle),
            child: Icon(Icons.lock_rounded, color: Colors.white.withValues(alpha: 0.3), size: 14),
          ),
      ]),
      const Spacer(),
      Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: -0.2)),
      const SizedBox(height: 4),
      Text(sub, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 12, height: 1.3, fontWeight: FontWeight.w500)),
    ]),
  );

  // ── ESSENTIAL TOOLS ──────────────────────────────────────
  Widget _buildToolsList(bool isUnlocked) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      children: _allTools.asMap().entries.map((e) {
        final tool = e.value;
        final isLocked = !isUnlocked;

        return GestureDetector(
          onTap: () async {
            if (isLocked) {
              _startProPurchase();
              return;
            }
            final c = Uri.parse(tool.url);
            if (await canLaunchUrl(c)) await launchUrl(c);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: _kCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _kCardBd),
            ),
            child: Row(children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: isLocked ? 4 : 0, sigmaY: isLocked ? 4 : 0),
                child: Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Text(tool.emoji, style: const TextStyle(fontSize: 20))),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: isLocked ? 4 : 0, sigmaY: isLocked ? 4 : 0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Flexible(child: Text(tool.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700))),
                      const SizedBox(width: 6),
                      if (tool.isHot) _badge('HOT', _kGold),
                      if (tool.isNew) _badge('NEW', _kGreen),
                    ]),
                    const SizedBox(height: 3),
                    Text(tool.desc, style: const TextStyle(color: _kTextDim, fontSize: 11, fontWeight: FontWeight.w500)),
                  ]),
                ),
              ),
              const SizedBox(width: 8),
              if (isLocked)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: _kTextDim.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(20), border: Border.all(color: _kTextDim.withValues(alpha: 0.2))),
                  child: Row(mainAxisSize: MainAxisSize.min, children: const [
                    Icon(Icons.lock_outline_rounded, color: _kTextDim, size: 10),
                    SizedBox(width: 4),
                    Text('PRO', style: TextStyle(color: _kTextDim, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
                  ]),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: _kGreen.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(20), border: Border.all(color: _kGreen.withValues(alpha: 0.25))),
                  child: const Text('FREE', style: TextStyle(color: _kGreen, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
                ),
            ]),
          ),
        );
      }).toList(),
    ),
  );

  Widget _badge(String label, Color color) => Container(
    margin: const EdgeInsets.only(right: 4),
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6), border: Border.all(color: color.withValues(alpha: 0.3))),
    child: Text(label, style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
  );
}
