import 'package:flutter/foundation.dart';

class NotificationsModel {
  final int id;
  final String title;
  final String body;
  final String tarikh;

  NotificationsModel({
    this.id,
    @required this.title,
    @required this.body,
    @required this.tarikh,
  });

  factory NotificationsModel.fromMap(Map<String, dynamic> json) =>
      new NotificationsModel(
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
