import 'package:flutter/material.dart';

class JobsheetHistoryModel {
  final int id;
  final String name;
  final String noPhone;
  final String email;
  final String model;
  final String password;
  final String kerosakkan;
  final String price;
  final String remarks;
  final String userUID;

  JobsheetHistoryModel({
    this.id,
    @required this.name,
    @required this.noPhone,
    @required this.email,
    @required this.model,
    @required this.password,
    @required this.kerosakkan,
    @required this.price,
    @required this.remarks,
    @required this.userUID,
  });

  factory JobsheetHistoryModel.fromMap(Map<String, dynamic> json) =>
      new JobsheetHistoryModel(
          id: json['id'],
          email: json['email'],
          kerosakkan: json['kerosakkan'],
          name: json['name'],
          noPhone: json['noPhone'],
          password: json['password'],
          price: json['price'],
          remarks: json['remarks'],
          model: json['model'],
          userUID: json['userUID']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'kerosakkan': kerosakkan,
      'name': name,
      'noPhone': noPhone,
      'password': password,
      'price': price,
      'remarks': remarks,
      'model': model,
      'userUID': userUID,
    };
  }
}
