import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SubTotalSession extends StatefulWidget {
  const SubTotalSession({super.key});

  @override
  State<SubTotalSession> createState() => _SubTotalSessionState();
}

class _SubTotalSessionState extends State<SubTotalSession> {
  void confirmOrder() {
    final cartItems = context.read<CartBloc>().state.cartItems;

    final orderItems = cartItems.map((item) {
      return {
        "foodId": item.food.foodId,
        "quantity": item.quantity,
      };
    }).toList();

    if (cartItems.isNotEmpty) {
      /// clear cart
      context.read<CartBloc>().add(
            ClearCartEvent(),
          );

      /// send order ใหม่
      context.read<OrderBloc>().add(
            ConfirmOrderEvent(orderItems),
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Order confirmed!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  double cartTotal(List<CartItem> cartItems) {
    return cartItems.fold(
      0,
      (sum, item) => sum + item.totalPrice,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final cartItems = state.cartItems;
        return Padding(
          padding: EdgeInsets.all(screenWidth * 0.001),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Subtotal",
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.workSans(
                        fontSize: ResponsiveFont.titleCategory(screenWidth),
                        color: Color(0xFF4F4F4F),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "\$${cartTotal(cartItems).toStringAsFixed(2)}",
                      maxLines: 1,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.workSans(
                        fontSize: ResponsiveFont.titleCategory(screenWidth),
                        color: cartTotal(cartItems) == 0
                            ? Color(0xFF4F4F4F)
                            : Color(0xFF7B61FF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenWidth * 0.01),
              LayoutBuilder(builder: (context, constraints) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: Responsive.spacing(constraints) * 2,
                    top: Responsive.spacing(constraints),
                  ),
                  child: ElevatedButton(
                    onPressed: confirmOrder,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 35),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      backgroundColor: cartItems.isEmpty
                          ? Colors.grey.shade500
                          : Color(0xFF32CD32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: [
                          Icon(
                            Icons.shopping_cart,
                            size: screenWidth * 0.09,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Confirm Order (${cartItems.fold(0, (sum, item) => sum + item.quantity)})",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: ResponsiveFont.title(screenWidth),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
