import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/config/export.dart';

class MenuCard extends StatelessWidget {
  final FoodMenu food;
  final VoidCallback? onAddToCart;

  const MenuCard({
    super.key,
    required this.food,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        /// หา quantity ของเมนูนี้ใน cart
        int quantity = 0;

        final index = state.cartItems.indexWhere(
          (item) => item.food.foodId == food.foodId,
        );

        if (index != -1) {
          quantity = state.cartItems[index].quantity;
        }

        return GestureDetector(
          onTap: onAddToCart,
          child: AspectRatio(
            aspectRatio: 323 / 354,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double titleSize = constraints.maxWidth * 0.08;
                  double descSize = constraints.maxWidth * 0.06;
                  double priceSize = constraints.maxWidth * 0.08;

                  return Column(
                    children: [
                      /// IMAGE
                      Expanded(
                        flex: 55,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(3),
                            topRight: Radius.circular(3),
                          ),
                          child: Image.network(
                            food.imageName ?? "",
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.broken_image,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),

                      /// TEXT SECTION
                      Expanded(
                        flex: 45,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// TITLE + QUANTITY
                                RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: titleSize,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      if (quantity > 0)
                                        TextSpan(
                                          text: 'X$quantity ',
                                          style: const TextStyle(
                                            color: Color(0xFF32CD32),
                                          ),
                                        ),
                                      TextSpan(
                                        text: food.foodName ?? '',
                                      ),
                                    ],
                                  ),
                                ),

                                /// DESCRIPTION
                                if ((food.foodDesc ?? "").isNotEmpty)
                                  Text(
                                    food.foodDesc!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: descSize,
                                      color: Colors.grey,
                                    ),
                                  ),

                                const Spacer(),

                                /// PRICE
                                Text(
                                  "\$${food.foodPrice}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: priceSize,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
