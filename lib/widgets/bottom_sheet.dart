import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/responsive.dart';

class BottomSheetInfo extends StatelessWidget {
  const BottomSheetInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // ✅ Responsive values
        final isMobile = Responsive.isMobileConstraints(constraints);
        final horizontalPadding = isMobile ? 10.0 : 20.0;
        final verticalPadding = isMobile ? 10.0 : 16.0;
        final titleFontSize = isMobile ? 12.0 : 16.0;
        final contentFontSize = isMobile ? 10.0 : 13.0;
        final spacing = isMobile ? 4.0 : 8.0;

        return Container(
          width: double.infinity,
          color: const Color(0xFF1F1F1F),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min, // ✅ ไม่ใช้ Expanded - ให้ flexible
            children: [
              /// 🔹 Contact Info Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 Left: Address
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Contact Us",
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: spacing),
                        Text(
                          "Rattanathibech 28 Alley, Tambon Bang Kraso,\n"
                          "Mueang Nonthaburi District,\n"
                          "Nonthaburi 11000",
                          maxLines: 4,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: contentFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: spacing * 2),

                  /// 🔹 Right: Social Media
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ContactRow(
                          icon: Icons.phone,
                          text: "090-890-xxxx",
                          fontSize: contentFontSize,
                        ),
                        SizedBox(height: spacing),
                        _ContactRow(
                          icon: Icons.camera_alt,
                          text: "SoiSiam",
                          fontSize: contentFontSize,
                        ),
                        SizedBox(height: spacing),
                        _ContactRow(
                          icon: Icons.play_circle_fill,
                          text: "SoiSiam Channel",
                          fontSize: contentFontSize,
                        ),
                        SizedBox(height: spacing),
                        _ContactRow(
                          icon: Icons.email,
                          text: "soisiam@gmail.co.th",
                          fontSize: contentFontSize,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: verticalPadding),

              /// 🔹 Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      "© Copyright 2022 | Powered by ",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: contentFontSize,
                      ),
                    ),
                  ),
                  SizedBox(width: spacing),
                  Image.asset(
                    "assets/logo/smile_logo.png",
                    width: isMobile ? 12 : 16,
                    height: isMobile ? 12 : 16,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final double fontSize;

  const _ContactRow({
    required this.icon,
    required this.text,
    this.fontSize = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: fontSize * 0.8, color: Colors.white),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white70, fontSize: fontSize),
          ),
        ),
      ],
    );
  }
}
