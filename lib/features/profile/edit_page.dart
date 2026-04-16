import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/responsivness.dart';
import '../../../constants/text.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  final TextEditingController nameController =
  TextEditingController(text: "Andrew Ainsley");

  @override
  Widget build(BuildContext context) {

    final r = context.r;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: r.wp(.05)),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: r.hp(.01)),

              /// HEADER
              Row(
                children: [

                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      size: r.text(22),
                      color: AppColors.black,
                    ),
                  ),

                  SizedBox(width: r.wp(.04)),

                  Text(
                    "Edit Profile",
                    style: AppText.Medium.copyWith(
                      fontSize: r.text(18),
                    ),
                  ),
                ],
              ),

              SizedBox(height: r.hp(.04)),

              /// INPUT FIELD
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: r.wp(.04),
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                ),

                child: TextField(
                  controller: nameController,
                  style: TextStyle(
                    fontSize: r.text(14),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Your name",
                    hintStyle: TextStyle(
                      fontSize: r.text(16),
                      color: AppColors.textGray,
                    ),
                  ),
                ),
              ),

              SizedBox(height: r.hp(.04)),

              /// UPDATE BUTTON
              GestureDetector(
                onTap: () {
                  // TODO: save logic
                },
                child: Container(
                  height: r.hp(.065),
                  width: double.infinity,
                  alignment: Alignment.center,

                  decoration: BoxDecoration(
                    gradient: AppColors.dailyPracticeGradient,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(.35),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),

                  child: Text(
                    "Update",
                    style: AppText.cardTitleSemiBold.copyWith(
                      fontSize: r.text(16),
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}