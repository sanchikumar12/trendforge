import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';

class CaptionSheet extends StatefulWidget {
  final String caption;
  final List<String> hashtags;
  final Platform platform;
  final int viralityScore;
  const CaptionSheet({super.key, required this.caption, required this.hashtags, required this.platform, required this.viralityScore});

  @override
  State<CaptionSheet> createState() => _CaptionSheetState();
}

class _CaptionSheetState extends State<CaptionSheet> {
  bool _copiedCaption = false;
  bool _copiedTags = false;

  void _copyCaption() {
    Clipboard.setData(ClipboardData(text: '${widget.caption}\n\n${widget.hashtags.join(' ')}'));
    setState(() => _copiedCaption = true);
    Future.delayed(const Duration(seconds: 2), () { if (mounted) setState(() => _copiedCaption = false); });
  }

  void _copyTags() {
    Clipboard.setData(ClipboardData(text: widget.hashtags.join(' ')));
    setState(() => _copiedTags = true);
    Future.delayed(const Duration(seconds: 2), () { if (mounted) setState(() => _copiedTags = false); });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      builder: (ctx, sc) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0A0A0F),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          controller: sc,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(margin: const EdgeInsets.only(top: 12, bottom: 8), width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
              // Header
              Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF06B6D4).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF06B6D4).withValues(alpha: 0.3)),
                    ),
                    child: const Icon(Icons.share_rounded, color: Color(0xFF22D3EE), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Post Caption & Distribution', style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
                      Text('${widget.platform == Platform.linkedin ? 'LinkedIn' : 'Instagram'} Ready', style: GoogleFonts.inter(color: const Color(0xFF22D3EE), fontSize: 10, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Virality Score
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [const Color(0xFF06B6D4).withValues(alpha: 0.1), const Color(0xFF6366F1).withValues(alpha: 0.1)]),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF06B6D4).withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(color: const Color(0xFF06B6D4).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.bolt_rounded, color: Color(0xFF22D3EE), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Predicted Scroll-Stop Score', style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                          Text('Trained on top 1% carousels', style: GoogleFonts.inter(color: Colors.white38, fontSize: 9)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${widget.viralityScore}%', style: GoogleFonts.jetBrainsMono(color: const Color(0xFF22D3EE), fontSize: 24, fontWeight: FontWeight.w900)),
                        Text('Top Tier', style: GoogleFonts.inter(color: const Color(0xFF10B981), fontSize: 9, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Caption
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Copy Caption', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700)),
                  GestureDetector(
                    onTap: _copyCaption,
                    child: Row(
                      children: [
                        Icon(_copiedCaption ? Icons.check_rounded : Icons.copy_rounded, size: 14, color: const Color(0xFF22D3EE)),
                        const SizedBox(width: 4),
                        Text(_copiedCaption ? 'Copied!' : 'Copy Full Post', style: GoogleFonts.inter(color: const Color(0xFF22D3EE), fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF12121A),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white10),
                ),
                child: SelectableText(widget.caption, style: GoogleFonts.inter(color: Colors.white70, fontSize: 12, height: 1.6)),
              ),
              const SizedBox(height: 20),
              // Hashtags
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Hashtag Bank', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700)),
                  GestureDetector(
                    onTap: _copyTags,
                    child: Row(
                      children: [
                        Icon(_copiedTags ? Icons.check_rounded : Icons.copy_rounded, size: 14, color: Colors.white38),
                        const SizedBox(width: 4),
                        Text(_copiedTags ? 'Copied!' : 'Copy Tags', style: GoogleFonts.inter(color: Colors.white38, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: widget.hashtags.map((t) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF12121A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Text(t, style: GoogleFonts.jetBrainsMono(color: const Color(0xFF22D3EE), fontSize: 11)),
                )).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _copyCaption,
                  icon: Icon(_copiedCaption ? Icons.check_rounded : Icons.copy_rounded, size: 18),
                  label: Text(_copiedCaption ? 'Copied to Clipboard!' : 'Copy Full Post & Close', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0891B2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
