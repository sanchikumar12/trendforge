import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/models.dart';
import '../data/themes.dart';
import '../widgets/slide_canvas.dart';

class ExportSheet extends StatefulWidget {
  final CarouselData carousel;
  final ThemeDNA theme;

  const ExportSheet({super.key, required this.carousel, required this.theme});

  @override
  State<ExportSheet> createState() => _ExportSheetState();
}

class _ExportSheetState extends State<ExportSheet> {
  bool _isExporting = false;
  String _statusMsg = '';
  double _progress = 0.0;
  final ScreenshotController _screenshotCtrl = ScreenshotController();

  Future<List<File>> _captureAllSlides({required double baseWidth, required double pixelRatio}) async {
    final dir = await getTemporaryDirectory();
    final files = <File>[];
    final baseHeight = baseWidth / widget.carousel.aspectRatio.aspectValue;

    for (int i = 0; i < widget.carousel.slides.length; i++) {
      if (mounted) {
        setState(() {
          _statusMsg = 'Rendering Slide ${i + 1} of ${widget.carousel.slides.length}...';
          _progress = (i + 1) / widget.carousel.slides.length;
        });
      }

      final imageBytes = await _screenshotCtrl.captureFromLongWidget(
        MediaQuery(
          data: const MediaQueryData(),
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: baseWidth,
              height: baseHeight,
              child: SlideCanvasWidget(
                slide: widget.carousel.slides[i],
                slideIndex: i,
                totalSlides: widget.carousel.slides.length,
                theme: widget.theme,
                brandKit: widget.carousel.brandKit,
                aspectRatio: widget.carousel.aspectRatio,
              ),
            ),
          ),
        ),
        delay: const Duration(milliseconds: 120),
        pixelRatio: pixelRatio,
      );

      final file = File('${dir.path}/trendforge_slide_${i + 1}.png');
      await file.writeAsBytes(imageBytes);
      files.add(file);
    }
    return files;
  }

  Future<void> _exportAsPngPack() async {
    setState(() {
      _isExporting = true;
      _statusMsg = 'Generating 1080x1350 PNG pack...';
      _progress = 0.1;
    });

    try {
      final files = await _captureAllSlides(baseWidth: 360, pixelRatio: 3.0);
      final xFiles = files.map((f) => XFile(f.path)).toList();
      final shareText = '${widget.carousel.caption}\n\n${widget.carousel.hashtags.join(' ')}';

      await Share.shareXFiles(
        xFiles,
        text: shareText,
        subject: widget.carousel.title,
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _exportAsLinkedInPdf() async {
    setState(() {
      _isExporting = true;
      _statusMsg = 'Rendering slides for LinkedIn PDF...';
      _progress = 0.1;
    });

    try {
      final files = await _captureAllSlides(baseWidth: 360, pixelRatio: 3.0);

      if (mounted) {
        setState(() {
          _statusMsg = 'Compiling Multi-Page PDF Document...';
          _progress = 0.9;
        });
      }

      final pdf = pw.Document();
      final pageFormat = PdfPageFormat(
        1080 * PdfPageFormat.point / 2.0,
        1350 * PdfPageFormat.point / 2.0,
        marginAll: 0,
      );

      for (final f in files) {
        final imageBytes = await f.readAsBytes();
        final pdfImage = pw.MemoryImage(imageBytes);
        pdf.addPage(
          pw.Page(
            pageFormat: pageFormat,
            build: (pw.Context context) {
              return pw.FullPage(
                ignoreMargins: true,
                child: pw.Image(pdfImage, fit: pw.BoxFit.fill),
              );
            },
          ),
        );
      }

      final dir = await getTemporaryDirectory();
      final pdfFile = File('${dir.path}/trendforge_carousel.pdf');
      await pdfFile.writeAsBytes(await pdf.save());

      final shareText = '${widget.carousel.caption}\n\n${widget.carousel.hashtags.join(' ')}';

      await Share.shareXFiles(
        [XFile(pdfFile.path)],
        text: shareText,
        subject: '${widget.carousel.title} - LinkedIn Document Carousel',
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF Export failed: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          color: Color(0xFF0A0A0F),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              // Header
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                    ),
                    child: const Icon(Icons.ios_share_rounded, color: Color(0xFF10B981), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pixel-Perfect Export',
                          style: GoogleFonts.inter(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900),
                        ),
                        Text(
                          'Exact 1080x1350 (4:5) / 1080x1080 (1:1) Native Scaling',
                          style: GoogleFonts.inter(color: const Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              if (_isExporting) ...[
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF12121A),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        value: _progress,
                        backgroundColor: Colors.white12,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                        borderRadius: BorderRadius.circular(10),
                        minHeight: 6,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _statusMsg,
                        style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rendering 1:1 preview matching resolution...',
                        style: GoogleFonts.inter(color: Colors.white38, fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ] else ...[
                // Option 1: Instagram PNG Pack
                _exportOptionCard(
                  title: 'Instagram PNG Pack',
                  subtitle: 'Exact 1080 x 1350 px individual high-res PNG slides',
                  icon: Icons.photo_library_rounded,
                  color: const Color(0xFFE1306C),
                  tag: '1080x1350 PNG',
                  onTap: _exportAsPngPack,
                ),
                const SizedBox(height: 10),

                // Option 2: LinkedIn Multi-Page PDF Document
                _exportOptionCard(
                  title: 'LinkedIn Document (PDF)',
                  subtitle: 'Swipeable multi-page PDF document format for LinkedIn',
                  icon: Icons.picture_as_pdf_rounded,
                  color: const Color(0xFF0A66C2),
                  tag: 'LinkedIn PDF',
                  onTap: _exportAsLinkedInPdf,
                ),
              ],
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _exportOptionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String tag,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF12121A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tag,
                          style: GoogleFonts.jetBrainsMono(color: color, fontSize: 8, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(color: Colors.white38, fontSize: 10),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 12),
          ],
        ),
      ),
    );
  }
}
