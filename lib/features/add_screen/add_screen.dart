import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ownproject/constants/responsivness.dart';
import 'package:ownproject/features/add_screen/widgets/add_collection_wg.dart';
import 'package:ownproject/features/add_screen/widgets/overplayedfild_wg.dart';
import 'package:ownproject/features/add_screen/widgets/save_button_wg.dart';
import 'package:ownproject/features/add_screen/widgets/smart_fill.dart';

import '../../constants/colors.dart';
import '../../constants/text.dart';
import '../home/widgets/collection_wg.dart';



class AddWordScreen extends StatefulWidget {
  const AddWordScreen({super.key});

  @override
  State<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  final controller = TextEditingController();


  String selectedType = "Adjective";
  String selectedCollection = "Business";

  final List<String> types = ["Adjective", "Noun", "Verb"];
  List<CollectionModel> collections = [];

  @override
  void initState() {
    super.initState();
    CollectionsRepo().load().then((_) {
      setState(() {
        collections = CollectionsRepo().collections;
        selectedCollection = collections.first.title;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Scaffold(
      backgroundColor: AppColors.background,

      // ================= APP BAR =================
      appBar: AppBar(
              backgroundColor: AppColors.background,
              centerTitle: true,
              elevation: 0,
              titleSpacing: 0,
              leading: BackButton(
                color: AppColors.black,
                onPressed: () {
                  context.go('/');
                },
              ),
              title: Text(
                "Add words",
                style: AppText.appBarBadgeBold.copyWith(fontSize: 18),

              ),
            ),

      // ================= BODY =================
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: r.wp(0.06),
          vertical: r.hp(0.02),
        ),
        child: Column(
          children: [
            WordSmartFillField(controller: controller,),
            SizedBox(height: r.text(12)),

            // -------- TYPE DROPDOWN --------
            SmartDropdown(
              value: selectedType,
              items: types,
              onChanged: (v) {
                setState(() => selectedType = v);
              },
            ),



            SizedBox(height: r.text(12)),

            _InputField(hint: "Definition"),
            SizedBox(height: r.text(12)),

            _InputField(
              hint: "Example sentence",
              maxLines: 2,
            ),

            SizedBox(height: r.text(12)),

            // -------- COLLECTION DROPDOWN --------
            SmartDropdown(
              value: selectedCollection,
              items: collections.map((e) => e.title).toList(),
              onChanged: (v) => setState(() => selectedCollection = v),
              onAdd: () async {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (_) => const AddCollectionDialog(),
                );

                if (result == true) {
                  setState(() {
                    collections = CollectionsRepo().collections;
                    selectedCollection = collections.last.title;
                  });
                }
              },),






              SizedBox(height: r.text(26)),
            SaveButton(),
          ],
        ),
      ),
    );
  }




}




class _InputField extends StatelessWidget {
  final String hint;
  final int maxLines;
  final String? errorText;
  final String? topLabel; // Yangi prop: yuqoridagi label uchun
  final Color? topLabelColor; // Label rangi uchun
  final bool showTopLabel; // Label ni ko'rsatish/yo'q

  const _InputField({
    required this.hint,
    this.maxLines = 1,
    this.errorText,
    this.topLabel,
    this.topLabelColor,
    this.showTopLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTopLabel && topLabel != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                topLabel!,
                style: AppText.appBarBadgeBold.copyWith(
                  fontSize: r.text(12),
                  color: topLabelColor ?? AppColors.barRed,
                ),
              ),
            ],
          ),

        if (showTopLabel && topLabel != null) SizedBox(height: r.text(4)),

        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppText.appBarBadgeBold.copyWith(
              fontSize: r.text(13),
              color: AppColors.gray,
            ),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: r.text(14),
              vertical: r.text(16),
            ),
            border: _inputBorder(),
            enabledBorder: _inputBorder(),
            focusedBorder: _inputBorder(
            ),
          ),
        ),

        if (errorText != null) ...[
          SizedBox(height: r.text(4)),
          Text(
            errorText!,
            style: AppText.appBarBadgeBold.copyWith(
              fontSize: r.text(11),
              color: Colors.red,
            ),
          ),
        ]
      ],
    );
  }

  OutlineInputBorder _inputBorder({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: color ?? AppColors.barGray,
        width: 1,
      ),
    );
  }
}



