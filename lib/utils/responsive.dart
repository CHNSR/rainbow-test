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

  static double? title(double base) {}
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
                      height: 1,
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

class ResponsiveFont {
  static double title(double width) {
    if (width < 700) return 40;
    if (width < 1200) return 60;
    if (width < 2000) return 80;
    return 100;
  }

  static double subtitle(double width) {
    if (width < 400) return 5;
    if (width < 700) return 8;
    if (width < 1200) return 14;
    return 18;
  }

  static double textsmall(double width) {
    if (width < 700) return 5;
    if (width < 1200) return 8;
    return 12;
  }

  static double logosize(double width) {
    if (width < 700) return 20;
    if (width < 1200) return 24;
    return 28;
  }

  static double subcategory_size(double width) {
    if (width < 400) return 8;
    if (width < 700) return 10;
    if (width < 1200) return 12;
    return 14;
  }

  static double titleCategory(double width) {
    if (width < 400) return 10;
    if (width < 700) return 12;
    if (width < 1200) return 14;
    return 16;
  }

  static double backButton(double width) {
    if (width < 400) return 8;
    if (width < 700) return 10;
    if (width < 1200) return 14;
    return 16;
  }
}

class ResponsiveSize {
  static double subcategoryheight(double width) {
    if (width < 400) return 20;
    if (width < 700) return 30;
    if (width < 1200) return 40;
    return 50;
  }

  static double backButtonheight(double width) {
    if (width < 400) return 18;
    if (width < 700) return 20;
    if (width < 1200) return 30;
    return 36;
  }

  static double backButtonSize(double width) {
    if (width < 400) return 8;
    if (width < 700) return 16;
    if (width < 1200) return 20;
    return 26;
  }
}
