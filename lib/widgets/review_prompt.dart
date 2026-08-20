import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

class ReviewPromptModal extends StatefulWidget {
  const ReviewPromptModal({super.key});

  static Future<void> checkAndShow(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hasReviewed = prefs.getBool('has_rated_app') ?? false;
    final exportCount = (prefs.getInt('export_count') ?? 0) + 1;
    await prefs.setInt('export_count', exportCount);

    if (!hasReviewed && (exportCount == 1 || exportCount % 3 == 0)) {
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => const ReviewPromptModal(),
        );
      }
    }
  }

  @override
  State<ReviewPromptModal> createState() => _ReviewPromptModalState();
}

class _ReviewPromptModalState extends State<ReviewPromptModal> {
  int _selectedStars = 5;
  bool _submitted = false;

  Future<void> _handleRateAction() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_rated_app', true);

    if (_selectedStars >= 4) {
      // Invite creator to share or review TrendForge on Play Store
      await Share.share(
        'Check out TrendForge – AI Carousel Maker on Google Play! https://play.google.com/store/apps/details?id=com.trendforge.trendforge',
        subject: 'Loving TrendForge AI Carousel Maker!',
      );
    }

    setState(() => _submitted = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F18),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withValues(alpha: 0.15),
              blurRadius: 30,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_submitted) ...[
              const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 48),
              const SizedBox(height: 14),
              Text(
                'Thank You Creator! 🚀',
                style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              Text(
                'Your support helps us keep TrendForge AI 100% free and blazing fast.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
              ),
            ] else ...[
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 26),
              ),
              const SizedBox(height: 14),
              Text(
                'Loving Your Carousel?',
                style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'Rate TrendForge 5-Stars on Google Play to unlock priority AI features!',
                style: GoogleFonts.inter(color: Colors.white60, fontSize: 12, height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              // Stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedStars = starIndex),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        starIndex <= _selectedStars ? Icons.star_rounded : Icons.star_border_rounded,
                        color: const Color(0xFFF59E0B),
                        size: 36,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 22),
              // Submit button
              GestureDetector(
                onTap: _handleRateAction,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _selectedStars >= 4 ? '⭐ Rate 5 Stars on Play Store' : '💬 Send Feedback',
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Maybe Later', style: GoogleFonts.inter(color: Colors.white38, fontSize: 11)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
