import 'package:hive_ce/hive_ce.dart';

part 'print_history.g.dart';

@HiveType(typeId: 1)
enum PrintStatus {
  @HiveField(0)
  success,
  @HiveField(1)
  fail,
  @HiveField(2)
  printing,
  @HiveField(3)
  waiting,
}

@HiveType(typeId: 2)
class PrintHistoryItem {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final double totalAmount;

  @HiveField(3)
  PrintStatus status;

  @HiveField(4)
  final String orderType;

  @HiveField(5)
  final List<Map<String, dynamic>> items;

  PrintHistoryItem({
    required this.id,
    required this.timestamp,
    required this.totalAmount,
    required this.status,
    required this.orderType,
    required this.items,
  });
}
