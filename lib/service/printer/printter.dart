// import 'dart:async';
// import 'dart:io';
// import 'dart:ui';

// import 'package:barcode_widget/barcode_widget.dart' as bw;
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_application_1/config/export.dart';
// import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
// import 'package:flutter_thermal_printer/utils/printer.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/services.dart';
// import 'package:image/image.dart' as img;

// class PrinterService {
//   final List<Future<bool> Function()> _queue = [];
//   bool _isProcessing = false;

//   Future<PrintResult> testPrintNetwork({
//     required String ip,
//     required int port,
//     required String paperSize,
//   }) async {
//     if (ip.isEmpty) {
//       return PrintResult(success: false, message: "IP is empty");
//     }

//     final service = FlutterThermalPrinterNetwork(ip, port: port);

//     try {
//       await service.connect();

//       final profile = await CapabilityProfile.load();
//       final generator = Generator(
//         paperSize == "58" ? PaperSize.mm58 : PaperSize.mm80,
//         profile,
//       );

//       List<int> bytes = [];

//       bytes += generator.text(
//         'TEST PRINTER',
//         styles: const PosStyles(
//           align: PosAlign.center,
//           bold: true,
//           height: PosTextSize.size2,
//           width: PosTextSize.size2,
//         ),
//       );

//       bytes += generator.hr();

//       bytes += generator.text("Connection: SUCCESS");
//       bytes += generator.text("IP: $ip");
//       bytes += generator.text("Port: $port");
//       bytes += generator.text("Time: ${DateTime.now()}");

//       bytes += generator.feed(2);
//       bytes += generator.cut();

//       await service.printTicket(bytes);

//       return PrintResult(success: true, message: "Print success");
//     } catch (e) {
//       return PrintResult(success: false, message: e.toString());
//     } finally {
//       await service.disconnect();
//     }
//   }

//   Future<void> printRecept({
//     required PrinterConfig config,
//     required List<OrderItem> orders,
//   }) async {
//     // ✅ Wraps the entire operation in a try-catch block for robust error handling.
//     final service = FlutterThermalPrinterNetwork(config.ip, port: config.port);
//     try {
//       await service.connect();

//       final profile = await CapabilityProfile.load();
//       final generator = Generator(
//         config.paperSize == "58" ? PaperSize.mm58 : PaperSize.mm80,
//         profile,
//       );

//       List<int> bytes = [];

//       // Header
//       //image section must change to uint8List
//       final ByteData data = await rootBundle.load('assets/logo/smile_logo.png');
//       final Uint8List imageBytes = data.buffer.asUint8List();
//       final img.Image? rawImage = img.decodeImage(imageBytes);
//       final img.Image? image =
//           rawImage != null ? img.copyResize(rawImage, width: 300) : null;

//       if (image != null) bytes += generator.image(image);

//       bytes += generator.text(
//         "Soi Siam Restaurant",
//         styles: const PosStyles(
//           align: PosAlign.center,
//           bold: true,
//           height: PosTextSize.size2,
//           width: PosTextSize.size2,
//         ),
//       );
//       bytes += generator.text("66-5842111");
//       bytes += generator.text(
//           "Date : ${DateFormat.yMd().format(DateTime.now())} Time : ${DateFormat.Hms().format(DateTime.now())}");
//       bytes += generator.hr();

//       // Items
//       for (final order in orders) {
//         bytes += generator.row([
//           PosColumn(
//               text: "x${order.quantity} ${order.foodName}",
//               width: 8,
//               styles: PosStyles()),
//           PosColumn(
//             text: order.foodPrice.toStringAsFixed(2),
//             width: 4,
//             styles: const PosStyles(align: PosAlign.right),
//           ),
//         ]);
//       }

//       bytes += generator.hr();

//       bytes += generator.row([
//         PosColumn(
//           text: "TOTAL",
//           width: 6,
//           styles: const PosStyles(bold: true),
//         ),
//         PosColumn(
//           text: orders
//               .fold<double>(0, (sum, item) => sum + item.totalPrice)
//               .toStringAsFixed(2),
//           width: 6,
//           styles: const PosStyles(
//             align: PosAlign.right,
//             bold: true,
//           ),
//         ),
//       ]);

//       // Footer
//       bytes += generator.feed(2);
//       bytes += generator.cut();

//       // ✅ print ครั้งเดียว
//       await service.printTicket(bytes);
//     } catch (e) {
//       // ✅ Logs any errors that occur during the printing process.
//       print("❌ Error printing receipt: $e");
//     } finally {
//       // ✅ Ensures the printer connection is always disconnected.
//       await service.disconnect();
//     }
//   }

//   Future<Uint8List> capture(GlobalKey repaintKey) async {
//     // ✅ รอ frame render เสร็จจริง ๆ
//     await WidgetsBinding.instance.endOfFrame;

//     final context = repaintKey.currentContext;

//     if (context == null) {
//       throw Exception("Context is null");
//     }

//     final boundary = context.findRenderObject();

//     if (boundary == null || boundary is! RenderRepaintBoundary) {
//       throw Exception("Not a RepaintBoundary");
//     }

//     // ✅ กัน paint ยังไม่เสร็จ
//     if (boundary.debugNeedsPaint) {
//       await Future.delayed(const Duration(milliseconds: 50));
//       return capture(repaintKey); // retry
//     }

//     final image = await boundary.toImage(pixelRatio: 3);
//     final byteData = await image.toByteData(format: ImageByteFormat.png);

//     if (byteData == null) {
//       throw Exception("Failed to convert image");
//     }

//     return byteData.buffer.asUint8List();
//   }

//   Future<bool> printWidgetReceipt({
//     required PrinterConfig config,
//     required GlobalKey repaintKey,
//   }) async {
//     print(
//         "[printWidgetReceipt] show config: ${config.ip}:${config.port}, paperSize: ${config.paperSize}");
//     final service = FlutterThermalPrinterNetwork(
//       config.ip,
//       port: config.port,
//     );

//     try {
//       /// 2. LOAD PROFILE
//       final profile = await CapabilityProfile.load();
//       final generator = Generator(
//         config.paperSize == "58" ? PaperSize.mm58 : PaperSize.mm80,
//         profile,
//       );

//       final targetWidth = config.paperSize == "58" ? 384 : 576;

//       /// 3. CAPTURE WIDGET
//       await Future.delayed(const Duration(milliseconds: 120));

//       final captured = await capture(repaintKey);
//       img.Image? image = img.decodeImage(captured);

//       if (image == null) {
//         print("❌ Image decode failed");
//         return false;
//       }

//       image = img.copyResize(image, width: targetWidth);

//       /// 4. GENERATE BYTES
//       List<int> bytes = [];
//       bytes += generator.image(image);
//       bytes += generator.feed(2);
//       bytes += generator.cut();

//       /// 5. SEND TO PRINTER
//       final result = await service.printTicket(bytes).timeout(
//         const Duration(seconds: 5),
//         onTimeout: () {
//           print("❌ Print timeout");
//           throw Exception("Print timeout");
//         },
//       );

//       /// บาง lib จะไม่ return อะไร → ให้ถือว่า success ถ้าไม่ throw
//       print("✅ Print sent");
//       return true;
//     } catch (e) {
//       print("❌ Print error: $e");
//       return false;
//     } finally {
//       try {
//         await service.disconnect();
//       } catch (_) {}
//     }
//   }

//   Future<bool> addPrintJob(
//     Future<bool> Function() job,
//   ) async {
//     final completer = Completer<bool>();

//     _queue.add(() async {
//       final result = await job();
//       completer.complete(result);
//       return result;
//     });

//     _processQueue();

//     return completer.future;
//   }

//   Future<void> _processQueue() async {
//     if (_isProcessing) return;
//     _isProcessing = true;

//     while (_queue.isNotEmpty) {
//       final job = _queue.removeAt(0);
//       try {
//         await job();
//       } catch (e) {
//         print("Print job error: $e");
//       }
//     }

//     _isProcessing = false;
//   }

//   Widget createBarCode(String data) {
//     return bw.BarcodeWidget(barcode: bw.Barcode.code128(), data: data);
//   }

//   Widget createQrCode(String data) {
//     return bw.BarcodeWidget(barcode: bw.Barcode.qrCode(), data: data);
//   }

//   // scan func
//   static Future<List<ScanPrinterDevice>> scanNetworkPrinters({
//     required String subnet,
//     List<int> ports = const [9100, 515, 631],
//     int start = 1,
//     int end = 254,
//     Duration timeout = const Duration(milliseconds: 300),
//     int concurrency = 50,
//   }) async {
//     final List<ScanPrinterDevice> results = [];
//     final List<Future<void>> tasks = [];

//     for (int i = start; i <= end; i++) {
//       final ip = '$subnet.$i';

//       tasks.add(_scanIp(ip, ports, timeout, results));

//       // จำกัด concurrency
//       if (tasks.length >= concurrency) {
//         await Future.wait(tasks);
//         tasks.clear();
//       }
//     }

//     // ✅ สำคัญ: run ที่เหลือ
//     if (tasks.isNotEmpty) {
//       await Future.wait(tasks);
//     }

//     // ✅ สำคัญ: return ค่า
//     return results;
//   }

//   static Future<void> _scanIp(
//     String ip,
//     List<int> ports,
//     Duration timeout,
//     List<ScanPrinterDevice> results,
//   ) async {
//     for (final port in ports) {
//       try {
//         final socket = await Socket.connect(ip, port, timeout: timeout);

//         results.add(ScanPrinterDevice(ip: ip, port: port));
//         socket.destroy();

//         // เจอ port นึงพอแล้ว ไม่ต้อง scan port อื่นต่อ
//         break;
//       } catch (_) {
//         // ignore
//       }
//     }
//   }
// }
