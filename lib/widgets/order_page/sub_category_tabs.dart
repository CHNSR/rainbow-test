import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';

class SubCategoryBar extends StatelessWidget {
  final List<SubFoodCategory> categories;
  final String? selectedCategoryId;
  final Function(String) onSelect;
  final ScrollController scrollController;

  const SubCategoryBar({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onSelect,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: ResponsiveSize.subcategoryheight(screenWidth),
        decoration: BoxDecoration(
          color: Color(0xFFF6F6F6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = category.foodCatId == selectedCategoryId;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () {
                  onSelect(category.foodCatId!);
                  scrollController.animateTo(
                    index * 100,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF02CCFE) : Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    category.foodCatName ?? "",
                    style: TextStyle(
                      fontSize: ResponsiveFont.subcategory_size(screenWidth),
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
