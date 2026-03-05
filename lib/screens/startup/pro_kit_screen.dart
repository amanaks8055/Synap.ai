import 'dart:ui';
import 'package:flutter/material.dart' hide ImageFilter;
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/moving_border_button.dart';

// ═══════════════════════════════════════════════════════════════
// SYNAP — PREMIUM STARTUP MASTERMIND (V9 - ACTIONABLE)
// 🚀 TAB 1: Founder Starter Pack (Clickable Roadmap & Blueprints)
// 🛠️ TAB 2: Earning Lab (Fixed URLs & 50+ Pro Tools)
// ═══════════════════════════════════════════════════════════════

class ProKitScreen extends StatefulWidget {
  final int initialIndex;
  const ProKitScreen({super.key, this.initialIndex = 0});
  @override State<ProKitScreen> createState() => _ProKitScreenState();
}

class _ProKitScreenState extends State<ProKitScreen> with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  bool _isUnlocked = false;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
    _checkOwnerAccess();
    Future.delayed(const Duration(seconds: 1), _checkOwnerAccess);
  }

  void _checkOwnerAccess() {
    if (!mounted) return;
    try {
      final user = Supabase.instance.client.auth.currentUser;
      final email = user?.email?.toLowerCase();
      if (email == 'amanaks8055@gmail.com' || (email?.contains('amanaks') ?? false)) {
        if (!_isUnlocked) setState(() => _isUnlocked = true);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _showPaymentModal() {
    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Initializing Secure Payment for Mastermind Bundle...')));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialIndex,
      child: Scaffold(
        backgroundColor: const Color(0xFF030712),
        body: Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: 220, pinned: true, floating: true, 
                  backgroundColor: const Color(0xFF030712),
                  elevation: 0,
                  leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20), onPressed: () => Navigator.pop(context)),
                  flexibleSpace: FlexibleSpaceBar(
                    background: _UnifiedMastermindHeader(isUnlocked: _isUnlocked),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      indicatorColor: const Color(0xFF6C63FF),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelStyle: GoogleFonts.syne(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1),
                      unselectedLabelColor: Colors.white38,
                      tabs: const [
                        Tab(text: '🚀 THE PLAN', icon: Icon(Icons.map_outlined, size: 18)),
                        Tab(text: '🛠️ THE TOOLS', icon: Icon(Icons.construction_outlined, size: 18)),
                      ],
                    ),
                  ),
                ),
              ],
              body: Container(
                color: const Color(0xFF030712),
                child: TabBarView(
                  children: [
                    _FounderPackTab(isUnlocked: _isUnlocked, onPay: _showPaymentModal),
                    _EarningLabTab(isUnlocked: _isUnlocked, onPay: _showPaymentModal),
                  ],
                ),
              ),
            ),
            if (!_isUnlocked) Align(
              alignment: Alignment.bottomCenter,
              child: _FloatingPayButton(onTap: _showPaymentModal),
            ),
          ],
        ),
      ),
    );
  }
}

class _StaggeredEntry extends StatelessWidget {
  final int index; final Widget child;
  const _StaggeredEntry({required this.index, required this.child});
  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0.0, end: 1.0),
    duration: Duration(milliseconds: 500 + (index * 80)),
    curve: Curves.easeOutCubic,
    builder: (context, value, child) => Opacity(opacity: value, child: Transform.translate(offset: Offset(0, 20 * (1 - value)), child: child)),
    child: child,
  );
}

// ── TAB 1: FOUNDER PACK ──────────────────────────────────────────

class _FounderPackTab extends StatelessWidget {
  final bool isUnlocked; final VoidCallback onPay;
  const _FounderPackTab({required this.isUnlocked, required this.onPay});

  void _showDetail(BuildContext context, String title, String detail) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D1420),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontFamily: 'Syne', fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
            const SizedBox(height: 16),
            Text(detail, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5)),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, child: SynapMovingBorderButton(onTap: () => Navigator.pop(context), borderRadius: 12, backgroundColor: const Color(0xFF6C63FF), child: const Text('GOT IT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      if (!isUnlocked) _StaggeredEntry(index: 0, child: _LockBanner(onTap: onPay)),
      const SizedBox(height: 20),
      const _StaggeredEntry(index: 1, child: _SectionHeader(title: 'Earn ₹1L in 48 Hours', sub: 'Click any step to reveal secret execution details')),
      const SizedBox(height: 16),
      _StaggeredEntry(index: 2, child: _ChallengeRoadmap(
        isLocked: !isUnlocked,
        onStepTap: (title, detail) => _showDetail(context, title, detail),
      )),
      const SizedBox(height: 32),
      const _StaggeredEntry(index: 3, child: _SectionHeader(title: '💰 Zero to ₹1L Models', sub: 'High-income India focused models')),
      const SizedBox(height: 16),
      _StaggeredEntry(index: 4, child: _BluePrintCard(
        title: 'Local Business Automation',
        desc: 'Setup WhatsApp Chatbots for local shops. Charge ₹15k setup + ₹2k/mo AMC.',
        icon: '🏪',
        isLocked: !isUnlocked,
        onTap: () => _showDetail(context, '🏪 Local Automation Strategy', 'Step 1: Scrape Google Maps for local businesses (Gyms, Salons) with low reviews.\nStep 2: Message them: "I saw you are missing 24/7 booking support. Can I set up an AI bot for you for free for 3 days?"\nStep 3: Use Synap\'s AI bot template to deploy in 10 mins.\nStep 4: Close for ₹15,000 once they see the leads flowing.'),
      )),
      _StaggeredEntry(index: 5, child: _BluePrintCard(
        title: 'Freelance AI Clones',
        desc: 'Use Fish.audio for voice clones & DreamForge for 3D assets. High ticket orders.',
        icon: '💎',
        isLocked: !isUnlocked,
        onTap: () => _showDetail(context, '💎 AI Freelance Arbitrage', 'Step 1: Create an Upwork profile specialized in "AI Real Estate Walkthroughs".\nStep 2: Use DreamForge to build 3D property models from 2D images.\nStep 3: Use Fish.audio to add a professional voiceover in seconds.\nStep 4: Charge \$100+ per video. Total work time: 30 minutes.'),
      )),
      const SizedBox(height: 32),
      const _StaggeredEntry(index: 6, child: _SectionHeader(title: '✉️ Plug & Play Scripts', sub: 'Click the copy icon to use instantly')),
      const SizedBox(height: 16),
      _StaggeredEntry(index: 7, child: _ScriptTile(title: 'LinkedIn Outreach', content: 'Hey [Name], I noticed you are scaling your startup. I built an AI automation module that handles [Specific Pain Point]. Can I send you a 1-min demo of how this works for your specific use case? No strings attached.', isLocked: !isUnlocked)),
      _StaggeredEntry(index: 8, child: _ScriptTile(title: 'SaaS Pricing Hook', content: 'Launch at ₹999/mo for first 50 users. Then bump to ₹2,499. Creates scarcity and pays for your API credits instantly.', isLocked: !isUnlocked),),
      const SizedBox(height: 100),
    ],
  );
}

// ── TAB 2: EARNING LAB ───────────────────────────────────────────

class _EarningLabTab extends StatelessWidget {
  final bool isUnlocked; final VoidCallback onPay;
  const _EarningLabTab({required this.isUnlocked, required this.onPay});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      if (!isUnlocked) _StaggeredEntry(index: 0, child: _LockBanner(onTap: onPay)),
      const SizedBox(height: 20),
      const _StaggeredEntry(index: 1, child: _SectionHeader(title: '⚡ Optimization Lab', sub: 'Execution tips to burn bottlenecks')),
      const SizedBox(height: 16),
      _StaggeredEntry(index: 2, child: _TipCard(title: 'Speed-to-Market', tip: 'Use Claude + Antigravity GSD to ship MVPs in 48 hours. Focus on v0.1 value.', icon: '🔋')),
      _StaggeredEntry(index: 3, child: _TipCard(title: 'Cost Cutting', tip: 'Run models locally with Pinokio to save \$100s in API tokens during development.', icon: '✂️')),
      const SizedBox(height: 32),
      const _StaggeredEntry(index: 4, child: _SectionHeader(title: '🛠️ The 50+ Tool Arsenal', sub: 'Secret weapons of rapid builders')),
      const SizedBox(height: 16),
      ...List.generate(_proTools.length, (i) => _StaggeredEntry(index: i + 5, child: _ProToolTile(tool: _proTools[i], isLocked: !isUnlocked))),
      const SizedBox(height: 100),
    ],
  );
}

// ── SHARED COMPONENTS ───────────────────────────────────────────



class _ProToolTile extends StatelessWidget {
  final _Tool tool; final bool isLocked;
  const _ProToolTile({required this.tool, required this.isLocked});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: isLocked ? null : () async {
      final uri = Uri.parse(tool.url);
      try {
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          throw 'Could not launch';
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not open ${tool.name}. Try manually: ${tool.url}')));
        }
      }
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03), 
        borderRadius: BorderRadius.circular(20), 
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(children: [
        Container(width: 48, height: 48, decoration: BoxDecoration(color: const Color(0xFF6C63FF).withOpacity(0.1), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.2))), child: Center(child: Text(tool.emoji, style: const TextStyle(fontSize: 22)))),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(tool.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Colors.white, letterSpacing: -0.3)),
          Text(tool.desc, style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.w500)),
        ])),
        Icon(isLocked ? Icons.lock_outline : Icons.arrow_forward_ios_rounded, color: Colors.white10, size: 14),
      ]),
    ),
  );
}

class _ChallengeRoadmap extends StatelessWidget {
  final bool isLocked; final Function(String, String) onStepTap;
  const _ChallengeRoadmap({required this.isLocked, required this.onStepTap});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: const Color(0xFF111827), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withOpacity(0.05))),
    child: Column(children: [
      _RoadStep(time: 'H 1-4', task: 'Niche Scrape & Validation', isLocked: isLocked, onTap: () => onStepTap('H 1-4: Discovery', '• Use "Awwwards" to find high-end design inspiration.\n• Use "Validator AI" to score your niche ideas.\n• Scrape subreddits to find recurring user complaints.\n• Build a "Waitlist Page" with Framer AI in 30 mins.\n• Goal: Get 10 email signups before building anything.')),
      const Divider(color: Colors.white10, height: 24),
      _RoadStep(time: 'H 5-24', task: 'MVP Build (Flutter + AI)', isLocked: isLocked, onTap: () => onStepTap('H 5-24: Build Sprint', '• Use Cursor AI with "Antigravity GSD" to generate core logic.\n• Connect Supabase for Auth & Database.\n• Run models locally with "Pinokio" to save token costs.\n• Integrate basic GPT-4o API for the "Magic" feature.')),
      const Divider(color: Colors.white10, height: 24),
      _RoadStep(time: 'H 25-48', task: 'Market & Cold Outreach', isLocked: isLocked, onTap: () => onStepTap('H 25-48: Launch & Scale', '• Post your product on "Dev21st" and "DesignArena".\n• Execute 50 cold DMs using our Plug & Play Scripts.\n• Set up a "Demo Video" with Nameeo animations.\n• Goal: Secure your first ₹1,000 payment.')),
    ]),
  );
}

class _RoadStep extends StatelessWidget {
  final String time, task; final bool isLocked; final VoidCallback onTap;
  const _RoadStep({required this.time, required this.task, required this.isLocked, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: isLocked ? null : onTap,
    child: Row(children: [
      Text(time, style: const TextStyle(color: Color(0xFF6C63FF), fontWeight: FontWeight.bold, fontSize: 12)),
      const SizedBox(width: 16),
      Expanded(child: isLocked 
        ? ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), child: Text(task, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)))
        : Text(task, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14))),
      if (!isLocked) const Icon(Icons.info_outline, color: Colors.white24, size: 14),
    ]),
  );
}

class _BluePrintCard extends StatelessWidget {
  final String title, desc, icon; final bool isLocked; final VoidCallback onTap;
  const _BluePrintCard({required this.title, required this.desc, required this.icon, required this.isLocked, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: isLocked ? null : onTap,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02), 
            borderRadius: BorderRadius.circular(24), 
            border: Border.all(color: isLocked ? Colors.white.withOpacity(0.05) : const Color(0xFF6C63FF).withOpacity(0.2)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)), child: Text(icon, style: const TextStyle(fontSize: 20))),
              const SizedBox(width: 12),
              Expanded(child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'Syne', fontWeight: FontWeight.w900, fontSize: 17, color: Colors.white, letterSpacing: -0.5))),
              const SizedBox(width: 8),
              if (!isLocked) const Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white24),
            ]),
            const SizedBox(height: 12),
            isLocked 
              ? ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), child: Text(desc, style: const TextStyle(color: Colors.white24, fontSize: 12, fontWeight: FontWeight.w500)))
              : Text(desc, style: const TextStyle(color: Colors.white60, fontSize: 12, height: 1.4, fontWeight: FontWeight.w500)),
          ]),
        ),
      ),
    ),
  );
}

class _ScriptTile extends StatelessWidget {
  final String title, content; final bool isLocked;
  const _ScriptTile({required this.title, required this.content, required this.isLocked});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: const Color(0xFF111827), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withOpacity(0.05))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
        if (!isLocked) GestureDetector(onTap: () { 
          Clipboard.setData(ClipboardData(text: content));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Script copied to clipboard!'), duration: Duration(seconds: 1)));
        }, child: const Icon(Icons.copy_rounded, color: Color(0xFF6C63FF), size: 16)),
      ]),
      const SizedBox(height: 8),
      isLocked 
        ? ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), child: Text(content, style: const TextStyle(color: Colors.white24, fontSize: 11)))
        : Text(content, style: const TextStyle(color: Colors.white54, fontSize: 11)),
    ]),
  );
}

class _TipCard extends StatelessWidget {
  final String title, tip, icon;
  const _TipCard({required this.title, required this.tip, required this.icon});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: const Color(0xFF1E1B4B).withOpacity(0.4), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.2))),
    child: Row(children: [
      Text(icon, style: const TextStyle(fontSize: 22)),
      const SizedBox(width: 16),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
        const SizedBox(height: 4),
        Text(tip, style: const TextStyle(color: Colors.white54, fontSize: 11)),
      ])),
    ]),
  );
}

class _UnifiedMastermindHeader extends StatelessWidget {
  final bool isUnlocked;
  const _UnifiedMastermindHeader({required this.isUnlocked});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter, 
        colors: [const Color(0xFF6C63FF).withOpacity(0.2), const Color(0xFF030712)],
      ),
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Positioned(top: -50, right: -50, child: ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50), child: Container(width: 150, height: 150, decoration: BoxDecoration(color: const Color(0xFF6C63FF).withOpacity(0.1), shape: BoxShape.circle)))),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(height: 40),
          const Text('FOUNDER MASTERMIND', style: TextStyle(fontFamily: 'Syne', fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.1))),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              _HItem(icon: '📝', label: 'PLAN'),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Icon(Icons.bolt, color: Colors.yellow, size: 16)),
              _HItem(icon: '🚀', label: 'RESULT'),
            ]),
          ),
          const SizedBox(height: 20),
          Text(isUnlocked ? 'FULL ACCESS ACTIVATED ✅' : 'ACTIVATE BOTH FOR ₹9', style: const TextStyle(color: Color(0xFF00D4AA), fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1)),
        ]),
      ],
    ),
  );
}

class _HItem extends StatelessWidget {
  final String icon, label;
  const _HItem({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(icon, style: const TextStyle(fontSize: 18)),
    const SizedBox(height: 4),
    Text(label, style: const TextStyle(color: Colors.white60, fontSize: 9, fontWeight: FontWeight.bold)),
  ]);
}

class _LockBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _LockBanner({required this.onTap});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.red.withOpacity(0.3))),
    child: Row(children: [
      const Icon(Icons.lock_person_outlined, color: Colors.redAccent, size: 20),
      const SizedBox(width: 12),
      const Expanded(child: Text('Unlock Earning Lab + Founder Pack for ₹9.', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold))),
      TextButton(onPressed: onTap, child: const Text('Unlock All', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold))),
    ]),
  );
}

class _FloatingPayButton extends StatelessWidget {
  final VoidCallback onTap;
  const _FloatingPayButton({required this.onTap});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: SynapMovingBorderButton(
      onTap: onTap,
      borderRadius: 20,
      backgroundColor: const Color(0xFF6C63FF),
      glowColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.auto_awesome, color: Colors.yellow),
        SizedBox(width: 12),
        Text('ACTIVATE BOTH FOR ₹9', style: TextStyle(fontFamily: 'Syne', fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white)),
      ]),
    ),
  );
}

class _SectionHeader extends StatelessWidget {
  final String title, sub;
  const _SectionHeader({required this.title, required this.sub});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title, style: const TextStyle(fontFamily: 'Syne', fontSize: 19, fontWeight: FontWeight.w800, color: Colors.white)),
    Text(sub, style: const TextStyle(color: Colors.white38, fontSize: 12)),
  ]);
}

class _Tool {
  final String name, url, emoji, desc;
  const _Tool({required this.name, required this.url, required this.emoji, required this.desc});
}

const List<_Tool> _proTools = [
  _Tool(name: 'Awwwards', url: 'https://www.awwwards.com', emoji: '🏆', desc: 'Design inspiration for premium startups'),
  _Tool(name: 'AutoGluon', url: 'https://auto.gluon.ai', emoji: '🧠', desc: 'Automated ML for real-world earning models'),
  _Tool(name: 'DreamForge', url: 'https://dreamforge-ai.com', emoji: '🎮', desc: '3D Game & Asset Building with AI'),
  _Tool(name: 'Antigravity GSD', url: 'https://github.com/toonight/get-shit-done-for-antigravity.git', emoji: '⚡', desc: 'Get Shit Done Plugin (Claude/Cursor)'),
  _Tool(name: 'Fish.audio', url: 'https://fish.audio', emoji: '🎙️', desc: 'Next-gen AI Voice Cloning for high-ticket ads'),
  _Tool(name: 'Flutter Studio', url: 'https://flutterstudio.app', emoji: '📱', desc: 'Real-time Flutter UI Visual Designer'),
  _Tool(name: 'Pinokio', url: 'https://pinokio.computer', emoji: '🤥', desc: 'Run AI models locally for \$0 cloud cost'),
  _Tool(name: 'Nameeo', url: 'https://nameeo.online', emoji: '🎥', desc: 'AI Animation Toolkit for video scaling'),
  _Tool(name: 'Dev21st', url: 'https://dev21st.com', emoji: '🧑‍💻', desc: 'Modern Developer discovery & earning resources'),
  _Tool(name: 'DesignArena', url: 'https://designarena.io', emoji: '🏟️', desc: 'Premium design assets for rapid scaling'),
];

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);
  final TabBar _tabBar;
  @override double get minExtent => _tabBar.preferredSize.height;
  @override double get maxExtent => _tabBar.preferredSize.height;
  @override Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => ClipRRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Container(color: const Color(0xFF030712).withOpacity(0.8), child: _tabBar),
    ),
  );
  @override bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
