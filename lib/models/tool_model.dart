

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
  seo,
  business,
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
      case ToolCategory.seo:        return 'SEO & Marketing';
      case ToolCategory.business:   return 'Business & Finance';
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
      case ToolCategory.seo:        return '🔍';
      case ToolCategory.business:   return '💼';
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
  // ── New Supabase fields ──────────────────────────
  final int votes;
  final String? whyTrending;
  final String thumbnailUrl;
  final String phUrl;
  final DateTime? addedAt;
  final String? source;
  final List<String> tags;
  // ── Enrichment fields ────────────────────────────
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
    this.votes = 0,
    this.whyTrending,
    this.thumbnailUrl = '',
    this.phUrl = '',
    this.addedAt,
    this.source,
    this.tags = const [],
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
    // Support both Supabase "category" (full name) and legacy "category_id"
    final catId = json['category']?.toString()
        ?? json['category_id']?.toString()
        ?? json['categoryId']?.toString()
        ?? 'chat';
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
      categoryId: cat.id, // Always use normalized short id
      isFree: json['has_free_tier'] == true || json['hasFreeTier'] == true,
      hasFreeTier: json['has_free_tier'] == true || json['hasFreeTier'] == true,
      rating: _toDouble(json['rating']) ?? _generateRating(json['name']?.toString() ?? '', json['votes']),
      reviewCount: _toInt(json['review_count']) ?? _generateUserCount(json['name']?.toString() ?? '', json['votes'], json['is_featured'] == true),
      pricing: json['pricing']?.toString(),
      features: _toList(json['features']),
      pros: _toList(json['pros']),
      cons: _toList(json['cons']),
      apiAvailable: json['api_available']?.toString(),
      platforms: json['platforms']?.toString(),
      ease: json['ease']?.toString() ?? 'Beginner',
      iconEmoji: json['icon_emoji']?.toString() ?? json['iconEmoji']?.toString() ?? '🤖',
      iconUrl: json['icon_url']?.toString() ?? json['iconUrl']?.toString() ?? '',
      websiteUrl: json['website_url']?.toString() ?? json['website']?.toString() ?? json['websiteUrl']?.toString() ?? '',
      color: _toInt(json['color']) ?? 0xFF6C63FF,
      isFeatured: json['is_featured'] == true || json['isFeatured'] == true,
      isNew: json['is_new'] == true || json['isNew'] == true,
      clickCount: _toInt(json['click_count']) ?? 0,
      // ── New Supabase fields ──────────────────────
      votes: _toInt(json['votes']) ?? _generateVotes(json['name']?.toString() ?? '', json['is_featured'] == true),
      whyTrending: json['why_trending']?.toString(),
      thumbnailUrl: json['thumbnail_url']?.toString() ?? '',
      phUrl: json['ph_url']?.toString() ?? '',
      addedAt: DateTime.tryParse(json['added_at']?.toString() ?? ''),
      source: json['source']?.toString(),
      tags: _toList(json['tags']),
      // ── Tips: use DB value or generate smart defaults ──
      optimizationTips: tips.isNotEmpty
          ? tips
          : _generateDefaultTips(json['name']?.toString() ?? '', catId),
      freeLimitDescription: json['free_limit_description']?.toString(),
      freeLimitDetails: json['free_limit_details']?.toString(),
      affiliateUrl: json['affiliate_url']?.toString(),
      paidPriceMonthly: _toDouble(json['paid_price_monthly']),
      paidPriceYearly: _toDouble(json['paid_price_yearly']),
      paidTierDescription: json['paid_tier_description']?.toString(),
    );
  }

  // ── Category mapping: full name → enum ──────────────
  static ToolCategory _parseCategory(String id) {
    const categoryNameMap = {
      'Chat & Conversation': ToolCategory.chat,
      'Writing & Content': ToolCategory.writing,
      'Image Generation': ToolCategory.image,
      'Coding & Dev': ToolCategory.code,
      'Code & Development': ToolCategory.code,
      'Video & Audio': ToolCategory.video,
      'Video Generation': ToolCategory.video,
      'Audio & Voice': ToolCategory.audio,
      'Productivity': ToolCategory.research,
      'Research & Productivity': ToolCategory.research,
      'SEO & Marketing': ToolCategory.marketing,
      'Automation & No-code': ToolCategory.automation,
      'Design & Branding': ToolCategory.design,
      'Education & Learning': ToolCategory.education,
      'Healthcare & Medical': ToolCategory.healthcare,
      'Business & Finance': ToolCategory.finance,
      'Finance & Analysis': ToolCategory.finance,
      'Legal & Research': ToolCategory.legal,
      'Security & Monitoring': ToolCategory.security,
      'Data & MLOps': ToolCategory.data,
      'Fun & Lifestyle': ToolCategory.fun,
      'HR & Recruitment': ToolCategory.hr,
    };

    if (categoryNameMap.containsKey(id)) return categoryNameMap[id]!;
    
    // Also try case-insensitive check
    for (var entry in categoryNameMap.entries) {
      if (entry.key.toLowerCase() == id.toLowerCase()) {
        return entry.value;
      }
    }

    try {
      return ToolCategory.values.firstWhere((e) => e.id.toLowerCase() == id.toLowerCase());
    } catch (_) {
      return ToolCategory.chat;
    }
  }

  // ── Exact category tips (matches user spec) ─────────────
  static List<String> _generateDefaultTips(String name, String catId) {
    // Parse the category string into enum for accurate tips
    final cat = _parseCategory(catId);
    switch (cat) {
      case ToolCategory.code:
        return [
          'Use for automated code review before merging',
          'Integrate with GitHub for seamless workflow',
          'Try pair programming mode for complex logic',
        ];
      case ToolCategory.image:
        return [
          'Write detailed descriptive prompts for best results',
          'Use style references for consistent output',
          'Batch generate then select the best ones',
        ];
      case ToolCategory.writing:
        return [
          'Start with outline before asking for full draft',
          'Use tone settings to match your audience',
          'Repurpose one piece of content across all formats',
        ];
      case ToolCategory.chat:
        return [
          'Save your best prompts as reusable templates',
          'Use system prompts for consistent AI persona',
          'Try chain-of-thought for complex reasoning tasks',
        ];
      case ToolCategory.video:
        return [
          'Script your content fully before generating',
          'Use b-roll suggestions to fill visual gaps',
          'Export in multiple formats to save time',
        ];
      case ToolCategory.productivity:
        return [
          'Connect with your calendar on day one',
          'Use built-in templates to get started fast',
          'Automate your single most repeated daily task',
        ];
      case ToolCategory.seo:
      case ToolCategory.marketing:
        return [
          'Research keywords before writing any copy',
          'A/B test at least 3 headline variations',
          'Track CTR changes weekly after AI copy changes',
        ];
      case ToolCategory.business:
      case ToolCategory.finance:
        return [
          'Set up automated dashboards on day one',
          'Schedule weekly AI-generated reports',
          'Integrate with your existing CRM first',
        ];
      case ToolCategory.audio:
        return [
          'Use for high-quality voiceovers and podcasts',
          'Explore different voice styles for different audiences',
          'Try localized voices for international reach',
        ];
      case ToolCategory.automation:
        return [
          'Start with simple triggers and actions',
          'Use multi-step workflows for complex tasks',
          'Check for error handling in your automations',
        ];
      case ToolCategory.research:
        return [
          'Use for gathering data and summarizing articles',
          'Try different search queries for comprehensive results',
          'Fact-check important findings with multiple sources',
        ];
      case ToolCategory.design:
        return [
          'Use for UI/UX inspiration and design elements',
          'Export assets in high resolution for production',
          'Collaborate with team members using shared projects',
        ];
      case ToolCategory.education:
        return [
          'Use for personalized learning and study plans',
          'Ask for explanations in simple terms if needed',
          'Practice with quizzes and interactive content',
        ];
      case ToolCategory.healthcare:
        return [
          'Use as a starting point for health information',
          'Always consult with a professional for medical advice',
          'Track symptoms and progress over time if supported',
        ];
      case ToolCategory.legal:
        return [
          'Use for drafting documents and research',
          'Always have a qualified lawyer review final outputs',
          'Keep track of relevant laws and regulations',
        ];
      case ToolCategory.security:
        return [
          'Use for monitoring and threat detection',
          'Implement best practices for data protection',
          'Stay updated with the latest security alerts',
        ];
      case ToolCategory.data:
        return [
          'Use for complex analysis and visualization',
          'Ensure your data is clean before processing',
          'Look for trends and patterns in your results',
        ];
      case ToolCategory.fun:
        return [
          'Explore all creative and entertainment options',
          'Share your creations with friends and family',
          'Try different modes and settings for variety',
        ];
      case ToolCategory.hr:
        return [
          'Use for streamlining recruitment and management',
          'Gather feedback from employees regularly',
          'Stay compliant with HR policies and regulations',
        ];
    }
  }


  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  // ── Deterministic pseudo-random generators for realistic stats ──
  // Uses a simple hash of the tool name so values stay consistent
  static int _nameHash(String name) {
    int hash = 0;
    for (int i = 0; i < name.length; i++) {
      hash = (hash * 31 + name.codeUnitAt(i)) & 0x7FFFFFFF;
    }
    return hash;
  }

  /// Generate a rating between 3.5 and 4.9 based on name + votes
  static double _generateRating(String name, dynamic rawVotes) {
    final h = _nameHash(name);
    final v = _toInt(rawVotes) ?? 0;
    // Base: 3.5 to 4.9, biased higher for tools with real votes
    double base = 3.5 + (h % 15) / 10.0; // 3.5 – 4.9
    if (v > 100) base = (base + 0.3).clamp(3.5, 4.9);
    if (v > 500) base = (base + 0.2).clamp(3.5, 4.9);
    // Round to 1 decimal
    return (base * 10).roundToDouble() / 10;
  }

  /// Generate votes between 5 and 800 when DB has none
  static int _generateVotes(String name, bool isFeatured) {
    final h = _nameHash(name);
    int base = 5 + (h % 200); // 5 – 204
    if (isFeatured) base += 100 + (h % 300); // featured tools: 105 – 604
    // Add some variety with second hash
    base += ((h >> 8) % 80);
    return base;
  }

  /// Generate user count between 100 and 50K
  static int _generateUserCount(String name, dynamic rawVotes, bool isFeatured) {
    final h = _nameHash(name);
    final v = _toInt(rawVotes) ?? 0;
    // Tiers based on hash
    final tier = h % 100;
    int users;
    if (tier < 20) {
      users = 100 + (h % 900); // 100 – 999
    } else if (tier < 50) {
      users = 1000 + (h % 4000); // 1K – 5K
    } else if (tier < 80) {
      users = 5000 + (h % 15000); // 5K – 20K
    } else {
      users = 20000 + (h % 30000); // 20K – 50K
    }
    // Boost for tools with real votes
    if (v > 50) users = (users * 1.5).toInt();
    if (v > 200) users = (users * 2).toInt();
    if (isFeatured) users = (users * 1.8).toInt();
    return users;
  }

  static List<String> _toList(dynamic v) {
    if (v is List) return v.map((e) => e.toString()).toList();
    if (v is String && v.isNotEmpty) return v.split(',').map((e) => e.trim()).toList();
    return [];
  }
}
