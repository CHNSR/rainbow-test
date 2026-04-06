import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:convert';

import 'package:driver_printer/driver_printer.dart';
import 'package:driver_printer/driver_printer_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/config/export.dart' as app;

class SmilePrinterService {
  // ใช้งานแบบ Singleton Pattern เพื่อให้เรียก instance เดิมได้จากทุกที่ในแอป
  SmilePrinterService._();
  static final SmilePrinterService instance = SmilePrinterService._();

  DriverPrinter _smilePrinter = DriverPrinter();

  final List<Future<bool> Function()> _queue = [];
  bool _isProcessing = false;

  // ==========================================
  // 1. 🔌 หมวดการเชื่อมต่อ (Connection)
  // ==========================================
  Future<bool> connectNetwork(String ip, int port) async {
    try {
      final PrinterConfig data = PrinterConfig(
        type: "network",
        gateway:
            "posx", // สามารถปรับเป็น "epson", "star", "none" ตามที่ Plugin รองรับได้เลยครับ
        value: PrinterValue(
          ip: ip,
          data:
              PrinterData(), // จำเป็นต้องส่ง PrinterData ตามโครงสร้างของ Entity
        ),
      );
      await _smilePrinter.connect(data);
      return true;
    } catch (e) {
      print("❌ Connect Network Error: $e");
      return false;
    }
  }

  Future<void> disconnect() async {
    try {
      final PrinterConfig data = PrinterConfig(
        type: "network",
        gateway: "posx",
        value: PrinterValue(data: PrinterData()),
      );
      final String jsonData = jsonEncode(data.toJson());
      await _smilePrinter.disconnectPrinter(jsonData as PrinterConfig);
    } catch (e) {
      print("❌ Disconnect Error: $e");
    }
  }

  Future<bool> getConnectionStatus() async {
    return false;
  }

  // ==========================================
  // 2. 📝 หมวดควบคุมข้อความ (Text Formatting)
  // ==========================================
  Future<void> printText(String text,
      {bool isBold = false, String size = 'h1'}) async {
    try {
      // แปลงขนาด String เป็น int ตามความเหมาะสม (สามารถปรับตัวเลขได้เองครับ)
      int textSize = 14; // Default
      if (size == 'h1')
        textSize = 24;
      else if (size == 'h2')
        textSize = 20;
      else if (size == 'h3') textSize = 18;

      final PrinterConfig data = PrinterConfig(
        type: "text",
        gateway: "posx",
        value: PrinterValue(
          data: PrinterData(
            sendText: SendText(
              dataReceipt: [
                DataReceipt(
                  text: "$text\n",
                  isBold: isBold,
                  textSize: textSize,
                )
              ],
            ),
          ),
        ),
      );
      final String jsonData = jsonEncode(data.toJson());
      await _smilePrinter.printData(jsonData as PrinterConfig);
    } catch (e) {
      print("❌ Print Text Error: $e");
    }
  }

  Future<void> feedPaper(int lines) async {
    try {
      String feed = List.filled(lines, '\n').join();
      final PrinterConfig data = PrinterConfig(
        type: "text",
        gateway: "posx",
        value: PrinterValue(
          data: PrinterData(
            sendText: SendText(
              dataReceipt: [DataReceipt(text: feed)],
            ),
          ),
        ),
      );
      final String jsonData = jsonEncode(data.toJson());
      await _smilePrinter.printData(jsonData as PrinterConfig);
    } catch (e) {
      print("❌ Feed Paper Error: $e");
    }
  }

  // ==========================================
  // 3. 🖼️ หมวดกราฟิก (Graphics)
  // ==========================================
  Future<void> printImage(Uint8List bytes) async {
    try {
      final base64Image = base64Encode(bytes); // แปลง Uint8List เป็น String
      final PrinterConfig data = PrinterConfig(
        type: "image",
        gateway: "posx",
        value: PrinterValue(
          data: PrinterData(sendImage: base64Image),
        ),
      );
      final String jsonData = jsonEncode(data.toJson());
      await _smilePrinter.fullPrint(jsonData as PrinterConfig);
    } catch (e) {
      print("❌ Print Image Error: $e");
    }
  }

  // ==========================================
  // 4. ✂️ หมวดควบคุมฮาร์ดแวร์ (Hardware Actions)
  // ==========================================
  Future<void> cutPaper() async {
    try {
      final PrinterConfig data = PrinterConfig(
        type: "hardware",
        gateway: "posx",
        value: PrinterValue(
          cutPaper: 1, // ค่า 1 ใช้เพื่อสั่งตัดกระดาษ
          data: PrinterData(),
        ),
      );
      final String jsonData = jsonEncode(data.toJson());
      await _smilePrinter.printOperation(jsonData as PrinterConfig);
    } catch (e) {
      print("❌ Cut Paper Error: $e");
    }
  }

  // ==========================================
  // 5. 🛠️ God Mode (Raw Data)
  // ==========================================
  Future<void> sendRawBytes(List<int> bytes) async {
    // await _plugin.sendRawBytes(bytes);
  }

  // ==========================================
  // 6. 🖨️ หมวดการพิมพ์ใบเสร็จและแปลงจาก Myprinter (Migrated)
  // ==========================================

  /// ตรวจสอบการเชื่อมต่อ Printer ผ่าน IP และ Port (Ping)
  Future<bool> checkConnection(String ip, int port) async {
    try {
      final socket =
          await Socket.connect(ip, port, timeout: const Duration(seconds: 2));
      socket.destroy();
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==========================================
  // 6. 🖨️(High-Level Functions)
  // ==========================================

  /// สั่งพิมพ์ใบเสร็จทดสอบ (จากหน้า Config)
  Future<app.PrintResult> testPrintNetwork({
    required String ip,
    required int port,
    required String paperSize,
  }) async {
    if (ip.isEmpty) {
      return app.PrintResult(success: false, message: "IP is empty");
    }

    try {
      bool isOnline = await checkConnection(ip, port);
      if (!isOnline) throw 'ไม่สามารถเชื่อมต่อ $ip:$port';

      await connectNetwork(ip, port);

      await printText('TEST PRINTER', isBold: true, size: 'h1');
      await printText('--------------------------------');
      await printText("Connection: SUCCESS");
      await printText("IP: $ip");
      await printText("Port: $port");
      await printText("Time: ${DateTime.now()}");

      await feedPaper(3);
      await cutPaper();

      return app.PrintResult(success: true, message: "Print success");
    } catch (e) {
      return app.PrintResult(success: false, message: e.toString());
    } finally {
      await disconnect();
    }
  }

  /// สั่งพิมพ์ใบเสร็จรับเงิน / ใบเสร็จครัว (แบบ Text)
  Future<void> printReceipt({
    required app.PrinterConfig config,
    required List<app.OrderItem> orders,
  }) async {
    try {
      bool isOnline = await checkConnection(config.ip, config.port);
      if (!isOnline) throw 'ไม่สามารถเชื่อมต่อ ${config.ip}:${config.port}';

      await connectNetwork(config.ip, config.port);

      await printText("Soi Siam Restaurant", isBold: true, size: 'h2');
      await printText("Tel : 66-5842111");
      await printText(
          "Date : ${DateTime.now().toLocal().toString().substring(0, 16)}");
      await printText("--------------------------------");

      double total = 0;
      for (final order in orders) {
        // จัดเรียงข้อความให้พอดีบรรทัด (สามารถดึงค่าจาก Template ได้ในอนาคต)
        await printText(
            "${order.quantity}x ${order.foodName}  ${order.foodPrice.toStringAsFixed(2)}");
        total += order.totalPrice;
      }

      await printText("--------------------------------");
      await printText("TOTAL: \$${total.toStringAsFixed(2)}", isBold: true);

      await feedPaper(3);
      await cutPaper();
    } catch (e) {
      print("❌ Error printing receipt: $e");
    } finally {
      await disconnect();
    }
  }

  /// แปลง Widget เป็นรูปภาพ
  Future<Uint8List> capture(GlobalKey repaintKey) async {
    await WidgetsBinding.instance.endOfFrame;
    final context = repaintKey.currentContext;
    if (context == null) throw Exception("Context is null");

    final boundary = context.findRenderObject();
    if (boundary == null || boundary is! RenderRepaintBoundary) {
      throw Exception("Not a RepaintBoundary");
    }

    if (boundary.debugNeedsPaint) {
      await Future.delayed(const Duration(milliseconds: 50));
      return capture(repaintKey);
    }

    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) throw Exception("Failed to convert image");
    return byteData.buffer.asUint8List();
  }

  /// สั่งพิมพ์รูปภาพจาก Widget Capture (ใบเสร็จ Graphic)
  Future<bool> printWidgetReceipt({
    required app.PrinterConfig config,
    required GlobalKey repaintKey,
  }) async {
    try {
      bool isOnline = await checkConnection(config.ip, config.port);
      if (!isOnline) throw 'ไม่สามารถเชื่อมต่อ ${config.ip}:${config.port}';

      await connectNetwork(config.ip, config.port);
      await Future.delayed(const Duration(milliseconds: 120));

      final captured = await capture(repaintKey);

      await printImage(captured);
      await feedPaper(3);
      await cutPaper();

      return true;
    } catch (e) {
      print("❌ Print error: $e");
      return false;
    } finally {
      try {
        await disconnect();
      } catch (_) {}
    }
  }

  // ==========================================
  // 7. 🗂️ หมวดคิวงาน (Print Queue) - สำหรับส่งพิมพ์ออเดอร์พร้อมกัน
  // ==========================================
  Future<bool> addPrintJob(Future<bool> Function() job) async {
    final completer = Completer<bool>();

    _queue.add(() async {
      final result = await job();
      completer.complete(result);
      return result;
    });

    _processQueue();
    return completer.future;
  }

  Future<void> _processQueue() async {
    if (_isProcessing) return;
    _isProcessing = true;

    while (_queue.isNotEmpty) {
      final job = _queue.removeAt(0);
      try {
        await job();
      } catch (e) {
        print("Print job error: $e");
      }
    }

    _isProcessing = false;
  }

  // ==========================================
  // 8. 📡 หมวดแสกนหาปริ้นเตอร์ (Network Scanner)
  // ==========================================
  static Future<List<app.ScanPrinterDevice>> scanNetworkPrinters({
    required String subnet,
    List<int> ports = const [9100, 515, 631],
    int start = 1,
    int end = 254,
    Duration timeout = const Duration(milliseconds: 300),
    int concurrency = 50,
  }) async {
    final List<app.ScanPrinterDevice> results = [];
    final List<Future<void>> tasks = [];

    for (int i = start; i <= end; i++) {
      final ip = '$subnet.$i';
      tasks.add(_scanIp(ip, ports, timeout, results));

      if (tasks.length >= concurrency) {
        await Future.wait(tasks);
        tasks.clear();
      }
    }
    if (tasks.isNotEmpty) {
      await Future.wait(tasks);
    }
    return results;
  }

  static Future<void> _scanIp(String ip, List<int> ports, Duration timeout,
      List<app.ScanPrinterDevice> results) async {
    for (final port in ports) {
      try {
        final socket = await Socket.connect(ip, port, timeout: timeout);
        results.add(app.ScanPrinterDevice(ip: ip, port: port));
        socket.destroy();
        break;
      } catch (_) {}
    }
  }
}
