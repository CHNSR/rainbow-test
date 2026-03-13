import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';

class OrderController extends ChangeNotifier {
  List<FoodSet> sets = [];
  List<SubFoodCategory> categories = [];
  List<FoodMenu> menus = [];
  List<CartItem> cartItems = [];

  String? selectedSetId;
  String? selectedCategoryId;
  String searchText = "";

  bool isLoading = true;

  Future<void> loadData() async {
    sets = await FoodService.parseFoodSet();
    categories = await FoodService.parseFoodCategory();
    menus = await FoodService.parseFoodMenu();

    if (sets.isNotEmpty) {
      selectedSetId = sets.first.foodSetId;

      // หาเมนูใน set นั้น
      final menusInSet = menus
          .where((m) => m.foodSetId == selectedSetId)
          .toList();
      print("[OrderController] Menu Set: ${menusInSet.first.foodSetId}");
      // ตั้ง default category จาก menu ตัวแรก
      if (menusInSet.isNotEmpty) {
        selectedCategoryId = menusInSet.first.foodCatId;
      }
    }

    isLoading = false;
    notifyListeners();
  }

  void addToCart(FoodMenu food) {
    final index = cartItems.indexWhere(
      (item) => item.food.foodId == food.foodId,
    );

    if (index != -1) {
      cartItems[index].quantity++;
    } else {
      cartItems.add(CartItem(food: food, quantity: 1));
    }

    notifyListeners();
  }

  //filter menu
  List<FoodMenu> get filteredMenus {
    return MenuFilter.filterMenus(
      menus: MenuFilter.filterMenus(
        menus: menus,
        foodSetId: selectedSetId,
        searchText: searchText,
      ),
    );
  }

  List<SubFoodCategory> get filteredCategories {
    if (selectedSetId == null) return [];

    final foodCatsInSet = menus
        .where((m) => m.foodSetId == selectedSetId)
        .map((m) => m.foodCatId)
        .toSet();

    return categories
        .where((c) => foodCatsInSet.contains(c.foodCatId))
        .toList();
  }

  void buildCategoryKeys(Map<String, GlobalKey> categoryIndexMap) {
    categoryIndexMap.clear();

    for (var cat in categories) {
      categoryIndexMap[cat.foodCatId] = GlobalKey();
    }
  }
}
