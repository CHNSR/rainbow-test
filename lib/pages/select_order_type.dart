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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Builder(
          builder: (context) {
            double screenWidth = MediaQuery.of(context).size.width;

            double iconSize = screenWidth < 500 ? 20 : 26;
            double fontSize = screenWidth < 500 ? 14 : 18;
            return Row(
              mainAxisSize: MainAxisSize.min,

              children: [
                Icon(Icons.restaurant, size: iconSize),
                const SizedBox(width: 8),
                Text("Soi Siam", style: TextStyle(fontSize: fontSize)),
              ],
            );
          },
        ),

        actions: [ChangeLangWidget()],
      ),
      body: Stack(
        children: [
          Positioned(
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

                  Text(
                    "Self-Service\nExperience.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 16),

                  Text(
                    "From self-order and self-checkout",
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 8),

                  const CreditCardInfoCard(),

                  SizedBox(height: 24),

                  SelectCatagory(),
                ],
              ),
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: BottomSheetCustom()),
        ],
      ),
    );
  }
}
