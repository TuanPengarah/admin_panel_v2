import 'package:admin_panel/POS/model/payment_model.dart';
import 'package:admin_panel/auth/controller/firebaseAuth_controller.dart';
import 'package:admin_panel/calculator/controller/price_calc_controller.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:admin_panel/graph/graph_controller.dart';
import 'package:admin_panel/home/controller/sparepart_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

import '../../API/notif_fcm.dart';

class PaymentController extends GetxController {
  List bills = [];

  final _authController = Get.find<AuthController>();
  final _priceController = Get.find<PriceCalculatorController>();

  final priceText = TextEditingController();

  var currentSteps = 0.obs;

  var errPriceMiss = false.obs;

  var currentStock = '...'.obs;
  var currentTechnician = ''.obs;
  String currentTechnicianID = '';
  String sparepartsID = '';
  String customerUID = '';
  String tempohWaranti = '';
  String mysid = '';
  var price = 0.obs;
  var selectedWaranti = 'Tiada Waranti'.obs;
  int warantiCost = 30;
  int hargaSpareparts = 0;
  var recommendedPrice = 0.0.obs;

  var totalBillsPrice = 0.0.obs;
  bool isPending = false;

  String customerName = '';
  String phoneNumber = '';

  @override
  void onInit() {
    currentTechnician.value = _authController.userName.value;
    currentTechnicianID = _authController.userUID.value;
    var jiffy9 = Jiffy()..add(duration: Duration(days: 0));
    tempohWaranti = jiffy9.format('dd-MM-yyyy').toString();
    super.onInit();
  }

  void calculatePrice(int harga) {
    hargaSpareparts = harga;
    _priceController.calculatePriceFromPayment(hargaSpareparts, warantiCost);
    print(hargaSpareparts);
    recommendedPrice.value = _priceController.jumlah.value;
  }

  int _commision(int value) {
    if (value <= 20) {
      double total = value / 2;
      return total.round().toInt();
    } else {
      return _priceController.markup;
    }
  }

  void changeWaranti() {
    switch (selectedWaranti.value) {
      case 'Tiada Waranti':
        warantiCost = 0;
        var jiffy9 = Jiffy()..add(duration: Duration(days: 0));
        tempohWaranti = jiffy9.format('dd-MM-yyyy').toString();
        break;
      case '1 Minggu Waranti':
        warantiCost = 10;
        var jiffy9 = Jiffy()..add(duration: Duration(days: 7));
        tempohWaranti = jiffy9.format('dd-MM-yyyy').toString();
        break;
      case '1 Bulan Waranti':
        warantiCost = 30;
        var jiffy9 = Jiffy()..add(duration: Duration(days: 30));
        tempohWaranti = jiffy9.format('dd-MM-yyyy').toString();
        print(tempohWaranti);
        break;
      case '2 Bulan Waranti':
        warantiCost = 50;
        var jiffy9 = Jiffy()..add(duration: Duration(days: 60));
        tempohWaranti = jiffy9.format('dd-MM-yyyy').toString();
        print(tempohWaranti);
        break;
      case '3 Bulan Waranti':
        warantiCost = 70;
        var jiffy9 = Jiffy()..add(duration: Duration(days: 90));
        tempohWaranti = jiffy9.format('dd-MM-yyyy').toString();
        break;
      default:
        warantiCost = 10;
        var jiffy9 = Jiffy()..add(duration: Duration(days: 0));
        tempohWaranti = jiffy9.format('dd-MM-yyyy').toString();
    }
  }

  void addBills() {
    Get.dialog(AlertDialog(
      title: Text('Tambah Resit'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.pending_actions),
            title: Text('Ambil dari Pending Payment'),
            onTap: () {
              Get.back();
              isPending = true;
              Haptic.feedbackClick();
              Get.toNamed(MyRoutes.posview);
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Hasilkan resit baru'),
            onTap: () {
              Get.back();
              isPending = false;
              Haptic.feedbackClick();
              Get.toNamed(MyRoutes.paymentSetup);
            },
          ),
        ],
      ),
    ));
  }

  void nextSteps() {
    if (currentSteps.value == 0) {
      if (currentStock.value != '...') {
        Haptic.feedbackClick();
        currentSteps.value++;
      } else {
        Haptic.feedbackError();
        ShowSnackbar.error('Kesalah telah berlaku',
            'Sila pilih stok spareparts atau servis yang digunakan', false);
      }
    } else if (currentSteps.value == 1) {
      Haptic.feedbackClick();
      currentSteps.value++;
    } else if (currentSteps.value == 2) {
      Haptic.feedbackClick();
      currentSteps.value++;
    } else if (currentSteps.value == 3) {
      if (priceText.text.isEmpty) {
        Haptic.feedbackError();
        errPriceMiss.value = true;
      } else {
        Haptic.feedbackClick();
        errPriceMiss.value = false;
        currentSteps.value++;
      }
    } else if (currentSteps.value == 4) {
      print(mysid);
      paymentConfirmation();
    }
  }

  void paymentConfirmation() async {
    Get.dialog(AlertDialog(
      title: Text('Adakah Anda Pasti?'),
      content:
          Text('Pastikan maklumat pembayaran tersebut adalah benar dan tepat!'),
      actions: [
        TextButton(
          onPressed: () {
            Haptic.feedbackError();
            Get.back();
          },
          child: Text(
            'Batal',
            style: TextStyle(
              color: Colors.amber[900],
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            await addToDatabase();
            bills.add(
              PaymentModel(
                currentStock.value,
                currentTechnician.value,
                selectedWaranti.value,
                int.parse(priceText.text),
                isPending,
              ).toJson(),
            );
            totalBillsPrice.value += int.parse(priceText.text);

            Get.back();
            Get.back();
            if (isPending == true) {
              Get.back();
            }

            reset();
            update();
          },
          child: Text('Pasti'),
        ),
      ],
    ));
  }

  Future<void> addToDatabase() async {
    Haptic.feedbackClick();
    final _graphController = Get.find<GraphController>();
    var title = ''.obs;
    Get.dialog(
      AlertDialog(
        title: Text('Membuat perubahan di database'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.grey),
            SizedBox(height: 10),
            Obx(() {
              return Text(
                title.value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              );
            }),
          ],
        ),
      ),
    );
    try {
      title.value = 'Memulakan perbuahan di database...';
      final firestore = FirebaseFirestore.instance;
      final db = FirebaseDatabase.instance.ref();

      //UPDATE STATUS 'isPayment' PADA MYREPAIR ID

      if (mysid != '') {
        title.value = 'Setkan mysid telah dibayar...';
        await firestore
            .collection('MyrepairID')
            .doc(mysid)
            .update({'isPayment': true});
      }

      //UPDATE STATUS PADA REPAIR HISTORY CUSTOMER
      if (customerUID != '') {
        title.value = 'Update status pada repair history pelanggan...';
        Map<String, dynamic> data = {
          'isWarranty': true,
          'Tarikh Waranti': '$tempohWaranti',
          'Kerosakkan': '${currentStock.value}',
          'Status': 'Selesai',
          'Harga': double.parse(priceText.text),
          'Technician': currentTechnician.value,
        };
        await firestore
            .collection('customer')
            .doc(customerUID)
            .collection('repair history')
            .doc(mysid)
            .update(data);

        //TAMBAH REPAIR POINTS
        title.value = 'Menambah Repair Points...';
        DocumentReference documentReference =
            firestore.collection('customer').doc(customerUID);
        firestore.runTransaction((transaction) async {
          DocumentSnapshot snap = await transaction.get(documentReference);

          if (!snap.exists) {
            throw Exception("User does not exist!");
          }

          int newPoints = snap.get('Points');
          transaction.update(documentReference, {'Points': newPoints + 1});
        });
      }

      //BUANG LIST SPAREPART YANG TELAH PAKAI

      if (sparepartsID != '') {
        title.value = 'Mengambil sparepart yang digunakan...';
        await db.child('Spareparts').child(sparepartsID).remove();
      }

      //TAMBAH JUMLAH REPAIR DAN JUMLAH KEUNTUNGAN TECHNICIAN
      title.value = 'Tambah jumlah repair dan keuntungan technician...';
      Map<String, dynamic> updateTechnician = {
        'jumlahRepair': ServerValue.increment(1),
        'jumlahKeuntungan': ServerValue.increment(
          _commision(int.parse(priceText.text)),
        ),
      };
      await db
          .child('Technician')
          .child(currentTechnicianID)
          .update(updateTechnician);

      //TAMBAH HARGA JUAL PADA GRAPH SALES
      String months = _graphController.checkMonths(DateTime.now().month - 1);
      title.value = 'Menambah harga jual pada graph sales...';
      DocumentReference hargaJual =
          firestore.collection('Sales').doc(_graphController.year);
      firestore.runTransaction((transaction) async {
        DocumentSnapshot snap = await transaction.get(hargaJual);

        if (!snap.exists) {
          throw Exception("Harga jual tidak dijumpai");
        }

        double newPoints = double.parse(snap.get(months).toString());
        transaction.update(
            hargaJual, {months: newPoints + double.parse(priceText.text)});
      });

      //TAMBAH PADA CASH FLOW
      title.value = 'Mengemaskini cash flow...';
      final Map<String, dynamic> cashflow = {
        'jumlah': int.parse(priceText.text),
        'remark': currentStock.value.toString(),
        'isModal': false,
        'isSpareparts': false,
        'isJualPhone': true,
        'timeStamp': FieldValue.serverTimestamp(),
      };

      await firestore
          .collection('Sales')
          .doc(_graphController.year)
          .collection('cashFlow')
          .add(cashflow);
      title.value = 'Menyegarkan semula semua data...';
      final _sparepartsController = Get.find<SparepartController>();
      final _authController = Get.find<AuthController>();
      await _authController.checkUserData(_authController.userEmail.value);
      await _sparepartsController.getSparepartsList();
      await _graphController.getGraphFromFirestore();
      title.value = 'Selesai!';
      await Future.delayed(Duration(seconds: 1));
      NotifFCM()
          .postData(
            'Pembayaran telah selesai!',
            'Juruteknik ${_authController.userName.value} telah membuka resit bayaran dengan berjumlah RM${priceText.text}',
          )
          .then((value) => debugPrint(value.body.toString()));
      Haptic.feedbackSuccess();
      Get.back();
    } on Exception catch (e) {
      debugPrint(e.toString());
      Haptic.feedbackSuccess();
      await Future.delayed(Duration(seconds: 1));
      Get.back();
      ShowSnackbar.error('Kesalahan telah berlaku!', e.toString(), false);
    }
  }

  void reset() {
    currentStock.value = '...';
    currentSteps.value = 0;
    currentTechnician.value = _authController.userName.value;
    currentTechnicianID = _authController.userUID.value;
    sparepartsID = '';
    mysid = '';
    price.value = 0;
    priceText.text = '';
    selectedWaranti.value = 'Tiada Waranti';
    warantiCost = 30;
    hargaSpareparts = 0;
    recommendedPrice.value = 0.0;
  }

  void backSteps() {
    Haptic.feedbackError();
    currentSteps.value = currentSteps.value - 1;
  }

  void chooseTechnician() async {
    var data =
        await Get.toNamed(MyRoutes.technician, arguments: {'isChoose': true});

    if (data == null) return;

    currentTechnician.value = data['nama'];
    currentTechnicianID = data['id'];
  }

  void chooseServices() {
    Get.dialog(AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('Pilih Spareparts / Stock'),
            onTap: () async {
              Haptic.feedbackClick();
              var data = await Get.toNamed(MyRoutes.spareparts,
                  arguments: {'isChoose': true});
              if (data == null) return;
              Get.back();
              currentStock.value = data['model'];
              sparepartsID = data['id'];
              calculatePrice(int.parse(data['harga']));
            },
          ),
          ListTile(
            title: Text('Software'),
            onTap: () {
              Haptic.feedbackClick();
              currentStock.value = 'Software';
              recommendedPrice.value = 50;
              Get.back();
            },
          ),
          ListTile(
            title: Text('Servis Upah Pasang'),
            onTap: () {
              Haptic.feedbackClick();
              currentStock.value = 'Servis Upah Pasang';
              recommendedPrice.value = 60;
              Get.back();
            },
          ),
        ],
      ),
    ));
  }

  void choosePrint() {
    Haptic.feedbackClick();
    final data = {
      'isBills': true,
    };
    Get.toNamed(
      MyRoutes.pdfReceiptViewer,
      arguments: data,
    );
  }

  Future<bool> exitPaymentSetup() async {
    Haptic.feedbackError();
    bool result = false;
    await Get.dialog(
      AlertDialog(
        title: Text('Anda pasti untuk keluar?'),
        content:
            Text('Segala maklumat yang telah anda masukkan akan di padam!'),
        actions: [
          TextButton(
            onPressed: () {
              result = false;
              Get.back();
            },
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              result = true;
              customerName = '';
              phoneNumber = '';
              Get.back();
            },
            child: Text(
              'Keluar',
              style: TextStyle(
                color: Colors.amber[900],
              ),
            ),
          ),
        ],
      ),
    );
    return result;
  }
}
