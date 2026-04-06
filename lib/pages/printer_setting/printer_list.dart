import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrinterListPage extends StatefulWidget {
  const PrinterListPage({super.key});

  @override
  State<PrinterListPage> createState() => _PrinterListPageState();
}

class _PrinterListPageState extends State<PrinterListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Printer List"),
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ConfigPrinter2(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<PrinterBloc, PrinterState>(
        builder: (context, state) {
          final printers = state.printers ?? [];

          // ✅ กรณีไม่มีข้อมูล
          if (printers.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.print_disabled, size: 60, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    "No Printer Config",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "กด + เพื่อเพิ่ม Printer",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // ✅ กรณีมีข้อมูล
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: printers.length,
            itemBuilder: (context, index) {
              final printer = printers[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 🔹 Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            printer.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Chip(
                            label: Text(
                              printer.category == "kitchen"
                                  ? "🍳 Kitchen"
                                  : "💰 Cashier",
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      /// 🔹 Info
                      Text("IP: ${printer.ip}"),
                      Text("Port: ${printer.port}"),

                      const SizedBox(height: 12),

                      /// 🔹 Actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              // PrinterService().testPrintNetwork(
                              //   ip: printer.ip,
                              //   port: printer.port,
                              //   paperSize: printer.paperSize,
                              // );
                            },
                            icon: const Icon(Icons.print),
                            label: const Text("Test"),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ConfigPrinter2(
                                    index: index,
                                    config: printer,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text("Edit"),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              context
                                  .read<PrinterBloc>()
                                  .add(RemovePrinter(index));
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                            label: const Text(
                              "Delete",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
