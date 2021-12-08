import 'dart:math';

import 'package:get/get_connect.dart';

class NotifFCM extends GetConnect {
  static const _serverKey =
      'AAAAZM5ESDY:APA91bGD3rkZMZpSZPmK_J-egyOV6-esuWFCg3OGMTtt6J3CEOabC4cjxL7z_8dXq97xWPjengeBpCtH7ND0IQgcdZTVK40riNYcsj0aA_ZLMLM3PKt4N9a4wuZRsWPUg4iDkb9nHSBd';
  int _id = Random().nextInt(999);

  Future<Response> postData(String title, String body,
      {bool isChat, String token}) {
    print(isChat);
    return post(
      'https://fcm.googleapis.com/fcm/send',
      {
        'to': token == null ? '/topics/adminPanel' : token,
        'token': token,
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
          'content': {
            'id': _id,
            'channelKey': 'fcm',
            'title': title,
            'body': body,
            'notificationLayout': 'BigText',
            "android_channel_id": 'fcm', // For Android >= 8
            "channel_id": 'fcm', // For Android Version < 8
          },
          'isChat': isChat == null ? false : isChat,
          'screen': isChat == null ? null : '/cash-flow',
        },
      },
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'key=$_serverKey',
      },
    );
  }
}
