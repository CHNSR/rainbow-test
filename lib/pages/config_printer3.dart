import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import จาก Driver Printer
import 'package:driver_printer/driver_printer.dart';
import 'package:driver_printer/driver_printer_entities.dart' as dp;
import 'package:driver_printer/command_printer.dart';

class ConfigPrinter3 extends StatefulWidget {
  final int? index;
  final PrinterConfig? config;

  const ConfigPrinter3({
    super.key,
    this.index,
    this.config,
  });

  @override
  State<ConfigPrinter3> createState() => _ConfigPrinter3State();
}

class _ConfigPrinter3State extends State<ConfigPrinter3> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // ==========================================
  // 1. ฟิลด์ข้อมูลพื้นฐานของแอป (แบบเดิม)
  // ==========================================
  final nameController = TextEditingController();
  String printerCategory = "kitchen"; // kitchen / cashier
  String paperSize = "80"; // 58 / 80

  bool _isAutoCut = true;
  bool _isBeep = false;
  bool _printPrice = true;

  // ==========================================
  // 2. ฟิลด์ข้อมูลเชิงลึกจาก Plugin
  // ==========================================
  final gatewayController = TextEditingController(text: 'posx');
  final modelController = TextEditingController(text: 'generic');
  final ipController = TextEditingController();
  final usbNameController = TextEditingController();
  final portController = TextEditingController(text: '9100');
  final timeoutController = TextEditingController(text: '10000');
  final maxCharacterController = TextEditingController(text: '48');

  bool useIp = true;
  bool isThermal = true;
  bool useNative = true;

  // ฟิลด์สำหรับการทดสอบ (Test Action)
  bool isPrint = true;
  bool opCashDrawer = true;
  bool opBuzzer = false;

  final List<String> gateways = const [
    'posx',
    'epson',
    'star',
    'esc_command',
    'vpos',
    'bixolon',
    'custom',
    'element'
  ];
  final List<String> models = const [
    'generic',
    'TM-M30',
    'TM-U220',
    'TM-T20',
    'TM-T82',
    'TSP-100III',
    'TSP-100IV',
    'SP-742'
  ];

  final _driverPrinter = DriverPrinter();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  void _loadConfig() {
    if (widget.config != null) {
      final c = widget.config!;
      nameController.text = c.name;
      printerCategory = c.category;
      paperSize = c.paperSize;
      portController.text = c.port.toString();

      _isAutoCut = c.isAutoCut ?? true;
      _isBeep = c.isBeep ?? false;
      _printPrice = c.printPrice ?? true;

      // โหลดการตั้งค่าขั้นสูงของปลั๊กอินที่แพ็คเก็บไว้ใน hardwareTemplate
      final extra = c.hardwareTemplate ?? {};
      gatewayController.text = extra['gateway'] ?? 'posx';
      modelController.text = extra['model'] ?? 'generic';
      isThermal = extra['isThermal'] ?? true;
      useIp = extra['useIp'] ?? true;
      useNative = extra['useNative'] ?? true;
      timeoutController.text = extra['timeout'] ?? '10000';
      maxCharacterController.text =
          extra['maxChar'] ?? (paperSize == "80" ? "48" : "32");

      if (useIp) {
        ipController.text = c.ip;
      } else {
        usbNameController.text = c.ip; // ถ้าเป็น USB จะเก็บชื่อลงใน ip แทน
      }
    }
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    // แพ็คค่า Advanced Config ลงใน Map
    final extraConfig = {
      'gateway': gatewayController.text,
      'model': modelController.text,
      'isThermal': isThermal,
      'useIp': useIp,
      'useNative': useNative,
      'timeout': timeoutController.text,
      'maxChar': maxCharacterController.text,
    };

    final config = PrinterConfig(
      name: nameController.text,
      ip: useIp ? ipController.text : usbNameController.text,
      port: int.tryParse(portController.text) ?? 9100,
      paperSize: paperSize,
      category: printerCategory,
      isAutoCut: _isAutoCut,
      isBeep: _isBeep,
      printPrice: _printPrice,
      hardwareTemplate: extraConfig, // 👈 เก็บซ่อนไว้ที่นี่
    );

    if (widget.index != null) {
      context.read<PrinterBloc>().add(EditPrinter(widget.index!, config));
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✏️ Updated Configuration")));
    } else {
      context.read<PrinterBloc>().add(AddPrinter(config));
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("✅ Saved Configuration")));
    }

    AppNavigator.goBack(context);
  }

  Future<void> _onSendTest() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final escService = CommandPrinterService(
      cmd: EscPosCommand(),
      connection: useIp ? TcpPrinter() : UsbPrinter(),
    );

    final value = dp.PrinterValue(
      model: modelController.text,
      ip: useIp ? ipController.text : null,
      usbName: useIp ? null : usbNameController.text,
      printerName:
          nameController.text.isEmpty ? 'Test Printer' : nameController.text,
      timeout: int.tryParse(timeoutController.text) ?? 10000,
      cutPaper: _isAutoCut ? 1 : 0,
      maxChar: int.tryParse(maxCharacterController.text) ?? 32,
      printerType: isThermal ? 'thermal' : 'dotMatrix',
      data: dp.PrinterData(
        sendText: isPrint
            ? dp.SendText(
                mode: 0,
                dataReceipt: [
                  dp.DataReceipt(
                      text: "TEST CONNECTION",
                      isBold: true,
                      alignment: 'center',
                      textSize: 24),
                  dp.DataReceipt(
                      text: "Gateway: ${gatewayController.text}",
                      alignment: 'left',
                      textSize: 16),
                  dp.DataReceipt(
                      text:
                          "Target: ${useIp ? ipController.text : usbNameController.text}",
                      alignment: 'left',
                      textSize: 16),
                  dp.DataReceipt(
                      text: "Category: $printerCategory",
                      alignment: 'left',
                      textSize: 16),
                  dp.DataReceipt(
                      text: "\n\n\n", alignment: 'left', textSize: 16),
                ],
              )
            : null,
        sendOperation: !isPrint
            ? dp.SendOperation(
                buzzer: opBuzzer ? 1 : 0, cashDrawer: opCashDrawer ? 1 : 0)
            : dp.SendOperation(buzzer: _isBeep ? 1 : 0, cashDrawer: 0),
      ),
    );

    final cfg = dp.PrinterConfig(gateway: gatewayController.text, value: value);

    try {
      String resConn;
      String resAction;

      if (useNative) {
        resConn = await _driverPrinter.connect(cfg);
        if (isPrint) {
          resAction = await _driverPrinter.printData(cfg);
        } else {
          resAction = await _driverPrinter.printOperation(cfg);
        }
        await _driverPrinter.disconnectPrinter(cfg);
      } else {
        resConn = await escService.connect(cfg);
        if (isPrint) {
          resAction = await escService.printData(cfg);
        } else {
          resAction = await escService.operation(cfg);
        }
        await escService.disconnectPrinter();
      }
      if (mounted)
        _showSnack('Success', 'Connect: $resConn\nAction: $resAction',
            isError: false);
    } catch (e) {
      if (mounted) _showSnack('Error', e.toString(), isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnack(String title, String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        content:
            Text('$title\n$msg', style: const TextStyle(color: Colors.white)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.index != null
                ? "Edit Printer (Advanced)"
                : "Add Printer (Advanced)",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: cs.inversePrimary,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // ---------------- 1. Printer Details (แอป) ----------------
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
                    value: paperSize,
                    items: const [
                      DropdownMenuItem(value: "58", child: Text("58 mm")),
                      DropdownMenuItem(value: "80", child: Text("80 mm")),
                    ],
                    onChanged: (val) {
                      setState(() {
                        paperSize = val!;
                        maxCharacterController.text =
                            (val == "80") ? "48" : "32";
                      });
                    },
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
                      DropdownMenuItem(
                          value: "kitchen", child: Text("Kitchen")),
                      DropdownMenuItem(
                          value: "cashier", child: Text("Cashier")),
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

            const SizedBox(height: 24),

            // ---------------- 2. Connection Settings (Plugin) ----------------
            const SectionHeader(
                icon: Icons.electrical_services_outlined,
                label: 'Connection & Engine'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: gatewayController.text,
                    items: gateways
                        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                        .toList(),
                    decoration: InputDecoration(
                        labelText: 'Gateway',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onChanged: (v) =>
                        setState(() => gatewayController.text = v ?? 'posx'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: models.contains(modelController.text)
                        ? modelController.text
                        : 'generic',
                    items: models
                        .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                        .toList(),
                    decoration: InputDecoration(
                        labelText: 'Model',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onChanged: (v) =>
                        setState(() => modelController.text = v ?? 'generic'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Network (IP)')),
                ButtonSegment(value: false, label: Text('USB Device')),
              ],
              selected: {useIp},
              onSelectionChanged: (s) => setState(() => useIp = s.first),
            ),
            const SizedBox(height: 12),
            if (useIp)
              PrinterTextField(
                  controller: ipController,
                  label: 'IP Address',
                  icon: Icons.router_outlined)
            else
              PrinterTextField(
                  controller: usbNameController,
                  label: 'USB Device Name',
                  icon: Icons.usb),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: PrinterTextField(
                        controller: portController,
                        label: 'Port',
                        icon: Icons.numbers)),
                const SizedBox(width: 12),
                Expanded(
                    child: PrinterTextField(
                        controller: timeoutController,
                        label: 'Timeout (ms)',
                        icon: Icons.timer)),
              ],
            ),
            const SizedBox(height: 12),
            SwitchListTile.adaptive(
              title: const Text("Use Native Engine"),
              subtitle: const Text("Off = ใช้ Dart ESC/POS Command"),
              value: useNative,
              onChanged: (v) => setState(() => useNative = v),
            ),

            const SizedBox(height: 24),

            // ---------------- 3. Basic Settings ----------------
            const SectionHeader(
                icon: Icons.settings, label: 'Printer Settings'),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              color: cs.surfaceContainerLow,
              child: Column(
                children: [
                  SwitchListTile.adaptive(
                    title: const Text("Auto Cut Paper",
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    value: _isAutoCut,
                    onChanged: (val) => setState(() => _isAutoCut = val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile.adaptive(
                    title: const Text("Beep Sound",
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    value: _isBeep,
                    onChanged: (val) => setState(() => _isBeep = val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile.adaptive(
                    title: const Text("Print Price (Cashier)",
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    value: _printPrice,
                    onChanged: (val) => setState(() => _printPrice = val),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ---------------- 4. Action & Testing ----------------
            const SectionHeader(
                icon: Icons.monitor_heart_outlined, label: 'Action & Testing'),
            const SizedBox(height: 12),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Print Receipt')),
                ButtonSegment(value: false, label: Text('Operation Only')),
              ],
              selected: {isPrint},
              onSelectionChanged: (s) => setState(() => isPrint = s.first),
            ),
            if (!isPrint) ...[
              const SizedBox(height: 12),
              SwitchListTile.adaptive(
                  title: const Text('Open Cash Drawer'),
                  value: opCashDrawer,
                  onChanged: (v) => setState(() => opCashDrawer = v)),
              SwitchListTile.adaptive(
                  title: const Text('Buzzer'),
                  value: opBuzzer,
                  onChanged: (v) => setState(() => opBuzzer = v)),
            ],
            const SizedBox(height: 12),
            ActionButton(
              label: _isLoading ? 'Sending...' : 'Send Test Command',
              icon: Icons.send,
              outlined: true,
              onTap: _isLoading ? null : _onSendTest,
            ),

            const SizedBox(height: 32),

            // ---------------- Save Buttons ----------------
            Row(
              children: [
                Expanded(
                  child: ActionButton(
                    label: 'Clear',
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
      ),
    );
  }
}
