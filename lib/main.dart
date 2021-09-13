import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/config/theme_data.dart';
import 'package:admin_panel/cust_overview/view/cust_view.dart';
import 'package:admin_panel/home/view/home_view.dart';
import 'package:admin_panel/home/view/mysid_history.dart';
import 'package:admin_panel/home/view/repair_log_view.dart';
import 'package:admin_panel/jobsheet/view/jobsheet_completed.dart';
import 'package:admin_panel/jobsheet/view/jobsheet_history.dart';
import 'package:admin_panel/jobsheet/view/jobsheet_view.dart';
import 'package:admin_panel/login/view/login_view.dart';
import 'package:admin_panel/pdf/view/pdf_view.dart';
import 'package:admin_panel/print/view/print_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'home/view/mysid_update.dart';

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
      initialRoute: isLogin == false ? MyRoutes.login : MyRoutes.home,
      getPages: [
        GetPage(name: MyRoutes.login, page: () => LoginView()),
        GetPage(name: MyRoutes.home, page: () => HomeView()),
        GetPage(
            name: MyRoutes.jobsheet,
            page: () => JobsheetView(),
            fullscreenDialog: true),
        GetPage(name: MyRoutes.jobsheetHistory, page: () => JobsheetHistory()),
        GetPage(name: MyRoutes.overview, page: () => CustomerView()),
        GetPage(name: MyRoutes.jobsheetDone, page: () => JobsheetCompleted()),
        GetPage(name: MyRoutes.pdfviewer, page: () => PdfViewer()),
        GetPage(name: MyRoutes.printviewer, page: () => PrintView()),
        GetPage(name: MyRoutes.mysidUpdate, page: () => MysidUpdate()),
        GetPage(name: MyRoutes.repairLog, page: () => RepairLogView()),
        GetPage(name: MyRoutes.mysidHisory, page: () => MysidHistoryView()),
      ],
    );
  }
}
