import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ownproject/constants/responsivness.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/colors.dart';
import '../../../constants/text.dart';

class CollectionCard extends StatelessWidget {
  final String title;
  final int progress;
  final int words;
  final String timeLabel;
  final bool finished;
  final VoidCallback? onTap;

  const CollectionCard({
    super.key,
    required this.title,
    required this.progress,
    required this.words,
    required this.timeLabel,
    this.finished = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: r.adaptive(
          mobile: r.wp(0.44),
          tablet: r.wp(0.38),
          desktop: r.wp(0.30),
        ),
        child: Container(
          padding: EdgeInsets.all(
            r.adaptive(
              mobile: r.text(12),
              tablet: r.text(14),
              desktop: r.text(16),
            ),
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.barGray),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- TITLE + PROGRESS ----------------
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: AppText.subtitleRegular.copyWith(
                        fontSize: r.adaptive(
                          mobile: 16,
                          tablet: 17,
                          desktop: 18,
                        ),
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: r.text(6)),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: r.text(8),
                      vertical: r.text(2),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.collection,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      "$progress%",
                      style: AppText.subtitleRegular.copyWith(
                        fontSize: r.text(10),
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: r.text(4)),

              // ---------------- WORDS + STATUS ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$words words",
                    style: AppText.subtitleRegular.copyWith(
                      fontSize: r.text(10),
                      color: AppColors.textGray,
                    ),
                  ),
                  Text(
                    finished ? "Finished" : "Active",
                    style: AppText.subtitleRegular.copyWith(
                      fontSize: r.text(10),
                      color: finished ? AppColors.success : AppColors.textGray,
                    ),
                  ),
                ],
              ),

              SizedBox(height: r.text(6)),

              // ---------------- TIME ----------------
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: r.text(10),
                    color: AppColors.textGray,
                  ),
                  SizedBox(width: r.text(4)),
                  Text(
                    timeLabel,
                    style: AppText.subtitleRegular.copyWith(
                      fontSize: r.text(10),
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CollectionsGrid extends StatefulWidget {
  const CollectionsGrid({super.key});

  @override
  State<CollectionsGrid> createState() => _CollectionsGridState();
}

class _CollectionsGridState extends State<CollectionsGrid> {
  @override
  void initState() {
    super.initState();
    CollectionsRepo().load().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final collections = CollectionsRepo().collections;

    return Wrap(
      spacing: r.text(6),
      runSpacing: r.text(6),
      children: collections.map((c) {
        return CollectionCard(
          title: c.title,
          progress: c.progress,
          words: c.words,
          timeLabel: _timeAgo(c.createdAt),
          onTap: () => context.go('/vocab'),
        );
      }).toList(),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return "${diff.inDays} days";
    if (diff.inHours > 0) return "${diff.inHours} hours";
    return "Today";
  }
}

class CollectionModel {
  final String title;
  final DateTime createdAt;
  final int words;
  final int progress;

  CollectionModel({
    required this.title,
    required this.createdAt,
    this.words = 0,
    this.progress = 0,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'createdAt': createdAt.toIso8601String(),
    'words': words,
    'progress': progress,
  };

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      title: json['title'],
      createdAt: DateTime.parse(json['createdAt']),
      words: json['words'] ?? 0,
      progress: json['progress'] ?? 0,
    );
  }
}

class CollectionsRepo {
  static final CollectionsRepo _instance = CollectionsRepo._internal();
  factory CollectionsRepo() => _instance;
  CollectionsRepo._internal();

  static const _key = 'collections';

  final List<CollectionModel> _collections = [];

  List<CollectionModel> get collections => _collections;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return;

    final List list = jsonDecode(raw);
    _collections
      ..clear()
      ..addAll(list.map((e) => CollectionModel.fromJson(e)));
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(_collections.map((e) => e.toJson()).toList());
    await prefs.setString(_key, data);
  }

  Future<void> addCollection(String title) async {
    _collections.add(
      CollectionModel(
        title: title,
        createdAt: DateTime.now(),
      ),
    );
    await _save();
  }
}
