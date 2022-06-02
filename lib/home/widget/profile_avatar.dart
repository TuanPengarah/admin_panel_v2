import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:get/get.dart';

class ProfileAvatar extends StatelessWidget {
  final String name;
  final String photoURL;
  final String email;
  final String jawatan;
  final String cawangan;

  const ProfileAvatar({
    Key key,
    @required this.name,
    @required this.photoURL,
    @required this.email,
    @required this.jawatan,
    @required this.cawangan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AdvancedAvatar(
                    size: 120,
                    name: name,
                    image: ExtendedNetworkImageProvider(photoURL, cache: true),
                    style: TextStyle(
                        fontSize: 50,
                        color: Theme.of(context).colorScheme.onBackground),
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(200),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        '$jawatan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      // Text(
                      //   '$email',
                      // ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: Get.theme.colorScheme.secondary,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '$cawangan',
                            style: TextStyle(
                              color: Get.theme.colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class YourRecord extends StatelessWidget {
  final int jumlahRepair;
  final int jumlahKeuntungan;
  final bool isMy;

  YourRecord({
    Key key,
    @required this.jumlahRepair,
    @required this.jumlahKeuntungan,
    @required this.isMy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
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
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.handyman_outlined,
                            color: Get.theme.colorScheme.secondary,
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
                      color: Get.theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.toll_outlined,
                            color: Get.theme.colorScheme.secondary,
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
      ),
    );
  }
}
