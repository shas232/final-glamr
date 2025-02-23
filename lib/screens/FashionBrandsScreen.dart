import 'package:flutter/material.dart';
import 'camera_screen.dart';

class FashionBrandsScreen extends StatefulWidget {
  @override
  _FashionBrandsScreenState createState() => _FashionBrandsScreenState();
}

class _FashionBrandsScreenState extends State<FashionBrandsScreen> {
  Set<String> selectedBrands = {};

  final List<Map<String, String>> brands = [
    {'name': 'Lululemon', 'logo': 'assets/brands/lululemon.png'},
    {'name': 'Skims', 'logo': 'assets/brands/skims.png'},
    {'name': 'Gymshark', 'logo': 'assets/brands/gymshark.png'},
    {'name': 'Alo', 'logo': 'assets/brands/alo.png'},
    {'name': 'Gap', 'logo': 'assets/brands/gap.png'},
    {'name': 'Nike', 'logo': 'assets/brands/nike.png'},
    {'name': 'Zara', 'logo': 'assets/brands/zara.png'},
    {'name': 'Uniqlo', 'logo': 'assets/brands/uniqlo.jpeg'},
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
                              color: isSelected ? Colors.white : Colors.black,
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
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CameraScreen()),
                    );
                  },
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
} 