import 'package:flutter/cupertino.dart';
import 'package:flutter_app_forms/app/data/models/formfield.dart';
import 'package:flutter_app_forms/app/data/util/storage_manager.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class LoadFormController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ImagePicker imagePicker = ImagePicker();
  List<DynamicFormField>? formFields;

  @override
  void onInit() {
    super.onInit();
  }

  Future<List<DynamicFormField>?> loadData() async {
    formFields = await StorageManager.readForm();
    return formFields;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
