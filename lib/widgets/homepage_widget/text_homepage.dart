import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/landscape.dart';

class TextHomepage extends StatelessWidget {
  final String note;

  const TextHomepage({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final double screenWidth =
        LandScapeUtils.getResponsiveScreenSize(context).width;
    final isLandscape = LandScapeUtils.isLandscape(context);

    final titleSize = isLandscape ? screenWidth / 30 : screenWidth / 9;
    final subTitleSize = isLandscape ? screenWidth / 120 : screenWidth * 0.028;
    final iconSize = isLandscape ? screenWidth / 110 : screenWidth / 25;
    final noteSize = isLandscape ? screenWidth / 110 : screenWidth / 40;

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
            fontWeight: FontWeight.w700,
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
                  note,
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
