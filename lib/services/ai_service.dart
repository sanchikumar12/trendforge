import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../data/ai_generator.dart';

enum AIProvider { gemini, openai, groq }

class AIService {
  static const String _keyApiKey = 'trendforge_api_key';
  static const String _keyProvider = 'trendforge_ai_provider';

  // Default Groq API Key loaded via environment or configured in-app
  static const String kDefaultGroqApiKey = String.fromEnvironment(
    'GROQ_API_KEY',
    defaultValue: '',
  );

  static String? _cachedApiKey;
  static AIProvider _cachedProvider = AIProvider.groq;

  static Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_keyApiKey);
    if (saved != null && saved.trim().isNotEmpty) {
      _cachedApiKey = saved.trim();
      _cachedProvider = saved.trim().startsWith('gsk_') ? AIProvider.groq : AIProvider.gemini;
    } else {
      _cachedApiKey = kDefaultGroqApiKey.isNotEmpty ? kDefaultGroqApiKey : null;
      _cachedProvider = AIProvider.groq;
    }
  }

  static Future<void> saveSettings({required String apiKey, required AIProvider provider}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyApiKey, apiKey.trim());
    await prefs.setString(_keyProvider, provider.name);
    _cachedApiKey = apiKey.trim();
    _cachedProvider = provider;
  }

  static String? get currentApiKey => _cachedApiKey;
  static AIProvider get currentProvider => _cachedProvider;

  /// Main AI generation method: calls live LLM and parses JSON schema, falls back to offline engine if needed
  static Future<CarouselData> generateCarousel({
    required String promptOrTopic,
    Platform platform = Platform.linkedin,
    int slideCount = 6,
    String tone = 'authoritative',
    BrandKit? brandKit,
    String themeId = 'editorial_mono',
  }) async {
    await loadSettings();

    // If no API key is saved, try to fetch or fall back to rule engine
    if (_cachedApiKey == null || _cachedApiKey!.isEmpty) {
      return generateNarrativeCarousel(
        promptOrTopic: promptOrTopic,
        platform: platform,
        slideCount: slideCount,
        brandKit: brandKit,
        themeId: themeId,
      );
    }

    try {
      final jsonResponse = await _callLLM(
        promptOrTopic: promptOrTopic,
        platform: platform,
        slideCount: slideCount,
        tone: tone,
        brandKit: brandKit,
      );

      if (jsonResponse != null) {
        return _parseCarouselFromJSON(
          jsonMap: jsonResponse,
          platform: platform,
          brandKit: brandKit ?? defaultBrandKit,
          themeId: themeId,
          fallbackTopic: promptOrTopic,
        );
      }
    } catch (e) {
      // Ignore error and smoothly fall back to offline narrative engine
    }

    return generateNarrativeCarousel(
      promptOrTopic: promptOrTopic,
      platform: platform,
      slideCount: slideCount,
      brandKit: brandKit,
      themeId: themeId,
    );
  }

  static Future<Map<String, dynamic>?> _callLLM({
    required String promptOrTopic,
    required Platform platform,
    required int slideCount,
    required String tone,
    BrandKit? brandKit,
  }) async {
    final systemPrompt = '''
You are TrendForge, an expert social media carousel ghostwriter for LinkedIn and Instagram.
Given a topic, generate a structured high-converting $slideCount-slide carousel adhering to a proven Narrative Arc (Hook -> Problem -> Insight -> Proof -> Steps -> CTA).
Return ONLY raw valid JSON (no markdown ticks, no commentary) matching this schema:
{
  "title": "Short title",
  "predictedViralityScore": 94,
  "hookVariants": ["Variant 1", "Variant 2", "Variant 3"],
  "caption": "Platform optimized caption text with emojis and formatting",
  "hashtags": ["#Tag1", "#Tag2", "#Tag3", "#Tag4"],
  "slides": [
    {
      "layout": "hookHero",
      "badge": "🔥 SCROLL STOPPER",
      "headline": "PUNCHY CAPITALIZED HEADLINE",
      "subheadline": "Tension-building subheadline",
      "body": null,
      "bulletPoints": null,
      "statNumber": null,
      "statLabel": null,
      "ctaButtonText": null
    },
    {
      "layout": "problemAgitate",
      "badge": "⚠️ THE TRAP",
      "headline": "Headline for Problem",
      "subheadline": "Context",
      "bulletPoints": ["Point 1", "Point 2", "Point 3"]
    },
    {
      "layout": "keyInsight",
      "badge": "💡 THE SHIFT",
      "headline": "Core Breakthrough",
      "subheadline": "Key principle",
      "body": "Explanation of the breakthrough insight..."
    },
    {
      "layout": "statCallout",
      "badge": "📊 PROVEN METRIC",
      "statNumber": "4.8x",
      "statLabel": "METRIC LABEL",
      "headline": "Why numbers don't lie",
      "subheadline": "Explanation of proof"
    },
    {
      "layout": "actionSteps",
      "badge": "⚡ ACTION PLAN",
      "headline": "Execution Framework",
      "bulletPoints": ["Step 1: ...", "Step 2: ...", "Step 3: ..."]
    },
    {
      "layout": "ctaAuthor",
      "badge": "🚀 TAKEAWAY",
      "headline": "Final Call to Action",
      "subheadline": "Save this post and follow for more",
      "ctaButtonText": "📌 SAVE & REPOST"
    }
  ]
}
Valid layout values are: "hookHero", "problemAgitate", "keyInsight", "statCallout", "actionSteps", "ctaAuthor".
Tone: $tone. Platform: ${platform.name}. Slide count: exactly $slideCount.
''';

    if (_cachedProvider == AIProvider.gemini) {
      final models = ['gemini-2.0-flash', 'gemini-1.5-flash', 'gemini-2.5-flash'];
      for (final m in models) {
        try {
          final url = Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/$m:generateContent?key=$_cachedApiKey',
          );
          final response = await http.post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'contents': [
                {
                  'parts': [
                    {'text': '$systemPrompt\n\nUSER TOPIC:\n$promptOrTopic'}
                  ]
                }
              ],
              'generationConfig': {
                'responseMimeType': 'application/json',
                'temperature': 0.7,
              }
            }),
          );

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            final rawText = data['candidates']?[0]?['content']?['parts']?[0]?['text'] as String?;
            if (rawText != null) {
              return _cleanAndParseJSON(rawText);
            }
          } else {
            print('[TrendForge AI Error $m] Status ${response.statusCode}: ${response.body}');
          }
        } catch (e) {
          print('[TrendForge AI Exception $m]: $e');
        }
      }
    } else if (_cachedProvider == AIProvider.openai || _cachedProvider == AIProvider.groq) {
      final endpoint = _cachedProvider == AIProvider.groq
          ? 'https://api.groq.com/openai/v1/chat/completions'
          : 'https://api.openai.com/v1/chat/completions';
      final models = _cachedProvider == AIProvider.groq
          ? ['openai/gpt-oss-120b', 'openai/gpt-oss-20b', 'qwen/qwen3.6-27b', 'allam-2-7b', 'groq/compound']
          : ['gpt-4o-mini', 'gpt-3.5-turbo'];

      for (final model in models) {
        try {
          final response = await http.post(
            Uri.parse(endpoint),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_cachedApiKey',
            },
            body: jsonEncode({
              'model': model,
              'messages': [
                {'role': 'system', 'content': systemPrompt},
                {'role': 'user', 'content': promptOrTopic}
              ],
              'response_format': {'type': 'json_object'},
              'temperature': 0.7,
            }),
          );

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            final rawText = data['choices']?[0]?['message']?['content'] as String?;
            if (rawText != null) {
              return _cleanAndParseJSON(rawText);
            }
          } else {
            print('[TrendForge AI Groq Error $model] Status ${response.statusCode}: ${response.body}');
          }
        } catch (e) {
          print('[TrendForge AI Groq Exception $model]: $e');
        }
      }
    }

    return null;
  }

  static Map<String, dynamic>? _cleanAndParseJSON(String raw) {
    var cleaned = raw.trim();
    if (cleaned.startsWith('```json')) {
      cleaned = cleaned.substring(7);
    } else if (cleaned.startsWith('```')) {
      cleaned = cleaned.substring(3);
    }
    if (cleaned.endsWith('```')) {
      cleaned = cleaned.substring(0, cleaned.length - 3);
    }
    cleaned = cleaned.trim();
    return jsonDecode(cleaned) as Map<String, dynamic>?;
  }

  static CarouselData _parseCarouselFromJSON({
    required Map<String, dynamic> jsonMap,
    required Platform platform,
    required BrandKit brandKit,
    required String themeId,
    required String fallbackTopic,
  }) {
    final title = jsonMap['title'] as String? ?? fallbackTopic;
    final predictedVirality = (jsonMap['predictedViralityScore'] as num?)?.toInt() ?? 94;
    final caption = jsonMap['caption'] as String? ?? '';
    final hashtags = (jsonMap['hashtags'] as List?)?.map((e) => e.toString()).toList() ?? [];
    final hookVariants = (jsonMap['hookVariants'] as List?)?.map((e) => e.toString()).toList() ?? [];

    final rawSlides = jsonMap['slides'] as List? ?? [];
    final List<SlideContent> slides = [];

    for (int i = 0; i < rawSlides.length; i++) {
      final s = rawSlides[i] as Map<String, dynamic>;
      final layoutStr = s['layout'] as String? ?? 'hookHero';
      final layout = SlideLayout.values.firstWhere(
        (l) => l.name.toLowerCase() == layoutStr.toLowerCase(),
        orElse: () => SlideLayout.keyInsight,
      );

      slides.add(SlideContent(
        id: 'slide-${i + 1}-${DateTime.now().millisecondsSinceEpoch}',
        layout: layout,
        headline: s['headline'] as String? ?? 'Slide Headline',
        subheadline: s['subheadline'] as String?,
        body: s['body'] as String?,
        bulletPoints: (s['bulletPoints'] as List?)?.map((e) => e.toString()).toList(),
        statNumber: s['statNumber'] as String?,
        statLabel: s['statLabel'] as String?,
        badge: s['badge'] as String?,
        ctaButtonText: s['ctaButtonText'] as String?,
        quoteAuthor: brandKit.name,
      ));
    }

    return CarouselData(
      id: 'carousel-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      platform: platform,
      aspectRatio: SlideAspectRatio.ratio4x5,
      themeId: themeId,
      slides: slides.isNotEmpty ? slides : generateNarrativeCarousel(promptOrTopic: fallbackTopic).slides,
      brandKit: brandKit,
      predictedViralityScore: predictedVirality,
      caption: caption,
      hashtags: hashtags,
      hookVariants: hookVariants,
    );
  }
}
