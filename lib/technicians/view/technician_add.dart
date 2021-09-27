import 'package:admin_panel/technicians/controller/technician_add_controller.dart';
import 'package:admin_panel/technicians/widget/stepper_add_technician.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TechnicianAdd extends StatelessWidget {
  final _controller = Get.put(TechnicianAddController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    'Tambah Staff',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Tambah staff atau juruteknik Af-Fix',
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
                  onStepContinue: () => _controller.nextStepper(),
                  onStepCancel: () => _controller.backStepper(),
                  steps: StepperTechnician().step(),
                  controlsBuilder: (context, {onStepContinue, onStepCancel}) {
                    return Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: onStepContinue,
                              child: Text(_controller.currentSteps.value != 5
                                  ? 'Seterusnya'
                                  : 'Tambah Staff'),
                            ),
                          ),
                          _controller.currentSteps.value == 0
                              ? Container()
                              : Expanded(
                                  child: TextButton(
                                    onPressed: onStepCancel,
                                    child: Text('Batal'),
                                  ),
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
    );
  }
}
