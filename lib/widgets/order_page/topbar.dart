import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';

class TopBar extends StatelessWidget {
  final bool showSearchBar;
  final Function() onToggleSearch;
  final Function(String) onSearchChanged;

  const TopBar({
    super.key,
    required this.showSearchBar,
    required this.onToggleSearch,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isLandscape = size.width > size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double iconSize = ResponsiveSize.backButtonSize(screenWidth);

    return Padding(
      padding: EdgeInsets.only(
          right: 6,
          top: isLandscape ? screenWidth * 0.015 : screenWidth * 0.05,
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
                ? SearchWidget(
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
                            isLandscape ? iconSize * 0.3 : iconSize * 0.32),
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
}
