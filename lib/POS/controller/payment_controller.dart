import 'package:admin_panel/API/notif_fcm_event.dart';
import 'package:admin_panel/POS/model/invoice_model.dart';
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
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class PaymentController extends GetxController {
  List bills = [];

  final _authController = Get.find<AuthController>();
  final _priceController = Get.find<PriceCalculatorController>();

  final priceText = TextEditingController();
  final otherServicesText = TextEditingController();

  final focusHarga = FocusNode();

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
  var selectedDibayar = 'Dibayar'.obs;
  int warantiCost = 30;
  int hargaSpareparts = 0;
  var recommendedPrice = 0.0.obs;

  var totalBillsPrice = 0.0.obs;
  bool isPending = false;

  String customerName = '';
  String phoneNumber = '';

  String environment = '';

  @override
  void onInit() {
    super.onInit();
    currentTechnician.value = _authController.userName.value;
    currentTechnicianID = _authController.userUID.value;
    var jiffy9 = Jiffy()..add(duration: Duration(days: 0));
    tempohWaranti = jiffy9.format('dd-MM-yyyy').toString();
    environment = DateTime.now().millisecondsSinceEpoch.toString();
    debugPrint('Environment invoices has been init: $environment');
  }

  @override
  void onReady() {
    super.onReady();
    if (bills.isEmpty) {
      Get.toNamed(MyRoutes.posview);
    }
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
      case '1 Minggu':
        warantiCost = 10;
        var jiffy9 = Jiffy()..add(duration: Duration(days: 7));
        tempohWaranti = jiffy9.format('dd-MM-yyyy').toString();
        break;
      case '1 Bulan':
        warantiCost = 30;
        var jiffy9 = Jiffy()..add(duration: Duration(days: 30));
        tempohWaranti = jiffy9.format('dd-MM-yyyy').toString();
        print(tempohWaranti);
        break;
      case '2 Bulan':
        warantiCost = 50;
        var jiffy9 = Jiffy()..add(duration: Duration(days: 60));
        tempohWaranti = jiffy9.format('dd-MM-yyyy').toString();
        print(tempohWaranti);
        break;
      case '3 Bulan':
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

  void nextSteps() async {
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
      await Future.delayed(Duration(milliseconds: 300));
      focusHarga.requestFocus();
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
      Haptic.feedbackClick();
      currentSteps.value++;
    } else if (currentSteps.value == 5) {
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
      if (selectedDibayar.value == 'Dibayar') {
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
      }

      //TAMBAH HARGA JUAL PADA GRAPH SALES
      if (selectedDibayar.value == 'Dibayar') {
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
      }

      //TAMBAH PADA CASH FLOW
      if (selectedDibayar.value == 'Dibayar') {
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
      }

      //TAMBAH INVOIS DAN PEMBAYARAN PADA CUSTOMER
      title.value = 'Tambah invois dan pembayaran kepada pelanggan...';
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

      List<InvoiceModel> invoisData = [];

      for (int i = 0; i < bills.length; i++) {
        var inv = bills[i];
        InvoiceModel invois = InvoiceModel(
          title: '${inv['title']}',
          price: double.parse(inv['harga'].toString()),
          warranty: inv['waranti'],
        );
        invoisData.add(invois);
      }
      Map<String, dynamic> invoisList = {
        'isPay': selectedDibayar.value == 'Dibayar' ? true : false,
        'technician': currentTechnician.value,
        'InvoiceList': invoisData.map((e) => e.toMap()).toList(),
      };
      if (bills.length == 1) {
        debugPrint('first bills');
        await FirebaseFirestore.instance
            .collection('customer')
            .doc(customerUID)
            .collection('invoice')
            .doc(environment)
            .set(invoisList);
      } else if (bills.length >= 2) {
        debugPrint('NOT first bills');
        await FirebaseFirestore.instance
            .collection('customer')
            .doc(customerUID)
            .collection('invoice')
            .doc(environment)
            .update(invoisList);
      }

      ///TAMBAH INVOIS PADA FIREBASE DATABASE
      // String invId = DateTime.now().millisecondsSinceEpoch.toString();
      Map<String, dynamic> invoisListDatabase = {
        'isPay': selectedDibayar.value == 'Dibayar' ? true : false,
        'technician': currentTechnician.value,
        'InvoiceList': invoisData.map((e) => e.toMap()).toList(),
        'customerUID': customerUID,
      };
      if (bills.length == 1) {
        await FirebaseDatabase.instance
            .ref('Invoices/$environment')
            .set(invoisListDatabase);
      } else {
        FirebaseDatabase.instance
            .ref('Invoices/$environment')
            .update(invoisListDatabase);
      }

      title.value = 'Menyegarkan semula semua data...';
      final _sparepartsController = Get.find<SparepartController>();
      final _authController = Get.find<AuthController>();
      await _authController.checkUserData(_authController.userEmail.value);
      await _sparepartsController.getSparepartsList();
      await _graphController.getGraphFromFirestore();
      title.value = 'Selesai!';
      await Future.delayed(Duration(seconds: 1));
      NotifFCMEvent()
          .postData(
            'Invois telah dibuka!',
            'Juruteknik ${_authController.userName.value} telah membuka invois dengan berjumlah RM${priceText.text}',
            token: _authController.token,
          )
          .then((value) => debugPrint(value.body.toString()));
      Haptic.feedbackSuccess();
      Get.back();
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
    selectedDibayar.value = 'Dibayar';
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
          ListTile(
            title: Text('Lain-lain'),
            onTap: () async {
              Haptic.feedbackClick();
              await Get.dialog(
                AlertDialog(
                  title: Text('Maklumat Servis'),
                  content: TextField(
                    controller: otherServicesText,
                    maxLines: 2,
                    textCapitalization: TextCapitalization.sentences,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Masukkan maklumat jenis stock / servis',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        otherServicesText.text = '';
                        Get.back();
                      },
                      child: Text(
                        'Batal',
                        style: TextStyle(color: Colors.amber.shade900),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (otherServicesText.text.isNotEmpty) {
                          currentStock.value = otherServicesText.text;
                          Get.back();
                        }
                      },
                      child: const Text('Selesai'),
                    ),
                  ],
                ),
              );

              Get.back();
            },
          ),
        ],
      ),
    ));
  }

  void choosePrint() {
    Haptic.feedbackClick();
    final tarikh = DateFormat('dd-MM-yyyy').format(DateTime.now());

    final data = {
      'isBills': true,
      'tarikh': tarikh,
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
              reset();

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
