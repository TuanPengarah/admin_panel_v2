import 'package:admin_panel/config/theme_data.dart';
import 'package:admin_panel/cust_overview/view/view/cust_view.dart';
import 'package:admin_panel/home/view/home_view.dart';
import 'package:admin_panel/jobsheet/view/jobsheet_history.dart';
import 'package:admin_panel/jobsheet/view/jobsheet_view.dart';
import 'package:admin_panel/login/view/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// flutter run -d web-server --web-port 8080 --web-hostname 192.168.1.17
Future<void> main() async {
  bool _isLogin = false;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.authStateChanges().listen((User user) {
    if (user == null) {
      print('User is currently signed out!');
      _isLogin = false;
    } else {
      print('user already signed in!');
      _isLogin = true;
    }
  });
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
      debugShowCheckedModeBanner: false,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      themeMode: MyThemes().themeMode,
      initialRoute: isLogin == false ? '/login' : '/home',
      getPages: [
        GetPage(name: '/login', page: () => LoginView()),
        GetPage(name: '/home', page: () => HomeView()),
        GetPage(
            name: '/jobsheet',
            page: () => JobsheetView(),
            fullscreenDialog: true),
        GetPage(name: '/jobsheet-history', page: () => JobsheetHistory()),
        GetPage(name: '/overview', page: () => CustomerView()),
      ],
    );
  }
}
