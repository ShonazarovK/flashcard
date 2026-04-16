import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ownproject/constants/responsivness.dart';

import '../../constants/colors.dart';
import '../../constants/text.dart';

class Vocebularies extends StatefulWidget {
  const Vocebularies({super.key});

  @override
  State<Vocebularies> createState() => _VocebulariesState();
}

class _VocebulariesState extends State<Vocebularies> {
  String search = "";

  /// Qaysi card expanded ekanini saqlaymiz (faqat bittasi ochiq bo‘ladi)
  String? expandedId;

  /// Demo data (sizda real list bo‘lsa, shuni o‘rniga ishlating)
  final List<_WordItem> allWords = [
    _WordItem(
      id: "simultaneously-noun",
      title: "Simultaneously",
      type: "Noun",
      description: "happening or done at the same time as something else",
      dotColor: AppColors.barBlue,
    ),
    _WordItem(
      id: "simultaneously-adjective",
      title: "Simultaneously",
      type: "Adjective",
      description:
      "happening or done at the same time as something else\n\n"
          "• The learning processes in both the sagittal and frontal planes are carried out simultaneously.",
      dotColor: AppColors.barOrange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    // ====== FILTER (SEARCH) ======
    final q = search.trim().toLowerCase();
    final List<_WordItem> shownWords = allWords.where((w) {
      if (q.isEmpty) return true;
      final all = "${w.title} ${w.type} ${w.description}".toLowerCase();
      return all.contains(q);
    }).toList();

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
            context.go('/seeAll');
          },
        ),
        title: Text(
          "Collections",
          style: AppText.Medium.copyWith(fontSize: 18),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 24.0),
            child: const Icon(
              Icons.more_vert,
              color: AppColors.black,
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
        child: ListView(
          children: [
            // -------- Title --------
            Text(
              "Business",
              style: AppText.cardTitleSemiBold.copyWith(
                fontSize: r.text(24),
                color: AppColors.black,
              ),
            ),

            SizedBox(height: r.text(14)),

            // -------- Stats --------
            Row(
              children: [
                _statCard("12", "Learned", AppColors.barBlue),
                SizedBox(width: r.text(8)),
                _statCard("12", "In Progress", AppColors.barOrange),
                SizedBox(width: r.text(8)),
                _statCard("0", "Not Reviewed", AppColors.barRed),
              ],
            ),

            SizedBox(height: r.text(14)),

            // -------- Search + Filter --------
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => search = v),
                    decoration: InputDecoration(
                      hintText: "Search words",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: r.text(10)),
                GestureDetector(
                  onTap: () {
                    context.push('/filter');
                  },
                  child: Container(
                    height: r.text(48),
                    width: r.text(48),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.tune),
                  ),
                )
              ],
            ),

            SizedBox(height: r.text(12)),

            // -------- Count --------
            Text(
              "${shownWords.length} WORDS",
              style: AppText.appBarBadgeBold.copyWith(
                fontSize: r.text(12),
                color: AppColors.textGray,
              ),
            ),

            SizedBox(height: r.text(12)),

            // -------- WORD LIST or NO WORDS FOUND --------
            if (shownWords.isEmpty)
              Padding(
                padding: EdgeInsets.only(top: r.text(80)),
                child: Center(
                  child: Text(
                    "NO WORDS FOUND",
                    style: AppText.subtitleRegular.copyWith(
                      fontSize: r.text(12),
                      color: AppColors.textGray,
                    ),
                  ),
                ),
              )
            else
              ...List.generate(shownWords.length, (i) {
                final w = shownWords[i];
                final isExpanded = expandedId == w.id;

                return Padding(
                  padding: EdgeInsets.only(bottom: r.text(10)),
                  child: wordCard(
                    key: ValueKey(w.id),
                    id: w.id,
                    title: w.title,
                    type: w.type,
                    description: w.description,
                    dotColor: w.dotColor,
                    expanded: isExpanded,
                    onTap: () {
                      setState(() {
                        expandedId = isExpanded ? null : w.id;
                      });
                    },
                    onDelete: () {
                      // demo delete
                      setState(() {
                        allWords.removeWhere((x) => x.id == w.id);
                        if (expandedId == w.id) expandedId = null;
                      });
                    },
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  // ================= HELPERS =================

  Widget _statCard(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// WORD CARD (rasmdagidek)
  /// - collapsed: short description (1-2 qator)
  /// - tap: expanded bo‘lib, pastga qolgan qismi ochiladi
  /// - swipe left: delete
  Widget wordCard({
    required Key key,
    required String id,
    required String title,
    required String type,
    required String description,
    required Color dotColor,
    required bool expanded,
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    final r = context.r;

    // description ni "short" va "details" ga bo‘lamiz
    // short = 1-qism, details = qolgan (agar bo‘lsa)
    final parts = description.split("\n\n");
    final shortText = parts.isNotEmpty ? parts.first.trim() : description.trim();
    final details =
    parts.length > 1 ? parts.sublist(1).join("\n\n").trim() : "";

    return Dismissible(
      key: key,
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),

      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.barRed,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 26,
        ),
      ),

      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: EdgeInsets.all(r.text(14)),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // DOT
                Container(
                  width: r.text(8),
                  height: r.text(8),
                  margin: EdgeInsets.only(top: r.text(6)),
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: r.text(10)),

                // TEXT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "$title $type",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: r.text(14),
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          Icon(
                            expanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: AppColors.textGray,
                          ),
                        ],
                      ),
                      SizedBox(height: r.text(6)),

                      // short always
                      Text(
                        shortText,
                        maxLines: expanded ? 10 : 2,
                        overflow: expanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: r.text(12),
                          color: AppColors.textGray,
                        ),
                      ),

                      // details only when expanded
                      if (expanded && details.isNotEmpty) ...[
                        SizedBox(height: r.text(8)),
                        Text(
                          details,
                          style: TextStyle(
                            fontSize: r.text(12),
                            color: AppColors.textGray,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WordItem {
  final String id;
  final String title;
  final String type;
  final String description;
  final Color dotColor;

  const _WordItem({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.dotColor,
  });
}
