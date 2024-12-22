import 'package:flutter/material.dart';
import 'package:tutorpus/theme/colors.dart';

// 학생 클래스
class Student {
  final int id;
  final String name;
  final String school;
  final String subject;

  Student({
    required this.id,
    required this.name,
    required this.school,
    required this.subject,
  });
}

// 세션 클래스
class Session {
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  Session({
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  String getDayOfWeek() {
    List<String> days = ['월', '화', '수', '목', '금', '토', '일'];
    return days[date.weekday - 1];
  }

  String getFormattedDate() {
    return "${date.month}월 ${date.day}일";
  }

  String formatTime(TimeOfDay time) {
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }
}

class StudentDetail extends StatefulWidget {
  final int studentId;

  const StudentDetail({super.key, required this.studentId});

  @override
  _StudentDetailState createState() => _StudentDetailState();
}

class _StudentDetailState extends State<StudentDetail> {
  late Future<Student> student;

  @override
  void initState() {
    super.initState();
    student = fetchStudent(widget.studentId);
  }

  Future<Student> fetchStudent(int id) async {
    await Future.delayed(const Duration(seconds: 2));
    return Student(id: id, name: '복지희', school: '초4', subject: '수학');
  }

  final List<Session> sessionList = [
    Session(
      date: DateTime(2024, 9, 12),
      startTime: const TimeOfDay(hour: 15, minute: 0),
      endTime: const TimeOfDay(hour: 17, minute: 30),
    ),
    Session(
      date: DateTime(2024, 9, 19),
      startTime: const TimeOfDay(hour: 14, minute: 0),
      endTime: const TimeOfDay(hour: 16, minute: 0),
    ),
    Session(
      date: DateTime(2024, 9, 26),
      startTime: const TimeOfDay(hour: 13, minute: 0),
      endTime: const TimeOfDay(hour: 15, minute: 30),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('학생 상세 정보'),
        backgroundColor: Colors.blue,
        elevation: 0.0,
      ),
      body: FutureBuilder<Student>(
        future: student,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('오류가 발생했습니다.'));
          } else if (snapshot.hasData) {
            final studentData = snapshot.data!;
            return buildStudentDetail(studentData);
          } else {
            return const Center(child: Text('학생 데이터를 불러오지 못했습니다.'));
          }
        },
      ),
    );
  }

  Widget buildStudentDetail(Student student) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [Colors.blue, Color.fromRGBO(200, 224, 250, 1), Colors.white],
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/homework.png',
                  width: 60,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.assignment, size: 60);
                  },
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: const TextStyle(
                          fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${student.school} || ${student.subject}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: white,
              ),
              padding: const EdgeInsets.all(20),
              child: ListView.builder(
                itemCount: sessionList.length,
                itemBuilder: (context, index) {
                  final session = sessionList[index];
                  return sessionBox(
                    session.getFormattedDate(),
                    session.formatTime(session.startTime),
                    session.formatTime(session.endTime),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding sessionBox(String date, String startTime, String endTime) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: lightblue,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$startTime ~ $endTime',
              style: const TextStyle(fontSize: 18, color: darkestblue),
            ),
            const SizedBox(height: 10),
            Text(
              date,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
