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

  void toJson() => {
        'remark': remark,
        'jumlah': jumlah,
        'isModal': isModal,
        'timeStamp': timeStamp
      };
}
