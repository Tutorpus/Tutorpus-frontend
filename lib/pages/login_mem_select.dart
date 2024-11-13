import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tutorpus/theme/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginMemSelcect extends StatelessWidget {
  const LoginMemSelcect({super.key});

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
            child: const SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                    )
              ,
              
                  ],
                ),
              ),
            )));
  }
}
