import 'package:get/get_connect.dart';

class NotifFCM extends GetConnect {
  static const _serverKey =
      'AAAAZM5ESDY:APA91bGD3rkZMZpSZPmK_J-egyOV6-esuWFCg3OGMTtt6J3CEOabC4cjxL7z_8dXq97xWPjengeBpCtH7ND0IQgcdZTVK40riNYcsj0aA_ZLMLM3PKt4N9a4wuZRsWPUg4iDkb9nHSBd';

  Future<Response> postData(
    String title,
    String body, {
    bool? isChat,
    String? token,
    String? userToken,
    String? uid,
    String? photoURL,
    String? photoURL1,
    String? name,
  }) {
    return post(
      'https://fcm.googleapis.com/fcm/send',
      {
        'to': token ?? '/topics/adminPanel',
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
          'isChat': isChat ?? false,
          'screen': isChat == null ? null : '/chat',
          'photoURL': isChat == null ? null : photoURL,
          'photoURL1': isChat == null ? null : photoURL1,
          'name': isChat == null ? null : name,
          'uid': isChat == null ? null : uid,
          'userToken': isChat == null ? null : userToken,
          'token': isChat == null ? null : token,
        },
      },
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'key=$_serverKey',
      },
    );
  }
}
