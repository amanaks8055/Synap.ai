// lib/services/tts_service.dart
// ══════════════════════════════════════════════════════════════
// SYNAP — Text-to-Speech Service
// Uses flutter_tts for voice output
// ══════════════════════════════════════════════════════════════

import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._();
  factory TtsService() => _instance;
  TtsService._();

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;
  bool _isSpeaking = false;
  static const double _speechRate = 0.44;
  static const double _pitch = 1.02;
  static const double _volume = 1.0;

  bool get isSpeaking => _isSpeaking;

  Future<void> init() async {
    if (_initialized) return;

    await _tts.awaitSpeakCompletion(true);
    await _tts.setQueueMode(0); // Flush old utterances for cleaner turn-taking.
    await _tts.setLanguage('en-US');
    await _selectMostNaturalVoice();
    await _tts.setSpeechRate(_speechRate);
    await _tts.setVolume(_volume);
    await _tts.setPitch(_pitch);

    _tts.setStartHandler(() {
      _isSpeaking = true;
    });

    _tts.setCompletionHandler(() {
      _isSpeaking = false;
    });

    _tts.setCancelHandler(() {
      _isSpeaking = false;
    });

    _tts.setErrorHandler((msg) {
      _isSpeaking = false;
    });

    _initialized = true;
  }

  Future<void> _selectMostNaturalVoice() async {
    try {
      final voices = await _tts.getVoices;
      if (voices is! List || voices.isEmpty) return;

      final parsed = voices
          .whereType<Map>()
          .map((v) => Map<String, dynamic>.from(v))
          .toList();
      if (parsed.isEmpty) return;

      int score(Map<String, dynamic> v) {
        final name = (v['name']?.toString() ?? '').toLowerCase();
        final locale = (v['locale']?.toString() ?? '').toLowerCase();
        final gender = (v['gender']?.toString() ?? '').toLowerCase();

        var s = 0;
        if (locale.startsWith('en-us')) s += 6;
        if (locale.startsWith('en-gb')) s += 5;
        if (locale.startsWith('en')) s += 3;

        if (name.contains('neural') || name.contains('enhanced') || name.contains('premium')) s += 5;
        if (name.contains('natural') || name.contains('wavenet')) s += 4;
        if (name.contains('female') || gender == 'female') s += 2;

        if (name.contains('google')) s += 2;
        if (name.contains('offline') || name.contains('compact') || name.contains('test')) s -= 3;
        return s;
      }

      parsed.sort((a, b) => score(b).compareTo(score(a)));
      final best = parsed.first;
      final bestName = best['name']?.toString();
      if (bestName == null || bestName.isEmpty) return;

      await _tts.setVoice({'name': bestName, 'locale': best['locale'] ?? 'en-US'});
    } catch (_) {
      // If voice probing fails on a device, fallback defaults still work.
    }
  }

  /// Speak text (strips emoji for cleaner TTS)
  Future<void> speak(String text) async {
    await init();
    await stop(); // Stop any ongoing speech

    // Clean text for TTS — remove emojis and special chars
    final cleaned = _cleanForTts(text);
    if (cleaned.isEmpty) return;

    _isSpeaking = true;
    await _tts.speak(cleaned);
  }

  /// Stop speaking
  Future<void> stop() async {
    _isSpeaking = false;
    await _tts.stop();
  }

  /// Clean text for natural TTS output
  String _cleanForTts(String text) {
    return text
        // Remove emojis
        .replaceAll(RegExp(
          r'[\u{1F600}-\u{1F64F}]|[\u{1F300}-\u{1F5FF}]|[\u{1F680}-\u{1F6FF}]|'
          r'[\u{1F1E0}-\u{1F1FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]|'
          r'[\u{FE00}-\u{FE0F}]|[\u{1F900}-\u{1F9FF}]|[\u{200D}]|'
          r'[\u{20E3}]|[\u{FE0F}]|[✅✦♊⚡💎💪🏆🎓✨🙌⌨️🎙️📢🔊💡🤖🎯🧠🧐]',
          unicode: true,
        ), '')
        // Remove bullet points and formatting
        .replaceAll('•', ',')
        .replaceAll('—', ', ')
        .replaceAll('-', ' ')
        .replaceAll('\n\n', '. ')
        .replaceAll('\n', '. ')
        // Expand common abbreviations for clearer pronunciation.
        .replaceAll(RegExp(r'\bAI\b'), 'A I')
        .replaceAll(RegExp(r'\bUI\b'), 'U I')
        .replaceAll(RegExp(r'\bUX\b'), 'U X')
        .replaceAll(RegExp(r'\bAPI\b'), 'A P I')
        .replaceAll('&', ' and ')
        // Normalize punctuation to create natural pauses.
        .replaceAll('...', '. ')
        .replaceAll(':', ', ')
        .replaceAll(';', ', ')
        // Collapse multiple spaces
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
