import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_application_1/widgets/bottom_sheet2.dart';

class SelectOrderType extends StatefulWidget {
  const SelectOrderType({super.key});

  @override
  State<SelectOrderType> createState() => _SelectOrderTypeState();
}

class _SelectOrderTypeState extends State<SelectOrderType> {
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
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            const Icon(Icons.restaurant),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _openIconButtonPress,
              child: const Text("Soi Siam", style: TextStyle(fontSize: 14)),
            ),
          ],
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/picture/select_order_type.png",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20),

                  Text(
                    "Self-Service\nExperience.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 16),

                  Text(
                    "From self-order and self-checkout",
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.credit_card, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        "Accept only Credit Card",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  SelectCatagory(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: BottomSheet2(),
    );
  }
}
