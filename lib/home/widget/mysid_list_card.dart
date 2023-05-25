import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MysidUI {
  static Card mySidListCard(QueryDocumentSnapshot<Object?> document,
      BuildContext context, Function() tap) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: tap,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      document['Model'],
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        document['Kerosakkan'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        document.id.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  document['Nama'],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  document['No Phone'],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              LinearPercentIndicator(
                leading: const Icon(Icons.history, color: Colors.grey),
                trailing: const Icon(Icons.done, color: Colors.grey),
                width: MediaQuery.of(context).size.width - 110,
                lineHeight: 3.2,
                percent: document['Percent'],
                backgroundColor: Get.theme.colorScheme.surfaceVariant,
                progressColor: Get.theme.colorScheme.secondary,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'RM ${document['Harga'].toString()}',
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      document['Tarikh'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
