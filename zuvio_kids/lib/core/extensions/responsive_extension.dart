import 'package:flutter/widgets.dart';
import 'package:zuvio_kids/core/constants/app_sizes.dart';

/// Extension on [BuildContext] for responsive design checks and helpers.
extension ResponsiveExtension on BuildContext {
  /// The current screen width.
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// The current screen height.
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Returns true if the device is a mobile screen (< [AppSizes.maxMobileWidth]).
  bool get isMobile => screenWidth < AppSizes.maxMobileWidth;

  /// Returns true if the device is a tablet or iPad ([AppSizes.maxMobileWidth] to [AppSizes.maxTabletWidth]).
  bool get isTablet =>
      screenWidth >= AppSizes.maxMobileWidth &&
      screenWidth < AppSizes.maxTabletWidth;

  /// Returns true if the screen is large tablet/iPad Pro/desktop (>= [AppSizes.maxTabletWidth]).
  bool get isDesktopOrLargeTablet => screenWidth >= AppSizes.maxTabletWidth;

  /// Returns a responsive value based on device form factor.
  /// If [tablet] is omitted, falls back to [mobile].
  /// If [desktop] is omitted, falls back to [tablet] or [mobile].
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktopOrLargeTablet && desktop != null) {
      return desktop;
    }
    if ((isTablet || isDesktopOrLargeTablet) && tablet != null) {
      return tablet;
    }
    return mobile;
  }
}
