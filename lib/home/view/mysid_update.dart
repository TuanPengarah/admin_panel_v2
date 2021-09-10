import 'package:admin_panel/home/controller/mysid_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MysidUpdate extends StatelessWidget {
  final _mysidController = Get.put(MysidController());
  final _data = Get.arguments;
  final _params = Get.parameters;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Hero(
        tag: _params['id'],
        child: Scaffold(
          body: NestedScrollView(
            physics: BouncingScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  title: Text('Kemaskini Status'),
                  collapsedHeight: 350,
                  snap: false,
                  pinned: false,
                  floating: true,
                  flexibleSpace: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(() {
                        return CircularPercentIndicator(
                          radius: 200.0,
                          lineWidth: 13.0,
                          animation: true,
                          arcType: ArcType.HALF,
                          arcBackgroundColor: Get.isDarkMode
                              ? Colors.red.shade700
                              : Colors.blue.shade600,
                          percent: _mysidController.progressPercent.value,
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Jumlah status\nkeselurahan",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${_mysidController.percentage.value.toStringAsFixed(0)}%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.white,
                        );
                      }),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ];
            },
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 8,
                child: SafeArea(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
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
                                color: Get.theme.primaryColor,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                            TextSpan(text: ' untuk melihat status Repair Log'),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: null,
            onPressed: () => _mysidController.setMysid(context),
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
