class OrderItem {
  final String foodSetId;
  final String foodId;
  final String foodName;
  final double foodPrice;
  final int quantity;

  const OrderItem({
    required this.foodSetId,
    required this.foodId,
    required this.foodName,
    required this.foodPrice,
    required this.quantity,
  });

  double get totalPrice => foodPrice * quantity;

  // ใช้สำหรับ copyWith
  OrderItem copyWith({
    String? foodSetId,
    String? foodId,
    String? foodName,
    double? foodPrice,
    int? quantity,
  }) {
    return OrderItem(
      foodSetId: foodSetId ?? this.foodSetId,
      foodId: foodId ?? this.foodId,
      foodName: foodName ?? this.foodName,
      foodPrice: foodPrice ?? this.foodPrice,
      quantity: quantity ?? this.quantity,
    );
  }
}
