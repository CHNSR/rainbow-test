import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                        //appbar
                        AppbarCustomWidget(
                            showBottom: showBottom,
                            onToggle: (bool show, Offset offset) {
                              setState(() {
                                showBottom = show;
                                bottomOffset = offset;
                              });
                            }),

                        SizedBox(
                            height: isLandscape
                                ? screen.width * 0.001
                                : screen.width * 0.15),
                        TextHomepage(note: "Accept only Credit Card "),
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
                        isLandscape ? screen.width * 0.11 : screen.width * 0.30,
                    child: BottomSheetCustom()),
              ],
            ),
          ),
        ],
      ),
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
        SizedBox(width: screenWidth * 0.025),
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
    final cardWidth = isLandscape ? screenWidth * 0.12 : screenWidth * 0.4;
    final cardHeight = isLandscape ? screenWidth * 0.14 : screenWidth * 0.47;
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
              padding: EdgeInsets.symmetric(vertical: cardHeight * 0.065),
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(8),
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
