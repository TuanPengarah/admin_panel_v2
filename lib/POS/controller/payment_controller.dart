import 'package:admin_panel/POS/model/payment_model.dart';
import 'package:admin_panel/auth/controller/firebaseAuth_controller.dart';
import 'package:admin_panel/calculator/controller/price_calc_controller.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/config/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  List bills = [];

  final _authController = Get.find<AuthController>();
  final _priceController = Get.put(PriceCalculatorController());

  final priceText = TextEditingController();

  var currentSteps = 0.obs;

  var errPriceMiss = false.obs;

  var currentStock = '...'.obs;
  var currentTechnician = ''.obs;
  String currentTechnicianID = '';
  var price = 0.obs;
  var selectedWaranti = '1 Bulan'.obs;
  int warantiCost = 30;
  int hargaSpareparts = 0;
  var recommendedPrice = 0.0.obs;

  @override
  void onInit() {
    currentTechnician.value = _authController.userName.value;
    currentTechnicianID = _authController.userUID.value;
    super.onInit();
  }

  void calculatePrice(int harga) {
    hargaSpareparts = harga;
    _priceController.calculatePriceFromPayment(hargaSpareparts, warantiCost);
    print(hargaSpareparts);
    recommendedPrice.value = _priceController.jumlah.value;
  }

  void changeWaranti() {
    switch (selectedWaranti.value) {
      case 'Tiada Waranti':
        warantiCost = 0;
        break;
      case '1 Minggu':
        warantiCost = 10;

        break;
      case '1 Bulan':
        warantiCost = 30;
        break;
      case '2 Bulan':
        warantiCost = 50;
        break;
      case '3 Bulan':
        warantiCost = 70;
        break;
      default:
        warantiCost = 10;
    }
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
          onPressed: () {
            bills.add(
              PaymentModel(
                currentStock.value,
                currentTechnician.value,
                selectedWaranti.value,
                int.parse(priceText.text),
              ).toJson(),
            );

            print(bills);
            Get.back();
            Get.offNamed(MyRoutes.bills);
          },
          child: Text('Pasti'),
        ),
      ],
    ));
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
}
