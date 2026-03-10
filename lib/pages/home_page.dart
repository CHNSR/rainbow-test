import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_application_1/utils/responsive.dart';
import 'package:flutter_application_1/widgets/bottom_sheet2.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _openIconButtonPress() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        child: BottomSheet2(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: GestureDetector(
          onTap: _openIconButtonPress,
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
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: 0,
            right: 0,
            bottom: -40,
            child: Image.asset(
              "assets/picture/togo_walk_in.gif",
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    MediaQuery(
                      data: MediaQuery.of(context),
                      child: Builder(
                        builder: (context) {
                          return Text(
                            "Self-Service\nExperience.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 20,
                              //fontSize: 60,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 16),

                    Text(
                      "From self-order and self-checkout",
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 8),

                    // ✅ ใช้ responsive helper class
                    const CreditCardInfoCard(),

                    SizedBox(height: 24),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        backgroundColor: Colors.blueAccent,
                      ),
                      onPressed: () {
                        AppNavigator.goToSelectOrderType(context);
                      },
                      child: const Text(
                        "Tap to Order",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
