import 'package:admin_panel/config/snackbar.dart';
import 'package:flutter/material.dart';

class MySidPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MyStatus ID',
        ),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              ShowSnackbar.success('Hi', 'Nak test je', false);
            },
            child: Text('Test1'),
          ),
          ElevatedButton(
            onPressed: () {
              ShowSnackbar.error('Kesalahan telah berlaku!',
                  'Nampaknya Akaun anda sudah melebihi RM100K', false);
            },
            child: Text('Test2'),
          ),
          ElevatedButton(
            onPressed: () {
              ShowSnackbar.notify('Tuan telah menerima 1 pesanan',
                  'Sila periksa di ruangan pesanan sekarang!');
            },
            child: Text('Test3'),
          ),
        ],
      ),
    );
  }
}
