import 'package:admin_panel/config/supplier.dart';
import 'package:admin_panel/spareparts/controller/add_spareparts_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddSparepart extends StatelessWidget {
  final _controller = Get.put(AddSparepartsController());
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
                    'Spareparts',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Parts Identification: 21413234',
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
              child: Obx(() => Stepper(
                    currentStep: _controller.currentSteps.value,
                    steps: [
                      Step(
                        title: Text('Supplier'),
                        content: DropdownButton(
                          items: Supplier.supplier.map((String value) {
                            return DropdownMenuItem(
                              child: Text(
                                Supplier.getSupplierCode(
                                  value.toString(),
                                ),
                              ),
                              value: value,
                            );
                          }).toList(),
                          value: _controller.selectedSupplier.value,
                          onChanged: (String newValue) {
                            _controller.selectedSupplier.value = newValue;
                          },
                        ),
                      )
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
