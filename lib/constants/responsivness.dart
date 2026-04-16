import 'package:flutter/material.dart';

/// Device categories
enum DeviceType { mobile, tablet, desktop }

/// Simple, safe, production-ready responsive helper
class Responsive {
  final BuildContext context;
  final MediaQueryData _mq;

  late final double width;
  late final double height;

  /// SafeArea paddings
  late final EdgeInsets padding;

  /// SafeArea-aware sizes (content area)
  late final double safeWidth;
  late final double safeHeight;

  Responsive(this.context) : _mq = MediaQuery.of(context) {
    width = _mq.size.width;
    height = _mq.size.height;

    padding = _mq.padding;

    safeWidth = width - padding.left - padding.right;
    safeHeight = height - padding.top - padding.bottom;
  }

  // --------------------------------------------------
  // Device type (clear & predictable breakpoints)
  // --------------------------------------------------
  DeviceType get deviceType {
    if (width >= 1100) return DeviceType.desktop;
    if (width >= 700) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;

  // --------------------------------------------------
  // Percentage-based spacing (content only)
  // NOTE: only use wp/hp for INSIDE layout, not for edge-positioning!
  // --------------------------------------------------
  double wp(double percent) => safeWidth * percent;
  double hp(double percent) => safeHeight * percent;

  // --------------------------------------------------
  // Edge-safe helpers (for Positioned/right/bottom etc.)
  // Use these for floating widgets near screen edges.
  // --------------------------------------------------
  double edgeRight(double value) => value + padding.right;
  double edgeLeft(double value) => value + padding.left;
  double edgeBottom(double value) => value + padding.bottom;
  double edgeTop(double value) => value + padding.top;

  // --------------------------------------------------
  // Adaptive values (layout / sizes)
  // --------------------------------------------------
  T adaptive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    switch (deviceType) {
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      default:
        return mobile;
    }
  }

  // --------------------------------------------------
  // Responsive text sizing (safe default)
  // --------------------------------------------------
  double text(double base) {
    switch (deviceType) {
      case DeviceType.tablet:
        return base * 1.15;
      case DeviceType.desktop:
        return base * 1.30;
      default:
        return base;
    }
  }
}

extension ResponsiveX on BuildContext {
  Responsive get r => Responsive(this);
}