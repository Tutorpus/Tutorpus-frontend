import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tutorpus/theme/colors.dart';
import 'package:tutorpus/models/student.dart';
import 'package:tutorpus/utils/api_client.dart';

class SessionDetail extends StatefulWidget {
  final DateTime sessionDate;
  final List<Map<String, dynamic>> homeworkList;
  final List<Map<String, dynamic>> feedbackList;
  final Student student; // 전달받은 Student 객체

  const SessionDetail({
    super.key,
    required this.sessionDate,
    required this.homeworkList,
    required this.feedbackList,
    required this.student,
  });

  @override
  State<SessionDetail> createState() => _SessionDetailState();
}

class _SessionDetailState extends State<SessionDetail> {
  bool _isHomeworkSelected = true; // 현재 "숙제 LIST" 또는 "수업 피드백" 중 선택된 탭
  late Future<Map<String, dynamic>> feedbackFuture;
  Future<List<Map<String, dynamic>>>? homeworkFuture;

  @override
  void initState() {
    super.initState();

    // Fetch feedback data
    feedbackFuture = fetchFeedback(
      widget.student.connectId,
      widget.sessionDate,
      widget.feedbackList.isNotEmpty
          ? widget.feedbackList.first['startTime']
          : '09:00:00',
    );

    // Fetch homework data
    homeworkFuture = fetchHomeworkList(
      widget.student.connectId,
      widget.sessionDate,
    );
  }

  // 피드백 데이터를 가져오는 함수
  Future<Map<String, dynamic>> fetchFeedback(
      int connectId, DateTime date, String startTime) async {
    final url =
        'http://43.201.11.102:8080/feedback/$connectId/${DateFormat('yyyy-MM-dd').format(date)}/$startTime';
    print('Fetching feedback from: $url'); // URL 로그 추가
    final client = ApiClient();

    try {
      final response = await client.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        return data;
      } else {
        throw Exception('Failed to fetch feedback');
      }
    } catch (e) {
      print('Error in fetchFeedback: $e');
      throw Exception('Error fetching feedback: $e');
    }
  }

  // 숙제 데이터를 가져오는 함수
  Future<List<Map<String, dynamic>>> fetchHomeworkList(
      int connectId, DateTime date) async {
    final url =
        'http://localhost:8080/homework/$connectId/${DateFormat('yyyy-MM-dd').format(date)}';
    print('Fetching homework from: $url'); // URL 로그 추가
    final client = ApiClient();

    try {
      final response = await client.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data =
            jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to fetch homework');
      }
    } catch (e) {
      print('Error in fetchHomeworkList: $e');
      throw Exception('Error fetching homework list: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          DateFormat('MM월 dd일 정규수업').format(widget.sessionDate),
          style: const TextStyle(color: blue),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [
              Colors.blue,
              Color.fromRGBO(200, 224, 250, 1),
              Colors.white,
            ],
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
                        widget.student.name,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.student.school,
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
            // 탭 버튼
            _buildTabButtons(),
            const SizedBox(height: 10),
            // 숙제 리스트 또는 수업 피드백 내용
            Expanded(
              child: _isHomeworkSelected
                  ? _buildHomeworkList()
                  : _buildFeedbackList(),
            ),
          ],
        ),
      ),
    );
  }

  // 탭 버튼
  Widget _buildTabButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isHomeworkSelected = true;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: _isHomeworkSelected ? Colors.blue : Colors.grey[200],
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Text(
              '숙제 LIST',
              style: TextStyle(
                color: _isHomeworkSelected ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            setState(() {
              _isHomeworkSelected = false;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: !_isHomeworkSelected ? Colors.blue : Colors.grey[200],
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Text(
              '수업 피드백',
              style: TextStyle(
                color: !_isHomeworkSelected ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 숙제 리스트
  Widget _buildHomeworkList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: homeworkFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return const Center(child: Text('숙제 데이터를 불러오지 못했습니다.'));
        } else if (snapshot.hasData) {
          final homeworkList = snapshot.data!;
          if (homeworkList.isEmpty) {
            return const Center(
              child: Text(
                '숙제가 없습니다.',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            );
          }

          return ListView.builder(
            itemCount: homeworkList.length,
            itemBuilder: (context, index) {
              final homework = homeworkList[index];
              final dueDate = DateFormat('MM/dd HH:mm').format(
                DateTime.parse(homework['dueDate']),
              );
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: Colors.lightBlue[50],
                child: ListTile(
                  title: Text(
                    homework['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(homework['content']),
                  trailing: Text(
                    '~$dueDate',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('숙제 데이터가 없습니다.'));
        }
      },
    );
  }

  // 수업 피드백 리스트
  Widget _buildFeedbackList() {
    return FutureBuilder<Map<String, dynamic>>(
      future: feedbackFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return const Center(child: Text('피드백 데이터를 불러오지 못했습니다.'));
        } else if (snapshot.hasData) {
          final feedback = snapshot.data!;
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: Colors.lightBlue[50],
            child: ListTile(
              title: const Text(
                '수업 피드백',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '참여도: ${feedback['participate']} (${feedback['participateScore']}점)\n'
                '적용도: ${feedback['apply']} (${feedback['applyScore']}점)\n'
                '숙제 수행: ${feedback['homework']} (${feedback['homeworkScore']}점)',
              ),
            ),
          );
        } else {
          return const Center(child: Text('수업 피드백이 없습니다.'));
        }
      },
    );
  }
}
