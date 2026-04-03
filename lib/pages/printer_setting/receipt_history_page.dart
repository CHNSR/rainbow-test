import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/model/receipt.dart';
import 'package:flutter_application_1/service/hive_ce/hive_ce.dart';

class ReceiptHistoryPage extends StatefulWidget {
  const ReceiptHistoryPage({super.key});

  @override
  State<ReceiptHistoryPage> createState() => _ReceiptHistoryPageState();
}

class _ReceiptHistoryPageState extends State<ReceiptHistoryPage> {
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
                    subtitle: Text(
                      DateFormat('dd MMM yyyy, HH:mm').format(receipt.date),
                      style: TextStyle(color: Colors.grey[600]),
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
                            title: Text("${item.quantity}x ${item.foodName}"),
                            trailing: Text(
                                "\$${(item.foodPrice * item.quantity).toStringAsFixed(2)}"),
                          )),
                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
