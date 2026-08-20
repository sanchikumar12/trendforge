import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/ai_service.dart';

class GeneratorSheet extends StatefulWidget {
  final void Function(String prompt, int slideCount, String tone) onGenerate;
  const GeneratorSheet({super.key, required this.onGenerate});

  @override
  State<GeneratorSheet> createState() => _GeneratorSheetState();
}

class _GeneratorSheetState extends State<GeneratorSheet> {
  int _tabIndex = 0; // 0=prompt, 1=voice, 2=repurpose
  final _promptCtrl = TextEditingController();
  int _slideCount = 6;
  String _tone = 'authoritative';
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    AIService.loadSettings();
  }

  @override
  void dispose() {
    _promptCtrl.dispose();
    super.dispose();
  }

  void _showApiKeyDialog() {
    final keyCtrl = TextEditingController(text: AIService.currentApiKey ?? '');
    var selectedProv = AIService.currentProvider;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          backgroundColor: const Color(0xFF0D0D18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              const Icon(Icons.vpn_key_rounded, color: Color(0xFFF59E0B), size: 20),
              const SizedBox(width: 8),
              Text('Live AI Settings', style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Provider', style: GoogleFonts.inter(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A24),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<AIProvider>(
                    value: selectedProv,
                    dropdownColor: const Color(0xFF1A1A24),
                    isExpanded: true,
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 12),
                    items: const [
                      DropdownMenuItem(value: AIProvider.gemini, child: Text('Google Gemini (Free Tier / Fastest)')),
                      DropdownMenuItem(value: AIProvider.groq, child: Text('Groq Cloud (Llama 3.3 70B)')),
                      DropdownMenuItem(value: AIProvider.openai, child: Text('OpenAI (GPT-4o Mini)')),
                    ],
                    onChanged: (v) => setDlgState(() => selectedProv = v ?? AIProvider.gemini),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text('API Key', style: GoogleFonts.inter(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(
                controller: keyCtrl,
                obscureText: true,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 12),
                decoration: InputDecoration(
                  hintText: selectedProv == AIProvider.gemini ? 'AIzaSy...' : 'sk-...',
                  hintStyle: GoogleFonts.inter(color: Colors.white24, fontSize: 12),
                  filled: true,
                  fillColor: const Color(0xFF1A1A24),
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white10)),
                ),
              ),
              const SizedBox(height: 10),
              Text('Tip: Free Gemini keys can be generated at aistudio.google.com with 0 cost.', style: GoogleFonts.inter(color: Colors.white38, fontSize: 10)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: GoogleFonts.inter(color: Colors.white54)),
            ),
            ElevatedButton(
              onPressed: () async {
                final nav = Navigator.of(ctx);
                final sm = ScaffoldMessenger.of(context);
                await AIService.saveSettings(apiKey: keyCtrl.text, provider: selectedProv);
                if (mounted) setState(() {});
                nav.pop();
                sm.showSnackBar(
                  const SnackBar(content: Text('AI Key & Provider saved!'), backgroundColor: Color(0xFF10B981)),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
              child: Text('Save Key', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      maxChildSize: 0.95,
      minChildSize: 0.5,
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
                      color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
                    ),
                    child: const Icon(Icons.auto_fix_high_rounded, color: Color(0xFF818CF8), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Narrative Arc Generator', style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
                        Text('Live LLM Engine (Gemini / OpenAI / Groq)', style: GoogleFonts.inter(color: const Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _showApiKeyDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A24),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.vpn_key_rounded, size: 14, color: Color(0xFFF59E0B)),
                          const SizedBox(width: 4),
                          Text('API Key', style: GoogleFonts.inter(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Tabs
              Row(
                children: [
                  _tab(0, Icons.auto_awesome_rounded, 'Topic Prompt'),
                  const SizedBox(width: 8),
                  _tab(1, Icons.mic_rounded, 'Voice'),
                  const SizedBox(width: 8),
                  _tab(2, Icons.article_rounded, 'Repurpose'),
                ],
              ),
              const SizedBox(height: 20),
              // Tab Content
              if (_tabIndex == 0) _buildPromptTab(),
              if (_tabIndex == 1) _buildVoiceTab(),
              if (_tabIndex == 2) _buildRepurposeTab(),
              const SizedBox(height: 20),
              // Slide count & Tone
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Slide Length', style: GoogleFonts.inter(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.w700)),
                            Text('$_slideCount Slides', style: GoogleFonts.jetBrainsMono(color: const Color(0xFF818CF8), fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Slider(
                          value: _slideCount.toDouble(),
                          min: 4, max: 8, divisions: 4,
                          activeColor: const Color(0xFF6366F1),
                          inactiveColor: Colors.white12,
                          onChanged: (v) => setState(() => _slideCount = v.toInt()),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Voice', style: GoogleFonts.inter(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF12121A),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _tone,
                              dropdownColor: const Color(0xFF12121A),
                              isExpanded: true,
                              style: GoogleFonts.inter(color: Colors.white, fontSize: 11),
                              items: const [
                                DropdownMenuItem(value: 'authoritative', child: Text('Authoritative')),
                                DropdownMenuItem(value: 'contrarian', child: Text('Contrarian')),
                                DropdownMenuItem(value: 'storyteller', child: Text('Storyteller')),
                                DropdownMenuItem(value: 'data_driven', child: Text('Data-Driven')),
                              ],
                              onChanged: (v) => setState(() => _tone = v ?? 'authoritative'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _promptCtrl.text.trim().isEmpty ? null : () {
                    widget.onGenerate(_promptCtrl.text, _slideCount, _tone);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    disabledBackgroundColor: const Color(0xFF6366F1).withValues(alpha: 0.3),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.auto_awesome_rounded, size: 18),
                      const SizedBox(width: 8),
                      Text('Forge Carousel', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w900)),
                    ],
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

  Widget _tab(int idx, IconData icon, String label) {
    final sel = _tabIndex == idx;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tabIndex = idx),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: sel ? const Color(0xFF6366F1) : const Color(0xFF12121A),
            borderRadius: BorderRadius.circular(14),
            border: sel ? null : Border.all(color: Colors.white10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: sel ? Colors.white : Colors.white54),
              const SizedBox(width: 6),
              Text(label, style: GoogleFonts.inter(color: sel ? Colors.white : Colors.white54, fontSize: 10, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromptTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What concept or lesson do you want to teach?', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        TextField(
          controller: _promptCtrl,
          maxLines: 3,
          onChanged: (_) => setState(() {}),
          style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            hintText: 'e.g. 5 costly mistakes founders make when pricing their B2B SaaS...',
            hintStyle: GoogleFonts.inter(color: Colors.white24, fontSize: 12),
            filled: true,
            fillColor: const Color(0xFF12121A),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white10)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white10)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF6366F1))),
          ),
        ),
        const SizedBox(height: 10),
        Text('Quick Ideas (Tap to Fill):', style: GoogleFonts.inter(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            _ideaChip('Why Reasoning Models are replacing prompt engineering in 2026'),
            _ideaChip('5 costly mistakes founders make when pricing their B2B SaaS'),
            _ideaChip('How to scale from 0 to 50k LinkedIn followers with carousel frameworks'),
          ],
        ),
      ],
    );
  }

  Widget _ideaChip(String text) {
    return GestureDetector(
      onTap: () => setState(() => _promptCtrl.text = text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF161622),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bolt_rounded, size: 12, color: Color(0xFFF59E0B)),
            const SizedBox(width: 4),
            Text(
              text.length > 35 ? '${text.substring(0, 32)}...' : text,
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceTab() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF12121A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
            ),
            child: Icon(Icons.mic_rounded, size: 32, color: _isRecording ? Colors.redAccent : const Color(0xFF818CF8)),
          ),
          const SizedBox(height: 14),
          Text(
            _isRecording ? 'Recording...' : 'Speak Your Idea in 30 Seconds',
            style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'TrendForge will transcribe and structure the narrative arc.',
            style: GoogleFonts.inter(color: Colors.white38, fontSize: 11),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() => _isRecording = !_isRecording);
              if (!_isRecording) {
                _promptCtrl.text = 'Why 90% of solo founders fail by doing work manually instead of building compounding agent workflows';
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _isRecording ? Colors.redAccent : const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Text(_isRecording ? 'Stop & Process' : 'Start Recording', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildRepurposeTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Paste Article, Transcript, or Long Post', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        TextField(
          controller: _promptCtrl,
          maxLines: 4,
          onChanged: (_) => setState(() {}),
          style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            hintText: 'Paste the full text or transcript here...',
            hintStyle: GoogleFonts.inter(color: Colors.white24, fontSize: 12),
            filled: true, fillColor: const Color(0xFF12121A),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white10)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white10)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF6366F1))),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => setState(() {
            _promptCtrl.text = 'The 4-part framework to turn cold LinkedIn connections into enterprise consulting clients in 14 days without spamming DMs';
          }),
          child: Text('+ Insert Sample Text', style: GoogleFonts.inter(color: const Color(0xFF818CF8), fontSize: 11, fontWeight: FontWeight.w600, decoration: TextDecoration.underline)),
        ),
      ],
    );
  }
}
