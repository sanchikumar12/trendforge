import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/themes.dart';
import '../models/models.dart' hide Platform;

class SlideCanvasWidget extends StatelessWidget {
  final SlideContent slide;
  final int slideIndex;
  final int totalSlides;
  final ThemeDNA theme;
  final BrandKit brandKit;
  final SlideAspectRatio aspectRatio;
  final bool isSelected;
  final VoidCallback? onEditBrandKit;

  const SlideCanvasWidget({
    super.key,
    required this.slide,
    required this.slideIndex,
    required this.totalSlides,
    required this.theme,
    required this.brandKit,
    required this.aspectRatio,
    this.isSelected = false,
    this.onEditBrandKit,
  });

  TextStyle _headlineStyle() => GoogleFonts.getFont(
        theme.headlineFontFamily,
        textStyle: TextStyle(
          color: theme.textColor,
          fontWeight: theme.headlineWeight,
          height: 1.15,
          letterSpacing: -0.5,
        ),
      );

  TextStyle _bodyStyle() => GoogleFonts.getFont(
        theme.bodyFontFamily,
        textStyle: TextStyle(color: theme.subtextColor, fontSize: 13, height: 1.5),
      );

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(theme.borderRadius > 0 ? 16 : 0);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.bgGradient == null ? theme.bgColor : null,
        gradient: theme.bgGradient,
        borderRadius: radius,
        border: isSelected
            ? Border.all(color: const Color(0xFF6366F1), width: 3)
            : null,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: AspectRatio(
          aspectRatio: aspectRatio.aspectValue,
          child: Stack(
            children: [
              // Grain overlay
              if (theme.grainOverlay)
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.03,
                    child: CustomPaint(painter: _GrainPainter()),
                  ),
                ),
              // Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 310,
                            child: _buildContent(),
                          ),
                        ),
                      ),
                    ),
                    _buildFooter(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onEditBrandKit,
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 13,
                    backgroundColor: Color(brandKit.primaryColor),
                    child: Text(
                      brandKit.name.isNotEmpty ? brandKit.name[0].toUpperCase() : 'A',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                brandKit.name,
                                style: GoogleFonts.inter(color: theme.textColor, fontSize: 11, fontWeight: FontWeight.w700),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.edit_rounded, size: 10, color: theme.subtextColor.withValues(alpha: 0.5)),
                          ],
                        ),
                        Text(
                          brandKit.handle,
                          style: GoogleFonts.inter(color: theme.subtextColor.withValues(alpha: 0.8), fontSize: 9, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${slideIndex + 1}/$totalSlides',
              style: GoogleFonts.jetBrainsMono(color: theme.subtextColor, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String badge) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: theme.accentColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.accentColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        badge,
        style: GoogleFonts.inter(color: theme.accentColor, fontSize: 10, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildContent() {
    switch (slide.layout) {
      case SlideLayout.hookHero:
        return _buildHookHero();
      case SlideLayout.problemAgitate:
        return _buildProblemAgitate();
      case SlideLayout.keyInsight:
        return _buildKeyInsight();
      case SlideLayout.statCallout:
        return _buildStatCallout();
      case SlideLayout.actionSteps:
        return _buildActionSteps();
      case SlideLayout.ctaAuthor:
        return _buildCtaAuthor();
    }
  }

  Widget _buildHookHero() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (slide.badge != null) ...[_buildBadge(slide.badge!), const SizedBox(height: 16)],
        Text(slide.headline, style: _headlineStyle().copyWith(fontSize: 24)),
        if (slide.subheadline != null) ...[
          const SizedBox(height: 12),
          Text(slide.subheadline!, style: _bodyStyle().copyWith(fontSize: 14)),
        ],
      ],
    );
  }

  Widget _buildProblemAgitate() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (slide.badge != null) ...[_buildBadge(slide.badge!), const SizedBox(height: 8)],
            Text(slide.headline, style: _headlineStyle().copyWith(fontSize: 18)),
            if (slide.subheadline != null) ...[
              const SizedBox(height: 6),
              Text(slide.subheadline!, style: _bodyStyle().copyWith(fontSize: 11)),
            ],
            if (slide.bulletPoints != null) ...[
              const SizedBox(height: 8),
              ...slide.bulletPoints!.map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: theme.borderColor.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 16, height: 16,
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(child: Text('✕', style: TextStyle(color: Colors.redAccent, fontSize: 8, fontWeight: FontWeight.bold))),
                          ),
                          const SizedBox(width: 6),
                          Expanded(child: Text(p, style: _bodyStyle().copyWith(color: theme.textColor, fontSize: 11))),
                        ],
                      ),
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildKeyInsight() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (slide.badge != null) ...[_buildBadge(slide.badge!), const SizedBox(height: 12)],
        Text(slide.headline, style: _headlineStyle().copyWith(fontSize: 22)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border(left: BorderSide(color: theme.accentColor, width: theme.borderWidth)),
            boxShadow: theme.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (slide.subheadline != null)
                Text(slide.subheadline!, style: GoogleFonts.inter(color: theme.accentColor, fontSize: 12, fontWeight: FontWeight.w700)),
              if (slide.body != null) ...[
                const SizedBox(height: 8),
                Text(slide.body!, style: _bodyStyle().copyWith(color: theme.textColor)),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCallout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (slide.badge != null) _buildBadge(slide.badge!),
        const SizedBox(height: 12),
        if (slide.statNumber != null)
          Text(slide.statNumber!, style: _headlineStyle().copyWith(fontSize: 56, color: theme.accentColor)),
        if (slide.statLabel != null) ...[
          const SizedBox(height: 4),
          Text(slide.statLabel!.toUpperCase(), style: GoogleFonts.inter(color: theme.subtextColor, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 2)),
        ],
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: theme.borderColor.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Text(slide.headline, style: _headlineStyle().copyWith(fontSize: 15)),
              if (slide.subheadline != null) ...[
                const SizedBox(height: 6),
                Text(slide.subheadline!, style: _bodyStyle().copyWith(fontSize: 11), textAlign: TextAlign.center),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionSteps() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (slide.badge != null) ...[_buildBadge(slide.badge!), const SizedBox(height: 12)],
        Text(slide.headline, style: _headlineStyle().copyWith(fontSize: 20)),
        if (slide.bulletPoints != null) ...[
          const SizedBox(height: 12),
          ...slide.bulletPoints!.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.borderColor.withValues(alpha: 0.2)),
                    boxShadow: theme.cardShadow,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24, height: 24,
                        decoration: BoxDecoration(
                          color: theme.accentColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '${e.key + 1}',
                            style: TextStyle(
                              color: theme.id == 'brutalist_bold' ? const Color(0xFF09090B) : Colors.white,
                              fontSize: 12, fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(e.value, style: _bodyStyle().copyWith(color: theme.textColor, fontSize: 12))),
                    ],
                  ),
                ),
              )),
        ],
      ],
    );
  }

  Widget _buildCtaAuthor() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (slide.badge != null) _buildBadge(slide.badge!),
        const SizedBox(height: 16),
        Text(slide.headline, style: _headlineStyle().copyWith(fontSize: 22), textAlign: TextAlign.center),
        if (slide.subheadline != null) ...[
          const SizedBox(height: 10),
          Text(slide.subheadline!, style: _bodyStyle().copyWith(fontSize: 12), textAlign: TextAlign.center),
        ],
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: theme.accentColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                slide.ctaButtonText ?? '📌 SAVE & SHARE',
                style: TextStyle(
                  color: theme.id == 'brutalist_bold' ? const Color(0xFF09090B) : Colors.white,
                  fontSize: 13, fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.arrow_forward_rounded, size: 16,
                  color: theme.id == 'brutalist_bold' ? const Color(0xFF09090B) : Colors.white),
            ],
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: onEditBrandKit,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: theme.borderColor.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(brandKit.primaryColor),
                  child: Text(brandKit.name.isNotEmpty ? brandKit.name[0] : 'A',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(brandKit.name, style: GoogleFonts.inter(color: theme.textColor, fontSize: 11, fontWeight: FontWeight.w700)),
                        const SizedBox(width: 4),
                        Icon(Icons.edit_rounded, size: 10, color: theme.subtextColor.withValues(alpha: 0.6)),
                      ],
                    ),
                    Text(brandKit.handle, style: GoogleFonts.inter(color: theme.subtextColor, fontSize: 9)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('TrendForge AI', style: GoogleFonts.inter(color: theme.subtextColor.withValues(alpha: 0.6), fontSize: 9)),
          slideIndex < totalSlides - 1
              ? Row(
                  children: [
                    Text('SWIPE', style: GoogleFonts.inter(color: theme.accentColor, fontSize: 10, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 2),
                    Icon(Icons.chevron_right_rounded, size: 14, color: theme.accentColor),
                  ],
                )
              : Row(
                  children: [
                    Text('FINISH', style: GoogleFonts.inter(color: theme.accentColor, fontSize: 10, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 2),
                    Icon(Icons.check_circle_outline_rounded, size: 14, color: theme.accentColor),
                  ],
                ),
        ],
      ),
    );
  }
}

class _GrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.03);
    for (var x = 0.0; x < size.width; x += 16) {
      for (var y = 0.0; y < size.height; y += 16) {
        canvas.drawCircle(Offset(x, y), 0.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
