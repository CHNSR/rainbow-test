import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:google_fonts/google_fonts.dart';

class AppbarCustomWidget extends StatelessWidget {
  final bool showBottom;
  final Function(bool, Offset) onToggle;
  final bool showExitButton;

  const AppbarCustomWidget({
    super.key,
    required this.showBottom,
    required this.onToggle,
    this.showExitButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;
    final isLandscape = screen.width > screen.height;
    final fontSized = isLandscape ? screen.width * 0.012 : screen.width * 0.03;
    final logoHeight = isLandscape ? screen.width * 0.012 : screen.width * 0.03;
    final logoWidth = isLandscape ? screen.width * 0.012 : screen.width * 0.03;
    final spacing = isLandscape ? screen.width * 0.005 : screen.width * 0.01;
    print("showExitButton: $showExitButton");
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.all(
          isLandscape ? screen.width * 0.01 : screen.width * 0.02),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        InkWell(
          onTap: () {
            HomePageCore.toggleBottomSheet(
                showBottom: showBottom, setStateCallback: onToggle);
          },
          child: Row(
            children: [
              Image.asset("assets/logo/chonsom.png",
                  width: logoWidth, height: logoHeight),
              SizedBox(width: spacing),
              Text("Soi Siam",
                  style: GoogleFonts.roboto(
                      fontSize: fontSized,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF8D8D8D))),
            ],
          ),
        ),
        ChangeLangWidget(
          showExitButton: showExitButton,
        )
      ]),
    );
  }
}
