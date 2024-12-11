import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:medicloud/features/app/splash_screen/splash_screen.dart';
import 'package:medicloud/features/user_auth/presentation/pages/doctor_home_page.dart';
import 'package:medicloud/features/user_auth/presentation/pages/patient_home_page.dart';
import 'package:medicloud/features/user_auth/presentation/pages/login_page.dart';
import 'package:medicloud/features/user_auth/presentation/pages/sign_up_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCsHDQtI9DItQgSqwy45_y2xG9tDGxuER8",
        appId: "1:540215271818:web:8b22d4aee01acdce862873",
        messagingSenderId: "540215271818",
        projectId: "flutter-firebase-9c136",
        // Your web Firebase config options
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MediCloud',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(
              // Decides whether to show LoginPage or HomePage based on user authentication
              child: LoginPage(),
            ),
        '/login': (context) => const LoginPage(),
        '/signUpPatient': (context) => const SignUpPage(isDoctor: false),
        '/signUpDoctor': (context) => const SignUpPage(isDoctor: true),
        '/patientHome': (context) => PatHomePage(),
        '/doctorHome': (context) => DoctorHomePage(),
      },
    );
  }
}
