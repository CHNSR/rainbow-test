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
  bool _isScanning = true;
  String _selectedGateway = 'posx';
  List<String> availableModels = [];

  @override
  void initState() {
    super.initState();
    availableModels = gatewayModelMap[PrinterGateway.epson] ?? ['generic'];
    _scanUsb();
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
                Row(
                  children: [
                    const Text("Gateway: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'posx', label: Text('POSX')),
                          ButtonSegment(value: 'epson', label: Text('Epson')),
                          ButtonSegment(value: 'star', label: Text('Star')),
                        ],
                        selected: {_selectedGateway},
                        onSelectionChanged: _isScanning
                            ? null
                            : (Set<String> newSelection) {
                                setState(() {
                                  _selectedGateway = newSelection.first;
                                });
                                _scanUsb(); // เรียกแสกนใหม่ทันทีที่เปลี่ยน Gateway
                              },
                      ),
                    ),
                  ],
                ),
                // const SizedBox(height: 8),
                // DropdownButtonFormField<String>(
                //       isExpanded: true,
                //       value: availableModels.contains(modelController.text)
                //           ? modelController.text
                //           : availableModels.first,
                //       style: TextStyle(fontSize: textSize, color: cs.onSurface),
                //       items: availableModels
                //           .map((m) => DropdownMenuItem(
                //                 value: m,
                //                 child: Text(
                //                   m,
                //                   maxLines: 1,
                //                   overflow: TextOverflow.ellipsis,
                //                 ),
                //               ))
                //           .toList(),
                //       decoration: InputDecoration(
                //           labelText: 'Model',
                //           labelStyle: TextStyle(fontSize: textSize),
                //           prefixIcon:
                //               Icon(Icons.developer_board, size: textSize + 6),
                //           border: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(12)),
                //           filled: true,
                //           fillColor: cs.surfaceContainerLow,
                //           contentPadding: EdgeInsets.symmetric(
                //               vertical: textSize * 0.9, horizontal: 16)),
                //       onChanged: (v) =>
                //           setState(() => modelController.text = v ?? 'generic'),
                //     ),
                // const SizedBox(height: 8),
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
