import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/trend_data.dart';
import '../models/models.dart';

class TrendRadarSheet extends StatefulWidget {
  final void Function(TrendTopic) onSelectTrend;
  const TrendRadarSheet({super.key, required this.onSelectTrend});

  @override
  State<TrendRadarSheet> createState() => _TrendRadarSheetState();
}

class _TrendRadarSheetState extends State<TrendRadarSheet> {
  String _selectedNiche = 'All Niches';

  List<TrendTopic> get _filtered => _selectedNiche == 'All Niches'
      ? kTrendRadarTopics
      : kTrendRadarTopics.where((t) => t.niche == _selectedNiche).toList();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (ctx, sc) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0A0A0F),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // Handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
                    ),
                    child: const Icon(Icons.local_fire_department_rounded, color: Color(0xFFF59E0B), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Trend Radar Engine', style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(width: 5, height: 5, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                                  const SizedBox(width: 4),
                                  Text('LIVE', style: GoogleFonts.jetBrainsMono(color: const Color(0xFF10B981), fontSize: 8, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Text('Real-time high-velocity topics scored for scroll-stop probability', style: GoogleFonts.inter(color: Colors.white38, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Niche Filters
            SizedBox(
              height: 36,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: kNicheFilters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (_, i) {
                  final niche = kNicheFilters[i];
                  final sel = _selectedNiche == niche;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedNiche = niche),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: sel ? const Color(0xFFF59E0B) : const Color(0xFF1A1A24),
                        borderRadius: BorderRadius.circular(20),
                        border: sel ? null : Border.all(color: Colors.white10),
                      ),
                      child: Text(niche, style: GoogleFonts.inter(
                        color: sel ? Colors.black : Colors.white54,
                        fontSize: 11, fontWeight: sel ? FontWeight.w800 : FontWeight.w600,
                      )),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            // Topic List
            Expanded(
              child: ListView.builder(
                controller: sc,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filtered.length,
                itemBuilder: (_, i) => _buildTopicCard(_filtered[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicCard(TrendTopic topic) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF12121A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.25)),
                ),
                child: Text(topic.niche, style: GoogleFonts.inter(color: const Color(0xFF818CF8), fontSize: 10, fontWeight: FontWeight.w700)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.25)),
                ),
                child: Text(topic.growthBadge, style: GoogleFonts.jetBrainsMono(color: const Color(0xFFF59E0B), fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(topic.topic, style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700, height: 1.3)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF08080E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Text('"${topic.sampleHook}"', style: GoogleFonts.inter(color: Colors.white54, fontSize: 11, fontStyle: FontStyle.italic)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.trending_up_rounded, size: 14, color: const Color(0xFF10B981)),
              const SizedBox(width: 4),
              Text('Velocity: ', style: GoogleFonts.inter(color: Colors.white38, fontSize: 10)),
              Text('${topic.velocityScore}/100', style: GoogleFonts.jetBrainsMono(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              const Spacer(),
              Icon(Icons.bolt_rounded, size: 14, color: const Color(0xFFF59E0B)),
              const SizedBox(width: 4),
              Text('Scroll-Stop: ', style: GoogleFonts.inter(color: Colors.white38, fontSize: 10)),
              Text('${topic.scrollStopProbability}%', style: GoogleFonts.jetBrainsMono(color: const Color(0xFFF59E0B), fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onSelectTrend(topic);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w900),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Forge Carousel'), SizedBox(width: 6), Icon(Icons.arrow_forward_rounded, size: 16)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
