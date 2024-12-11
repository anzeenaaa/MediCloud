import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicloud/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:medicloud/features/user_auth/presentation/pages/login_page.dart';
import 'package:medicloud/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpPage extends StatefulWidget {
  final bool isDoctor;

  const SignUpPage({super.key, required this.isDoctor});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  // Controllers for patient fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Controllers for doctor fields
  final TextEditingController _registrationController = TextEditingController();
  final TextEditingController _specializationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _clinicNameController = TextEditingController();

  bool isSigningUp = false;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _registrationController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    _clinicNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.isDoctor ? "Doctor Signup" : "Patient Signup"),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.isDoctor ? "Doctor Signup" : "Patient Signup",
                style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // Dynamic form fields
              if (!widget.isDoctor) ...[
                // Patient fields
                FormContainerWidget(
                  controller: _nameController,
                  hintText: "Name",
                  isPasswordField: false,
                ),
                const SizedBox(height: 10),
                FormContainerWidget(
                  controller: _ageController,
                  hintText: "Age",
                  isPasswordField: false,
                ),
                const SizedBox(height: 10),
                FormContainerWidget(
                  controller: _genderController,
                  hintText: "Gender (Male/Female/Other)",
                  isPasswordField: false,
                ),
                const SizedBox(height: 10),
              ] else ...[
                // Doctor fields
                FormContainerWidget(
                  controller: _nameController,
                  hintText: "Name",
                  isPasswordField: false,
                ),
                const SizedBox(height: 10),
                FormContainerWidget(
                  controller: _registrationController,
                  hintText: "Doctor Registration Number",
                  isPasswordField: false,
                ),
                const SizedBox(height: 10),
                FormContainerWidget(
                  controller: _specializationController,
                  hintText: "Specialization",
                  isPasswordField: false,
                ),
                const SizedBox(height: 10),
                FormContainerWidget(
                  controller: _experienceController,
                  hintText: "Years of Experience",
                  isPasswordField: false,
                ),
                const SizedBox(height: 10),
                FormContainerWidget(
                  controller: _clinicNameController,
                  hintText: "Clinic/Hospital Name",
                  isPasswordField: false,
                ),
                const SizedBox(height: 10),
              ],

              // Common fields
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
              const SizedBox(height: 10),
              FormContainerWidget(
                controller: _phoneController,
                hintText: "Phone Number (Optional)",
                isPasswordField: false,
              ),
              const SizedBox(height: 30),

              // Signup Button
              GestureDetector(
                onTap: _signUp,
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: isSigningUp
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Redirect to login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      "Login",
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

  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      // Register user with email and password
      User? user = await _auth.registerWithEmailAndPassword(email, password);

      if (user != null) {
        if (!mounted) return;

        setState(() {
          isSigningUp = false;
        });

        showToast(message: "User successfully registered");

        // Navigate based on doctor or patient role
        Navigator.pushNamed(
          context,
          widget.isDoctor ? "/doctorHome" : "/patientHome",
        );
      } else {
        // Registration failed
        setState(() {
          isSigningUp = false;
        });
      }
    } catch (e) {
      setState(() {
        isSigningUp = false;
      });
      showToast(message: "Some error occurred: ${e.toString()}");
    }
  }
}

void showToast({required String message}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
