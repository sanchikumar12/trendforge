import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class BrandKitSheet extends StatefulWidget {
  final BrandKit initialBrandKit;
  final void Function(BrandKit) onSave;

  const BrandKitSheet({super.key, required this.initialBrandKit, required this.onSave});

  @override
  State<BrandKitSheet> createState() => _BrandKitSheetState();
}

class _BrandKitSheetState extends State<BrandKitSheet> {
  late TextEditingController _nameCtrl;
  late TextEditingController _handleCtrl;
  late TextEditingController _roleCtrl;
  late int _selectedColor;

  final List<int> _colorOptions = [
    0xFF6366F1, // Indigo
    0xFF3B82F6, // Blue
    0xFF10B981, // Emerald
    0xFFF59E0B, // Amber
    0xFFEC4899, // Pink
    0xFF8B5CF6, // Purple
    0xFFEF4444, // Red
    0xFF06B6D4, // Cyan
  ];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialBrandKit.name);
    _handleCtrl = TextEditingController(text: widget.initialBrandKit.handle);
    _roleCtrl = TextEditingController(text: widget.initialBrandKit.role);
    _selectedColor = widget.initialBrandKit.primaryColor;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _handleCtrl.dispose();
    _roleCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveAndClose() async {
    final updated = widget.initialBrandKit.copyWith(
      name: _nameCtrl.text.trim().isNotEmpty ? _nameCtrl.text.trim() : 'Creator Name',
      handle: _handleCtrl.text.trim().isNotEmpty
          ? (_handleCtrl.text.trim().startsWith('@') ? _handleCtrl.text.trim() : '@${_handleCtrl.text.trim()}')
          : '@creator',
      role: _roleCtrl.text.trim().isNotEmpty ? _roleCtrl.text.trim() : 'Creator',
      primaryColor: _selectedColor,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('brand_name', updated.name);
    await prefs.setString('brand_handle', updated.handle);
    await prefs.setString('brand_role', updated.role);
    await prefs.setInt('brand_color', updated.primaryColor);

    widget.onSave(updated);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
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
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              // Header
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(_selectedColor).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Color(_selectedColor).withValues(alpha: 0.3)),
                    ),
                    child: Icon(Icons.person_rounded, color: Color(_selectedColor), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Living Brand Kit', style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
                      Text('Your identity auto-injected on every slide', style: GoogleFonts.inter(color: Colors.white38, fontSize: 10)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Live Avatar / Preview Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF12121A),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(_selectedColor),
                      child: Text(
                        _nameCtrl.text.isNotEmpty ? _nameCtrl.text[0].toUpperCase() : 'A',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _nameCtrl.text.isNotEmpty ? _nameCtrl.text : 'Your Name',
                            style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _handleCtrl.text.isNotEmpty ? _handleCtrl.text : '@handle',
                            style: GoogleFonts.inter(color: Color(_selectedColor), fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            _roleCtrl.text.isNotEmpty ? _roleCtrl.text : 'Your Title / Niche',
                            style: GoogleFonts.inter(color: Colors.white38, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Name Field
              Text('Full Name / Brand Name', style: GoogleFonts.inter(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              TextField(
                controller: _nameCtrl,
                onChanged: (_) => setState(() {}),
                style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.badge_rounded, size: 16, color: Colors.white38),
                  hintText: 'e.g. Alex Rivera',
                  hintStyle: GoogleFonts.inter(color: Colors.white24, fontSize: 12),
                  filled: true,
                  fillColor: const Color(0xFF12121A),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white10)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white10)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Color(_selectedColor))),
                ),
              ),
              const SizedBox(height: 16),

              // Handle Field
              Text('Social Handle (Instagram / LinkedIn)', style: GoogleFonts.inter(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              TextField(
                controller: _handleCtrl,
                onChanged: (_) => setState(() {}),
                style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.alternate_email_rounded, size: 16, color: Colors.white38),
                  hintText: 'e.g. @alexrivera_ai',
                  hintStyle: GoogleFonts.inter(color: Colors.white24, fontSize: 12),
                  filled: true,
                  fillColor: const Color(0xFF12121A),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white10)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white10)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Color(_selectedColor))),
                ),
              ),
              const SizedBox(height: 16),

              // Role / Bio
              Text('Role / Tagline', style: GoogleFonts.inter(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              TextField(
                controller: _roleCtrl,
                onChanged: (_) => setState(() {}),
                style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.work_rounded, size: 16, color: Colors.white38),
                  hintText: 'e.g. AI Product Architect & Creator',
                  hintStyle: GoogleFonts.inter(color: Colors.white24, fontSize: 12),
                  filled: true,
                  fillColor: const Color(0xFF12121A),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white10)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white10)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Color(_selectedColor))),
                ),
              ),
              const SizedBox(height: 20),

              // Brand Primary Color Selector
              Text('Brand Signature Color', style: GoogleFonts.inter(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _colorOptions.map((c) {
                  final isSel = _selectedColor == c;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = c),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Color(c),
                        shape: BoxShape.circle,
                        border: isSel ? Border.all(color: Colors.white, width: 3) : null,
                        boxShadow: isSel ? [BoxShadow(color: Color(c).withValues(alpha: 0.6), blurRadius: 10)] : null,
                      ),
                      child: isSel ? const Icon(Icons.check_rounded, color: Colors.white, size: 18) : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveAndClose,
                  icon: const Icon(Icons.check_circle_rounded, size: 18),
                  label: Text('Save Brand Kit & Apply', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(_selectedColor),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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
