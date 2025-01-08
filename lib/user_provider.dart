import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  bool _isLoggedIn = false;

  User? get user => _user;
  bool get isLoggedIn => _isLoggedIn;

  // Initialize the user state by checking if the user is already logged in
  Future<void> initializeUser() async {
    _user = FirebaseAuth.instance.currentUser;
    _isLoggedIn = _user != null; // If the user exists, set isLoggedIn to true
    notifyListeners(); // Notify listeners about the state change
  }

  // Login method: Takes email and password, signs the user in, and updates the user state
  Future<void> login(String email, String password) async {
    try {
      // Attempt to sign in with the provided email and password
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user; // Set the logged-in user
      _isLoggedIn = true; // Set isLoggedIn to true
      notifyListeners(); // Notify listeners about the state change
    } catch (e) {
      print("Login failed: $e"); // Log the error in case of failure
      _isLoggedIn = false; // Set isLoggedIn to false in case of failure
      notifyListeners(); // Notify listeners about the state change
    }
  }

  // Logout method: Signs the user out and resets the user state
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut(); // Sign out the user
    _user = null; // Reset the user object
    _isLoggedIn = false; // Set isLoggedIn to false
    notifyListeners(); // Notify listeners about the state change
  }
}
