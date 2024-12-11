import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicloud/features/user_auth/presentation/pages/sign_up_page.dart'; // No prefix
import 'package:medicloud/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:medicloud/global/common/toast.dart' as toast;  // Prefix for 'toast.dart'

import '../../firebase_auth_implementation/firebase_auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigning = false;
  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isDoctor = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Login"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Toggle for selecting Doctor/Patient
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isDoctor = false;
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: isDoctor ? Colors.grey[300] : Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Patient"),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isDoctor = true;
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: isDoctor ? Colors.blue : Colors.grey[300],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Doctor"),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Email and Password Input
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
              const SizedBox(height: 10),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),
              const SizedBox(height: 30),

              // Sign in button
              GestureDetector(
                onTap: () {
                  _signIn(context); // Pass context explicitly
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: _isSigning
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Sign up navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpPage(isDoctor: isDoctor),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Sign in method using email and password
  void _signIn(BuildContext context) async {
    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      User? user = await _auth.signInWithEmailAndPassword(email, password);

      if (!mounted) return;  // Ensure the widget is still in the tree before updating state

      setState(() {
        _isSigning = false;
      });

      if (user != null) {
        // Show success message and navigate based on the role
        toast.showToast(
          message: "Login successful",  // The actual message to display in the toast
          duration: Duration(seconds: 2),  // Duration for how long the toast will show
        );

        if (mounted) {
          Navigator.pushNamed(
            context,
            isDoctor ? "/doctorHome" : "/patientHome",
          );
        }
      } else {
        // Handle case where login fails
        if (mounted) {
          toast.showToast(
            message: "Login failed", 
            duration: Duration(seconds: 2),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSigning = false;
        });
        toast.showToast(
          message: "Login failed: ${e.toString()}",
          duration: Duration(seconds: 2),
        );
      }
    }
  }
}
