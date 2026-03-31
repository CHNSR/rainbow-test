import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CartSection extends StatefulWidget {
  const CartSection({super.key});

  @override
  State<CartSection> createState() => _CartSectionState();
}

class _CartSectionState extends State<CartSection> {
  @override
  Widget build(BuildContext context) {
    final Size screen = LandScapeUtils.getResponsiveScreenSize(context);
    bool isLandscape = LandScapeUtils.isLandscape(context);
    final double screenWidth = screen.width;

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
            Align(alignment: Alignment.topRight, child: ChangeLangWidget()),

            Row(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "My Order",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: screenWidth * 0.02,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4F4F4F),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.005),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Image.asset(
                    'assets/logo/vector.png',
                    width:
                        isLandscape ? screenWidth * 0.015 : screenWidth * 0.02,
                    height:
                        isLandscape ? screenWidth * 0.015 : screenWidth * 0.02,
                  ),
                ),
              ],
            ),

            Divider(),
            // Cart Items List
            Expanded(child: _cardItem(screen, isLandscape)),
            const Divider(),
            //sub total
            _subTotalSession(screenWidth, isLandscape),
          ],
        ),
      ),
    );
  }

  Widget _cardItem(Size screenSize, bool isLandscape) {
    final screenWidth = screenSize.width;
    return BlocBuilder<OrderfullBloc, OrderfullState>(
      builder: (context, state) {
        final cartItems = state.cartItems;
        Widget content = cartItems.isEmpty
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
                        color: Colors.grey,
                        fontSize: isLandscape
                            ? screenWidth * 0.015
                            : screenSize.width * 0.02),
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
                      horizontal: screenSize.width * 0.0001,
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
                                          decorationThickness: 1,
                                          color: Color(0xFF4F4F4F),
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
                                                  context
                                                      .read<OrderfullBloc>()
                                                      .add(
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
                                                  color: Color(0xFF4F4F4F),
                                                ),
                                              ),

                                              SizedBox(
                                                  width: screenWidth * 0.01),

                                              /// plus
                                              GestureDetector(
                                                onTap: () {
                                                  context
                                                      .read<OrderfullBloc>()
                                                      .add(
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

        if (state is OrderfullLoading) {
          return Stack(
            children: [
              content,
              Positioned.fill(
                child: Container(
                  color: Colors.white.withValues(alpha: 0.6),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
          );
        }

        if (state is OrderfullFailure) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        return content;
      },
    );
  }

  Widget _subTotalSession(double screenWidth, bool isLandscape) {
    return BlocBuilder<OrderfullBloc, OrderfullState>(
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
                        fontSize: isLandscape
                            ? screenWidth * 0.011
                            : screenWidth * 0.025,
                        color: Color(0xFF4F4F4F),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "\$${OrderFullPageCore().cartTotal(cartItems)}",
                      maxLines: 1,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.workSans(
                        fontSize: isLandscape
                            ? screenWidth * 0.011
                            : screenWidth * 0.025,
                        color: OrderFullPageCore().cartTotal(cartItems) == 0
                            ? Color(0xFF4F4F4F)
                            : Color(0xFF7B61FF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenWidth * 0.005),
              LayoutBuilder(builder: (context, constraints) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: Responsive.spacing(constraints) * 2,
                    top: Responsive.spacing(constraints),
                  ),
                  child: ElevatedButton(
                    onPressed: (cartItems.isEmpty ||
                            state is OrderfullLoading ||
                            state is OrderfullFailure)
                        ? null
                        : () => OrderFullPageCore().confirmOrder(context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 35),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      backgroundColor: (cartItems.isEmpty ||
                              state is OrderfullLoading ||
                              state is OrderfullFailure)
                          ? Colors.grey.shade500
                          : Color(0xFF32CD32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.006),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: isLandscape
                                  ? screenWidth * 0.06
                                  : screenWidth * 0.065,
                              color: Colors.white,
                            ),
                            SizedBox(width: screenWidth * 0.015),
                            Text(
                              "Confirm Order (${cartItems.fold(0, (sum, item) => sum + item.quantity)})",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: ResponsiveFont.title(screenWidth),
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
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
