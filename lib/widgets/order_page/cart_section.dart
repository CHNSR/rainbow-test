import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CartSection extends StatefulWidget {
  //final List<CartItem> cartItems;
  const CartSection({super.key}); // required this.cartItems});

  @override
  State<CartSection> createState() => _CartSectionState();
}

class _CartSectionState extends State<CartSection> {
  void confirmOrder() {
    final cartItems = context.read<CartBloc>().state.cartItems;

    final orderItems = cartItems.map((item) {
      return {
        "foodId": item.food.foodId,
        "quantity": item.quantity,
      };
    }).toList();

    if (cartItems.isNotEmpty) {
      /// send order
      context.read<OrderBloc>().add(
            ConfirmOrderEvent(orderItems),
          );

      /// clear cart
      context.read<CartBloc>().add(
            ClearCartEvent(),
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Order confirmed!"),
          duration: Duration(milliseconds: 1500),
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
        return Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.5),
              blurRadius: 1,
              spreadRadius: 1,
              offset: const Offset(-2, 0),
            )
          ]),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
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
                      SizedBox(width: screenWidth * 0.02),
                      Image.asset('assets/logo/Vector.png',
                          width: screenWidth * 0.02,
                          height: screenWidth * 0.02),
                    ],
                  ),
                ),

                Divider(),

                // Cart Items List
                Expanded(
                    child: cartItems.isEmpty
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
                        : BlocBuilder<CartBloc, CartState>(
                            builder: (context, state) {
                              final cartItems = state.cartItems;

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: cartItems.length,
                                itemBuilder: (context, index) {
                                  final cartItem = cartItems[index];

                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.0001,
                                      vertical: screenWidth * 0.002,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  /// name
                                                  Text(
                                                    'X${cartItem.quantity} ${cartItem.food.foodName}',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: ResponsiveFont
                                                          .subtitle(
                                                              screenWidth),
                                                    ),
                                                  ),

                                                  /// desc
                                                  Text(
                                                    cartItem.food.foodDesc ??
                                                        '',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: ResponsiveFont
                                                          .textsmall(
                                                              screenWidth),
                                                      color:
                                                          Colors.grey.shade600,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: screenWidth * 0.02,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      /// price
                                                      Text(
                                                        "\$${cartItem.food.foodPrice.toStringAsFixed(2)}",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF7B61FF),
                                                          fontSize: ResponsiveFont
                                                              .subtitle(
                                                                  screenWidth),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),

                                                      /// quantity buttons
                                                      Row(
                                                        children: [
                                                          /// minus
                                                          GestureDetector(
                                                            onTap: () {
                                                              context
                                                                  .read<
                                                                      CartBloc>()
                                                                  .add(
                                                                    RemoveFromCartEvent(
                                                                        cartItem
                                                                            .food),
                                                                  );
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .all(screenWidth *
                                                                      0.0004),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: Icon(
                                                                Icons.remove,
                                                                size: ResponsiveFont
                                                                    .subtitle(
                                                                        screenWidth),
                                                              ),
                                                            ),
                                                          ),

                                                          SizedBox(
                                                              width:
                                                                  screenWidth *
                                                                      0.01),

                                                          Text(
                                                            cartItem.quantity
                                                                .toString()
                                                                .padLeft(
                                                                    2, "0"),
                                                            style: TextStyle(
                                                              fontSize:
                                                                  ResponsiveFont
                                                                      .subtitle(
                                                                          screenWidth),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),

                                                          SizedBox(
                                                              width:
                                                                  screenWidth *
                                                                      0.01),

                                                          /// plus
                                                          GestureDetector(
                                                            onTap: () {
                                                              context
                                                                  .read<
                                                                      CartBloc>()
                                                                  .add(
                                                                    AddToCartEvent(
                                                                        cartItem
                                                                            .food),
                                                                  );
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .all(screenWidth *
                                                                      0.0004),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: Icon(
                                                                Icons.add,
                                                                size: ResponsiveFont
                                                                    .subtitle(
                                                                        screenWidth),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
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
                              );
                            },
                          )),

                const Divider(),

                Padding(
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
                                fontSize: ResponsiveFont.subtitle(screenWidth),
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "\$${cartTotal(cartItems).toStringAsFixed(2)}",
                              maxLines: 1,
                              textAlign: TextAlign.right,
                              style: GoogleFonts.workSans(
                                fontSize: ResponsiveFont.subtitle(screenWidth),
                                color: cartTotal(cartItems) == 0
                                    ? Color(0xFF4F4F4F)
                                    : Color(0xFF7B61FF),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      LayoutBuilder(builder: (context, constraints) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: Responsive.spacing(constraints) * 2,
                            top: Responsive.spacing(constraints),
                          ),
                          child: ElevatedButton(
                            onPressed: confirmOrder,
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 40),
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
                                      fontSize:
                                          ResponsiveFont.title(screenWidth),
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
