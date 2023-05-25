import 'package:admin_panel/notification/model/notification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NotificationController extends GetxController {
  var groupValue = false.obs;
  final box = GetStorage();

  @override
  onInit() {
    getValue();
    super.onInit();
  }

  Future<void> deleteAllNotification(List<NotificationsModel> history) async {
    // history.forEach((element) async {
    //   // await DatabaseHelper.instance.deleteNotification(element.id);
    //   print(element.id);
    // });
    update();
  }

  Future<void> subscribedToFCM(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  Future<void> unsubscribedFromFCM(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  Future<void> getValue() async {
    if (!GetPlatform.isWeb) {
      groupValue.value = box.read<bool>('initNotif') ?? false;
    }
  }
}
