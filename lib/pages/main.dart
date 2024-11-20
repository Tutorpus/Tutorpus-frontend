import 'package:flutter/material.dart';
import 'package:tutorpus/pages/login_main.dart';
import 'package:tutorpus/pages/signin_mem_select.dart';
import 'package:tutorpus/pages/sample.dart';
import 'package:tutorpus/pages/signup_teacher.dart';
import 'package:tutorpus/pages/home_common.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginMain(),
      //SigninMemSelect(), // 여기만 const 유지
    );
  }
}
