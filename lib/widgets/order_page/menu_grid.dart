import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/food_menu.dart';
import 'package:flutter_application_1/widgets/order_page/menu_card.dart';

class MenuGrid extends StatelessWidget {
  final List<FoodMenu> foods;
  final ScrollController? scrollController;
  final Function(FoodMenu)? onAddToCart;

  const MenuGrid({
    super.key,
    required this.foods,
    this.scrollController,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    final crossAxisCount = orientation == Orientation.landscape ? 4 : 2;

    if (foods.isEmpty) {
      return const Center(child: Text("No food items"));
    }

    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 0.75,
      ),
      itemCount: foods.length,
      itemBuilder: (context, i) {
        final food = foods[i];
        return MenuCard(food: food, onAddToCart: () => onAddToCart?.call(food));
      },
    );
  }
}
