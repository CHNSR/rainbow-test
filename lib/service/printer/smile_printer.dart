import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:convert';
import 'package:driver_printer/driver_printer.dart';
import 'package:driver_printer/command_printer.dart';
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
  // 2. 📝 Helper Method: สำหรับสร้าง Config ส่งให้ Printer
  // ==========================================
  PrinterConfig _buildConfig({
    app.PrinterConfig? config,
    String? fallbackIp,
    required PrinterData data,
  }) {
    // ค่าตั้งต้น (Fallback Defaults)
    String gateway = 'posx';
    String model = 'generic';
    int timeout = 10000;
    int maxChar = 32;
    bool isThermal = true;
    String? ip = fallbackIp;
    String? usbName;
    int cutPaper = 1;
    String printerName = 'SmilePrinter';

    // ดึงการตั้งค่าระดับลึกจาก Hive Database
    if (config != null) {
      final extra = config.hardwareTemplate ?? {};
      gateway = extra['gateway'] ?? 'posx';
      model = extra['model'] ?? 'generic';
      timeout = int.tryParse(extra['timeout']?.toString() ?? '10000') ?? 10000;

      final defaultMaxChar = config.paperSize == "80" ? 48 : 32;
      maxChar = int.tryParse(
              extra['maxChar']?.toString() ?? defaultMaxChar.toString()) ??
          defaultMaxChar;

      isThermal = extra['isThermal'] ?? true;
      final useIp = extra['useIp'] ?? true;

      ip = useIp ? config.ip : null;
      usbName = !useIp ? config.ip : null;
      cutPaper = (config.isAutoCut ?? true) ? 1 : 0;
      printerName = config.name.isEmpty ? 'SmilePrinter' : config.name;
    }

    return PrinterConfig(
      gateway: gateway,
      value: PrinterValue(
        ip: ip,
        usbName: usbName,
        model: model,
        printerName: printerName,
        timeout: timeout,
        cutPaper: cutPaper,
        maxChar: maxChar,
        printerType: isThermal ? 'thermal' : 'dotMatrix',
        data: data,
      ),
    );
  }

  // ==========================================
  // 3. 🖨️ หมวดการพิมพ์ใบเสร็จและฟังก์ชันหลัก
  // ==========================================

  /// ตรวจสอบการเชื่อมต่อ Printer ผ่าน IP และ Port (Ping)
  Future<bool> checkConnection(String ip, int port) async {
    try {
      // ข้ามการ Ping เช็ค Socket หากเป็นชื่อ USB Device
      if (!ip.contains('.')) return true;

      final socket =
          await Socket.connect(ip, port, timeout: const Duration(seconds: 2));
      socket.destroy();
      return true;
    } catch (e) {
      return false;
    }
  }

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

      // สร้างรูปแบบใบเสร็จ (DataReceipt List)
      final List<DataReceipt> receiptLines = [
        DataReceipt(
            text: "TEST PRINTER",
            isBold: true,
            textSize: 24,
            alignment: 'center'),
        DataReceipt(
            text: "--------------------------------",
            alignment: 'left',
            textSize: 16),
        DataReceipt(
            text: "Connection: SUCCESS", alignment: 'left', textSize: 16),
        DataReceipt(text: "IP: $ip", alignment: 'left', textSize: 16),
        DataReceipt(text: "Port: $port", alignment: 'left', textSize: 16),
        DataReceipt(
            text: "Time: ${DateTime.now()}", alignment: 'left', textSize: 16),
        DataReceipt(
            text: "\n\n", alignment: 'left', textSize: 16), // Feed paper
      ];

      // รวมแพ็กเกจข้อมูล
      final configPayload = _buildConfig(
        fallbackIp: ip,
        data: PrinterData(
          sendText: SendText(dataReceipt: receiptLines),
        ),
      );

      // ส่งคำสั่งทีเดียวจบแบบ Lifecycle ของ Plugin
      await _smilePrinter.connect(configPayload);
      await _smilePrinter.printData(configPayload);
      await _smilePrinter.disconnectPrinter(configPayload);

      return app.PrintResult(success: true, message: "Print success");
    } catch (e) {
      return app.PrintResult(success: false, message: e.toString());
    }
  }

  /// สั่งทดสอบ Operation (เช่น ตัดกระดาษ, เปิดลิ้นชัก)
  Future<app.PrintResult> testOperationNetwork({
    required String ip,
    required int port,
  }) async {
    if (ip.isEmpty) {
      return app.PrintResult(success: false, message: "IP is empty");
    }

    try {
      bool isOnline = await checkConnection(ip, port);
      if (!isOnline) throw 'ไม่สามารถเชื่อมต่อ $ip:$port';

      final configPayload = _buildConfig(
        fallbackIp: ip,
        data: PrinterData(
          sendOperation: SendOperation(buzzer: 0, cashDrawer: 0),
        ),
      );

      await _smilePrinter.connect(configPayload);
      await _smilePrinter.printOperation(configPayload);
      await _smilePrinter.disconnectPrinter(configPayload);

      return app.PrintResult(success: true, message: "Operation success");
    } catch (e) {
      return app.PrintResult(success: false, message: e.toString());
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

      final List<DataReceipt> receiptLines = [];

      receiptLines.add(DataReceipt(
          text: "Soi Siam Restaurant",
          isBold: true,
          textSize: 20,
          alignment: 'center'));
      receiptLines.add(DataReceipt(
          text: "Tel : 66-5842111", alignment: 'center', textSize: 16));
      receiptLines.add(DataReceipt(
          text:
              "Date : ${DateTime.now().toLocal().toString().substring(0, 16)}",
          alignment: 'left',
          textSize: 16));
      receiptLines.add(DataReceipt(
          text: "--------------------------------",
          alignment: 'left',
          textSize: 16));

      double total = 0;
      for (final order in orders) {
        receiptLines.add(DataReceipt(
            text:
                "${order.quantity}x ${order.foodName}  \$${order.foodPrice.toStringAsFixed(2)}",
            alignment: 'left',
            textSize: 16));
        total += order.totalPrice;
      }

      receiptLines.add(DataReceipt(
          text: "--------------------------------",
          alignment: 'left',
          textSize: 16));

      // ตรวจสอบเงื่อนไข Print Price หากเป็น false จะซ่อนยอดรวม
      if (config.printPrice ?? true) {
        receiptLines.add(DataReceipt(
            text: "TOTAL: \$${total.toStringAsFixed(2)}",
            isBold: true,
            alignment: 'right',
            textSize: 18));
      }

      receiptLines.add(DataReceipt(
          text: "\n\n", alignment: 'left', textSize: 16)); // Feed paper

      final configPayload = _buildConfig(
        config: config,
        data: PrinterData(
            sendText: SendText(dataReceipt: receiptLines),
            sendOperation: SendOperation(
                buzzer: (config.isBeep ?? false) ? 1 : 0,
                cashDrawer: 0)), // ตรวจสอบเสียงเตือน
      );

      final useNative = config.hardwareTemplate?['useNative'] ?? true;
      final useIp = config.hardwareTemplate?['useIp'] ?? true;

      if (useNative) {
        await _smilePrinter.connect(configPayload);
        await _smilePrinter.printData(configPayload);
        await _smilePrinter.disconnectPrinter(configPayload);
      } else {
        final escService = CommandPrinterService(
          cmd: EscPosCommand(),
          connection: useIp ? TcpPrinter() : UsbPrinter(),
        );
        await escService.connect(configPayload);
        await escService.printData(configPayload);
        await escService.disconnectPrinter();
      }
    } catch (e) {
      print("❌ Error printing receipt: $e");
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

    // ⚠️ ลดขนาดภาพเพื่อไม่ให้ Buffer เครื่องปริ้นเต็ม (1.5 คมชัดพอดีกระดาษ)
    final image = await boundary.toImage(pixelRatio: 1.5);
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
      await Future.delayed(const Duration(milliseconds: 120));

      final captured = await capture(repaintKey);
      final base64Image = base64Encode(captured);

      final configPayload = _buildConfig(
        config: config,
        data: PrinterData(
          sendImage: base64Image,
          sendOperation: SendOperation(
              buzzer: (config.isBeep ?? false) ? 1 : 0,
              cashDrawer: 0), // ตรวจสอบเสียงเตือน
        ),
      );

      final useNative = config.hardwareTemplate?['useNative'] ?? true;
      final useIp = config.hardwareTemplate?['useIp'] ?? true;

      if (useNative) {
        await _smilePrinter.connect(configPayload);
        await _smilePrinter.printData(configPayload);
        await _smilePrinter.disconnectPrinter(configPayload);
      } else {
        final escService = CommandPrinterService(
          cmd: EscPosCommand(),
          connection: useIp ? TcpPrinter() : UsbPrinter(),
        );
        await escService.connect(configPayload);
        await escService.printData(configPayload);
        await escService.disconnectPrinter();
      }

      return true;
    } catch (e) {
      print("❌ Print error: $e");
      return false;
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
