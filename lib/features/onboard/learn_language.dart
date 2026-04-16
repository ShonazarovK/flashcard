// import 'package:flutter/material.dart';
// import 'package:ownproject/constants/responsivness.dart';
// import 'package:ownproject/features/onboard/wg/indicator.dart';
// import '../../constants/colors.dart';
//
//
// class LearnLanguagePage extends StatefulWidget {
//   const LearnLanguagePage({super.key});
//
//   @override
//   State<LearnLanguagePage> createState() => _LearnLanguagePageState();
// }
//
// class _LearnLanguagePageState extends State<LearnLanguagePage> {
//   String selected = "Spain";
//
//   final List<Map<String, String>> languages = [
//     {"name": "English", "flag": "🇬🇧"},
//     {"name": "Spain", "flag": "🇪🇸"},
//     {"name": "French", "flag": "🇫🇷"},
//     {"name": "German", "flag": "🇩🇪"},
//     {"name": "Japanies", "flag": "🇯🇵"},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     final r = context.r;
//
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: r.wp(0.06)),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//               SizedBox(height: r.hp(0.01)),
//
//               /// 🔥 TOP INDICATOR
//               TopProgressIndicator(
//                 progress: 0.3,
//                 onBack: () => Navigator.pop(context),
//               ),
//
//               SizedBox(height: r.hp(0.03)),
//
//               /// TITLE
//               Text(
//                 "What would you like\nto learn",
//                 style: TextStyle(
//                   fontSize: r.text(28),
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.black,
//                   height: 1.2,
//                 ),
//               ),
//
//               SizedBox(height: r.hp(0.015)),
//
//               /// SUBTITLE
//               Text(
//                 "Choose all that apply and we’ll help you\nfind your match.",
//                 style: TextStyle(
//                   fontSize: r.text(14),
//                   color: AppColors.textGray,
//                   height: 1.4,
//                 ),
//               ),
//
//               SizedBox(height: r.hp(0.03)),
//
//               /// LIST
//               Expanded(
//                 child: Column(
//                   children: List.generate(languages.length, (index) {
//                     final item = languages[index];
//                     final isSelected = selected == item["name"];
//
//                     return Padding(
//                       padding: EdgeInsets.only(bottom: r.hp(0.015)),
//                       child: GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             selected = item["name"]!;
//                           });
//                         },
//                         child: Container(
//                           height: r.hp(0.075),
//                           padding: EdgeInsets.symmetric(
//                             horizontal: r.wp(0.04),
//                           ),
//                           decoration: BoxDecoration(
//                             color: isSelected
//                                 ? const Color(0xFFE8E9FF) // 🔥 selected background
//                                 : const Color(0xFFEDEDF5),
//                             borderRadius: BorderRadius.circular(14),
//                             border: isSelected
//                                 ? Border.all(
//                               color: AppColors.primary,
//                               width: 1.5,
//                             )
//                                 : null,
//                           ),
//                           child: Row(
//                             children: [
//
//                               /// FLAG
//                               Text(
//                                 item["flag"]!,
//                                 style: TextStyle(fontSize: r.text(22)),
//                               ),
//
//                               SizedBox(width: r.wp(0.03)),
//
//                               /// NAME
//                               Expanded(
//                                 child: Text(
//                                   item["name"]!,
//                                   style: TextStyle(
//                                     fontSize: r.text(16),
//                                     fontWeight: FontWeight.w500,
//                                     color: AppColors.black,
//                                   ),
//                                 ),
//                               ),
//
//                               /// CHECK
//                               if (isSelected)
//                                 Icon(
//                                   Icons.check,
//                                   color: AppColors.primary,
//                                   size: r.text(22),
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//
//               SizedBox(height: r.hp(0.02)),
//
//               /// BUTTON
//               Center(
//                 child: Container(
//                   width: r.wp(0.45),
//                   height: r.hp(0.065),
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [
//                         Color(0xFF7B7FEF),
//                         Color(0xFF8376EC),
//                       ],
//                     ),
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   alignment: Alignment.center,
//                   child: Text(
//                     "Continue",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: r.text(16),
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: r.hp(0.03)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }