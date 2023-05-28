import 'package:admin_panel/auth/controller/firebase_auth_controller.dart';
import 'package:admin_panel/notification/controller/notification_controller.dart';
import 'package:admin_panel/graph/graph_controller.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => GraphController(), fenix: true);
    Get.lazyPut(() => NotificationController(), fenix: true);
  }
}
