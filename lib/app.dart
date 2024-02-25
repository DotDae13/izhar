import 'package:flutter/material.dart';
import 'auth/auth.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        //visualDensity: VisualDensity.standard,
      ),

      home: const AuthPage(),
      //home: const ChatbotIntegration(),
    );
  }
}