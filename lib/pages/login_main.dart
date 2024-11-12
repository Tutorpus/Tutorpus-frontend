import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tutorpus/theme/colors.dart';

class LoginMain extends StatelessWidget {
  const LoginMain({super.key});

  void _login() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blue3,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SvgPicture.asset('assets/icons/login_main_logo.svg'),
              const SizedBox(height: 50),
              Form(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: loginField('email'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: loginField('password'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              loginButton(),
              loginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Padding loginButton() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _login,
          child: const Text('Login'),
        ),
      ),
    );
  }

  TextFormField loginField(Text) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: (Text),
        filled: true, // 배경색 활성화
        fillColor: Colors.white, // 배경색 설정
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0), // 둥근 모서리 설정
          borderSide: BorderSide(color: Colors.grey.shade300), // 외곽선 색상
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0), // 포커스 시 둥근 모서리 유지
          borderSide: const BorderSide(
              color: Colors.white, width: 2.0), // 포커스 시 외곽선 색상 및 두께
        ),
      ),
    );
  }
}
