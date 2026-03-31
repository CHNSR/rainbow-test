import 'package:equatable/equatable.dart';

class PrintResult {
  final bool success;
  final String message;

  PrintResult({required this.success, required this.message});
}

class PrinterConfig extends Equatable {
  final String name;
  final String ip;
  final int port;
  final String paperSize;
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
