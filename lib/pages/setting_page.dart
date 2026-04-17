import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_application_1/model/app_user.dart';
import 'package:flutter_application_1/service/hive_ce/hive_ce.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
      body: BlocBuilder<StoreManagementBloc, StoreManagementState>(
        builder: (context, storeState) {
          bool isLoggedOut = true;
          String currentUserName = "Guest";
          String currentUserRole = "Guest";

          // เช็คสถานะการล็อกอินจาก StoreManagementBloc
          if (storeState is StoreManagementLoaded &&
              storeState.currentUser != null) {
            isLoggedOut = false;
            currentUserName = storeState.currentUser!.name;
            currentUserRole = storeState.currentUser!.role;
          }

          return BlocBuilder<SettingBloc, SettingState>(
            builder: (context, state) {
              if (state is SettingInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              bool isTogo = true;
              bool isToStay = true;
              bool isShowFoodSet = true;

              if (state is SettingLoaded) {
                isTogo = state.isTogo;
                isToStay = state.isStay;
                isShowFoodSet = state.isShowFoodSet;
              }

              return ListView(
                padding: const EdgeInsets.only(bottom: 40),
                children: [
                  _buildSection(title: "Account & Login", children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: isLoggedOut
                                ? Colors.grey.shade200
                                : cs.primaryContainer,
                            child: Icon(
                              isLoggedOut ? Icons.person_outline : Icons.person,
                              size: 30,
                              color: isLoggedOut
                                  ? Colors.grey.shade500
                                  : cs.primary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isLoggedOut
                                      ? "Guest Account"
                                      : currentUserName,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isLoggedOut
                                      ? "Please login to access settings"
                                      : "Role: $currentUserRole",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                          if (isLoggedOut)
                            ElevatedButton.icon(
                              onPressed: () => _showPinDialog(context),
                              icon: const Icon(Icons.login, size: 18),
                              label: const Text("Login"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cs.primary,
                                foregroundColor: cs.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            )
                          else
                            OutlinedButton.icon(
                              onPressed: () {
                                context
                                    .read<StoreManagementBloc>()
                                    .add(const SetCurrentUserEvent(null));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Logged out successfully")),
                                );
                              },
                              icon: const Icon(Icons.logout, size: 18),
                              label: const Text("Logout"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red.shade600,
                                side: BorderSide(color: Colors.red.shade200),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ]),

                  // 🔒 ซ่อนส่วนอื่นๆ ถ้ายังไม่ได้ Login
                  if (!isLoggedOut) ...[
                    _buildSection(
                      title: "Order Preferences",
                      children: [
                        _buildToggleTile(
                          icon: Icons.shopping_bag_outlined,
                          title: "Togo",
                          subtitle: "Enable take-away orders",
                          value: isTogo,
                          onChanged: (value) => context
                              .read<SettingBloc>()
                              .add(ToggleTogoEvent(value)),
                        ),
                        _buildDivider(),
                        _buildToggleTile(
                          icon: Icons.restaurant_outlined,
                          title: "To Stay",
                          subtitle: "Enable dine-in orders",
                          value: isToStay,
                          onChanged: (value) => context
                              .read<SettingBloc>()
                              .add(ToggleTostayEvent(value)),
                        ),
                        _buildDivider(),
                        _buildToggleTile(
                          icon: Icons.fastfood_outlined,
                          title: "First Page Show Food Set",
                          subtitle: "Display food sets by default on home",
                          value: isShowFoodSet,
                          onChanged: (value) => context
                              .read<SettingBloc>()
                              .add(ToggleShowFoodSetEvent(value)),
                        ),
                      ],
                    ),
                    _buildSection(
                      title: "Payment & Cart",
                      children: [
                        _buildPaymentMethodTile(),
                        _buildDivider(),
                        _buildShowOrderTile(),
                        _buildDivider(),
                        _buildNavigationTile(
                          icon: Icons.history_outlined,
                          title: "History Printing",
                          subtitle: "View past print jobs and receipts",
                          onTap: () {
                            AppNavigator.goToHistoryPrinting(context);
                          },
                        ),
                        _buildDivider(),
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
                      ],
                    ),
                    _buildSection(title: "Store Settings", children: [
                      _buildNavigationTile(
                        icon: Icons.store_outlined,
                        title: "Manage Store",
                        subtitle: "Edit store info, menu, and employees",
                        onTap: () {
                          AppNavigator.goToStoreManagement(
                            context,
                            role: currentUserRole,
                            name: currentUserName,
                          );
                        },
                      ),
                      _buildDivider(),
                    ])
                  ],
                ],
              );
            },
          );
        },
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

  void _showPinDialog(BuildContext context) {
    final TextEditingController pinController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          title: const Text("Settings Login",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Please enter your PIN to access settings."),
              const SizedBox(height: 16),
              TextField(
                controller: pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: "4-Digit PIN",
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF496EE2),
                  foregroundColor: Colors.white),
              onPressed: () {
                final enteredPin = pinController.text.trim();
                bool isMatch = false;
                String userRole = 'Staff'; // Default role
                String userName = 'Guest'; // Default name
                Employee? matchedEmployee;

                final rawUsers = HiveService.getAppUsersRaw();
                if (rawUsers.isEmpty && enteredPin == "9999") {
                  isMatch =
                      true; // Fallback รหัสผ่านชั่วคราว (กรณีแอพยังไม่มีข้อมูล)
                  userRole = 'Owner';
                  userName = 'Owner';
                  matchedEmployee = Employee(
                      id: "1",
                      name: userName,
                      role: userRole,
                      pin: enteredPin,
                      hourlyWage: 0);
                } else {
                  for (var str in rawUsers) {
                    final map = jsonDecode(str);
                    if (map['pin'] == enteredPin && map['isActive'] == true) {
                      isMatch = true;
                      userRole = map['role'] as String? ?? 'Staff';
                      userName = map['name'] as String? ?? 'Staff';
                      matchedEmployee = Employee.fromJson(map);
                      break;
                    }
                  }
                }

                if (isMatch) {
                  // 🧑‍💼 บันทึกข้อมูลพนักงานที่ Login ลงใน State ของแอป
                  context
                      .read<StoreManagementBloc>()
                      .add(SetCurrentUserEvent(matchedEmployee));

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("✅ Logged in as $userName"),
                      backgroundColor: Colors.green));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("❌ Incorrect PIN!"),
                      backgroundColor: Colors.red));
                }
              },
              child: const Text("Enter"),
            ),
          ],
        );
      },
    );
  }
}
