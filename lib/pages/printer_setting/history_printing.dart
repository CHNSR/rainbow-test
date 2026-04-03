import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// สถานะของการพิมพ์
enum PrintStatus {
  success,
  fail,
  printing,
  waiting,
}

/// Model จำลองสำหรับประวัติการพิมพ์ (ภายหลังสามารถย้ายไปเก็บใน Hive ได้)
class PrintHistoryItem {
  final String id;
  final DateTime timestamp;
  final double totalAmount;
  PrintStatus status;

  PrintHistoryItem({
    required this.id,
    required this.timestamp,
    required this.totalAmount,
    required this.status,
  });
}

class HistoryPrinting extends StatefulWidget {
  const HistoryPrinting({super.key});

  @override
  State<HistoryPrinting> createState() => _HistoryPrintingState();
}

class _HistoryPrintingState extends State<HistoryPrinting> {
  // ข้อมูลจำลอง (Mock Data)
  final List<PrintHistoryItem> _history = [
    PrintHistoryItem(
      id: 'ORD-0001',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      totalAmount: 250.0,
      status: PrintStatus.success,
    ),
    PrintHistoryItem(
      id: 'ORD-0002',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      totalAmount: 120.0,
      status: PrintStatus.fail,
    ),
    PrintHistoryItem(
      id: 'ORD-0003',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      totalAmount: 850.0,
      status: PrintStatus.success,
    ),
  ];

  /// ฟังก์ชันจำลองการสั่งพิมพ์ซ้ำ
  Future<void> _reprint(PrintHistoryItem item) async {
    // 1. เปลี่ยนสถานะเป็น รอคิวพิมพ์ (Waiting)
    setState(() => item.status = PrintStatus.waiting);
    await Future.delayed(const Duration(milliseconds: 500));

    // 2. เปลี่ยนสถานะเป็น กำลังพิมพ์ (Printing)
    setState(() => item.status = PrintStatus.printing);

    // TODO: เรียกใช้ PrinterService().printRecept(...) หรือ printWidgetReceipt(...) ตรงนี้
    await Future.delayed(
        const Duration(seconds: 2)); // จำลองเวลาเครื่องปริ้นทำงาน

    // 3. อัปเดตสถานะเมื่อสำเร็จ (Success) หรือ ล้มเหลว (Fail)
    if (mounted) {
      setState(() => item.status = PrintStatus.success);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ พิมพ์ใบเสร็จ ${item.id} ซ้ำสำเร็จ'),
          backgroundColor: Colors.green.shade700,
        ),
      );
    }
  }

  /// Helper สำหรับแปลง Status เป็น สี
  Color _getStatusColor(PrintStatus status) {
    switch (status) {
      case PrintStatus.success:
        return Colors.green.shade600;
      case PrintStatus.fail:
        return Colors.red.shade600;
      case PrintStatus.printing:
        return Colors.blue.shade600;
      case PrintStatus.waiting:
        return Colors.orange.shade600;
    }
  }

  /// Helper สำหรับแปลง Status เป็น ข้อความ
  String _getStatusText(PrintStatus status) {
    switch (status) {
      case PrintStatus.success:
        return 'Print Success';
      case PrintStatus.fail:
        return 'Print Fail';
      case PrintStatus.printing:
        return 'Printing...';
      case PrintStatus.waiting:
        return 'Waiting...';
    }
  }

  /// Helper สำหรับแปลง Status เป็น Icon
  IconData _getStatusIcon(PrintStatus status) {
    switch (status) {
      case PrintStatus.success:
        return Icons.check_circle;
      case PrintStatus.fail:
        return Icons.error;
      case PrintStatus.printing:
        return Icons.print;
      case PrintStatus.waiting:
        return Icons.hourglass_empty;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('History Printing',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: cs.inversePrimary,
        centerTitle: true,
      ),
      body: _history.isEmpty
          ? const Center(child: Text('ไม่มีประวัติการพิมพ์'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _history.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _history[index];
                final isProcessing = item.status == PrintStatus.printing ||
                    item.status == PrintStatus.waiting;

                return Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // ไอคอนสถานะ
                        Icon(_getStatusIcon(item.status),
                            color: _getStatusColor(item.status), size: 36),
                        const SizedBox(width: 16),

                        // รายละเอียดออเดอร์
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order: ${item.id}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('dd MMM yyyy, HH:mm')
                                    .format(item.timestamp),
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _getStatusText(item.status),
                                style: TextStyle(
                                    color: _getStatusColor(item.status),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13),
                              ),
                            ],
                          ),
                        ),

                        // ปุ่ม Reprint
                        FilledButton.tonalIcon(
                          onPressed: isProcessing ? null : () => _reprint(item),
                          icon: isProcessing
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.print, size: 18),
                          label: Text(isProcessing ? 'Wait' : 'Reprint'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
