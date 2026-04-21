// lib/core/intent_detector.dart
// ══════════════════════════════════════════════════════════════
// SYNAP — Rule-Based Intent Detection Engine
// Keyword scoring, regex patterns, synonym expansion
// ══════════════════════════════════════════════════════════════

class IntentMatch {
  final String intent;
  final double confidence;
  final String? subIntent;
  const IntentMatch(this.intent, this.confidence, {this.subIntent});
}

class IntentDetector {
  // ── Intent definitions: intent → (keywords, weight) ──────
  static const Map<String, List<_KW>> _intents = {
    // ── Greetings ──
    'greeting': [
      _KW('hi', 1.0), _KW('hello', 1.0), _KW('hey', 1.0),
      _KW('good morning', 1.2), _KW('good afternoon', 1.2),
      _KW('good evening', 1.2), _KW('good night', 1.0),
      _KW('howdy', 0.8), _KW('sup', 0.7), _KW('yo', 0.6),
      _KW('namaste', 1.0), _KW('hola', 0.8),
      _KW('greetings', 0.9), _KW('what\'s up', 1.0),
      _KW('whats up', 1.0), _KW('wassup', 0.9),
    ],

    // ── How are you ──
    'how_are_you': [
      _KW('how are you', 1.5), _KW('how r u', 1.3),
      _KW('how do you do', 1.3), _KW('how are things', 1.2),
      _KW('you good', 1.0), _KW('are you okay', 1.1),
      _KW('how is it going', 1.2), _KW('how\'s it going', 1.2),
      _KW('kaise ho', 1.3), _KW('kya haal', 1.2),
      _KW('how you doing', 1.3),
    ],

    // ── Assistant Identity ──
    'assistant_info': [
      _KW('who are you', 1.5), _KW('what are you', 1.4),
      _KW('what can you do', 1.5), _KW('what do you do', 1.4),
      _KW('your name', 1.3), _KW('introduce yourself', 1.3),
      _KW('tell me about yourself', 1.4),
      _KW('what is synap', 1.5), _KW('about synap', 1.4),
      _KW('are you ai', 1.2), _KW('are you a bot', 1.2),
      _KW('what\'s your purpose', 1.3),
      _KW('how can you help', 1.4), _KW('help me', 1.0),
      _KW('can you help', 1.2), _KW('assist me', 1.1),
    ],

    // ── Thanks ──
    'thanks': [
      _KW('thank you', 1.5), _KW('thanks', 1.3),
      _KW('thank', 1.0), _KW('appreciate', 1.1),
      _KW('great job', 1.0), _KW('awesome', 0.8),
      _KW('nice', 0.6), _KW('perfect', 0.8),
      _KW('shukriya', 1.0), _KW('dhanyawad', 1.0),
    ],

    // ── Goodbye ──
    'goodbye': [
      _KW('bye', 1.3), _KW('goodbye', 1.3),
      _KW('see you', 1.2), _KW('see ya', 1.1),
      _KW('take care', 1.2), _KW('later', 0.7),
      _KW('good night', 0.9), _KW('gotta go', 1.0),
      _KW('alvida', 1.0), _KW('cya', 0.9),
    ],

    // ── Joke / Fun ──
    'joke': [
      _KW('tell me a joke', 1.5), _KW('joke', 1.2),
      _KW('make me laugh', 1.3), _KW('funny', 0.8),
      _KW('tell something funny', 1.3),
      _KW('humor', 0.9), _KW('mazak', 1.0),
    ],

    // ── Time / Date ──
    'time_date': [
      _KW('what time', 1.5), _KW('current time', 1.4),
      _KW('what day', 1.3), _KW('what date', 1.3),
      _KW('today\'s date', 1.4), _KW('day today', 1.2),
      _KW('time right now', 1.3),
    ],

    // ── Motivation ──
    'motivation': [
      _KW('motivate me', 1.5), _KW('motivational', 1.2),
      _KW('inspire me', 1.4), _KW('motivation', 1.3),
      _KW('feeling down', 1.2), _KW('feeling sad', 1.1),
      _KW('cheer me up', 1.3), _KW('need encouragement', 1.3),
      _KW('i\'m stressed', 1.1), _KW('i am stressed', 1.1),
      _KW('feeling low', 1.2), _KW('give me hope', 1.2),
    ],

    // ── Tip / Quick Advice ──
    'tip': [
      _KW('give me a tip', 1.4), _KW('quick tip', 1.3),
      _KW('productivity tip', 1.4), _KW('life hack', 1.2),
      _KW('suggestion', 0.9), _KW('advice', 1.0),
      _KW('recommend', 0.8),
    ],

    // ── Tool search (delegates to VoiceKBService) ──
    'tool_search': [
      _KW('best tool', 1.5), _KW('best app', 1.4),
      _KW('recommend tool', 1.3), _KW('suggest tool', 1.3),
      _KW('free tool', 1.4), _KW('free app', 1.3),
      _KW('tool for', 1.3), _KW('app for', 1.2),
      _KW('software for', 1.2),
      // Categories
      _KW('video edit', 1.6), _KW('image generat', 1.5),
      _KW('photo edit', 1.4), _KW('code', 0.9),
      _KW('coding', 1.1), _KW('programming', 1.1),
      _KW('music', 0.9), _KW('song', 0.8),
      _KW('resume', 1.1), _KW('presentation', 1.1),
      _KW('writing', 0.9), _KW('design', 0.9),
      _KW('alternative', 1.0), _KW('chatgpt', 1.2),
      _KW('voice', 0.7), _KW('search engine', 1.0),
      _KW('research', 0.8), _KW('slides', 1.0),
    ],

    // ── Follow-up / Contextual ──
    'followup_free': [
      _KW('which one is free', 1.8), _KW('free one', 1.5),
      _KW('which is free', 1.6), _KW('any free', 1.4),
      _KW('free option', 1.5), _KW('free version', 1.4),
      _KW('free alternative', 1.5), _KW('without paying', 1.3),
      _KW('no cost', 1.2), _KW('free mein', 1.3),
    ],

    'followup_best': [
      _KW('which is best', 1.7), _KW('best one', 1.5),
      _KW('which one', 1.2), _KW('recommend one', 1.4),
      _KW('top pick', 1.3), _KW('number one', 1.2),
      _KW('best option', 1.4), _KW('sabse accha', 1.3),
    ],

    'followup_beginner': [
      _KW('for beginner', 1.6), _KW('easy to use', 1.5),
      _KW('simple', 0.9), _KW('beginner friendly', 1.6),
      _KW('for students', 1.3), _KW('for beginners', 1.5),
      _KW('newbie', 1.2), _KW('start with', 1.1),
    ],

    'followup_more': [
      _KW('tell me more', 1.6), _KW('more about', 1.4),
      _KW('explain more', 1.5), _KW('details', 1.0),
      _KW('elaborate', 1.2), _KW('more info', 1.3),
      _KW('aur batao', 1.3), _KW('and more', 1.0),
    ],

    // ── Yes / No ──
    'affirm': [
      _KW('yes', 1.3), _KW('yeah', 1.2), _KW('yep', 1.1),
      _KW('sure', 1.1), _KW('okay', 1.0), _KW('ok', 0.9),
      _KW('of course', 1.2), _KW('absolutely', 1.2),
      _KW('haan', 1.1), _KW('ha', 0.7),
    ],

    'deny': [
      _KW('no', 1.2), _KW('nah', 1.1), _KW('nope', 1.1),
      _KW('not really', 1.2), _KW('no thanks', 1.3),
      _KW('nahi', 1.0), _KW('don\'t want', 1.2),
    ],
  };

  /// Detect the best matching intent from input text
  static IntentMatch detect(String rawInput) {
    final input = _normalize(rawInput);
    if (input.isEmpty) return const IntentMatch('empty', 0);

    String bestIntent = 'fallback';
    double bestScore = 0;

    for (final entry in _intents.entries) {
      double score = 0;
      for (final kw in entry.value) {
        if (input.contains(kw.word)) {
          score += kw.weight;
        }
      }
      if (score > bestScore) {
        bestScore = score;
        bestIntent = entry.key;
      }
    }

    // Minimum confidence threshold
    if (bestScore < 0.5) bestIntent = 'fallback';

    return IntentMatch(bestIntent, bestScore);
  }

  /// Normalize input for matching
  static String _normalize(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r"[^\w\s']"), '')  // keep apostrophes
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}

/// Keyword with weight
class _KW {
  final String word;
  final double weight;
  const _KW(this.word, this.weight);
}
