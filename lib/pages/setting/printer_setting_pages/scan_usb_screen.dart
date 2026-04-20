import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_application_1/model/printer_enums.dart';
import 'package:flutter_application_1/model/printer_model_enum.dart';
import 'package:flutter_application_1/service/printer/smile_printer_native.dart';

class ScanUsbScreen extends StatefulWidget {
  const ScanUsbScreen({super.key});

  @override
  State<ScanUsbScreen> createState() => _ScanUsbScreenState();
}

class _ScanUsbScreenState extends State<ScanUsbScreen> {
  List<USBPrinterDevice> _devices = [];
  bool _isScanning = false;
  String _selectedGateway = 'posx';
  List<String> availableModels = [];
  List<String> gatewayModel = [];

  @override
  void initState() {
    super.initState();
    availableModels = gatewayModelMap[PrinterGateway.epson] ?? ['generic'];
    gatewayModel = gatewayModelMap[PrinterGateway] ?? ['generic'];
  }

  Future<void> _scanUsb() async {
    print("📡 [ScanUsbScreen] Initiating USB scan...");
    setState(() {
      _isScanning = true;
      _devices = [];
    });

    final devices = await SmilePrinterService.scanUsbPrinters(
        printerGateway: _selectedGateway);
    print(
        "📡 [ScanUsbScreen] Scan completed. Updating UI with ${devices.length} devices.");

    if (mounted) {
      setState(() {
        _devices = devices;
        _isScanning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('Scan USB Printers',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: cs.inversePrimary,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isScanning ? null : _scanUsb,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surface,
              border: Border(
                  bottom:
                      BorderSide(color: cs.outlineVariant.withOpacity(0.5))),
            ),
            child: Column(
              children: [
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  items: PrinterGateway.values
                      .map((gateway) => DropdownMenuItem(
                            value: gateway.name,
                            child: Text(gateway.name.toUpperCase()),
                          ))
                      .toList(),
                  value: _selectedGateway,
                  onChanged: _isScanning
                      ? null
                      : (value) {
                          setState(() {
                            _selectedGateway = value!;
                            availableModels = gatewayModelMap[PrinterGateway
                                    .values
                                    .firstWhere((g) => g.name == value)] ??
                                ['generic'];
                          });
                        },
                  decoration: const InputDecoration(
                    labelText: 'Printer Gateway',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: availableModels.contains('generic')
                      ? 'generic'
                      : availableModels.first,
                  items: availableModels
                      .map((model) => DropdownMenuItem(
                            value: model,
                            child: Text(model.toUpperCase()),
                          ))
                      .toList(),
                  onChanged: _isScanning
                      ? null
                      : (value) {
                          // Handle model selection if needed
                        },
                  decoration: const InputDecoration(
                    labelText: 'Printer Model',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _isScanning ? null : _scanUsb,
                    icon: _isScanning
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.search),
                    label: Text(
                        _isScanning ? 'Scanning...' : 'Scan USB Printers',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          Expanded(
            child: _isScanning
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text("Scanning for USB devices..."),
                      ],
                    ),
                  )
                : _devices.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.usb_off,
                                size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text(
                              "No USB printers found",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _scanUsb,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Try Again'),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: _devices.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final device = _devices[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            leading: CircleAvatar(
                              backgroundColor: cs.primaryContainer,
                              child:
                                  Icon(Icons.usb, color: cs.onPrimaryContainer),
                            ),
                            title: Text(device.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: const Text('Tap to select this printer'),
                            trailing: Icon(Icons.check_circle_outline,
                                color: cs.primary),
                            onTap: () {
                              // ส่งชื่ออุปกรณ์ที่เลือกกลับไปยังหน้า Config
                              Navigator.pop(context, device.name);
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
