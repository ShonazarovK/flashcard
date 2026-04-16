import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ownproject/constants/responsivness.dart';

import '../../../constants/colors.dart';

class ProgressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(r.wp(0.05)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER
          Row(
            children: [
              SvgPicture.asset(
              "assets/icons/progress.svg",
              width: r.text(24),
              height: r.text(24),

            ),

              SizedBox(width: r.wp(0.01)),

              Text(
                "Progress",
                style: TextStyle(
                  fontSize: r.text(26),
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),

              const Spacer(),

              Icon(
                Icons.more_vert,
                size: r.text(24),
                color: AppColors.titleGray,
              ),
            ],
          ),

          SizedBox(height: r.hp(0.008)),

          /// STREAK
          Text(
            "Streak 14",
            style: TextStyle(
              fontSize: r.text(12),
              color: AppColors.titleGray.withOpacity(.7),
            ),
          ),

          SizedBox(height: r.hp(0.004)),

          /// MONTH LABELS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _Month("JAN"),
              _Month("FEB"),
              _Month("MAR"),
              _Month("APR"),
              _Month("MAY"),
            ],
          ),

          SizedBox(height: r.hp(0.012)),

          /// HEATMAP GRID
           _HeatmapGrid(),
        ],
      ),
    );
  }
}



class _Month extends StatelessWidget {
  final String text;

  const _Month(this.text);

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Text(
      text,
      style: TextStyle(
        fontSize: r.text(12),
        fontWeight: FontWeight.w700,
        color: AppColors.titleGray.withOpacity(.6),
      ),
    );
  }
}



class _HeatmapGrid extends StatelessWidget {
  const _HeatmapGrid();

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    const columns = 18;
    const rows = 7;

    /// SVG pattern converted
    const values = [
      0,0,1,0,0,1,0,
      0,1,2,0,1,0,1,
      1,0,0,1,0,2,0,
      0,0,1,2,1,0,0,
      1,0,2,3,1,1,0,
      0,2,0,1,0,0,2,
      1,0,1,2,3,2,1,
      0,0,0,1,1,1,0,
      1,1,2,3,2,1,1,
      1,3,2,1,1,0,0,
      0,1,1,1,0,0,1,
      3,2,1,2,3,2,1,
      2,3,3,2,1,1,1,
      0,1,1,3,2,0,0,
      1,1,2,3,3,2,1,
      1,2,3,3,2,1,1,
      0,1,2,1,1,0,0,
      2,3,3,2,1,1,0,
    ];

    Color color(int v) {
      switch (v) {
        case 1:
          return const Color(0xFF7B7FEF).withOpacity(.4);
        case 2:
          return const Color(0xFF7B7FEF).withOpacity(.8);
        case 3:
          return const Color(0xFF7B7FEF);
        default:
          return const Color(0xFFF3F4F6);
      }
    }

    return SizedBox(
      height: r.hp(0.12),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: columns * rows,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: r.wp(0.014),
          crossAxisSpacing: r.wp(0.012),
        ),
        itemBuilder: (_, i) {
          return Container(
            decoration: BoxDecoration(
              color: color(values[i]),
              borderRadius: BorderRadius.circular(3),
            ),
          );
        },
      ),
    );
  }
}