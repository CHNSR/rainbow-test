import 'package:flutter_application_1/model/receipt.dart';
import 'package:flutter_application_1/model/print_result.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:flutter_application_1/hive_registrar.g.dart';

class HiveService {
  // Constants for Box Names
  static const String settingsBox = 'settingsBox';
  static const String printerBox = 'printerBox';
  static const String receiptBox = 'receiptBox';

  // Constants for Setting Keys
  static const String keyRestaurantName = 'restaurantName';
  static const String keyRestaurantPhone = 'restaurantPhone';
  static const String keyTaxRate = 'taxRate';

  static Future<void> initHive() async {
    // 1. Initialize Hive
    await Hive.initFlutter();

    // 2. Register Adapters
    Hive.registerAdapters();

    // 3. Open Boxes
    await Hive.openBox<dynamic>(settingsBox);
    await Hive.openBox<PrinterConfig>(printerBox);
    await Hive.openBox<Receipt>(receiptBox);

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
}
