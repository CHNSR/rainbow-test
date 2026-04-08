import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive_ce.dart';

part 'receipt.g.dart';

@HiveType(typeId: 10) // เลือก typeId ที่ยังไม่ซ้ำในระบบของคุณ
class Receipt extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final double totalAmount;

  @HiveField(3)
  final String orderType;

  @HiveField(4)
  final List<ReceiptItem> items;

  @HiveField(5, defaultValue: 'Success')
  final String status;

  @HiveField(6, defaultValue: [])
  final List<Map<String, dynamic>> printer;

  const Receipt({
    required this.id,
    required this.date,
    required this.totalAmount,
    required this.orderType,
    required this.items,
    required this.status,
    required this.printer,
  });

  @override
  List<Object?> get props => [
        id,
        date,
        totalAmount,
        orderType,
        items,
        status,
        printer,
      ];
}

@HiveType(typeId: 7) // เลือก typeId ที่ยังไม่ซ้ำในระบบของคุณ
class ReceiptItem extends Equatable {
  @HiveField(0)
  final String foodName;

  @HiveField(1)
  final double foodPrice;

  @HiveField(2)
  final int quantity;

  const ReceiptItem({
    required this.foodName,
    required this.foodPrice,
    required this.quantity,
  });

  @override
  List<Object?> get props => [foodName, foodPrice, quantity];
}
