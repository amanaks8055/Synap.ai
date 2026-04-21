// lib/core/context_manager.dart
// ══════════════════════════════════════════════════════════════
// SYNAP — Lightweight Conversation Context Manager
// Tracks session memory for follow-up handling
// ══════════════════════════════════════════════════════════════

class ConversationContext {
  String? lastIntent;
  String? lastTopic;         // e.g. 'video_editing', 'coding'
  String? lastToolCategory;  // e.g. 'Video', 'Code', 'Image'
  String? lastResponse;
  int turnCount = 0;
  DateTime? sessionStart;

  // ── Message history (last 6 turns) ─────────────────────
  final List<ChatTurn> _history = [];
  List<ChatTurn> get history => List.unmodifiable(_history);

  ConversationContext() {
    sessionStart = DateTime.now();
  }

  /// Add a new conversation turn
  void addTurn(String userText, String botResponse, String intent) {
    _history.add(ChatTurn(
      userText: userText,
      botResponse: botResponse,
      intent: intent,
      timestamp: DateTime.now(),
    ));

    // Keep only last 6 turns for memory efficiency
    if (_history.length > 6) {
      _history.removeAt(0);
    }

    lastIntent = intent;
    lastResponse = botResponse;
    turnCount++;

    // Map intent to topic for follow-up detection
    _updateTopic(intent);
  }

  void _updateTopic(String intent) {
    // Only update topic for content intents, not conversational ones
    const topicIntents = {
      'tool_search': true,
    };

    if (topicIntents.containsKey(intent)) {
      lastTopic = intent;
    }
  }

  /// Set the tool category from the last tool search
  void setToolCategory(String category) {
    lastToolCategory = category;
  }

  /// Check if this is a follow-up question
  bool get isFollowUp =>
      lastTopic != null && turnCount > 0;

  /// Check if conversation is fresh (first few turns)
  bool get isFreshConversation => turnCount <= 1;

  /// Get the topic name for display
  String get topicDisplayName {
    switch (lastToolCategory) {
      case 'Video': return 'video editing';
      case 'Image': return 'image generation';
      case 'Code': return 'coding';
      case 'Audio': return 'music creation';
      case 'Chat': return 'AI assistants';
      case 'Writing': return 'writing';
      case 'Slides': return 'presentations';
      case 'Career': return 'career tools';
      case 'Search': return 'research';
      case 'Voice': return 'voice tools';
      default: return lastToolCategory ?? 'AI tools';
    }
  }

  /// Reset the conversation
  void reset() {
    lastIntent = null;
    lastTopic = null;
    lastToolCategory = null;
    lastResponse = null;
    turnCount = 0;
    _history.clear();
    sessionStart = DateTime.now();
  }
}

class ChatTurn {
  final String userText;
  final String botResponse;
  final String intent;
  final DateTime timestamp;

  const ChatTurn({
    required this.userText,
    required this.botResponse,
    required this.intent,
    required this.timestamp,
  });
}
