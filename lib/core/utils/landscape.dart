import 'package:flutter/material.dart';

class LandScapeUtils {
  static bool isLandscape(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return size.width > size.height;
  }

  static double getResponsiveWidth(BuildContext context, double scale) {
    return MediaQuery.of(context).size.width * scale;
  }

  static double getResponsiveHeight(BuildContext context, double scale) {
    return MediaQuery.of(context).size.height * scale;
  }

  static Size getResponsiveScreenSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size;
  }
}
