import 'package:flutter/material.dart';

class AddMembershipScreen extends StatefulWidget {
  @override
  _AddMembershipScreenState createState() => _AddMembershipScreenState();
}

class _AddMembershipScreenState extends State<AddMembershipScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String? selectedDuration = '6 Months'; // Default selected duration

  // Function to handle the form submission
  void _submitMembership() {
    if (_formKey.currentState!.validate()) {
      // Handle successful form submission (you can add your desired action here)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Membership Added Successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all mandatory fields!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              // Background Image
              Image.asset(
                "asset/background.jpg",
                fit: BoxFit.cover,
                height: screenHeight,
                width: screenWidth,
              ),
              // Content on top of the background image
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        "Add Membership",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontFamily: "NerkoOne",
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Name Text Field
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.7),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),

                          // Email Text Field
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.7),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),

                          // Membership Duration Selection
                          DropdownButtonFormField<String>(
                            value: selectedDuration,
                            items: ['6 Months', '1 Year', '2 Years']
                                .map((duration) => DropdownMenuItem(
                              value: duration,
                              child: Text(duration),
                            ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedDuration = value;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Select Membership Duration',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.7),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a membership duration';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Confirm Button
                          ElevatedButton(
                            onPressed: _submitMembership,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black.withOpacity(0.7),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Confirm',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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
