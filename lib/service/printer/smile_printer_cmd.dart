import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:driver_printer/command_printer.dart';
import 'package:driver_printer/driver_printer.dart';
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
      print(
          "📟 [CMD] connectNetwork - ip: $ip, port: $port, gateway: $gateway");
      cmdprinterservice = CommandPrinterService(
        connection: TcpPrinter(),
        cmd: EscPosCommand(),
      );
      final PrinterConfig data = PrinterConfig(
        type: "network",
        gateway: gateway,
        value: PrinterValue(ip: ip, port: port, data: PrinterData()),
      );
      print("📟 [CMD] Attempting to connect...");
      await cmdprinterservice.connect(data);
      print("✅ [CMD] Network connection successful");
      return true;
    } catch (e) {
      print("❌ [CMD] Connection Network failed: $e");
      return false;
    }
  }

  Future<bool> connectUsb(String deviceId) async {
    try {
      print("📟 [CMD] connectUsb - deviceId: $deviceId");
      cmdprinterservice = CommandPrinterService(
        connection: UsbPrinter(),
        cmd: EscPosCommand(),
      );
      final data = PrinterConfig(
        type: "usb",
        gateway: "",
        value: PrinterValue(
          usbName: deviceId,
          data: PrinterData(),
        ),
      );
      print("📟 [CMD] Attempting USB connection...");
      await cmdprinterservice.connect(data);
      print("✅ [CMD] USB connection successful");
      return true;
    } catch (e) {
      print("❌ [CMD] Connection USB failed: $e");
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
      // ⚡ Ensure connection first
      final useIp = config.hardwareTemplate?['useIp'] ?? true;
      bool connected = false;

      if (useIp) {
        connected = await connectNetwork(
            config.ip ?? "10.0.2.2",
            config.port ?? 9100,
            config.hardwareTemplate?['gateway'] ?? "esc_command");
      } else {
        connected = await connectUsb(config.hardwareTemplate?['usbName'] ?? "");
      }

      if (!connected) {
        return false;
      }

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

      await cmdprinterservice.printData(configPayload);

      await cmdprinterservice.disconnectPrinter();

      return true;
    } catch (e) {
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
    try {
      // Step 1️⃣: Get device IP

      final deviceIp = await getDeviceIpAddress();

      if (deviceIp == null) {
        print("❌ Could not find device IP address");
        return [];
      }

      // Step 2️⃣: Extract subnet
      final subnet = extractSubnet(deviceIp);

      // Step 3️⃣: Scan printers in that range

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

  // ==========================================
  // 6. Cash Drawer
  // ==========================================

  Future<void> openCashDrawer(app.PrinterConfig config) async {
    try {
      // 1. ตรวจสอบการเชื่อมต่อ
      final useIp = config.hardwareTemplate?['useIp'] ?? true;

      if (useIp) {
        // 🌐 กรณีใช้ IP (Network) สามารถใช้ Socket ส่งคำสั่ง Bytes ตรงๆ ได้เลย (ทำงานไวมาก)
        final socket = await Socket.connect(config.ip, config.port,
            timeout: const Duration(seconds: 3));
        socket.add([
          27,
          112,
          0,
          25,
          250
        ]); // 👈 ชุดคำสั่ง Bytes เตะลิ้นชัก (ESC p 0 25 250)
        await socket.flush();
        socket.destroy();
      } else {
        // 🔌 กรณีใช้ USB ต้องส่งผ่าน Plugin เพราะ Flutter สั่งยิง Bytes ออกพอร์ต USB ตรงๆ ยาก
        bool connected =
            await connectUsb(config.hardwareTemplate?['usbName'] ?? "");
        if (!connected) {
          return;
        }

        final configPayload = _buildConfig(
          config: config,
          data: PrinterData(
            sendOperation: SendOperation(buzzer: 1, cashDrawer: 1),
          ),
        );
        await cmdprinterservice.operation(configPayload);
        await cmdprinterservice.disconnectPrinter();
      }
    } catch (e) {
      print("❌ [CMD] Open cash drawer failed: $e");
    }
  }

  // ==========================================
  // 7. 🧪 Test Print Network
  // ==========================================

  // ==========================================
  // 8. 🔌 USB Scanner
  // ==========================================
  static Future<List<app.USBPrinterDevice>> scanUsbPrinters({
    PrinterGateway printer = PrinterGateway.custom,
  }) async {
    print("🔍 [CMD] Start scanning USB printers...");
    final List<app.USBPrinterDevice> results = [];

    try {
      final req = DiscoveryPrinter(
        gateway: 'discovery_printer',
        printer: printer,
        toUsb: true,
      );

      final response =
          await DriverPrinter().discoveryPrinter(jsonEncode(req.toJson()));

      Map<String, dynamic> decoded;
      try {
        decoded = jsonDecode(response as String) as Map<String, dynamic>;
      } catch (_) {
        decoded = {'result': []};
      }

      final printers = decoded['result'] as List? ?? [];
      print("✅ [CMD] Found ${printers.length} USB printers.");

      for (final printer in printers) {
        final model = printer['model'] ?? 'Unknown';
        final usbName = printer['usbName'] ?? 'Unknown USB Device';
        final gateway = printer['gateway'] ?? 'unknown';

        results.add(app.USBPrinterDevice(
          name: usbName,
          model: model,
          gateway: gateway,
        ));
      }
    } catch (e) {
      print("❌ [CMD] USB Scan error: $e");
    }

    return results;
  }
}
