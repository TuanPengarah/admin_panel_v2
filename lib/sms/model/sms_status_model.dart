class SMSStatusModel {
  String status;
  String reason;

  SMSStatusModel({required this.status, required this.reason});

  factory SMSStatusModel.get(Map<String, dynamic> json) => SMSStatusModel(
        status: json['status'],
        reason: json['reason'],
      );
}
