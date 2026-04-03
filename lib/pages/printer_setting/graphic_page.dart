import 'dart:typed_data';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_printer_01/flutter_printer_01.dart';
import 'package:flutter_printer_01/src/modules/printer_graphics.dart';
import 'package:flutter_application_1/config/export.dart';

class GraphicsScreen extends StatefulWidget {
  final FlutterPrinter01 plugin;

  const GraphicsScreen({
    super.key,
    required this.plugin,
  });

  @override
  State<GraphicsScreen> createState() => _GraphicsScreenState();
}

class _GraphicsScreenState extends State<GraphicsScreen> {
  bool _isLoading = false;
  String _status = '';
  bool _success = false;

  // Widget print key
  final GlobalKey _repaintKey = GlobalKey();

  // QR / Barcode
  final _qrController = TextEditingController(text: 'https://example.com');
  final _barcodeController = TextEditingController(text: '1234567890');

  int _qrModuleSize = 6;
  int _barcodeHeight = 80;
  int _barcodeWidth = 2;
  BarcodeHri _hri = BarcodeHri.below;

  void _setStatus(bool ok, String msg) => setState(() {
        _success = ok;
        _status = msg;
        _isLoading = false;
      });

  // ── Print QR ─────────────────────────────────────────────────────────────
  Future<void> _printQr() async {
    setState(() => _isLoading = true);
    try {
      final ok = await widget.plugin.graphics.printQrCode(
        _qrController.text,
        moduleSize: _qrModuleSize,
      );
      _setStatus(ok, ok ? '✅ QR Code ส่งสำเร็จ' : '❌ ส่ง QR ล้มเหลว');
    } catch (e) {
      _setStatus(false, 'Error: $e');
    }
  }

  // ── Print Barcode ─────────────────────────────────────────────────────────
  Future<void> _printBarcode() async {
    setState(() => _isLoading = true);
    try {
      final ok = await widget.plugin.graphics.printBarcode(
        _barcodeController.text,
        height: _barcodeHeight,
        width: _barcodeWidth,
        hri: _hri,
      );
      _setStatus(ok, ok ? '✅ Barcode ส่งสำเร็จ' : '❌ ส่ง Barcode ล้มเหลว');
    } catch (e) {
      _setStatus(false, 'Error: $e');
    }
  }

  @override
  void dispose() {
    _qrController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Graphics Printing',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: cs.inversePrimary,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── QR Code (Native) ──────────────────────────────────────
          const SectionHeader(
              icon: Icons.qr_code_2_outlined,
              label: 'QR Code (Native ESC/POS)'),
          const SizedBox(height: 12),
          TextField(
            controller: _qrController,
            enabled: !_isLoading,
            decoration: InputDecoration(
              labelText: 'QR Data (URL หรือข้อความ)',
              prefixIcon: const Icon(Icons.link_outlined),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: cs.surfaceContainerLow,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Module Size:',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              Expanded(
                child: Slider(
                  value: _qrModuleSize.toDouble(),
                  min: 1,
                  max: 16,
                  divisions: 15,
                  label: '$_qrModuleSize',
                  onChanged: (v) => setState(() => _qrModuleSize = v.round()),
                ),
              ),
              Text('$_qrModuleSize',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: cs.primary)),
            ],
          ),
          ActionButton(
            label: 'Test Print QR Code',
            icon: Icons.qr_code_2,
            onTap: (!_isLoading) ? _printQr : null,
            loading: _isLoading,
          ),

          const SizedBox(height: 28),
          const Divider(),
          const SizedBox(height: 16),

          // ── Barcode (Native) ──────────────────────────────────────
          const SectionHeader(
              icon: Icons.barcode_reader,
              label: 'Barcode Code128 (Native ESC/POS)'),
          const SizedBox(height: 12),
          TextField(
            controller: _barcodeController,
            enabled: !_isLoading,
            decoration: InputDecoration(
              labelText: 'Barcode Data',
              prefixIcon: const Icon(Icons.numbers_outlined),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: cs.surfaceContainerLow,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Height:',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
              Expanded(
                child: Slider(
                  value: _barcodeHeight.toDouble(),
                  min: 20,
                  max: 200,
                  divisions: 18,
                  label: '$_barcodeHeight',
                  onChanged: (v) => setState(() => _barcodeHeight = v.round()),
                ),
              ),
              Text('$_barcodeHeight',
                  style: TextStyle(
                      color: cs.primary, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              const Text('Width:',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
              Expanded(
                child: Slider(
                  value: _barcodeWidth.toDouble(),
                  min: 1,
                  max: 6,
                  divisions: 5,
                  label: '$_barcodeWidth',
                  onChanged: (v) => setState(() => _barcodeWidth = v.round()),
                ),
              ),
              Text('$_barcodeWidth',
                  style: TextStyle(
                      color: cs.primary, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          const Text('HRI (Human Readable):',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: BarcodeHri.values
                .map((h) => ChoiceChip(
                      label: Text(h.name, style: const TextStyle(fontSize: 12)),
                      selected: _hri == h,
                      onSelected: (_) => setState(() => _hri = h),
                    ))
                .toList(),
          ),
          const SizedBox(height: 28),
          ActionButton(
            label: 'Save Graphic Config',
            icon: Icons.save,
            onTap: () {
              final templateData = {
                'qrModuleSize': _qrModuleSize,
                'barcodeHeight': _barcodeHeight,
                'barcodeWidth': _barcodeWidth,
                'hri': _hri.name,
              };

              log('📤 Sending Graphic Template: $templateData');
              Navigator.pop(context, templateData);
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
