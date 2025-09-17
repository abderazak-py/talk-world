import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final String id;
  final String name;
  final String uid;
  final Timestamp date;
  final String type;
  final String? profilePhoto;

  Message(this.message, this.id, this.name, this.uid, this.date, this.type, 
      this.profilePhoto);

  factory Message.fromJson(jsonData) {
    return Message(
      jsonData['message'],
      jsonData['id'],
      jsonData['name'],
      jsonData['uid'],
      jsonData['date'],
      jsonData['type'],
      jsonData['profilePhoto'],
    );
  }
}
