import 'package:admin_panel/config/color_scheme.dart';
import 'package:admin_panel/config/initial_binding.dart';
import 'package:admin_panel/config/mouse_drag.dart';
import 'package:admin_panel/price_list/model/price_list_api.dart';
import 'package:dynamic_color/dynamic_color.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  bool isLogin = false;
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackground);

  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    debugPrint('user already signed in');
    isLogin = true;
  } else {
    debugPrint('User is currently signed out');
    isLogin = false;
  }

  await PriceListApi.init();
  runApp(MyApp(
    isLogin: isLogin,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLogin;
  const MyApp({super.key, required this.isLogin});
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme colorSchemeLight;
        ColorScheme colorSchemeDark;
        if (darkDynamic != null) {
          colorSchemeLight = lightDynamic!.harmonized();
          colorSchemeDark = darkDynamic.harmonized();
        } else {
          colorSchemeLight = lightColorScheme;
          colorSchemeDark = darkColorScheme;
        }
        return GetMaterialApp(
          title: 'Af-Fix Admin Panel',
          scrollBehavior: MyCustomScrollBehavior(),
          debugShowCheckedModeBanner: false,
          initialBinding: InitialBinding(),
          theme: MyThemes().light(colorSchemeLight),
          darkTheme: MyThemes().dark(colorSchemeDark),
          themeMode: MyThemes().themeMode,
          initialRoute: isLogin == false ? MyRoutes.login : MyRoutes.home,
          getPages: MyRoutes().page,
        );
      },
    );
  }
}
