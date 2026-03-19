import 'dart:ui';

class HomePageCore {
  static toggleBottomSheet({
    required bool showBottom,
    required Function(bool, Offset) setStateCallback,
  }) async {
    if (!showBottom) {
      // Open
      setStateCallback(true, const Offset(0, 1));

      await Future.delayed(const Duration(milliseconds: 50));

      setStateCallback(true, const Offset(0, 0));
    } else {
      // Close (animate down first)
      setStateCallback(true, const Offset(0, 1));

      await Future.delayed(const Duration(milliseconds: 400));

      setStateCallback(false, const Offset(0, 1));
    }
  }
}
