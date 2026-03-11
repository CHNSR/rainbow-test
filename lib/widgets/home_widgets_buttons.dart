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
          child: Column(
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
        ),

        /// RIGHT IMAGE
        Expanded(
          flex: 5,
          child: Image.asset(
            "assets/picture/togo_walk_in.gif",
            fit: BoxFit.cover,
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
    return Column(
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

        Text("From self-order and self-checkout", textAlign: TextAlign.center),

        SizedBox(height: 8),

        // ✅ ใช้ responsive helper class
        const CreditCardInfoCard(),

        SizedBox(height: 24),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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

        SizedBox(height: 30),

        Expanded(
          child: Image.asset(
            "assets/picture/togo_walk_in.gif",
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
            width: double.infinity,
          ),
        ),
      ],
    );
  }
}
