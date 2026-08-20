import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../data/themes.dart';
import '../data/ai_generator.dart';
import '../widgets/slide_canvas.dart';
import '../screens/trend_radar_screen.dart';
import '../screens/theme_gallery_screen.dart';
import '../screens/generator_screen.dart';
import '../screens/caption_screen.dart';
import '../screens/brand_kit_screen.dart';
import '../screens/export_sheet.dart';
import '../screens/privacy_policy_sheet.dart';
import '../widgets/review_prompt.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/ai_service.dart';

class StudioScreen extends StatefulWidget {
  const StudioScreen({super.key});

  @override
  State<StudioScreen> createState() => _StudioScreenState();
}

class _StudioScreenState extends State<StudioScreen> {
  late CarouselData _carousel;
  int _activeSlide = 0;
  bool _isAILoading = false;
  final PageController _pageCtrl = PageController(viewportFraction: 0.85);

  @override
  void initState() {
    super.initState();
    _carousel = generateNarrativeCarousel(
      promptOrTopic: 'Why Reasoning Models Are Replacing 80% of Traditional Prompt Engineering in 2026',
    );
    _loadSavedBrandKit();
  }

  Future<void> _loadSavedBrandKit() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('brand_name');
    final handle = prefs.getString('brand_handle');
    final role = prefs.getString('brand_role');
    final color = prefs.getInt('brand_color');

    if (name != null || handle != null || role != null || color != null) {
      setState(() {
        _carousel.brandKit = _carousel.brandKit.copyWith(
          name: name ?? _carousel.brandKit.name,
          handle: handle ?? _carousel.brandKit.handle,
          role: role ?? _carousel.brandKit.role,
          primaryColor: color ?? _carousel.brandKit.primaryColor,
        );
      });
    }
  }

  void _openBrandKit() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BrandKitSheet(
        initialBrandKit: _carousel.brandKit,
        onSave: (updated) {
          setState(() => _carousel.brandKit = updated);
          _showToast('Brand identity updated for all slides!');
        },
      ),
    );
  }

  ThemeDNA get _currentTheme => kThemeDNAPacks.firstWhere((t) => t.id == _carousel.themeId, orElse: () => kThemeDNAPacks[0]);

  void _showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(msg, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12))),
        ],
      ),
      backgroundColor: const Color(0xFF6366F1),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      duration: const Duration(seconds: 2),
    ));
  }

  void _openTrendRadar() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TrendRadarSheet(
        onSelectTrend: (topic) async {
          _showToast('Generating AI narrative arc...');
          setState(() => _isAILoading = true);
          final result = await AIService.generateCarousel(
            promptOrTopic: '${topic.topic}: ${topic.sampleHook}',
            platform: _carousel.platform,
            brandKit: _carousel.brandKit,
            themeId: _carousel.themeId,
          );
          if (mounted) {
            setState(() {
              _carousel = result;
              _activeSlide = 0;
              _isAILoading = false;
            });
            _pageCtrl.jumpToPage(0);
            _showToast('Forged: "${topic.topic.substring(0, topic.topic.length.clamp(0, 25))}..."');
          }
        },
      ),
    );
  }

  void _openThemes() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ThemeGallerySheet(
        selectedThemeId: _carousel.themeId,
        onSelectTheme: (theme) {
          setState(() => _carousel.themeId = theme.id);
          _showToast('Applied: ${theme.name}');
        },
      ),
    );
  }

  void _openGenerator() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => GeneratorSheet(
        onGenerate: (prompt, count, tone) async {
          _showToast('AI is crafting your $count-slide story arc...');
          setState(() => _isAILoading = true);
          final result = await AIService.generateCarousel(
            promptOrTopic: prompt,
            platform: _carousel.platform,
            slideCount: count,
            tone: tone,
            brandKit: _carousel.brandKit,
            themeId: _carousel.themeId,
          );
          if (mounted) {
            setState(() {
              _carousel = result;
              _activeSlide = 0;
              _isAILoading = false;
            });
            _pageCtrl.jumpToPage(0);
            _showToast('Live AI generated $count slides!');
          }
        },
      ),
    );
  }

  void _openCaptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CaptionSheet(
        caption: _carousel.caption,
        hashtags: _carousel.hashtags,
        platform: _carousel.platform,
        viralityScore: _carousel.predictedViralityScore,
      ),
    );
  }

  void _openExportSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ExportSheet(
        carousel: _carousel,
        theme: _currentTheme,
      ),
    );
    if (mounted) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) ReviewPromptModal.checkAndShow(context);
    }
  }

  void _updateSlide(SlideContent Function(SlideContent) updater) {
    setState(() {
      _carousel.slides[_activeSlide] = updater(_carousel.slides[_activeSlide]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = _currentTheme;
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildAppBar(theme),
                _buildInfoBar(theme),
                Expanded(child: _buildSlideCarousel(theme)),
                _buildSlideEditor(theme),
                _buildBottomBar(theme),
              ],
            ),
            if (_isAILoading)
              Container(
                color: Colors.black54,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D0D18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.4)),
                      boxShadow: [
                        BoxShadow(color: const Color(0xFF6366F1).withValues(alpha: 0.2), blurRadius: 20),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(color: Color(0xFF6366F1), strokeWidth: 3),
                        ),
                        const SizedBox(height: 16),
                        Text('AI Narrative Synthesizer', style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Structuring story arc & viral hooks...', style: GoogleFonts.inter(color: Colors.white54, fontSize: 11)),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(ThemeDNA theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A14),
        border: Border(bottom: BorderSide(color: Color(0xFF1E1E2E))),
      ),
      child: Row(
        children: [
          // Logo
          Container(
            height: 36, width: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFF6366F1), Color(0xFFEC4899)]),
            ),
            padding: const EdgeInsets.all(1.5),
            child: Container(
              decoration: BoxDecoration(color: const Color(0xFF020617), borderRadius: BorderRadius.circular(8.5)),
              child: const Icon(Icons.local_fire_department_rounded, color: Color(0xFFF59E0B), size: 18),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('TrendForge', style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.25)),
                    ),
                    child: Text('AI', style: GoogleFonts.inter(color: const Color(0xFF818CF8), fontSize: 8, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
              Text('Input → Insight → Carousel', style: GoogleFonts.inter(color: Colors.white30, fontSize: 9)),
            ],
          ),
          const Spacer(),
          // Data Safety / Info
          GestureDetector(
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const PrivacyPolicySheet(),
            ),
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF161622),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white12),
              ),
              child: const Icon(Icons.info_outline_rounded, size: 16, color: Colors.white60),
            ),
          ),
          // Export
          GestureDetector(
            onTap: _openExportSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.ios_share_rounded, size: 14, color: Colors.white),
                  const SizedBox(width: 4),
                  Text('Export', style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBar(ThemeDNA theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFF0D0D18),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _carousel.title,
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(8)),
            child: Text('${_carousel.slides.length} Slides', style: GoogleFonts.jetBrainsMono(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt_rounded, size: 10, color: Color(0xFF10B981)),
                const SizedBox(width: 3),
                Text('${_carousel.predictedViralityScore}%', style: GoogleFonts.jetBrainsMono(color: const Color(0xFF10B981), fontSize: 9, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlideCarousel(ThemeDNA theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.5,
          colors: [const Color(0xFF6366F1).withValues(alpha: 0.06), Colors.transparent],
        ),
      ),
      child: PageView.builder(
        controller: _pageCtrl,
        onPageChanged: (i) => setState(() => _activeSlide = i),
        itemCount: _carousel.slides.length,
        itemBuilder: (_, i) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
            child: Column(
              children: [
                // Slide index badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF12121A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Text('Slide ${i + 1} of ${_carousel.slides.length}', style: GoogleFonts.jetBrainsMono(color: Colors.white38, fontSize: 9)),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SlideCanvasWidget(
                    slide: _carousel.slides[i],
                    slideIndex: i,
                    totalSlides: _carousel.slides.length,
                    theme: theme,
                    brandKit: _carousel.brandKit,
                    aspectRatio: _carousel.aspectRatio,
                    isSelected: i == _activeSlide,
                    onEditBrandKit: _openBrandKit,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSlideEditor(ThemeDNA theme) {
    final slide = _carousel.slides[_activeSlide];
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D18),
        border: Border(top: BorderSide(color: Color(0xFF1E1E2E))),
      ),
      child: Column(
        children: [
          // Layout archetype switcher
          SizedBox(
            height: 32,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: SlideLayout.values.map((layout) {
                final sel = slide.layout == layout;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: GestureDetector(
                    onTap: () => _updateSlide((s) => s.copyWith(layout: layout)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: sel ? const Color(0xFF6366F1).withValues(alpha: 0.2) : const Color(0xFF12121A),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: sel ? const Color(0xFF6366F1) : Colors.white10),
                      ),
                      child: Row(
                        children: [
                          Text(layout.icon, style: const TextStyle(fontSize: 10)),
                          const SizedBox(width: 4),
                          Text(layout.label, style: GoogleFonts.inter(color: sel ? const Color(0xFFC7D2FE) : Colors.white38, fontSize: 9, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          // Headline quick-edit
          TextField(
            key: ValueKey('headline-$_activeSlide'),
            controller: TextEditingController(text: slide.headline)
              ..selection = TextSelection.collapsed(offset: slide.headline.length),
            onChanged: (v) => _updateSlide((s) => s.copyWith(headline: v)),
            style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
            maxLines: 1,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.title_rounded, size: 16, color: Color(0xFF818CF8)),
              hintText: 'Headline...',
              hintStyle: GoogleFonts.inter(color: Colors.white24, fontSize: 12),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              filled: true,
              fillColor: const Color(0xFF12121A),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ThemeDNA theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A14),
        border: Border(top: BorderSide(color: Color(0xFF1E1E2E))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _bottomAction(Icons.local_fire_department_rounded, 'Trends', const Color(0xFFF59E0B), _openTrendRadar),
          _bottomAction(Icons.auto_fix_high_rounded, 'Forge', const Color(0xFF818CF8), _openGenerator),
          _bottomAction(Icons.palette_rounded, 'Themes', const Color(0xFFEC4899), _openThemes),
          _bottomAction(Icons.share_rounded, 'Caption', const Color(0xFF22D3EE), _openCaptions),
          _bottomAction(Icons.add_rounded, 'Add', Colors.white54, () {
            setState(() {
              _carousel.slides.add(SlideContent(
                id: 'slide-${DateTime.now().millisecondsSinceEpoch}',
                layout: SlideLayout.keyInsight,
                headline: 'New Key Strategy',
                subheadline: 'Describe the core insight here.',
                badge: '💡 PRO TIP',
              ));
              _activeSlide = _carousel.slides.length - 1;
              _pageCtrl.animateToPage(_activeSlide, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
            });
            _showToast('Added slide ${_carousel.slides.length}');
          }),
        ],
      ),
    );
  }

  Widget _bottomAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.inter(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
