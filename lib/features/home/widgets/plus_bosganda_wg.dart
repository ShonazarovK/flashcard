import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ownproject/constants/responsivness.dart';
import '../../../constants/colors.dart';

class FabActionMenu extends StatefulWidget {
  final VoidCallback onScanText;
  final VoidCallback onManual;
  final VoidCallback onMic;

  const FabActionMenu({
    super.key,
    required this.onScanText,
    required this.onManual,
    required this.onMic,
  });

  @override
  State<FabActionMenu> createState() => _FabActionMenuState();
}

class _FabActionMenuState extends State<FabActionMenu>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  bool _open = false;

  // --- Tunables (fixed -> same on emulator & phone)
  static const double _fabSize = 56.0;
  static const double _edgeMargin = 16.0;
  static const double _rowGap = 10.0;
  static const double _aboveFabGap = 14.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      _open ? _controller.forward() : _controller.reverse();
    });
  }

  void _close() {
    if (!_open) return;
    setState(() {
      _open = false;
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    // viewPadding -> navigation bar / notch holatlarida ham stabil
    final vp = MediaQuery.of(context).viewPadding;

    final double right = _edgeMargin + vp.right;
    final double bottom = _edgeMargin + vp.bottom;

    // Action row FAB dan yuqorida turadi
    final double rowBottom = bottom + _fabSize + _aboveFabGap;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Tap outside -> close (stabil behavior)
        if (_open)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _close,
              child: const SizedBox(),
            ),
          ),

        // =============== ACTION ROW (positioned) ===============
        Positioned(
          right: right,
          bottom: rowBottom,
          child: IgnorePointer(
            ignoring: !_open,
            child: FadeTransition(
              opacity: _animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.25),
                  end: Offset.zero,
                ).animate(_animation),
                child: _ActionRow(
                  gap: _rowGap,
                  onScan: () {
                    _close();
                    context.push('/photo');
                    // yoki: widget.onScanText();
                  },
                  onAdd: () {
                    _close();
                    context.go('/add-word');
                    // yoki: widget.onManual();
                  },
                  onMic: () {
                    _close();
                    context.go('/speak');
                    // yoki: widget.onMic();
                  },
                ),
              ),
            ),
          ),
        ),

        // =============== MAIN FAB (positioned) ===============
        Positioned(
          right: right,
          bottom: bottom,
          child: SizedBox(
            width: _fabSize,
            height: _fabSize,
            child: FloatingActionButton(
              heroTag: "fab_action_menu",
              backgroundColor: AppColors.primary,
              elevation: 6,
              shape: const CircleBorder(),
              onPressed: _toggle,
              child: AnimatedRotation(
                turns: _open ? 0.125 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  _open ? Icons.close : Icons.add,
                  color: AppColors.white,
                  // icon size: fixed-ish (NOT tablet/desktop adaptive)
                  size: r.isDesktop ? 30 : 28,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  final double gap;
  final VoidCallback onScan;
  final VoidCallback onAdd;
  final VoidCallback onMic;

  const _ActionRow({
    required this.gap,
    required this.onScan,
    required this.onAdd,
    required this.onMic,
  });

  @override
  Widget build(BuildContext context) {
    // Fixed sizes -> same everywhere
    const double itemW = 110;
    const double itemH = 72;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ActionItem(
          width: itemW,
          height: itemH,
          icon: Icons.document_scanner_outlined,
          label: "Scan text",
          onTap: onScan,
        ),
        SizedBox(width: gap),
        _ActionItem(
          width: itemW,
          height: itemH,
          icon: Icons.grid_view_rounded,
          label: "Add",
          onTap: onAdd,
        ),
        SizedBox(width: gap),
        _ActionItem(
          width: itemW,
          height: itemH,
          icon: Icons.mic_none_rounded,
          label: "Microphone",
          onTap: onMic,
        ),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  final double width;
  final double height;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: AppColors.primary.withOpacity(0.12),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: AppColors.collection),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}