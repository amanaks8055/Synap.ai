import 'package:flutter/material.dart';

class TrackerTool {
  final String id;
  final String name;
  int sessionUsed;
  int sessionLimit;
  int weeklyUsed;
  int weeklyLimit;
  DateTime? resetAt;
  DateTime? weeklyResetAt;
  Map<String, dynamic> models;
  DateTime? lastFetched;
  bool isEnabled;
  bool isPinned;
  String? provider;

  TrackerTool({
    required this.id,
    required this.name,
    this.sessionUsed = 0,
    this.sessionLimit = 40,
    this.weeklyUsed = 0,
    this.weeklyLimit = 0,
    this.resetAt,
    this.weeklyResetAt,
    this.models = const {},
    this.lastFetched,
    this.isEnabled = true,
    this.isPinned = false,
    this.provider,
  });

  // ── Visual getters ────────────────────────────────────────
  String get emoji {
    const map = {
      'claude': '🟠',
      'chatgpt': '🟢',
      'gemini': '🔵',
      'perplexity': '🟣',
    };
    return map[id] ?? '🤖';
  }

  int get colorHex {
    const map = {
      'claude': 0xFFFF6B35,
      'chatgpt': 0xFF10A37F,
      'gemini': 0xFF4285F4,
      'perplexity': 0xFF8B5CF6,
    };
    return map[id] ?? 0xFF6B7280;
  }

  Color get color => Color(colorHex);

  String get icon => emoji;

  // ── Usage getters ─────────────────────────────────────────
  int get freeLimit => sessionLimit;
  int get remaining => (sessionLimit - sessionUsed).clamp(0, sessionLimit);
  double get usagePct =>
      sessionLimit > 0 ? (sessionUsed / sessionLimit).clamp(0.0, 1.0) : 0.0;
  double get sessionPercent => usagePct;
  double get weeklyPercent =>
      weeklyLimit > 0 ? (weeklyUsed / weeklyLimit).clamp(0.0, 1.0) : 0.0;

  // ── Status getters ────────────────────────────────────────
  bool get isExhausted => sessionUsed >= sessionLimit && sessionLimit > 0;
  bool get isLow => !isExhausted && usagePct >= 0.8;
  bool get isWarning => isLow;
  bool get isHealthy => !isExhausted && !isLow;

  // ── Label getters ─────────────────────────────────────────
  String get unitShort => 'msgs';

  String get resetPeriodLabel {
    const map = {
      'claude': 'Daily reset',
      'chatgpt': 'Every 3h reset',
      'gemini': 'Daily reset',
      'perplexity': 'Daily reset',
    };
    return map[id] ?? 'Resets periodically';
  }

  String get countdownLabel {
    if (resetAt == null) return 'Soon';
    final diff = resetAt!.difference(DateTime.now());
    if (diff.isNegative) return 'Now';
    final h = diff.inHours;
    final m = diff.inMinutes % 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }

  String get resetTimeLabel => countdownLabel;

  String get tipWhenLow {
    const map = {
      'claude': 'Switch to ChatGPT or Gemini to save Claude tokens.',
      'chatgpt': 'Switch to Claude — it has a daily limit, not hourly.',
      'gemini': 'Try Claude or ChatGPT while Gemini resets.',
      'perplexity': 'Use ChatGPT for now, Perplexity resets daily.',
    };
    return map[id] ?? 'Consider switching to another AI tool.';
  }

  String get switchTo {
    const map = {
      'claude': 'ChatGPT',
      'chatgpt': 'Claude',
      'gemini': 'Claude',
      'perplexity': 'ChatGPT',
    };
    return map[id] ?? 'another AI tool';
  }

  // ── Factory ───────────────────────────────────────────────
  factory TrackerTool.fromPayload(String id, Map<String, dynamic> data) {
    return TrackerTool(
      id: id,
      name: _nameFor(id),
      sessionUsed: (data['sessionUsed'] as num?)?.toInt() ?? 0,
      sessionLimit: (data['sessionLimit'] as num?)?.toInt() ?? 40,
      weeklyUsed: (data['weeklyUsed'] as num?)?.toInt() ?? 0,
      weeklyLimit: (data['weeklyLimit'] as num?)?.toInt() ?? 0,
      resetAt: data['resetAt'] != null
          ? DateTime.tryParse(data['resetAt'].toString())
          : null,
      weeklyResetAt: data['weeklyResetAt'] != null
          ? DateTime.tryParse(data['weeklyResetAt'].toString())
          : null,
      models: (data['models'] as Map<String, dynamic>?) ?? {},
      lastFetched: data['lastFetched'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (data['lastFetched'] as num).toInt())
          : null,
    );
  }

  TrackerTool copyWith({
    int? sessionUsed,
    int? sessionLimit,
    int? weeklyUsed,
    int? weeklyLimit,
    DateTime? resetAt,
    bool? isEnabled,
    bool? isPinned,
  }) {
    return TrackerTool(
      id: id,
      name: name,
      sessionUsed: sessionUsed ?? this.sessionUsed,
      sessionLimit: sessionLimit ?? this.sessionLimit,
      weeklyUsed: weeklyUsed ?? this.weeklyUsed,
      weeklyLimit: weeklyLimit ?? this.weeklyLimit,
      resetAt: resetAt ?? this.resetAt,
      weeklyResetAt: weeklyResetAt,
      models: models,
      lastFetched: lastFetched,
      isEnabled: isEnabled ?? this.isEnabled,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  static String _nameFor(String id) {
    const names = {
      'claude': 'Claude',
      'chatgpt': 'ChatGPT',
      'gemini': 'Gemini',
      'perplexity': 'Perplexity',
    };
    return names[id] ?? id;
  }

  @override
  bool operator ==(Object other) =>
      other is TrackerTool &&
      other.id == id &&
      other.sessionUsed == sessionUsed &&
      other.sessionLimit == sessionLimit;

  @override
  int get hashCode => Object.hash(id, sessionUsed, sessionLimit);
}
