import 'package:flutter/material.dart';
import 'package:tutorpus/theme/colors.dart';

class StuList extends StatefulWidget {
  const StuList({super.key});

  @override
  State<StuList> createState() => _StuListState();
}

class _StuListState extends State<StuList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('students'),
        backgroundColor: white,
      ),
      body: Container(
        
      )
    );
  }
}
