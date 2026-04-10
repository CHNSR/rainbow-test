import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/hive_ce/hive_ce.dart';

class StoreSetting extends StatefulWidget {
  const StoreSetting({super.key});

  @override
  State<StoreSetting> createState() => _StoreSettingState();
}

class _StoreSettingState extends State<StoreSetting> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _taxController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // โหลดข้อมูลเก่าจาก Hive มาแสดงในฟอร์ม
    _nameController =
        TextEditingController(text: HiveService.getRestaurantName());
    _phoneController =
        TextEditingController(text: HiveService.getRestaurantPhone());
    _taxController = TextEditingController(text: HiveService.getTaxRate());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _taxController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // บันทึกค่าลง Hive Database
    await HiveService.setRestaurantName(_nameController.text.trim());
    await HiveService.setRestaurantPhone(_phoneController.text.trim());
    await HiveService.setTaxRate(_taxController.text.trim());

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Store settings saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // กลับไปหน้า Store Main Page
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Store Settings",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSectionTitle("General Information"),
            _buildCard([
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Restaurant Name",
                  prefixIcon: Icon(Icons.storefront),
                  border: OutlineInputBorder(),
                ),
                validator: (val) => (val == null || val.isEmpty)
                    ? "Please enter restaurant name"
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle("Financial & Tax"),
            _buildCard([
              TextFormField(
                controller: _taxController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: "Tax Rate (%)",
                  prefixIcon: Icon(Icons.percent),
                  border: OutlineInputBorder(),
                  hintText: "e.g. 7.0",
                ),
                validator: (val) {
                  if (val != null && val.isNotEmpty) {
                    if (double.tryParse(val) == null)
                      return "Invalid number format";
                  }
                  return null;
                },
              ),
            ]),
            const SizedBox(height: 32),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF496EE2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.save),
                label: const Text("Save Settings",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(title.toUpperCase(),
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
              letterSpacing: 1.2)),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200)),
      child: Padding(
          padding: const EdgeInsets.all(16), child: Column(children: children)),
    );
  }
}
