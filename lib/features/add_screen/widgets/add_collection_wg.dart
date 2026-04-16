import 'package:flutter/material.dart';
import 'package:ownproject/constants/responsivness.dart';
import '../../../constants/colors.dart';
import '../../../constants/text.dart';
import '../../home/widgets/collection_wg.dart';


class AddCollectionDialog extends StatefulWidget {

  const AddCollectionDialog({
    super.key,});

  @override
  State<AddCollectionDialog> createState() => _AddCollectionDialogState();
}

class _AddCollectionDialogState extends State<AddCollectionDialog> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(r.text(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Add Collection",
              style: AppText.cardTitleSemiBold.copyWith(
                fontSize: r.text(18),
              ),
            ),

            SizedBox(height: r.text(16)),

            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Collection name",
                  hintStyle: AppText.Medium.copyWith(
                    fontSize: 14,
                    color: AppColors.titleGray
                  ),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: r.text(20)),

            SizedBox(
              width: double.infinity,
              height: r.text(46),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.collection,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  if (controller.text.trim().isEmpty) return;

                  await CollectionsRepo().addCollection(controller.text.trim());
                  Navigator.pop(context, true);
                },

                child: Text(
                  "ADD COLLECTION",
                  style: AppText.appBarSemiBold.copyWith(
                    color: AppColors.white,
                    fontSize: 14
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
