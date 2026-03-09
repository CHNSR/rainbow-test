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
        final horizontalPadding = isMobile ? 8.0 : 16.0;
        final verticalPadding = isMobile ? 8.0 : 12.0;
        final titleFontSize = isMobile ? 11.0 : 14.0;
        final contentFontSize = isMobile ? 9.0 : 11.0;
        final spacing = isMobile ? 3.0 : 6.0;

        return Container(
          width: double.infinity,
          color: const Color(0xFF1F1F1F),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 🔹 Contact Info Section
              Flexible(
                child: isMobile
                    ? _buildMobileContactLayout(
                        spacing,
                        titleFontSize,
                        contentFontSize,
                      )
                    : _buildDesktopContactLayout(
                        spacing,
                        titleFontSize,
                        contentFontSize,
                      ),
              ),

              SizedBox(height: verticalPadding),

              /// 🔹 Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
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
                    width: isMobile ? 10 : 14,
                    height: isMobile ? 10 : 14,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// 🔹 Mobile Layout: Vertical Stack
  Widget _buildMobileContactLayout(
    double spacing,
    double titleFontSize,
    double contentFontSize,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        Text(
          "Contact Us",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white70,
            fontSize: titleFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: spacing),

        // Address
        Text(
          "Rattanathibech 28 Alley, Tambon Bang Kraso, Mueang Nonthaburi District, Nonthaburi 11000",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white70,
            fontSize: contentFontSize,
            height: 1.2,
          ),
        ),
        SizedBox(height: spacing * 1.5),

        // Contact Info
        _ContactRow(
          icon: Icons.phone,
          text: "090-890-xxxx",
          fontSize: contentFontSize,
        ),
        SizedBox(height: spacing * 0.8),
        _ContactRow(
          icon: Icons.camera_alt,
          text: "SoiSiam",
          fontSize: contentFontSize,
        ),
        SizedBox(height: spacing * 0.8),
        _ContactRow(
          icon: Icons.play_circle_fill,
          text: "SoiSiam Channel",
          fontSize: contentFontSize,
        ),
        SizedBox(height: spacing * 0.8),
        _ContactRow(
          icon: Icons.email,
          text: "soisiam@gmail.co.th",
          fontSize: contentFontSize,
        ),
      ],
    );
  }

  /// 🔹 Desktop Layout: Horizontal 2-Column
  Widget _buildDesktopContactLayout(
    double spacing,
    double titleFontSize,
    double contentFontSize,
  ) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Left: Address
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Contact Us",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: spacing),
              Text(
                "Rattanathibech 28 Alley, Tambon Bang Kraso, Mueang Nonthaburi District, Nonthaburi 11000",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: contentFontSize,
                  height: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(width: spacing * 2),

          /// 🔹 Right: Social Media
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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
        ],
      ),
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
        Icon(icon, size: fontSize * 0.6, color: Colors.white), // ลด icon size
        const SizedBox(width: 3), // ลด spacing
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
