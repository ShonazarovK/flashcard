import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

/// Fullscreen overlay: dim background + scan frame + moving scan line + text.
class AnalyzingOverlay extends StatefulWidget {
  final String title;
  final EdgeInsets padding;
  final BorderRadius borderRadius;

  /// If you already have a crop rect on screen, you can wrap this overlay in a Stack
  /// and position it yourself. This version centers a scan frame automatically.
  const AnalyzingOverlay({
    super.key,
    this.title = "Analyzing",
    this.padding = const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
  });

  @override
  State<AnalyzingOverlay> createState() => _AnalyzingOverlayState();
}

class _AnalyzingOverlayState extends State<AnalyzingOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _t;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1300));
    _t = CurvedAnimation(parent: _c, curve: Curves.easeInOut);
    _c.repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: false,
      child: AnimatedBuilder(
        animation: _t,
        builder: (context, _) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Slight blur + dark overlay (feels premium instead of "bizarre")
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(color: Colors.black.withOpacity(0.45)),
              ),

              // Scan frame + scan line
              Center(
                child: LayoutBuilder(
                  builder: (context, c) {
                    // frame size: like OCR scan box (tweak if you want)
                    final w = min(c.maxWidth - widget.padding.horizontal, 360.0);
                    final h = min(c.maxHeight * 0.46, 420.0);

                    return CustomPaint(
                      size: Size(w, h),
                      painter: _ScanPainter(
                        t: _t.value,
                        r: widget.borderRadius,
                      ),
                    );
                  },
                ),
              ),

              // Text + dots
              Positioned(
                left: 0,
                right: 0,
                bottom: 80,
                child: _AnalyzingText(title: widget.title, t: _t.value),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AnalyzingText extends StatelessWidget {
  final String title;
  final double t;
  const _AnalyzingText({required this.title, required this.t});

  @override
  Widget build(BuildContext context) {
    // 0..3 dots
    final dots = ((t * 3.999).floor()).clamp(0, 3);
    final dotStr = "." * dots;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "$title$dotStr",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 160,
          height: 3,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Align(
            alignment: Alignment(-1 + (t * 2), 0),
            child: Container(
              width: 54,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.75),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ScanPainter extends CustomPainter {
  final double t; // 0..1
  final BorderRadius r;

  _ScanPainter({required this.t, required this.r});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rr = r.toRRect(rect);

    // frame border (subtle pulse)
    final pulse = 0.6 + 0.4 * sin(t * pi);
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white.withOpacity(0.65 * pulse);

    // outer glow
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..color = Colors.white.withOpacity(0.06 * pulse)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawRRect(rr, glowPaint);
    canvas.drawRRect(rr, borderPaint);

    // corner ticks (like scanner)
    final tickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withOpacity(0.85);

    const corner = 22.0;
    void cornerL(Offset o, bool right, bool down) {
      final dx = right ? corner : -corner;
      final dy = down ? corner : -corner;
      canvas.drawLine(o, o.translate(dx, 0), tickPaint);
      canvas.drawLine(o, o.translate(0, dy), tickPaint);
    }

    cornerL(rr.outerRect.topLeft.translate(12, 12), true, true);
    cornerL(rr.outerRect.topRight.translate(-12, 12), false, true);
    cornerL(rr.outerRect.bottomLeft.translate(12, -12), true, false);
    cornerL(rr.outerRect.bottomRight.translate(-12, -12), false, false);

    // scan line (moves top -> bottom -> top because controller repeats reverse)
    final y = lerpDouble(rr.top + 18, rr.bottom - 18, t)!;

    final linePaint = Paint()
      ..strokeWidth = 2.2
      ..color = Colors.white.withOpacity(0.9)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    final glowLinePaint = Paint()
      ..strokeWidth = 16
      ..color = Colors.white.withOpacity(0.12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    // clip to frame area so line doesn't go outside
    canvas.save();
    canvas.clipRRect(rr.deflate(6));
    canvas.drawLine(Offset(rr.left + 14, y), Offset(rr.right - 14, y), glowLinePaint);
    canvas.drawLine(Offset(rr.left + 14, y), Offset(rr.right - 14, y), linePaint);

    // subtle "scan band"
    final bandH = 46.0;
    final bandRect = Rect.fromLTWH(rr.left, y - bandH / 2, rr.width, bandH);
    final bandPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withOpacity(0.00),
          Colors.white.withOpacity(0.08),
          Colors.white.withOpacity(0.00),
        ],
      ).createShader(bandRect);

    canvas.drawRect(bandRect, bandPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ScanPainter oldDelegate) {
    return oldDelegate.t != t || oldDelegate.r != r;
  }
}