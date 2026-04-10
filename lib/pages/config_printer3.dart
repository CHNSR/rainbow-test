import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import จาก Driver Printer
import 'package:driver_printer/driver_printer.dart';
import 'package:driver_printer/driver_printer_entities.dart' as dp;
import 'package:driver_printer/command_printer.dart';
import 'package:flutter_application_1/model/printer_enums.dart';
import 'package:flutter_application_1/pages/setting/printer_setting_pages/scan_usb_screen.dart';

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
  final timeoutController = TextEditingController(text: '5000');
  final maxCharacterController = TextEditingController(text: '48');

  bool useIp = true;
  bool isThermal = true;
  bool useNative = true;

  // ฟิลด์สำหรับการทดสอบ (Test Action)
  bool isPrint = true;
  bool opCashDrawer = true;
  bool opBuzzer = false;

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
      timeoutController.text = extra['timeout'] ?? '5000';
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
    final screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final bool isPad = screenWidth > 600;

    // 📏 Fixed & Predictable Sizing (ลบสูตรคูณ % หน้าจอที่ทำให้ UI เพี้ยน)
    final double textSize = isPad ? 16.0 : 14.0;
    final double H1Size = isPad ? 22.0 : 18.0;
    final double H2Size = isPad ? 18.0 : 16.0;
    final double spacing = isPad ? 20.0 : 16.0;

    // 🛠️ Helper สำหรับสร้างกล่องครอบแต่ละ Section ให้ดูคลีนและจัด Group
    Widget buildCard(List<Widget> children) {
      return Container(
        padding: EdgeInsets.all(spacing),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      );
    }

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest, // พื้นหลังให้สว่างสุด
      appBar: AppBar(
        title: Text(
            widget.index != null
                ? "Edit Printer (Advanced)"
                : "Add Printer (Advanced)",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: H1Size)),
        backgroundColor: cs.inversePrimary,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          // คุมความกว้างไม่ให้ยืดเต็มจอเกินไปใน Tablet/Web
          padding: EdgeInsets.symmetric(
              horizontal: isPad ? screenWidth * 0.03 : 20, vertical: 24),
          children: [
            // ---------------- 1. Printer Details (แอป) ----------------
            SectionHeader(
                sizetext: H2Size,
                icon: Icons.info_outline,
                label: 'Printer Details'),
            const SizedBox(height: 12),
            buildCard([
              PrinterTextField(
                controller: nameController,
                label: 'Name of printer',
                icon: Icons.print,
                textSize: textSize,
                validator: (val) => (val == null || val.trim().isEmpty)
                    ? 'กรุณากรอกชื่อเครื่องพิมพ์'
                    : null,
              ),
              SizedBox(height: spacing),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: paperSize,
                      style: TextStyle(fontSize: textSize, color: cs.onSurface),
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
                        labelStyle: TextStyle(fontSize: textSize),
                        prefixIcon:
                            Icon(Icons.receipt_long, size: textSize + 6),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: cs.surfaceContainerLow,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: textSize * 0.9, horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: printerCategory,
                      style: TextStyle(fontSize: textSize, color: cs.onSurface),
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
                        labelStyle: TextStyle(fontSize: textSize),
                        prefixIcon: Icon(Icons.category, size: textSize + 6),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: cs.surfaceContainerLow,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: textSize * 0.9, horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ]),

            const SizedBox(height: 32),

            // ---------------- 2. Connection Settings (Plugin) ----------------
            SectionHeader(
                sizetext: H2Size,
                icon: Icons.electrical_services_outlined,
                label: 'Connection & Engine'),
            const SizedBox(height: 12),
            buildCard([
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: gatewayController.text,
                      style: TextStyle(fontSize: textSize, color: cs.onSurface),
                      items: PrinterGateway.values
                          .map((g) => DropdownMenuItem(
                                value: g.value,
                                child: Text(g.value),
                              ))
                          .toList(),
                      decoration: InputDecoration(
                          labelText: 'Gateway',
                          labelStyle: TextStyle(fontSize: textSize),
                          prefixIcon:
                              Icon(Icons.settings_ethernet, size: textSize + 6),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: cs.surfaceContainerLow,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: textSize * 0.9, horizontal: 16)),
                      onChanged: (v) =>
                          setState(() => gatewayController.text = v ?? 'posx'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: PrinterModel.values
                              .any((e) => e.value == modelController.text)
                          ? modelController.text
                          : PrinterModel.generic.value,
                      style: TextStyle(fontSize: textSize, color: cs.onSurface),
                      items: PrinterModel.values
                          .map((m) => DropdownMenuItem(
                                value: m.value,
                                child: Text(m.value),
                              ))
                          .toList(),
                      decoration: InputDecoration(
                          labelText: 'Model',
                          labelStyle: TextStyle(fontSize: textSize),
                          prefixIcon:
                              Icon(Icons.developer_board, size: textSize + 6),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: cs.surfaceContainerLow,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: textSize * 0.9, horizontal: 16)),
                      onChanged: (v) =>
                          setState(() => modelController.text = v ?? 'generic'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing),
              SegmentedButton<bool>(
                style: SegmentedButton.styleFrom(
                    textStyle: TextStyle(fontSize: textSize),
                    padding: EdgeInsets.symmetric(vertical: textSize * 0.7),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                segments: const [
                  ButtonSegment(value: true, label: Text('Network (IP)')),
                  ButtonSegment(value: false, label: Text('USB Device')),
                ],
                selected: {useIp},
                onSelectionChanged: (s) => setState(() => useIp = s.first),
              ),
              SizedBox(height: spacing),
              if (useIp)
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: PrinterTextField(
                          controller: ipController,
                          label: 'IP Address',
                          textSize: textSize,
                          icon: Icons.router_outlined,
                          validator: (val) {
                            if (useIp && (val == null || val.trim().isEmpty)) {
                              return 'กรุณากรอก IP Address';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        onPressed: () async {
                          final selectedIp = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ScanNetworkScreen()),
                          );
                          if (selectedIp != null &&
                              selectedIp is String &&
                              mounted) {
                            setState(() => ipController.text = selectedIp);
                          }
                        },
                        icon: Icon(Icons.wifi_find, size: textSize + 4),
                        label: Text('Scan',
                            style: TextStyle(
                                fontSize: textSize,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: PrinterTextField(
                        controller: usbNameController,
                        label: 'USB Device Name',
                        textSize: textSize,
                        icon: Icons.usb,
                        validator: (val) {
                          if (!useIp && (val == null || val.trim().isEmpty)) {
                            return 'กรุณากรอกชื่อ USB Device';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      onPressed: () async {
                        final selectedUsb = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ScanUsbScreen()),
                        );
                        if (selectedUsb != null &&
                            selectedUsb is String &&
                            mounted) {
                          setState(() => usbNameController.text = selectedUsb);
                        }
                      },
                      icon: Icon(Icons.usb, size: textSize + 4),
                      label: Text('Find Device',
                          style: TextStyle(
                              fontSize: textSize, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              SizedBox(height: spacing),
              Row(
                children: [
                  Expanded(
                      child: PrinterTextField(
                    controller: portController,
                    label: 'Port',
                    textSize: textSize,
                    icon: Icons.numbers,
                    validator: (val) => (val == null || val.trim().isEmpty)
                        ? 'กรุณากรอกพอร์ต'
                        : null,
                  )),
                  const SizedBox(width: 12),
                  Expanded(
                      child: PrinterTextField(
                    controller: timeoutController,
                    label: 'Timeout (ms)',
                    textSize: textSize,
                    icon: Icons.timer,
                    validator: (val) => (val == null || val.trim().isEmpty)
                        ? 'กรุณากรอก Timeout'
                        : null,
                  )),
                ],
              ),
              SizedBox(height: spacing),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text("Use Native Engine",
                    style: TextStyle(
                        fontSize: textSize, fontWeight: FontWeight.w500)),
                subtitle: Text("Off = ใช้ Dart ESC/POS Command",
                    style: TextStyle(fontSize: textSize * 0.85)),
                value: useNative,
                onChanged: (v) => setState(() => useNative = v),
              ),
            ]),

            const SizedBox(height: 32),

            // ---------------- 3. Basic Settings ----------------
            SectionHeader(
                icon: Icons.settings,
                label: 'Printer Settings',
                sizetext: H2Size),
            const SizedBox(height: 12),
            buildCard([
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text("Auto Cut Paper",
                    style: TextStyle(
                        fontWeight: FontWeight.w500, fontSize: textSize)),
                value: _isAutoCut,
                onChanged: (val) => setState(() => _isAutoCut = val),
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text("Beep Sound",
                    style: TextStyle(
                        fontWeight: FontWeight.w500, fontSize: textSize)),
                value: _isBeep,
                onChanged: (val) => setState(() => _isBeep = val),
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text("Print Price (Cashier)",
                    style: TextStyle(
                        fontWeight: FontWeight.w500, fontSize: textSize)),
                value: _printPrice,
                onChanged: (val) => setState(() => _printPrice = val),
              ),
            ]),

            const SizedBox(height: 32),

            // ---------------- 4. Action & Testing ----------------
            SectionHeader(
                icon: Icons.monitor_heart_outlined,
                label: 'Action & Testing',
                sizetext: H2Size),
            const SizedBox(height: 12),
            buildCard([
              SegmentedButton<bool>(
                style: SegmentedButton.styleFrom(
                    textStyle: TextStyle(fontSize: textSize),
                    padding: EdgeInsets.symmetric(vertical: textSize * 0.7),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                segments: const [
                  ButtonSegment(value: true, label: Text('Print Receipt')),
                  ButtonSegment(value: false, label: Text('Operation Only')),
                ],
                selected: {isPrint},
                onSelectionChanged: (s) => setState(() => isPrint = s.first),
              ),
              if (!isPrint) ...[
                SizedBox(height: spacing),
                SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Open Cash Drawer',
                        style: TextStyle(
                            fontSize: textSize, fontWeight: FontWeight.w500)),
                    value: opCashDrawer,
                    onChanged: (v) => setState(() => opCashDrawer = v)),
                const Divider(height: 1),
                SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Buzzer',
                        style: TextStyle(
                            fontSize: textSize, fontWeight: FontWeight.w500)),
                    value: opBuzzer,
                    onChanged: (v) => setState(() => opBuzzer = v)),
              ],
              SizedBox(height: spacing),
              ActionButton(
                label: _isLoading ? 'Sending...' : 'Send Test Command',
                icon: Icons.send,
                outlined: true,
                onTap: _isLoading ? null : _onSendTest,
                textSize: textSize,
              ),
            ]),

            const SizedBox(height: 48),

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
                    textSize: textSize,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ActionButton(
                    label: 'Save Config',
                    icon: Icons.save,
                    onTap: _onSave,
                    textSize: textSize,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
