import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';

class MenuGrid extends StatelessWidget {
  final List<FoodMenu> foods;
  final Function(FoodMenu)? onAddToCart;
  final List<SubFoodCategory> subcategories;
  final ScrollController? subcategoryScrollController;
  final Map<String, GlobalKey> categoryKeys;
  final ScrollController menuScrollController;

  const MenuGrid({
    super.key,
    required this.foods,
    required this.subcategories,
    required this.subcategoryScrollController,
    required this.categoryKeys,
    required this.menuScrollController,
    this.onAddToCart,
  });

  Map<String, List<FoodMenu>> groupFoodByCategory(List<FoodMenu> foods) {
    final Map<String, List<FoodMenu>> map = {};

    for (var food in foods) {
      map.putIfAbsent(food.foodCatId, () => []);
      map[food.foodCatId]!.add(food);
    }

    return map;
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    final crossAxisCount = orientation == Orientation.landscape ? 4 : 2;

    final foodMap = groupFoodByCategory(foods);
    double width = MediaQuery.of(context).size.width;
    double aspectRatio;

    if (width < 500) {
      aspectRatio = 0.8;
    } else if (width < 900) {
      aspectRatio = 0.85;
    } else {
      aspectRatio = 0.9;
    }

    return CustomScrollView(
      controller: menuScrollController,
      slivers: subcategories.map((section) {
        final menu = foodMap[section.foodCatId] ?? [];

        if (menu.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox());
        }

        return SliverMainAxisGroup(
          slivers: [
            /// Category Header
            SliverToBoxAdapter(
              child: Padding(
                key: categoryKeys[section.foodCatId],
                padding: const EdgeInsets.all(8),
                child: Text(
                  section.foodCatName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            /// Menu Grid
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, i) {
                  final food = menu[i];

                  return MenuCard(
                    food: food,
                    onAddToCart: () {
                      if (onAddToCart != null) {
                        onAddToCart!(food);
                      }
                    },
                  );
                }, childCount: menu.length > 8 ? 8 : menu.length),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: aspectRatio,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
