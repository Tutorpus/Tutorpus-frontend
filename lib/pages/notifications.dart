import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tutorpus/theme/colors.dart';

class Noti extends StatefulWidget {
  const Noti({super.key});

  @override
  State<Noti> createState() => _NotiState();
}

class _NotiState extends State<Noti> {
  // 알림 데이터를 저장할 리스트
  List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications(); // 알림 데이터 불러오기
  }

  // 알림 데이터 가져오는 함수
  Future<void> _fetchNotifications() async {
    const String url =
        'http://ec2-43-201-11-102.ap-northeast-2.compute.amazonaws.com:8080/notifications';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        setState(() {
          notifications = body
              .map((notification) => NotificationModel.fromJson(notification))
              .toList();
        });
      } else {
        print('Failed to load notifications: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('알림 데이터를 불러오는데 실패했습니다.')),
        );
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('서버 연결 중 에러가 발생했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: notifications.isEmpty
            ? const Center(
                child: Text(
                  '알림이 없습니다!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ) // 알림이 없을 때 메시지 표시
            : SingleChildScrollView(
                child: Column(
                  children: notifications.map((notification) {
                    return NotificationBox(
                      title: notification.title,
                      detail: notification.detail,
                      time: notification.time,
                      type: notification.type,
                    );
                  }).toList(),
                ),
              ),
      ),
    );
  }

  Padding NotificationBox({
    required String title,
    required String detail,
    required String time,
    required String type,
  }) {
    String imagePath;

    // 타입에 따른 이미지 경로 설정
    switch (type) {
      case 'homework':
        imagePath = 'assets/images/homework.png';
        break;
      case 'feedback':
        imagePath = 'assets/images/feedback.png';
        break;
      default:
        imagePath = 'assets/images/calendar.png'; // 기본 이미지
    }

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: lightblue,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    time,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Image.asset(
                      imagePath,
                      width: 30,
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 45.0),
                child: Text(
                  detail,
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 알림 데이터 모델 클래스
class NotificationModel {
  final String title;
  final String detail;
  final String time;
  final String type;

  NotificationModel({
    required this.title,
    required this.detail,
    required this.time,
    required this.type,
  });

  // JSON 데이터를 Dart 객체로 변환
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'],
      detail: json['detail'],
      time: json['time'],
      type: json['type'],
    );
  }
}
