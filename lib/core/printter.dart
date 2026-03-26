import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

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
      //image section must change to uint8List
      final ByteData data = await rootBundle.load('assets/logo/smile_logo.png');
      final Uint8List imageBytes = data.buffer.asUint8List();
      final img.Image? rawImage = img.decodeImage(imageBytes);
      final img.Image? image =
          rawImage != null ? img.copyResize(rawImage, width: 300) : null;

      if (image != null) bytes += generator.image(image);

      bytes += generator.text(
        "Soi Siam Restaurant",
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      );
      bytes += generator.text("66-5842111");
      bytes += generator.text(
          "Date : ${DateFormat.yMd().format(DateTime.now())} Time : ${DateFormat.Hms().format(DateTime.now())}");
      bytes += generator.hr();

      // Items
      for (final order in orders) {
        bytes += generator.row([
          PosColumn(
              text: "x${order.quantity} ${order.foodName}",
              width: 8,
              styles: PosStyles()),
          PosColumn(
            text: order.foodPrice.toStringAsFixed(2),
            width: 4,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      }

      bytes += generator.hr();

      bytes += generator.row([
        PosColumn(
          text: "TOTAL",
          width: 6,
          styles: const PosStyles(bold: true),
        ),
        PosColumn(
          text: orders
              .fold<double>(0, (sum, item) => sum + item.totalPrice)
              .toStringAsFixed(2),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
            bold: true,
          ),
        ),
      ]);

      // Footer
      bytes += generator.feed(2);
      bytes += generator.cut();

      // ✅ print ครั้งเดียว
      await service.printTicket(bytes);
    } finally {
      await service.disconnect();
    }
  }

  Widget buildReceiptWidget(
      {required List<OrderItem> orders, required GlobalKey repaintKey}) {
    return RepaintBoundary(
      key: repaintKey,
      child: ReceiptWidget(orders: orders),
    );
  }

  Future<Uint8List> capture(GlobalKey repaintKey) async {
    final boundary =
        repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  // print recept func
  Future<void> printWidgetReceipt({
    required PrinterConfig config,
    required GlobalKey repaintKey,
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
      //delay for wait capture widget
      await Future.delayed(Duration(milliseconds: 100));
      final captured = await capture(repaintKey);
      img.Image? image = img.decodeImage(captured);

      image = img.copyResize(image!, width: 384);

      List<int> bytes = [];
      bytes += generator.image(image);

      await service.printTicket(bytes);
    } finally {
      await service.disconnect();
    }
  }
}
