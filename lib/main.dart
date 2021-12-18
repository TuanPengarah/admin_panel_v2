import 'package:admin_panel/config/initial_binding.dart';
import 'package:admin_panel/config/mouse_drag.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'config/get_route_export.dart';
import 'config/routes.dart';

// flutter run -d web-server --web-port 8080 --web-hostname 192.168.1.17

Future<void> _firebaseMessagingBackground(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool _isLogin = false;
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackground);

  final _user = FirebaseAuth.instance.currentUser;
  if (_user != null) {
    print('user already signed in');
    _isLogin = true;
  } else {
    print('User is currently signed out');
    _isLogin = false;
  }
  await GetStorage.init();
  runApp(MyApp(
    isLogin: _isLogin,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLogin;
  MyApp({this.isLogin});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Af-Fix Admin Panel',
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      themeMode: MyThemes().themeMode,
      initialRoute: isLogin == false ? MyRoutes.login : MyRoutes.home,
      getPages: MyRoutes().page,
    );
  }
}
