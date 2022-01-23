import 'package:flutter/cupertino.dart';
import 'package:flutter_app_forms/app/data/models/formfield.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateFormController extends GetxController {
  final List<DynamicFormField> formFields = <DynamicFormField>[];
  final ImagePicker imagePicker = ImagePicker();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final List<String> formTypes = <String>[
    'Text',
    'Number',
    'Email',
    'Password',
    'Photo',
    'DropDown',
    'Date',
    'Time',
    'Switch',
    'CheckBox',
    'RadioButton'
  ];
  var addCheckBoxValue = false.obs,
      addSwitchValue = false.obs,
      addRadioValue = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
