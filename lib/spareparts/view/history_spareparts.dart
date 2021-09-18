import 'package:admin_panel/API/sqlite.dart';
import 'package:admin_panel/spareparts/model/sparepart_model.dart';
import 'package:flutter/material.dart';

class HistorySparepartsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sejarah Spareparts'),
      ),
      body: Center(
        child: FutureBuilder(
          future: DatabaseHelper.instance.getSparepartsHistory(),
          builder: (BuildContext context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: InkWell(
                    onTap: () {
                      DatabaseHelper.instance.deleteSparepartsHistory(1);
                    },
                    child: Text('Memuatkan data...')),
              );
            }
            if (snapshot.data.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 120,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Tiada sejarah penambahan Spareparts ditemui!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              );
            }
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) {
                  Spareparts history = snapshot.data[i];
                  return ListTile(
                    title: Text(history.model),
                    subtitle: Text(history.jenisSpareparts),
                  );
                });
          },
        ),
      ),
    );
  }
}
