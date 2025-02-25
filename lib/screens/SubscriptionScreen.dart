import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'UserInfoScreen.dart';

class SubscriptionScreen extends StatelessWidget {
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      print(e);
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final Size screenSize = MediaQuery.of(context).size;
    final bool isPhone = screenSize.width < 600;

    // Calculate responsive sizes
    final double titleFontSize = isPhone ? 20 : 32;
    final double subtitleFontSize = isPhone ? 14 : 22;
    final double priceFontSize = isPhone ? 18 : 28;
    final double descriptionFontSize = isPhone ? 16 : 24;
    final double buttonFontSize = isPhone ? 16 : 24;
    final double topPadding = screenSize.height * 0.1;
    final double horizontalPadding = screenSize.width * (isPhone ? 0.04 : 0.1);
    final double imageHeight = screenSize.height * 0.3;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: topPadding),

              // Title and Subtitle
              Column(
                children: [
                  Text(
                    "FIND THE CHEAPEST ALTERNATIVE",
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenSize.height * 0.01),
                  Text(
                    "Proven to find best prices",
                    style: TextStyle(
                      fontSize: subtitleFontSize,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  // SizedBox(height: screenSize.height * 0.02),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text(
                  //       "\$88",
                  //       style: TextStyle(
                  //         fontSize: priceFontSize,
                  //         color: Colors.red,
                  //         fontWeight: FontWeight.bold,
                  //         decoration: TextDecoration.lineThrough,
                  //       ),
                  //     ),
                  //     SizedBox(width: screenSize.width * 0.02),
                  //     Icon(
                  //       Icons.arrow_forward,
                  //       color: Colors.green,
                  //       size: isPhone ? 20 : 26,
                  //     ),
                  //     SizedBox(width: screenSize.width * 0.02),
                  //     Text(
                  //       "\$6",
                  //       style: TextStyle(
                  //         fontSize: priceFontSize,
                  //         color: Colors.green,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.02),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isPhone ? double.infinity : 600,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(isPhone ? 12 : 16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(screenSize.width * 0.04),
                  child: Text(
                    "All you have to do is click a picture or upload one of some clothing you want to buy, and we will show you the cheapest similar-looking alternatives.",
                    style: TextStyle(
                      fontSize: descriptionFontSize,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              Container(
                width: double.infinity,
                height: imageHeight,
                constraints: BoxConstraints(
                  maxWidth: isPhone ? double.infinity : 600,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(isPhone ? 16 : 20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Center(
                  child: Image.network(
                    'https://p1.assets.glamr.us/home_page_animation.gif',
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Image.asset(
                        'assets/home_screen_animation_preview.png',
                        fit: BoxFit.cover,
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/home_screen_animation_preview.png',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: screenSize.height * 0.03),

              Container(
                constraints: BoxConstraints(
                  maxWidth: isPhone ? double.infinity : 600,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserInfoScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      vertical: screenSize.height * 0.02,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: Size(double.infinity, screenSize.height * 0.07),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Find your best clothing today ",
                        style: TextStyle(
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.celebration,
                        color: Colors.white,
                        size: isPhone ? 20 : 26,
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                  bottom: screenSize.height * 0.03,
                  top: screenSize.height * 0.02,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => _launchURL('https://privacy.glamr.us'),
                      child: Text(
                        "Privacy Policy",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: isPhone ? 18 : 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}