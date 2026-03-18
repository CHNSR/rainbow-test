import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuGrid extends StatelessWidget {
  final List<FoodMenu> foods;
  final Function(FoodMenu)? onAddToCart;
  final List<SubFoodCategory> subcategories;
  final ScrollController? subcategoryScrollController;
  final Map<String, GlobalKey> categoryKeys;
  final ScrollController menuScrollController;
  final List<CartItem> cartItems;

  const MenuGrid({
    super.key,
    required this.foods,
    required this.subcategories,
    required this.subcategoryScrollController,
    required this.categoryKeys,
    required this.menuScrollController,
    required this.cartItems,
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
    final double aspectRatio = 352 / 354;

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
                padding: const EdgeInsets.only(
                    top: 16, left: 16, right: 8, bottom: 0),
                child: Text(
                  section.foodCatName,
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4F4F4F),
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
                      context.read<CartBloc>().add(
                            AddToCartEvent(food),
                          );
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
