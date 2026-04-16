import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ownproject/constants/colors.dart';
import 'package:ownproject/constants/responsivness.dart';
import 'package:ownproject/constants/text.dart';

import '../add_screen/widgets/add_collection_wg.dart';
import '../home/widgets/collection_wg.dart' show CollectionCard, CollectionsGrid;


class CollectionsScreen extends StatefulWidget {
  const CollectionsScreen({super.key});

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  String search = "";

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    // final filtered = collectionsData
    //     .where((c) =>
    //     c.title.toLowerCase().contains(search.toLowerCase()))
    //     .toList();

    return Scaffold(
      backgroundColor: AppColors.background,

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        titleSpacing: 0,
        leading: BackButton(
          color: AppColors.black,
          onPressed: () {
            context.go('/');
          },
        ),

        title: Text(
          "Home",
          style: AppText.Medium.copyWith(
            fontSize: 18,
          ),
        ),

        actions: [
          GestureDetector(
            onTap: () async {
              final result = await showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) => const AddCollectionDialog(),
              );

              /// agar kerak bo‘lsa natijani ishlatish
              if (result == true) {
                // masalan refresh qilish
                setState(() {});
              }
            },
            child: Container(
              padding: const EdgeInsets.only(right: 24.0),
              child: Image.asset(
                'assets/icons/image 11.png',
                width: 28,
                height: 28,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),

      // ================= BODY =================
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          r.wp(0.05),
          r.text(4),
          r.wp(0.05),
          r.wp(0.05),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------- Title --------
            Text(
              "Collections",
              style: AppText.cardTitleSemiBold.copyWith(
                fontSize: r.text(24),
                color: AppColors.black,
              ),
            ),

            SizedBox(height: r.text(14)),

            // -------- Search + Filter --------
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => search = v),
                    decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(
                        color: AppColors.textGray,
                        fontSize: r.text(14),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.textGray,
                      ),
                      filled: true,
                      fillColor: AppColors.white,
                      contentPadding:
                      EdgeInsets.symmetric(vertical: r.text(14)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: r.text(10)),

                // -------- Filter button --------
                Container(
                  height: r.text(48),
                  width: r.text(48),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.tune,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),

            SizedBox(height: r.text(12)),

            // -------- Count --------
            // Text(
            //   "${filtered.length} collections",
            //   style: AppText.appBarBadgeBold.copyWith(
            //     fontSize: r.text(12),
            //     color: AppColors.textGray,
            //   ),
            // ),

            SizedBox(height: r.text(12)),

            // -------- Grid --------
            CollectionsGrid(),
          ],
        ),
      ),
    );
  }
}
