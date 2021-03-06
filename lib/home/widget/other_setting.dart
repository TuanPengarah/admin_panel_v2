import 'package:admin_panel/auth/controller/firebaseAuth_controller.dart';
import 'package:admin_panel/config/get_route_export.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/home/controller/other_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtherSettings extends StatelessWidget {
  final _authController = Get.find<AuthController>();
  final _otherController = Get.find<OtherController>();

  Widget logOutButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 45),
      height: 45,
      child: ElevatedButton.icon(
        onPressed: () => _authController.performLogOut(),
        icon: Icon(Icons.logout),
        label: Text('Log Keluar'),
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(8),
          shadowColor: MaterialStateProperty.all<Color>(Get.theme.errorColor),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor:
              MaterialStateProperty.all<Color>(Get.theme.errorColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(45),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            ///OTHERS FUNCTIONS
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 5),
              child: Text(
                'Lain-lain',
                style: TextStyle(
                  fontSize: 18,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => Get.toNamed(MyRoutes.bills),
                child: ListTile(
                  leading: Icon(
                    Icons.point_of_sale,
                    color: Get.theme.colorScheme.secondary,
                  ),
                  title: Text('POS'),
                  subtitle: Text('Point Of Sales'),
                ),
              ),
            ),
            Card(
              color: Get.theme.colorScheme.surfaceVariant,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => Get.toNamed(MyRoutes.technician),
                child: ListTile(
                  leading: Icon(
                    Icons.badge,
                    color: Get.theme.colorScheme.secondary,
                  ),
                  title: Text('Juruteknik'),
                  subtitle: Text('Senerai semua juruteknik di Af-Fix'),
                ),
              ),
            ),
            Card(
              color: Get.theme.colorScheme.surfaceVariant,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => Get.toNamed(MyRoutes.pricelist),
                child: ListTile(
                  leading: Icon(
                    Icons.ballot,
                    color: Get.theme.colorScheme.secondary,
                  ),
                  title: Text('Senarai Harga'),
                  subtitle: Text('Lihat semua senarai harga spareparts'),
                ),
              ),
            ),
            Card(
              color: Get.theme.colorScheme.surfaceVariant,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => Get.toNamed(MyRoutes.priceCalc),
                child: ListTile(
                  leading: Icon(
                    Icons.calculate,
                    color: Get.theme.colorScheme.secondary,
                  ),
                  title: Text('Pengiraan Harga'),
                  subtitle: Text('Alat untuk mengira harga spareparts'),
                ),
              ),
            ),
            Card(
              color: Get.theme.colorScheme.surfaceVariant,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => Get.toNamed(MyRoutes.smsView),
                child: ListTile(
                  leading: Icon(
                    Icons.sms,
                    color: Get.theme.colorScheme.secondary,
                  ),
                  title: Text('SMS Gateway'),
                  subtitle: Text('Hantar SMS kepada pelanggan'),
                ),
              ),
            ),
            SizedBox(height: 30),

            ///SETTINGS

            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 5),
              child: Text(
                'Pengurusan Peranti',
                style: TextStyle(
                  fontSize: 18,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Card(
              color: Get.theme.colorScheme.surfaceVariant,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Get.dialog(
                    AlertDialog(
                      title: Text('Pilih Tema'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.settings_suggest,
                              color: MyThemes().themeMode == ThemeMode.system
                                  ? Colors.amber
                                  : Get.theme.iconTheme.color,
                            ),
                            title: Text(
                              'Sistem',
                              style: TextStyle(
                                fontWeight:
                                    MyThemes().themeMode == ThemeMode.system
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                            onTap: () {
                              Get.back();
                              MyThemes().setSystemMode();
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.emoji_objects,
                              color: MyThemes().themeMode == ThemeMode.light
                                  ? Colors.amber
                                  : Get.theme.iconTheme.color,
                            ),
                            title: Text(
                              'Cerah',
                              style: TextStyle(
                                fontWeight:
                                    MyThemes().themeMode == ThemeMode.light
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                            onTap: () {
                              Get.back();
                              MyThemes().setLightMode();
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.dark_mode,
                              color: MyThemes().themeMode == ThemeMode.dark
                                  ? Colors.amber
                                  : Get.theme.iconTheme.color,
                            ),
                            title: Text(
                              'Gelap',
                              style: TextStyle(
                                fontWeight:
                                    MyThemes().themeMode == ThemeMode.dark
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                            onTap: () {
                              Get.back();
                              MyThemes().setDarkMode();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: ListTile(
                  leading: Icon(
                    Icons.palette,
                    color: Get.theme.colorScheme.secondary,
                  ),
                  title: Text('Tema'),
                  subtitle: Text('Pilih tema untuk aplikasi ini'),
                ),
              ),
            ),
            Card(
              color: Get.theme.colorScheme.surfaceVariant,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => Get.toNamed(MyRoutes.notifSettings),
                child: ListTile(
                  leading: Icon(
                    Icons.notification_important,
                    color: Get.theme.colorScheme.secondary,
                  ),
                  title: Text('Peringatan Media Sosial'),
                  subtitle: Text('Notifikasi untuk membuat siaran'),
                ),
              ),
            ),
            Card(
              color: Get.theme.colorScheme.surfaceVariant,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => Get.toNamed(MyRoutes.notifHistory),
                child: ListTile(
                  leading: Icon(
                    Icons.notifications,
                    color: Get.theme.colorScheme.secondary,
                  ),
                  title: Text('Sejarah Notifikasi'),
                  subtitle: Text('Lihat semua sejarah notifikasi anda'),
                ),
              ),
            ),
            Card(
              color: Get.theme.colorScheme.surfaceVariant,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Get.dialog(AlertDialog(
                    title: Text('Pilih kaedah penyimpanan'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.file_copy),
                          title: Text('Simpan ke peranti anda'),
                          onTap: _otherController.saveDBToDevice,
                        ),
                        ListTile(
                          leading: Icon(Icons.upload),
                          title: Text('Simpan ke Firebase Storage'),
                          onTap: () {
                            Get.back();
                            _otherController.uploadToFirebase();
                          },
                        ),
                      ],
                    ),
                  ));
                },
                child: ListTile(
                  leading: Icon(
                    Icons.upload_file,
                    color: Get.theme.colorScheme.secondary,
                  ),
                  title: Text('Eksport Database'),
                  subtitle: Text('Eksport segala maklumat SQLite'),
                ),
              ),
            ),
            Card(
              color: Get.theme.colorScheme.surfaceVariant,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Get.dialog(
                    AlertDialog(
                      title: Text('Pilih kaedah import'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.file_copy),
                            title: Text('Ambil dari peranti anda'),
                            onTap: _otherController.getFromDevices,
                          ),
                          ListTile(
                            leading: Icon(Icons.download),
                            title: Text('Ambil dari Firebase Storage'),
                            onTap: () {
                              Get.back();
                              _otherController.downloadFromFirebase();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: ListTile(
                  leading: Icon(
                    Icons.sim_card_download_outlined,
                    color: Get.theme.colorScheme.secondary,
                  ),
                  title: Text('Import Database'),
                  subtitle: Text('Import maklumat SQLite'),
                ),
              ),
            ),

            Card(
              color: Get.theme.colorScheme.surfaceVariant,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Get.dialog(AlertDialog(
                    title: Text('Buang Database?'),
                    content: Text(
                        'Segala maklumat SQLite anda akan dibuang. Adakah anda pasti?'),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          Haptic.feedbackError();
                          await _otherController.deletedSQLite();
                        },
                        child: Text('Buang',
                            style: TextStyle(
                              color: Colors.amber[900],
                            )),
                      ),
                      TextButton(
                        onPressed: () {
                          Haptic.feedbackClick();
                          Get.back();
                        },
                        child: Text('Batal'),
                      ),
                    ],
                  ));
                },
                child: ListTile(
                  leading: Icon(
                    Icons.delete,
                    color: Get.theme.colorScheme.secondary,
                  ),
                  title: Text('Buang Database'),
                  subtitle: Text('Buang segala maklumat SQLite'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
