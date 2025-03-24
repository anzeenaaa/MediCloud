import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.isDoctor});

  final bool isDoctor; // Store whether user is a doctor or patient

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool isSigningUp = false;
  String selectedRole = "patient"; // Default role is patient

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Signup"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // ✅ Go back to login page
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: "Phone Number"),
            ),

            // Role selection dropdown
            DropdownButton<String>(
              value: selectedRole,
              onChanged: (String? newValue) {
                setState(() {
                  selectedRole = newValue!;
                });
              },
              items: <String>["patient", "doctor"]
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.toUpperCase()),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 20),

            // Sign Up Button
            ElevatedButton(
              onPressed: _signUp,
              child: isSigningUp
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Sign Up"),
            ),
            
            const SizedBox(height: 10),
            // Navigate back to Login Button
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context, 
                  "/login", 
                  (route) => false, // Remove all previous routes
                );
              },
              child: const Text("Back to Login"),
            ),
          ],
        ),
      ),
    );
  }

  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        Map<String, dynamic> userData = {
          "uid": user.uid,
          "name": _nameController.text.trim(),
          "email": _emailController.text.trim(),
          "phone": _phoneController.text.trim(),
          "role": selectedRole,
        };

        // Store data in Firestore
        if (selectedRole == "doctor") {
          await _firestore.collection("doctors").doc(user.uid).set(userData);
        } else {
          userData.addAll({"uniqueId": null, "age": null, "gender": null});
          await _firestore.collection("patients").doc(user.uid).set(userData);
        }

        showToast("Signup successful! Redirecting to login...");

        // ✅ Navigate back to login page
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "/login",
            (route) => false, // Remove all previous routes
          );
        }
      }
    } catch (e) {
      showToast("Signup failed: \${e.toString()}");
    }

    setState(() {
      isSigningUp = false;
    });
  }
}

void showToast(String message) {
  Fluttertoast.showToast(msg: message, backgroundColor: Colors.black);
}
