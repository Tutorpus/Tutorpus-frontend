import 'package:flutter/material.dart';

Widget inputField(String hintText,
    {TextEditingController? controller, bool obscureText = false}) {
  return TextField(
    controller: controller, // 컨트롤러 추가
    obscureText: obscureText,
    decoration: InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
