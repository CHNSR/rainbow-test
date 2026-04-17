import 'package:flutter_application_1/model/receipt.dart';
import 'package:flutter_application_1/model/print_result.dart';
import 'package:flutter_application_1/model/print_history.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:flutter_application_1/hive_registrar.g.dart';

class HiveService {
  // Constants for Box Names
  static const String settingsBox = 'settingsBox';
  static const String printerBox = 'printerBox';
  static const String receiptBox = 'receiptBox';
  static const String printHistoryBox = 'printHistoryBox';

  // Constants for Setting Keys
  static const String keyRestaurantName = 'restaurantName';
  static const String keyRestaurantPhone = 'restaurantPhone';
  static const String keyTaxRate = 'taxRate';
  static const String keyAppUsers = 'appUsers';

  static Future<void> initHive() async {
    // 1. Initialize Hive
    await Hive.initFlutter();

    // 2. Register Adapters
    Hive.registerAdapters();

    // 3. Open Boxes
    await Hive.openBox<dynamic>(settingsBox);
    await Hive.openBox<PrinterConfig>(printerBox);

    try {
      await Hive.openBox<Receipt>(receiptBox);
    } catch (e) {
      // หากเปิด Box ไม่ได้เนื่องจากโครงสร้างข้อมูลเก่าไม่ตรงกับ Model ใหม่ ให้ลบ Box ทิ้งแล้วเปิดใหม่
      await Hive.deleteBoxFromDisk(receiptBox);
      await Hive.openBox<Receipt>(receiptBox);
    }

    try {
      await Hive.openBox<PrintHistoryItem>(printHistoryBox);
    } catch (e) {
      // หากเปิด Box ไม่ได้เนื่องจากโครงสร้างข้อมูลเก่าไม่ตรงกับ Model ใหม่ ให้ลบ Box ทิ้งแล้วเปิดใหม่
      await Hive.deleteBoxFromDisk(printHistoryBox);
      await Hive.openBox<PrintHistoryItem>(printHistoryBox);
    }

    // Set default settings if not exists
    final box = Hive.box<dynamic>(settingsBox);
    if (!box.containsKey(keyRestaurantName)) {
      box.put(keyRestaurantName, "Soi Siam Restaurant");
    }
  }

  // ==========================================
  // PRINTER CONFIGURATIONS
  // ==========================================

  /// Get all saved printer configurations
  static List<PrinterConfig> getPrinters() {
    final box = Hive.box<PrinterConfig>(printerBox);
    return box.values.toList();
  }

  /// Add a new printer configuration
  static Future<void> addPrinter(PrinterConfig config) async {
    final box = Hive.box<PrinterConfig>(printerBox);
    await box.add(config);
  }

  /// Update an existing printer configuration by index
  static Future<void> updatePrinter(int index, PrinterConfig config) async {
    final box = Hive.box<PrinterConfig>(printerBox);
    if (index >= 0 && index < box.length) {
      await box.putAt(index, config);
    }
  }

  /// Remove a printer configuration by index
  static Future<void> removePrinter(int index) async {
    final box = Hive.box<PrinterConfig>(printerBox);
    if (index >= 0 && index < box.length) {
      await box.deleteAt(index);
    }
  }

  /// Delete all saved printers
  static Future<void> clearAllPrinters() async {
    final box = Hive.box<PrinterConfig>(printerBox);
    await box.clear();
  }

  // ==========================================
  // APP SETTINGS
  // ==========================================

  static String getRestaurantName() {
    return Hive.box<dynamic>(settingsBox)
        .get(keyRestaurantName, defaultValue: "My Restaurant");
  }

  static Future<void> setRestaurantName(String name) async {
    await Hive.box<dynamic>(settingsBox).put(keyRestaurantName, name);
  }

  static String getRestaurantPhone() {
    return Hive.box<dynamic>(settingsBox)
        .get(keyRestaurantPhone, defaultValue: "");
  }

  static Future<void> setRestaurantPhone(String phone) async {
    await Hive.box<dynamic>(settingsBox).put(keyRestaurantPhone, phone);
  }

  static String getTaxRate() {
    return Hive.box<dynamic>(settingsBox).get(keyTaxRate, defaultValue: "0.0");
  }

  static Future<void> setTaxRate(String rate) async {
    await Hive.box<dynamic>(settingsBox).put(keyTaxRate, rate);
  }

  // ==========================================
  // USERS / ROLES
  // ==========================================
  static List<String> getAppUsersRaw() {
    final box = Hive.box<dynamic>(settingsBox);
    return box.get(keyAppUsers, defaultValue: <dynamic>[]).cast<String>();
  }

  static Future<void> saveAppUsersRaw(List<String> users) async {
    await Hive.box<dynamic>(settingsBox).put(keyAppUsers, users);
  }

  // ==========================================
  // RECEIPTS
  // ==========================================

  static Future<void> addReceipt(Receipt receipt) async {
    final box = Hive.box<Receipt>(receiptBox);
    await box.put(receipt.id, receipt);
  }

  static List<Receipt> getReceipts() {
    final box = Hive.box<Receipt>(receiptBox);
    final receipts = box.values.toList();
    // เรียงลำดับจากใบเสร็จใหม่สุดไปเก่าสุด
    receipts.sort((a, b) => b.date.compareTo(a.date));
    return receipts;
  }

  // ==========================================
  // PRINT HISTORY (With Printer Config)
  // ==========================================

  /// 💾 Save print history with printer configuration data
  /// - id: Receipt ID
  /// - totalAmount: Total order amount
  /// - orderType: dine-in / takeaway / delivery
  /// - items: List of items ordered
  /// - printerConfigs: List of printer config used for printing
  /// - status: Print status (success/fail/printing/waiting)
  static Future<void> savePrintHistory({
    required String id,
    required double totalAmount,
    required String orderType,
    required List<Map<String, dynamic>> items,
    required List<Map<String, dynamic>> printerConfigs,
    PrintStatus status = PrintStatus.success,
  }) async {
    try {
      final historyItem = PrintHistoryItem(
        id: id,
        timestamp: DateTime.now(),
        totalAmount: totalAmount,
        status: status,
        orderType: orderType,
        items: items,
        printer: printerConfigs,
      );

      final box = Hive.box<PrintHistoryItem>(printHistoryBox);
      await box.add(historyItem);

      print("✅ [PrintHistory] Saved history + printer config for order #$id");
    } catch (e) {
      print("❌ [PrintHistory] Error saving print history: $e");
    }
  }

  /// 📋 Get all print history sorted by latest first
  static List<PrintHistoryItem> getPrintHistory() {
    try {
      final box = Hive.box<PrintHistoryItem>(printHistoryBox);
      final history = box.values.toList();
      // Sort by latest first
      history.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return history;
    } catch (e) {
      print("❌ [PrintHistory] Error getting print history: $e");
      return [];
    }
  }

  /// 🗑️ Clear all print history
  static Future<void> clearPrintHistory() async {
    try {
      final box = Hive.box<PrintHistoryItem>(printHistoryBox);
      await box.clear();
      print("✅ [PrintHistory] Cleared all print history");
    } catch (e) {
      print("❌ [PrintHistory] Error clearing print history: $e");
    }
  }
}
