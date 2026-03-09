import 'package:flutter_application_1/model/food_menu.dart' show FoodMenu;

class MenuFilter {
  static List<FoodMenu> filterMenus({
    required List<FoodMenu> menus,
    String? foodSetId,
    String? foodCatId,
    String searchText = "",
  }) {
    final query = searchText.trim().toLowerCase();

    return menus.where((m) {
      /// filter foodSet
      if (foodSetId != null && m.foodSetId != foodSetId) {
        return false;
      }

      /// filter category
      if (foodCatId != null && m.foodCatId != foodCatId) {
        return false;
      }

      /// filter search
      if (query.isNotEmpty) {
        final name = (m.foodName ?? "").toLowerCase();
        final desc = (m.foodDesc ?? "").toLowerCase();

        if (!name.contains(query) && !desc.contains(query)) {
          return false;
        }
      }

      return true;
    }).toList();
  }
}
