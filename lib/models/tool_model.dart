import 'package:flutter/foundation.dart';

typedef Tool = ToolModel;

enum ToolCategory {
  chat,
  writing,
  image,
  video,
  code,
  audio,
  productivity,
  research,
  marketing,
  automation,
  design,
  education,
  healthcare,
  finance,
  legal,
  security,
  data,
  fun,
  hr,
}

extension ToolCategoryLabel on ToolCategory {
  String get label {
    switch (this) {
      case ToolCategory.chat:        return 'Chat & Conversation';
      case ToolCategory.writing:     return 'Writing & Content';
      case ToolCategory.image:       return 'Image Generation';
      case ToolCategory.video:       return 'Video';
      case ToolCategory.code:        return 'Code';
      case ToolCategory.audio:       return 'Audio';
      case ToolCategory.productivity: return 'Productivity';
      case ToolCategory.research:    return 'Research';
      case ToolCategory.marketing:   return 'Marketing';
      case ToolCategory.automation:  return 'Automation';
      case ToolCategory.design:      return 'Design';
      case ToolCategory.education:   return 'Education';
      case ToolCategory.healthcare:  return 'Healthcare';
      case ToolCategory.finance:     return 'Finance';
      case ToolCategory.legal:       return 'Legal';
      case ToolCategory.security:    return 'Security';
      case ToolCategory.data:        return 'Data';
      case ToolCategory.fun:         return 'Fun';
      case ToolCategory.hr:          return 'HR';
    }
  }

  String get emoji {
    switch (this) {
      case ToolCategory.chat:        return '💬';
      case ToolCategory.writing:     return '✍️';
      case ToolCategory.image:       return '🎨';
      case ToolCategory.video:       return '🎬';
      case ToolCategory.code:        return '💻';
      case ToolCategory.audio:       return '🎵';
      case ToolCategory.productivity: return '⚡';
      case ToolCategory.research:    return '🔬';
      case ToolCategory.marketing:   return '📈';
      case ToolCategory.automation:  return '⚙️';
      case ToolCategory.design:      return '🖌️';
      case ToolCategory.education:   return '🎓';
      case ToolCategory.healthcare:  return '🏥';
      case ToolCategory.finance:     return '💰';
      case ToolCategory.legal:       return '⚖️';
      case ToolCategory.security:    return '🛡️';
      case ToolCategory.data:        return '📊';
      case ToolCategory.fun:         return '🎮';
      case ToolCategory.hr:          return '👥';
    }
  }

  String get id {
    return toString().split('.').last;
  }
}

class ToolModel {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String shortDesc;
  final ToolCategory category;
  final String categoryId; // For legacy matching
  final bool isFree;
  final bool hasFreeTier; // Alias for isFree
  final double rating;       // 0.0 – 5.0
  final int reviewCount;
  final String? pricing;     
  final List<String> features;
  final List<String> pros;
  final List<String> cons;
  final String? apiAvailable; 
  final String? platforms;    
  final String ease;          
  final String iconEmoji;
  final String iconUrl;
  final String websiteUrl;
  final int color;            
  final bool isFeatured;
  final bool isNew;
  final int clickCount;
  final List<String> optimizationTips;
  final String? freeLimitDescription;
  final String? freeLimitDetails;
  final String? affiliateUrl;
  final double? paidPriceMonthly;
  final double? paidPriceYearly;
  final String? paidTierDescription;

  const ToolModel({
    required this.id,
    required this.name,
    this.slug = '',
    this.description = '',
    this.shortDesc = '',
    this.category = ToolCategory.chat,
    this.categoryId = 'chat',
    this.isFree = false,
    this.hasFreeTier = false,
    this.rating = 4.0,
    this.reviewCount = 100,
    this.pricing,
    this.features = const [],
    this.pros = const [],
    this.cons = const [],
    this.apiAvailable,
    this.platforms,
    this.ease = 'Beginner',
    required this.iconEmoji,
    this.iconUrl = '',
    this.websiteUrl = '',
    this.color = 0xFF6C63FF,
    this.isFeatured = false,
    this.isNew = false,
    this.clickCount = 0,
    this.optimizationTips = const [],
    this.freeLimitDescription,
    this.freeLimitDetails,
    this.affiliateUrl,
    this.paidPriceMonthly,
    this.paidPriceYearly,
    this.paidTierDescription,
  });

  /// Parse from Supabase JSON row
  factory ToolModel.fromJson(Map<String, dynamic> json) {
    final catId = json['category_id']?.toString() ?? json['categoryId']?.toString() ?? 'chat';
    final ToolCategory cat = _parseCategory(catId);
    
    List<String> tips = const [];
    final rawTips = json['optimization_tips'];
    if (rawTips is List) {
      tips = rawTips.map((e) => e.toString()).toList();
    } else if (rawTips is String && rawTips.isNotEmpty) {
      tips = rawTips.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }

    return ToolModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? json['name']?.toString().toLowerCase().replaceAll(' ', '-') ?? '',
      description: json['description']?.toString() ?? '',
      shortDesc: json['short_desc']?.toString() ?? json['description']?.toString() ?? '',
      category: cat,
      categoryId: catId,
      isFree: json['has_free_tier'] == true || json['hasFreeTier'] == true,
      hasFreeTier: json['has_free_tier'] == true || json['hasFreeTier'] == true,
      rating: _toDouble(json['rating']) ?? 4.0,
      reviewCount: (json['review_count'] ?? 1000) as int,
      pricing: json['pricing']?.toString(),
      features: _toList(json['features']),
      pros: _toList(json['pros']),
      cons: _toList(json['cons']),
      apiAvailable: json['api_available']?.toString(),
      platforms: json['platforms']?.toString(),
      ease: json['ease']?.toString() ?? 'Beginner',
      iconEmoji: json['icon_emoji']?.toString() ?? json['iconEmoji']?.toString() ?? '🤖',
      iconUrl: json['icon_url']?.toString() ?? json['iconUrl']?.toString() ?? '',
      websiteUrl: json['website_url']?.toString() ?? json['websiteUrl']?.toString() ?? '',
      color: (json['color'] as int?) ?? 0xFF6C63FF,
      isFeatured: json['is_featured'] == true || json['isFeatured'] == true,
      isNew: json['is_new'] == true || json['isFeatured'] == true,
      clickCount: (json['click_count'] ?? 0) as int,
      optimizationTips: tips,
      freeLimitDescription: json['free_limit_description']?.toString(),
      freeLimitDetails: json['free_limit_details']?.toString(),
      affiliateUrl: json['affiliate_url']?.toString(),
      paidPriceMonthly: _toDouble(json['paid_price_monthly']),
      paidPriceYearly: _toDouble(json['paid_price_yearly']),
      paidTierDescription: json['paid_tier_description']?.toString(),
    );
  }

  static ToolCategory _parseCategory(String id) {
    try {
      return ToolCategory.values.firstWhere((e) => e.id == id);
    } catch (_) {
      return ToolCategory.chat;
    }
  }

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  static List<String> _toList(dynamic v) {
    if (v is List) return v.map((e) => e.toString()).toList();
    if (v is String && v.isNotEmpty) return v.split(',').map((e) => e.trim()).toList();
    return [];
  }
}
