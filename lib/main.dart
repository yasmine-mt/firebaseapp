import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseapp/firebase_auth/auth_screen.dart';
import 'package:flutter/material.dart';

import 'firebase_auth/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyC-iUeJkt60C8sq7aRCLRZV5WkQfS_ETlM',
      appId: '1:502615247314:android:aa8812e4c01d0a1400600b',
      messagingSenderId: '502615247314',
      projectId: 'fir-app-606e8',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

