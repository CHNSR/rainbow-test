class SubFoodCategory {
  final String foodCatName;

  SubFoodCategory({required this.foodCatName});
  factory SubFoodCategory.fromJson(Map<String, dynamic> json) {
    return SubFoodCategory(foodCatName: json['foodCatName']);
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
