import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/cart_item.dart';

class CartSection extends StatefulWidget {
  final List<CartItem> cartItems;
  final double cartTotal;
  const CartSection({
    super.key,
    required this.cartItems,
    required this.cartTotal,
  });

  @override
  State<CartSection> createState() => _CartSectionState();
}

class _CartSectionState extends State<CartSection> {
  void confirmOrder() {
    if (widget.cartItems.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Order confirmed!"),
          duration: Duration(milliseconds: 1500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(top: screenWidth * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            child: AutoSizeText(
              "My Order",
              maxLines: 1,
              style: TextStyle(
                fontSize: screenWidth * 0.02,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Divider(),

          // Cart Items List
          Expanded(
            child: widget.cartItems.isEmpty
                ? const Center(
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
            padding: EdgeInsets.all(screenWidth * 0.01),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        "Subtotal",
                        maxLines: 1,
                        minFontSize: 8,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      child: AutoSizeText(
                        "\$${widget.cartTotal.toStringAsFixed(2)}",
                        maxLines: 1,
                        minFontSize: 8,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Colors.purple,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: confirmOrder,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, screenWidth * 0.10),
                    backgroundColor: widget.cartItems.isEmpty
                        ? Colors.grey.shade500
                        : Colors.lightGreen,
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
                          size: screenWidth * 0.1,
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
                            fontSize: screenWidth * 0.1,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
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
