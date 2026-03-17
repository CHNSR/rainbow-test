import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';

class CartSection extends StatefulWidget {
  const CartSection({super.key});

  @override
  State<CartSection> createState() => _CartSectionState();
}

class _CartSectionState extends State<CartSection> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.15),
          blurRadius: 1,
          spreadRadius: -1,
          offset: const Offset(-3, 0),
        )
      ]),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.015),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // lang side
            Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                'assets/picture/usa_flag.png',
                width: screenWidth * 0.02,
                height: screenWidth * 0.02,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenWidth * 0.03),
              child: Row(
                children: [
                  AutoSizeText(
                    "My Order",
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: screenWidth * 0.02,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4F4F4F),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.01),
                  Image.asset('assets/logo/vector.png',
                      width: screenWidth * 0.02, height: screenWidth * 0.02),
                ],
              ),
            ),

            Divider(),

            // Cart Items List
            Expanded(child: CardItem()),

            const Divider(),
            //sub total
            SubTotalSession()
          ],
        ),
      ),
    );
  }
}
