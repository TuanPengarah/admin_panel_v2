import 'package:admin_panel/auth/controller/firebaseAuth_controller.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtherSettings {
  final _authController = Get.find<AuthController>();

  Padding otherAndSetting(BuildContext context) {
    return Padding(
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
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Get.toNamed(MyRoutes.bills),
              child: ListTile(
                leading: Icon(
                  Icons.point_of_sale,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text('POS'),
                subtitle: Text('Point Of Sales'),
              ),
            ),
          ),
          Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Get.toNamed(MyRoutes.technician),
              child: ListTile(
                leading: Icon(
                  Icons.badge,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text('Juruteknik'),
                subtitle: Text('Senerai semua juruteknik di Af-Fix'),
              ),
            ),
          ),
          Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {},
              child: ListTile(
                leading: Icon(
                  Icons.ballot,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text('Senarai Harga'),
                subtitle: Text('Lihat semua senarai harga spareparts'),
              ),
            ),
          ),
          Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Get.toNamed(MyRoutes.priceCalc),
              child: ListTile(
                leading: Icon(
                  Icons.calculate,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text('Pengiraan Harga'),
                subtitle: Text('Alat untuk mengira harga spareparts'),
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
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {},
              child: ListTile(
                leading: Icon(
                  Icons.upload_file,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text('Simpan Database'),
                subtitle: Text('Simpan segala maklumat SQLite'),
              ),
            ),
          ),
          Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {},
              child: ListTile(
                leading: Icon(
                  Icons.sim_card_download_outlined,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text('Muat Turun Database'),
                subtitle: Text('Muat turun maklumat SQLite'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container logOutButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      height: 45,
      child: ElevatedButton.icon(
        onPressed: () => _authController.performLogOut(),
        icon: Icon(Icons.logout),
        label: Text('Log Keluar'),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(45),
            ),
          ),
        ),
      ),
    );
  }
}
