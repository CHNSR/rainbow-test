import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';

/// ✅ Route names - ใช้ reference ชื่อ route
class AppRoutes {
  static const String home = '/home';
  static const String selectOrderType = '/select-order-type';
  static const String order = '/order';
  static const String setting = '/setting';
  static const String storeManagement = '/store-management';
  static const String configPrinter = '/config-printer';
  static const String printerList = '/printer_list';
}

/// ✅ Route generator - สร้าง routes
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case AppRoutes.selectOrderType:
        return MaterialPageRoute(builder: (_) => const SelectOrderType());

      case AppRoutes.order:
        return MaterialPageRoute(builder: (_) => const OrderPages());

      case AppRoutes.setting:
        return MaterialPageRoute(builder: (_) => const SettingPage());

      case AppRoutes.configPrinter:
        return MaterialPageRoute(builder: (_) => const PrinterConfigPage());

      case AppRoutes.printerList:
        return MaterialPageRoute(builder: (_) => const PrinterListPage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text('Route "${settings.name}" not found')),
          ),
        );
    }
  }
}

/// ✅ Navigation helper class
class AppNavigator {
  /// ไปหน้า home
  static void goToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );
  }

  /// ไปหน้า select order type
  static void goToSelectOrderType(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.selectOrderType);
  }

  /// ไปหน้า order
  static void goToOrder(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.order);
  }

  /// ไปหน้า setting
  static void goToSetting(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.setting);
  }

  /// ไปหน้า store management
  static void goToStoreManagement(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.storeManagement);
  }

  static void goToConfigPrinter(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.configPrinter);
  }

  static void goToPrinterList(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.printerList);
  }

  /// ย้อนกลับ
  static void goBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
