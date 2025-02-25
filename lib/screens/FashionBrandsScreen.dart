import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../services/purchases_service.dart';

class FashionBrandsScreen extends StatefulWidget {
  @override
  _FashionBrandsScreenState createState() => _FashionBrandsScreenState();
}

class _FashionBrandsScreenState extends State<FashionBrandsScreen> {
  Set<String> selectedBrands = {};

  final List<Map<String, String>> brands = [
    {'name': 'Lululemon', 'logo': 'assets/lululemon.png'},
    {'name': 'Skims', 'logo': 'assets/skims.png'},
    {'name': 'Gymshark', 'logo': 'assets/gymshark.png'},
    {'name': 'Alo', 'logo': 'assets/alo.png'},
    {'name': 'Gap', 'logo': 'assets/gap.png'},
    {'name': 'Nike', 'logo': 'assets/nike.png'},
    {'name': 'Zara', 'logo': 'assets/zara.png'},
    {'name': 'Uniqlo', 'logo': 'assets/uniqlo.jpeg'},
  ];

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isPhone = screenSize.width < 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width * (isPhone ? 0.04 : 0.1),
            vertical: 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                "Select your favorite fashion brands",
                style: TextStyle(
                  fontSize: isPhone ? 24 : 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Choose as many as you like",
                style: TextStyle(
                  fontSize: isPhone ? 16 : 20,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isPhone ? 2 : 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: brands.length,
                  itemBuilder: (context, index) {
                    final brand = brands[index];
                    final isSelected = selectedBrands.contains(brand['name']);
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedBrands.remove(brand['name']);
                          } else {
                            selectedBrands.add(brand['name']!);
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.black : Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              brand['logo']!,
                              height: isPhone ? 40 : 50,
                            ),
                            SizedBox(height: 8),
                            Text(
                              brand['name']!,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontSize: isPhone ? 14 : 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: _handleContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: isPhone ? 16 : 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleContinue() async {
    if (selectedBrands.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one brand')),
      );
      return;
    }

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

class PaywallSheet extends StatelessWidget {
  final Package package;
  final VoidCallback onSuccess;

  const PaywallSheet({
    required this.package,
    required this.onSuccess,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPhone = MediaQuery.of(context).size.width < 600;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Unlock Premium',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isPhone ? 24 : 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeatureItem('✨ Unlimited style matches'),
                  _buildFeatureItem('🔍 Detailed product recommendations'),
                  _buildFeatureItem('💫 Priority access to new features'),
                  _buildFeatureItem('🎯 Personalized style suggestions'),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final customerInfo = await PurchasesService.purchasePackage(package);
                        if (customerInfo != null && customerInfo.entitlements.active.isNotEmpty) {
                          onSuccess();
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Purchase failed. Please try again.')),
                        );
                      }
                    },
                    child: Text('Start Free Trial'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(text, style: TextStyle(fontSize: 18)),
    );
  }
}
