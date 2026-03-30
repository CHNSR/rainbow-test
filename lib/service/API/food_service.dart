import 'package:flutter/services.dart';
import 'package:flutter_application_1/model/food_category.dart';
import 'dart:convert';

import 'package:flutter_application_1/model/food_menu.dart';

class FoodService {
  static Future<List<SubFoodCategory>> parseFoodCategory() async {
    final String response = await rootBundle.loadString(
      'assets/data/menu.json',
    );
    final data = json.decode(response);
    final List categoryJson = data['result']['foodCategory'];
    return categoryJson.map((e) => SubFoodCategory.fromJson(e)).toList();
  }

  static Future<List<FoodSet>> parseFoodSet() async {
    final String response = await rootBundle.loadString(
      'assets/data/menu.json',
    );
    final data = json.decode(response);
    final List foodSetJson = data['result']['foodSet'];
    return foodSetJson.map((e) => FoodSet.fromJson(e)).toList();
  }

  static Future<List<FoodMenu>> parseFoodMenu() async {
    final String response = await rootBundle.loadString(
      'assets/data/menu.json',
    );
    final Map<String, dynamic> data = json.decode(response);
    final List<dynamic> foodMenuJson = data['result']['food'];
    return foodMenuJson
        .map((e) => FoodMenu.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Map<String, List<FoodMenu>> groupFoodMenuByCategory(
    List<FoodMenu> foodMenus,
  ) {
    final Map<String, List<FoodMenu>> groupedFoodMenus = {};

    for (var food in foodMenus) {
      if (!groupedFoodMenus.containsKey(food.foodCatId)) {
        groupedFoodMenus[food.foodCatId] = [];
      }
      groupedFoodMenus[food.foodCatId]!.add(food);
    }
    return groupedFoodMenus;
  }
}
