import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'CreateAccountScreen.dart';
import 'Home.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordHidden = true;
  bool _isLoading = false;

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
                      style: const TextStyle(color: Colors.white),
                      controller: emailController,
                      decoration: const InputDecoration(
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
                      style: const TextStyle(color: Colors.white),
                      obscureText: _isPasswordHidden,
                      controller: passwordController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
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
                        labelStyle: const TextStyle(color: Colors.white),
                        border: const OutlineInputBorder(
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
                          side: const BorderSide(color: Colors.white, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          String email = emailController.text.trim();
                          String password = passwordController.text.trim();

                          if (email.isEmpty || password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please fill in all fields")),
                            );
                            return;
                          }
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            UserCredential userCredential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(email: email, password: password);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Sign In successful!")),
                            );

                            // Navigate to the Home Screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LibraryHomeScreen(),
                              ),
                            );
                          } on FirebaseAuthException catch (e) {
                            String errorMessage;
                            if (e.code == 'user-not-found') {
                              errorMessage = "No user found for this email";
                            } else if (e.code == 'wrong-password') {
                              errorMessage = "Incorrect Password";
                            } else {
                              errorMessage = "Sign In failed. Try again later";
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(errorMessage)),
                            );
                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateAccount(),
                                ),
                              );
                            });
                          },
                          child: const Text(
                            "Create Account",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        const Text("|",
                            style: TextStyle(color: Colors.white, fontSize: 16)),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forget Password",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
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
