import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CartSection extends StatefulWidget {
  final List<CartItem> cartItems;
  const CartSection({super.key, required this.cartItems});

  @override
  State<CartSection> createState() => _CartSectionState();
}

class _CartSectionState extends State<CartSection> {
  void confirmOrder() {
    final orderItems = widget.cartItems.map((item) {
      return {"foodId": item.food.foodId, "quantity": item.quantity};
    }).toList();
    if (widget.cartItems.isNotEmpty) {
      context.read<OrderBloc>().add(ConfirmOrderEvent(orderItems));

      setState(() {
        widget.cartItems.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Order confirmed!"),
          duration: Duration(milliseconds: 1500),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  double get cartTotal {
    return widget.cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(top: screenWidth * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              const SizedBox(width: 8),
              Image.asset('assets/logo/Vector.png', width: 10, height: 10),
            ],
          ),

          Divider(),

          // Cart Items List
          Expanded(
            child: widget.cartItems.isEmpty
                ? const Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        "No order selected",
                        maxLines: 1,
                        minFontSize: 8,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = widget.cartItems[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.015,
                          vertical: screenWidth * 0.005,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200, // สีเทาอ่อน
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cartItem.food.foodName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      AutoSizeText(
                                        maxLines: 1,
                                        minFontSize: 8,
                                        "\$${cartItem.food.foodPrice.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.08,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (cartItem.quantity > 1) {
                                              cartItem.quantity--;
                                            } else {
                                              widget.cartItems.removeAt(index);
                                            }
                                          });
                                        },
                                        child: const Text(
                                          "-",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${cartItem.quantity}",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            cartItem.quantity++;
                                          });
                                        },
                                        child: const Text(
                                          "+",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          const Divider(),

          Padding(
            padding: EdgeInsets.all(screenWidth * 0.001),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText(
                      "Subtotal",
                      maxLines: 1,
                      minFontSize: 10,
                      maxFontSize: 18,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.workSans(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    AutoSizeText(
                      "\$${cartTotal.toStringAsFixed(2)}",
                      maxLines: 1,
                      minFontSize: 10,
                      maxFontSize: 18,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.workSans(
                        color: cartTotal == 0
                            ? Color(0xFF4F4F4F)
                            : Color(0xFF7B61FF),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                    right: 4.0,
                    left: 4.0,
                  ),
                  child: ElevatedButton(
                    onPressed: confirmOrder,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 56),
                      backgroundColor: widget.cartItems.isEmpty
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
                          AutoSizeText(
                            "Confirm Order (${widget.cartItems.fold(0, (sum, item) => sum + item.quantity)})",
                            maxLines: 1,
                            minFontSize: 16,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.09,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
