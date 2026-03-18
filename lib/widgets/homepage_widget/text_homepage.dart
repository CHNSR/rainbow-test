import 'package:flutter/material.dart';

class TextHomepage extends StatelessWidget {
  const TextHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // 🔥 แยก scale ตาม orientation
    final titleSize = isLandscape ? size.width / 15 : size.width / 10;
    final subTitleSize = isLandscape ? size.width / 60 : size.width * 0.025;
    final iconSize = isLandscape ? size.width / 80 : size.width / 25;
    final noteSize = isLandscape ? size.width / 80 : size.width / 40;

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
        SizedBox(height: isLandscape ? 5 : 16),
        Text(
          "From self-order and self-checkout",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: subTitleSize,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
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
            SizedBox(width: isLandscape ? 5 : 10),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "Accept only Credit Card",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: noteSize,
                    fontWeight: FontWeight.w600,
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
