class SMSStatusModel {
  final String? status;
  final String? reason;

  SMSStatusModel({required this.status, required this.reason});

  factory SMSStatusModel.get(Map<String, dynamic> json) => SMSStatusModel(
        status: json['status'].toString(),
        reason: json['reason'].toString(),
      );
}
