import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:driver_printer/command_printer.dart';
import 'package:driver_printer/driver_printer_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/config/export.dart' as app;

class SmailePrinterCmd {
  late final CommandPrinterService cmdprinterservice;

  SmailePrinterCmd._();
  static final SmailePrinterCmd instance = SmailePrinterCmd._();

  final List<Future<bool> Function()> _queue = [];
  bool _isProcessing = false;

  // ==========================================
  // 1. 🔌 Connection Methods
  // ==========================================

  Future<bool> connectNetwork(String ip, int port, String gateway) async {
    try {
      cmdprinterservice = CommandPrinterService(
        connection: TcpPrinter(),
        cmd: EscPosCommand(),
      );
      final PrinterConfig data = PrinterConfig(
        type: "network",
        gateway: gateway,
        value: PrinterValue(ip: ip, data: PrinterData()),
      );
      await cmdprinterservice.connect(data);
      return true;
    } catch (e) {
      print("❌ Connection Network failed: $e");
      return false;
    }
  }

  Future<bool> connectUsb(String deviceId) async {
    try {
      cmdprinterservice = CommandPrinterService(
        connection: UsbPrinter(),
        cmd: EscPosCommand(),
      );
      final data = PrinterConfig(
        type: "usb",
        gateway: "",
        value: PrinterValue(usbName: deviceId, data: PrinterData()),
      );
      await cmdprinterservice.connect(data);
      return true;
    } catch (e) {
      print("❌ Connection USB failed: $e");
      return false;
    }
  }

  Future<void> writeUsbData(Uint8List data) async {
    try {
      final configPayload = PrinterConfig(
        type: "usb",
        gateway: "",
        value: PrinterValue(
          data: PrinterData(
            sendText: SendText(dataReceipt: []),
          ),
        ),
      );
      await cmdprinterservice.printData(configPayload);
    } catch (e) {
      print("Write USB data failed: $e");
    }
  }

  Future<void> disconnectUsbPrinter() async {
    try {
      await cmdprinterservice.disconnectPrinter();
    } catch (e) {
      print("Disconnect USB printer failed: $e");
    }
  }

  Future<void> disconnectNetworkPrinter() async {
    try {
      await cmdprinterservice.disconnectPrinter();
    } catch (e) {
      print("Disconnect Network printer failed: $e");
    }
  }

  // ==========================================
  // 2. 📝 Config Builder
  // ==========================================

  PrinterConfig _buildConfig({
    app.PrinterConfig? config,
    String? fallbackIp,
    required PrinterData data,
  }) {
    String gateway = 'posx';
    String model = 'generic';
    int timeout = 5000;
    int maxChar = 32;
    String? ip = fallbackIp;
    String? usbName;
    int cutPaper = 1;
    String printerName = 'SmilePrinter';

    if (config != null) {
      final extra = config.hardwareTemplate ?? {};
      gateway = extra['gateway'] ?? 'posx';
      model = extra['model'] ?? 'generic';
      timeout = int.tryParse(extra['timeout']?.toString() ?? '5000') ?? 5000;

      final defaultMaxChar = config.paperSize == "80" ? 48 : 32;
      maxChar = int.tryParse(
              extra['maxChar']?.toString() ?? defaultMaxChar.toString()) ??
          defaultMaxChar;

      final useIp = extra['useIp'] ?? true;
      ip = useIp ? config.ip : null;
      usbName = !useIp ? (extra['usbName'] ?? config.ip) : null;
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
        printerType: 'thermal',
        data: data,
      ),
    );
  }

  // ==========================================
  // 3. 🖨️ Print Methods
  // ==========================================

  Future<Uint8List> convertWidgetToImageBytes(GlobalKey repaintKey) async {
    await WidgetsBinding.instance.endOfFrame;
    final context = repaintKey.currentContext;
    if (context == null) throw Exception("Context is null");
    final boundary = context.findRenderObject();
    if (boundary == null || boundary is! RenderRepaintBoundary) {
      throw Exception("Not a RepaintBoundary");
    }

    if (boundary.debugNeedsPaint) {
      await Future.delayed(const Duration(milliseconds: 50));
      return convertWidgetToImageBytes(repaintKey);
    }

    final image = await boundary.toImage(pixelRatio: 1.5);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) throw Exception("Failed to convert image");
    return byteData.buffer.asUint8List();
  }

  Future<bool> printWidgetReceipt({
    required app.PrinterConfig config,
    required GlobalKey repaintKey,
  }) async {
    try {
      final captured = await convertWidgetToImageBytes(repaintKey);
      final base64Image = base64Encode(captured);

      final configPayload = _buildConfig(
        config: config,
        data: PrinterData(
          sendImage: base64Image,
          sendOperation: SendOperation(
            buzzer: (config.isBeep ?? false) ? 1 : 0,
            cashDrawer: 0,
          ),
        ),
      );

      await cmdprinterservice.connect(configPayload);
      await cmdprinterservice.printData(configPayload);
      await cmdprinterservice.disconnectPrinter();

      return true;
    } catch (e) {
      print("Print widget receipt failed: $e");
      return false;
    }
  }

  // ==========================================
  // 4. 🗂️ Print Queue
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
    if (_isProcessing || _queue.isEmpty) return;
    _isProcessing = true;

    while (_queue.isNotEmpty) {
      final job = _queue.removeAt(0);
      try {
        await job();
      } catch (e) {
        print("Print job failed: $e");
      }
    }
    _isProcessing = false;
  }

  // ==========================================
  // 5. 📡 Network Scanner - Auto & Easy
  // ==========================================

  /// 🔍 Get device current IP address
  Future<String?> getDeviceIpAddress() async {
    try {
      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4 &&
              !addr.address.startsWith('127.')) {
            return addr.address;
          }
        }
      }
      return null;
    } catch (e) {
      print("❌ Error getting device IP: $e");
      return null;
    }
  }

  /// 📊 Extract subnet from IP address
  /// Example: 192.168.1.100 → 192.168.1
  String extractSubnet(String ipAddress) {
    final parts = ipAddress.split('.');
    if (parts.length != 4) return "192.168.1";
    return '${parts[0]}.${parts[1]}.${parts[2]}';
  }

  /// 🎯 Automatic Network Printer Scan (Easy for users)
  /// - No need to enter IP address manually
  /// - Auto detects WiFi subnet
  /// - Scans wide range (1-254)
  Future<List<app.ScanPrinterDevice>> scanNetworkPrintersAutomatic({
    Duration timeout = const Duration(milliseconds: 300),
    int concurrency = 50,
    void Function(int)? onProgress,
  }) async {
    print("🔍 [SmailePrinterCmd] Starting automatic network scan...");

    try {
      // Step 1️⃣: Get device IP
      print("⏳ Step 1/2: Detecting device IP address...");
      final deviceIp = await getDeviceIpAddress();

      if (deviceIp == null) {
        print("❌ Could not find device IP address");
        return [];
      }

      print("✅ Found device IP: $deviceIp");

      // Step 2️⃣: Extract subnet
      final subnet = extractSubnet(deviceIp);
      print("✅ Using subnet: $subnet.x");

      // Step 3️⃣: Scan printers in that range
      print("🔎 Step 2/2: Scanning printers in range $subnet.1-254...");
      final results = await scanNetworkPrinters(
        subnet: subnet,
        timeout: timeout,
        concurrency: concurrency,
        onProgress: onProgress,
      );

      print("🎉 Scan complete! Found ${results.length} printer(s)");
      return results;
    } catch (e) {
      print("❌ Error during automatic scan: $e");
      return [];
    }
  }

  /// 📡 Manual Network Printer Scan
  /// Use when you know your subnet
  Future<List<app.ScanPrinterDevice>> scanNetworkPrinters({
    required String subnet,
    List<int> ports = const [9100, 515, 631],
    int start = 1,
    int end = 254,
    Duration timeout = const Duration(milliseconds: 300),
    int concurrency = 50,
    void Function(int)? onProgress,
  }) async {
    final List<app.ScanPrinterDevice> results = [];
    final List<Future<void>> tasks = [];
    int scannedCount = 0;

    for (int i = start; i <= end; i++) {
      final ip = '$subnet.$i';
      tasks.add(_scanIp(ip, ports, timeout, results, () {
        scannedCount++;
        onProgress?.call(scannedCount);
      }));

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

  /// 🔍 Scan single IP address
  static Future<void> _scanIp(
    String ip,
    List<int> ports,
    Duration timeout,
    List<app.ScanPrinterDevice> results,
    VoidCallback onComplete,
  ) async {
    for (final port in ports) {
      try {
        final socket = await Socket.connect(ip, port, timeout: timeout);
        results.add(app.ScanPrinterDevice(ip: ip, port: port));
        socket.destroy();
        break;
      } catch (_) {
        // Port not responding
      }
    }
    onComplete();
  }
}


// class SmailePrinterCmd2 {
//   late final CommandPrinterService cmdprinterservice;

//   final List<Future<bool> Function()> _queue = [];
//   bool _isProcessing = false;

//   // 1 connection
//   Future<bool> connectNetwork(String ip, int port, String getway) async {
//     try {
//       cmdprinterservice = CommandPrinterService(
//         connection: TcpPrinter(),
//         cmd: EscPosCommand(),
//       );
//       final PrinterConfig data = PrinterConfig(
//           type: "network",
//           gateway: getway,
//           value: PrinterValue(ip: ip, data: PrinterData()));
//       await cmdprinterservice.connect(data);
//       return true;
//     } catch (e) {
//       print({Future.error("Connection Network failed: $e")});
//       return false;
//     }
//   }

//   Future<bool> connectUsb(String deviceId) async {
//     try {
//       cmdprinterservice = CommandPrinterService(
//         connection: UsbPrinter(),
//         cmd: EscPosCommand(),
//       );
//       final data = PrinterConfig(
//           type: "usb",
//           gateway: "",
//           value: PrinterValue(usbName: deviceId, data: PrinterData()));
//       await cmdprinterservice.connect(data);
//       return true;
//     } catch (e) {
//       print({Future.error("Connection USB failed: $e")});
//       return false;
//     }
//   }

//   Future<void> writeUsbData(Uint8List data) async {
//     try {
//       final configPayload = PrinterConfig(
//         type: "usb",
//         gateway: "",
//         value: PrinterValue(
//           data: PrinterData(
//             sendText: SendText(dataReceipt: []),
//           ),
//         ),
//       );
//       await cmdprinterservice.printData(configPayload);
//     } catch (e) {
//       print("Write USB data failed: $e");
//     }
//   }

//   Future<void> disconnectUsbPrinter() async {
//     try {
//       await cmdprinterservice.disconnectPrinter();
//     } catch (e) {
//       print("Disconnect USB printer failed: $e");
//     }
//   }

//   Future<void> disconnectNetworkPrinter() async {
//     try {
//       await cmdprinterservice.disconnectPrinter();
//     } catch (e) {
//       print("Disconnect Network printer failed: $e");
//     }
//   }

//   PrinterConfig _buildConfig({
//     app.PrinterConfig? config,
//     String? fallbackIp,
//     required PrinterData data,
//   }) {
//     // ค่าตั้งต้น (Fallback Defaults)
//     String gateway = 'posx';
//     String model = 'generic';
//     int timeout = 5000;
//     int maxChar = 32;
//     bool isThermal = true;
//     String? ip = fallbackIp;
//     String? usbName;
//     int cutPaper = 1;
//     String printerName = 'SmilePrinter';

//     // ดึงการตั้งค่าระดับลึกจาก Hive Database
//     if (config != null) {
//       final extra = config.hardwareTemplate ?? {};
//       gateway = extra['gateway'] ?? 'posx';
//       model = extra['model'] ?? 'generic';
//       timeout = int.tryParse(extra['timeout']?.toString() ?? '5000') ?? 5000;

//       final defaultMaxChar = config.paperSize == "80" ? 48 : 32;
//       maxChar = int.tryParse(
//               extra['maxChar']?.toString() ?? defaultMaxChar.toString()) ??
//           defaultMaxChar;

//       isThermal = extra['isThermal'] ?? true;
//       final useIp = extra['useIp'] ?? true;

//       ip = useIp ? config.ip : null;
//       usbName = !useIp ? (extra['usbName'] ?? config.ip) : null;
//       cutPaper = (config.isAutoCut ?? true) ? 1 : 0;
//       printerName = config.name.isEmpty ? 'SmilePrinter' : config.name;
//     }

//     return PrinterConfig(
//       gateway: gateway,
//       value: PrinterValue(
//         ip: ip,
//         usbName: usbName,
//         model: model,
//         printerName: printerName,
//         timeout: timeout,
//         cutPaper: cutPaper,
//         maxChar: maxChar,
//         printerType: isThermal ? 'thermal' : 'dotMatrix',
//         data: data,
//       ),
//     );
//   }

//   // ==========================================
//   // 3. 🖨️ หมวดการพิมพ์ใบเสร็จและฟังก์ชันหลัก
//   // ==========================================
//   Future<Uint8List> convertWidgetToImageBytes(GlobalKey repaintKey) async {
//     // Implementation for converting widget to image bytes
//     await WidgetsBinding.instance.endOfFrame;
//     final context = repaintKey.currentContext;
//     if (context == null) throw Exception("Context is null");
//     final boundary = context.findRenderObject();
//     if (boundary == null || boundary is! RenderRepaintBoundary) {
//       throw Exception("Not a RepaintBoundary");
//     }

//     if (boundary.debugNeedsPaint) {
//       await Future.delayed(const Duration(milliseconds: 50));
//       return convertWidgetToImageBytes(repaintKey);
//     }

//     // ⚠️ ลดขนาดภาพเพื่อไม่ให้ Buffer เครื่องปริ้นเต็ม (1.5 คมชัดพอดีกระดาษ)
//     final image = await boundary.toImage(pixelRatio: 1.5);
//     final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

//     if (byteData == null) throw Exception("Failed to convert image");
//     return byteData.buffer.asUint8List();
//   }

//   Future<bool> printWidgetReciept({
//     required app.PrinterConfig config,
//     required GlobalKey repaintKey,
//   }) async {
//     try {
//       final captured = await convertWidgetToImageBytes(repaintKey);
//       final base64Image = base64Encode(captured);
//       // Proceed with printing using the base64Image
//       final configPayload = _buildConfig(
//         config: config,
//         data: PrinterData(
//           sendImage: base64Image,
//           sendOperation: SendOperation(
//               buzzer: (config.isBeep ?? false) ? 1 : 0,
//               cashDrawer: 0), // ตรวจสอบเสียงเตือน
//         ),
//       );

//       final useNative = config.hardwareTemplate?['useNative'] ?? true;

//       if (useNative) {
//         await cmdprinterservice.connect(configPayload);
//         await cmdprinterservice.printData(configPayload);
//         await cmdprinterservice.disconnectPrinter();
//       } else {
//         await cmdprinterservice.connect(configPayload);
//         await cmdprinterservice.printData(configPayload);
//         await cmdprinterservice.disconnectPrinter();
//       }

//       return true;
//     } catch (e) {
//       print("Print widget receipt failed: $e");
//       return false;
//     }
//   }

//   // ==========================================
//   // 7. 🗂️ หมวดคิวงาน (Print Queue) - สำหรับส่งพิมพ์ออเดอร์พร้อมกัน
//   // ==========================================

//   Future<bool> addPrintJob(Future<bool> Function() job) async {
//     final completer = Completer<bool>();
//     _queue.add(() async {
//       final result = await job();
//       completer.complete(result);
//       return result;
//     });
//     _processQueue();
//     return completer.future;
//   }

//   Future<void> _processQueue() async{
//     if (_isProcessing || _queue.isEmpty) return;
//     _isProcessing = true;

//     while(_queue.isEmpty) {
//       final job = _queue.removeAt(0);
//       try {
//         await job();
//       } catch (e){
//         throw("Print job failed: $e");
//       }
      
//     }
//     _isProcessing = false;
//   }

//   // ==========================================
//   // 5. 📡 หมวดแสกนหาปริ้นเตอร์ (Network Scanner)
//   // ==========================================
//   static Future<List<app.ScanPrinterDevice>> scanNetworkPrinters({
//     required List<int> ports,
//     String subnet = '192.168.1',
//     int concurrency = 50,
//     Duration timeout = const Duration(milliseconds: 300),
//   }) async {
//     final List<app.ScanPrinterDevice> results = [];
//     final List<Future<void>> tasks = [];
//     for 
    
// })




// }


