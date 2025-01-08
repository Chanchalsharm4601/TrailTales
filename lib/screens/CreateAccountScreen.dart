import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController CreatePasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _isPasswordHidden = true;
  bool _isConfirmedPasswordHidden = true;
  bool _isLoading = false; // Loading state

  // Email validation regex
  final RegExp emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

  // Method for account creation
  Future<void> createAccount() async {
    if (CreatePasswordController.text == confirmPasswordController.text) {
      if (emailController.text.isNotEmpty && emailRegex.hasMatch(emailController.text)) {
        setState(() {
          _isLoading = true;
        });

        try {
          await _auth.createUserWithEmailAndPassword(
            email: emailController.text,
            password: CreatePasswordController.text,
          );
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Account created successfully!")));
        } on FirebaseAuthException catch (e) {
          String errorMessage = e.message ?? 'An unknown error occurred';
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $errorMessage")));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An unexpected error occurred")));
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a valid email address')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Passwords do not match!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Image.asset(
                "asset/background.jpg",
                fit: BoxFit.cover,
                height: screenHeight,
                width: screenWidth,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    screenWidth * 0.1, screenHeight * 0.3, screenWidth * 0.1, screenHeight * 0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      style: TextStyle(color: Colors.white),
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined, color: Colors.white),
                        labelText: "Enter your Email",
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    TextField(
                      style: TextStyle(color: Colors.white),
                      obscureText: _isPasswordHidden,
                      controller: CreatePasswordController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordHidden = !_isPasswordHidden;
                            });
                          },
                        ),
                        labelText: "Enter Password",
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    TextField(
                      style: TextStyle(color: Colors.white),
                      obscureText: _isConfirmedPasswordHidden,
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.password_outlined, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmedPasswordHidden ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmedPasswordHidden = !_isConfirmedPasswordHidden;
                            });
                          },
                        ),
                        labelText: "Confirm Password",
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          side: BorderSide(color: Colors.white, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _isLoading ? null : createAccount, // Disable button when loading
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
