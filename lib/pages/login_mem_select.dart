import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tutorpus/theme/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tutorpus/utils/oval_button.dart';

class LoginMemSelcect extends StatelessWidget {
  const LoginMemSelcect({super.key});

  void statStu() {}
  void statTch() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity, // 가로로 화면 전체를 채움
            height: double.infinity, // 세로로 화면 전체를 채움
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.lightBlueAccent,
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 50,
                    ),
                    OvalButton(
                        text: 'students',
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        onPressed: statStu),
                    OvalButton(
                        text: 'Teachers',
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        onPressed: statStu)
                  ],
                ),
              ),
            )));
  }
}
