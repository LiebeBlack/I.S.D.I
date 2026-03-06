import 'package:flutter/material.dart';

/// A robust responsive layout builder that adapts the UI based on logical screen width.
/// 
/// Facilitates seamless scaling from small portrait phones to landscape tablets.
class ResponsiveLayoutBuilder extends StatelessWidget {

  const ResponsiveLayoutBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });
  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder? desktop;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 600 &&
      MediaQuery.sizeOf(context).width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1200;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200 && desktop != null) {
          return desktop!(context);
        } else if (constraints.maxWidth >= 600 && tablet != null) {
          return tablet!(context);
        } else {
          return mobile(context);
        }
      },
    );
}
