import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';

class HomeWidgetsButtons extends StatefulWidget {
  final String pathpic;
  final String title;
  const HomeWidgetsButtons({
    super.key,
    required this.pathpic,
    required this.title,
  });

  @override
  State<HomeWidgetsButtons> createState() => _ToStayButtonsState();
}

class _ToStayButtonsState extends State<HomeWidgetsButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(border: Border.symmetric()),
      child: Column(),
    );
  }
}

//Tab to order button
class TabtoOrderButton extends StatefulWidget {
  const TabtoOrderButton({super.key});

  @override
  State<TabtoOrderButton> createState() => _TabtoOrderButtonState();
}

class _TabtoOrderButtonState extends State<TabtoOrderButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () {}, child: Text('Tap to Order'));
  }
}

class LandscapeMainContant extends StatelessWidget {
  const LandscapeMainContant({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// LEFT UI
        Expanded(
          flex: 5,
          child: Stack(
            children: [
              Positioned.fill(
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.diagonal3Values(-1, -1, 1),
                  child: Image.asset(
                    "assets/picture/home_background1.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Self-Service\nExperience.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "From self-order and self-checkout",
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  const CreditCardInfoCard(),

                  const SizedBox(height: 24),

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
            ],
          ),
        ),

        /// RIGHT IMAGE
        Expanded(
          flex: 5,
          child: Align(
            alignment: .bottomCenter,
            child: Image.asset(
              "assets/picture/togo_walk_in.gif",
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
      ],
    );
  }
}

class PortraitMainContant extends StatelessWidget {
  const PortraitMainContant({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          top: MediaQuery.of(context).size.height * 0.5,
          bottom: 0,
          left: 0,
          right: 0,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/picture/togo_walk_in.gif",
                  fit: BoxFit.cover,
                ),
              ),

              Align(
                alignment: const Alignment(-0.05, 0.35),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.restaurant, color: Colors.white),
                    Text("Soi Siam", style: TextStyle(color: Colors.white)),
                    Text("Restaurant", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),

        Positioned.fill(
          top: 0,
          bottom: MediaQuery.of(context).size.height * 0.5,
          left: 0,
          right: 0,
          child: Image.asset(
            "assets/picture/home_background1.png",
            fit: BoxFit.cover,
          ),
        ),
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Self-Service\nExperience.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 20,
                  //fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),

              Text(
                "From self-order and self-checkout",
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 8),

              // ✅ ใช้ responsive helper class
              const CreditCardInfoCard(),

              SizedBox(height: 8),

              // ElevatedButton(
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
      ],
    );
  }
}
