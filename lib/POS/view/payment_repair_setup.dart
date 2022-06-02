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
        body: GestureDetector(
          onTap: () => Get.focusScope.unfocus(),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      onPressed: () async {
                        bool exit = await _controller.exitPaymentSetup();
                        if (exit == true) Get.back();
                      },
                      icon: Icon(Icons.arrow_back)),
                ),
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
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _data == null
                              ? 'Sunting dan tambah kaedah pembayaran'
                              : 'Tambah kaedah pembayaran untuk ${_data['model']}',
                        ),
                        SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
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
                                  child: Text(
                                      _controller.currentSteps.value == 4
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
        ),
      ),
    );
  }
}
