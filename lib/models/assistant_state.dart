// lib/models/assistant_state.dart

import '../models/voice_tool_model.dart';

enum Sender { user, assistant }

class ChatMessage {
  final String text;
  final Sender sender;
  final List<VoiceToolModel> tools;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.sender,
    this.tools = const [],
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

enum MicState {
  idle,
  listening,
  processing,
  speaking,
}

class AssistantState {
  final List<ChatMessage> messages;
  final MicState micState;
  final String? lastIntent;
  final String mode; // 'chat' | 'search' | 'track'

  AssistantState({
    required this.messages,
    required this.micState,
    this.lastIntent,
    required this.mode,
  });

  factory AssistantState.initial() {
    return AssistantState(
      messages: [],
      micState: MicState.idle,
      lastIntent: null,
      mode: 'chat',
    );
  }

  AssistantState copyWith({
    List<ChatMessage>? messages,
    MicState? micState,
    String? lastIntent,
    String? mode,
  }) {
    return AssistantState(
      messages: messages ?? this.messages,
      micState: micState ?? this.micState,
      lastIntent: lastIntent ?? this.lastIntent,
      mode: mode ?? this.mode,
    );
  }
}
