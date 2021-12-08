import 'package:flutter/foundation.dart';

class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String tarikh;

  NotificationModel({
    this.id,
    @required this.title,
    @required this.body,
    @required this.tarikh,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> json) =>
      new NotificationModel(
        id: json['id'],
        title: json['title'],
        body: json['body'],
        tarikh: json['tarikh'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'body': body,
        'tarikh': tarikh,
      };
}
