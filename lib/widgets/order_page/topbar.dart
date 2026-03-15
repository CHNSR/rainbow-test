import 'package:auto_size_text/auto_size_text.dart';
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
    double width = MediaQuery.of(context).size.width;
    double buttonHeight;
    double iconSize;
    double fontSize;

    if (width < 600) {
      buttonHeight = 24;
      iconSize = 12;
      fontSize = 9;
    } else if (width < 1024) {
      buttonHeight = 32;
      iconSize = 18;
      fontSize = 14;
    } else {
      buttonHeight = 36;
      iconSize = 20;
      fontSize = 18;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          /// Back button
          Align(
            alignment: .centerLeft,
            child: SizedBox(
              height: buttonHeight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  elevation: 0,
                  padding: const EdgeInsets.all(3),
                  minimumSize: Size(50, buttonHeight),
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
                    Text(
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                      "Back",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: fontSize,
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
                      height: iconSize * 2,
                      width: iconSize * 2,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: iconSize,
                        onPressed: onToggleSearch,
                        icon: const Icon(Icons.search),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
