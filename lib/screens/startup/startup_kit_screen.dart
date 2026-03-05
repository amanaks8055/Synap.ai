import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart' hide ImageFilter;
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pro_kit_screen.dart';
import 'founders_vault_screen.dart';
import '../../widgets/moving_border_button.dart';

// ═══════════════════════════════════════════════════════════════
// SYNAP — STARTUP KIT SCREEN v5 (Optimized)
// 🆓 Free Tools | 📋 Original Docs | 🚀 Pro Booster Link
// ═══════════════════════════════════════════════════════════════

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
      {'heading': 'Core Features (MVP)', 'body': 'P0 (Must Have):\n• Feature 1 — reason why essential\n• Feature 2 — reason why essential\n• Feature 3 — reason why essential\n\nP1 (Should Have):\n• Feature 4\n• Feature 5\n\nP2 (Nice to Have):\n• Feature 6'},
      {'heading': 'Success Metrics', 'body': 'Acquisition: DAU target, MAU target\nActivation: % users completing onboarding (target: 60%+)\nRetention: D7 retention (target: 40%+), D30 (20%+)\nRevenue: MRR target at 3 months, 6 months, 12 months\nNPS: Target score 50+'},
      {'heading': 'Timeline & Milestones', 'body': 'Week 1-2: Discovery + design\nWeek 3-4: MVP development sprint 1\nWeek 5-6: MVP development sprint 2\nWeek 7: Internal testing + bug fixes\nWeek 8: Beta launch (100 users)\nWeek 10: Public launch\nWeek 12: First revenue milestone'},
      {'heading': 'Assumptions & Risks', 'body': 'Assumptions:\n• Users will pay [price] for [value]\n• Market size is large enough\n• Distribution channel works\n\nRisks:\n• Competitor launches similar product\n• Regulatory changes in market\n• Tech dependency / API changes\n• Team bandwidth constraints'},
    ]),
  _Doc(title: 'System Design', subtitle: 'Architecture Blueprint', emoji: '🏗️', filename: 'SystemDesign', color: Color(0xFF00D4AA),
    sections: ['🔌 API Design', '🗄️ Database Schema', '📡 Data Flow', '⚡ Scalability'],
    content: [
      {'heading': 'API Design', 'body': 'Type: REST API (or GraphQL if complex queries needed)\nBase URL: https://api.yourapp.com/v1\n\nEndpoints:\nPOST  /auth/login\nPOST  /auth/signup\nGET   /users/:id\nPUT   /users/:id\n\nAuth: JWT Bearer tokens, 24h expiry, refresh tokens'},
      {'heading': 'Database Schema', 'body': 'Primary DB: PostgreSQL (via Supabase)\n\nCore Tables:\nusers (\n  id UUID PRIMARY KEY,\n  email TEXT UNIQUE,\n  name TEXT,\n  created_at TIMESTAMPTZ\n)\n\nsessions (\n  id UUID, user_id UUID,\n  token TEXT, expires_at TIMESTAMPTZ\n)'},
      {'heading': 'Data Flow', 'body': 'User → Flutter App → Supabase API → PostgreSQL DB\n\nReal-time: Supabase Realtime WebSockets\nCaching: Local Hive cache for offline support\nCDN: Supabase Storage for media files\n\nFlow:\n1. User action → BLoC event\n2. Repository API call → Supabase\n3. Response → BLoC state update → UI'},
      {'heading': 'Scalability Plan', 'body': 'Phase 1 (0 to 1K users):\n• Supabase free/pro tier\n• Single region deployment\n• Simple caching\n\nPhase 2 (1K+ users):\n• Supabase Pro + connection pooling\n• Add Redis for hot data'},
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
  _Tool(name: 'Tome AI', url: 'https://tome.app', emoji: '📊', desc: 'AI pitch deck builder for investors', category: 'Grow', isHot: true),
  _Tool(name: 'Apollo.io', url: 'https://apollo.io', emoji: '🎯', desc: 'AI sales intelligence & prospecting', category: 'Grow', isHot: true),
  _Tool(name: 'Instantly AI', url: 'https://instantly.ai', emoji: '📧', desc: 'AI cold email at scale', category: 'Grow', isHot: true),
  _Tool(name: 'Causal AI', url: 'https://causal.app', emoji: '📉', desc: 'Financial modeling & scenario planning', category: 'Finance', isHot: true),
];

const List<String> _purposes = ['📱 Mobile App', '🌐 Web / SaaS', '🛒 E-Commerce', '🤖 AI Product', '🏢 Enterprise', '🎮 Game', '📚 EdTech', '🏥 HealthTech'];

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

class StartupKitScreen extends StatefulWidget {
  const StartupKitScreen({super.key});
  @override State<StartupKitScreen> createState() => _StartupKitScreenState();
}

class _StartupKitScreenState extends State<StartupKitScreen> with TickerProviderStateMixin {
  late AnimationController _heroCtrl, _floatCtrl, _pulseCtrl, _entryCtrl;
  bool _isDownloading = false, _isUnlocked = false;

  @override
  void initState() {
    super.initState();
    _heroCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);
    _floatCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
    _entryCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..forward();
    _checkOwnerAccess();
  }

  void _checkOwnerAccess() {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user?.email?.contains('amanaks') ?? false) setState(() => _isUnlocked = true);
    } catch (_) {}
  }

  @override
  void dispose() {
    _heroCtrl.dispose(); _floatCtrl.dispose(); _pulseCtrl.dispose(); _entryCtrl.dispose();
    super.dispose();
  }

  void _showDownloadSheet({_Doc? single}) {
    HapticFeedback.selectionClick(); String? selected;
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (_) => StatefulBuilder(builder: (ctx, setS) => Container(
      decoration: const BoxDecoration(color: Color(0xFF0D1420), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 40),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('🚀 Choose Your Niche', style: TextStyle(fontFamily: 'Syne', fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
        const SizedBox(height: 20),
        Wrap(spacing: 8, runSpacing: 8, children: _purposes.map((p) => ChoiceChip(label: Text(p), selected: selected == p, onSelected: (v) => setS(() => selected = p))).toList()),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: selected == null ? null : () async {
          Navigator.pop(context); setState(() => _isDownloading = true);
          final path = await _PdfGen.generateDoc(single ?? _docs[0], selected!);
          setState(() => _isDownloading = false);
          OpenFilex.open(path);
        }, child: const Text('Download PDF'))),
      ]),
    )));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF030712),
    body: CustomScrollView(slivers: [
      SliverAppBar(
        expandedHeight: 320, pinned: true, 
        backgroundColor: const Color(0xFF030712),
        flexibleSpace: FlexibleSpaceBar(
          background: _Hero(
            heroCtrl: _heroCtrl, 
            onPro: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProKitScreen())), 
            isUnlocked: _isUnlocked
          ),
        ),
      ),
      SliverPadding(padding: const EdgeInsets.all(20), sliver: SliverList(delegate: SliverChildListDelegate([
        _StaggeredEntry(index: 0, child: _DualBoosterSection(
          onEarningLabTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProKitScreen(initialIndex: 1))),
          onFounderPackTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProKitScreen(initialIndex: 0))),
          isUnlocked: _isUnlocked,
        )),
        const SizedBox(height: 32),
        const _StaggeredEntry(index: 1, child: _SH(title: '🚀 Free Starter Kit', sub: 'Essential docs to build your MVP')),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), 
          crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, 
          childAspectRatio: 0.8, // More vertical space for titles
          children: List.generate(_docs.length, (i) => _StaggeredEntry(index: i + 2, child: _DocCard(doc: _docs[i], onTap: () => _showDownloadSheet(single: _docs[i])))),
        ),
        const SizedBox(height: 40),
        const _StaggeredEntry(index: 6, child: _SH(title: '🛠️ Essential Tools', sub: 'Curated list for early stages')),
        const SizedBox(height: 16),
        ...List.generate(_allTools.length, (i) => _StaggeredEntry(index: i + 7, child: _ToolTile(tool: _allTools[i]))),
        const SizedBox(height: 100),
      ]))),
    ]),
  );
}

class _Hero extends StatelessWidget {
  final AnimationController heroCtrl; final VoidCallback onPro; final bool isUnlocked;
  const _Hero({required this.heroCtrl, required this.onPro, required this.isUnlocked});
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [Color(0xFF0F172A), Color(0xFF030712)],
      ),
    ),
    child: Stack(fit: StackFit.expand, children: [
      _GlobeBackground(heroCtrl: heroCtrl),
      Positioned.fill(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center, radius: 1.2,
              colors: [Colors.transparent, const Color(0xFF030712).withOpacity(0.8), const Color(0xFF030712)],
            ),
          ),
        ),
      ),
      SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('STARTUP\nRESOURCE HUB', style: TextStyle(fontFamily: 'Syne', fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, height: 1, letterSpacing: -1)),
        const SizedBox(height: 8),
        Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFF6C63FF), borderRadius: BorderRadius.circular(2))),
        const Spacer(),
        SynapMovingBorderButton(onTap: onPro, borderRadius: 16, backgroundColor: const Color(0xFF6C63FF), glowColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), child: Center(child: Text(isUnlocked ? 'ACCESS FOUNDER PACK ✅' : 'GET FOUNDER PACK (₹9)', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)))),
      ]))),
    ]),
  );
}

class _GlobeBackground extends StatefulWidget {
  final AnimationController heroCtrl;
  const _GlobeBackground({required this.heroCtrl});
  @override
  State<_GlobeBackground> createState() => _GlobeBackgroundState();
}

class _GlobeBackgroundState extends State<_GlobeBackground> {
  final List<_Star> _stars = List.generate(50, (_) => _Star());
  
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.heroCtrl,
    builder: (_, __) => CustomPaint(painter: _GlobePainter(widget.heroCtrl.value, _stars)),
  );
}

class _Star {
  final double x = math.Random().nextDouble();
  final double y = math.Random().nextDouble();
  final double size = math.Random().nextDouble() * 2;
  final double speed = 0.1 + math.Random().nextDouble() * 0.2;
}

class _DualBoosterSection extends StatelessWidget {
  final VoidCallback onEarningLabTap, onFounderPackTap; final bool isUnlocked;
  const _DualBoosterSection({required this.onEarningLabTap, required this.onFounderPackTap, required this.isUnlocked});
  @override
  Widget build(BuildContext context) => Column(children: [
    Stack(alignment: Alignment.center, children: [
      Positioned(top: 60, bottom: 60, child: Container(width: 2, color: const Color(0xFF6C63FF).withOpacity(0.3))), // Connecting Line
      Column(children: [
        _MiniCard(onTap: onEarningLabTap, title: 'Earning Lab', desc: '50+ Pro AI Tools Arsenal', icon: '🛠️', color: const Color(0xFF1E1B4B), isUnlocked: isUnlocked),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(color: Color(0xFF6C63FF), shape: BoxShape.circle),
          child: const Icon(Icons.link, color: Colors.white, size: 20),
        ),
        _MiniCard(onTap: onFounderPackTap, title: 'Founder Pack', desc: 'Earn ₹1L in 48 Hours Roadmap', icon: '🚀', color: const Color(0xFF1E1B4B), isUnlocked: isUnlocked),
      ]),
      Positioned(right: 10, child: _BundleBadge(isUnlocked: isUnlocked)),
    ]),
    const SizedBox(height: 16),
    Text(isUnlocked ? 'ALL-IN-ONE MASTERMIND UNLOCKED ✅' : 'GET BOTH FOR JUST ₹9', style: const TextStyle(color: Color(0xFF00D4AA), fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1)),
  ]);
}

class _MiniCard extends StatelessWidget {
  final String title, desc, icon; final Color color; final bool isUnlocked; final VoidCallback onTap;
  const _MiniCard({required this.title, required this.desc, required this.icon, required this.color, required this.isUnlocked, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: color.withOpacity(0.7),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: isUnlocked ? const Color(0xFF00D4AA).withOpacity(0.3) : Colors.white.withOpacity(0.08)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Row(children: [
            Container(width: 56, height: 56, decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withOpacity(0.1))), child: Center(child: Text(icon, style: const TextStyle(fontSize: 28)))),
            const SizedBox(width: 20),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontFamily: 'Syne', fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
              const SizedBox(height: 2),
              Text(desc, style: const TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.w500)),
            ])),
          ]),
        ),
      ),
    ),
  );
}

class _BundleBadge extends StatelessWidget {
  final bool isUnlocked;
  const _BundleBadge({required this.isUnlocked});
  @override
  Widget build(BuildContext context) => Transform.rotate(
    angle: 0.2,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFF00D4AA), borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10)]),
      child: Column(children: [
        const Text('BUNDLE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 10)),
        Text(isUnlocked ? 'FREE' : '₹9', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
      ]),
    ),
  );
}

class _ToolTile extends StatelessWidget {
  final _Tool tool;
  const _ToolTile({required this.tool});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.03),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.white.withOpacity(0.05)),
    ),
    child: ListTile(
      onTap: () => launchUrl(Uri.parse(tool.url)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(width: 48, height: 48, decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(14)), child: Center(child: Text(tool.emoji, style: const TextStyle(fontSize: 22)))),
      title: Text(tool.name, style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 15)),
      subtitle: Text(tool.desc, style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white10, size: 14),
    ),
  );
}

class _DocCard extends StatelessWidget {
  final _Doc doc; final VoidCallback onTap;
  const _DocCard({required this.doc, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: doc.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: doc.color.withOpacity(0.2)),
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [doc.color.withOpacity(0.15), Colors.transparent],
            ),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: 36, height: 36, decoration: BoxDecoration(color: doc.color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Center(child: Text(doc.emoji, style: const TextStyle(fontSize: 20)))),
            const Spacer(),
            Text(doc.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'Syne', fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white, letterSpacing: -0.5)),
            const SizedBox(height: 2),
            Text(doc.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Colors.white54, fontWeight: FontWeight.w600)),
          ]),
        ),
      ),
    ),
  );
}

class _SH extends StatelessWidget {
  final String title, sub;
  const _SH({required this.title, required this.sub});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontFamily: 'Syne', fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)), Text(sub, style: const TextStyle(fontSize: 12, color: Colors.white38))]);
}

class _StaggeredEntry extends StatelessWidget {
  final int index; final Widget child;
  const _StaggeredEntry({required this.index, required this.child});
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}

class _GlobePainter extends CustomPainter {
  final double t;
  final List<_Star> stars;
  _GlobePainter(this.t, this.stars);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.5);
    final radius = size.width * 0.45;
    
    // 1. Paint Starfield (3D World environment)
    final starPaint = Paint()..color = Colors.white;
    for (var star in stars) {
      final dx = (star.x + t * star.speed) % 1.0;
      final offset = Offset(size.width * dx, size.height * star.y);
      starPaint.color = Colors.white.withOpacity(0.2 + 0.3 * math.sin(t * 5 + star.x * 10));
      canvas.drawCircle(offset, star.size, starPaint);
    }

    final paint = Paint()..strokeWidth = 0.5..style = PaintingStyle.stroke;
    
    // Rotation based on animation controller value
    final rotation = t * 2 * math.pi;

    // 2. Draw Globe Longitudes
    for (var i = 0; i < 8; i++) {
      final angle = rotation + (i * math.pi / 4);
      final xRadius = radius * math.cos(angle).abs();
      paint.color = const Color(0xFF6C63FF).withOpacity(0.15 * (math.cos(angle) + 1.2));
      canvas.drawOval(Rect.fromCenter(center: center, width: xRadius * 2, height: radius * 2), paint);
    }

    // 3. Draw Globe Latitudes
    for (var i = 1; i < 6; i++) {
      final h = radius * math.sin((i * math.pi / 6) - math.pi / 2);
      final w = radius * math.cos((i * math.pi / 6) - math.pi / 2);
      paint.color = Colors.white.withOpacity(0.05);
      canvas.drawOval(Rect.fromCenter(center: Offset(center.dx, center.dy + h), width: w * 2, height: w * 0.2), paint);
    }

    // 4. Draw Hot Nodes & Floating Particles
    final nodePaint = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < 15; i++) {
      final phi = i * math.pi / 7.5;
      final theta = t * math.pi + (i * math.pi / 3.75);
      
      final x = radius * math.sin(phi) * math.cos(theta);
      final y = radius * math.cos(phi);
      final z = radius * math.sin(phi) * math.sin(theta);

      if (z > -20) { // Slightly more depth
        final opacity = ((z + radius) / (radius * 2)).clamp(0.0, 1.0);
        nodePaint.color = const Color(0xFF00D4AA).withOpacity(opacity); // Teal nodes for contrast
        canvas.drawCircle(Offset(center.dx + x, center.dy + y), 2.5, nodePaint);
        
        if (z > 0) { // Front glow
          nodePaint.color = const Color(0xFF6C63FF).withOpacity(opacity * 0.3);
          canvas.drawCircle(Offset(center.dx + x, center.dy + y), 6, nodePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_GlobePainter old) => old.t != t;
}
