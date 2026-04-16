// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart' as app;
import 'package:flutter_application_1/service/printer/smile_printer_native.dart';
import 'package:flutter_application_1/service/printer/smile_printer_cmd.dart';

/// Factory/Selector เพื่อเลือก Service ตามการตั้งค่า useNative
class PrinterServiceFactory {
  /// เลือก Printer Service ตามค่า useNative
  ///
  /// ถ้า useNative = true → ใช้ SmilePrinterService (Native)
  /// ถ้า useNative = false → ใช้ SmailePrinterCmd (Command)
  static dynamic getPrinterService({required bool useNative}) {
    if (useNative) {
      print("📱 [PrinterFactory] Using Native Service");
      return SmilePrinterService.instance;
    } else {
      print("📟 [PrinterFactory] Using Command Service");
      return SmailePrinterCmd.instance;
    }
  }

  /// Print Receipt - เลือก service อัตโนมัติตามค่า config
  static Future<void> printReceipt({
    required app.PrinterConfig config,
    required List<app.OrderItem> orders,
  }) async {
    try {
      final useNative = config.hardwareTemplate?['useNative'] ?? true;

      if (useNative) {
        // ใช้ Native Service
        await SmilePrinterService.instance.printReceipt(
          config: config,
          orders: orders,
        );
      } else {
        // ใช้ Command Service
        // สั่งโยง cmd service ด้วย
        // หมายเหตุ: SmailePrinterCmd ยังไม่มี printReceipt เหมือน native
        // ก็สร้าง printReceipt ให้ SmailePrinterCmd ด้วย
        print("⚠️ [PrinterFactory] CMD printReceipt ยังไม่ได้สร้าง");
      }
    } catch (e) {
      print("❌ [PrinterFactory] Print error: $e");
    }
  }

  /// Print Widget Receipt - เลือก service อัตโนมัติตามค่า config
  static Future<bool> printWidgetReceipt({
    required app.PrinterConfig config,
    required GlobalKey repaintKey,
  }) async {
    try {
      final useNative = config.hardwareTemplate?['useNative'] ?? true;

      if (useNative) {
        // ใช้ Native Service
        return await SmilePrinterService.instance.printWidgetReceipt(
          config: config,
          repaintKey: repaintKey,
        );
      } else {
        // ใช้ Command Service
        return await SmailePrinterCmd.instance.printWidgetReceipt(
          config: config,
          repaintKey: repaintKey,
        );
      }
    } catch (e) {
      print("❌ [PrinterFactory] Widget Print error: $e");
      return false;
    }
  }

  /// Add Print Job to Queue - เลือก service อัตโนมัติตามค่า config
  static Future<bool> addPrintJob({
    required app.PrinterConfig config,
    required Future<bool> Function() job,
  }) async {
    try {
      final useNative = config.hardwareTemplate?['useNative'] ?? true;

      if (useNative) {
        // Native Service มี addPrintJob
        return await SmilePrinterService.instance.addPrintJob(job);
      } else {
        // Command Service มี addPrintJob เช่นกัน
        return await SmailePrinterCmd.instance.addPrintJob(job);
      }
    } catch (e) {
      print("❌ [PrinterFactory] Add print job error: $e");
      return false;
    }
  }
}
