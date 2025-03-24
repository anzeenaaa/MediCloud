
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicloud/features/app/splash_screen/splash_screen.dart';
import 'package:medicloud/features/user_auth/presentation/pages/doctor_home_page.dart';
import 'package:medicloud/features/user_auth/presentation/pages/patient_home_page.dart';
import 'package:medicloud/features/user_auth/presentation/pages/login_page.dart';
import 'package:medicloud/features/user_auth/presentation/pages/sign_up_page.dart';
//import 'package:medicloud/features/user_auth/presentation/pages/report_page.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey:"AIzaSyCsHDQtI9DItQgSqwy45_y2xG9tDGxuER8",
        appId: "1:540215271818:web:8b22d4aee01acdce862873",
        messagingSenderId: "540215271818",
        projectId: "flutter-firebase-9c136",
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
        '/': (context) => SplashScreen(child: AuthChecker()),
        '/login': (context) => const LoginPage(),
        '/signUp': (context) => const SignUpPage(isDoctor: false),
        '/patientHome': (context) =>  PatHomePage(userName: ''),
        '/doctorHome': (context) =>  DoctorHomePage(),
      },
    );
  }
}

class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection("users").doc(snapshot.data!.uid).get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.hasData) {
                String role = userSnapshot.data?["role"] ?? "patient";
                return role == "doctor" ?  DoctorHomePage() :  PatHomePage(userName: '');
              }
              return const LoginPage();
            },
          );
        }
        return const LoginPage();
      },
    );
  }
}