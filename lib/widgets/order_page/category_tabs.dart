import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';

class CategoryBar extends StatelessWidget {
  final List<FoodSet> sets;
  final String? selectedSetId;
  final Function(String) onSelect;

  const CategoryBar({
    super.key,
    required this.sets,
    required this.selectedSetId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: ResponsiveSize.subcategoryheight(screenWidth),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sets.length,
        itemBuilder: (context, index) {
          final set = sets[index];
          final isSelected = set.foodSetId == selectedSetId;

          return GestureDetector(
            onTap: () => onSelect(set.foodSetId!),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF02CCFE) : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                set.foodSetName ?? "",
                style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: ResponsiveFont.titleCategory(screenWidth),
                    fontWeight: FontWeight.w400),
              ),
            ),
          );
        },
      ),
    );
  }
}
