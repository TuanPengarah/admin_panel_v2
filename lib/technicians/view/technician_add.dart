import 'package:admin_panel/technicians/controller/technician_add_controller.dart';
import 'package:admin_panel/technicians/widget/stepper_add_technician.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TechnicianAdd extends StatelessWidget {
  final _controller = Get.put(TechnicianAddController());

  TechnicianAdd({super.key});
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
              child: const Column(
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
                    ? const Color(0xff131313)
                    : Get.theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Obx(() {
                return Stepper(
                  currentStep: _controller.currentSteps.value,
                  onStepContinue: () => _controller.nextStepper(),
                  onStepCancel: () => _controller.backStepper(),
                  onStepTapped: (step) => _controller.currentSteps.value = step,
                  steps: StepperTechnician().step(),
                  controlsBuilder: (context, details) {
                    return Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: details.onStepContinue,
                            child: Text(_controller.currentSteps.value != 5
                                ? 'Seterusnya'
                                : 'Tambah Staff'),
                          ),
                          _controller.currentSteps.value == 0
                              ? Container()
                              : TextButton(
                                  onPressed: details.onStepCancel,
                                  child: const Text('Batal'),
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
