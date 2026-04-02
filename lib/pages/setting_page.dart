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
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text("Settings",
              style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          surfaceTintColor: Colors.transparent),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 40),
        children: [
          _buildSection(
            title: "Order Preferences",
            children: [
              _buildToggleTile(
                icon: Icons.shopping_bag_outlined,
                title: "Togo",
                subtitle: "Enable take-away orders",
                value: isTogo,
                onChanged: (value) => setState(() => isTogo = value),
              ),
              _buildDivider(),
              _buildToggleTile(
                icon: Icons.restaurant_outlined,
                title: "To Stay",
                subtitle: "Enable dine-in orders",
                value: isToStay,
                onChanged: (value) => setState(() => isToStay = value),
              ),
              _buildDivider(),
              _buildToggleTile(
                icon: Icons.fastfood_outlined,
                title: "First Page Show Food Set",
                subtitle: "Display food sets by default on home",
                value: isShowFoodSet,
                onChanged: (value) => setState(() => isShowFoodSet = value),
              ),
            ],
          ),
          _buildSection(
            title: "Payment & Cart",
            children: [
              _buildPaymentMethodTile(),
              _buildDivider(),
              _buildShowOrderTile(),
            ],
          ),
          _buildSection(
            title: "Hardware & System",
            children: [
              _buildNavigationTile(
                icon: Icons.print_outlined,
                title: "Config Printer",
                subtitle: "Manage network and USB printers",
                onTap: () => AppNavigator.goToPrinterList(context),
              ),
              _buildDivider(),
              _buildNavigationTile(
                icon: Icons.settings_ethernet,
                title: "Connect Setting",
                subtitle: "Setup device connections",
                onTap: () {
                  // Navigation.push(context, MaterialPageRoute(builder: (context) => const ConnectionPrinter2()));
                },
              ),
              _buildDivider(),
              _buildNavigationTile(
                icon: Icons.access_time_outlined,
                title: "Setting Timing",
                subtitle: "Configure business hours & delays",
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Section Wrapper
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
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  /// Custom Divider
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 56),
      child: Divider(height: 1, color: Colors.grey.shade100),
    );
  }

  /// Toggle Tile Widget
  Widget _buildToggleTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade700),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null
          ? Text(subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500))
          : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    );
  }

  /// Payment Method Tile
  Widget _buildPaymentMethodTile() {
    return ListTile(
      leading: Icon(Icons.credit_card, color: Colors.grey.shade700),
      title: const Text(
        "Payment Methods / Credit Card",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        "Tap, Touch, Swipe Card for Pay",
        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      onTap: () {
        // TODO: Navigate to payment settings
      },
    );
  }

  /// Show Order Tile with Button
  Widget _buildShowOrderTile() {
    return ListTile(
      leading: Icon(Icons.shopping_cart_outlined, color: Colors.grey.shade700),
      title: const Text(
        "Show My Order / Cart",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: FilledButton.tonal(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        ),
        onPressed: () {
          // TODO: Show order/cart modal or navigate
        },
        child: const Text(
          "SHOW",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    );
  }

  /// Navigation Tile
  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade700),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null
          ? Text(subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500))
          : null,
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      onTap: onTap,
    );
  }
}
