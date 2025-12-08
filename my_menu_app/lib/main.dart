import 'package:flutter/material.dart';
import 'features/home/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyMenu',
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFF9F9F5)),
      home: const HomeScreen(),
    );
  }
}
