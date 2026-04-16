import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ownproject/constants/colors.dart';
import 'package:ownproject/constants/responsivness.dart';
import 'package:ownproject/constants/text.dart';

class ExerciseHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  final int tab;
  final ValueChanged<int> onTabChanged;

  final VoidCallback onBack;
  final VoidCallback onInfo;

  const ExerciseHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tab,
    required this.onTabChanged,
    required this.onBack,
    required this.onInfo,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // =========================
        // TOP BAR
        // =========================
        Row(
          children: [
            _CircleIconButton(
              icon: Icons.arrow_back_rounded,
              onTap: onBack,
            ),
            const Spacer(),
            const _PillMiniLabel(text: "AI EXERCISE LAB"),
            const Spacer(),
            _CircleIconButton(
              icon: Icons.info_outline_rounded,
              onTap: onInfo,
            ),
          ],
        ),

        SizedBox(height: r.hp(0.03)),

        // =========================
        // TITLE
        // =========================
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: r.text(28),
            fontWeight: FontWeight.w900,
            color: AppColors.black.withOpacity(0.88),
            height: 1.1,
          ),
        ),
        SizedBox(height: r.hp(0.008)),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: r.text(13),
            fontWeight: AppText.subtitleRegular.fontWeight,
            color: AppColors.titleGray.withOpacity(0.6),
            height: 1.4,
          ),
        ),

        SizedBox(height: r.hp(0.02)),

        // =========================
        // SEGMENTED
        // =========================
        _Segmented(
          left: "Write Yourself",
          right: "AI Generate",
          value: tab,
          onChanged: onTabChanged,
        ),
      ],
    );
  }
}

// =========================
// UI helpers (private)
// =========================

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final size = r.adaptive(mobile: 40.0, tablet: 44.0, desktop: 46.0);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.black.withOpacity(0.04),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: r.text(22),
          color: AppColors.black.withOpacity(0.80),
        ),
      ),
    );
  }
}

class _PillMiniLabel extends StatelessWidget {
  final String text;
  const _PillMiniLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.wp(0.03),
        vertical: r.hp(0.007),
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
      //   borderRadius: BorderRadius.circular(999),
      //   border: Border.all(
      //     color: AppColors.barGray.withOpacity(0.9),
      //     width: 1,
      //   ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome_outlined,
            size: r.text(14),
            color: AppColors.primary,
          ),
          SizedBox(width: r.wp(0.012)),
          Text(
            text,
            style: TextStyle(
              fontSize: r.text(14),
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Segmented extends StatelessWidget {
  final String left;
  final String right;
  final int value;
  final ValueChanged<int> onChanged;

  const _Segmented({
    required this.left,
    required this.right,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    final h = r.adaptive(mobile: 44.0, tablet: 48.0, desktop: 50.0);
    final radius = r.adaptive(mobile: 14.0, tablet: 16.0, desktop: 18.0);

    return Container(
      height: h,
      width: double.infinity,
      padding: EdgeInsets.all(r.wp(0.01)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: AppColors.barGray.withOpacity(0.9),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegBtn(
              text: left,
              active: value == 0,
              onTap: () {
                onChanged(0);
                context.go('/ai');
              },
            ),
          ),
          SizedBox(width: r.wp(0.015)),
          Expanded(
            child: _SegBtn(
              text: right,
              active: value == 1,
              onTap: () {
                onChanged(1);
                context.go('/next');
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SegBtn extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const _SegBtn({
    required this.text,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.black.withOpacity(0.06) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: active
              ? Border.all(
            color: AppColors.barGray.withOpacity(0.9),
            width: 1,
          )
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: r.text(12.5),
            fontWeight: FontWeight.w800,
            color: AppColors.black.withOpacity(active ? 0.88 : 0.55),
          ),
        ),
      ),
    );
  }
}