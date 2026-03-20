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
                        isSelected ? Color(0xFF02CCFE) : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6),
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
}
