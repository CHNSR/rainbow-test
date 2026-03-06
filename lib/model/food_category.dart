class SubFoodCategory {
  final String foodCatId;
  final String foodCatName;
  final int foodCatSorting;
  final String? foodCatDesc;
  final String foodCatColor;
  final String foodCatIcon;
  final bool priority;
  final int foodCatParent;
  final bool active;

  SubFoodCategory({
    required this.foodCatId,
    required this.foodCatName,
    required this.foodCatSorting,
    this.foodCatDesc,
    required this.foodCatColor,
    required this.foodCatIcon,
    required this.priority,
    required this.foodCatParent,
    required this.active,
  });

  factory SubFoodCategory.fromJson(Map<String, dynamic> json) {
    return SubFoodCategory(
      foodCatId: json['foodCatId'] ?? '',
      foodCatName: json['foodCatName'] ?? '',
      foodCatSorting: json['foodCatSorting'] ?? 0,
      foodCatDesc: json['foodCatDesc'],
      foodCatColor: json['foodCatColor'] ?? '',
      foodCatIcon: json['foodCatIcon'] ?? '',
      priority: json['priority'] ?? false,
      foodCatParent: json['foodCatParent'] ?? 0,
      active: json['active'] ?? false,
    );
  }

  static List<SubFoodCategory> listFromJson(List list) {
    return list.map((e) => SubFoodCategory.fromJson(e)).toList();
  }
}

class FoodSet {
  final String foodSetId;
  final String foodSetName;
  final String foodSetChar;
  final int foodSetSorting;
  final bool isThirdParty;
  final bool active;

  FoodSet({
    required this.foodSetId,
    required this.foodSetName,
    required this.foodSetChar,
    required this.foodSetSorting,
    required this.isThirdParty,
    required this.active,
  });

  factory FoodSet.fromJson(Map<String, dynamic> json) {
    return FoodSet(
      foodSetId: json['foodSetId'],
      foodSetName: json['foodSetName'],
      foodSetChar: json['foodSetChar'],
      foodSetSorting: json['foodSetSorting'],
      isThirdParty: json['isThirdParty'],
      active: json['active'],
    );
  }
}
