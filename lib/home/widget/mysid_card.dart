import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/haptic_feedback.dart';
import '../../config/routes.dart';

class MysidCard extends StatelessWidget {
  const MysidCard({super.key, 
    required Map<String, String> params,
    required dynamic data,
  })  : _params = params,
        _data = data;

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
              const Text(
                'Maklumat Kerosakkan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.date_range),
                title: const Text('No MySID'),
                subtitle: Text(_params['id'].toString()),
              ),
              ListTile(
                leading: const Icon(Icons.phonelink_erase_outlined),
                title: const Text('Kerosakkan'),
                subtitle: Text(_data['Kerosakkan']),
              ),
              ListTile(
                leading: const Icon(Icons.phone_android_outlined),
                title: const Text('Model'),
                subtitle: Text(_data['Model']),
              ),
              ListTile(
                leading: const Icon(Icons.pattern),
                title: const Text('Password'),
                subtitle: Text(_data['Password']),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Pelanggan'),
                subtitle: Text(_data['Nama']),
              ),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Nombor Telefon'),
                subtitle: Text(_data['No Phone']),
              ),
              ListTile(
                leading: const Icon(Icons.text_snippet_outlined),
                title: const Text('Catatan'),
                subtitle: Text(_data['Remarks']),
              ),
              const SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: 'Sila ',
                  style: const TextStyle(
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
                              parameters: {'id': _params['id'].toString()});
                        },
                    ),
                    const TextSpan(text: ' untuk melihat status Repair Log'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
