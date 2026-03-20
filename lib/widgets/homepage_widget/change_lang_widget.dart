import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';

class ChangeLangWidget extends StatefulWidget {
  const ChangeLangWidget({super.key});

  @override
  State<ChangeLangWidget> createState() => _ChangeLangWidgetState();
}

class _ChangeLangWidgetState extends State<ChangeLangWidget> {
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final screenWidth = screen.width;
    final isLandscape = screen.width > screen.height;
    double flagSize = isLandscape ? screenWidth * 0.03 : screenWidth * 0.06;
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
                  AppNavigator.goToStoreManagement(context);
                  break;
                case "exit":
                  // Close the application
                  Navigator.of(context).pop();
                  break;
              }
            },
            itemBuilder: (context) => [
              _buildItem("english", "English", screen),
              _buildItem("setting", "Setting", screen),
              _buildItem("store management", "Store Management", screen),
              _buildItem("exit", "Exit", screen),
            ],
          ),
        );
      },
    );
  }

  PopupMenuItem<String> _buildItem(String value, String text, Size screen) {
    return PopupMenuItem(
      value: value,
      child: Text(text,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: screen.width * 0.008,
          )),
    );
  }
}
