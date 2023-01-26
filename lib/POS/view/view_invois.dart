import 'package:admin_panel/config/routes.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewInvoice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invois'),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(MyRoutes.bills, arguments: {false}),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseDatabase.instance.ref('Invoices').onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator.adaptive(),
                  ],
                ),
              );
            }

            if (snapshot.hasData) {
              var data = snapshot.data.snapshot.value as Map<dynamic, dynamic>;

              List invItem = [];

              data.forEach((key, value) {
                invItem.add({'id': key, ...value});
              });

              invItem.sort(((b, a) {
                return DateTime.fromMicrosecondsSinceEpoch(int.parse(a['id']))
                    .compareTo(DateTime.fromMicrosecondsSinceEpoch(
                        int.parse(b['id'])));
              }));

              return ListView.builder(
                  itemCount: invItem.length,
                  itemBuilder: (context, index) {
                    var docs = invItem[index];
                    List invoisList = docs['InvoiceList'];
                    return _list(invoisList, docs);
                  });
            }
            return Container();
          }),
    );
  }

  ListTile _list(List<dynamic> invoisList, docs) {
    return ListTile(
      title: Text(invoisList[0]['title']),
      subtitle: Text(
        'RM ${invoisList[0]['price']}',
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: docs['isPay'] == true
              ? Colors.green.withOpacity(0.2)
              : Colors.red.withOpacity(0.2),
        ),
        child: Text(
          docs['isPay'] == true ? 'Dibayar' : 'Belum Dibayar',
          style: TextStyle(
            color: docs['isPay'] == true ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onTap: () {
        print(docs['id']);
      },
    );
  }
}
