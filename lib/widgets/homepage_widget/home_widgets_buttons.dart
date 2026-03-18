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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
                  //Text title
                  TextHomepage(),

                  SizedBox(height: MediaQuery.of(context).size.width / 25),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      backgroundColor: const Color.fromARGB(255, 54, 118, 255),
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
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/picture/togo_walk_in.gif",
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: const Alignment(-0.05, 0.30),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/logo/chonsom_white.png",
                      height: height * 0.03,
                      width: width * 0.03,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.001),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Soi Siam",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.02,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
    final screenWith = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                    Image.asset("assets/logo/chonsom_white.png",
                        width: screenWith * 0.02, height: screenHeight * 0.04),
                    Text(
                      "Soi Siam",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                      ),
                    ),
                    Text(
                      "Restaurant",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                      ),
                    ),
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
              TextHomepage(),
              SizedBox(height: MediaQuery.of(context).size.width / 25),
              // ElevatedButton(
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.width * 0.10,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        //horizontal: 32,
                        //vertical: 10,
                        ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    backgroundColor: const Color(0xFF496EE2),
                  ),
                  onPressed: () {
                    AppNavigator.goToSelectOrderType(context);
                  },
                  child: Text(
                    "Tap to Order",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.03),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
