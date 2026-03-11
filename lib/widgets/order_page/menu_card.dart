import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/food_menu.dart';

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
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 55,
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
            Expanded(
              flex: 45,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      food.foodName ?? "",
                      maxLines: 1,
                      minFontSize: 5,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    //Text of drescription
                    //const SizedBox(height: 4),
                    Flexible(
                      child: AutoSizeText(
                        food.foodDesc ?? "",
                        maxLines: 2,
                        minFontSize: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    //const SizedBox(height: 4),
                    AutoSizeText(
                      "\$${food.foodPrice}",
                      maxLines: 1,
                      minFontSize: 10,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
