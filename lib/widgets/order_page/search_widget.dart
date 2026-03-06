import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const SearchWidget({
    super.key,
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController controller = TextEditingController();

  void _clear() {
    if (controller.text.isEmpty) {
      widget.onClear(); // 🔹 ปิด search bar
    } else {
      controller.clear(); // 🔹 ลบข้อความ
      widget.onChanged("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: "Search food...",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: _clear,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }
}
