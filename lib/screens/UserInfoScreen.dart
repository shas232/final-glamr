import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'FashionBrandsScreen.dart';

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? selectedState;

  final List<String> states = [
    'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California',
    'Colorado', 'Connecticut', 'Delaware', 'Florida', 'Georgia',
    'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa',
    'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland',
    'Massachusetts', 'Michigan', 'Minnesota', 'Mississippi', 'Missouri',
    'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 'New Jersey',
    'New Mexico', 'New York', 'North Carolina', 'North Dakota', 'Ohio',
    'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island', 'South Carolina',
    'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont',
    'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming'
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
          // Adjust horizontal padding based on screen size
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width * (isPhone ? 0.04 : 0.1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10), 
              Text(
                "Tell us about yourself",
                style: TextStyle(
                  fontSize: isPhone ? 24 : 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),

              // First bar (TextField)
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'What is your first name?',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  floatingLabelStyle: TextStyle(color: Colors.grey[600]),
                ),
              ),
              SizedBox(height: 30),

              // Second bar (Dropdown)
              Container(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: Text(
                      'Which state do you live in?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    items: states.map((String state) {
                      return DropdownMenuItem<String>(
                        value: state,
                        child: Text(
                          state,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      );
                    }).toList(),
                    value: selectedState,
                    onChanged: (String? value) {
                      setState(() {
                        selectedState = value;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                        color: Colors.white,
                      ),
                    ),
                    // Important: Set offset to (0, 0) so the dropdown anchors correctly
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      offset: const Offset(0, 0),  // <-- Drop-down directly under button
                      width: screenSize.width * (isPhone ? 0.92 : 0.8),
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      height: 48,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    iconStyleData: IconStyleData(
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),

              // Continue button
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Only continue if name and state are not empty
                    if (_nameController.text.isNotEmpty && selectedState != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FashionBrandsScreen(),
                        ),
                      );
                    }
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
