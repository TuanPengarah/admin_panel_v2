import 'package:admin_panel/config/theme_data.dart';
import 'package:admin_panel/home/view/home_view.dart';
import 'package:admin_panel/login/view/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'config/root.dart';

// flutter run -d web-server --web-port 8080 --web-hostname 192.168.1.17
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Af-Fix Admin Panel',
      debugShowCheckedModeBanner: false,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      themeMode: MyThemes().themeMode,
      initialRoute: '/root',
      getPages: [
        GetPage(name: '/root', page: () => Root()),
        GetPage(name: '/login', page: () => LoginView()),
        GetPage(name: '/home', page: () => HomeView()),
      ],
    );
  }
}
