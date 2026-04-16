import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:ownproject/constants/responsivness.dart';

import '../../../constants/colors.dart';

class StudyStatsRow extends StatelessWidget {
  const StudyStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: "Avg. Time",
            value: "2.4h",
          ),
        ),

        SizedBox(width: r.wp(.04)),

        Expanded(
          child: _StatCard(
            title: "Time Spent",
            value: "42h",
          ),
        ),
      ],
    );
  }
}
class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Container(
      height: r.hp(.13),
      padding: EdgeInsets.symmetric(
        horizontal: r.wp(.05),
        vertical: r.hp(.02),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          /// title
          Text(
            title,
            style: TextStyle(
              fontSize: r.text(12),
              color: AppColors.gray,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: r.hp(.01)),

          /// value
          Text(
            value,
            style: TextStyle(
              fontSize: r.text(26),
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}