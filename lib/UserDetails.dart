import 'package:flutter/material.dart';
import 'package:trail_tales/screens/AddBook.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  // Dropdown menu options for extending membership
  String? _selectedExtensionPeriod;
  final List<String> _extensionPeriods = ['1 Month', '3 Months', '6 Months', '1 Year'];

  // Navigates to the AddBookScreen
  void _navigateToAddBookScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddBookScreen()),
    );
  }

  // Handle membership extension action
  void _extendMembership() {
    if (_selectedExtensionPeriod != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Membership extended for $_selectedExtensionPeriod!'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a membership extension period!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background color for the screen
      appBar: AppBar(
        title: Text('User Management'), // App bar with title
        backgroundColor: Colors.blueAccent, // App bar background color
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding for the body content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),

              // Add Book Section
              Text(
                'Add a Book to Your Library',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent, // Title text color
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _navigateToAddBookScreen, // Navigate to the AddBookScreen
                child: Text('Add Book'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Button color
                  padding: EdgeInsets.symmetric(vertical: 14), // Button padding
                ),
              ),
              const SizedBox(height: 20),

              // Membership Extension Section
              Text(
                'Extend Membership for Users',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent, // Title text color
                ),
              ),
              const SizedBox(height: 16),
              // Dropdown menu to select membership extension period
              DropdownButtonFormField<String>(
                value: _selectedExtensionPeriod,
                hint: Text('Select Membership Extension Period'),
                onChanged: (value) {
                  setState(() {
                    _selectedExtensionPeriod = value;
                  });
                },
                items: _extensionPeriods.map((String period) {
                  return DropdownMenuItem<String>(
                    value: period,
                    child: Text(period),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white, // Background color for the dropdown
                ),
              ),
              const SizedBox(height: 16),
              // Button to extend membership
              ElevatedButton(
                onPressed: _extendMembership, // Calls function to extend membership
                child: Text('Extend Membership'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent, // Button color
                  padding: EdgeInsets.symmetric(vertical: 14), // Button padding
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
