import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_printer_01/flutter_printer_01.dart';

class PrinterConfigPage extends StatefulWidget {
  final int? index;
  final PrinterConfig? config;

  const PrinterConfigPage({
    super.key,
    this.index,
    this.config,
  });

  @override
  State<PrinterConfigPage> createState() => _PrinterConfigPageState();
}

class _PrinterConfigPageState extends State<PrinterConfigPage> {
  String printerType = "network"; // network / usb
  final ipController = TextEditingController();
  final portController = TextEditingController(text: "9100");
  String paperSize = "80"; // 58 / 80
  String printerCategory = "kitchen"; // kitchen / cashier
  final printerService = PrinterService();
  final myprinter = FlutterPrinter01();
  final nameController = TextEditingController();

  bool _isConnected = false;
  bool _isLoading = false;
  String _status = 'Ready';

  void onTestPrint() async {
    setState(() => _isLoading = true);
    final result = await printerService.testPrintNetwork(
      ip: ipController.text,
      port: int.tryParse(portController.text) ?? 9100,
      paperSize: paperSize,
    );

    setState(() => _isLoading = false);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.success ? "✅ ${result.message}" : "❌ ${result.message}",
        ),
      ),
    );
  }

  Future<void> _checkStatus() async {
    setState(() => _isLoading = true);
    try {
      final ok = await myprinter.connection.getConnectionStatus();
      setState(() {
        _isConnected = ok;
        _status = ok ? '🟢 Status: Connected' : '🔴 Status: Disconnected';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _openScanScreen() async {
    final ip = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => ScanNetworkScreen(plugin: myprinter)),
    );
    if (ip != null && mounted) {
      setState(() {
        ipController.text = ip;
        _status = '📡 พบ IP: $ip';
      });
    }
  }

  Future<void> _scanUsb() async {
    setState(() => _isLoading = true);
    try {
      final devices = await myprinter.connection.getUsbDevices();
      if (!mounted) return;
      setState(() {
        _status = devices.isEmpty
            ? 'ไม่พบ USB Device'
            : 'พบ: ${devices.map((d) => d['deviceName']).join(", ")}';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onSave() {
    if (printerType == "network") {
      final config = PrinterConfig(
        name: nameController.text,
        ip: ipController.text,
        port: int.tryParse(portController.text) ?? 9100,
        paperSize: paperSize,
        category: printerCategory,
        // ⚠️ NOTE: Add these fields to your PrinterConfig model first
        // isAutoCut: _isAutoCut,
        // isBeep: _isBeep,
        // printPrice: _printPrice,
      );

      if (widget.index != null) {
        // ✏️ EDIT
        context.read<PrinterBloc>().add(
              EditPrinter(widget.index!, config),
            );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✏️ Updated")),
        );
      } else {
        // ➕ ADD
        context.read<PrinterBloc>().add(
              AddPrinter(config),
            );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Saved")),
        );
      }

      AppNavigator.goBack(context);
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.config != null) {
      final c = widget.config!;

      nameController.text = c.name;
      ipController.text = c.ip;
      portController.text = c.port.toString();
      paperSize = c.paperSize;
      printerCategory = c.category;

      // ⚠️ NOTE: Add these fields to your PrinterConfig model first
      // _isAutoCut = c.isAutoCut;
      // _isBeep = c.isBeep;
      // _printPrice = c.printPrice;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.index != null ? "Edit Printer" : "Config Printer",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: cs.inversePrimary,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          StatusCard(isConnected: _isConnected, status: _status),
          const SizedBox(height: 24),
          const SectionHeader(
              icon: Icons.info_outline, label: 'Printer Details'),
          const SizedBox(height: 12),
          PrinterTextField(
            controller: nameController,
            label: 'Name of printer',
            icon: Icons.print,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: printerType,
                  items: const [
                    DropdownMenuItem(value: "network", child: Text("Network")),
                    DropdownMenuItem(value: "usb", child: Text("USB")),
                  ],
                  onChanged: (value) => setState(() => printerType = value!),
                  decoration: InputDecoration(
                    labelText: "Printer Type",
                    prefixIcon: const Icon(Icons.usb),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: cs.surfaceContainerLow,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (printerType == 'network') ...[
            const SectionHeader(icon: Icons.wifi, label: 'Network Settings'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: PrinterTextField(
                    controller: ipController,
                    label: 'IP Address',
                    icon: Icons.router_outlined,
                    enabled: !_isConnected && !_isLoading,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: PrinterTextField(
                    controller: portController,
                    label: 'Port',
                    icon: Icons.electrical_services_outlined,
                    enabled: !_isConnected && !_isLoading,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ActionButton(
              label: 'Scan Network Printers',
              icon: Icons.radar,
              onTap: _isLoading ? null : _openScanScreen,
              outlined: true,
            ),
          ] else if (printerType == 'usb') ...[
            const SectionHeader(
                icon: Icons.usb_outlined, label: 'USB Settings'),
            const SizedBox(height: 12),
            ActionButton(
              label: 'Scan USB Devices',
              icon: Icons.search,
              outlined: true,
              onTap: _isLoading ? null : _scanUsb,
            ),
          ],
          const SizedBox(height: 24),
          const SectionHeader(
              icon: Icons.monitor_heart_outlined, label: 'Testing & Status'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ActionButton(
                  label: 'Check Status',
                  icon: Icons.sync_outlined,
                  onTap: _isLoading ? null : _checkStatus,
                  outlined: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ActionButton(
                  label: 'Test Print',
                  icon: Icons.print_outlined,
                  onTap: _isLoading ? null : () => onTestPrint(),
                  outlined: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const SectionHeader(icon: Icons.settings, label: 'Configuration'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: paperSize,
                  items: const [
                    DropdownMenuItem(value: "58", child: Text("58 mm")),
                    DropdownMenuItem(value: "80", child: Text("80 mm")),
                  ],
                  onChanged: (value) => setState(() => paperSize = value!),
                  decoration: InputDecoration(
                    labelText: "Paper Size",
                    prefixIcon: const Icon(Icons.receipt_long),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: cs.surfaceContainerLow,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: printerCategory,
                  items: const [
                    DropdownMenuItem(value: "kitchen", child: Text("Kitchen")),
                    DropdownMenuItem(value: "cashier", child: Text("Cashier")),
                  ],
                  onChanged: (value) =>
                      setState(() => printerCategory = value!),
                  decoration: InputDecoration(
                    labelText: "Category",
                    prefixIcon: const Icon(Icons.category),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: cs.surfaceContainerLow,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: ActionButton(
                  label: 'Clear Config',
                  icon: Icons.clear,
                  danger: true,
                  outlined: true,
                  onTap: () {
                    context.read<PrinterBloc>().add(ClearPrinterConfig());
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ActionButton(
                  label: 'Save Config',
                  icon: Icons.save,
                  onTap: _onSave,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
