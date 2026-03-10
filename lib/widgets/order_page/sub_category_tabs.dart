import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/food_category.dart';

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
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
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
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  category.foodCatName ?? "",
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
