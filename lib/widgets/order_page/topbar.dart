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
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade200,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.black54),
            label: const Text("Back", style: TextStyle(color: Colors.black54)),
          ),

          const Spacer(),

          if (!showSearchBar)
            IconButton(
              onPressed: onToggleSearch,
              icon: const Icon(Icons.search),
            ),

          if (showSearchBar)
            Expanded(
              child: SearchWidget(
                onChanged: onSearchChanged,
                onClear: onToggleSearch,
              ),
            ),
        ],
      ),
    );
  }
}
