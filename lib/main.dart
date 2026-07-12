import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart'; 

import 'screen/welcome_screen.dart'; 
import 'screen/splash_screen.dart'; // Import SplashScreen vào đây

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const NikeCloneApp());
}

class NikeCloneApp extends StatelessWidget {
  const NikeCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'Nike Clone',
      theme: ThemeData(
        fontFamily: 'Helvetica', 
        scaffoldBackgroundColor: Colors.black, 
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Colors.black,
              body: Center(child: CircularProgressIndicator(color: Colors.white)),
            );
          }
          
          // ĐÃ ĐĂNG NHẬP: Cho người dùng xem SplashScreen 3 giây rồi vào Home
          if (snapshot.hasData) {
            return const SplashScreen();
          }
          
          // CHƯA ĐĂNG NHẬP: Vào thẳng WelcomeScreen
          return const WelcomeScreen();
        },
      ), 
    );
  }
}