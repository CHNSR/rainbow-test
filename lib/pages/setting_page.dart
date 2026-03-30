import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // Settings toggles
  bool isTogo = true;
  bool isToStay = true;
  bool isShowFoodSet = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text("Setting"),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // 1. Togo Toggle
          _buildToggleTile(
            title: "Togo",
            value: isTogo,
            onChanged: (value) {
              setState(() {
                isTogo = value;
              });
            },
          ),

          const Divider(height: 1, indent: 16, endIndent: 16),

          // 2. To Stay Toggle
          _buildToggleTile(
            title: "To Stay",
            value: isToStay,
            onChanged: (value) {
              setState(() {
                isToStay = value;
              });
            },
          ),

          const Divider(height: 1, indent: 16, endIndent: 16),

          // 3. Payment Methods / Credit Card
          _buildPaymentMethodTile(),

          const Divider(height: 1, indent: 16, endIndent: 16),

          // 4. Show My Order / Cart
          _buildShowOrderTile(),

          const Divider(height: 1, indent: 16, endIndent: 16),

          const Divider(height: 1, indent: 16, endIndent: 16),

          // 5. First Page Show Food Set Toggle
          _buildToggleTile(
            title: "First Page Show Food Set",
            subtitle: "Show Food Set",
            value: isShowFoodSet,
            onChanged: (value) {
              setState(() {
                isShowFoodSet = value;
              });
            },
          ),

          // 6. Setting Timing
          _buildNavigationTile(
            title: "Setting Timing",
            onTap: () {},
          ),

          // 7. Config
          _buildNavigationTile(
              title: "Config Printer",
              onTap: () {
                AppNavigator.goToConfigPrinter(context);
              })
        ],
      ),
    );
  }

  /// Toggle Tile Widget
  Widget _buildToggleTile({
    required String title,
    String? subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(fontSize: 12))
          : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  /// Payment Method Tile
  Widget _buildPaymentMethodTile() {
    return ListTile(
      title: const Text(
        "Payment Methods / Credit Card",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: const Text(
        "Tap, Touch, Swipe Card for Pay",
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: const Icon(Icons.credit_card, color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      onTap: () {
        // TODO: Navigate to payment settings
      },
    );
  }

  /// Show Order Tile with Button
  Widget _buildShowOrderTile() {
    return ListTile(
      title: const Text(
        "Show My Order / Cart",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          backgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        onPressed: () {
          // TODO: Show order/cart modal or navigate
        },
        child: const Text(
          "SHOW",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  /// Navigation Tile
  Widget _buildNavigationTile({
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      onTap: onTap,
    );
  }
}
