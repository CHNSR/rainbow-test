import 'package:flutter_application_1/config/export.dart';

class FoodRepository {
  final FoodService service = FoodService();

  Future<List<FoodMenu>> getMenus() {
    return FoodService.parseFoodMenu();
  }
}
