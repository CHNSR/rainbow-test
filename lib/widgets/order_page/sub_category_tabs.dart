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

    // 🔥 กำหนดความกว้างต่อ item
    final itemWidth = screenWidth * 0.18; // ปรับได้ตามต้องการ

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
                  index * itemWidth, // 🔥 ใช้ width จริง
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                );
              },
              child: Container(
                width: itemWidth, // ✅ ทำให้เท่ากัน
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF02CCFE)
                      : const Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  category.foodCatName ?? "",
                  textAlign: TextAlign.center, // 🔥 กันล้น
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // 🔥 กันล้น
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
}
