import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';

class PopupWidget extends StatelessWidget {
  const PopupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Image.asset("assets/picture/usa_flag.png", width: 24, height: 24),
      onSelected: (value) {
        switch (value) {
          case "english":
            // TODO: implement language selection
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
  }
}
