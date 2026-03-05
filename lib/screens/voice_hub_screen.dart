// lib/screens/voice_hub_screen.dart
// ══════════════════════════════════════════════════════════════
// SYNAP — Voice Hub Screen
// Hindi + English + Hinglish voice support
// speech_to_text package use kar raha hai
// ══════════════════════════════════════════════════════════════

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/tracker/tracker_bloc.dart';
import '../blocs/tracker/tracker_event.dart';
import '../widgets/ai_loader.dart';
import '../services/user_profile_service.dart';

// New Imports
import '../models/voice_tool_model.dart';
import '../services/voice_kb_service.dart';
import 'voice_hub/widgets/mode_pill.dart';
import 'voice_hub/widgets/waveform_bars.dart';
import 'voice_hub/widgets/thinking_dots.dart';
import 'voice_hub/widgets/cursor_blink.dart';
import 'voice_hub/widgets/tool_card.dart';

// ══════════════════════════════════════════════════════════════
// VOICE HUB SCREEN
// ══════════════════════════════════════════════════════════════
enum _VoiceState { idle, listening, thinking, done }

class VoiceHubScreen extends StatefulWidget {
  const VoiceHubScreen({super.key});
  @override State<VoiceHubScreen> createState() => _VoiceHubScreenState();
}

class _VoiceHubScreenState extends State<VoiceHubScreen>
    with TickerProviderStateMixin {

  // ── Speech ─────────────────────────────────────────────────
  final SpeechToText _speech = SpeechToText();
  bool   _speechAvailable = false;
  bool   _isListening      = false;
  String _transcript       = '';
  String _partialText      = '';

  // ── State ──────────────────────────────────────────────────
  _VoiceState _state = _VoiceState.idle;

  String            _aiResponse = '';
  List<VoiceToolModel>  _results    = [];
  String            _mode       = 'search'; // search | track

  // ── Animations ─────────────────────────────────────────────
  late AnimationController _pulseCtrl;
  late AnimationController _waveCtrl;
  late AnimationController _resultCtrl;
  late AnimationController _ringCtrl;

  // ── Suggestion chips ───────────────────────────────────────
  final _chips = [
    'Free image banao',
    'ChatGPT alternative',
    'Code karne ke liye',
    'Video editing free',
    'Music banana free',
    'Resume likhna hai',
    'Presentation banana',
    'Research karna hai',
  ];

  @override
  void initState() {
    super.initState();

    _pulseCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _waveCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 800),
    );

    _resultCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500),
    );

    _ringCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1200),
    );

    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _speechAvailable = await _speech.initialize(
      onStatus: _onSpeechStatus,
      onError:  (e) => _onSpeechError(e.errorMsg),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _waveCtrl.dispose();
    _resultCtrl.dispose();
    _ringCtrl.dispose();
    _speech.stop();
    super.dispose();
  }

  // ══════════════════════════════════════════════════════════
  // SPEECH LOGIC
  // ══════════════════════════════════════════════════════════
  Future<void> _toggleMic() async {
    if (_isListening) {
      await _speech.stop();
      return;
    }

    if (!_speechAvailable) {
      _showToast('Please grant Microphone permission in Settings');
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() {
      _state       = _VoiceState.listening;
      _isListening = true;
      _transcript  = '';
      _partialText = '';
      _results     = [];
      _aiResponse  = '';
    });

    _ringCtrl.repeat();
    _waveCtrl.repeat(reverse: true);

    await _speech.listen(
      onResult:          _onResult,
      listenFor:         const Duration(seconds: 10),
      pauseFor:          const Duration(seconds: 2),
      // English voice recognition
      localeId:          'en_US',
      onSoundLevelChange: (level) {
        // Wave animation speed change based on sound level
        if (mounted) setState(() {});
      },
    );
  }

  void _onResult(SpeechRecognitionResult result) {
    setState(() {
      _partialText = result.recognizedWords;
      if (result.finalResult) {
        _transcript  = result.recognizedWords;
        _isListening = false;
        _ringCtrl.stop();
        _waveCtrl.stop();
        if (_transcript.trim().isNotEmpty) {
          _processQuery(_transcript);
        } else {
          _setState(_VoiceState.idle);
        }
      }
    });
  }

  void _onSpeechStatus(String status) {
    if (status == 'done' || status == 'notListening') {
      if (_isListening && _partialText.isNotEmpty) {
        _transcript  = _partialText;
        _isListening = false;
        _ringCtrl.stop();
        _waveCtrl.stop();
        _processQuery(_transcript);
      } else if (_isListening) {
        setState(() {
          _isListening = false;
          _state = _VoiceState.idle;
        });
        _ringCtrl.stop();
        _waveCtrl.stop();
      }
    }
  }

  void _onSpeechError(String error) {
    setState(() {
      _isListening = false;
      _state = _VoiceState.idle;
    });
    _ringCtrl.stop();
    _waveCtrl.stop();
    if (error != 'error_speech_timeout') {
      _showToast('Try again — $error');
    }
  }

  // ══════════════════════════════════════════════════════════
  // PROCESS QUERY
  // ══════════════════════════════════════════════════════════
  void _processQuery(String text) async {
    if (text.trim().isEmpty) return;

    _setState(_VoiceState.thinking);
    HapticFeedback.lightImpact();

    // Simulate AI thinking delay (300ms feels natural)
    await Future.delayed(const Duration(milliseconds: 350));

    if (_mode == 'track') {
      _handleTrackCommand(text);
    } else {
      _handleSearch(text);
    }
  }

  void _handleSearch(String text) {
    final response = VoiceKBService.getResponse(text);
    final tools    = VoiceKBService.getTools(text);

    setState(() {
      _aiResponse = response;
      _results    = tools;
      _state      = _VoiceState.done;
    });

    UserProfileService.incrementToolsUsed();

    _resultCtrl.forward(from: 0);
    HapticFeedback.lightImpact();
  }

  void _handleTrackCommand(String text) {
    final cmd = VoiceKBService.parseTrackCommand(text);

    if (cmd == null) {
      setState(() {
        _aiResponse = 'Konsa tool track karna hai? Jaise: "ChatGPT ke 5 messages use kiye"';
        _results    = [];
        _state      = _VoiceState.done;
      });
      return;
    }

    final toolId = cmd['toolId'] as String;
    final count  = cmd['count']  as int;
    final isReset = cmd['isReset'] as bool;

    if (isReset) {
      context.read<TrackerBloc>().add(TrackerManualReset(toolId));
      setState(() {
        _aiResponse = '✅ $toolId reset ho gaya!';
        _results    = [];
        _state      = _VoiceState.done;
      });
    } else {
      context.read<TrackerBloc>().add(
        TrackerUsageLogged(toolId, count: count));
      setState(() {
        _aiResponse = '📊 $count ${_unitFor(toolId)} logged for ${_nameFor(toolId)}';
        _results    = [];
        _state      = _VoiceState.done;
      });
    }
    _resultCtrl.forward(from: 0);
    HapticFeedback.lightImpact();
  }

  // ── Try chip ─────────────────────────────────────────────
  void _tryChip(String text) {
    setState(() {
      _transcript  = text;
      _partialText = text;
    });
    _processQuery(text);
  }

  void _setState(_VoiceState s) {
    setState(() => _state = s);
  }

  // ── Helpers ──────────────────────────────────────────────
  String _unitFor(String toolId) {
    switch (toolId) {
      case 'midjourney': return 'images';
      case 'suno':       return 'credits';
      default:           return 'messages';
    }
  }

  String _nameFor(String toolId) {
    final map = {
      'chatgpt_gpt4o': 'ChatGPT',
      'claude':        'Claude',
      'gemini':        'Gemini',
      'perplexity':    'Perplexity',
      'suno':          'Suno',
      'midjourney':    'Midjourney',
      'cursor':        'Cursor',
    };
    return map[toolId] ?? toolId;
  }

  void _showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg,
        style: const TextStyle(fontFamily: 'DM Sans')),
      backgroundColor: const Color(0xFF0C1019),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),
    ));
  }

  // ══════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05080F),
      body: SafeArea(
        child: Column(children: [
          _buildTopBar(),
          Expanded(child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(children: [
              _buildModePills(),
              _buildMicStage(),
              _buildStatusLabel(),
              _buildTranscriptArea(),
              if (_state == _VoiceState.done) _buildResults(),
              if (_state == _VoiceState.idle ||
                  _state == _VoiceState.done)
                _buildChips(),
            ]),
          )),
        ]),
      ),
    );
  }

  // ── TOP BAR ──────────────────────────────────────────────
  Widget _buildTopBar() => Padding(
    padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
    child: Row(children: [
      IconButton(
        icon: const Icon(Icons.arrow_back_ios,
          color: Color(0xFF3A4A60), size: 18),
        onPressed: () => Navigator.pop(context),
      ),
      // Synap logo inline SVG feel — just text logo
      const Text('Voice Hub',
        style: TextStyle(fontFamily: 'Syne', fontSize: 18,
          fontWeight: FontWeight.w800, color: Colors.white,
          letterSpacing: -0.5)),
      const Spacer(),
      // Language indicator
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF00C8E8).withOpacity(0.08),
          border: Border.all(
            color: const Color(0xFF00C8E8).withOpacity(0.2)),
        ),
        child: const Text('ENGLISH',
          style: TextStyle(fontFamily: 'DM Sans', fontSize: 10,
            color: Color(0xFF00C8E8), fontWeight: FontWeight.w600,
            letterSpacing: 0.5)),
      ),
    ]),
  );

  // ── MODE PILLS ───────────────────────────────────────────
  Widget _buildModePills() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
    child: Row(children: [
      ModePill(
        icon: '🔍', label: 'Find Tool',
        active: _mode == 'search',
        onTap: () => setState(() {
          _mode = 'search';
          _results = []; _aiResponse = '';
          _state = _VoiceState.idle;
        }),
      ),
      const SizedBox(width: 10),
      ModePill(
        icon: '📊', label: 'Log Usage',
        active: _mode == 'track',
        onTap: () => setState(() {
          _mode = 'track';
          _results = []; _aiResponse = '';
          _state = _VoiceState.idle;
        }),
      ),
    ]),
  );

  // ── MIC STAGE ────────────────────────────────────────────
  Widget _buildMicStage() => SizedBox(
    height: 260,
    child: Stack(alignment: Alignment.center, children: [
      // Animated rings
      AnimatedBuilder(
        animation: _ringCtrl,
        builder: (_, __) => Stack(
          alignment: Alignment.center,
          children: [1.0, 1.4, 1.8, 2.2].asMap().entries.map((e) {
            final delay  = e.key * 0.25;
            final t      = (_ringCtrl.value - delay).clamp(0.0, 1.0);
            final scale  = _isListening ? 1.0 + t * 0.5 : 1.0;
            final opacity = _isListening
                ? (1 - t) * (e.key == 0 ? 0.5 : e.key == 1 ? 0.3 : e.key == 2 ? 0.15 : 0.07)
                : 0.06 - e.key * 0.01;
            return Transform.scale(
              scale: scale,
              child: Container(
                width: 96.0 + e.key * 30,
                height: 96.0 + e.key * 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF00C8E8)
                        .withOpacity(opacity.clamp(0, 1)),
                    width: 1,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),

      // Main mic button
      GestureDetector(
        onTap: _toggleMic,
        child: AnimatedBuilder(
          animation: _pulseCtrl,
          builder: (_, __) {
            final isActive = _isListening ||
                _state == _VoiceState.thinking;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              width: isActive ? 90 : 80,
              height: isActive ? 90 : 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? const Color(0xFF00C8E8)
                    : const Color(0xFF0C1019),
                border: Border.all(
                  color: isActive
                      ? const Color(0xFF00C8E8)
                      : const Color(0xFF00C8E8).withOpacity(
                          0.25 + 0.15 * _pulseCtrl.value),
                  width: 1.5,
                ),
                boxShadow: [BoxShadow(
                  color: const Color(0xFF00C8E8).withOpacity(
                    isActive
                        ? 0.3 + 0.15 * _pulseCtrl.value
                        : 0.08 + 0.06 * _pulseCtrl.value),
                  blurRadius: isActive ? 30 : 20,
                  spreadRadius: isActive ? 4 : 0,
                )],
              ),
              child: SynapAiLoader(
                size: isActive ? 90 : 80,
                text: _state == _VoiceState.thinking ? 'Thinking' : (_isListening ? 'Listening' : 'Talk'),
                animate: isActive,
              ),
            );
          },
        ),
      ),

      // Waveform bars (visible when listening)
      if (_isListening)
        Positioned(
          bottom: 20,
          child: AnimatedBuilder(
            animation: _waveCtrl,
            builder: (_, __) => WaveformBars(value: _waveCtrl.value),
          ),
        ),
    ]),
  );

  // ── STATUS LABEL ─────────────────────────────────────────
  Widget _buildStatusLabel() {
    String text = '';
    Color color = Colors.transparent;
    switch (_state) {
      case _VoiceState.idle:
        text  = _speechAvailable
            ? 'Tap Mic — Speak in English'
            : 'Microphone permission required';
        color = const Color(0xFF3A4A60);
        break;
      case _VoiceState.listening:
        text  = 'Listening...';
        color = const Color(0xFF00C8E8);
        break;
      case _VoiceState.thinking:
        text  = 'Thinking...';
        color = const Color(0xFFF5A623);
        break;
      case _VoiceState.done:
        text  = 'Here is your answer 👇';
        color = const Color(0xFF00D68F);
        break;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Padding(
        key: ValueKey(text),
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_state != _VoiceState.idle)
              Container(
                width: 7, height: 7,
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle, color: color,
                  boxShadow: [BoxShadow(
                    color: color.withOpacity(0.5), blurRadius: 6)],
                ),
              ),
            Text(text, style: TextStyle(fontFamily: 'DM Sans',
              fontSize: 13, color: color, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  // ── TRANSCRIPT AREA ───────────────────────────────────────
  Widget _buildTranscriptArea() {
    final display = _partialText.isNotEmpty
        ? _partialText : _transcript;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.fromLTRB(20, 6, 20, 0),
      padding: const EdgeInsets.all(14),
      constraints: const BoxConstraints(minHeight: 52),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF090D16),
        border: Border.all(
          color: _isListening
              ? const Color(0xFF00C8E8).withOpacity(0.3)
              : const Color(0xFF131B27)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('"', style: TextStyle(fontFamily: 'Syne',
            fontSize: 28, height: 0.8,
            color: const Color(0xFF131B27))),
          const SizedBox(width: 4),
          Expanded(child: display.isEmpty
              ? Text(
                  _mode == 'track'
                      ? 'E.g. "ChatGPT ke 10 messages use kiye"'
                      : 'E.g. "Free mein video edit karna hai"',
                  style: const TextStyle(fontFamily: 'DM Sans',
                    fontSize: 13, color: Color(0xFF2E3E54)),
                )
              : Text(display,
                  style: const TextStyle(fontFamily: 'DM Sans',
                    fontSize: 14, color: Colors.white, height: 1.5)),
          ),
          if (_isListening)
            const CursorBlink(),
        ],
      ),
    );
  }

  // ── AI RESULTS ───────────────────────────────────────────
  Widget _buildResults() => AnimatedBuilder(
    animation: _resultCtrl,
    builder: (_, __) {
      final v = Curves.easeOutCubic.transform(_resultCtrl.value);
      return Opacity(
        opacity: v,
        child: Transform.translate(
          offset: Offset(0, 16 * (1 - v)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Synap AI label
                Row(children: [
                  Container(
                    width: 22, height: 22,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: const Color(0xFF090D16),
                      border: Border.all(
                        color: const Color(0xFF00C8E8).withOpacity(0.3)),
                    ),
                    child: const Center(
                      child: Text('S', style: TextStyle(
                        fontFamily: 'Syne', fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF00C8E8)))),
                  ),
                  const SizedBox(width: 8),
                  const Text('Synap AI',
                    style: TextStyle(fontFamily: 'DM Sans',
                      fontSize: 11, fontWeight: FontWeight.w600,
                      color: Color(0xFF00C8E8),
                      letterSpacing: 0.5)),
                ]),
                const SizedBox(height: 10),

                // Response text
                Text(_aiResponse,
                  style: const TextStyle(fontFamily: 'DM Sans',
                    fontSize: 14, color: Colors.white, height: 1.6)),

                if (_results.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  ..._results.asMap().entries.map((e) =>
                    TweenAnimationBuilder<double>(
                      duration: Duration(
                        milliseconds: 300 + e.key * 80),
                      tween: Tween(begin: 0, end: 1),
                      curve: Curves.easeOutCubic,
                      builder: (_, v, child) => Transform.translate(
                        offset: Offset(0, 14 * (1 - v)),
                        child: Opacity(
                          opacity: v.clamp(0, 1), child: child),
                      ),
                      child: ToolResultCard(tool: e.value),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    },
  );

  // ── SUGGESTION CHIPS ─────────────────────────────────────
  Widget _buildChips() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Text('Try karo',
          style: TextStyle(fontFamily: 'DM Sans', fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.25),
            letterSpacing: 0.8)),
      ),
      SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: _chips.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) => GestureDetector(
            onTap: () => _tryChip(_chips[i]),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFF090D16),
                border: Border.all(color: const Color(0xFF131B27)),
              ),
              child: Text(_chips[i], style: const TextStyle(
                fontFamily: 'DM Sans', fontSize: 12,
                color: Color(0xFF7A8FA8), fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ),
    ],
  );
}
