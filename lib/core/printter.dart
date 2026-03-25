import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';

class PrinterService {
  Future<PrintResult> testPrintNetwork({
    required String ip,
    required int port,
    required String paperSize,
  }) async {
    if (ip.isEmpty) {
      return PrintResult(success: false, message: "IP is empty");
    }

    final service = FlutterThermalPrinterNetwork(ip, port: port);

    try {
      await service.connect();

      final profile = await CapabilityProfile.load();
      final generator = Generator(
        paperSize == "58" ? PaperSize.mm58 : PaperSize.mm80,
        profile,
      );

      List<int> bytes = [];

      bytes += generator.text(
        'TEST PRINTER',
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      );

      bytes += generator.hr();

      bytes += generator.text("Connection: SUCCESS");
      bytes += generator.text("IP: $ip");
      bytes += generator.text("Port: $port");
      bytes += generator.text("Time: ${DateTime.now()}");

      bytes += generator.feed(2);
      bytes += generator.cut();

      await service.printTicket(bytes);

      return PrintResult(success: true, message: "Print success");
    } catch (e) {
      return PrintResult(success: false, message: e.toString());
    } finally {
      await service.disconnect();
    }
  }

  Future<void> printRecept({
    required PrinterConfig config,
    required List<OrderItem> orders,
  }) async {
    final service = FlutterThermalPrinterNetwork(config.ip, port: config.port);
    try {
      await service.connect();

      final profile = await CapabilityProfile.load();
      final generator = Generator(
        config.paperSize == "58" ? PaperSize.mm58 : PaperSize.mm80,
        profile,
      );

      List<int> bytes = [];

      // Header
      bytes += generator.text(
        "Soi Siam Restaurant",
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      );

      bytes += generator.hr();

      //Order items
      for (final order in orders) {
        bytes += generator.row([
          PosColumn(text: "X${order.quantity.toString()}", width: 3),
          PosColumn(
            text: order.foodName,
            width: 9,
          ),
          PosColumn(
            text: order.foodPrice.toStringAsFixed(2),
            width: 3,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);

        bytes += generator.hr();

        // Total
        bytes += generator.row([
          PosColumn(
            text: "TOTAL",
            width: 6,
            styles: const PosStyles(bold: true),
          ),
          PosColumn(
            text: "price ${order.totalPrice.toStringAsFixed(2)}",
            width: 6,
            styles: const PosStyles(
              align: PosAlign.right,
              bold: true,
            ),
          ),
        ]);

        bytes += generator.feed(2);
        bytes += generator.cut();

        await service.printTicket(bytes);
      }
    } finally {
      await service.disconnect();
    }
  }
}
