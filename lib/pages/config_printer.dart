import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrinterConfigPage extends StatefulWidget {
  const PrinterConfigPage({super.key});

  @override
  State<PrinterConfigPage> createState() => _PrinterConfigPageState();
}

class _PrinterConfigPageState extends State<PrinterConfigPage> {
  String printerType = "network"; // network / bluetooth
  final ipController = TextEditingController();
  final portController = TextEditingController(text: "9100");
  String paperSize = "80"; // 58 / 80

  final printerService = PrinterService();

  void onTestPrint() async {
    final result = await printerService.testPrintNetwork(
      ip: ipController.text,
      port: int.tryParse(portController.text) ?? 9100,
      paperSize: paperSize,
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.success ? "✅ ${result.message}" : "❌ ${result.message}",
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    final config = context.read<PrinterBloc>().state.config;

    if (config != null) {
      ipController.text = config.ip;
      portController.text = config.port.toString();
      paperSize = config.paperSize;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PrinterBloc, PrinterState>(
        listener: (context, state) {
          if (state.config == null) {
            // เมื่อ config ถูกล้างค่า ให้เคลียร์ค่าในฟอร์มด้วย
            setState(() {
              ipController.clear();
              portController.text = "9100"; // คืนค่าเริ่มต้น
              paperSize = "80"; // คืนค่าเริ่มต้น
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("🗑️ ล้างการตั้งค่าแล้ว")),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Config Printer"),
            backgroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 🔘 เลือกประเภท
                _buildSectionTitle("Printer Type"),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        title: const Text("Network"),
                        value: "network",
                        groupValue: printerType,
                        onChanged: (value) {
                          setState(() => printerType = value!);
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        title: const Text("Bluetooth"),
                        value: "bluetooth",
                        groupValue: printerType,
                        onChanged: (value) {
                          setState(() => printerType = value!);
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 🌐 NETWORK FORM
                if (printerType == "network") ...[
                  // 🧪 Test Print

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle("Network Settings"),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                          ),
                          onPressed: () {
                            onTestPrint();
                          },
                          label: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.connect_without_contact,
                                  color: Colors.black),
                              Text(
                                "Test printer",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          )),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: ipController,
                    decoration: const InputDecoration(
                      labelText: "IP Address",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: portController,
                    decoration: const InputDecoration(
                      labelText: "Port",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],

                // 🔵 BLUETOOTH
                if (printerType == "bluetooth") ...[
                  _buildSectionTitle("Bluetooth"),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: scan printer
                    },
                    child: const Text("Scan Printer"),
                  ),
                  const SizedBox(height: 10),
                  const Text("Select printer from list..."),
                ],

                const SizedBox(height: 20),

                // 📄 Paper Size
                _buildSectionTitle("Paper Size"),
                DropdownButtonFormField(
                  value: paperSize,
                  items: const [
                    DropdownMenuItem(value: "58", child: Text("58 mm")),
                    DropdownMenuItem(value: "80", child: Text("80 mm")),
                  ],
                  onChanged: (value) {
                    setState(() => paperSize = value!);
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 30),

                // 💾 Save
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          if (printerType == "network") {
                            final config = PrinterConfig(
                              ip: ipController.text,
                              port: int.tryParse(portController.text) ?? 9100,
                              paperSize: paperSize,
                            );

                            context.read<PrinterBloc>().add(
                                  SetPrinterConfig(config: config),
                                );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("✅ Saved")),
                            );
                          }
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<PrinterBloc>().add(ClearPrinterConfig());
                        },
                        child: const Text(
                          "Clear Config",
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
