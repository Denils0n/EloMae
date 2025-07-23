import 'package:flutter/material.dart';
import 'package:elomae/app/models/reminder_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderViewmodel extends ChangeNotifier {
  DateTime? selectedDate;
  String? startDateTime;
  String? endDateTime;
  String? description;

  final TextEditingController dateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final List<String> times = List.generate(24 * 60 ~/ 5, (index) {
    final totalMinutes = index * 5;
    final hour = totalMinutes ~/ 60;
    final minute = totalMinutes % 60;
    final formattedHour = hour.toString().padLeft(2, '0');
    final formattedMinute = minute.toString().padLeft(2, '0');

    return '$formattedHour:$formattedMinute';
  });

  void setDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void setStartDateTime(String time) {
    startDateTime = time;
    notifyListeners();
  }

  void setEndDateTime(String time) {
    endDateTime = time;
    notifyListeners();
  }

  void setDescription(String newDescription) {
    description = newDescription;
    notifyListeners();
  }

  Future<void> reminderCreate(
    String title,
    DateTime start,
    DateTime end,
    String description,
  ) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    final reminder = ReminderModel(
      id: '',
      title: title,
      date: selectedDate ?? start,
      startDateTime: start,
      endDateTime: end,
      description: description.trim().isEmpty ? null : description.trim(),
    );

    final data = reminder.toMap();
    data['userId'] = user.uid;

    data.removeWhere((key, value) => value == null);

    await FirebaseFirestore.instance.collection('calendar_reminders').add(data);

    print('Lembrete salvo com sucesso!');
  }

  void updateDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setDate(pickedDate);
      dateController.text = formatDate(pickedDate);
    }
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  DateTime? combineDateAndTime(DateTime? date, String? time) {
    if (date == null || time == null) return null;
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  @override
  void dispose() {
    dateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
