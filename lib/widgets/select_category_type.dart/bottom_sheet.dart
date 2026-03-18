import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/export.dart';

class BottomSheetCustom extends StatelessWidget {
  const BottomSheetCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = MediaQuery.of(context).size;
        final isLandscape = size.width > size.height;
        final isMobile = Responsive.isMobileConstraints(constraints);
        final horizontalPadding = isLandscape ? 8.0 : 16.0;
        final verticalPadding = isLandscape ? 36.0 : 12.0;
        final titleFontSize =
            isLandscape ? size.height * 0.02 : size.height * 0.01;
        final contentFontSize =
            isLandscape ? size.height * 0.001 : size.height * 0.01;
        final spacing =
            isLandscape ? size.height * 0.00005 : size.height * 0.005;

        // Your layout logic here
        return Container(
          width: double.infinity,
          height: isLandscape ? size.height * 0.10 : size.height * 0.20,
          color: const Color(0xFF1F1F1F),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            mainAxisSize: isLandscape ? MainAxisSize.max : MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  SizedBox(width: MediaQuery.of(context).size.width * 0.10),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(spacing * 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                  height: contentFontSize + 4,
                                  width: contentFontSize + 4,
                                  child: Image.asset(
                                    'assets/picture/call_pic.png',
                                  )),
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
                              SizedBox(
                                  height: contentFontSize + 4,
                                  width: contentFontSize + 4,
                                  child: Image.asset(
                                    'assets/picture/instagram_pic.png',
                                  )),
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
                              SizedBox(
                                  height: contentFontSize + 4,
                                  width: contentFontSize + 4,
                                  child: Image.asset(
                                    'assets/picture/youtube_pic.png',
                                  )),
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
                              SizedBox(
                                  height: contentFontSize + 4,
                                  width: contentFontSize + 4,
                                  child: Image.asset(
                                    'assets/picture/email_pic.png',
                                  )),
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
