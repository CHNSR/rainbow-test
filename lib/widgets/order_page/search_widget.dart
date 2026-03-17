import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/responsive.dart';

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
    final double screenwidget = MediaQuery.of(context).size.width;
    final double buttonHeight = ResponsiveSize.backButtonheight(screenwidget);
    final double textSize = ResponsiveFont.backButton(screenwidget);
    return SizedBox(
      height: buttonHeight,
      child: TextField(
        controller: controller,
        onChanged: widget.onChanged,
        style: TextStyle(fontSize: textSize),
        decoration: InputDecoration(
          isDense: true,
          hint: Text("Search foods...",
              maxLines: 1, style: TextStyle(fontSize: textSize)),

          /// 🔹 ปรับ icon ให้ชิด text
          prefixIcon: Padding(
            padding: EdgeInsets.all(1),
            child: Icon(Icons.search, size: 12),
          ),

          prefixIconConstraints: const BoxConstraints(
            minWidth: 18,
            minHeight: 18,
          ),

          suffixIcon: IconButton(
            icon: Icon(Icons.clear, size: textSize),
            padding: EdgeInsets.zero,
            onPressed: _clear,
          ),

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),

          /// 🔹 ลด padding เพื่อให้ text ไม่โดนตัด
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 1,
            vertical: 1,
          ),
        ),
      ),
    );
  }
}
