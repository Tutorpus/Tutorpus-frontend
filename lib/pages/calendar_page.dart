import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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

  // 일정 데이터 (예시)
  final Map<DateTime, List<Event>> _events = {
    DateTime.utc(2024, 9, 18): [
      Event('김이화', '11:00 ~ 12:30', '수학 수업'),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일정 관리'),
      ),
      body: Column(
        children: [
          // 달력
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) => _events[day] ?? [],
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

          // 선택된 날짜의 일정 목록
          _buildEventList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddScheduleDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  // 일정 리스트 빌더
  Widget _buildEventList() {
    final selectedEvents = _events[_selectedDay] ?? [];

    return Expanded(
      child: ListView.builder(
        itemCount: selectedEvents.length,
        itemBuilder: (context, index) {
          final event = selectedEvents[index];
          return ListTile(
            title: Text(event.title),
            subtitle: Text('${event.time} - ${event.detail}'),
            trailing: PopupMenuButton(
              onSelected: (value) {
                if (value == 'edit') {
                  _showEditScheduleDialog(context, event);
                } else if (value == 'delete') {
                  _deleteSchedule(event);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'edit', child: Text('수정')),
                PopupMenuItem(value: 'delete', child: Text('삭제')),
              ],
            ),
          );
        },
      ),
    );
  }

  // 일정 추가 팝업
  void _showAddScheduleDialog(BuildContext context) {
    final titleController = TextEditingController();
    final timeController = TextEditingController();
    final detailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('수업 추가'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(titleController, '학생 이름'),
              _buildTextField(timeController, '시간 (예: 11:00 ~ 12:30)'),
              _buildTextField(detailController, '세부 내용'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _events[_selectedDay ?? DateTime.now()] ??= [];
                  _events[_selectedDay ?? DateTime.now()]!.add(Event(
                    titleController.text,
                    timeController.text,
                    detailController.text,
                  ));
                });
                Navigator.pop(context);
              },
              child: const Text('저장'),
            ),
          ],
        );
      },
    );
  }

  // 일정 수정 팝업
  void _showEditScheduleDialog(BuildContext context, Event event) {
    final titleController = TextEditingController(text: event.title);
    final timeController = TextEditingController(text: event.time);
    final detailController = TextEditingController(text: event.detail);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('수업 수정'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(titleController, '학생 이름'),
              _buildTextField(timeController, '시간 (예: 11:00 ~ 12:30)'),
              _buildTextField(detailController, '세부 내용'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  event.title = titleController.text;
                  event.time = timeController.text;
                  event.detail = detailController.text;
                });
                Navigator.pop(context);
              },
              child: const Text('수정'),
            ),
          ],
        );
      },
    );
  }

  // 일정 삭제
  void _deleteSchedule(Event event) {
    setState(() {
      _events[_selectedDay]?.remove(event);
    });
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }
}

class Event {
  String title;
  String time;
  String detail;

  Event(this.title, this.time, this.detail);
}
