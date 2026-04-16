import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ownproject/features/onboard/wg/login_wg.dart';
import '../../constants/responsivness.dart';
import '../../constants/colors.dart';



class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: r.wp(0.06)),
          child: Column(
            children: [

              SizedBox(height: r.hp(0.02)),

              /// 🔥 HEADER
              Container(
                height: r.hp(0.30),
                child: Stack(
                  children: [

                    /// 🐱 CENTER IMAGE (KATTA)
                    Align(
                      alignment: Alignment(-0.1, 0),
                      child: Container(
                        width: r.wp(0.42),
                        height: r.wp(0.4),
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/icons/cat1.png",
                          width: r.wp(0.42),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    /// 🔥 LEFT ICONS

                    Positioned(
                      left: r.wp(0.02),
                      top: r.hp(0.04),
                      child: _circleIcon("assets/icons/icon_camera.svg", r),
                    ),

                    Positioned(
                      left: r.wp(0.1),
                      top: r.hp(0.07),
                      child: _circleIcon("assets/icons/icon_cube.svg", r),
                    ),

                    Positioned(
                      left: r.wp(0.02),
                      top: r.hp(0.1),
                      child: _circleIcon("assets/icons/icon_play.svg", r),
                    ),

                    Positioned(
                      left: r.wp(0.11),
                      top: r.hp(0.125),
                      child: _circleIcon("assets/icons/icon_chat.svg", r),
                    ),

                    Positioned(
                      left: r.wp(0.025),
                      top: r.hp(0.16),
                      child: _circleIcon("assets/icons/icon_book.svg", r),
                    ),

                    /// TEXTS

                    Positioned(
                      right: r.wp(0.2),
                      top: r.hp(0.05),
                      child: const Text(
                        "本",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
                      ),
                    ),

                    Positioned(
                      right: r.wp(0.005),
                      top: r.hp(0.06),
                      child: Transform.rotate(
                        angle: -0.3,
                        child: const Text(
                          "Selamat pagi",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),

                    Positioned(
                      right: r.wp(0.01),
                      top: r.hp(0.080),
                      child: Transform.rotate(
                        angle: -0.15,
                        child: const Text(
                          "Alegre",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),

                    Positioned(
                      right: r.wp(0.1),
                      top: r.hp(0.115),
                      child: const Text(
                        "नमस्ते",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                      ),
                    ),

                    Positioned(
                      right: r.wp(0.01),
                      top: r.hp(0.145),
                      child: Transform.rotate(
                        angle: -0.2,
                        child: const Text(
                          "N’arrêtez pas.",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: r.hp(0.0)),

              /// 🔥 CARDS
              _card(r, "Learn", "学ぶ", r.wp(0.68)),
              SizedBox(height: r.hp(0.012)),

              _card(r, "Anything", "Cualquier cosa", r.wp(0.8)),
              SizedBox(height: r.hp(0.012)),

              _card(r, "Anywhere", "N'importe où", r.wp(0.76)),

              SizedBox(height: r.hp(0.06)),

              SizedBox(
                width: r.wp(0.8),
                child: Text(
                  "Capture words from movies, podcast audio,\n"
                      "or photos. We transform raw content into\n"
                      "structured lessons and quizzes.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: r.text(14),
                    color: AppColors.textGray,
                    height: 1.8,
                  ),
                ),
              ),

              SizedBox(height: r.hp(0.04)),

              /// BUTTON
              GestureDetector(
                onTap: () {
                  context.push('/chooseLanguage');
                },
                child: Container(
                  width: r.wp(0.48),
                  height: r.hp(0.065),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF7B7FEF),
                        Color(0xFF8376EC),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Get started",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: r.text(15),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: r.hp(0.03)),

              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (_) => const AuthBottomSheet(),
                  );
                },
                child: Text(
                  "Log in",
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: r.text(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 ICON
  Widget _circleIcon(String path, Responsive r) {
    return Container(
      width: r.wp(0.11),
      height: r.wp(0.11),
      padding: const EdgeInsets.all(8),
      child: SvgPicture.asset(
        path,
        color: AppColors.primary,
      ),
    );
  }

  /// 🔥 CARD
  Widget _card(Responsive r, String left, String right, double width) {
    return Center(
      child: Container(
        width: width,
        height: r.hp(0.082),
        padding: EdgeInsets.symmetric(horizontal: r.wp(0.045)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: [

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("INPUT",
                    style: TextStyle(
                        fontSize: r.text(11),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textGray)),
                SizedBox(height: r.hp(0.004)),
                Text(left,
                    style: TextStyle(
                        fontSize: r.text(15),
                        fontWeight: FontWeight.w600)),
              ],
            ),

            Expanded(
              child: Center(
                child: Container(
                  width: r.wp(0.11),
                  height: r.wp(0.11),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8E9FF),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/icons/star.svg",
                      width: r.wp(0.055),
                      height: r.wp(0.055),
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("DEFINED",
                    style: TextStyle(
                        fontSize: r.text(11),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textGray)),
                SizedBox(height: r.hp(0.004)),
                Text(
                  right,
                  style: TextStyle(
                    fontSize: r.text(15),
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}