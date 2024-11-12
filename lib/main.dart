import 'package:flutter/material.dart';
import 'package:tutorpus/pages/login_main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginMain(), // 여기만 const 유지
    );
  }
}
