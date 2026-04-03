import 'package:hive_ce/hive_ce.dart';

part 'order_item.g.dart';

@HiveType(
    typeId:
        12) // เปลี่ยนเป็น 12 เพื่อไม่ให้ซ้ำกับ PrintHistoryItem (ที่ใช้ 2 ไปแล้ว)
class OrderItem {
  @HiveField(0)
  final String foodSetId;

  @HiveField(1)
  final String foodId;

  @HiveField(2)
  final String foodName;

  @HiveField(3)
  final double foodPrice;

  @HiveField(4)
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
