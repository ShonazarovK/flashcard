import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ownproject/constants/responsivness.dart';
import '../../../constants/colors.dart';

class HomeBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onAdd;

  const HomeBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAdd,
  });

  void _handleNavigation(BuildContext context, int index) {
    onTap(index);

    switch (index) {
      case 0:
        context.push('/');
        break;
      case 1:
        context.push('/stats');
        break;
      case 2:
        context.push('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return BottomAppBar(
      color: AppColors.white,
      elevation: 12,
      shape: const CircularNotchedRectangle(),
      notchMargin: r.text(8),
      child: SizedBox(
        height: r.adaptive(
          mobile: 64,
          tablet: 72,
          desktop: 80,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: r.wp(0.06)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              /// HOME
              _BottomItem(
                svg: 'assets/icons/li_home.svg',
                label: "Home",
                active: currentIndex == 0,
                onTap: () => _handleNavigation(context, 0),
              ),

              /// STATISTICS
              _BottomItem(
                svg: 'assets/icons/statistics.svg',
                label: "Statistics",
                active: currentIndex == 1,
                onTap: () => _handleNavigation(context, 1),
              ),

              /// SETTINGS
              _BottomItem(
                svg: 'assets/icons/settings.svg',
                label: "Settings",
                active: currentIndex == 2,
                onTap: () => _handleNavigation(context, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}







class _BottomItem extends StatelessWidget {
  final String svg;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _BottomItem({
    required this.svg,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    final color = active
        ? AppColors.collection
        : AppColors.black;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: r.text(6),
          horizontal: r.text(4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// SVG ICON
            SvgPicture.asset(
              svg,
              width: r.adaptive(
                mobile: 22,
                tablet: 26,
                desktop: 30,
              ),
              height: r.adaptive(
                mobile: 22,
                tablet: 26,
                desktop: 30,
              ),
              colorFilter: ColorFilter.mode(
                color,
                BlendMode.srcIn,
              ),
            ),

            SizedBox(height: r.text(4)),

            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: r.adaptive(
                  mobile: 11,
                  tablet: 13,
                  desktop: 14,
                ),
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}