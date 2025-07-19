import 'package:cloud_firestore/cloud_firestore.dart';

// Cria os dados que iram conter no chat da comunidade
class Message {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
  }
);

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] ?? 'sem-id',
      text: map['text'],
      senderId: map['senderId'],
      senderName: map['senderName'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'text' : text,
      'senderId' : senderId,
      'senderName' : senderName,
      'timestamp' : Timestamp.fromDate(timestamp),
    };
  }
}