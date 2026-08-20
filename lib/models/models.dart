// TrendForge — Core Data Models

enum Platform { linkedin, instagram }

enum SlideAspectRatio {
  ratio4x5('4:5', 1080, 1350),
  ratio1x1('1:1', 1080, 1080),
  ratio9x16('9:16', 1080, 1920);

  final String label;
  final int width;
  final int height;
  const SlideAspectRatio(this.label, this.width, this.height);

  double get aspectValue => width / height;
}

enum SlideLayout {
  hookHero('Hook & Hero', '🔥'),
  problemAgitate('Problem & Traps', '⚠️'),
  keyInsight('Key Insight Box', '💡'),
  statCallout('Big Stat Callout', '📊'),
  actionSteps('Actionable Steps', '⚡'),
  ctaAuthor('CTA & Bio', '🚀');

  final String label;
  final String icon;
  const SlideLayout(this.label, this.icon);
}

class SlideContent {
  String id;
  SlideLayout layout;
  String headline;
  String? subheadline;
  String? body;
  List<String>? bulletPoints;
  String? statNumber;
  String? statLabel;
  String? quoteAuthor;
  String? badge;
  String? ctaButtonText;

  SlideContent({
    required this.id,
    required this.layout,
    required this.headline,
    this.subheadline,
    this.body,
    this.bulletPoints,
    this.statNumber,
    this.statLabel,
    this.quoteAuthor,
    this.badge,
    this.ctaButtonText,
  });

  SlideContent copyWith({
    String? id,
    SlideLayout? layout,
    String? headline,
    String? subheadline,
    String? body,
    List<String>? bulletPoints,
    String? statNumber,
    String? statLabel,
    String? quoteAuthor,
    String? badge,
    String? ctaButtonText,
  }) {
    return SlideContent(
      id: id ?? this.id,
      layout: layout ?? this.layout,
      headline: headline ?? this.headline,
      subheadline: subheadline ?? this.subheadline,
      body: body ?? this.body,
      bulletPoints: bulletPoints ?? this.bulletPoints,
      statNumber: statNumber ?? this.statNumber,
      statLabel: statLabel ?? this.statLabel,
      quoteAuthor: quoteAuthor ?? this.quoteAuthor,
      badge: badge ?? this.badge,
      ctaButtonText: ctaButtonText ?? this.ctaButtonText,
    );
  }
}

class BrandKit {
  String name;
  String handle;
  String role;
  String avatarUrl;
  int primaryColor;
  int secondaryColor;
  int accentColor;
  int backgroundColor;
  int textColor;

  BrandKit({
    required this.name,
    required this.handle,
    required this.role,
    required this.avatarUrl,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.textColor,
  });

  BrandKit copyWith({
    String? name,
    String? handle,
    String? role,
    String? avatarUrl,
    int? primaryColor,
    int? secondaryColor,
    int? accentColor,
    int? backgroundColor,
    int? textColor,
  }) {
    return BrandKit(
      name: name ?? this.name,
      handle: handle ?? this.handle,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      accentColor: accentColor ?? this.accentColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
    );
  }
}

class TrendTopic {
  final String id;
  final String niche;
  final String topic;
  final int velocityScore;
  final int scrollStopProbability;
  final String sampleHook;
  final String source;
  final String growthBadge;
  final List<String> tags;

  const TrendTopic({
    required this.id,
    required this.niche,
    required this.topic,
    required this.velocityScore,
    required this.scrollStopProbability,
    required this.sampleHook,
    required this.source,
    required this.growthBadge,
    required this.tags,
  });
}

class CarouselData {
  String id;
  String title;
  Platform platform;
  SlideAspectRatio aspectRatio;
  String themeId;
  List<SlideContent> slides;
  BrandKit brandKit;
  int predictedViralityScore;
  String caption;
  List<String> hashtags;
  List<String> hookVariants;

  CarouselData({
    required this.id,
    required this.title,
    required this.platform,
    required this.aspectRatio,
    required this.themeId,
    required this.slides,
    required this.brandKit,
    required this.predictedViralityScore,
    required this.caption,
    required this.hashtags,
    required this.hookVariants,
  });
}
