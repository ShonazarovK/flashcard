import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ownproject/constants/responsivness.dart';
import '../../constants/colors.dart';
import '../../constants/text.dart';
import 'keep_analyze_screen.dart';

class KeepResultsScreen extends StatelessWidget {
  final List<KeepWordItem> results;
  const KeepResultsScreen({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(
          color: AppColors.black,
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Keep",
          style: AppText.cardTitleSemiBold.copyWith(
            fontSize: r.text(20),
            color: AppColors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: r.wp(0.06)),
        child: ListView.separated(
          padding: EdgeInsets.only(top: r.text(10)),
          itemCount: results.length,
          separatorBuilder: (_, __) => SizedBox(height: r.text(12)),
          itemBuilder: (context, i) {
            return _ResultCard(
              item: results[i],
              onEdit: () {},
              onPlay: () {},
            );
          },
        ),
      ),
    );
  }
}
class _ResultCard extends StatelessWidget {
  final KeepWordItem item;
  final VoidCallback onEdit;
  final VoidCallback onPlay;

  const _ResultCard({
    required this.item,
    required this.onEdit,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: r.text(99)),
      padding: EdgeInsets.symmetric(
        horizontal: r.text(14),
        vertical: r.text(12),
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.gray.withOpacity(0.4),
          width: 1,
        ),

      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: r.text(8),
            height: r.text(8),
            margin: EdgeInsets.only(top: r.text(6)),
            decoration: BoxDecoration(
              color: AppColors.collection.withOpacity(0.85),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: r.text(10)),

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ TOP: word + type + edit right
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              item.word,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.cardTitleSemiBold.copyWith(
                                fontSize: r.text(16),
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          SizedBox(width: r.text(6)),
                          Text(
                            item.type,
                            style: AppText.subtitleRegular.copyWith(
                              fontSize: r.text(14),
                              color: AppColors.black,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: onEdit,
                      child: Padding(
                        padding: EdgeInsets.only(left: r.text(6)),
                        child: Icon(
                          Icons.edit_outlined,
                          size: r.text(18),
                          color: AppColors.textGray,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: r.text(4)),

                // ✅ IPA + US + speaker (speaker US yonida)
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        item.ipa,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.subtitleRegular.copyWith(
                          fontSize: r.text(12),
                          color: AppColors.textGray,
                        ),
                      ),
                    ),
                    SizedBox(width: r.text(10)),
                    Text(
                      "US",
                      style: AppText.subtitleRegular.copyWith(
                        fontSize: r.text(12),
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(width: r.text(6)),
                    GestureDetector(
                      onTap: onPlay,
                      child: Icon(
                        Icons.volume_up_rounded,
                        size: r.text(18),
                        color: AppColors.collection,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: r.text(8)),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LevelBadge(level: item.level),
                    SizedBox(width: r.text(8)),
                    Expanded(
                      child: Text(
                        item.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.subtitleRegular.copyWith(
                          fontSize: r.text(12),
                          color: AppColors.textGray,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  final String level;
  const _LevelBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.text(8), vertical: r.text(3)),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        level,
        style: AppText.appBarBadgeBold.copyWith(
          fontSize: r.text(10),
          color: AppColors.white,
        ),
      ),
    );
  }
}
