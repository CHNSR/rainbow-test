import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_application_1/service/hive_ce/hive_ce.dart';

class ChangeLangWidget extends StatelessWidget {
  final bool showExitButton;

  const ChangeLangWidget({super.key, this.showExitButton = true});

  @override
  Widget build(BuildContext context) {
    final screen = LandScapeUtils.getResponsiveScreenSize(context);
    final screenWidth = screen.width;
    final isLandscape = LandScapeUtils.isLandscape(context);
    double flagSize = isLandscape ? screenWidth * 0.03 : screenWidth * 0.07;
    double fontSize = isLandscape ? screenWidth * 0.02 : screenWidth * 0.03;
    return Builder(
      builder: (context) {
        return SizedBox(
          height: flagSize,
          width: flagSize,
          child: PopupMenuButton<String>(
            color: Colors.white,
            offset: Offset(0, screen.height * 0.040),
            borderRadius: BorderRadius.circular(12),
            constraints: BoxConstraints(
              maxHeight:
                  isLandscape ? screen.width * 0.15 : screen.height * 0.35,
              maxWidth: isLandscape ? screen.width * 0.25 : screen.width * 0.35,
            ),
            icon: Image.asset(
              "assets/picture/usa_flag.png",
              width: flagSize,
              height: flagSize,
            ),
            onSelected: (value) {
              switch (value) {
                case "english":
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Language set to English")),
                  );
                  break;
                case "setting":
                  AppNavigator.goToSetting(context);
                  break;
                case "store management":
                  _showPinDialog(context);
                  break;
                case "exit":
                  // Close the application
                  Navigator.of(context).pop();
                  break;
              }
            },
            itemBuilder: (context) => [
              _buildItem("english", "English", fontSize),
              _buildItem("setting", "Setting", fontSize),
              _buildItem("store management", "Store Management", fontSize),

              if (showExitButton)
                _buildItem("exit", "Exit", fontSize), // เงื่อนไขแสดง Exit
            ],
          ),
        );
      },
    );
  }

  PopupMenuItem<String> _buildItem(String value, String text, double fontSize) {
    return PopupMenuItem(
      value: value,
      child: Text(text,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: fontSize,
          )),
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
          title: const Text("Store Management",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  "Please enter your PIN to access the store management system."),
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

                final rawUsers = HiveService.getAppUsersRaw();
                if (rawUsers.isEmpty && enteredPin == "9999") {
                  isMatch =
                      true; // Fallback รหัสผ่านชั่วคราว (กรณีแอพยังไม่มีข้อมูล)
                  userRole = 'Owner';
                  userName = 'Owner';
                } else {
                  for (var str in rawUsers) {
                    final map = jsonDecode(str);
                    if (map['pin'] == enteredPin && map['isActive'] == true) {
                      isMatch = true;
                      userRole = map['role'] as String? ?? 'Staff';
                      userName = map['name'] as String? ?? 'Staff';
                      break;
                    }
                  }
                }

                if (isMatch) {
                  Navigator.pop(context);
                  AppNavigator.goToStoreManagement(context,
                      role: userRole, name: userName);
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
