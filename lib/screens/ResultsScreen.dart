import 'package:flutter/material.dart';
import 'package:final_glamr/screens/SubscriptionScreen.dart';
import 'dart:typed_data';
import 'package:url_launcher/url_launcher.dart';
import 'package:final_glamr/screens/camera_screen.dart';

class ResultsScreen extends StatelessWidget {
  final Uint8List capturedImage;
  final Map<String, dynamic> searchResults;

  const ResultsScreen({
    super.key,
    required this.capturedImage,
    required this.searchResults,
  });

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Could not launch $url $e');
      throw 'Could not launch $url';
    }
  }

  List<Map<String, String>> _processSearchResults() {
    List<dynamic> products = searchResults['search_options'] ?? [];
    return products.map<Map<String, String>>((product) {
      return {
        'image': product['image'] ?? 'https://via.placeholder.com/150',
        'title': product['title'] ?? 'Product Name',
        'currency': product['currency'] ?? '\$',
        'price': product['price']?.toString() ?? '0',
        'source': product['source'] ?? 'Store',
        'link': product['link'] ?? 'link'
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isPhone = screenSize.width < 600;
    final List<Map<String, String>> results = _processSearchResults();

    // Responsive sizes
    final double capturedImageWidth = isPhone ? 150 : 200;
    final double capturedImageHeight = isPhone ? 200 : 266;
    final double resultCardPadding = isPhone ? 12.0 : 16.0;
    // We'll update the resultImageSize to be bigger
    // and use the same value for both image and text column height
    final double updatedResultImageSize = isPhone ? 100 : 140;
    final double titleFontSize = isPhone ? 16 : 20;
    final double priceFontSize = isPhone ? 20 : 24;
    final double sourceFontSize = isPhone ? 14 : 16;
    final double iconSize = isPhone ? 16 : 20;
    final double horizontalPadding = screenSize.width * (isPhone ? 0.04 : 0.1);

    return Scaffold(
      backgroundColor: Colors.white, // White background for a clean look
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: isPhone ? 24 : 30,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CameraScreen()),
            );
          },
        ),
        title: Text(
          'Best Results',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: isPhone ? 20 : 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(isPhone ? 16.0 : 24.0),
            child: Center(
              child: Container(
                width: capturedImageWidth,
                height: capturedImageHeight,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(isPhone ? 16 : 20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: isPhone ? 2 : 3,
                      blurRadius: isPhone ? 8 : 12,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(isPhone ? 16 : 20),
                  child: Image.memory(
                    capturedImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          if (results.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: isPhone ? 64 : 80,
                      color: Colors.grey,
                    ),
                    SizedBox(height: isPhone ? 16 : 24),
                    Text(
                      'No results found',
                      style: TextStyle(
                        fontSize: isPhone ? 18 : 22,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final result = results[index];
                  return InkWell(
                    onTap: () => _launchURL(result['link']!),
                    child: Card(
                      color: Color(0xFFF2F3F3),
                      margin: EdgeInsets.only(bottom: isPhone ? 16.0 : 24.0),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(isPhone ? 12.0 : 16.0),
                      ),
                      elevation: isPhone ? 3 : 4,
                      child: Padding(
                        padding: EdgeInsets.all(resultCardPadding),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Updated bigger product image
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(isPhone ? 8.0 : 12.0),
                              child: Image.network(
                                result['image']!,
                                width: updatedResultImageSize,
                                height: updatedResultImageSize,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: updatedResultImageSize,
                                    height: updatedResultImageSize,
                                    color: Colors.grey[300],
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey,
                                      size: updatedResultImageSize * 0.5,
                                    ),
                                  );
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    width: updatedResultImageSize,
                                    height: updatedResultImageSize,
                                    color: Colors.grey[300],
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: isPhone ? 2 : 3,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: isPhone ? 16 : 24),
                            // Text column with fixed height matching the image
                            Expanded(
                              child: Container(
                                height: updatedResultImageSize,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Title and source at the top
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          result['title']!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: titleFontSize,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                            height: isPhone ? 4 : 6),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.store,
                                              size: iconSize,
                                              color: Colors.black54,
                                            ),
                                            SizedBox(
                                                width: isPhone ? 4 : 6),
                                            Text(
                                              result['source']!,
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: sourceFontSize,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    // Price and arrow at the bottom
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          result['currency']! +
                                              result['price']!,
                                          style: TextStyle(
                                            fontSize: priceFontSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: iconSize,
                                          color: Colors.black54,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
