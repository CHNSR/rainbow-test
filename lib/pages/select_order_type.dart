import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectOrderType extends StatefulWidget {
  const SelectOrderType({super.key});

  @override
  State<SelectOrderType> createState() => _SelectOrderTypeState();
}

class _SelectOrderTypeState extends State<SelectOrderType> {
  bool showBottom = false;
  Offset bottomOffset = const Offset(0, 1);
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    final isLandscape = screen.width > screen.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/picture/select_order_type.png",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _appBarWidget(screen, isLandscape),
                        SizedBox(
                            height: isLandscape
                                ? screen.width * 0.001
                                : screen.width * 0.08),
                        TextHomepage(),
                        SizedBox(
                            height: isLandscape
                                ? screen.width * 0.03
                                : screen.width * 0.075),
                        _selectCatagory(screen.width, screen.height),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                    height:
                        isLandscape ? screen.width * 0.11 : screen.width * 0.33,
                    child: BottomSheetCustom()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBarWidget(Size screen, bool isLandscape) {
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
              showBottom: showBottom,
              setStateCallback: (bool show, Offset offset) {
                setState(() {
                  showBottom = show;
                  bottomOffset = offset;
                });
              },
            );
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

  //select catagory
  Widget _selectCatagory(double screenWidth, double screenHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //button
        _categoryButton(
          title: 'To Stay',
          imagePath: 'assets/picture/ani_to_stay.gif',
          buttonColor: Color(0xFF496EE2),
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          onTap: () {
            context.read<OrderBloc>().add(SetOrderType("stay"));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderPages()),
            );
          },
        ),
        SizedBox(width: 10),
        _categoryButton(
          title: 'Togo Walk-in',
          imagePath: 'assets/picture/togo_walk_in.gif',
          buttonColor: Color(0xFFFAA21C),
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          onTap: () {
            context.read<OrderBloc>().add(SetOrderType("togo"));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderPages()),
            );
          },
        ),

        //button
      ],
    );
  }

  //category button
  Widget _categoryButton({
    required String title,
    required String imagePath,
    required Color buttonColor,
    required VoidCallback onTap,
    required double screenWidth,
    required double screenHeight,
  }) {
    final isLandscape = screenWidth > screenHeight;
    final cardWidth =
        isLandscape ? screenWidth * 0.12 : screenWidth * 0.4; // 🔥 ปรับตรงนี้
    final cardHeight = isLandscape ? screenWidth * 0.14 : screenWidth * 0.5;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(5),
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: cardHeight * 0.08),
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(5),
                ),
              ),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: cardWidth * 0.08,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
