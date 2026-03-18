import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';

class SelectOrderType extends StatefulWidget {
  const SelectOrderType({super.key});

  @override
  State<SelectOrderType> createState() => _SelectOrderTypeState();
}

class _SelectOrderTypeState extends State<SelectOrderType> {
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screen.width > screen.height;

    final appBarHeight = screenHeight < 300.0
        ? screenHeight * 0.05
        : screenHeight < 900.0
            ? screen.height * 0.1
            : screen.height * 0.02;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: appBarHeight,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Builder(
          builder: (context) {
            double screenWidth = MediaQuery.of(context).size.width;
            double iconSize = screenWidth < 300 ? 15 : 20;
            double fontSize = screenWidth < 300 ? 14 : 18;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/logo/chonsom.png",
                  height: iconSize,
                  width: iconSize,
                ),
                const SizedBox(width: 8),
                Text("Soi Siam", style: TextStyle(fontSize: fontSize)),
              ],
            );
          },
        ),
        actions: [ChangeLangWidget()],
      ),
      bottomNavigationBar: isLandscape ? null : BottomSheetCustom(),
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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  // HomePage Text
                  TextHomepage(),
                  SizedBox(height: 24),
                  // HomePage Button
                  SelectCatagory(),
                  Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
