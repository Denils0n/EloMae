class ReminderModel {
  final String id;
  final String title;
  final DateTime date;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String? description;

  ReminderModel({
    required this.id,
    required this.title,
    required this.date,
    required this.startDateTime,
    required this.endDateTime,
    this.description,
  });

  Map<String, dynamic> toMap() => {
    'title': title,
    'date': date.toIso8601String(),
    'startDateTime': startDateTime.toIso8601String(),
    'endDateTime': endDateTime.toIso8601String(),
    'description': description,
  };

  factory ReminderModel.fromMap(String id, Map<String, dynamic> map) {
    return ReminderModel(
      id: id, 
      title: map['title'], 
      date: DateTime.parse(map['date']), 
      startDateTime: DateTime.parse(map['startDateTime']), 
      endDateTime: DateTime.parse(map['endDateTime']),
      description: map['description'], 
    );
  }
}