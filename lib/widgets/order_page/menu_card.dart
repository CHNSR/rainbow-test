import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';

class MenuCard extends StatelessWidget {
  final FoodMenu food;
  final VoidCallback? onAddToCart;
  const MenuCard({super.key, required this.food, this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAddToCart,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 1,
              offset: const Offset(0, 1),
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
                Expanded(
                  flex: 55,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(3),
                      topRight: Radius.circular(3),
                    ),
                    child: Image.network(
                      food.imageName ?? "assets/logo/error_loading.png",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
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
                Expanded(
                  flex: 45,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            food.foodName ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: titleSize,
                            ),
                          ),

                          //Text of drescription
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

                          Spacer(),
                          //Text of price
                          Text(
                            "\$${food.foodPrice}",
                            maxLines: 1,
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
    );
  }
}
