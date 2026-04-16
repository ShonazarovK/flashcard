// import 'package:flutter/material.dart';
// import 'package:ownproject/constants/colors.dart';
// import 'package:ownproject/constants/responsivness.dart';
//
// class IdentifyMeaningPage extends StatefulWidget {
//   const IdentifyMeaningPage({super.key});
//
//   @override
//   State<IdentifyMeaningPage> createState() => _IdentifyMeaningPageState();
// }
//
// class _IdentifyMeaningPageState extends State<IdentifyMeaningPage> {
//   int selectedIndex = 0; // 0..3
//   final int current = 2;
//   final int total = 5;
//
//   @override
//   Widget build(BuildContext context) {
//     final r = context.r;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F7FB),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.fromLTRB(
//             r.wp(0.06),
//             r.hp(0.016),
//             r.wp(0.06),
//             r.hp(0.02),
//           ),
//           child: Column(
//             children: [
//               // =========================
//               // TOP BAR (Priority + Streak + Close)
//               // =========================
//               TopMetaRow(
//                 onClose: () => Navigator.maybePop(context),
//               ),
//
//               SizedBox(height: r.hp(0.018)),
//
//               // =========================
//               // PROGRESS BAR
//               // =========================
//               StreakProgressBar(
//                 progress: 0.1000, // rasmga o‘xshash
//               ),
//
//               SizedBox(height: r.hp(0.03)),
//
//               // =========================
//               // QUIZ CARD
//               // =========================
//               Expanded(
//                 child: Align(
//                   alignment: Alignment.topCenter,
//                   child: IdentifyMeaningCard(
//                     stepText: "$current/$total",
//                     badgeText: "CONFIDENCE PRIMER",
//                     titleSmall: "IDENTIFY MEANING",
//                     word: "Simultaneous",
//                     options: const [
//                       "Happening at the same time",
//                       "Happening very slowly",
//                       "Extremely loud",
//                       "Very small",
//                     ],
//                     selectedIndex: selectedIndex,
//                     onSelect: (i) => setState(() => selectedIndex = i),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
// class TopMetaRow extends StatelessWidget {
//   final VoidCallback onClose;
//
//   const TopMetaRow({
//     super.key,
//     required this.onClose,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final r = context.r;
//
//     return Row(
//       children: [
//         // PRIORITY pill
//         Container(
//           padding: EdgeInsets.symmetric(
//             horizontal: r.wp(0.03),
//             vertical: r.hp(0.006),
//           ),
//           decoration: BoxDecoration(
//             color: const Color(0xFFDBF7E9), // yumshoq yashil
//             borderRadius: BorderRadius.circular(999),
//           ),
//           child: Text(
//             "PRIORITY 1",
//             style: TextStyle(
//               fontSize: r.text(11),
//               fontWeight: FontWeight.w900,
//               color: const Color(0xFF1F9D63),
//               letterSpacing: 0.4,
//             ),
//           ),
//         ),
//
//         const Spacer(),
//
//         Text(
//           "3 IN A ROW",
//           style: TextStyle(
//             fontSize: r.text(12),
//             fontWeight: FontWeight.w900,
//             color: AppColors.primary,
//             letterSpacing: 0.6,
//           ),
//         ),
//
//         const Spacer(),
//
//         InkWell(
//           onTap: onClose,
//           borderRadius: BorderRadius.circular(999),
//           child: Padding(
//             padding: EdgeInsets.all(r.wp(0.012)),
//             child: Icon(
//               Icons.close_rounded,
//               size: r.text(22),
//               color: AppColors.titleGray.withOpacity(0.7),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class StreakProgressBar extends StatelessWidget {
//   final double progress; // 0..1
//
//   const StreakProgressBar({
//     super.key,
//     required this.progress,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final r = context.r;
//
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(999),
//       child: Container(
//         height: r.adaptive(mobile: 10.0, tablet: 11.0, desktop: 12.0),
//         decoration: BoxDecoration(
//           color: AppColors.barGray.withOpacity(0.35),
//         ),
//         child: Align(
//           alignment: Alignment.centerLeft,
//           child: FractionallySizedBox(
//             widthFactor: progress.clamp(0.0, 1.0),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: AppColors.primary.withOpacity(0.75),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class IdentifyMeaningCard extends StatelessWidget {
//   final String badgeText;
//   final String stepText;
//   final String titleSmall;
//   final String word;
//   final List<String> options;
//   final int selectedIndex;
//   final ValueChanged<int> onSelect;
//
//   const IdentifyMeaningCard({
//     super.key,
//     required this.badgeText,
//     required this.stepText,
//     required this.titleSmall,
//     required this.word,
//     required this.options,
//     required this.selectedIndex,
//     required this.onSelect,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final r = context.r;
//
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.fromLTRB(
//         r.wp(0.05),
//         r.hp(0.018),
//         r.wp(0.05),
//         r.hp(0.02),
//       ),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(
//           color: AppColors.barGray.withOpacity(0.35),
//           width: 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 26,
//             offset: const Offset(0, 14),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Badge row + step
//           Row(
//             children: [
//               _Badge(text: badgeText),
//               const Spacer(),
//               Text(
//                 stepText,
//                 style: TextStyle(
//                   fontSize: r.text(12),
//                   fontWeight: FontWeight.w800,
//                   color: AppColors.titleGray.withOpacity(0.7),
//                 ),
//               ),
//             ],
//           ),
//
//           SizedBox(height: r.hp(0.02)),
//
//           Text(
//             titleSmall,
//             style: TextStyle(
//               fontSize: r.text(10.8),
//               fontWeight: FontWeight.w900,
//               letterSpacing: 1.8,
//               color: AppColors.titleGray.withOpacity(0.55),
//             ),
//           ),
//
//           SizedBox(height: r.hp(0.01)),
//
//           Text(
//             word,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: r.text(28),
//               fontWeight: FontWeight.w900,
//               color: AppColors.black.withOpacity(0.9),
//               height: 1.05,
//             ),
//           ),
//
//           SizedBox(height: r.hp(0.02)),
//
//           // options
//           Column(
//             children: List.generate(options.length, (i) {
//               final letter = String.fromCharCode(65 + i); // A B C D
//               return Padding(
//                 padding: EdgeInsets.only(bottom: i == options.length - 1 ? 0 : r.hp(0.012)),
//                 child: AnswerOptionTile(
//                   letter: "$letter)",
//                   text: options[i],
//                   selected: i == selectedIndex,
//                   onTap: () => onSelect(i),
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class AnswerOptionTile extends StatelessWidget {
//   final String letter;
//   final String text;
//   final bool selected;
//   final VoidCallback onTap;
//
//   const AnswerOptionTile({
//     super.key,
//     required this.letter,
//     required this.text,
//     required this.selected,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final r = context.r;
//
//     final bg = selected ? AppColors.primary.withOpacity(0.65) : AppColors.white;
//     final border = selected
//         ? Colors.transparent
//         : AppColors.barGray.withOpacity(0.35);
//
//     final fg = selected ? AppColors.white : AppColors.titleGray.withOpacity(0.85);
//     final mainText = selected ? AppColors.white : AppColors.black.withOpacity(0.85);
//
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         height: r.adaptive(mobile: 56.0, tablet: 60.0, desktop: 62.0),
//         padding: EdgeInsets.symmetric(horizontal: r.wp(0.04)),
//         decoration: BoxDecoration(
//           color: bg,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: border, width: 1),
//         ),
//         child: Row(
//           children: [
//             Text(
//               letter,
//               style: TextStyle(
//                 fontSize: r.text(13.5),
//                 fontWeight: FontWeight.w900,
//                 color: fg,
//               ),
//             ),
//             SizedBox(width: r.wp(0.02)),
//             Expanded(
//               child: Text(
//                 text,
//                 style: TextStyle(
//                   fontSize: r.text(14),
//                   fontWeight: FontWeight.w800,
//                   color: mainText,
//                 ),
//               ),
//             ),
//             if (selected) ...[
//               Container(
//                 width: r.adaptive(mobile: 20.0, tablet: 22.0, desktop: 24.0),
//                 height: r.adaptive(mobile: 20.0, tablet: 22.0, desktop: 24.0),
//                 decoration: BoxDecoration(
//                   color: AppColors.white.withOpacity(0.18),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Icons.check_rounded,
//                   size: r.text(16),
//                   color: AppColors.white,
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _Badge extends StatelessWidget {
//   final String text;
//   const _Badge({required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     final r = context.r;
//
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: r.wp(0.03),
//         vertical: r.hp(0.006),
//       ),
//       decoration: BoxDecoration(
//         color: AppColors.primary.withOpacity(0.18),
//         borderRadius: BorderRadius.circular(999),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             Icons.flash_on_rounded,
//             size: r.text(14),
//             color: AppColors.primary,
//           ),
//           SizedBox(width: r.wp(0.012)),
//           Text(
//             text,
//             style: TextStyle(
//               fontSize: r.text(11),
//               fontWeight: FontWeight.w900,
//               letterSpacing: 0.6,
//               color: AppColors.primary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }