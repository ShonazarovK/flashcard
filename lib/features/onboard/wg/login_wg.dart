import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ownproject/constants/responsivness.dart';
import '../../../constants/colors.dart';

class AuthBottomSheet extends StatelessWidget {
  const AuthBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Container(
      padding: EdgeInsets.only(
        top: r.hp(0.04),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [

          /// 🔥 MAIN SHEET
          Container(
            margin: EdgeInsets.only(top: r.hp(0.04)),
            padding: EdgeInsets.symmetric(
              horizontal: r.wp(0.06),
              vertical: r.hp(0.025),
            ),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                SizedBox(height: r.hp(0.02)),

                /// EMAIL
                _button(
                  r,
                  text: "Sign in with Email",
                  icon: Icons.email_outlined,
                  isOutlined: true,
                  onTap: () {
                    context.push('/email-login'); // 🔥 route qilasan
                  },
                ),

                SizedBox(height: r.hp(0.015)),

                /// GOOGLE
                _button(
                  r,
                  text: "Sign In with Google",
                  asset: "assets/icons/google.png",
                  onTap: () async {
                    // 🔥 vaqtinchalik (keyin firebase ulaymiz)
                    print("Google login bosildi");

                    context.go('/'); // test uchun
                  },
                ),

                SizedBox(height: r.hp(0.015)),

                /// APPLE
                _button(
                  r,
                  text: "Sign In with Apple",
                  icon: Icons.apple,
                  isDark: true,
                  onTap: () {
                    print("Apple login bosildi");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 BUTTON
  Widget _button(
      Responsive r, {
        required String text,
        IconData? icon,
        String? asset,
        bool isDark = false,
        bool isOutlined = false,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: r.hp(0.065),
        padding: EdgeInsets.symmetric(horizontal: r.wp(0.04)),
        decoration: BoxDecoration(
          color: isDark ? AppColors.black : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: isOutlined
              ? Border.all(color: AppColors.barGray)
              : null,
          boxShadow: isDark
              ? []
              : [
            BoxShadow(
              color: Colors.black.withOpacity(.03),
              blurRadius: 10,
            )
          ],
        ),
        child: Row(
          children: [

            /// ICON
            if (asset != null)
              Image.asset(asset, width: 24)
            else if (icon != null)
              Icon(
                icon,
                color: isDark
                    ? AppColors.white
                    : AppColors.titleGray,
              ),

            SizedBox(width: r.wp(0.04)),

            /// TEXT
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: r.text(15),
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.white
                      : AppColors.titleGray,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}