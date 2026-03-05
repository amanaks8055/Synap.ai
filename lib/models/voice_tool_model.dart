// lib/models/voice_tool_model.dart

class VoiceToolModel {
  final String name;
  final String emoji;
  final String description;
  final String category;
  final bool isFree;
  final String url;

  const VoiceToolModel({
    required this.name,
    required this.emoji,
    required this.description,
    required this.category,
    required this.isFree,
    required this.url,
  });
}
