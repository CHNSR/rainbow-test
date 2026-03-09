import 'package:flutter/material.dart';

/// 🎯 Responsive Utilities - ใช้ helper functions แทน inline LayoutBuilder
class Responsive {
  // Mobile breakpoint
  static const double mobileBP = 600;
  static const double tabletBP = 1200;

  /// ✅ ตรวจสอบ device type จาก context
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBP;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBP &&
      MediaQuery.of(context).size.width < tabletBP;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBP;

  /// ✅ ตรวจสอบ device type จาก constraints (ใช้ใน LayoutBuilder)
  static bool isMobileConstraints(BoxConstraints constraints) =>
      constraints.maxWidth < mobileBP;

  static bool isTabletConstraints(BoxConstraints constraints) =>
      constraints.maxWidth >= mobileBP && constraints.maxWidth < tabletBP;

  static bool isDesktopConstraints(BoxConstraints constraints) =>
      constraints.maxWidth >= tabletBP;

  /// ✅ Get responsive value
  static T getValue<T>({
    required BoxConstraints constraints,
    required T mobile,
    required T tablet,
    required T desktop,
  }) {
    if (isDesktopConstraints(constraints)) return desktop;
    if (isTabletConstraints(constraints)) return tablet;
    return mobile;
  }

  /// ✅ Helper: icon size
  static double iconSize(BoxConstraints constraints) => getValue(
    constraints: constraints,
    mobile: 35.0,
    tablet: 40.0,
    desktop: 50.0,
  );

  /// ✅ Helper: font size
  static double fontSize(BoxConstraints constraints) => getValue(
    constraints: constraints,
    mobile: 14.0,
    tablet: 17.0,
    desktop: 20.0,
  );

  /// ✅ Helper: padding horizontal
  static double paddingH(BoxConstraints constraints) => getValue(
    constraints: constraints,
    mobile: 8.0,
    tablet: 10.0,
    desktop: 12.0,
  );

  /// ✅ Helper: spacing
  static double spacing(BoxConstraints constraints) => getValue(
    constraints: constraints,
    mobile: 4.0,
    tablet: 6.0,
    desktop: 8.0,
  );
}

/// 🎯 Credit Card Info Card Builder
class CreditCardInfoCard extends StatelessWidget {
  final VoidCallback? onTap;

  const CreditCardInfoCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.paddingH(constraints),
            vertical: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔷 Icon
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Icon(
                    Icons.credit_card,
                    color: Colors.red,
                    size: Responsive.iconSize(constraints),
                  ),
                ),
              ),
              SizedBox(width: Responsive.spacing(constraints)),
              // 🔷 Text
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Accept only Credit Card",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: Responsive.fontSize(constraints),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
