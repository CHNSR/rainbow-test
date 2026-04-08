import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/receipt.dart';
import 'package:flutter_application_1/service/hive_ce/hive_ce.dart';
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
  List<Receipt> receipts = [];

  @override
  void initState() {
    super.initState();
    _loadReceipts();
  }

  void _loadReceipts() {
    setState(() {
      receipts = HiveService.getReceipts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("History Receipts"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: receipts.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No Receipts Yet",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: receipts.length,
              itemBuilder: (context, index) {
                final receipt = receipts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      "Order #${receipt.id.substring(receipt.id.length - 6)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('dd MMM yyyy, HH:mm')
                                .format(receipt.date),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                  border:
                                      Border.all(color: Colors.blue.shade200),
                                ),
                                child: Text(
                                  receipt.orderType,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: receipt.orderType == "stay"
                                          ? Colors.blue.shade700
                                          : Colors.orange.shade700),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color:
                                      receipt.status.toLowerCase() == 'success'
                                          ? Colors.green.shade50
                                          : Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      color: receipt.status.toLowerCase() ==
                                              'success'
                                          ? Colors.green.shade200
                                          : Colors.red.shade200),
                                ),
                                child: Text(
                                  receipt.status,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: receipt.status.toLowerCase() ==
                                            'success'
                                        ? Colors.green.shade700
                                        : Colors.red.shade700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  "🖨️ ${receipt.printer.length} Printer(s)",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w500),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    trailing: Text(
                      "\$${receipt.totalAmount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                    children: [
                      const Divider(),
                      ...receipt.items.map((item) => ListTile(
                            visualDensity: VisualDensity.compact,
                            title: Text("${item.quantity}x ${item.foodName}"),
                            trailing: Text(
                                "\$${(item.foodPrice * item.quantity).toStringAsFixed(2)}"),
                          )),
                      if (receipt.printer.isNotEmpty) ...[
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "🖨️ Printed via:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...receipt.printer.map((p) {
                                final category =
                                    p['category']?.toString() ?? 'Unknown';
                                final name =
                                    p['name']?.toString() ?? 'Unknown Printer';
                                final ip = p['ip']?.toString() ?? '-';
                                final port = p['port']?.toString() ?? '-';
                                final printStatus = p['status']?.toString() ??
                                    'success'; // ดึงสถานะการพิมพ์ของเครื่องนี้

                                final isKitchen =
                                    category.toLowerCase() == 'kitchen';

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8.0),
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: isKitchen
                                              ? Colors.orange.shade100
                                              : Colors.blue.shade100,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          isKitchen
                                              ? Icons.soup_kitchen
                                              : Icons.point_of_sale,
                                          size: 20,
                                          color: isKitchen
                                              ? Colors.orange.shade700
                                              : Colors.blue.shade700,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              "IP: $ip : $port",
                                              style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: printStatus == 'success'
                                              ? Colors.green.shade100
                                              : Colors.red.shade100,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          printStatus.toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: printStatus == 'success'
                                                  ? Colors.green.shade700
                                                  : Colors.red.shade700),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
