import 'package:admin_panel/API/sqlite.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/home/model/suggestion.dart';
import 'package:admin_panel/jobsheet/controller/jobsheet_controller.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
    return WillPopScope(
      onWillPop: () async => await _jobsheetController.exitJobSheet(),
      child: Scaffold(
        backgroundColor:
            Get.isDarkMode ? Colors.black : Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor:
              Get.isDarkMode ? Colors.black : Theme.of(context).primaryColor,
          elevation: 0,
          actions: [
            kIsWeb
                ? Container()
                : IconButton(
                    onPressed: () => Get.toNamed(MyRoutes.jobsheetHistory),
                    icon: Icon(
                      Icons.history,
                    ),
                  ),
            kIsWeb
                ? Container()
                : IconButton(
                    onPressed: () => _jobsheetController.selectContact(),
                    icon: Icon(Icons.contact_page),
                  ),
            IconButton(
              onPressed: () async {
                await DatabaseHelper.instance.addModelSuggestion(
                    ModelSuggestion(
                        model: _jobsheetController.modelPhone.text));
              },
              icon: Icon(Icons.add),
            )
          ],
        ),
        body: GestureDetector(
          onTap: () => Get.focusScope.unfocus(),
          child: Column(
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
                      Obx(() => Text(
                            'MyStatus Identification: ${_jobsheetController.mySID.value}',
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
                child: GestureDetector(
                  onTap: () => Get.focusScope.unfocus(),
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
                    child: Obx(
                      () => Stepper(
                        physics: BouncingScrollPhysics(),
                        currentStep: _jobsheetController.currentSteps.value,
                        onStepTapped: (index) =>
                            _jobsheetController.stepTap(index),
                        controlsBuilder: (context, details) {
                          return Column(
                            children: [
                              SizedBox(height: 15),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: details.onStepContinue,
                                      child: Text(_jobsheetController
                                                  .currentSteps.value ==
                                              7
                                          ? 'Tambah Jobsheet'
                                          : 'Seterusnya'),
                                    ),
                                  ),
                                  if (_jobsheetController.currentSteps.value !=
                                      0)
                                    Expanded(
                                      child: TextButton(
                                        onPressed: details.onStepCancel,
                                        child: Text('Batal'),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          );
                        },
                        onStepContinue: () => _jobsheetController.nextStep(),
                        onStepCancel: () => _jobsheetController.previousStep(),
                        steps: [
                          Step(
                            state: _jobsheetController.currentSteps.value != 0
                                ? StepState.complete
                                : StepState.indexed,
                            isActive:
                                _jobsheetController.currentSteps.value >= 0,
                            content: TextField(
                              autofocus: true,
                              focusNode: _jobsheetController.focusNamaCust,
                              controller: _jobsheetController.namaCust,
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.words,
                              onSubmitted: (text) =>
                                  _jobsheetController.nextStep(),
                              decoration: InputDecoration(
                                errorText:
                                    _jobsheetController.errNama.value == true
                                        ? 'Sila masukkan nama pelanggan'
                                        : null,
                              ),
                            ),
                            title: Text(
                              'Nama Customer',
                            ),
                          ),
                          Step(
                            state: _jobsheetController.currentSteps.value > 1
                                ? StepState.complete
                                : StepState.indexed,
                            isActive:
                                _jobsheetController.currentSteps.value >= 1,
                            content: TextField(
                              focusNode: _jobsheetController.focusNoPhone,
                              controller: _jobsheetController.noPhone,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.phone,
                              onSubmitted: (text) =>
                                  _jobsheetController.nextStep(),
                              decoration: InputDecoration(
                                errorText: _jobsheetController
                                            .errNoPhone.value ==
                                        true
                                    ? 'Sila masukkan nombor telefon pelanggan'
                                    : null,
                              ),
                            ),
                            title: Text(
                              'Nombor telefon untuk dihubungi',
                            ),
                          ),
                          Step(
                            state: _jobsheetController.currentSteps.value > 2
                                ? StepState.complete
                                : StepState.indexed,
                            isActive:
                                _jobsheetController.currentSteps.value >= 2,
                            content: TextField(
                              focusNode: _jobsheetController.focusEmail,
                              controller: _jobsheetController.email,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              onSubmitted: (text) =>
                                  _jobsheetController.nextStep(),
                            ),
                            title: Text(
                              'Email *Optional',
                            ),
                          ),
                          Step(
                            state: _jobsheetController.currentSteps.value > 3
                                ? StepState.complete
                                : StepState.indexed,
                            isActive:
                                _jobsheetController.currentSteps.value >= 3,
                            content: TypeAheadField(
                              textFieldConfiguration: TextFieldConfiguration(
                                  controller: _jobsheetController.modelPhone,
                                  focusNode:
                                      _jobsheetController.focusModelPhone,
                                  textInputAction: TextInputAction.next,
                                  textCapitalization: TextCapitalization.words,
                                  onSubmitted: (text) =>
                                      _jobsheetController.nextStep(),
                                  decoration: InputDecoration(
                                    errorText:
                                        _jobsheetController.errModel.value ==
                                                true
                                            ? 'Sila masukkan model peranti'
                                            : null,
                                  )),
                              suggestionsCallback: (String pattern) async =>
                                  await DatabaseHelper.instance
                                      .getModelSuggestion(pattern),
                              onSuggestionSelected: (ModelSuggestion data) =>
                                  _jobsheetController.modelPhone.text =
                                      data.model,
                              itemBuilder:
                                  (BuildContext context, ModelSuggestion data) {
                                return ListTile(
                                  title: Text(data.model),
                                );
                              },
                              getImmediateSuggestions: false,
                              hideOnEmpty: true,
                              hideSuggestionsOnKeyboardHide: true,
                            ),
                            // TextField(
                            //                               focusNode: _jobsheetController.focusModelPhone,
                            //                               controller: _jobsheetController.modelPhone,
                            //                               textInputAction: TextInputAction.next,
                            //                               textCapitalization: TextCapitalization.words,
                            //                               onSubmitted: (text) =>
                            //                                   _jobsheetController.nextStep(),
                            //                               decoration: InputDecoration(
                            //                                 errorText:
                            //                                     _jobsheetController.errModel.value == true
                            //                                         ? 'Sila masukkan model peranti'
                            //                                         : null,
                            //                               ),
                            //                             ),

                            title: Text(
                              'Model Smartphone',
                            ),
                          ),
                          Step(
                            state: _jobsheetController.currentSteps.value > 4
                                ? StepState.complete
                                : StepState.indexed,
                            isActive:
                                _jobsheetController.currentSteps.value >= 4,
                            content: TextField(
                              focusNode: _jobsheetController.focusPassPhone,
                              controller: _jobsheetController.passPhone,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.visiblePassword,
                              onSubmitted: (text) =>
                                  _jobsheetController.nextStep(),
                            ),
                            title: Text(
                              'Password Smartphone *Optional',
                            ),
                          ),
                          Step(
                            state: _jobsheetController.currentSteps.value > 5
                                ? StepState.complete
                                : StepState.indexed,
                            isActive:
                                _jobsheetController.currentSteps.value >= 5,
                            content: TextField(
                              focusNode: _jobsheetController.focusKerosakkan,
                              controller: _jobsheetController.kerosakkan,
                              textInputAction: TextInputAction.newline,
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: 3,
                              decoration: InputDecoration(
                                errorText:
                                    _jobsheetController.errKerosakkan.value ==
                                            true
                                        ? 'Sila masukkan jenis kerosakkan'
                                        : null,
                              ),
                            ),
                            title: Text(
                              'Kerosakkan',
                            ),
                          ),
                          Step(
                            state: _jobsheetController.currentSteps.value > 6
                                ? StepState.complete
                                : StepState.indexed,
                            isActive:
                                _jobsheetController.currentSteps.value >= 6,
                            content: TextField(
                              focusNode: _jobsheetController.focusHarga,
                              controller: _jobsheetController.harga,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              onSubmitted: (text) =>
                                  _jobsheetController.nextStep(),
                              decoration: InputDecoration(
                                errorText:
                                    _jobsheetController.errPrice.value == true
                                        ? 'Sila masukkan anggaran harga'
                                        : null,
                              ),
                            ),
                            title: Text(
                              'Anggaran Harga',
                            ),
                          ),
                          Step(
                            state: _jobsheetController.currentSteps.value > 7
                                ? StepState.complete
                                : StepState.indexed,
                            isActive:
                                _jobsheetController.currentSteps.value >= 7,
                            content: TextField(
                                focusNode: _jobsheetController.focusRemarks,
                                controller: _jobsheetController.remarks,
                                textInputAction: TextInputAction.newline,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                maxLines: 5),
                            title: Text(
                              'Remarks',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
