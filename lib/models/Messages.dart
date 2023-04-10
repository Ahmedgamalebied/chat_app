import 'package:chat_app/constant/constant.dart';
import 'package:flutter/material.dart';

class Message {
  final String message;
  final String id;
  Message(this.message, this.id);

  factory Message.fromjson(jsonData) {
    return Message(jsonData[KeyMessage], jsonData['id']);
  }
}
