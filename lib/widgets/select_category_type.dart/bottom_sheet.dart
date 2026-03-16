import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';

class BottomSheetCustom extends StatelessWidget {
  const BottomSheetCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = Responsive.isMobileConstraints(constraints);
        final horizontalPadding = isMobile ? 8.0 : 16.0;
        final verticalPadding = isMobile ? 8.0 : 12.0;
        final titleFontSize = isMobile ? 8.0 : 14.0;
        final contentFontSize = isMobile ? 6.0 : 11.0;
        final spacing = isMobile ? 3.0 : 6.0;
        // Your layout logic here
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
              // Contract Info Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(spacing * 2),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Contact Us",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: titleFontSize,
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
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(spacing * 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: Colors.white,
                                size: contentFontSize + 2,
                              ),
                              SizedBox(width: spacing),
                              Text(
                                "090-890-xxxx",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: contentFontSize,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: spacing),
                          Row(
                            children: [
                              Icon(
                                Icons.email,
                                color: Colors.white,
                                size: contentFontSize + 2,
                              ),
                              SizedBox(width: spacing),
                              Text(
                                "SoiSiam",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: contentFontSize,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: spacing),
                          Row(
                            children: [
                              Icon(
                                Icons.chat,
                                color: Colors.white,
                                size: contentFontSize + 2,
                              ),
                              SizedBox(width: spacing),
                              Text(
                                "SoiSiam Channel",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: contentFontSize,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: spacing),
                          Row(
                            children: [
                              Icon(
                                Icons.email,
                                color: Colors.white,
                                size: contentFontSize + 2,
                              ),
                              SizedBox(width: spacing),
                              Text(
                                "soisiam@gmail.co.th",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: contentFontSize,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Contract Links Section
              SizedBox(height: spacing * 2),
              // Fonder Info Section
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
}
