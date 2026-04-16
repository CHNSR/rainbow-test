import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/printer/smile_printer_native.dart';

/// หน้าทดสอบ Network Scanner โดยเฉพาะ
class ScanNetworkScreen extends StatefulWidget {
  const ScanNetworkScreen({
    super.key,
  });

  @override
  State<ScanNetworkScreen> createState() => _ScanNetworkScreenState();
}

class _ScanNetworkScreenState extends State<ScanNetworkScreen>
    with SingleTickerProviderStateMixin {
  final _portController = TextEditingController(text: '9100');
  final _subnetController = TextEditingController(text: '192.168.1');
  final List<String> _foundPrinters = [];
  bool _isScanning = false;
  String _status = 'กด Scan เพื่อค้นหาเครื่องปริ้นเตอร์ในวงเน็ตเดียวกัน';

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _startScan() async {
    final ports = _portController.text
        .split(',')
        .map((s) => int.tryParse(s.trim()))
        .whereType<int>()
        .toList();
    final subnet = _subnetController.text.trim();

    if (ports.isEmpty) {
      setState(() => _status = 'กรุณากรอก Port ที่ถูกต้อง (เช่น 9100)');
      return;
    }
    if (subnet.isEmpty) {
      setState(() => _status = 'กรุณากรอก Subnet (เช่น 192.168.1)');
      return;
    }

    setState(() {
      _isScanning = true;
      _foundPrinters.clear();
      _status =
          'กำลังสแกน${ports.length > 1 ? " ${ports.length} พอร์ต" : " พอร์ต ${ports.first}"} กว่า 254 IPs...';
    });

    try {
      final result = await SmilePrinterService.scanNetworkPrinters(
        subnet: subnet,
        ports: ports,
      );
      if (!mounted) return;
      setState(() {
        _foundPrinters.addAll(result.map((e) => e.ip));
        _status = result.isEmpty
            ? 'ไม่พบเครื่องปริ้นเตอร์ ลองเช็ค IP/Port หรือวง LAN ดูครับ'
            : 'พบเครื่องปริ้นเตอร์ ${result.length} เครื่อง — แตะเพื่อเชื่อมต่อ';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _status = 'Scan Error: $e');
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  void _onPrinterSelected(String ip) {
    Navigator.of(context).pop(ip);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _portController.dispose();
    _subnetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isPad = screenWidth > 600; // เช็คว่าเป็นจอใหญ่หรือไม่

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text('Network Printer Scanner',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: isPad ? 24 : 30)),
        backgroundColor: cs.inversePrimary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Status Card ---
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: _isScanning
                      ? cs.primaryContainer.withOpacity(0.6)
                      : _foundPrinters.isNotEmpty
                          ? Colors.green.shade50
                          : cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isScanning
                        ? cs.primary
                        : _foundPrinters.isNotEmpty
                            ? Colors.green.shade300
                            : cs.outlineVariant,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    _isScanning
                        ? ScaleTransition(
                            scale: _pulseAnimation,
                            child: Icon(Icons.radar,
                                color: cs.primary, size: isPad ? 48 : 36),
                          )
                        : Icon(
                            _foundPrinters.isNotEmpty
                                ? Icons.print
                                : Icons.print_disabled_outlined,
                            color: _foundPrinters.isNotEmpty
                                ? Colors.green.shade600
                                : cs.onSurfaceVariant,
                            size: isPad ? 48 : 36,
                          ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        _status,
                        style: TextStyle(
                          fontSize:
                              isPad ? 18 : 15, // ขยายข้อความและทำ Responsive
                          fontWeight: FontWeight.w600,
                          color: _isScanning
                              ? cs.primary
                              : _foundPrinters.isNotEmpty
                                  ? Colors.green.shade800
                                  : cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- Subnet Input ---
              TextField(
                controller: _subnetController,
                enabled: !_isScanning,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Subnet (เช่น 192.168.1)',
                  hintText: '192.168.1',
                  prefixIcon: const Icon(Icons.network_wifi),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: cs.surfaceContainerLow,
                ),
              ),
              const SizedBox(height: 16),

              // --- Port Input ---
              TextField(
                controller: _portController,
                enabled: !_isScanning,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'พอร์ตที่จะสแกน (ใส่หลายพอร์ตคั่นด้วย ,)',
                  hintText: '9100, 4000, 9101',
                  prefixIcon: const Icon(Icons.settings_ethernet),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: cs.surfaceContainerLow,
                ),
              ),
              const SizedBox(height: 16),

              // --- Scan Button ---
              SizedBox(
                height: isPad ? 64 : 52, // ขยายปุ่มให้สูงขึ้นในจอใหญ่
                child: FilledButton.icon(
                  onPressed: _isScanning ? null : _startScan,
                  icon: _isScanning
                      ? SizedBox(
                          width: isPad ? 26 : 20,
                          height: isPad ? 26 : 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Icon(Icons.search, size: isPad ? 28 : 24),
                  label: Text(
                    _isScanning ? 'กำลังสแกนวง LAN...' : 'เริ่มสแกน',
                    style: TextStyle(
                        fontSize: isPad ? 20 : 16, fontWeight: FontWeight.bold),
                  ),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // --- Results Header ---
              if (_foundPrinters.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'ผลลัพธ์ (${_foundPrinters.length} เครื่อง)',
                    style: TextStyle(
                      fontSize: isPad ? 18 : 15,
                      fontWeight: FontWeight.bold,
                      color: cs.onSurfaceVariant,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],

              // --- Results List ---
              _foundPrinters.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.wifi_find_outlined,
                              size: isPad ? 84 : 64, color: cs.outlineVariant),
                          const SizedBox(height: 12),
                          Text(
                            'ไม่พบเครื่องปริ้นเตอร์',
                            style: TextStyle(
                                color: cs.outlineVariant,
                                fontSize: isPad ? 18 : 15),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true, // 👈 ให้หดตัวเท่าข้อมูลที่มี
                      physics:
                          const NeverScrollableScrollPhysics(), // 👈 ให้ใช้การ Scroll ของ SingleChildScrollView
                      itemCount: _foundPrinters.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final ip = _foundPrinters[index];
                        return _PrinterListTile(
                          ip: ip,
                          port: int.tryParse(_portController.text
                                  .split(',')
                                  .first
                                  .trim()) ??
                              9100,
                          onTap: () => _onPrinterSelected(ip),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrinterListTile extends StatelessWidget {
  final String ip;
  final int port;
  final VoidCallback onTap;

  const _PrinterListTile({
    required this.ip,
    required this.port,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isPad = screenWidth > 600;

    return Material(
      color: cs.primaryContainer.withOpacity(0.4),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child:
                    Icon(Icons.print, color: cs.primary, size: isPad ? 28 : 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ip,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isPad ? 20 : 16),
                    ),
                    Text(
                      'Port $port  •  แตะเพื่อเชื่อมต่อ',
                      style: TextStyle(
                          fontSize: isPad ? 15 : 12,
                          color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: isPad ? 20 : 16, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
