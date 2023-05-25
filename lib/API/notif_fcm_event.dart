import 'package:get/get_connect.dart';

class NotifFCMEvent extends GetConnect {
  static const _serverKey =
      'AAAAZM5ESDY:APA91bGD3rkZMZpSZPmK_J-egyOV6-esuWFCg3OGMTtt6J3CEOabC4cjxL7z_8dXq97xWPjengeBpCtH7ND0IQgcdZTVK40riNYcsj0aA_ZLMLM3PKt4N9a4wuZRsWPUg4iDkb9nHSBd';

  Future<Response> postData(
    String title,
    String body, {
    String? token,
  }) {
    return post(
      'https://fcm.googleapis.com/fcm/send',
      {
        'to': '/topics/adminPanel',
        // 'token': token,
        "mutable_content": true,
        "content_available": true,
        "priority": "high",
        'notification': {
          'title': title,
          'body': body,
          "android_channel_id": 'fcm', // For Android >= 8
          "channel_id": 'fcm', // For Android Version < 8
        },
        'data': {
          'token': token,
        },
      },
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'key=$_serverKey',
      },
    );
  }
}
