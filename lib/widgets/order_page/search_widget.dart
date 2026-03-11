import 'package:auto_size_text/auto_size_text.dart';
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
      widget.onClear();
    } else {
      controller.clear();
      widget.onChanged("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: TextField(
        controller: controller,
        onChanged: widget.onChanged,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          isDense: true,
          hint: AutoSizeText("Search foods...", maxLines: 1, minFontSize: 14),

          /// 🔹 ปรับ icon ให้ชิด text
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 6, right: 4),
            child: Icon(Icons.search, size: 18),
          ),

          prefixIconConstraints: const BoxConstraints(
            minWidth: 28,
            minHeight: 28,
          ),

          suffixIcon: IconButton(
            icon: const Icon(Icons.clear, size: 18),
            padding: EdgeInsets.zero,
            onPressed: _clear,
          ),

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),

          /// 🔹 ลด padding เพื่อให้ text ไม่โดนตัด
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 6,
          ),
        ),
      ),
    );
  }
}
