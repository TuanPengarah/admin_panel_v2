import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/haptic_feedback.dart';
import '../../config/routes.dart';

class MysidCard extends StatelessWidget {
  const MysidCard({
    Key key,
    @required Map<String, String> params,
    @required dynamic data,
  })  : _params = params,
        _data = data,
        super(key: key);

  final Map<String, String> _params;
  final dynamic _data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 8,
        child: SafeArea(
          child: ListView(
            children: [
              Text(
                'Maklumat Kerosakkan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.date_range),
                title: Text('No MySID'),
                subtitle: Text(_params['id']),
              ),
              ListTile(
                leading: Icon(Icons.phonelink_erase_outlined),
                title: Text('Kerosakkan'),
                subtitle: Text(_data['Kerosakkan']),
              ),
              ListTile(
                leading: Icon(Icons.phone_android_outlined),
                title: Text('Model'),
                subtitle: Text(_data['Model']),
              ),
              ListTile(
                leading: Icon(Icons.pattern),
                title: Text('Password'),
                subtitle: Text(_data['Password']),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Pelanggan'),
                subtitle: Text(_data['Nama']),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('Nombor Telefon'),
                subtitle: Text(_data['No Phone']),
              ),
              ListTile(
                leading: Icon(Icons.text_snippet_outlined),
                title: Text('Catatan'),
                subtitle: Text(_data['Remarks']),
              ),
              SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: 'Sila ',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  children: [
                    TextSpan(
                      text: 'klik sini',
                      style: TextStyle(
                        color: Get.theme.colorScheme.primary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Haptic.feedbackClick();
                          Get.toNamed(MyRoutes.repairLog,
                              parameters: {'id': _params['id']});
                        },
                    ),
                    TextSpan(text: ' untuk melihat status Repair Log'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
