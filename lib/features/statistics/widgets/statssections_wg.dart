import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:ownproject/constants/responsivness.dart';

import '../../../constants/colors.dart';

class StatisticsPerformanceSection extends StatelessWidget {
  const StatisticsPerformanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(r.wp(0.04)),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(.05),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// GRAPH
                SizedBox(
                  height: r.hp(0.07),
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _LineChartPainter(),
                  ),
                ),
                SizedBox(height: r.hp(0.015)),

                Text(
                  "+ 25 word\nLearned",
                  style: TextStyle(
                    fontSize: r.text(15),
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),

                SizedBox(height: r.hp(0.003)),

                Text(
                  "Daily Rates",
                  style: TextStyle(
                    fontSize: r.text(10),
                    color: AppColors.titleGray,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(width: r.wp(0.04)),

        Expanded(
          child: Container(
            padding: EdgeInsets.all(r.wp(0.04)),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(.05),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "Recall performance",
                  style: TextStyle(
                    fontSize: r.text(12),
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),

                SizedBox(height: r.hp(0.01)),

                /// BARS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,

                  children:  [
                    _Bar(30, AppColors.barGray),

                    _Bar(55, Color(0xFFFFB900)),
                    _Bar(40, Color(0xFFFFB900)),
                    _Bar(65, Color(0xFFFFB900)),
                    _Bar(45, Color(0xFFFFB900)),
                    _Bar(55, Color(0xFFFFB900)),
                  ],
                ),

                SizedBox(height: r.hp(0.004)),

                Center(
                  child: Column(
                    children: [
                      Text(
                        "89%",
                        style: TextStyle(
                          fontSize: r.text(15),
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        "Accuracy",
                        style: TextStyle(
                          fontSize: r.text(10),
                          color: AppColors.titleGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}



class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    final path = Path();

    /// MAIN CURVE
    path.moveTo(size.width * 0.01, size.height * 0.82);

    path.cubicTo(
      size.width * 0.11,
      size.height * 0.74,
      size.width * 0.19,
      size.height * 0.74,
      size.width * 0.25,
      size.height * 0.82,
    );

    path.cubicTo(
      size.width * 0.32,
      size.height * 0.90,
      size.width * 0.40,
      size.height * 0.75,
      size.width * 0.50,
      size.height * 0.50,
    );

    path.cubicTo(
      size.width * 0.60,
      size.height * 0.25,
      size.width * 0.68,
      size.height * 0.32,
      size.width * 0.75,
      size.height * 0.70,
    );

    path.cubicTo(
      size.width * 0.82,
      size.height * 1.00,
      size.width * 0.90,
      size.height * 0.90,
      size.width * 0.99,
      size.height * 0.40,
    );

    /// COPY FOR FILL
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    /// GRADIENT
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF00BC7D).withOpacity(0.30),
        const Color(0xFF00BC7D).withOpacity(0.0),
      ],
    );

    final fillPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    canvas.drawPath(fillPath, fillPaint);

    /// STROKE LINE
    final linePaint = Paint()
      ..color = const Color(0xFF00BC7D)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Bar extends StatelessWidget {
  final double height;
  final Color color;

  const _Bar(this.height, this.color);

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Container(
      width: r.wp(0.018),
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}