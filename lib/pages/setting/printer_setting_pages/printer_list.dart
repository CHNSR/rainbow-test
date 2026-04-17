import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrinterListPage extends StatefulWidget {
  const PrinterListPage({super.key});

  @override
  State<PrinterListPage> createState() => _PrinterListPageState();
}

class _PrinterListPageState extends State<PrinterListPage> {
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            "$label:",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Printer Configurations",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ConfigPrinter3(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Printer"),
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
      ),
      body: BlocBuilder<PrinterBloc, PrinterState>(
        builder: (context, state) {
          final printers = state.printers ?? [];

          // ✅ กรณีไม่มีข้อมูล
          if (printers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                        )
                      ],
                    ),
                    child: Icon(Icons.print_disabled_outlined,
                        size: 64, color: Colors.grey.shade400),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "No Printers Configured",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tap the + button below to add your first printer.",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                  ),
                ],
              ),
            );
          }

          // ✅ กรณีมีข้อมูล
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: printers.length,
            itemBuilder: (context, index) {
              final printer = printers[index];
              final bool useIp = printer.hardwareTemplate?['useIp'] ?? true;
              final bool useNative =
                  printer.hardwareTemplate?['useNative'] ?? true;
              final bool isKitchen = printer.category == "kitchen";

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔹 Header Section
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isKitchen
                            ? Colors.orange.shade50
                            : Colors.blue.shade50,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        border: Border(
                            bottom: BorderSide(color: Colors.grey.shade100)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isKitchen
                                  ? Colors.orange.shade100
                                  : Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              isKitchen
                                  ? Icons.soup_kitchen
                                  : Icons.point_of_sale,
                              color: isKitchen
                                  ? Colors.orange.shade700
                                  : Colors.blue.shade700,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  printer.name.isEmpty
                                      ? "Unnamed Printer"
                                      : printer.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isKitchen
                                            ? Colors.orange.shade600
                                            : Colors.blue.shade600,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        isKitchen ? "KITCHEN" : "CASHIER",
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: useNative
                                            ? Colors.purple.shade600
                                            : Colors.teal.shade600,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        useNative ? "NATIVE" : "COMMAND",
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors
                                  .green, // Indicator ว่ามีคอนฟิกเรียบร้อย (สามารถผูกกับสถานะ ping จริงๆ ได้ในอนาคต)
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// 🔹 Details Section
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!useIp)
                                  _buildDetailRow(
                                      Icons.usb,
                                      "USB",
                                      printer.hardwareTemplate?['usbName'] ??
                                          printer.ip)
                                else ...[
                                  _buildDetailRow(Icons.router_outlined,
                                      "IP Address", printer.ip),
                                  _buildDetailRow(
                                      Icons.numbers, "Port", "${printer.port}"),
                                ],
                                _buildDetailRow(
                                    Icons.settings_ethernet,
                                    "Gateway",
                                    printer.hardwareTemplate?['gateway']
                                            ?.toString()
                                            .toUpperCase() ??
                                        'UNKNOWN'),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow(
                                    Icons.developer_board,
                                    "Model",
                                    printer.hardwareTemplate?['model'] ??
                                        'Unknown'),
                                _buildDetailRow(Icons.receipt_long, "Paper",
                                    "${printer.paperSize} mm"),
                                _buildDetailRow(Icons.timer_outlined, "Timeout",
                                    "${printer.hardwareTemplate?['timeout']} ms"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// 🔹 Actions Section
                    Divider(height: 1, color: Colors.grey.shade200),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () async {
                              // สามารถปลดคอมเมนต์และเรียกใช้งาน Test Print ของ Factory ตรงนี้ได้เลยครับ
                              // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Testing connection...')));
                            },
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.blue.shade700),
                            icon: const Icon(Icons.print_outlined, size: 18),
                            label: const Text("Test Print"),
                          ),
                          const SizedBox(width: 4),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ConfigPrinter3(
                                    index: index,
                                    config: printer,
                                  ),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.orange.shade700),
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            label: const Text("Edit"),
                          ),
                          const SizedBox(width: 4),
                          TextButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Delete Printer?"),
                                  content: Text(
                                      "Are you sure you want to delete '${printer.name}'?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context
                                            .read<PrinterBloc>()
                                            .add(RemovePrinter(index));
                                        Navigator.pop(ctx);
                                      },
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.red),
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.red.shade600),
                            icon: const Icon(Icons.delete_outline, size: 18),
                            label: const Text("Delete"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
