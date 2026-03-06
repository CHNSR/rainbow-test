import 'package:flutter_application_1/model/food_menu.dart' show FoodMenu;

class MenuFilter {
  static List<FoodMenu> filterMenus({
    required List<FoodMenu> menus,
    String? foodSetId,
    String? foodCatId,
    String searchText = "",
  }) {
    var result = menus;

    /// filter foodSet
    if (foodSetId != null) {
      result = result.where((m) => m.foodSetId == foodSetId).toList();
    }

    /// filter category
    if (foodCatId != null) {
      result = result.where((m) => m.foodCatId == foodCatId).toList();
    }

    /// filter search
    if (searchText.isNotEmpty) {
      final query = searchText.toLowerCase();

      result = result.where((m) {
        final name = (m.foodName ?? "").toLowerCase();
        final desc = (m.foodDesc ?? "").toLowerCase();

        return name.contains(query) || desc.contains(query);
      }).toList();
    }

    return result;
  }
}
