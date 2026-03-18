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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double iconSize = ResponsiveSize.backButtonSize(screenWidth);

    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 6, top: 6, bottom: 6),
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
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.all(iconSize * 0.25),
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
