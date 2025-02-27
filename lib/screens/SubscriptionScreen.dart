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
    final Size screenSize = MediaQuery.of(context).size;
    final bool isPhone = screenSize.width < 600;

    // Calculate responsive sizes
    final double titleFontSize = isPhone ? 20 : 32;
    final double subtitleFontSize = isPhone ? 14 : 22;
    final double priceFontSize = isPhone ? 18 : 28;
    final double descriptionFontSize = isPhone ? 16 : 24;
    final double buttonFontSize = isPhone ? 16 : 24;
    final double topPadding = screenSize.height * 0.15;
    final double horizontalPadding = screenSize.width * (isPhone ? 0.04 : 0.1);
    final double imageHeight = screenSize.height * 0.3;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenSize.height,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(height: topPadding),
                    Column(
                      children: [
                        Text(
                          "STOP OVERPAYING",
                          style: TextStyle(
                            fontSize: isPhone ? 28 : 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "START SAVING",
                          style: TextStyle(
                            fontSize: isPhone ? 28 : 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenSize.height * 0.01),
                        Text(
                          "We use AI to find you the same or similar apparel for upto 90% less",
                          style: TextStyle(
                            fontSize: subtitleFontSize,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),

                    SizedBox(height: screenSize.height * 0.04),

                    Container(
                      width: double.infinity,
                      height: screenSize.height * 0.35,
                      constraints: BoxConstraints(
                        maxWidth: isPhone ? double.infinity : 600,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(isPhone ? 16 : 20),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
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
                  ],
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: screenSize.height * 0.08),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: isPhone ? double.infinity : 600,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
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
                        elevation: 0,
                      ),
                      child: Text(
                        "START SAVING NOW ->",
                        style: TextStyle(
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}