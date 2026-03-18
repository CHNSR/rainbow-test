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
    return Builder(
      builder: (context) {
        double screenWidth = MediaQuery.of(context).size.width;
        double flagSize = screenWidth < 400 ? 10 : 15;
        return PopupMenuButton<String>(
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          offset: const Offset(0, 40),
          icon: Image.asset(
            "assets/picture/usa_flag.png",
            height: flagSize,
            width: flagSize,
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
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: "english",
              child: Text("English", style: TextStyle(fontSize: 12)),
            ),
            PopupMenuItem(
              value: "setting",
              child: Text("Setting", style: TextStyle(fontSize: 12)),
            ),
            PopupMenuItem(
              value: "store management",
              child: Text("Store Management", style: TextStyle(fontSize: 12)),
            ),
            PopupMenuItem(
              value: 'exit',
              child: Text("Exit", style: TextStyle(fontSize: 12)),
            ),
          ],
        );
      },
    );
  }
}
