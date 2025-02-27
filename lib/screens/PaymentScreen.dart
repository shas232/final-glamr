import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../services/purchases_service.dart';
import 'camera_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isPhone = screenSize.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.width * (isPhone ? 0.04 : 0.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              "UNLOCK FACE MELTING DEALS",
              style: TextStyle(
                fontSize: isPhone ? 28 : 40,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: isPhone ? 16 : 20,
                  color: Colors.grey[600],
                ),
                children: [
                  TextSpan(text: "Best user has saved "),
                  TextSpan(
                    text: "\$7291",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: " in the first week"),
                ],
              ),
            ),
            SizedBox(height: 40),
            Container(
              width: double.infinity,
              height: screenSize.height * 0.35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/paymentscreenanimation.gif',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Spacer(),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _handlePurchase(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "SAVE NOW ->",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Our users save 10X more than the \$2.99/week cost",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Add privacy policy action
                      },
                      child: Text(
                        "Privacy Policy",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(" • ", style: TextStyle(color: Colors.grey[600])),
                    TextButton(
                      onPressed: () async {
                        try {
                          // Show loading indicator
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );

                          // Restore purchases
                          CustomerInfo restoredInfo = await Purchases.restorePurchases();
                          
                          // Close loading indicator
                          Navigator.pop(context);

                          // Check if user has pro access
                          if (restoredInfo.entitlements.all['pro']?.isActive == true) {
                            // Navigate to camera screen if they have access
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => CameraScreen()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('No active subscription found')),
                            );
                          }
                        } catch (e) {
                          // Close loading indicator if there was an error
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to restore purchase. Please try again.')),
                          );
                        }
                      },
                      child: Text(
                        "Already purchased?",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePurchase(BuildContext context) async {
    try {
      final offerings = await PurchasesService.getOfferings();
      
      if (offerings == null || offerings.current == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to load subscription options')),
        );
        return;
      }

      final packages = offerings.current!.availablePackages;
      if (packages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Subscription package not available')),
        );
        return;
      }

      final package = packages.first;
      try {
        CustomerInfo? purchaseResult = await PurchasesService.purchasePackage(package);
        
        if (purchaseResult != null && purchaseResult.entitlements.all['pro']?.isActive == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CameraScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Purchase was not completed. Please try again.')),
          );
        }
      } catch (purchaseError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to complete purchase. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to load subscription options')),
      );
    }
  }
} 