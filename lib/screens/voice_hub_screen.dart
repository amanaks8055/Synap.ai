// lib/screens/voice_hub_screen.dart
// ══════════════════════════════════════════════════════════════
// SYNAP — Premium Voice Assistant Screen
// ChatGPT-inspired conversational layout with Glassmorphism
// ══════════════════════════════════════════════════════════════

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/assistant_state.dart';
import '../services/assistant_controller.dart';
import '../models/voice_tool_model.dart';
import 'voice_hub/widgets/tool_card.dart';
import 'voice_hub/widgets/waveform_bars.dart';
import 'voice_hub/widgets/thinking_dots.dart';

class VoiceHubScreen extends ConsumerStatefulWidget {
  const VoiceHubScreen({super.key});

  @override
  ConsumerState<VoiceHubScreen> createState() => _VoiceHubScreenState();
}

class _VoiceHubScreenState extends ConsumerState<VoiceHubScreen> {
  final SpeechToText _speech = SpeechToText();
  final ScrollController _scrollCtrl = ScrollController();
  bool _speechAvailable = false;
  String _partialText = "";

  final _suggestions = [
    {'label': 'Who are you?', 'icon': Icons.info_outline},
    {'label': 'Best free AI writing tool?', 'icon': Icons.edit_note_rounded},
    {'label': 'Best video editor?', 'icon': Icons.movie_outlined},
    {'label': 'Tell me a joke', 'icon': Icons.emoji_emotions_outlined},
    {'label': 'Free music AI tool', 'icon': Icons.music_note_outlined},
    {'label': 'Give me a pro tip', 'icon': Icons.lightbulb_outline},
  ];

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      _speechAvailable = await _speech.initialize(
        onError: (e) => debugPrint('[VoiceHub] Speech Init Error: $e'),
      );
    } catch (e) {
      _speechAvailable = false;
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    ref.read(assistantProvider.notifier).stopSpeaking();
    _scrollCtrl.dispose();
    _speech.stop();
    super.dispose();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (!mounted) return;
    setState(() => _partialText = result.recognizedWords);
    if (result.finalResult) {
      ref.read(assistantProvider.notifier).processVoiceInput(result.recognizedWords);
      if (!mounted) return;
      setState(() => _partialText = "");
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutQuart,
        );
      }
    });
  }

  Future<void> _openTool(VoiceToolModel tool) async {
    final raw = tool.url.trim();
    if (raw.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No website available for this tool.')),
      );
      return;
    }

    final normalized = raw.startsWith('http://') || raw.startsWith('https://')
        ? raw
        : 'https://$raw';

    final uri = Uri.tryParse(normalized);
    if (uri == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid tool link.')),
      );
      return;
    }

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open tool link.')),
      );
    }
  }

  Future<void> _startListening() async {
    final state = ref.read(assistantProvider);
    
    if (state.micState == MicState.speaking) {
      ref.read(assistantProvider.notifier).stopSpeaking();
      return;
    }

    if (state.micState == MicState.listening) {
      await _speech.stop();
      ref.read(assistantProvider.notifier).setMicState(MicState.idle);
      return;
    }

    if (!_speechAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Speech recognition not available')),
      );
      return;
    }

    HapticFeedback.mediumImpact();
    ref.read(assistantProvider.notifier).setMicState(MicState.listening);
    
    await _speech.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 20),
      pauseFor: const Duration(seconds: 4),
      localeId: 'en_US',
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(assistantProvider);

    return WillPopScope(
      onWillPop: () async {
        ref.read(assistantProvider.notifier).stopSpeaking();
        await _speech.stop();
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF020305),
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(state),
        body: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topRight,
              radius: 1.5,
              colors: [
                Color(0xFF0F172A),
                Color(0xFF020305),
              ],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                const SizedBox(height: 10),
                _buildModeSection(state.mode),
                const SizedBox(height: 10),
                
                Expanded(
                  child: state.messages.isEmpty 
                    ? _buildEmptyState() 
                    : _buildChatList(state),
                ),

                _buildBottomSection(state),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AssistantState state) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 28),
        onPressed: () async {
          ref.read(assistantProvider.notifier).stopSpeaking();
          await _speech.stop();
          if (mounted) Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatusDot(state.micState),
            const SizedBox(width: 10),
            const Text(
              'Synap Intelligence',
              style: TextStyle(
                fontFamily: 'Syne',
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: Colors.white30, size: 22),
          onPressed: () => ref.read(assistantProvider.notifier).clearChat(),
        ).animate().scale(delay: 500.ms),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildStatusDot(MicState mic) {
    Color color;
    switch (mic) {
      case MicState.idle: color = Colors.greenAccent; break;
      case MicState.listening: color = Colors.blueAccent; break;
      case MicState.processing: color = Colors.amberAccent; break;
      case MicState.speaking: color = Colors.purpleAccent; break;
    }

    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.6), blurRadius: 6, spreadRadius: 1),
        ],
      ),
    ).animate(onPlay: (c) => c.repeat())
     .shimmer(duration: 1.5.seconds, color: Colors.white54);
  }

  Widget _buildModeSection(String currentMode) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ModePill(
            label: 'Search AI Tools',
            mode: 'chat',
            currentMode: currentMode,
            icon: Icons.search_rounded,
            onTap: () => ref.read(assistantProvider.notifier).setMode('chat'),
          ),
          const SizedBox(width: 12),
          _ModePill(
            label: 'Log AI Usage',
            mode: 'track',
            currentMode: currentMode,
            icon: Icons.analytics_outlined,
            onTap: () => ref.read(assistantProvider.notifier).setMode('track'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.03),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white24, size: 48),
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 24),
          const Text(
            "How can I help you, Master?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Syne',
              fontWeight: FontWeight.w700,
            ),
          ).animate().fadeIn(delay: 200.ms).moveY(begin: 10, end: 0),
          const SizedBox(height: 8),
          const Text(
            "Ask me anything about free AI tools.",
            style: TextStyle(color: Colors.white38, fontSize: 14),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 48),
          _buildSuggestionGrid(),
        ],
      ),
    );
  }

  Widget _buildSuggestionGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: _suggestions.map((s) {
          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              ref.read(assistantProvider.notifier).processVoiceInput(s['label'] as String);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(s['icon'] as IconData, color: Colors.white38, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    s['label'] as String,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          );
        }).toList().animate(interval: 50.ms).fadeIn().scale(begin: const Offset(0.9, 0.9)),
      ),
    );
  }

  Widget _buildChatList(AssistantState state) {
    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 80), // More bottom padding for mic button
      itemCount: state.messages.length + (state.micState == MicState.processing ? 1 : 0),
      itemBuilder: (ctx, i) {
        if (i == state.messages.length) {
          return _buildThinkingBubble();
        }

        final m = state.messages[i];
        bool isUser = m.sender == Sender.user;
        
        return Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildMessageBubble(m, isUser),
            if (m.tools.isNotEmpty) ...[
              const SizedBox(height: 16),
              SizedBox(
                height: 220, // Increased height for better card visibility
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: m.tools.length,
                  padding: const EdgeInsets.symmetric(horizontal: 4), // Small offset
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (_, ti) => ToolResultCard(
                    tool: m.tools[ti],
                    onOpen: () => _openTool(m.tools[ti]),
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, curve: Curves.easeOutCubic),
            ],
          ],
        );
      },
    );
  }

  Widget _buildThinkingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B).withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: const ThinkingDots(),
      ),
    ).animate().fade().scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildMessageBubble(ChatMessage m, bool isUser) {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isUser 
          ? const Color(0xFF2563EB).withOpacity(0.15) 
          : const Color(0xFF1E293B).withOpacity(0.5),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(24),
          topRight: const Radius.circular(24),
          bottomLeft: Radius.circular(isUser ? 24 : 6),
          bottomRight: Radius.circular(isUser ? 6 : 24),
        ),
        border: Border.all(
          color: isUser 
            ? const Color(0xFF3B82F6).withOpacity(0.4) 
            : Colors.white.withOpacity(0.1),
        ),
        boxShadow: [
          if (isUser) 
            BoxShadow(
              color: const Color(0xFF2563EB).withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Text(
        m.text,
        style: TextStyle(
          color: isUser ? Colors.white : Colors.white.withOpacity(0.9),
          fontSize: 15,
          height: 1.5,
          letterSpacing: 0.2,
          fontWeight: isUser ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    ).animate().fade(duration: 300.ms).slideY(begin: 0.05, end: 0);
  }

  Widget _buildBottomSection(AssistantState state) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            const Color(0xFF020305).withOpacity(0.95),
            const Color(0xFF020305),
          ],
        ),
      ),
      padding: EdgeInsets.fromLTRB(24, 0, 24, MediaQuery.of(context).padding.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Speech Visualization / Waveform
          if (state.micState == MicState.speaking)
             const Padding(
               padding: EdgeInsets.only(bottom: 20),
               child: WaveformBars(),
             ),

          // User Transcript (Partial)
          if (state.micState == MicState.listening && _partialText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                _partialText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ).animate().fade(),

          // Main Mic Toggle
          _buildMicButton(state.micState),
        ],
      ),
    );
  }

  Widget _buildMicButton(MicState mic) {
    bool isListening = mic == MicState.listening;
    bool isSpeaking = mic == MicState.speaking;

    return GestureDetector(
      onTap: _startListening,
      child: Container(
        width: 84,
        height: 84,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.03),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Ring animations when listening
              if (isListening)
                ...List.generate(2, (i) => 
                  Container(
                    width: 70, height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                    ),
                  ).animate(onPlay: (c) => c.repeat())
                   .scale(begin: const Offset(1, 1), end: const Offset(1.8, 1.8), duration: 1200.ms, delay: (i*600).ms)
                   .fadeOut()
                ),

              // Core Button
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isListening 
                      ? [const Color(0xFF3B82F6), const Color(0xFF2563EB)]
                      : isSpeaking
                        ? [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)]
                        : [const Color(0xFF1E293B), const Color(0xFF0F172A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    if (isListening) 
                      BoxShadow(color: Colors.blueAccent.withOpacity(0.4), blurRadius: 20, spreadRadius: 2),
                    if (isSpeaking)
                      BoxShadow(color: Colors.purpleAccent.withOpacity(0.3), blurRadius: 20, spreadRadius: 2),
                  ],
                ),
                child: Icon(
                  isListening ? Icons.stop_rounded : (isSpeaking ? Icons.volume_up_rounded : Icons.mic_none_rounded),
                  color: isListening || isSpeaking ? Colors.white : Colors.white54,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModePill extends StatelessWidget {
  final String label;
  final String mode;
  final String currentMode;
  final IconData icon;
  final VoidCallback onTap;

  const _ModePill({
    required this.label,
    required this.mode,
    required this.currentMode,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool active = mode == currentMode;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: active ? Colors.blueAccent.withOpacity(0.1) : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: active ? Colors.blueAccent.withOpacity(0.3) : Colors.white.withOpacity(0.05),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon, 
              size: 16, 
              color: active ? Colors.blueAccent : Colors.white38
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : Colors.white38,
                fontSize: 13,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
