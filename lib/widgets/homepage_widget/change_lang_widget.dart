import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';

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
                  AppNavigator.goToStoreManagement(context);
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
}
