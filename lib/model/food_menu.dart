class FoodMenu {
  final String foodId;
  final String foodName;
  final String? foodNameAlt;
  final double foodPrice;
  final String? foodDesc;
  final int foodSorting;
  final bool active;
  final String foodSetId;
  final String foodCatId;
  final String imageName;
  final bool isOutStock;
  final bool isFree;
  final bool isShow;

  FoodMenu({
    required this.foodId,
    required this.foodName,
    required this.foodPrice,
    required this.foodSorting,
    required this.active,
    required this.foodSetId,
    required this.foodCatId,
    required this.imageName,
    required this.isOutStock,
    required this.isFree,
    required this.isShow,
    this.foodNameAlt,
    this.foodDesc,
  });

  factory FoodMenu.fromJson(Map<String, dynamic> json) {
    return FoodMenu(
      foodId: json['foodId'],
      foodName: json['foodName'],
      foodNameAlt: json['foodNameAlt'],
      foodPrice: (json['foodPrice'] as num).toDouble(),
      foodDesc: json['foodDesc'],
      foodSorting: json['foodSorting'],
      active: json['active'],
      foodSetId: json['foodSetId'],
      foodCatId: json['foodCatId'],
      imageName: json['imageName'],
      isOutStock: json['isOutStock'],
      isFree: json['isFree'],
      isShow: json['isShow'],
    );
  }
}
