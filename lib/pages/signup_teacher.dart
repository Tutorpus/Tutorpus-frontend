import 'package:flutter/material.dart';

class SignupTch extends StatefulWidget {
  const SignupTch({super.key});

  @override
  State<SignupTch> createState() => _SignupTchState();
}

class _SignupTchState extends State<SignupTch> {
  @override
  Widget build(BuildContext context) {
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
                    height: 100,
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
                ],
              ),
            ),
          )),
    );
  }
}
