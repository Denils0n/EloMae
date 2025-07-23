import 'package:elomae/app/models/reminder_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderService {
  final _firestore = FirebaseFirestore.instance;

  Future<void> createReminder(ReminderModel model, String userId) async {
    final data = model.toMap();
    data['userId'] = userId;
    await _firestore.collection('calendar_reminders').add(data);
  }
}