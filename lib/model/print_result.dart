import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive_ce.dart';

part 'print_result.g.dart';

class PrintResult {
  final bool success;
  final String message;

  PrintResult({required this.success, required this.message});
}

@HiveType(typeId: 0)
class PrinterConfig extends Equatable {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String ip;
  @HiveField(2)
  final int port;
  @HiveField(3)
  final String paperSize;
  @HiveField(4)
  final String category; // kitchen / cashier

  const PrinterConfig({
    required this.name,
    required this.ip,
    required this.port,
    required this.paperSize,
    required this.category,
  });

  @override
  List<Object?> get props => [name, ip, port, paperSize, category];
}

class ScanPrinterDevice {
  final String ip;
  final int port;

  ScanPrinterDevice({
    required this.ip,
    required this.port,
  });

  @override
  String toString() => '$ip:$port';
}
