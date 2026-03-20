import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:google_fonts/google_fonts.dart';

class AppbarCustomWidget extends StatelessWidget {
  final bool showBottom;
  final Function(bool, Offset) onToggle;

  const AppbarCustomWidget({
    Key? key,
    required this.showBottom,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;
    final isLandscape = screen.width > screen.height;
    final fontSized = isLandscape ? screen.width * 0.012 : screen.width * 0.03;
    final logoHeight = isLandscape ? screen.width * 0.012 : screen.width * 0.03;
    final logoWidth = isLandscape ? screen.width * 0.012 : screen.width * 0.03;
    final spacing = isLandscape ? screen.width * 0.005 : screen.width * 0.01;

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
        PopupMenuButton<String>(
          offset: Offset(0, screen.height * 0.040),
          borderRadius: BorderRadius.circular(12),
          constraints: BoxConstraints(
            maxHeight: isLandscape ? screen.width * 0.15 : screen.height * 0.35,
            maxWidth: isLandscape ? screen.width * 0.25 : screen.width * 0.35,
          ),
          icon: Image.asset(
            "assets/picture/usa_flag.png",
            width: logoWidth,
            height: logoHeight,
          ),
          onSelected: (value) {
            switch (value) {
              case "english":
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
          itemBuilder: (context) => [
            PopupMenuItem(
              value: "english",
              child: Text("English",
                  style: TextStyle(fontSize: screen.width * 0.02)),
            ),
            PopupMenuItem(
              value: "setting",
              child: Text("Setting",
                  style: TextStyle(fontSize: screen.width * 0.02)),
            ),
            PopupMenuItem(
              value: "store management",
              child: Text("Store Management",
                  style: TextStyle(fontSize: screen.width * 0.02)),
            ),
            PopupMenuItem(
              value: 'exit',
              child:
                  Text("Exit", style: TextStyle(fontSize: screen.width * 0.02)),
            ),
          ],
        ),
      ]),
    );
  }
}
