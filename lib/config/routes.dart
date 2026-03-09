import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/pages/order_pages.dart';
import 'package:flutter_application_1/pages/select_order_type.dart';
import 'package:flutter_application_1/pages/setting_page.dart';
import 'package:flutter_application_1/pages/store_management_page.dart';

/// ✅ Route names - ใช้ reference ชื่อ route
class AppRoutes {
  static const String home = '/home';
  static const String selectOrderType = '/select-order-type';
  static const String order = '/order';
  static const String setting = '/setting';
  static const String storeManagement = '/store-management';
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

      // case AppRoutes.setting:
      //   return MaterialPageRoute(builder: (_) => const SettingPage());

      // case AppRoutes.storeManagement:
      //   return MaterialPageRoute(builder: (_) => const StoreManagementPage());

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

  /// ย้อนกลับ
  static void goBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
