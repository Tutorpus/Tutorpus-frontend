class Student {
  final int connectId;
  final String name;
  final String school;
  final String subject;
  final String color;

  Student({
    required this.connectId,
    required this.name,
    required this.school,
    required this.subject,
    required this.color,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      connectId: json['connectId'],
      name: json['name'],
      school: json['school'],
      subject: json['subject'],
      color: json['color'],
    );
  }
}
