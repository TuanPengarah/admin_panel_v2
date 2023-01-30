import 'package:admin_panel/POS/model/invoice_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewInvoiceDetail extends StatelessWidget {
  final _id = Get.parameters;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maklumat Invois'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: StreamBuilder(
          stream:
              FirebaseDatabase.instance.ref('Invoices/${_id['id']}').onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (snapshot.hasData) {
              var data = snapshot.data.snapshot.value as Map<dynamic, dynamic>;
              var invoice = InvoiceDetailsModel.fromDatabase(data);
              double totalPrice = 0;

              invoice.invoiceList.forEach(
                (total) {
                  totalPrice += double.parse(total['price'].toString());
                },
              );

              return Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: ListView.builder(
                      itemCount: invoice.invoiceList.length,
                      itemBuilder: (BuildContext context, int i) {
                        var list = invoice.invoiceList[i];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(list['title'].toString()),
                            trailing: Text('RM ${list['price']}'),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(9),
                      height: 90,
                      color: !Get.isDarkMode
                          ? Colors.grey.shade300
                          : Colors.grey[850],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(children: [
                            Expanded(
                              flex: 8,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Text('Hasilkan Resit'),
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Jumlah',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    'RM $totalPrice',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                          const SizedBox(height: 5),
                          Text(
                            invoice.ispay == true
                                ? '- Invois Ini Telah Dibayar -'
                                : '- Invois Ini Belum Dibayar Lagi',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return Center(
              child: const Text('An error has accured'),
            );
          }),
    );
  }
}
