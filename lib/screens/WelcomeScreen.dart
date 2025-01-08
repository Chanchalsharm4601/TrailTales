import 'package:flutter/material.dart';
import 'package:trail_tales/screens/signin.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _HomeState();
}

class _HomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background Image that covers the whole screen
          Image.asset(
            'asset/background.jpg',
            fit: BoxFit.cover,
            height: double.infinity, // Ensures full screen height
            width: double.infinity, // Ensures full screen width
            alignment: Alignment.center,
          ),
          // Centered Text displaying the app's welcome message
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Centers the text block vertically
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Welcome message
                Text(
                  "Hey! Welcome to",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32, // Increased font size for better readability
                    fontWeight: FontWeight.bold,
                    fontFamily: "NerkoOne", // Custom font for styling
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10), // Adds spacing for visual balance
                // App name text with larger font
                Text(
                  "TrailTales",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 80, // Larger font for the app name
                      fontFamily: "NerkoOne",
                      fontWeight: FontWeight.bold), // Bold to emphasize the name
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30), // Adds spacing between text and button
                // Button to navigate to the next screen (Home)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // Transparent background for the button
                    shadowColor: Colors.transparent, // No shadow for button
                    elevation: 0, // No elevation effect
                    shape: const CircleBorder(), // Circular button shape
                    side: BorderSide(width: 4, color: Colors.white), // White border for the button
                    padding: EdgeInsets.all(15), // Padding for the button
                  ),
                  onPressed: () {
                    // Navigates to the Home screen
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                  },
                  child: const Icon(
                    Icons.arrow_forward_ios_outlined, // Arrow icon for navigation
                    color: Colors.white, // White color for the icon
                    size: 30, // Slightly larger icon size for better visibility
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
