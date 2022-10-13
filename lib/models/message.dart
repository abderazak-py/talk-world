import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final String id;
  final String name;
  final String uid;
  final Timestamp date;
  final bool isImage;

  Message(this.message, this.id, this.name, this.uid, this.date, this.isImage);

  factory Message.fromJson(jsonData){
    return Message(jsonData['message'], jsonData['id'],jsonData['name'],jsonData['uid'],jsonData['date'],jsonData['isImage']);
  }
}