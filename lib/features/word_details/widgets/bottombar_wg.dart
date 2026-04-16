import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ownproject/constants/responsivness.dart';
import 'package:ownproject/constants/text.dart';
import '../../../constants/colors.dart';


class WordProgressBar extends StatelessWidget {
  final int currentStep;
  final VoidCallback? onForget;
  final VoidCallback? onSave;
  final ValueChanged<int>? onStepTap;

  const WordProgressBar({
    super.key,
    required this.currentStep,
    this.onForget,
    this.onSave,
    this.onStepTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    final sideSize = r.adaptive(mobile: 48.0, tablet: 52.0, desktop: 54.0);
    final stepSize = r.adaptive(mobile: 48.0, tablet: 52.0, desktop: 54.0);
    final gap = r.adaptive(mobile: 12.0, tablet: 14.0, desktop: 16.0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: sideSize,
          child: _ActionIconWithLabel(
            svgAsset: 'assets/icons/forget.svg',
            label: "FORGET",
            accent: AppColors.titleGray.withOpacity(0.65),
            onTap: onForget,
            size: sideSize,
          ),
        ),

        SizedBox(width: gap),

        Expanded(
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StepPill(
                  step: 1,
                  size: stepSize,
                  isActive: currentStep == 1,
                  onTap: () => onStepTap?.call(1),
                ),
                SizedBox(width: r.wp(0.02)),
                _StepPill(
                  step: 2,
                  size: stepSize,
                  isActive: currentStep == 2,
                  onTap: () => onStepTap?.call(2),
                ),
                SizedBox(width: r.wp(0.02)),
                _StepPill(
                  step: 3,
                  size: stepSize,
                  isActive: currentStep == 3,
                  onTap: () => onStepTap?.call(3),
                ),
                SizedBox(width: r.wp(0.02)),
                _StepPill(
                  step: 4,
                  size: stepSize,
                  isActive: currentStep == 4,
                  onTap: () => onStepTap?.call(4),
                ),
              ],
            ),
          ),
        ),

        SizedBox(width: gap),

        SizedBox(
          width: sideSize,
          child: _ActionIconWithLabel(
            svgAsset: 'assets/icons/check.svg',
            label: "SAVE",
            accent: AppColors.primary,
            onTap: onSave,
            size: sideSize,
          ),
        ),
      ],
    );
  }
}


class _ActionIconWithLabel extends StatelessWidget {
  final String svgAsset;
  final String label;
  final Color accent;
  final VoidCallback? onTap;
  final double size;

  const _ActionIconWithLabel({
    required this.svgAsset,
    required this.label,
    required this.accent,
    required this.onTap,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.barGray.withOpacity(0.9),
                width: 1,
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                svgAsset,
                width: r.text(22),
                height: r.text(22),
                colorFilter: ColorFilter.mode(
                  accent,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          SizedBox(
            height: r.adaptive(
              mobile: 6.0,
              tablet: 7.0,
              desktop: 8.0,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: r.text(11),
              fontWeight: AppText.appBarBadgeBold.fontWeight,
              letterSpacing: 0.5,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepPill extends StatelessWidget {
  final int step;
  final bool isActive;
  final VoidCallback? onTap;
  final double size;

  const _StepPill({
    required this.step,
    required this.isActive,
    required this.size,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    final bg = isActive
        ? AppColors.primary.withOpacity(0.85)
        : AppColors.barGray.withOpacity(0.55);

    final fg =
    isActive ? AppColors.white : AppColors.titleGray.withOpacity(0.75);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          "$step",
          style: TextStyle(
            fontSize: r.text(18),
            fontWeight: FontWeight.w800,
            color: fg,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}