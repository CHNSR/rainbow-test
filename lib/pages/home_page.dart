import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showBottom = false;
  Offset offset = const Offset(0, 1);

  void _toggleBottomSheet() async {
    if (!showBottom) {
      // เปิด
      setState(() {
        showBottom = true;
        offset = const Offset(0, 1);
      });

      await Future.delayed(const Duration(milliseconds: 50));

      setState(() {
        offset = const Offset(0, 0);
      });
    } else {
      // ปิด (animate ลงก่อน)
      setState(() {
        offset = const Offset(0, 1);
      });

      await Future.delayed(const Duration(milliseconds: 400));

      setState(() {
        showBottom = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: GestureDetector(
          onTap: _toggleBottomSheet,
          child: Row(
            children: [
              Image.asset("assets/logo/chonsom.png", width: 15, height: 15),
              const SizedBox(width: 8),
              const Text("Soi Siam", style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
        actions: [PopupWidget()],
      ),
      //
      body: Stack(
        children: [
          Center(
            child: isLandscape ? LandscapeMainContant() : PortraitMainContant(),
          ),
          if (showBottom)
            AnimatedSlide(
              offset: offset,
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: BottomSheetCustom(),
              ),
            ),
        ],
      ),
    );
  }
}
