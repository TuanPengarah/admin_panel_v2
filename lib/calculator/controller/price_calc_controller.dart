import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PriceCalculatorController extends GetxController {
  final supplierPriceTitle = TextEditingController();

  int upahPasang = 20;
  int tambahWaranti = 10;
  int markup = 30;

  var jumlah = 20.0.obs;

  var supplierPrice = '0'.obs;
  var tempohWarranti = '1 Minggu'.obs;

  // @override
  // void onInit() {
  //   calculatePrice(
  //       supplierPrice.value == '0' ? 0 : int.parse(supplierPrice.value));
  //   super.onInit();
  // }

  double calculateFromWidget(double hargaSupplier) {
    tambahWaranti = 30;
    tempohWarranti.value = '1 Bulan';
    supplierPrice.value = hargaSupplier.toString();
    supplierPriceTitle.text = hargaSupplier.toString();
    double total =
        upahPasang + tambahWaranti * hargaSupplier / 100 + hargaSupplier;
    if (hargaSupplier < 10) {
      jumlah.value = 20.0;
      return 20.0;
    }

    total = total.round() + markup.toDouble();
    // debugPrint(total);
    total = (total / 10).roundToDouble();
    // debugPrint(total);
    total = total * 10;
    jumlah.value = total;
    return total;
  }

  void calculatePrice(int hargaSupplier) {
    double total =
        upahPasang + tambahWaranti * hargaSupplier / 100 + hargaSupplier;
    if (hargaSupplier < 10) {
      jumlah.value = 20.0;
    } else {
      total = total.round() + markup.toDouble();
      total = (total / 10).roundToDouble();
      total = total * 10;
      jumlah.value = total;
    }
  }

  void calculatePriceFromPayment(int hargaSupplier, int waranti) {
    double total = upahPasang + waranti * hargaSupplier / 100 + hargaSupplier;
    if (hargaSupplier < 10) {
      jumlah.value = 20.0;
    } else {
      total = total.round() + markup.toDouble();
      total = (total / 10).roundToDouble();
      total = total * 10;
      jumlah.value = total;
    }
  }

  void changeWaranti() {
    switch (tempohWarranti.value) {
      case '1 Minggu':
        tambahWaranti = 10;

        break;
      case '1 Bulan':
        tambahWaranti = 30;
        break;
      case '2 Bulan':
        tambahWaranti = 50;
        break;
      case '3 Bulan':
        tambahWaranti = 70;
        break;
      default:
        tambahWaranti = 10;
    }
  }
}
