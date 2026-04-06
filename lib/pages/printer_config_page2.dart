import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_application_1/service/smile_printer/smile_printer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfigPrinter2 extends StatefulWidget {
  final int? index;
  final PrinterConfig? config;

  const ConfigPrinter2({
    super.key,
    this.index,
    this.config,
  });

  @override
  State<ConfigPrinter2> createState() => _ConfigPrinter2State();
}

class _ConfigPrinter2State extends State<ConfigPrinter2> {
  String printerType = "network"; // network / usb
  final ipController = TextEditingController();
  final portController = TextEditingController(text: "9100");
  String paperSize = "80"; // 58 / 80
  String printerCategory = "kitchen"; // kitchen / cashier
  final smilePrinterService = SmilePrinterService.instance;
  final nameController = TextEditingController();

  bool _isConnected = false;
  bool _isLoading = false;
  String _status = 'ยังไม่ได้ตรวจสอบสถานะ';

  // สำหรับ Plugin ใหม่: เก็บค่า USB Device ที่แสกนเจอ
  String? _selectedUsbKey;
  List<Map<String, dynamic>> _usbDevices = [];

  Map<String, dynamic>? _textTemplate;
  Map<String, dynamic>? _hardwareTemplate;
  Map<String, dynamic>? _graphicsTemplate;

  void onTestPrint() async {
    setState(() => _isLoading = true);
    final result = await smilePrinterService.testPrintNetwork(
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
      final ok = await smilePrinterService.getConnectionStatus();
      setState(() {
        _isConnected = ok;
        _status = ok ? 'Printer พร้อมใช้งาน' : 'ไม่สามารถติดต่อ Printer ได้';
      });
    } catch (e) {
      setState(() {
        _isConnected = false;
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _openScanScreen() async {
    final ip = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const ScanNetworkScreen()),
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
      // TODO: รอใส่ฟังก์ชันค้นหา USB Device จากปลั๊กอินตัวใหม่
      final List<dynamic> devices = [];
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
        //
        textTemplate: _textTemplate,
        hardwareTemplate: _hardwareTemplate,
        graphicsTemplate: _graphicsTemplate,
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
      _textTemplate = c.textTemplate;
      _hardwareTemplate = c.hardwareTemplate;
      _graphicsTemplate = c.graphicsTemplate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.index != null ? "Edit Printer" : "Add Printer",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: cs.inversePrimary,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ---------------- printer status & actions ----------------
          if (widget.index != null) ...[
            const SizedBox(height: 12),
            const SectionHeader(
                icon: Icons.monitor_heart_outlined, label: 'Testing & Status'),
            const SizedBox(height: 12),
            Text(
              'Status: $_status',
              style: TextStyle(
                color: _isConnected ? Colors.green : Colors.grey.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ActionButton(
                    label: 'Connect',
                    icon: Icons.link,
                    onTap: _isLoading ? null : _checkStatus,
                    outlined: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ActionButton(
                    label: 'PrintData',
                    icon: Icons.print_outlined,
                    onTap: _isLoading ? null : () => onTestPrint(),
                    outlined: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ActionButton(
                    label: 'Operation',
                    icon: Icons.build_circle_outlined,
                    onTap: _isLoading
                        ? null
                        : () {}, // TODO: call printOperation()
                    outlined: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
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
            // const SizedBox(height: 12),
            // ActionButton(
            //   label: 'Scan Network Printers',
            //   icon: Icons.radar,
            //   onTap: _isLoading ? null : _openScanScreen,
            //   outlined: true,
            // ),
          ] else if (printerType == 'usb') ...[
            const SectionHeader(
                icon: Icons.usb_outlined, label: 'USB Settings'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    value: _selectedUsbKey,
                    items: _usbDevices.isEmpty
                        ? const [
                            DropdownMenuItem(
                                value: null, child: Text('No devices found'))
                          ]
                        : _usbDevices.map((d) {
                            return DropdownMenuItem<String>(
                              value: d['key'] as String,
                              child: Text(
                                  d['name'] as String? ?? 'Unknown Device'),
                            );
                          }).toList(),
                    onChanged: (value) =>
                        setState(() => _selectedUsbKey = value),
                    decoration: InputDecoration(
                      labelText: "Select USB Device",
                      prefixIcon: const Icon(Icons.usb),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: cs.surfaceContainerLow,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ActionButton(
                    label: 'Scan USB',
                    icon: Icons.search,
                    outlined: true,
                    onTap: _isLoading ? null : _scanUsb,
                  ),
                ),
              ],
            ),
          ],

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
          //Dropdown for Auto Cut, Beep, Print Price can be added here similarly
          const SizedBox(height: 24),

          /* ปิดการใช้งาน Template Settings เนื่องจาก Plugin ใหม่ไม่รองรับการตั้งค่าแยกส่วนแล้ว
          const SectionHeader(
              icon: Icons.pages_sharp, label: 'Template Settings'),
          const SizedBox(height: 12),

          Column(
            children: [
              Card(
                elevation: 0,
                color: cs.surfaceContainerLow,
                child: ListTile(
                  leading: const Icon(Icons.text_fields_outlined,
                      color: Color(0xFF5C6BC0)),
                  title: const Text('Text',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(_textTemplate != null
                      ? '✅ บันทึกชั่วคราวแล้ว'
                      : 'กำหนดค่า Data / PrintData Config'),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => TextScreen(
                              /* TODO: อัปเดตให้รองรับปลั๊กอินใหม่ */)),
                    );
                    if (result != null && mounted) {
                      setState(
                          () => _textTemplate = result as Map<String, dynamic>);
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                color: cs.surfaceContainerLow,
                child: ListTile(
                  leading: const Icon(Icons.hardware_outlined,
                      color: Color(0xFFF57C00)),
                  title: const Text('Hardware',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(_hardwareTemplate != null
                      ? '✅ บันทึกชั่วคราวแล้ว'
                      : 'คำสั่ง Operation / ตัดกระดาษ, ลิ้นชัก'),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HardwareScreen(
                          /* TODO: อัปเดตให้รองรับปลั๊กอินใหม่ */
                          printerIndex: widget.index,
                          config: widget.config,
                        ),
                      ),
                    );
                    if (result != null && mounted) {
                      setState(() =>
                          _hardwareTemplate = result as Map<String, dynamic>);
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                color: cs.surfaceContainerLow,
                child: ListTile(
                  leading: const Icon(Icons.image_outlined,
                      color: Color(0xFF388E3C)),
                  title: const Text('Graphics',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(_graphicsTemplate != null
                      ? '✅ บันทึกชั่วคราวแล้ว'
                      : 'พิมพ์รูปภาพ / FullPrint'),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => GraphicsScreen(
                              /* TODO: อัปเดตให้รองรับปลั๊กอินใหม่ */)),
                    );
                    if (result != null && mounted) {
                      setState(() =>
                          _graphicsTemplate = result as Map<String, dynamic>);
                    }
                  },
                ),
              ),
            ],
          ),
          */

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
