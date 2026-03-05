import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tool_model.dart';
import '../data/tools_data.dart';

enum UserEvent { viewed, favorited, compared, searched }

class UserInteraction {
  final String toolId;
  final UserEvent event;
  final DateTime timestamp;
  final ToolCategory category;

  UserInteraction({
    required this.toolId,
    required this.event,
    required this.timestamp,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
        'toolId': toolId,
        'event': event.index,
        'timestamp': timestamp.toIso8601String(),
        'category': category.index,
      };

  factory UserInteraction.fromJson(Map<String, dynamic> j) => UserInteraction(
        toolId: j['toolId'],
        event: UserEvent.values[j['event']],
        timestamp: DateTime.parse(j['timestamp']),
        category: ToolCategory.values[j['category']],
      );
}

const Map<UserEvent, double> _eventWeights = {
  UserEvent.viewed:    1.0,
  UserEvent.favorited: 4.0,
  UserEvent.compared:  2.0,
  UserEvent.searched:  1.5,
};

class RecommendationService extends ChangeNotifier {
  static const _prefKey = 'synap_interactions';
  static const _favKey  = 'synap_favorites';

  final List<UserInteraction> _interactions = [];
  final Set<String> _favorites = {};

  static final RecommendationService _instance = RecommendationService._();
  factory RecommendationService() => _instance;
  RecommendationService._();

  Set<String> get favorites => Set.unmodifiable(_favorites);
  bool isFavorite(String id) => _favorites.contains(id);
  bool get isNewUser => _interactions.isEmpty;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefKey);
    if (raw != null) {
      try {
        final List decoded = jsonDecode(raw);
        _interactions.clear();
        _interactions.addAll(decoded.map((e) => UserInteraction.fromJson(e)));
      } catch (e) {
        debugPrint('Error loading interactions: $e');
      }
    }
    final favRaw = prefs.getStringList(_favKey);
    if (favRaw != null) {
      _favorites.clear();
      _favorites.addAll(favRaw);
    }
    notifyListeners();
  }

  Future<void> record(String toolId, UserEvent event) async {
    final tool = ToolsData.getById(toolId);
    if (tool == null) return;
    _interactions.add(UserInteraction(
      toolId: toolId,
      event: event,
      timestamp: DateTime.now(),
      category: tool.category,
    ));
    if (_interactions.length > 500) _interactions.removeAt(0);
    await _persist();
    notifyListeners();
  }

  Future<void> toggleFavorite(String toolId) async {
    if (_favorites.contains(toolId)) {
      _favorites.remove(toolId);
    } else {
      _favorites.add(toolId);
      await record(toolId, UserEvent.favorited);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favKey, _favorites.toList());
    notifyListeners();
  }

  List<ToolModel> getRecommendations({int count = 6}) {
    if (_interactions.isEmpty) {
      return ToolsData.trending.take(count).toList();
    }

    final Map<ToolCategory, double> catScores = {};
    final now = DateTime.now();
    for (final i in _interactions) {
      final daysDiff = now.difference(i.timestamp).inDays;
      final decay = 1.0 / (1.0 + daysDiff * 0.08);
      final weight = (_eventWeights[i.event] ?? 1.0) * decay;
      catScores[i.category] = (catScores[i.category] ?? 0.0) + weight;
    }

    final Map<String, double> toolScores = {};
    for (final tool in ToolsData.all) {
      final timesInteracted = _interactions.where((i) => i.toolId == tool.id).length;
      if (timesInteracted > 10) continue; 

      double score = 0.0;
      score += (catScores[tool.category] ?? 0.0) * 3.0; 
      score += tool.rating * 2.0;                        
      score += (tool.reviewCount / 10000).clamp(0.0, 5.0); 
      if (tool.isFree) score += 1.0;                     
      score -= timesInteracted * 0.8;                    

      toolScores[tool.id] = score;
    }

    final result = ToolsData.all
        .where((t) => toolScores.containsKey(t.id))
        .toList()
      ..sort((a, b) =>
          (toolScores[b.id] ?? 0).compareTo(toolScores[a.id] ?? 0));

    return result.take(count).toList();
  }

  List<ToolModel> get recentlyViewed {
    final seen = <String>{};
    final result = <ToolModel>[];
    for (final i in _interactions.reversed) {
      if (i.event == UserEvent.viewed && !seen.contains(i.toolId)) {
        final tool = ToolsData.getById(i.toolId);
        if (tool != null) result.add(tool);
        seen.add(i.toolId);
      }
      if (result.length >= 8) break;
    }
    return result;
  }

  List<ToolCategory> get topCategories {
    if (_interactions.isEmpty) return [];
    final Map<ToolCategory, double> catScores = {};
    for (final i in _interactions) {
      catScores[i.category] = (catScores[i.category] ?? 0.0) +
          (_eventWeights[i.event] ?? 1.0);
    }
    final sorted = catScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(2).map((e) => e.key).toList();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefKey,
      jsonEncode(_interactions.map((e) => e.toJson()).toList()),
    );
  }
}
