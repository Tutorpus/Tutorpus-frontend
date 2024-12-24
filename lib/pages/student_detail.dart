import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tutorpus/theme/colors.dart';
import 'package:tutorpus/utils/api_client.dart';
import 'package:tutorpus/models/student.dart';
import 'session_detail.dart'; // SessionDetail import

class Session {
  final DateTime date;
  final String day;
  final String startTime;
  final String endTime;

  Session({
    required this.date,
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  String getFormattedDate() {
    return "${date.month}월 ${date.day}일";
  }

  String getFormattedTime(String time) {
    final parts = time.split(":");
    return "${parts[0]}:${parts[1]}"; // 시:분만 반환
  }
}

class StudentDetail extends StatefulWidget {
  final Student student; // 전달받은 Student 객체

  const StudentDetail({super.key, required this.student});

  @override
  _StudentDetailState createState() => _StudentDetailState();
}

class _StudentDetailState extends State<StudentDetail> {
  late Future<List<Session>> sessionList;
  DateTime selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    sessionList = fetchSessions(
        widget.student.connectId, selectedMonth.year, selectedMonth.month);
  }

  Future<List<Session>> fetchSessions(
      int studentId, int year, int month) async {
    final url =
        'http://43.201.11.102:8080/schedule/student/$studentId/$year/$month';
    final client = ApiClient();

    try {
      final response = await client.get(url);
      if (response.statusCode == 200) {
        print('학생 수업 정보를 불러옵니다.');
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data.entries.map((entry) {
          final date = DateTime.parse(entry.key);
          final sessionData = entry.value as Map<String, dynamic>;
          return Session(
            date: date,
            day: sessionData['day'],
            startTime: sessionData['startTime'],
            endTime: sessionData['endTime'],
          );
        }).toList();
      } else {
        throw Exception('Failed to fetch sessions');
      }
    } catch (e) {
      throw Exception('Error fetching sessions: $e');
    }
  }

  void changeMonth(int offset) {
    setState(() {
      selectedMonth =
          DateTime(selectedMonth.year, selectedMonth.month + offset);
      sessionList = fetchSessions(
          widget.student.connectId, selectedMonth.year, selectedMonth.month);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('학생 상세 정보'),
        backgroundColor: Colors.blue,
        elevation: 0.0,
      ),
      body: FutureBuilder<List<Session>>(
        future: sessionList,
        builder: (context, sessionSnapshot) {
          if (sessionSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (sessionSnapshot.hasError) {
            return const Center(child: Text('수업 정보를 불러오는 중 오류가 발생했습니다.'));
          } else if (sessionSnapshot.hasData) {
            final sessions = sessionSnapshot.data!;
            return buildStudentDetail(sessions);
          } else {
            return const Center(child: Text('수업 데이터를 불러오지 못했습니다.'));
          }
        },
      ),
    );
  }

  Widget buildStudentDetail(List<Session> sessions) {
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
          // 상단 학생 정보
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
                      widget.student.name, // 전달받은 학생 이름 사용
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      widget.student.school, // 전달받은 학생 학교 사용
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // 월 변경 버튼
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_left),
                          onPressed: () => changeMonth(-1),
                        ),
                        Text(
                          '${selectedMonth.year}년 ${selectedMonth.month}월',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_right),
                          onPressed: () => changeMonth(1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // 세션 리스트
                  Expanded(
                    child: sessions.isEmpty
                        ? const Center(child: Text('이번 달 수업이 없습니다.'))
                        : ListView.builder(
                            itemCount: sessions.length,
                            itemBuilder: (context, index) {
                              final session = sessions[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SessionDetail(
                                        sessionDate: session.date, // 세션 날짜 전달
                                        homeworkList: const [
                                          // 여기에 API에서 받은 숙제 데이터를 넣습니다.
                                        ],
                                        feedbackList: const [
                                          // 여기에 API에서 받은 피드백 데이터를 넣습니다.
                                        ],
                                        student:
                                            widget.student, // Student 객체 전달
                                      ),
                                    ),
                                  );
                                },
                                child: sessionBox(
                                  session.getFormattedDate(),
                                  session.day,
                                  session.getFormattedTime(session.startTime),
                                  session.getFormattedTime(session.endTime),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding sessionBox(
      String date, String day, String startTime, String endTime) {
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
              day,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
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
