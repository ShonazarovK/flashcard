import 'package:flutter/material.dart';
import 'package:ownproject/constants/responsivness.dart';
import '../../../constants/colors.dart';

class VocabularyGrowthCard extends StatefulWidget {
  const VocabularyGrowthCard({super.key});

  @override
  State<VocabularyGrowthCard> createState() => _VocabularyGrowthCardState();
}

class _VocabularyGrowthCardState extends State<VocabularyGrowthCard> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    final List<int> learnedWords = [10, 120, 280, 90, 350];

    int getMaxY(List<int> data) {
      final maxVal = data.reduce((a, b) => a > b ? a : b);
      return ((maxVal / 100).ceil()) * 100;
    }

    final maxY = getMaxY(learnedWords);

    List<int> generateYAxis(int maxY) {
      final step = (maxY / 4).ceil();
      return [step * 4, step * 3, step * 2, step, 0];
    }

    final yLabels = generateYAxis(maxY);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(r.wp(0.05)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Text(
                "Vocabulary Growth",
                style: TextStyle(
                  fontSize: r.text(18),
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              const Spacer(),
              Icon(Icons.more_vert,
                  color: AppColors.titleGray, size: r.text(24)),
            ],
          ),

          SizedBox(height: r.hp(0.004)),

          Text(
            "Last • 13/11/24",
            style: TextStyle(
              fontSize: r.text(12),
              color: AppColors.titleGray,
            ),
          ),

          SizedBox(height: r.hp(0.04)),

          /// CHART
          SizedBox(
            height: 120,
            child: Row(
              children: [

                /// Y axis
                SizedBox(
                  width: r.wp(.08),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:
                    yLabels.map((e) => _YAxisLabel(e.toString())).toList(),
                  ),
                ),

                /// GRAPH
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final step = width / (learnedWords.length - 1);

                      return GestureDetector(
                        onPanUpdate: (details) {
                          final dx = details.localPosition.dx;

                          setState(() {
                            selectedIndex =
                                (dx / step).round().clamp(0, learnedWords.length - 1);
                          });
                        },
                        onPanEnd: (_) {
                          setState(() => selectedIndex = null);
                        },
                        child: CustomPaint(
                          painter: _ChartPainter(
                            learnedWords,
                            maxY,
                            selectedIndex,
                          ),
                          size: Size.infinite,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: r.hp(0.010)),

          Padding(
            padding: EdgeInsets.only(left: r.wp(0.09)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _XAxisLabel("25.10"),
                _XAxisLabel("26.10"),
                _XAxisLabel("27.10"),
                _XAxisLabel("28.10"),
                _XAxisLabel("29.10"),
                _XAxisLabel("30.10"),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _YAxisLabel extends StatelessWidget {
  final String text;
  const _YAxisLabel(this.text);

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Text(
      text,
      style: TextStyle(
        fontSize: r.text(10),
        color: AppColors.titleGray.withOpacity(.7),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _XAxisLabel extends StatelessWidget {
  final String text;
  const _XAxisLabel(this.text);

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Text(
      text,
      style: TextStyle(
        fontSize: r.text(10),
        color: AppColors.titleGray.withOpacity(.7),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<int> data;
  final int maxY;
  final int? selectedIndex;

  _ChartPainter(this.data, this.maxY, this.selectedIndex);

  @override
  void paint(Canvas canvas, Size size) {
    final dxStep = size.width / (data.length - 1);

    final points = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = dxStep * i;
      final normalized = data[i] / maxY;
      final y = size.height - (normalized * size.height);
      points.add(Offset(x, y));
    }

    final linePaint = Paint()
      ..color = const Color(0xFF7B61FF)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0x407B61FF),
          Color(0x007B61FF),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final current = points[i];
      final midX = (prev.dx + current.dx) / 2;

      path.cubicTo(midX, prev.dy, midX, current.dy, current.dx, current.dy);
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    final dotStroke = Paint()
      ..color = const Color(0xFF7B61FF)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final dotFill = Paint()..color = Colors.white;

    final tooltipPaint = Paint()..color = const Color(0xFF7B61FF);

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < points.length; i++) {
      final p = points[i];

      canvas.drawCircle(p, 5, dotFill);
      canvas.drawCircle(p, 5, dotStroke);

      /// 🔥 SELECTED
      if (selectedIndex == i) {

        /// vertical line
        canvas.drawLine(
          Offset(p.dx, 0),
          Offset(p.dx, size.height),
          Paint()
            ..color = const Color(0xFF7B61FF).withOpacity(.2)
            ..strokeWidth = 1,
        );

        /// tooltip box
        final rect = RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(p.dx, p.dy - 25),
            width: 40,
            height: 20,
          ),
          const Radius.circular(6),
        );

        canvas.drawRRect(rect, tooltipPaint);

        /// text
        textPainter.text = TextSpan(
          text: data[i].toString(),
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        );

        textPainter.layout();

        textPainter.paint(
          canvas,
          Offset(
            p.dx - textPainter.width / 2,
            p.dy - 32,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}