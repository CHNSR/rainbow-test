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
  @HiveField(5)
  final Map<String, dynamic>? textTemplate;
  @HiveField(6)
  final Map<String, dynamic>? hardwareTemplate;
  @HiveField(7)
  final Map<String, dynamic>? graphicsTemplate;
  @HiveField(8)
  final bool? isAutoCut;
  @HiveField(9)
  final bool? isBeep;
  @HiveField(10)
  final bool? printPrice;

  const PrinterConfig({
    required this.name,
    required this.ip,
    required this.port,
    required this.paperSize,
    required this.category,
    this.textTemplate,
    this.hardwareTemplate,
    this.graphicsTemplate,
    this.isAutoCut,
    this.isBeep,
    this.printPrice,
  });

  @override
  List<Object?> get props => [
        name,
        ip,
        port,
        paperSize,
        category,
        textTemplate,
        hardwareTemplate,
        graphicsTemplate,
        isAutoCut,
        isBeep,
        printPrice,
      ];
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
