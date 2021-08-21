import 'package:admin_panel/API/firebaseAuth_controller.dart';
import 'package:admin_panel/config/remove_glow_effect.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardPage extends StatelessWidget {
  final _authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _authController.performLogOut();
            },
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Container(
                      height: 350,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(120),
                            bottomRight: Radius.circular(120)),
                      ),
                    ),
                    Positioned(
                      top: 200,
                      right: 20,
                      child: Card(
                        elevation: 10,
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          height: 350,
                          width: MediaQuery.of(context).size.width - 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text('hello')
            ],
          ),
        ),
      ),
    );
  }
}
