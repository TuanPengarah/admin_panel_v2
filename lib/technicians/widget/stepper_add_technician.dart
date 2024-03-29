import 'package:admin_panel/config/management.dart';
import 'package:admin_panel/technicians/controller/technician_add_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:get/get.dart';

class StepperTechnician {
  final _controller = Get.find<TechnicianAddController>();

  List<Step> step() => [
        Step(
          state: _controller.currentSteps.value != 0
              ? StepState.complete
              : StepState.indexed,
          isActive: _controller.currentSteps.value >= 0,
          title: const Text('Nama Staff'),
          content: TextField(
            controller: _controller.namaStaff,
            autofocus: true,
            focusNode: _controller.staffFocus,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            onEditingComplete: () => _controller.nextStepper(),
            decoration: InputDecoration(
              errorText: _controller.errStaff.value == true
                  ? 'Sila masukkan nama staff anda!'
                  : null,
            ),
          ),
        ),
        Step(
          state: _controller.currentSteps.value > 1
              ? StepState.complete
              : StepState.indexed,
          isActive: _controller.currentSteps.value >= 1,
          title: const Text('Jawatan'),
          content: Container(
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? Colors.grey.shade900
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10)),
            child: DropdownButton(
              icon: Container(),
              underline: const SizedBox(),
              items: Management.jawatan.map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(
                    value.toString(),
                  ),
                );
              }).toList(),
              value: _controller.selectedJawatan.value,
              onChanged: (String? newValue) {
                _controller.selectedJawatan.value = newValue.toString();
              },
            ),
          ),
        ),
        Step(
          state: _controller.currentSteps.value > 2
              ? StepState.complete
              : StepState.indexed,
          isActive: _controller.currentSteps.value >= 2,
          title: const Text('Cawangan'),
          content: Container(
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? Colors.grey.shade900
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10)),
            child: DropdownButton(
              icon: Container(),
              underline: const SizedBox(),
              items: Management.cawangan.map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(
                    value.toString(),
                  ),
                );
              }).toList(),
              value: _controller.selectedCawangan.value,
              onChanged: (String? newValue) {
                _controller.selectedCawangan.value = newValue.toString();
              },
            ),
          ),
        ),
        Step(
          state: _controller.currentSteps.value > 3
              ? StepState.complete
              : StepState.indexed,
          isActive: _controller.currentSteps.value >= 3,
          title: const Text('Email'),
          content: TextField(
            controller: _controller.emailStaff,
            focusNode: _controller.emailFocus,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => _controller.nextStepper(),
            decoration: InputDecoration(
              errorText: _controller.errEmail.value == true
                  ? 'Sila masukkan email staff!'
                  : null,
            ),
          ),
        ),
        Step(
          state: _controller.currentSteps.value > 4
              ? StepState.complete
              : StepState.indexed,
          isActive: _controller.currentSteps.value >= 4,
          title: const Text('Gambar Profile'),
          content: Center(
            child: GetBuilder<TechnicianAddController>(
              assignId: true,
              builder: (logic) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AdvancedAvatar(
                      name: _controller.namaStaff.text == ''
                          ? 'Xde Nama'
                          : _controller.namaStaff.text,
                      size: 120,
                      style: const TextStyle(fontSize: 50),
                      image: _controller.imageFile.path.isNotEmpty
                          ? FileImage(_controller.imageFile)
                          : null,
                    ),
                    const SizedBox(height: 10),
                    _controller.imageFile.path.isNotEmpty
                        ? TextButton(
                            onPressed: () => _controller.choosePictureDialog(),
                            child: const Text('Pilih Gambar'),
                          )
                        : TextButton(
                            onPressed: () => _controller.removePicture(),
                            child: Text('Buang Gambar',
                                style: TextStyle(color: Colors.amber[900])),
                          ),
                  ],
                );
              },
            ),
          ),
        ),
        Step(
          state: _controller.currentSteps.value > 5
              ? StepState.complete
              : StepState.indexed,
          isActive: _controller.currentSteps.value >= 5,
          title: const Text('Kepastian'),
          content: Column(
            children: [
              AdvancedAvatar(
                name: _controller.namaStaff.text == ''
                    ? 'Xde Nama'
                    : _controller.namaStaff.text,
                style: const TextStyle(fontSize: 30),
                image: _controller.imageFile.path.isNotEmpty
                    ? FileImage(_controller.imageFile)
                    : null,
              ),
              const SizedBox(height: 18),
              _info('Nama Staff', _controller.namaStaff.text),
              _info('Email', _controller.emailStaff.text),
              _info('Jawatan', _controller.selectedJawatan.value),
              _info('Cawangan', _controller.selectedCawangan.value),
            ],
          ),
        ),
      ];

  Container _info(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$title : '),
          Text(
            content,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
