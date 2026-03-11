import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_application_1/widgets/bottom_sheet2.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showBottom = false;

  void _toggleBottomSheet() {
    setState(() {
      showBottom = !showBottom;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: GestureDetector(
          onTap: _toggleBottomSheet,
          child: Row(
            children: [
              const Icon(Icons.restaurant),
              const SizedBox(width: 8),
              const Text("Soi Siam", style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Image.asset(
              "assets/picture/usa_flag.png",
              width: 24,
              height: 24,
            ),
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
          ),
        ],
      ),
      body: Stack(
        children: [
          //back ground
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              "assets/picture/home_background1.png",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: isLandscape
                    ? LandscapeMainContant()
                    : PortraitMainContant(),
              ),
            ),
          ),

          //for bottom sheet
          if (showBottom)
            Align(alignment: Alignment.bottomCenter, child: BottomSheet2()),
        ],
      ),
    );
  }
}
