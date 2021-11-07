import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MyThemes {
  final _box = GetStorage();
  final _key = 'isDarkMode';
  final _key1 = 'isSystemMode';

  /// Get isDarkMode info from local storage and return ThemeMode
  ThemeMode get themeMode => _loadThemeFromBox()
      ? ThemeMode.dark
      : _loadSystemTheme()
          ? ThemeMode.system
          : ThemeMode.light;

  /// Load isDArkMode from local storage and if it's empty, returns false (that means default theme is light)
  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  bool _loadSystemTheme() => _box.read(_key1) ?? false;

  /// Save isDarkMode to local storage
  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);
  _saveThemeSystem(bool isSystem) => _box.write(_key1, isSystem);

  /// Switch theme and save to local storage
  void switchTheme() {
    Haptic.feedbackClick();
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }

  void setDarkMode() {
    Haptic.feedbackClick();
    Get.changeThemeMode(ThemeMode.dark);
    _saveThemeToBox(true);
    _saveThemeSystem(false);
  }

  void setLightMode() {
    Haptic.feedbackClick();
    Get.changeThemeMode(ThemeMode.light);
    _saveThemeToBox(false);
    _saveThemeSystem(false);
  }

  void setSystemMode() {
    Haptic.feedbackClick();
    Get.changeThemeMode(ThemeMode.system);
    _saveThemeToBox(false);
    _saveThemeSystem(true);
  }

  //Theme Config
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    primaryColor: Colors.blue,
    // appBarTheme: AppBarTheme(
    //   systemOverlayStyle: SystemUiOverlayStyle.dark,
    // ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade200,
      contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(width: 0, color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(width: 0, color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(
          color: Colors.blue,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(
          color: Colors.amber.shade900,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(
          color: Colors.amber.shade900,
          width: 2,
        ),
      ),
      errorStyle: TextStyle(
        color: Colors.amber.shade900,
        fontWeight: FontWeight.bold,
      ),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    primarySwatch: Colors.blueGrey,
    primaryColor: Colors.blueGrey,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blueGrey,
    ),
    canvasColor: Color(0xff131313),
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: Color(0xff131313)),
    cardTheme: CardTheme(
      color: Colors.grey.shade900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade900,
      contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(width: 0, color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(width: 0, color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(
          color: Colors.blueGrey,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(
          color: Colors.amber.shade900,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(
          color: Colors.amber.shade900,
          width: 2,
        ),
      ),
      errorStyle: TextStyle(
        color: Colors.amber.shade900,
        fontWeight: FontWeight.bold,
      ),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
