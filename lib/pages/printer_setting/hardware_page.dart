import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_printer_01/flutter_printer_01.dart';
import 'package:flutter_printer_01/src/modules/printer_hardware.dart';
import 'package:flutter_application_1/config/export.dart';

class HardwareScreen extends StatefulWidget {
  final FlutterPrinter01 plugin;
  final int? printerIndex;
  final PrinterConfig? config;

  const HardwareScreen({
    super.key,
    required this.plugin,
    this.printerIndex,
    this.config,
  });

  @override
  State<HardwareScreen> createState() => _HardwareScreenState();
}

class _HardwareScreenState extends State<HardwareScreen> {
  final _rawBytesController = TextEditingController(text: '29, 86, 66, 0');
  bool _isLoading = false;
  String _status = '';
  bool _success = false;
  PrinterStatus? _printerStatus;
  bool _cutpaper = true;
  int _beepCount = 0;
  final TextEditingController _beepController =
      TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();
    // ⚠️ ถ้า Model มี Field แล้ว ให้ดึงค่าเริ่มต้นมาเซ็ตตรงนี้ครับ
    // if (widget.config != null) {
    //   _cutpaper = widget.config!.isAutoCut;
    //   _beepCount = widget.config!.beepCount;
    //   _beepController.text = _beepCount.toString();
    // }
  }

  void _saveHardwareConfig() {
    if (widget.printerIndex == null || widget.config == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                '❌ ไม่พบ Index ปริ้นเตอร์ที่จะบันทึก (ต้องส่งมาจากหน้าก่อนหน้า)')),
      );
      return;
    }

    // ⚠️ ต้องไปเพิ่ม field isAutoCut, beepCount ในโมเดล PrinterConfig ก่อน
    /*
    final updatedConfig = PrinterConfig(
      name: widget.config!.name,
      ip: widget.config!.ip,
      port: widget.config!.port,
      paperSize: widget.config!.paperSize,
      category: widget.config!.category,
      // isAutoCut: _cutpaper,
      // beepCount: _beepCount,
    );

    // 📥 ส่ง Event เข้า Bloc เพื่อบันทึกลง Database (Hive)
    context.read<PrinterBloc>().add(EditPrinter(widget.printerIndex!, updatedConfig));
    */

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content:
              Text('✅ (จำลอง) บันทึกการตั้งค่า Hardware เข้า BLoC สำเร็จ')),
    );
  }

  Future<void> _checkPrinterStatus() async {
    setState(() => _isLoading = true);
    try {
      final status = await widget.plugin.hardware.getPrinterStatus();
      setState(() {
        _printerStatus = status;
        _success = status.isSuccess;
        _status = status.isSuccess
            ? 'สถานะ: ${status.state.name}\n${status.toString()}'
            : 'ดึงสถานะไม่สำเร็จ';
      });
    } catch (e) {
      setState(() {
        _success = false;
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _cutPaper() async {
    setState(() => _isLoading = true);
    try {
      final ok = await widget.plugin.hardware.cutPaper();
      setState(() {
        _success = ok;
        _status = ok ? '✅ ตัดกระดาษสำเร็จ' : '❌ ตัดกระดาษล้มเหลว';
      });
    } catch (e) {
      setState(() {
        _success = false;
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sendCustomBytes() async {
    final parts = _rawBytesController.text
        .split(',')
        .map((s) => int.tryParse(s.trim()))
        .whereType<int>()
        .toList();
    if (parts.isEmpty) {
      setState(() {
        _success = false;
        _status = 'กรุณากรอก Bytes ที่ถูกต้อง เช่น 27, 64';
      });
      return;
    }
    setState(() => _isLoading = true);
    try {
      final ok = await widget.plugin.hardware.sendRawBytes(parts);
      setState(() {
        _success = ok;
        _status =
            ok ? '✅ Raw Bytes [${parts.join(', ')}] ส่งสำเร็จ' : '❌ ส่งล้มเหลว';
      });
    } catch (e) {
      setState(() {
        _success = false;
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _beep({int times = 2, int duration = 2}) async {
    setState(() => _isLoading = true);
    try {
      final ok = await widget.plugin.hardware.beep(
        times: times,
        duration: duration,
      );
      setState(() {
        _success = ok;
        _status = ok ? '✅ Beep ส่งสำเร็จ' : '❌ ส่งล้มเหลว';
      });
    } catch (e) {
      setState(() {
        _success = false;
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _rawBytesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Hardware Control',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 40),
        children: [
          // ── Printer Status ──────────────────────────────────────────────────
          _buildSection(
            title: 'Printer Status',
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: ActionButton(
                  label: 'Test Print Receipt',
                  icon: Icons.refresh,
                  onTap: (!_isLoading) ? _checkPrinterStatus : null,
                  loading: _isLoading,
                  outlined: true,
                ),
              ),
              if (_printerStatus != null) ...[
                const Divider(height: 1),
                _StatusInfoTile(
                  icon: Icons.power_settings_new,
                  label: 'State',
                  value: _printerStatus!.state.name.toUpperCase(),
                  isSuccess: _printerStatus!.isOnline,
                ),
                _StatusInfoTile(
                  icon: Icons.circle,
                  label: 'Send',
                  value: _printerStatus!.isOnline ? "Yes" : "No",
                  isSuccess: _printerStatus!.isOnline,
                ),
                _StatusInfoTile(
                  icon: Icons.feed_outlined,
                  label: 'Paper Feed Button',
                  value: _printerStatus!.isPaperFeedButtonPressed
                      ? "Pushed"
                      : "Idle",
                ),
              ],
            ],
          ),

          // ── Actions ──────────────────────────────────────────────────
          _buildSection(
            title: 'Hardware Actions',
            children: [
              ListTile(
                leading: const Icon(Icons.content_cut),
                title: const Text(
                  'Auto Cut Paper',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text('Automatically cut after printing'),
                trailing: Switch(
                  value: _cutpaper,
                  onChanged: (value) {
                    setState(() {
                      _cutpaper = value;
                    });
                  },
                ),
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              ListTile(
                leading: const Icon(Icons.volume_up_outlined),
                title: const Text(
                  'Beep Sound',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text('Enter number of beeps'),
                trailing: SizedBox(
                  width: 70,
                  child: TextField(
                    controller: _beepController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      final parsed = int.tryParse(value) ?? 0;

                      setState(() {
                        _beepCount = parsed.clamp(0, 10); // กันใส่เยอะเกิน
                      });
                    },
                  ),
                ),
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ActionButton(
                  label: 'Save Hardware Config',
                  icon: Icons.save,
                  onTap: _saveHardwareConfig,
                ),
              ),
            ],
          ),

          // ── Advanced ──────────────────────────────────────────────────
          _buildSection(
            title: 'Advanced: Custom Command',
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _rawBytesController,
                      keyboardType: TextInputType.number,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        labelText: 'ESC/POS Bytes (comma-separated)',
                        hintText: 'e.g., 27, 64 or 29, 86, 66, 0',
                        prefixIcon: const Icon(Icons.data_array_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: cs.surfaceContainerLow,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ActionButton(
                      label: 'Send Raw Bytes',
                      icon: Icons.send_outlined,
                      outlined: true,
                      onTap: (!_isLoading) ? _sendCustomBytes : null,
                      loading: _isLoading,
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (_status.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: StatusCard(isConnected: _success, status: _status),
            ),
          ],
        ],
      ),
    );
  }

  /// Section Wrapper (เหมือนหน้า SettingPage)
  Widget _buildSection(
      {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _StatusInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool? isSuccess;

  const _StatusInfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.isSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Color valueColor = cs.onSurface;
    if (isSuccess != null) {
      valueColor = isSuccess! ? Colors.green.shade700 : cs.error;
    }

    return ListTile(
      dense: true,
      leading: Icon(icon,
          color: isSuccess == null
              ? cs.onSurfaceVariant
              : (isSuccess! ? Colors.green.shade600 : cs.error)),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Text(
        value,
        style: TextStyle(fontWeight: FontWeight.bold, color: valueColor),
      ),
    );
  }
}
