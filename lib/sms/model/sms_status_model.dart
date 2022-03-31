class SMSStatusModel {
  String status;
  String reason;

  SMSStatusModel({this.status, this.reason});

  factory SMSStatusModel.get(Map<String, dynamic> json) => new SMSStatusModel(
        status: json['status'],
        reason: json['reason'],
      );
}
