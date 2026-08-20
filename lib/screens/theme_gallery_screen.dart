import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/themes.dart';

class ThemeGallerySheet extends StatelessWidget {
  final String selectedThemeId;
  final void Function(ThemeDNA) onSelectTheme;
  const ThemeGallerySheet({super.key, required this.selectedThemeId, required this.onSelectTheme});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (ctx, sc) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0A0A0F),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            Center(child: Container(margin: const EdgeInsets.only(top: 12, bottom: 8), width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEC4899).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFEC4899).withValues(alpha: 0.3)),
                    ),
                    child: const Icon(Icons.palette_rounded, color: Color(0xFFEC4899), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Theme DNA Gallery', style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
                      Text('8 bespoke constraint-based design systems', style: GoogleFonts.inter(color: Colors.white38, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                controller: sc,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.72,
                ),
                itemCount: kThemeDNAPacks.length,
                itemBuilder: (_, i) => _buildThemeCard(context, kThemeDNAPacks[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeCard(BuildContext context, ThemeDNA theme) {
    final isSelected = theme.id == selectedThemeId;
    return GestureDetector(
      onTap: () {
        onSelectTheme(theme);
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF12121A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF6366F1) : Colors.white10, width: isSelected ? 2 : 1),
        ),
        child: Column(
          children: [
            // Mini theme preview
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.bgGradient == null ? theme.bgColor : null,
                  gradient: theme.bgGradient,
                  borderRadius: BorderRadius.circular(theme.borderRadius > 0 ? 12 : 0),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.badgeBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('DNA', style: TextStyle(color: theme.badgeText, fontSize: 7, fontWeight: FontWeight.w800)),
                        ),
                        Container(width: 8, height: 8, decoration: BoxDecoration(color: theme.accentColor, shape: BoxShape.circle)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Scroll-Stopping', style: GoogleFonts.getFont(theme.headlineFontFamily, textStyle: TextStyle(color: theme.textColor, fontSize: 10, fontWeight: theme.headlineWeight))),
                        const SizedBox(height: 2),
                        Text('Dynamic layout', style: TextStyle(color: theme.subtextColor, fontSize: 7)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Alex R.', style: TextStyle(color: theme.subtextColor, fontSize: 7)),
                        Text('1/6 ⏩', style: TextStyle(color: theme.accentColor, fontSize: 7, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Details
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(theme.name, style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700))),
                      if (isSelected) const Icon(Icons.check_circle_rounded, color: Color(0xFF6366F1), size: 16),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(theme.tagline, style: GoogleFonts.inter(color: Colors.white38, fontSize: 9), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF1A1A24),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          isSelected ? 'Active' : 'Apply DNA',
                          style: GoogleFonts.inter(color: isSelected ? Colors.white : Colors.white54, fontSize: 10, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
