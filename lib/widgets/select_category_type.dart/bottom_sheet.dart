import 'package:flutter/material.dart';

class BottomSheetCustom extends StatelessWidget {
  const BottomSheetCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = MediaQuery.of(context).size;
        final isLandscape = screenSize.width > screenSize.height;
        final horizontalPadding =
            isLandscape ? screenSize.width * 0.01 : screenSize.width * 0.07;
        final verticalPadding =
            isLandscape ? screenSize.width * 0.01 : screenSize.width * 0.05;
        final titleFontSize =
            isLandscape ? screenSize.width * 0.01 : screenSize.width * 0.015;
        final contentFontSize =
            isLandscape ? screenSize.width * 0.005 : screenSize.width * 0.015;
        final spacing =
            isLandscape ? screenSize.width * 0.005 : screenSize.width * 0.005;

        // Your layout logic here
        return Container(
          width: double.infinity,
          color: const Color(0xFF212121),
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
                                  height: contentFontSize,
                                  width: contentFontSize,
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
                                  height: contentFontSize,
                                  width: contentFontSize,
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
                                  height: contentFontSize,
                                  width: contentFontSize,
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
                                  height: contentFontSize,
                                  width: contentFontSize,
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
              //SizedBox(height: spacing ),
              Spacer(),
              // Fonder Info Section
              Align(
                alignment: AlignmentGeometry.bottomCenter,
                child: Row(
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
                      width: isLandscape
                          ? screenSize.width * 0.015
                          : screenSize.width * 0.05,
                      height: isLandscape
                          ? screenSize.width * 0.015
                          : screenSize.width * 0.05,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
