import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tutorpus/theme/colors.dart';
import 'package:tutorpus/utils/api_client.dart';
import 'dart:convert';

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

  @override
  void initState() {
    super.initState();
    fetchSchedule(_focusedDay.year, _focusedDay.month);
  }

  Future<void> fetchSchedule(int year, int month) async {
    final url = 'http://43.201.11.102:8080/schedule/$year/$month';

    try {
      final response = await ApiClient().get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Fetched schedule data: $data');

        setState(() {
          _events.clear();
          for (final key in data.keys) {
            final color =
                Color(int.parse(data[key]['color'].replaceFirst('#', '0xff')));
            final dates = (data[key]['dates'] as List<dynamic>)
                .map((date) => DateTime.parse(date))
                .toList();

            for (final date in dates) {
              final normalizedDate =
                  DateTime(date.year, date.month, date.day); // 시간 제거
              _events[normalizedDate] ??= [];
              _events[normalizedDate]!
                  .add(Event('Event $key', '', '', color: color));
            }
          }
        });

        print('Mapped events: $_events');
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
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  final normalizedDate =
                      DateTime(date.year, date.month, date.day); // 시간 제거
                  final eventList = _events[normalizedDate] ?? [];
                  print(
                      'Marker builder called for date: $normalizedDate with events: $eventList');

                  if (eventList.isNotEmpty) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: eventList.map((event) {
                        final eventColor = (event).color;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 1.0),
                          width: 6.0,
                          height: 6.0,
                          decoration: BoxDecoration(
                            color: eventColor,
                            shape: BoxShape.circle,
                          ),
                        );
                      }).toList(),
                    );
                  }
                  return null;
                },
              ),
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
                fetchSchedule(focusedDay.year, focusedDay.month);
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
            _buildEventList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList() {
    final selectedEvents = _events[_selectedDay] ?? [];
    return Expanded(
      child: ListView.builder(
        itemCount: selectedEvents.length,
        itemBuilder: (context, index) {
          final event = selectedEvents[index];
          return ListTile(
            title: Text(event.title),
          );
        },
      ),
    );
  }
}

class Event {
  String title;
  String time;
  String detail;
  Color color;

  Event(this.title, this.time, this.detail, {required this.color});
}
