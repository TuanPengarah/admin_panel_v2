import 'package:admin_panel/config/initial_binding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'config/get_route_export.dart';
import 'config/routes.dart';

// flutter run -d web-server --web-port 8080 --web-hostname 192.168.1.17
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool _isLogin = false;
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await Firebase.initializeApp();
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
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      themeMode: MyThemes().themeMode,
      initialRoute: isLogin == false ? MyRoutes.login : MyRoutes.home,
      getPages: [
        GetPage(name: MyRoutes.login, page: () => LoginView()),
        GetPage(name: MyRoutes.home, page: () => HomeView()),
        GetPage(name: MyRoutes.jobsheet, page: () => JobsheetView()),
        GetPage(name: MyRoutes.jobsheetHistory, page: () => JobsheetHistory()),
        GetPage(name: MyRoutes.overview, page: () => CustomerView()),
        GetPage(name: MyRoutes.jobsheetDone, page: () => JobsheetCompleted()),
        GetPage(name: MyRoutes.pdfviewer, page: () => PdfViewer()),
        GetPage(name: MyRoutes.printviewer, page: () => PrintView()),
        GetPage(name: MyRoutes.mysidUpdate, page: () => MysidUpdate()),
        GetPage(name: MyRoutes.repairLog, page: () => RepairLogView()),
        GetPage(name: MyRoutes.mysidHisory, page: () => MysidHistoryView()),
        GetPage(name: MyRoutes.spareparts, page: () => AllSparepartsView()),
        GetPage(name: MyRoutes.sparepartsDetails, page: () => DetailsSpareparts()),
        GetPage(name: MyRoutes.sparepartsAdd, page: () => AddSparepart()),
        GetPage(name: MyRoutes.sparepartsHistory, page: () => HistorySparepartsView()),
        GetPage(name: MyRoutes.priceCalc, page: () => PriceCalculatorView()),
        GetPage(name: MyRoutes.technician, page: () => TechnicianView()),
        GetPage(name: MyRoutes.technicianAdd, page: () => TechnicianAdd()),
        GetPage(name: MyRoutes.technicianDetails, page: () => TechnicianInfo()),
      ],
    );
  }
}
