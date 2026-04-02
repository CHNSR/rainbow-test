import 'package:flutter_application_1/model/print_result.dart';
import 'package:flutter_printer_01/flutter_printer_01.dart';

class Myprinter {
  // อินสแตนซ์เดียวของ FlutterPrinter01
  final FlutterPrinter01 _printer = FlutterPrinter01();

  /// ตัวอย่างการพิมพ์ผ่านเครือข่าย
  Future<PrintResult> testPrintNetwork({
    required String ip,
    required int port,
    required String paperSize, // ยังไม่ได้ใช้ในตัวอย่างนี้
  }) async {
    try {
      // 1️⃣ เชื่อมต่อพริ้นเตอร์
      bool connected = await _printer.;
      if (!connected) {
        throw 'ไม่สามารถเชื่อมต่อ $ip:$port';
      }

      // 2️⃣ (ใส่ logic พิมพ์เพิ่มเติมที่นี่) เช่น:
      // await _printer.text.printText('Hello, $paperSize paper');

      // 3️⃣ ส่งข้อมูลดิบตัวอย่าง (ถ้าต้องการ)
      // await _printer.connection.writeData('Hello from Myprinter\n');

      return const PrintResult(success: true, message: 'Print success');
    } catch (e) {
      return PrintResult(success: false, message: e.toString());
    } finally {
      // 4️⃣ ปิดการเชื่อมต่อเสมอ
      await _printer.connection.disconnectPrinter();
    }
  }

  /// ส่งข้อมูลดิบ (raw) ไปยังเครื่องพิมพ์
  Future<void> write(String data) async {
    // ใช้ wrapper ที่เราเพิ่มใน PrinterConnection
    await _printer.connection.writeData(data);
  }

  /// ส่งบรรทัดพร้อม newline
  Future<void> println(String line) async {
    await write('$line\n');
  }
}
