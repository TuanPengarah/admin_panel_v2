import 'package:flutter/foundation.dart';

class ChatModel {
  final String images;
  final String name;
  final String content;
  final String date;
  final int whoChat;

  ChatModel({
    @required this.images,
    @required this.name,
    this.content,
    this.date,
    this.whoChat,
  });

  Map<String, dynamic> toMap() => {
        'images': images,
        'name': name,
        'content': content,
        'date': date,
        'whoChat': whoChat,
      };
}
