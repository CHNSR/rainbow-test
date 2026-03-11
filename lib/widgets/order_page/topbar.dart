import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/order_page/search_widget.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          /// Back button (เล็กลง)
          SizedBox(
            height: 32,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(60, 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  const Icon(Icons.arrow_back, color: Colors.black54, size: 18),
                  const AutoSizeText(
                    maxLines: 1,
                    minFontSize: 8,
                    overflow: TextOverflow.visible,
                    "Back",
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
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
                    child: IconButton(
                      iconSize: 26,
                      onPressed: onToggleSearch,
                      icon: const Icon(Icons.search),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
