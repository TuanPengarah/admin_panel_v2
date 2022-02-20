import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:get/get.dart';

class ProfileAvatar {
  Container profile({
    @required BuildContext context,
    @required String name,
    @required String photoURL,
    @required String email,
    @required String jawatan,
  }) {
    return Container(
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AdvancedAvatar(
              size: 120,
              name: name,
              image: ExtendedNetworkImageProvider(photoURL, cache: true),
              style: TextStyle(fontSize: 50),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(200),
              ),
            ),
            SizedBox(height: 20),
            Text(
              '$name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '$jawatan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '$email',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding yourRecord(
      BuildContext context, int jumlahRepair, int jumlahKeuntungan, bool isMy) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 5),
            child: Text(
              isMy == true ? 'Rekod Anda' : 'Rekod Juruteknik',
              style: TextStyle(
                fontSize: 18,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade900
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.handyman_outlined,
                          color: Theme.of(context).primaryColor,
                          size: 40,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Jumlah Repair',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Get.isDarkMode
                                ? Colors.grey.shade300
                                : Colors.grey.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '$jumlahRepair',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Get.isDarkMode
                                ? Colors.grey.shade300
                                : Colors.grey.shade700,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade900
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.toll_outlined,
                          color: Theme.of(context).primaryColor,
                          size: 40,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Jumlah Komisen',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Get.isDarkMode
                                ? Colors.grey.shade300
                                : Colors.grey.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'RM$jumlahKeuntungan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Get.isDarkMode
                                ? Colors.grey.shade300
                                : Colors.grey.shade700,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
