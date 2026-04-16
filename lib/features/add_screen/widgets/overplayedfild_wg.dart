import 'package:flutter/material.dart';
import 'package:ownproject/constants/responsivness.dart';

import '../../../constants/colors.dart';
import '../../../constants/text.dart';



class SmartDropdown extends StatefulWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final VoidCallback? onAdd;

  const SmartDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.onAdd,
  });

  @override
  State<SmartDropdown> createState() => _SmartDropdownState();
}

class _SmartDropdownState extends State<SmartDropdown> {
  final GlobalKey _key = GlobalKey();
  OverlayEntry? _overlay;

  void _show() {
    final r = context.r;
    final box = _key.currentContext!.findRenderObject() as RenderBox;
    final pos = box.localToGlobal(Offset.zero);
    final size = box.size;

    _overlay = OverlayEntry(
      builder: (_) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _hide,
        child: Stack(
          children: [
            Positioned(
              left: pos.dx,
              top: pos.dy + size.height + 6,
              width: size.width,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: r.text(8)),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 12,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...widget.items.map(
                            (e) => InkWell(
                          onTap: () {
                            widget.onChanged(e);
                            _hide();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: r.text(16),
                              vertical: r.text(12),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                e,
                                style: AppText.appBarBadgeBold.copyWith(
                                  fontSize: r.text(13),
                                  color: AppColors.gray,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (widget.onAdd != null) ...[
                        const Divider(),
                        InkWell(
                          onTap: () {
                            _hide();
                            widget.onAdd!();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: r.text(16),
                              vertical: r.text(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.add, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  "Add a new Collection",
                                  style: AppText.appBarBadgeBold.copyWith(
                                    fontSize: r.text(13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlay!);
  }

  void _hide() {
    _overlay?.remove();
    _overlay = null;
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return GestureDetector(
      key: _key,
      onTap: _show,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: r.text(14),
          vertical: r.text(16),
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.barGray),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.value,
              style: AppText.appBarBadgeBold.copyWith(
                fontSize: r.text(13),
                color: AppColors.gray,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.gray,
            ),
          ],
        ),
      ),
    );
  }
}
