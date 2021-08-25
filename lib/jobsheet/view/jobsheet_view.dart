import 'package:admin_panel/jobsheet/controller/jobsheet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension Utility on BuildContext {
  void nextEditableTextFocus() {
    do {
      FocusScope.of(this).nextFocus();
    } while (FocusScope.of(this).focusedChild.context.widget is! EditableText);
  }
}

class JobsheetView extends StatelessWidget {
  final _jobsheetController = Get.put(JobsheetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Get.isDarkMode ? Colors.black : Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor:
            Get.isDarkMode ? Colors.black : Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.import_contacts),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.contact_page),
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
                    'Job Sheet',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'MyStatus Identification: 371215',
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
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Obx(
                () => Stepper(
                  physics: BouncingScrollPhysics(),
                  currentStep: _jobsheetController.currentSteps.value,
                  onStepTapped: (index) =>
                      _jobsheetController.currentSteps.value = index,
                  onStepContinue: () => _jobsheetController.nextStep(),
                  onStepCancel: () => _jobsheetController.previousStep(),
                  steps: [
                    Step(
                      isActive: _jobsheetController.currentSteps.value <= 0,
                      content: TextField(
                        autofocus: true,
                        controller: _jobsheetController.namaCust,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        onEditingComplete: () {
                          _jobsheetController.nextStep();
                          context.nextEditableTextFocus();
                        },
                      ),
                      title: Text(
                        'Nama Customer',
                      ),
                    ),
                    Step(
                      isActive: _jobsheetController.currentSteps.value == 1,
                      content: TextField(
                        autofocus: true,
                        controller: _jobsheetController.noPhone,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.phone,
                        onEditingComplete: () {
                          _jobsheetController.nextStep();
                          context.nextEditableTextFocus();
                        },
                      ),
                      title: Text(
                        'Nombor telefon untuk dihubungi',
                      ),
                    ),
                    Step(
                      isActive: _jobsheetController.currentSteps.value == 2,
                      content: TextField(
                        controller: _jobsheetController.email,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        onEditingComplete: () {
                          _jobsheetController.nextStep();
                          context.nextEditableTextFocus();
                        },
                      ),
                      title: Text(
                        'Email *Optional',
                      ),
                    ),
                    Step(
                      isActive: _jobsheetController.currentSteps.value == 3,
                      content: TextField(
                        controller: _jobsheetController.modelPhone,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        onEditingComplete: () {
                          _jobsheetController.nextStep();
                          context.nextEditableTextFocus();
                        },
                      ),
                      title: Text(
                        'Model Smartphone',
                      ),
                    ),
                    Step(
                      isActive: _jobsheetController.currentSteps.value == 4,
                      content: TextField(
                        controller: _jobsheetController.passPhone,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.visiblePassword,
                        onEditingComplete: () {
                          _jobsheetController.nextStep();
                          context.nextEditableTextFocus();
                        },
                      ),
                      title: Text(
                        'Password Smartphone *Optional',
                      ),
                    ),
                    Step(
                      isActive: _jobsheetController.currentSteps.value == 5,
                      content: TextField(
                        controller: _jobsheetController.kerosakkan,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        onEditingComplete: () {
                          _jobsheetController.nextStep();
                          context.nextEditableTextFocus();
                        },
                      ),
                      title: Text(
                        'Kerosakkan',
                      ),
                    ),
                    Step(
                      isActive: _jobsheetController.currentSteps.value == 6,
                      content: TextField(
                        controller: _jobsheetController.harga,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onEditingComplete: () {
                          _jobsheetController.nextStep();
                          context.nextEditableTextFocus();
                        },
                      ),
                      title: Text(
                        'Anggaran Harga',
                      ),
                    ),
                    Step(
                      isActive: _jobsheetController.currentSteps.value == 7,
                      content: TextField(
                        controller: _jobsheetController.remarks,
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.sentences,
                        onEditingComplete: () {
                          _jobsheetController.nextStep();
                          Get.focusScope.unfocus();
                        },
                      ),
                      title: Text(
                        'Remarks',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
