import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'camera_screen.dart'; // Import CameraScreen for navigation

class SubscriptionScreen extends StatelessWidget {
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication); // Launch in external browser
    } catch (e) {
      print(e);
      throw 'Could not launch $url'; // Handle error if URL can't be opened
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 60), // Space at the top for layout alignment

            // Title and Subtitle
            const Column(
              children: [
                Text(
                  "UNLIMITED SEARCHES",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Proven to find best prices",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),

            // Image Container Placeholder
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Center(
                child: Image.network(
                  'https://p1.assets.glamr.us/home_page_animation.gif', // Replace with your actual CDN URL
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      // The image is fully loaded
                      return child;
                    } else {
                      // Show a placeholder image or a CircularProgressIndicator while loading
                      return Image.asset(
                        'assets/home_screen_animation_preview.png', // Replace with your placeholder image path
                        fit: BoxFit.cover,
                      );
                    }
                  },
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    // Show a fallback image if there's an error loading the GIF
                    return Image.asset(
                      'assets/home_screen_animation_preview.png', // Replace with your error fallback image path
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),

            // Payment Information and Button
            Column(
              children: [
                const Text(
                  "✓ No payment due now",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    // Navigate to CameraScreen on button press
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CameraScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Use backgroundColor instead of primary
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: Size(double.infinity, 56), // Full-width button
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Try for free ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Icon(Icons.celebration, color: Colors.white, size: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Subscription Information
                const Text(
                  "3 days free, then \$6.99 per week",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            // Footer Links
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Terms of use",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Text(
                    "|",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Restore Purchase",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Text(
                    "|",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _launchURL('https://privacy.glamr.us'),
                    child: const Text(

                      "Privacy Policy",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
