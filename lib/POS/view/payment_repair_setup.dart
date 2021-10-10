import 'package:admin_panel/POS/controller/payment_controller.dart';
import 'package:admin_panel/POS/widget/steps_payment_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentSetup extends StatelessWidget {
  final _controller = Get.find<PaymentController>();

  @override
  Widget build(BuildContext context) {
    final _data = Get.arguments;
    return WillPopScope(
      onWillPop: () => _controller.exitPaymentSetup(),
      child: Scaffold(
        backgroundColor:
            Get.isDarkMode ? Colors.black : Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor:
              Get.isDarkMode ? Colors.black : Theme.of(context).primaryColor,
          elevation: 0,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pembayaran',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _data == null
                          ? 'Sunting dan tambah kaedah pembayaran'
                          : 'Tambah kaedah pembayaran untuk ${_data['model']}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 18),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? Color(0xff131313)
                      : Get.theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Obx(() {
                  return Stepper(
                    currentStep: _controller.currentSteps.value,
                    onStepContinue: () => _controller.nextSteps(),
                    onStepCancel: () => _controller.backSteps(),
                    steps: StepsPayment().stepper(),
                    controlsBuilder: (context, details) {
                      return Container(
                        margin: const EdgeInsets.only(top: 30),
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: details.onStepContinue,
                              child: Text(_controller.currentSteps.value == 4
                                  ? 'Bayar'
                                  : 'Seterusnya'),
                            ),
                            SizedBox(width: 10),
                            _controller.currentSteps.value == 0
                                ? Container()
                                : TextButton(
                                    onPressed: details.onStepCancel,
                                    child: Text('Batal'),
                                  ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
