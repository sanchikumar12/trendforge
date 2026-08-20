import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicySheet extends StatelessWidget {
  const PrivacyPolicySheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A10),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.security_rounded, color: Color(0xFF818CF8), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Privacy & Data Safety', style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
                      Text('Google Play Compliance & Zero Data Sale Guarantee', style: GoogleFonts.inter(color: const Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _buildSection(
                title: '🔒 100% Privacy by Design',
                content: 'TrendForge does NOT collect your personal browsing history, passwords, or device identifiers. Your customized Brand Kit (creator name, handle, role) is stored locally on your device using encrypted storage.',
              ),
              const SizedBox(height: 12),
              _buildSection(
                title: '⚡ Live AI Processing',
                content: 'When you generate a carousel or analyze a topic, only your topic text or voice transcript is sent securely over TLS/SSL encryption to our AI engine (Groq/Gemini). Prompts are processed ephemerally and never used to train public AI models.',
              ),
              const SizedBox(height: 12),
              _buildSection(
                title: '📸 Export & Media Permissions',
                content: 'TrendForge uses Android storage permissions solely to save high-resolution PNG slides and LinkedIn PDF documents to your local device gallery and to share them via the standard Android Share sheet.',
              ),
              const SizedBox(height: 12),
              _buildSection(
                title: '🇮🇳 India & Global Regional Compliance',
                content: 'Fully compliant with Google Play Data Safety policies, IT Rules, and international privacy standards.',
              ),
              const SizedBox(height: 20),
              Center(
                child: Text('TrendForge v1.0.0 • Made with ❤️ for Content Creators', style: GoogleFonts.inter(color: Colors.white24, fontSize: 10)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF12121C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(content, style: GoogleFonts.inter(color: Colors.white60, fontSize: 11, height: 1.45)),
        ],
      ),
    );
  }
}
