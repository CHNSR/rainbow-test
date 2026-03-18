import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/export.dart';

class CardItem extends StatelessWidget {
  const CardItem({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final cartItems = state.cartItems;
        return cartItems.isEmpty
            ?
            // No order selected
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "No order selected",
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.grey, fontSize: screenWidth * 0.02),
                  ),
                ),
              )
            //Order add to cart
            : ListView.separated(
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
                    child: Column(
                      children: [
                        Container(
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
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: ResponsiveFont.subtitle(
                                              screenWidth),
                                          decoration: TextDecoration.underline,
                                          decorationColor: Color(0xFF4F4F4F),
                                          decorationThickness: 2,
                                        ),
                                      ),

                                      /// desc
                                      Text(
                                        cartItem.food.foodDesc ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: ResponsiveFont.textsmall(
                                              screenWidth),
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      SizedBox(
                                        height: screenWidth * 0.02,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          /// price
                                          Text(
                                            "\$${cartItem.food.foodPrice.toStringAsFixed(2)}",
                                            style: TextStyle(
                                              color: Color(0xFF7B61FF),
                                              fontSize: ResponsiveFont.subtitle(
                                                  screenWidth),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          /// quantity buttons
                                          Row(
                                            children: [
                                              /// minus
                                              GestureDetector(
                                                onTap: () {
                                                  context.read<CartBloc>().add(
                                                        RemoveFromCartEvent(
                                                            cartItem.food),
                                                      );
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(
                                                      screenWidth * 0.0004),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade300,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.remove,
                                                    size:
                                                        ResponsiveFont.subtitle(
                                                            screenWidth),
                                                  ),
                                                ),
                                              ),

                                              SizedBox(
                                                  width: screenWidth * 0.01),

                                              Text(
                                                cartItem.quantity
                                                    .toString()
                                                    .padLeft(2, "0"),
                                                style: TextStyle(
                                                  fontSize:
                                                      ResponsiveFont.subtitle(
                                                          screenWidth),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),

                                              SizedBox(
                                                  width: screenWidth * 0.01),

                                              /// plus
                                              GestureDetector(
                                                onTap: () {
                                                  context.read<CartBloc>().add(
                                                        AddToCartEvent(
                                                            cartItem.food),
                                                      );
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(
                                                      screenWidth * 0.0004),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade300,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.add,
                                                    size:
                                                        ResponsiveFont.subtitle(
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
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                  height: screenWidth * 0.01,
                  color: Colors.grey.shade300,
                  thickness: 1,
                ),
              );
      },
    );
  }
}
