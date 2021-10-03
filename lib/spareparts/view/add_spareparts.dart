import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/spareparts/controller/add_spareparts_controller.dart';
import 'package:admin_panel/spareparts/widget/stepper_add_sparepart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddSparepart extends StatelessWidget {
  final _controller = Get.put(AddSparepartsController());
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _controller.exitSpareparts(),
      child: Scaffold(
        backgroundColor:
            Get.isDarkMode ? Colors.black : Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor:
              Get.isDarkMode ? Colors.black : Theme.of(context).primaryColor,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                Haptic.feedbackClick();
                Get.toNamed(MyRoutes.sparepartsHistory);
              },
              icon: Icon(
                Icons.history,
              ),
            ),
          ],
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
                      'Spareparts',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    Obx(() => Text(
                          'Parts Identification: ${_controller.partsID}',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )),
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
                child: Obx(() => Stepper(
                      currentStep: _controller.currentSteps.value,
                      onStepContinue: () => _controller.nextStepper(),
                      onStepCancel: _controller.currentSteps.value == 0
                          ? null
                          : () => _controller.backStepper(),
                      steps: AddSparepartStepper().getStepper(),
                      controlsBuilder: (context, details) {
                        return Container(
                          margin: const EdgeInsets.only(top: 50),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: details.onStepContinue,
                                  child: Text(
                                    _controller.currentSteps.value == 7
                                        ? 'Selesai'
                                        : 'Seterusnya',
                                  ),
                                ),
                              ),
                              if (_controller.currentSteps.value != 0)
                                Expanded(
                                  child: TextButton(
                                    onPressed: details.onStepCancel,
                                    child: Text(
                                      'Batal',
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
