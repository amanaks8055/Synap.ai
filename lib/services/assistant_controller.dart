// lib/services/assistant_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/assistant_state.dart';
import '../models/voice_tool_model.dart';
import '../core/intent_detector.dart';
import '../core/response_engine.dart';
import '../core/context_manager.dart';
import '../services/voice_kb_service.dart';
import '../services/tts_service.dart';

class AssistantController extends StateNotifier<AssistantState> {
  final ConversationContext _context = ConversationContext();
  final TtsService _tts = TtsService();

  AssistantController() : super(AssistantState.initial()) {
    _tts.init();
  }

  void addUserMessage(String text) {
    state = state.copyWith(
      messages: [...state.messages, ChatMessage(text: text, sender: Sender.user)],
    );
  }

  void addAssistantMessage(String text, {List<VoiceToolModel> tools = const []}) {
    state = state.copyWith(
      messages: [...state.messages, ChatMessage(text: text, sender: Sender.assistant, tools: tools)],
    );
  }

  void setMicState(MicState micState) {
    state = state.copyWith(micState: micState);
  }

  void setMode(String mode) {
    state = state.copyWith(mode: mode);
  }

  Future<void> processVoiceInput(String input) async {
    if (input.trim().isEmpty) {
      setMicState(MicState.idle);
      return;
    }

    addUserMessage(input);
    setMicState(MicState.processing);

    // AI Thinking Delay for Premium feel
    await Future.delayed(const Duration(milliseconds: 1600));

    String responseText = "";
    List<VoiceToolModel> tools = [];

    final normalizedInput = input.toLowerCase();

    if (state.mode == 'track') {
      final cmd = VoiceKBService.parseTrackCommand(input);
      if (cmd == null) {
        responseText = "I'm not sure which tool to track. Try 'Logged 5 ChatGPT messages'.";
      } else {
        responseText = "Understood. I've logged $input to your usage dashboard.";
      }
    } else if (normalizedInput.contains('best') || normalizedInput.contains('tool')) {
       // Premium Discovery Path
       tools = VoiceKBService.getTools('writing');
       responseText = (tools.isNotEmpty) 
          ? "Here are the top trending free AI tools for your request. Which one looks best?"
          : "Searching the neural network for free AI tools... Found a few recommendations for you.";
    } else {
      final intentMatch = IntentDetector.detect(input);
      final intent = intentMatch.intent;
      
      state = state.copyWith(lastIntent: intent);
      final result = ResponseEngine.generate(intent, input, _context);
      responseText = result.text;

      if (result.showTools && result.toolQuery != null) {
        tools = VoiceKBService.getTools(result.toolQuery!);
        if (responseText.isEmpty) {
          responseText = VoiceKBService.getResponse(result.toolQuery!);
        }
      }
      
      _context.addTurn(input, responseText, intent);
    }

    // Default response if empty
    if (responseText.isEmpty) responseText = "I've analyzed your request: \"$input\". How would you like to proceed?";

    addAssistantMessage(responseText, tools: tools);
    setMicState(MicState.speaking);

    await _tts.speak(responseText);
    setMicState(MicState.idle);
  }

  void clearChat() {
    _context.reset();
    _tts.stop();
    state = AssistantState.initial();
  }

  void stopSpeaking() {
    _tts.stop();
    setMicState(MicState.idle);
  }
}

final assistantProvider = StateNotifierProvider<AssistantController, AssistantState>((ref) {
  return AssistantController();
});
