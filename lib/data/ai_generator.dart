import '../models/models.dart';

final BrandKit defaultBrandKit = BrandKit(
  name: 'Alex Rivera',
  handle: '@alexrivera_ai',
  role: 'AI Product Architect & Creator',
  avatarUrl: '',
  primaryColor: 0xFF6366F1,
  secondaryColor: 0xFFEC4899,
  accentColor: 0xFFF59E0B,
  backgroundColor: 0xFF0F172A,
  textColor: 0xFFFFFFFF,
);

CarouselData generateNarrativeCarousel({
  required String promptOrTopic,
  Platform platform = Platform.linkedin,
  int slideCount = 6,
  BrandKit? brandKit,
  String themeId = 'editorial_mono',
}) {
  final bk = brandKit ?? defaultBrandKit;
  final topic = promptOrTopic.trim();
  final cleanTitle = topic.length > 55 ? '${topic.substring(0, 52)}...' : topic;

  final slides = <SlideContent>[
    SlideContent(
      id: 'slide-1', layout: SlideLayout.hookHero,
      headline: topic.contains(':')
          ? topic.split(':')[0].toUpperCase()
          : 'THE REAL TRUTH ABOUT ${topic.toUpperCase().substring(0, topic.length.clamp(0, 38))}',
      subheadline: topic.contains(':')
          ? topic.split(':')[1].trim()
          : 'Most people are doing this completely backwards in 2026.',
      badge: '🔥 SCROLL STOPPER',
    ),
    SlideContent(
      id: 'slide-2', layout: SlideLayout.problemAgitate,
      headline: 'The Costly Mistake 90% Make',
      subheadline: 'Why standard advice keeps you stuck in the bottom 90%:',
      bulletPoints: [
        'Focusing on vanity metrics instead of high-leverage points',
        'Copying outdated 2023 playbooks that algorithms penalize today',
        'Burning out doing manually what intelligent systems do in seconds',
      ],
      badge: '⚠️ THE TRAP',
    ),
    SlideContent(
      id: 'slide-3', layout: SlideLayout.keyInsight,
      headline: 'The Paradigm Shift',
      subheadline: 'Winners stopped doing more work and started building compound systems.',
      body: 'The real asymmetric advantage comes from tightening your feedback loop. When you eliminate friction, output multiplies by 10x with zero extra fatigue.',
      badge: '💡 THE 80/20 RULE',
    ),
    SlideContent(
      id: 'slide-4', layout: SlideLayout.statCallout,
      statNumber: '4.8x',
      statLabel: 'Higher Conversion & Retention',
      headline: 'The Data Doesn\'t Lie',
      subheadline: 'Creators applying this visual narrative architecture outperform generic competitors by nearly 500%.',
      badge: '📊 PROVEN METRICS',
    ),
    SlideContent(
      id: 'slide-5', layout: SlideLayout.actionSteps,
      headline: 'Your 3-Step Execution Plan',
      subheadline: 'How to implement this starting today:',
      bulletPoints: [
        'Step 1: Audit your bottleneck and cut the lowest 50% value tasks',
        'Step 2: Establish a living brand token system for instant consistency',
        'Step 3: Test hooks aggressively with rapid iterative cycles',
      ],
      badge: '⚡ ACTION PLAN',
    ),
    SlideContent(
      id: 'slide-6', layout: SlideLayout.ctaAuthor,
      headline: 'Want to scale this in your workflow?',
      subheadline: 'Save this post and join 45,000+ founders building with precision.',
      ctaButtonText: '📌 SAVE & REPOST',
      quoteAuthor: bk.name,
      badge: '🚀 FINAL TAKEAWAY',
    ),
  ];

  final hookVariants = [
    'Stop scrolling: ${topic.substring(0, topic.length.clamp(0, 45))} is changing everything.',
    'I spent 100 hours analyzing ${topic.substring(0, topic.length.clamp(0, 30))}. Here is the 1-minute breakdown:',
    'Why 99% of people fail at ${topic.substring(0, topic.length.clamp(0, 35))} (and how the top 1% win):',
  ];

  final caption = platform == Platform.linkedin
      ? '90% of people get ${topic.toLowerCase()} wrong.\n\nHere is the breakdown of why traditional playbooks fail and what top performers do instead.\n\nSwipe through the carousel above for the exact framework ⏩\n\n📌 Found this helpful? Repost to help your network.'
      : 'The breakdown on ${topic.toLowerCase()} you need today ⚡\n\nSave this post before the algorithm buries it 📌\n\nDrop your thoughts in the comments! 👇';

  return CarouselData(
    id: 'carousel-${DateTime.now().millisecondsSinceEpoch}',
    title: cleanTitle,
    platform: platform,
    aspectRatio: SlideAspectRatio.ratio4x5,
    themeId: themeId,
    slides: slides.sublist(0, slideCount.clamp(3, slides.length)),
    brandKit: bk,
    predictedViralityScore: 92,
    caption: caption,
    hashtags: ['#PersonalBranding', '#Productivity', '#GrowthHacking', '#LinkedInTips', '#CreatorEconomy', '#TrendForge'],
    hookVariants: hookVariants,
  );
}
