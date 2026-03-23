import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showBottom = false;
  Offset bottomOffset = const Offset(0, 1);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: isLandscape
                ? _landscapeMainContant(size, isLandscape)
                : _portraitMainContant(size, isLandscape),
          ),
          if (showBottom)
            AnimatedSlide(
              offset: bottomOffset,
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                    height: isLandscape ? size.width * 0.11 : size.width * 0.33,
                    child: BottomSheetCustom()),
              ),
            ),
        ],
      ),
    );
  }

  Widget _landscapeMainContant(Size screen, bool isLand) {
    return Stack(
      children: [
        Row(
          children: [
            /// LEFT UI
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Positioned.fill(
                    left: screen.width * -0.05,
                    bottom: screen.width * -0.05,
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
                      _textHomePage(screen.width, screen.height),

                      SizedBox(height: screen.width / 25),
                      // button
                      _tapToOrderButton(screen.width, screen.height),
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
                          height: screen.height * 0.03,
                          width: screen.width * 0.03,
                        ),
                        SizedBox(width: screen.width * 0.001),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Soi Siam",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screen.width * 0.02,
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
        ),
        AppbarCustomWidget(
            showExitButton: false,
            showBottom: showBottom,
            onToggle: (bool show, Offset offset) {
              setState(() {
                showBottom = show;
                bottomOffset = offset;
              });
            })
      ],
    );
  }

  Widget _portraitMainContant(Size screen, bool isLanding) {
    return Stack(
      children: [
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
              //_appBarWidget(screen, isLanding),
              AppbarCustomWidget(
                showBottom: showBottom,
                showExitButton: false,
                onToggle: (show, offset) {
                  setState(() {
                    showBottom = show;
                    bottomOffset = offset;
                  });
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.width / 20),
              //Text title
              TextHomepage(),
              //_textHomePage(screenWidth, screenHeight),
              SizedBox(height: MediaQuery.of(context).size.width / 20),

              _tapToOrderButton(
                screen.width,
                screen.height,
              ),

              Expanded(
                flex: 50,
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
                              width: screen.width * 0.02,
                              height: screen.height * 0.04),
                          Text(
                            "Soi Siam",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                            ),
                          ),
                          Text(
                            "Restaurant",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                            ),
                          ),
                        ],
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

  //Tap to order button
  Widget _tapToOrderButton(double screenWidth, double screenHeight) {
    bool isLandscape = screenWidth > screenHeight;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: isLandscape ? screenWidth * 0.035 : screenWidth * 0.095,
          vertical: isLandscape ? screenWidth * 0.02 : screenWidth * 0.055,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: const Color(0xFF496EE2),
      ),
      onPressed: () {
        AppNavigator.goToSelectOrderType(context);
      },
      child: Text(
        "Tap to Order",
        style: GoogleFonts.roboto(
          color: Colors.white,
          fontSize: isLandscape ? screenWidth * 0.015 : screenWidth * 0.035,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _textHomePage(double screenWidth, double screenHeight) {
    bool isLandscape = screenWidth > screenHeight;
    final titleSize = isLandscape ? screenWidth / 15 : screenWidth / 9;
    final subTitleSize = isLandscape ? screenWidth / 60 : screenWidth * 0.025;
    final iconSize = isLandscape ? screenWidth / 80 : screenWidth / 25;
    final noteSize = isLandscape ? screenWidth / 80 : screenWidth / 40;

    return Column(
      children: [
        Text(
          "Self-Service\nExperience.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: titleSize,
            fontFamily: 'Rasa',
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: isLandscape ? 5 : 10),
        Text(
          "From self-order and self-checkout",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: subTitleSize,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: isLandscape ? screenWidth * 0.01 : screenWidth * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Icon(
                  Icons.credit_card_sharp,
                  color: Colors.red,
                  size: iconSize,
                ),
              ),
            ),
            SizedBox(
                width: isLandscape ? screenWidth * 0.01 : screenWidth * 0.02),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "Accept only Credit Card",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: noteSize,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.red,
                    decorationThickness: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
