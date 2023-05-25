import 'package:get/get_connect.dart';

class SMSApi extends GetConnect {
  static const _url = 'https://sms.ala.my/api/v1/send';
  static const _uid = '321547608';
  static const _key = 'oj67r20spidn3ugl915z';
  static const _merchant = 'Af-Fix Smartphone Repair';
  Future<Response> sendSMS(String noPhone, String message) {
    return post(
      _url,
      {
        'token_uid': _uid,
        'token_key': _key,
        'receipients': noPhone,
        'message': '$_merchant: $message',
      },
    );
  }
}
