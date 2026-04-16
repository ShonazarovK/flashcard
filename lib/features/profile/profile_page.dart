import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../constants/colors.dart';
import '../../../constants/responsivness.dart';
import '../../../constants/text.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  File? image;

  Future pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    setState(() {
      image = File(picked.path);
    });
  }

  @override
  Widget build(BuildContext context) {

    final r = context.r;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: r.wp(.05)),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: r.hp(.00)),

              /// PROFILE CARD
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: r.hp(.01)),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: r.wp(.05)),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: r.wp(.00)),
                          child: Text(
                            "profile".tr(), // 🔥
                            style: AppText.appBarSemiBold.copyWith(
                              fontSize: r.text(20),
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// AVATAR
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        width: r.wp(.30),
                        height: r.wp(.30),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.gray.withOpacity(0.1),
                        ),
                        child: ClipOval(
                          child: image != null
                              ? Image.file(
                            image!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                              :
                          SvgPicture.asset(
                            'assets/icons/profile.svg',
                            width: r.text(15),
                            height: r.text(15),
                            colorFilter: ColorFilter.mode(
                              AppColors.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: r.hp(.02)),

                    /// NAME
                    Text(
                      "Andrew Ainsley",
                      style: AppText.cardTitleSemiBold.copyWith(
                        fontSize: r.text(20),
                        color: AppColors.black,
                      ),
                    ),

                    SizedBox(height: r.hp(.01)),

                    /// BADGE
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.wp(.04),
                        vertical: r.hp(.006),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/level_profile.svg',
                            width: r.text(16),
                            height: r.text(16),
                            colorFilter: ColorFilter.mode(
                              AppColors.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(width: r.wp(.01)),
                          Text(
                            "intermediate".tr(), // 🔥
                            style: TextStyle(
                              fontSize: r.text(14),
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: r.hp(.02)),

              /// SETTINGS CARD
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [

                    ProfileTile(
                      icon: Icons.person_outline,
                      title: "personal_details".tr(), // 🔥
                      onTap: () {},
                    ),

                    ProfileTile(
                      icon: Icons.language,
                      title: "language".tr(), // 🔥
                      trailing: Text(
                        "English (US)",
                        style: TextStyle(
                          fontSize: r.text(15),
                        ),
                      ),
                      onTap: () {
                        context.push('/language');
                      },
                    ),

                    ProfileSwitchTile(
                      icon: Icons.dark_mode_outlined,
                      title: "dark_mode".tr(), // 🔥
                    ),
                  ],
                ),
              ),

              SizedBox(height: r.hp(.02)),

              /// PRIVACY CARD
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [

                    ProfileTile(
                      icon: Icons.lock_outline,
                      title: "privacy_policy".tr(), // 🔥
                      onTap: () {},
                    ),

                    ProfileTile(
                      icon: Icons.description_outlined,
                      title: "terms".tr(), // 🔥
                      onTap: () {},
                    ),

                    ProfileTile(
                      icon: Icons.mail_outline,
                      title: "support_email".tr(), // 🔥
                      onTap: () {},
                    ),

                    ProfileTile(
                      icon: Icons.person_remove_outlined,
                      title: "delete_account".tr(), // 🔥
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              SizedBox(height: r.hp(.02)),

              /// LOGOUT
              Container(
                height: r.hp(.06),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.red,
                      size: r.text(20),
                    ),
                    SizedBox(width: r.wp(.02)),
                    Text(
                      "logout".tr(), // 🔥
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: r.text(15),
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(height: r.hp(.02)),

              Center(
                child: Text(
                  "version".tr(), // 🔥
                  style: TextStyle(
                    fontSize: r.text(12),
                    color: AppColors.textGray,
                  ),
                ),
              ),

              SizedBox(height: r.hp(.03)),
            ],
          ),
        ),
      ),
    );
  }
}


class ProfileTile extends StatelessWidget {

  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;

  const ProfileTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {

    final r = context.r;

    return ListTile(
      leading: Icon(icon, size: r.text(20),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: r.text(16),
          fontWeight: FontWeight.w500,
        ),

      ),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}




class ProfileSwitchTile extends StatefulWidget {

  final IconData icon;
  final String title;

  const ProfileSwitchTile({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  State<ProfileSwitchTile> createState() => _ProfileSwitchTileState();
}

class _ProfileSwitchTileState extends State<ProfileSwitchTile> {

  bool value = false;

  @override
  Widget build(BuildContext context) {

    final r = context.r;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.wp(.04)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Row(
            children: [
              Icon(widget.icon, size: r.text(20)),
              SizedBox(width: r.wp(.03)),
              Text(
                widget.title,
                style: TextStyle(fontSize: r.text(16),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              activeColor: AppColors.primary,
              activeTrackColor: AppColors.primary.withOpacity(0.4),
              onChanged: (v) {
                setState(() {
                  value = v;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}