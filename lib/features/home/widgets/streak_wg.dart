// streak_banner.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ownproject/constants/responsivness.dart';
import '../../../constants/colors.dart';


class StreakBanner extends StatelessWidget {
  const StreakBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: r.wp(0.10)),
      padding: EdgeInsets.symmetric(
        horizontal: r.wp(0.04),
        vertical: r.hp(0.014),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          /// 🔥 ICON
          Container(
            width: r.wp(0.09),
            height: r.wp(0.09),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child:  SvgPicture.asset(
              'assets/icons/streakbar.svg',
              width: r.text(12),
              height: r.text(12),

            ),
          ),

          SizedBox(width: r.wp(0.03)),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "7 DAY STREAK",
                  style: TextStyle(
                    fontSize: r.text(11),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textGray,
                  ),
                ),
                SizedBox(height: r.hp(0.003)),
                Text(
                  "Your best 14 days",
                  style: TextStyle(
                    fontSize: r.text(15),
                    fontWeight: FontWeight.w500,
                    color: AppColors.titleGray,
                  ),
                ),
              ],
            ),
          ),

          /// VIEW
          Text(
            "View",
            style: TextStyle(
              fontSize: r.text(14),
              fontWeight: FontWeight.w600,
              color: AppColors.textGray,
            ),
          ),
        ],
      ),
    );
  }
}





class StreakBannerOverlay extends StatefulWidget {
  const StreakBannerOverlay({super.key});

  @override
  State<StreakBannerOverlay> createState() => _StreakBannerOverlayState();
}

class _StreakBannerOverlayState extends State<StreakBannerOverlay>
    with SingleTickerProviderStateMixin {

  /// 🔥 SESSION FLAG (eng muhim)
  static bool _alreadyShownThisSession = false;

  late AnimationController _controller;
  late Animation<Offset> _slide;

  bool _visible = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _checkAndShow();
  }

  void _checkAndShow() async {
    /// 🔥 agar shu sessionda allaqachon chiqgan bo‘lsa → chiqmaydi
    if (_alreadyShownThisSession) return;

    _alreadyShownThisSession = true;

    setState(() {
      _visible = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    _controller.forward();

    await Future.delayed(const Duration(seconds: 4));

    _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    if (!_visible) return const SizedBox();

    return Positioned(
      top: r.edgeTop(0),
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slide,
        child: Padding(
          padding: EdgeInsets.only(top: r.hp(0.01)),
          child: const StreakBanner(),
        ),
      ),
    );
  }
}