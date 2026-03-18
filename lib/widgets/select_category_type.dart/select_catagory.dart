import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectCatagory extends StatefulWidget {
  const SelectCatagory({super.key});

  @override
  State<SelectCatagory> createState() => _SelectCatagoryState();
}

class _SelectCatagoryState extends State<SelectCatagory> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //button
        CategoryButton(
          title: 'To Stay',
          imagePath: 'assets/picture/ani_to_stay.gif',
          buttonColor: Colors.blue,
          onTap: () {
            context.read<OrderBloc>().add(SetOrderType("stay"));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderPages()),
            );
          },
        ),
        SizedBox(width: 10),
        CategoryButton(
          title: 'Togo Walk-in',
          imagePath: 'assets/picture/togo_walk_in.gif',
          buttonColor: Colors.orangeAccent,
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
}

class CategoryButton extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback onTap;
  final Color buttonColor;

  const CategoryButton({
    super.key,
    required this.imagePath,
    required this.title,
    required this.onTap,
    required this.buttonColor,
  });

  // @override
  // Widget build(BuildContext context) {
  //   final screenWidth = MediaQuery.of(context).size.width;
  //   final size = MediaQuery.of(context).size;
  //   final isLandscape = size.width > size.height;
  //   final cardWidth = isLandscape
  //       ? (size.height * 0.25).clamp(100.0, 220.0) // 🔥 ใช้ height แทน
  //       : (size.width * 0.35).clamp(120.0, 260.0);
  //   final cardHeight = cardWidth * (180 / 150);

  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       width: cardWidth,
  //       height: cardHeight,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(5),
  //         color: Colors.white,
  //         boxShadow: [
  //           BoxShadow(
  //             blurRadius: 8,
  //             color: Colors.black.withOpacity(0.1),
  //             offset: const Offset(0, 4),
  //           ),
  //         ],
  //       ),
  //       child: Column(
  //         children: [
  //           Expanded(
  //             child: ClipRRect(
  //               borderRadius: const BorderRadius.vertical(
  //                 top: Radius.circular(5),
  //               ),
  //               child: Image.asset(
  //                 imagePath,
  //                 fit: BoxFit.cover,
  //                 width: double.infinity,
  //               ),
  //             ),
  //           ),
  //           Container(
  //             width: double.infinity,
  //             padding: EdgeInsets.symmetric(vertical: cardHeight * 0.08),
  //             decoration: BoxDecoration(
  //               color: buttonColor,
  //               borderRadius: const BorderRadius.vertical(
  //                 bottom: Radius.circular(5),
  //               ),
  //             ),
  //             child: Center(
  //               child: Text(
  //                 title,
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: cardWidth * 0.1,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final base = min(size.width, size.height);

    final cardWidth = base * 0.3; // 🔥 ปรับตรงนี้
    final cardHeight = cardWidth * 1.0;

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
                    fontSize: cardWidth * 0.1,
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
