import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_printer_01/flutter_printer_01.dart';

class PrinterSetting extends StatefulWidget {
  const PrinterSetting({super.key});

  @override
  State<PrinterSetting> createState() => _PrinterSettingState();
}

class _PrinterSettingState extends State<PrinterSetting> {
  final _plugin = FlutterPrinter01();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final modules = [
      ModuleItem(
        icon: Icons.text_fields_outlined,
        label: 'Text',
        subtitle: 'พิมพ์ข้อความ / Print Text',
        color: const Color(0xFF5C6BC0),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TextScreen(
              plugin: _plugin,
            ),
          ),
        ),
      ),
      ModuleItem(
        icon: Icons.hardware_outlined,
        label: 'Hardware',
        subtitle: 'Raw Bytes, ESC/POS Commands',
        color: const Color(0xFFF57C00),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HardwareScreen(plugin: _plugin),
          ),
        ),
      ),
      ModuleItem(
        icon: Icons.image_outlined,
        label: 'Graphics',
        subtitle: 'Widget, รูปภาพ, QR Code, Barcode',
        color: const Color(0xFF388E3C),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GraphicsScreen(plugin: _plugin),
          ),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text(
              'Printer Plugin Tester',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: cs.surface,
            surfaceTintColor: Colors.transparent,
            expandedHeight: 160,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
                child: Row(
                  children: [],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            sliver: SliverList.separated(
              itemCount: modules.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) => ModuleCard(item: modules[i]),
            ),
          ),
        ],
      ),
    );
  }
}
