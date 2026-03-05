import 'package:flutter/material.dart';
import 'package:flutter_application_1/bloc/bloc/tap_to_order_bloc.dart';
import 'package:flutter_application_1/pages/order_pages.dart';
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 180,
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
            /// 🔹 รูปด้านบน
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

            /// 🔹 แถบด้านล่าง
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(5),
                ),
              ),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
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
