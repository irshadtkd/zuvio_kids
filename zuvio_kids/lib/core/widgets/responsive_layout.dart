import 'package:flutter/widgets.dart';
import 'package:zuvio_kids/core/constants/app_sizes.dart';

/// A reusable widget that renders different layouts for mobile, tablet, and desktop/iPad.
///
/// Uses [LayoutBuilder] to adapt based on parent constraints.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    required this.mobile,
    this.tablet,
    this.desktop,
    this.maxContentWidth,
    super.key,
  });

  /// Widget builder for mobile screens (< [AppSizes.maxMobileWidth]).
  final WidgetBuilder mobile;

  /// Optional widget builder for tablet and iPad screens.
  /// Falls back to [mobile] if null.
  final WidgetBuilder? tablet;

  /// Optional widget builder for large tablet / desktop screens.
  /// Falls back to [tablet] or [mobile] if null.
  final WidgetBuilder? desktop;

  /// Optional max content width limit. When specified on tablets/iPads,
  /// centers the content and constrains its maximum width to avoid over-stretched UI.
  final double? maxContentWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Widget content;
        if (constraints.maxWidth >= AppSizes.maxTabletWidth && desktop != null) {
          content = desktop!(context);
        } else if (constraints.maxWidth >= AppSizes.maxMobileWidth &&
            tablet != null) {
          content = tablet!(context);
        } else {
          content = mobile(context);
        }

        final maxWidth = maxContentWidth;
        if (maxWidth != null && constraints.maxWidth > maxWidth) {
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: content,
            ),
          );
        }

        return content;
      },
    );
  }
}
