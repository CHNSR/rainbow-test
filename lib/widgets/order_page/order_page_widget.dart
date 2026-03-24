import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderPageWidget {
  static Widget topBar({
    required BuildContext context,
    required bool showSearchBar,
    required Function() onToggleSearch,
    required Function(String) onSearchChanged,
  }) {
    final Size size = MediaQuery.of(context).size;
    final bool isLandscape = size.width > size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double iconSize = ResponsiveSize.backButtonSize(screenWidth);

    return Padding(
      padding: EdgeInsets.only(
          right: 6,
          top: isLandscape ? screenWidth * 0.015 : screenWidth * 0.06,
          bottom: isLandscape ? screenWidth * 0.01 : screenWidth * 0.02),
      child: Row(
        children: [
          /// Back button
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: ResponsiveSize.backButtonheight(screenWidth),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  minimumSize:
                      Size(20, ResponsiveSize.subcategoryheight(screenWidth)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      color: Colors.black54,
                      size: iconSize,
                    ),
                    SizedBox(
                      width: screenWidth * 0.004,
                    ),
                    Text(
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                      "Back",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: ResponsiveFont.backButton(screenWidth),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          /// Search area (ยาวขึ้น)
          Expanded(
            child: showSearchBar
                ? _SearchWidget(
                    onChanged: onSearchChanged,
                    onClear: onToggleSearch,
                  )
                : Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: ResponsiveSize.backButtonheight(screenWidth),
                      width: ResponsiveSize.backButtonheight(screenWidth),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.all(
                            isLandscape ? iconSize * 0.4 : iconSize * 0.32),
                        iconSize: iconSize,
                        onPressed: onToggleSearch,
                        icon: Image.asset('assets/logo/search_logo.png'),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  static Widget categoryBar({
    required BuildContext context,
    required List<FoodSet> sets,
    required String? selectedSetId,
    required Function(String) onSelect,
  }) {
    final screen = MediaQuery.of(context).size;
    final screenWidth = screen.width;
    final isLandScape = screen.width > screen.height;
    return SizedBox(
      height: ResponsiveSize.subcategoryheight(screenWidth),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sets.length,
        itemBuilder: (context, index) {
          final set = sets[index];
          final isSelected = set.foodSetId == selectedSetId;

          return Row(
            children: [
              GestureDetector(
                onTap: () => onSelect(set.foodSetId!),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        isLandScape ? screenWidth * 0.03 : screenWidth * 0.02,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        isSelected ? const Color(0xFF02CCFE) : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6),
                    border: isSelected
                        ? Border.all(
                            color: Colors.grey.shade500,
                            width: 1.0,
                          )
                        : null,
                  ),
                  child: Text(
                    set.foodSetName ?? "",
                    style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: ResponsiveFont.titleCategory(screenWidth),
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              SizedBox(
                  width: isLandScape ? screenWidth * 0.01 : screenWidth * 0.01),
            ],
          );
        },
      ),
    );
  }

  static Widget subCategoryBar({
    required BuildContext context,
    required List<SubFoodCategory> categories,
    required String? selectedCategoryId,
    required Function(String) onSelect,
    required ScrollController scrollController,
  }) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = isLandscape ? screenWidth * 0.1 : screenWidth * 0.18;

    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        height: ResponsiveSize.subcategoryheight(screenWidth),
        child: ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = category.foodCatId == selectedCategoryId;

            return GestureDetector(
              onTap: () {
                onSelect(category.foodCatId!);
                scrollController.animateTo(
                  index * itemWidth,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                );
              },
              child: Container(
                width: itemWidth,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF02CCFE)
                      : const Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  category.foodCatName ?? "",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ResponsiveFont.subcategory_size(screenWidth),
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static Widget menuGrid({
    required BuildContext context,
    required List<FoodMenu> foods,
    required List<SubFoodCategory> subcategories,
    required ScrollController? subcategoryScrollController,
    required Map<String, GlobalKey> categoryKeys,
    required ScrollController menuScrollController,
  }) {
    Map<String, List<FoodMenu>> groupFoodByCategory(List<FoodMenu> foods) {
      final Map<String, List<FoodMenu>> map = {};
      for (var food in foods) {
        map.putIfAbsent(food.foodCatId, () => []);
        map[food.foodCatId]!.add(food);
      }
      return map;
    }

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
                    color: const Color(0xFF4F4F4F),
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

                  return menuCard(
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

  static Widget menuCard({
    required FoodMenu food,
    required Function() onAddToCart,
  }) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        int quantity = 0;

        final index = state.cartItems.indexWhere(
          (item) => item.food.foodId == food.foodId,
        );

        if (index != -1) {
          quantity = state.cartItems[index].quantity;
        }

        return GestureDetector(
          onTap: onAddToCart,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.8),
                  spreadRadius: 0,
                  blurRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double titleSize = constraints.maxWidth * 0.05;
                double descSize = constraints.maxWidth * 0.04;
                double priceSize = constraints.maxWidth * 0.05;

                return Column(
                  children: [
                    /// IMAGE
                    Expanded(
                      flex: 60,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
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
                      flex: 40,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// TITLE + QUANTITY
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: RichText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
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
                                            style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w500,
                                              fontSize: titleSize,
                                              color: const Color(0xFF4F4F4F),
                                            ),
                                          ),
                                        ],
                                      ),
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
                                ],
                              ),

                              /// PRICE
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  "\$${food.foodPrice}",
                                  style: GoogleFonts.roboto(
                                    color: const Color(0xFF4F4F4F),
                                    fontWeight: FontWeight.w500,
                                    fontSize: priceSize,
                                  ),
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
      },
    );
  }
}

class _SearchWidget extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchWidget({
    Key? key,
    required this.onChanged,
    required this.onClear,
  }) : super(key: key);

  @override
  State<_SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<_SearchWidget> {
  final TextEditingController controller = TextEditingController();

  void _clear() {
    if (controller.text.isEmpty) {
      widget.onClear();
    } else {
      controller.clear();
      widget.onChanged("");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenwidget = MediaQuery.of(context).size.width;
    final double buttonHeight = ResponsiveSize.backButtonheight(screenwidget);
    final double textSize = ResponsiveFont.backButton(screenwidget);
    return SizedBox(
      height: buttonHeight,
      child: TextField(
        controller: controller,
        onChanged: widget.onChanged,
        style: TextStyle(fontSize: textSize),
        decoration: InputDecoration(
          isDense: true,
          hint: Text("Search foods...",
              maxLines: 1, style: TextStyle(fontSize: textSize)),

          /// 🔹 ปรับ icon ให้ชิด text
          prefixIcon: Padding(
            padding: const EdgeInsets.all(1),
            child: const Icon(Icons.search, size: 12),
          ),

          prefixIconConstraints: const BoxConstraints(
            minWidth: 18,
            minHeight: 18,
          ),

          suffixIcon: IconButton(
            icon: Icon(Icons.clear, size: textSize),
            padding: EdgeInsets.zero,
            onPressed: _clear,
          ),

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),

          /// 🔹 ลด padding เพื่อให้ text ไม่โดนตัด
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 1,
            vertical: 1,
          ),
        ),
      ),
    );
  }
}
