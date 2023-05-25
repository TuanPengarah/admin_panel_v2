import 'package:cloud_firestore/cloud_firestore.dart';

class CashFlowModel {
  final String id;
  final String remark;
  final double jumlah;
  final bool isModal;
  final bool isSpareparts;
  final bool isJualPhone;
  final Timestamp timeStamp;

  CashFlowModel(
      {required this.id,
      required this.remark,
      required this.jumlah,
      required this.isModal,
      required this.isSpareparts,
      required this.isJualPhone,
      required this.timeStamp});

  factory CashFlowModel.fromJson(
          QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
      CashFlowModel(
        id: doc.id,
        jumlah: double.parse(doc['jumlah'].toString()),
        isModal: doc['isModal'],
        timeStamp: doc['timeStamp'],
        remark: doc['remark'],
        isJualPhone: doc['isJualPhone'],
        isSpareparts: doc['isSpareparts'],
      );

  void toJson() => {
        'remark': remark,
        'jumlah': jumlah,
        'isModal': isModal,
        'timeStamp': timeStamp,
        'isSpareparts': isSpareparts,
        'isJualPhone': isJualPhone,
      };
}
