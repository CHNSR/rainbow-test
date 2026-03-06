import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/select_order_type.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.restaurant),
            const SizedBox(width: 8),
            const Text("Soi Siam", style: TextStyle(fontSize: 14)),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (value) {},
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: "english",
                child: Text("English", style: TextStyle(fontSize: 12)),
              ),
              PopupMenuItem(
                value: "seting",
                child: Text("Setting", style: TextStyle(fontSize: 12)),
              ),
              PopupMenuItem(
                value: "store management",
                child: Text("Store Managament", style: TextStyle(fontSize: 12)),
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
            child: Image.asset(
              "assets/picture/home_background1.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: 0,
            right: 0,
            bottom: -35,
            child: Image.asset(
              "assets/picture/togo_walk_in.gif",
              fit: BoxFit.contain,
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
                          print(
                            "${MediaQuery.of(context).size.width} x ${MediaQuery.of(context).size.height}",
                          );
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

                    Container(
                      color: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Icon(
                                Icons.credit_card,
                                color: Colors.red,
                                size: 50,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: const Text(
                                "Accept only Credit Card",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SelectOrderType(),
                          ),
                        );
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
