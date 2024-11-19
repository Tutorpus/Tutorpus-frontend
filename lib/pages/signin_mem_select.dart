import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:tutorpus/pages/signup_stu.dart';
import 'package:tutorpus/pages/signup_teacher.dart';
import 'dart:convert';
import 'package:tutorpus/utils/oval_button.dart';
import 'package:tutorpus/theme/colors.dart';
import 'package:flutter/material.dart';

bool _isChecked = false;

class SigninMemSelect extends StatefulWidget {
  const SigninMemSelect({super.key});
  @override
  _SigninMemSelectState createState() => _SigninMemSelectState();
}

class _SigninMemSelectState extends State<SigninMemSelect> {
  @override
  Widget build(BuildContext context) {
    signupStu() {}

    return Scaffold(
        appBar: AppBar(
          title: const Text(' '),
        ),
        body: Container(
            width: double.infinity, // 가로로 화면 전체를 채움
            height: double.infinity, // 세로로 화면 전체를 채움
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.blue,
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
                      height: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          Image.asset('assets/icons/octo_only_icon.png'),
                          const Text(
                            '반갑습니다!',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w600),
                          ),
                          const Text('어떤 회원으로 가입하시겠어요?',
                              style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                    OvalButton(
                        text: 'students',
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        onPressed: signupStu),
                    OvalButton(
                        text: 'Teachers',
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupTch()));
                        }),
                    Row(
                      children: [
                        const SizedBox(height: 30),
                        Checkbox(
                          fillColor: const WidgetStatePropertyAll(Colors.blue),
                          value: _isChecked,
                          onChanged: (bool? isChecked) {
                            setState(() {
                              _isChecked = isChecked ?? false; // null safety 처리
                            });
                          },
                        ),
                        const Text(
                          '이용 약관에 동의하십니까?',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )));
  }
}
