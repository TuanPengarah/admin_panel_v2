import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CashFlowModel {
  final String id;
  final String remark;
  final double jumlah;
  final bool isModal;
  final Timestamp timeStamp;

  CashFlowModel(
      {@required this.id,
      @required this.remark,
      @required this.jumlah,
      @required this.isModal,
      @required this.timeStamp});

  factory CashFlowModel.fromJson(
          QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
      new CashFlowModel(
        id: doc.id,
        jumlah: double.parse(doc['jumlah'].toString()),
        isModal: doc['isModal'],
        timeStamp: doc['timeStamp'],
        remark: doc['remark'],
      );

  void toJson() => {
        'remark': remark,
        'jumlah': jumlah,
        'isModal': isModal,
        'timeStamp': timeStamp
      };
}
