import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tutorpus/theme/colors.dart';
import 'package:tutorpus/utils/api_client.dart';

void main() => runApp(const CalendarApp());

class CalendarApp extends StatelessWidget {
  const CalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '캘린더 일정',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalendarPage(),
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<Event>> _events = {};
  final Map<int, String> studentNames = {};

  @override
  void initState() {
    super.initState();
    fetchStudents().then((_) {
      fetchSchedule(_focusedDay.year, _focusedDay.month);
    });
    _selectedDay =
        DateTime(_focusedDay.year, _focusedDay.month, _focusedDay.day);
  }

  Future<void> fetchStudents() async {
    const url = 'http://43.201.11.102:8080/student';

    try {
      final response = await ApiClient().get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          studentNames.clear();
          for (final student in data) {
            final studentId = student['connectId'];
            final studentName = student['name'];
            studentNames[studentId] = studentName; // ID로 이름 저장
          }
        });
      } else {
        throw Exception('Failed to fetch students');
      }
    } catch (e) {
      print('Error fetching students: $e');
    }
  }

  Future<void> fetchSchedule(int year, int month) async {
    final url = 'http://43.201.11.102:8080/schedule/$year/$month';

    try {
      final response = await ApiClient().get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          _events.clear();
          for (final key in data.keys) {
            final int studentId = int.parse(key); // key를 학생 ID로 사용
            final studentName =
                studentNames[studentId] ?? 'Unknown Student'; // 이름 매칭

            final color =
                Color(int.parse(data[key]['color'].replaceFirst('#', '0xff')));
            final dates = (data[key]['dates'] as List<dynamic>)
                .map((date) => DateTime.parse(date))
                .toList();

            for (final date in dates) {
              final normalizedDate =
                  DateTime(date.year, date.month, date.day); // 시간 제거
              _events[normalizedDate] ??= [];
              _events[normalizedDate]!.add(
                  Event(studentName, '10:00 ~ 12:00', color)); // 이름으로 이벤트 제목 설정
            }
          }
        });
        print('Fetched schedule: $_events');
      } else {
        throw Exception('Failed to load schedule');
      }
    } catch (e) {
      print('Error fetching schedule: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일정 관리'),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            // 캘린더 위젯
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              selectedDayPredicate: (day) =>
                  isSameDay(_selectedDay, day), // 날짜 선택 여부 확인
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = DateTime(
                      selectedDay.year, selectedDay.month, selectedDay.day);
                  _focusedDay = focusedDay;
                });
              },
              eventLoader: (day) {
                final normalizedDate =
                    DateTime(day.year, day.month, day.day); // 정규화
                return _events[normalizedDate] ?? [];
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  final normalizedDate =
                      DateTime(date.year, date.month, date.day);
                  final eventList = _events[normalizedDate] ?? [];

                  if (eventList.isNotEmpty) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: eventList.map((event) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 1.0),
                          width: 6.0,
                          height: 6.0,
                          decoration: BoxDecoration(
                            color: event.color,
                            shape: BoxShape.circle,
                          ),
                        );
                      }).toList(),
                    );
                  }
                  return null;
                },
              ),
              onPageChanged: (focusedDay) async {
                setState(() {
                  _focusedDay = focusedDay;
                });
                await fetchSchedule(focusedDay.year, focusedDay.month);
              },
              calendarStyle: const CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
              ),
            ),
            const SizedBox(height: 10),

            // 선택된 날짜의 이벤트 리스트
            _buildEventList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList() {
    final normalizedSelectedDay = _selectedDay != null
        ? DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day)
        : DateTime.now(); // 정규화
    final selectedEvents = _events[normalizedSelectedDay] ?? [];
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: lightblue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: selectedEvents.isEmpty
            ? const Center(
                child: Text(
                  '선택된 날짜의 일정이 없습니다.',
                  style: TextStyle(fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: selectedEvents.length,
                itemBuilder: (context, index) {
                  final event = selectedEvents[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: event.color,
                      radius: 8,
                    ),
                    title: Text(
                      event.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(event.time),
                  );
                },
              ),
      ),
    );
  }
}

class Event {
  String title;
  String time;
  final Color color;

  Event(this.title, this.time, this.color);
}
