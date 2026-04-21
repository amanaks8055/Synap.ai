class NewsModel {
  final String id;
  final String title;
  final String summary;
  final String? imageUrl;
  final String sourceUrl;
  final String sourceName;
  final String category;
  final DateTime publishedAt;
  final bool isVerified;
  final bool isBreaking;

  NewsModel({
    required this.id,
    required this.title,
    required this.summary,
    this.imageUrl,
    required this.sourceUrl,
    required this.sourceName,
    required this.category,
    required this.publishedAt,
    this.isVerified = false,
    this.isBreaking = false,
  });

  /// Emoji for category badge
  String get categoryEmoji {
    switch (category) {
      case 'breaking': return '🔴';
      case 'launch': return '🚀';
      case 'research': return '🔬';
      case 'funding': return '💰';
      case 'opensource': return '🔓';
      default: return '📰';
    }
  }

  /// Human-readable category label
  String get categoryLabel {
    switch (category) {
      case 'breaking': return 'Breaking';
      case 'launch': return 'Launch';
      case 'research': return 'Research';
      case 'funding': return 'Funding';
      case 'opensource': return 'Open Source';
      default: return 'Update';
    }
  }

  /// Human-readable time ago string
  String get timeAgo {
    final diff = DateTime.now().difference(publishedAt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      imageUrl: json['imageUrl'],
      sourceUrl: json['sourceUrl'] ?? '',
      sourceName: json['sourceName'] ?? 'Unknown',
      category: json['category'] ?? 'update',
      publishedAt: json['publishedAt'] != null 
          ? DateTime.parse(json['publishedAt']) 
          : DateTime.now(),
      isVerified: json['isVerified'] ?? false,
      isBreaking: json['isBreaking'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'imageUrl': imageUrl,
      'sourceUrl': sourceUrl,
      'sourceName': sourceName,
      'category': category,
      'publishedAt': publishedAt.toIso8601String(),
      'isVerified': isVerified,
      'isBreaking': isBreaking,
    };
  }
}
