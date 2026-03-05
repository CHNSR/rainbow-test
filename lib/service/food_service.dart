import 'package:flutter/services.dart';
import 'package:flutter_application_1/model/food_category.dart';
import 'dart:convert';

class FoodService {
  static Future<List<SubFoodCategory>> parseFoodCategory() async {
    final String response = await rootBundle.loadString(
      'assets/data/menu.json',
    );

    final data = json.decode(response);

    final List categoryJson = data['result']['foodCategory'];
    print("Category JSON: $categoryJson");

    return categoryJson.map((e) => SubFoodCategory.fromJson(e)).toList();
  }

  static Future<List<FoodSet>> parseFoodSet() async {
    final String response = await rootBundle.loadString(
      'assets/data/menu.json',
    );

    final data = json.decode(response);

    final List foodSetJson = data['result']['foodSet'];
    print("Food Set JSON: $foodSetJson");

    return foodSetJson.map((e) => FoodSet.fromJson(e)).toList();
  }
}
