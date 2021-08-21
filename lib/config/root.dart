import 'package:admin_panel/home/view/home_view.dart';
import 'package:admin_panel/login/view/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print('User is sign in');
            return HomeView();
          } else {
            print('User is sign out');
            return LoginView();
          }
        });
  }
}
