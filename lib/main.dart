import 'package:admin_panel/config/initial_binding.dart';
import 'package:admin_panel/config/mouse_drag.dart';
import 'package:admin_panel/price_list/model/price_list_api.dart';
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
  debugPrint("Handling a background message: ${message.messageId}");
}

const firebaseOptions = FirebaseOptions(
  appId: '1:432957311030:ios:28ff4cd8805045fa5a3097',
  apiKey: 'AIzaSyDBfiwrlxhEsYX9Ng6WVRr13G2nUHtWmy0',
  projectId: 'af-fix-database',
  messagingSenderId: '432957311030',
  authDomain: 'af-fix-database.firebaseapp.com',
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (GetPlatform.isMacOS) {
    await Firebase.initializeApp(options: firebaseOptions);
  } else {
    await Firebase.initializeApp();
    await GetStorage.init();
  }
  bool _isLogin = false;
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackground);

  final _user = FirebaseAuth.instance.currentUser;
  if (_user != null) {
    debugPrint('user already signed in');
    _isLogin = true;
  } else {
    debugPrint('User is currently signed out');
    _isLogin = false;
  }

  await PriceListApi.init();
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
