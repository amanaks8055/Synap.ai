import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';
import '../../blocs/premium/premium_bloc.dart';
import '../../widgets/moving_border_button.dart';

// ═══════════════════════════════════════════════════════════════
// SYNAP — FOUNDER'S VAULT v2 (CLEANED)
// ═══════════════════════════════════════════════════════════════

class _VaultDoc {
  final String title, subtitle, emoji, filename;
  final Color color;
  final String category;
  final List<Map<String, String>> content;
  const _VaultDoc({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.filename,
    required this.color,
    required this.category,
    required this.content,
  });
}

const _cats = ['⚖️ Legal Armor', '📊 Business Ops', '🏗️ Tech Blueprint', '📈 Growth Engine'];

const List<_VaultDoc> _vaultDocs = [
  _VaultDoc(
    title: 'Legal Shield',
    subtitle: 'Terms of Service',
    emoji: '⚖️',
    filename: 'LegalShield',
    color: Color(0xFF6C63FF),
    category: '⚖️ Legal Armor',
    content: [
      {'heading': 'Acceptance', 'body': 'By using the Service, you agree to these Terms. If you disagree, you may not access it.'},
      {'heading': 'Accounts', 'body': 'Provide accurate info. You are responsible for your password security.'},
      {'heading': 'Intellectual Property', 'body': 'The Service, logo, and code are owned by [Company] and protected by IP laws.'},
      {'heading': 'Termination', 'body': 'We may terminate access immediately for any violation of these terms.'},
    ],
  ),
  _VaultDoc(
    title: 'Data Fortress',
    subtitle: 'Privacy Policy',
    emoji: '🔒',
    filename: 'DataFortress',
    color: Color(0xFF00D4AA),
    category: '⚖️ Legal Armor',
    content: [
      {'heading': 'Collection', 'body': 'We collect email, name, and usage data to provide and improve the service.'},
      {'heading': 'Usage', 'body': 'To maintain accounts, provide support, and analyze how users interact with our app.'},
      {'heading': 'Retention', 'body': 'We keep data only as long as needed. You can request deletion anytime.'},
    ],
  ),
  _VaultDoc(
    title: 'Stealth Mode',
    subtitle: 'Mutual NDA',
    emoji: '🤐',
    filename: 'StealthMode',
    color: Color(0xFFFF6B6B),
    category: '⚖️ Legal Armor',
    content: [
      {'heading': 'Confidential Information', 'body': 'Includes trade secrets, code, business plans disclosed during partnership.'},
      {'heading': 'Obligations', 'body': 'Do not share info with third parties. Use it only for the agreed purpose.'},
      {'heading': 'Term', 'body': 'This agreement stays active for 2 years. Obligations survive for 3 years after.'},
    ],
  ),
  _VaultDoc(
    title: 'Funding Rocket',
    subtitle: 'SAFE Agreement',
    emoji: '🚀',
    filename: 'FundingRocket',
    color: Color(0xFFFFA940),
    category: '⚖️ Legal Armor',
    content: [
      {'heading': 'Investment', 'body': 'Investor pays USD [Amount] for future equity conversion.'},
      {'heading': 'Conversion', 'body': 'Converts to equity during the next priced equity financing round.'},
      {'heading': 'Cap', 'body': 'Post-money Valuation Cap: USD [___]. Discount Rate: [__]%.'},
    ],
  ),
  _VaultDoc(
    title: 'Co-Founder Pact',
    subtitle: 'Founder Accord',
    emoji: '🤝',
    filename: 'CoFounderPact',
    color: Color(0xFF9B59B6),
    category: '⚖️ Legal Armor',
    content: [
      {'heading': 'Equity Split', 'body': 'Founder A: [__]% | Founder B: [__]% | 4-year vesting, 1-year cliff.'},
      {'heading': 'Decision Making', 'body': 'Roles: CEO for Business, CTO for Tech. Major decisions need unanimity.'},
    ],
  ),
  _VaultDoc(
    title: 'Product Blueprint',
    subtitle: 'PRD Master',
    emoji: '📋',
    filename: 'ProductPRD',
    color: Color(0xFF6C63FF),
    category: '📊 Business Ops',
    content: [
      {'heading': 'The Problem', 'body': 'Define the customer pain point. Why is this a problem today?'},
      {'heading': 'The Solution', 'body': 'How your product solves it. Key features (P0, P1, P2).'},
      {'heading': 'Metrics', 'body': 'Retention (D7, D30), Acquisition cost, and Revenue targets.'},
    ],
  ),
  _VaultDoc(
    title: 'Investor Magnet',
    subtitle: 'Pitch Deck Flow',
    emoji: '🎤',
    filename: 'PitchDeck',
    color: Color(0xFFFF6B6B),
    category: '📊 Business Ops',
    content: [
      {'heading': 'Slides 1-5', 'body': '1. Title | 2. Problem | 3. Solution | 4. Market Size | 5. Traction.'},
      {'heading': 'Slides 6-10', 'body': '6. Business Model | 7. Competition | 8. Team | 9. Financials | 10. The Ask.'},
    ],
  ),
  _VaultDoc(
    title: 'Code Architecture',
    subtitle: 'System Design',
    emoji: '🏗️',
    filename: 'SystemDesign',
    color: Color(0xFF00D4AA),
    category: '🏗️ Tech Blueprint',
    content: [
      {'heading': 'Backend', 'body': 'Supabase PostgreSQL, Edge Functions, Auth, and Storage.'},
      {'heading': 'Frontend', 'body': 'Flutter BLoC pattern, Hive local DB, Sentry for monitoring.'},
      {'heading': 'Flow', 'body': 'Action -> BLoC -> Repository -> Supabase API -> DB.'},
    ],
  ),
  _VaultDoc(
    title: 'Launch Playbook',
    subtitle: 'GTM Strategy',
    emoji: '🚀',
    filename: 'LaunchGTM',
    color: Color(0xFFFFA940),
    category: '📈 Growth Engine',
    content: [
      {'heading': 'Phase 1: Build', 'body': 'Waitlist site, Twitter community building, Beta testing.'},
      {'heading': 'Phase 2: Launch', 'body': 'Product Hunt launch, Hacker News, Reddit communities.'},
      {'heading': 'Phase 3: Scale', 'body': 'SEO Content engine, Referral loops, Paid acquisition.'},
    ],
  ),
];

// ═══════════════════════════════════════════════════════════════
// PDF GENERATOR
// ═══════════════════════════════════════════════════════════════
class _VaultPdf {
  static PdfColor _pc(Color c) => PdfColor(c.r, c.g, c.b);

  static Future<String> generate(_VaultDoc doc) async {
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      header: (ctx) => pw.Container(
        padding: const pw.EdgeInsets.all(16),
        margin: const pw.EdgeInsets.only(bottom: 16),
        decoration: pw.BoxDecoration(color: _pc(doc.color), borderRadius: pw.BorderRadius.circular(8)),
        child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text("SYNAP FOUNDER'S VAULT", style: pw.TextStyle(fontSize: 9, color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 4),
            pw.Text('${doc.emoji} ${doc.title}', style: pw.TextStyle(fontSize: 18, color: PdfColors.white, fontWeight: pw.FontWeight.bold)),
          ]),
          pw.Text(doc.subtitle, style: pw.TextStyle(fontSize: 10, color: PdfColors.white)),
        ])),
      build: (ctx) => [
        pw.Text('How to use with AI', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        pw.Text('1. Upload this file to ChatGPT or Claude.\n2. Use prompt: "Fill this document for my startup: [Your Startup Name]"\n3. Copy the personalized output.'),
        pw.SizedBox(height: 20),
        ...doc.content.map((s) => pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text(s['heading']!, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: _pc(doc.color))),
          pw.Padding(padding: const pw.EdgeInsets.fromLTRB(10, 4, 0, 14), child: pw.Text(s['body']!, style: const pw.TextStyle(fontSize: 11))),
        ])),
      ],
    ));
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/Synap_${doc.filename}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }
}

// ═══════════════════════════════════════════════════════════════
// MAIN SCREEN
// ═══════════════════════════════════════════════════════════════
class FoundersVaultScreen extends StatefulWidget {
  const FoundersVaultScreen({super.key});
  @override State<FoundersVaultScreen> createState() => _FoundersVaultScreenState();
}

class _FoundersVaultScreenState extends State<FoundersVaultScreen> with TickerProviderStateMixin {
  late AnimationController _bgCtrl, _entryCtrl;
  String _selectedCat = _cats.first;
  bool _downloading = false;

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat(reverse: true);
    _entryCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..forward();
  }

  @override
  void dispose() {
    _bgCtrl.dispose(); _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final premState = context.watch<PremiumBloc>().state;
    if (!premState.isProfessional) {
      return _buildLockedScreen(context);
    }
    final filtered = _vaultDocs.where((d) => d.category == _selectedCat).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF060A13),
      body: Stack(children: [
        AnimatedBuilder(animation: _bgCtrl, builder: (_, __) => CustomPaint(size: MediaQuery.of(context).size, painter: _VaultBgPainter(_bgCtrl.value))),
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 180, pinned: true,
              backgroundColor: const Color(0xFF060A13).withOpacity(0.9),
              leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("FOUNDER'S VAULT", style: TextStyle(fontFamily: 'Syne', fontWeight: FontWeight.w900, fontSize: 16)),
                background: Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF1A1040), Color(0xFF060A13)]))),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 50, child: ListView.builder(
              scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _cats.length,
              itemBuilder: (_, i) {
                final active = _cats[i] == _selectedCat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
                  child: SynapMovingBorderButton(
                    onTap: () => setState(() => _selectedCat = _cats[i]),
                    isAnimating: active,
                    borderRadius: 12,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    backgroundColor: active ? const Color(0xFF6C63FF).withOpacity(0.3) : const Color(0xFF0D1420),
                    glowColor: active ? const Color(0xFF6C63FF) : Colors.white12,
                    child: Text(
                      _cats[i],
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 12,
                        fontWeight: active ? FontWeight.bold : FontWeight.normal,
                        color: active ? Colors.white : Colors.white60,
                      ),
                    ),
                  ),
                );
              },
            ))),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(delegate: SliverChildBuilderDelegate(
                (ctx, i) => _VaultCard(doc: filtered[i], downloading: _downloading, onDownload: () async {
                  setState(() => _downloading = true);
                  try {
                    final path = await _VaultPdf.generate(filtered[i]);
                    await OpenFilex.open(path);
                  } finally {
                    setState(() => _downloading = false);
                  }
                }),
                childCount: filtered.length,
              )),
            ),
          ],
        ),
      ]),
    );
  }

  Widget _buildLockedScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060A13),
      body: Stack(children: [
        AnimatedBuilder(animation: _bgCtrl, builder: (_, __) => CustomPaint(size: MediaQuery.of(context).size, painter: _VaultBgPainter(_bgCtrl.value))),
        SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.3)),
                ),
                child: const Icon(Icons.lock_rounded, color: Color(0xFF6C63FF), size: 36),
              ),
              const SizedBox(height: 24),
              const Text("FOUNDER'S VAULT", style: TextStyle(fontFamily: 'Syne', fontWeight: FontWeight.w900, fontSize: 22, color: Colors.white, letterSpacing: 1)),
              const SizedBox(height: 10),
              Text('This vault is exclusive to Professional plan members.\nUpgrade to unlock legal docs, pitch decks & more.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14, height: 1.5)),
              const SizedBox(height: 28),
              SynapMovingBorderButton(
                onTap: () => Navigator.pushNamed(context, '/premium'),
                borderRadius: 16,
                height: 52,
                backgroundColor: const Color(0xFF6C63FF),
                glowColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: const Text('Upgrade to Professional', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _VaultCard extends StatefulWidget {
  final _VaultDoc doc;
  final bool downloading;
  final VoidCallback onDownload;
  const _VaultCard({required this.doc, required this.downloading, required this.onDownload});
  @override State<_VaultCard> createState() => _VaultCardState();
}

class _VaultCardState extends State<_VaultCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onDownload,
      child: Transform.scale(
        scale: _pressed ? 0.95 : 1.0,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: widget.doc.color.withOpacity(0.3)),
          ),
          child: Row(children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(color: widget.doc.color.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: Center(child: Text(widget.doc.emoji, style: const TextStyle(fontSize: 20)))),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.doc.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              Text(widget.doc.subtitle, style: const TextStyle(fontSize: 12, color: Colors.white60)),
            ])),
            if (widget.downloading) const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white70))
            else const Icon(Icons.download, color: Colors.white54, size: 20),
          ]),
        ),
      ),
    );
  }
}


class _VaultBgPainter extends CustomPainter {
  final double t;
  _VaultBgPainter(this.t);
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80);
    p.color = const Color(0xFF6C63FF).withOpacity(0.1 + (math.sin(t * math.pi) * 0.05));
    canvas.drawCircle(Offset(s.width * 0.2, s.height * 0.3), 150, p);
    p.color = const Color(0xFF00D4AA).withOpacity(0.08 + (math.cos(t * math.pi) * 0.04));
    canvas.drawCircle(Offset(s.width * 0.8, s.height * 0.7), 120, p);
  }
  @override bool shouldRepaint(_VaultBgPainter o) => true;
}
