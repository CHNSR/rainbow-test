import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class BottomSheetInfo extends StatelessWidget {
  const BottomSheetInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1F1F1F),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// 🔹 บรรทัดบน
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 ฝั่งซ้าย
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    AutoSizeText(
                      "Contact Us",
                      maxLines: 1,
                      minFontSize: 8,
                      style: TextStyle(color: Colors.white70, fontSize: 4),
                    ),
                    SizedBox(height: 4),
                    AutoSizeText(
                      "Rattanathibech 28 Alley, Tambon Bang Kraso,\n"
                      "Mueang Nonthaburi District,\n"
                      "Nonthaburi 11000",
                      maxLines: 3,
                      minFontSize: 8,
                      style: TextStyle(color: Colors.white70, fontSize: 2),
                    ),
                  ],
                ),
              ),

              /// 🔹 ฝั่งขวา
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _ContactRow(icon: Icons.phone, text: "090-890-xxxx"),
                    SizedBox(height: 2),
                    _ContactRow(icon: Icons.camera_alt, text: "SoiSiam"),
                    SizedBox(height: 2),
                    _ContactRow(
                      icon: Icons.play_circle_fill,
                      text: "SoiSiam Channel",
                    ),
                    SizedBox(height: 2),
                    _ContactRow(icon: Icons.email, text: "soisiam@gmail.co.th"),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText.rich(
                const TextSpan(
                  children: [
                    TextSpan(
                      text: "© Copyright 2022 | Powered by ",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                maxLines: 1,
                minFontSize: 8,
                style: const TextStyle(fontSize: 5),
              ),
              SizedBox(width: 5),
              Image.asset("assets/logo/smile_logo.png", width: 16, height: 16),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 5, color: Colors.white),
        const SizedBox(width: 2),
        Expanded(
          child: AutoSizeText(
            text,
            maxLines: 1,
            minFontSize: 8,
            style: const TextStyle(color: Colors.white70, fontSize: 4),
          ),
        ),
      ],
    );
  }
}
