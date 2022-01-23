import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_forms/app/data/models/formfield.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../controllers/load_form_controller.dart';

class LoadFormView extends GetView<LoadFormController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoadFormController>(
      init: LoadFormController(),
      builder: (LoadFormController controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Loaded Fom'),
            centerTitle: true,
          ),
          body: Form(
            key: controller.formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Container(
              margin: EdgeInsets.all(5.0),
              height: Get.height,
              child: FutureBuilder(
                future: controller.loadData(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<DynamicFormField>?> snapShot) {
                  if (snapShot.data != null && snapShot.data!.isNotEmpty) {
                    return GridView.builder(
                        itemCount: controller.formFields!.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 5,
                                childAspectRatio: 2.5,
                                crossAxisSpacing: 5),
                        itemBuilder: (BuildContext context, int index) {
                          DynamicFormField currentItem =
                              controller.formFields![index];
                          if (currentItem.fieldType == 'Text') {
                            return TextFormField(
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field must not be empty';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (String? value) {
                                final int index =
                                    controller.formFields!.indexOf(currentItem);
                                currentItem =
                                    currentItem.copyWith(value: value);
                                controller.formFields!.removeAt(index);
                                controller.formFields!
                                    .insert(index, currentItem);
                              },
                              autovalidateMode: AutovalidateMode.always,
                              controller: TextEditingController(
                                  text: currentItem.value),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: currentItem.labelName),
                            );
                          } else if (currentItem.fieldType == 'Number') {
                            return TextFormField(
                              validator: (String? number) {
                                if (number == null || number.isEmpty) {
                                  return 'Field must not be empty';
                                } else if (!number.isNumericOnly) {
                                  return 'Field must contain only numbers';
                                }
                              },
                              autovalidateMode: AutovalidateMode.always,
                              onSaved: (String? value) {
                                final int index =
                                    controller.formFields!.indexOf(currentItem);
                                currentItem =
                                    currentItem.copyWith(value: value);
                                controller.formFields!.removeAt(index);
                                controller.formFields!
                                    .insert(index, currentItem);
                              },
                              controller: TextEditingController(
                                  text: currentItem.value),
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  labelText: currentItem.labelName),
                            );
                          } else if (currentItem.fieldType == 'Password') {
                            return TextFormField(
                              obscureText: true,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "Password field must not be blank";
                                }
                                value = value.trim();
                                bool hasUppercase =
                                    value.contains(RegExp(r'[A-Z]'));
                                bool hasDigits =
                                    value.contains(RegExp(r'[0-9]'));
                                bool hasLowercase =
                                    value.contains(RegExp(r'[a-z]'));
                                bool hasSpecialCharacters = value.contains(
                                    RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

                                if (value.length > 6 &&
                                    hasUppercase &&
                                    hasDigits &&
                                    hasLowercase &&
                                    hasSpecialCharacters) {
                                  return null;
                                } else {
                                  return "* Your password must be at least 6 characters.\n* Your password must contain at least one uppercase character.\n* Your password must contain at least one lowercase character.\n* Your password must contain at least one numerical character.\n* Your password must contain at least one special character.";
                                }
                              },
                              onSaved: (String? value) {
                                final int index =
                                    controller.formFields!.indexOf(currentItem);
                                currentItem =
                                    currentItem.copyWith(value: value);
                                controller.formFields!.removeAt(index);
                                controller.formFields!
                                    .insert(index, currentItem);
                              },
                              autovalidateMode: AutovalidateMode.always,
                              controller: TextEditingController(
                                  text: currentItem.value),
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                  labelText: currentItem.labelName),
                            );
                          } else if (currentItem.fieldType == 'Email') {
                            return TextFormField(
                              onSaved: (String? value) {
                                final int index =
                                    controller.formFields!.indexOf(currentItem);
                                currentItem =
                                    currentItem.copyWith(value: value);
                                controller.formFields!.removeAt(index);
                                controller.formFields!
                                    .insert(index, currentItem);
                              },
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email must not be empty';
                                }
                                String pattern =
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                RegExp regex = RegExp(pattern);
                                RegExp emailRegex = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+");
                                if (!regex.hasMatch(value) ||
                                    !value.contains(emailRegex)) {
                                  return 'Please enter valid email id';
                                }
                              },
                              autovalidateMode: AutovalidateMode.always,
                              controller: TextEditingController(
                                  text: currentItem.value),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  labelText: currentItem.labelName),
                            );
                          } else if (currentItem.fieldType == 'DropDown') {
                            return DropdownButtonFormField<String>(
                              value: currentItem.selectedValue,
                              autovalidateMode: AutovalidateMode.always,
                              decoration: InputDecoration(
                                  labelText: currentItem.labelName),
                              onChanged: (String? value) {
                                currentItem =
                                    currentItem.copyWith(selectedValue: value);
                                // controller.update();
                              },
                              onSaved: (String? value) {
                                final int index =
                                    controller.formFields!.indexOf(currentItem);
                                currentItem =
                                    currentItem.copyWith(selectedValue: value);
                                controller.formFields!.removeAt(index);
                                controller.formFields!
                                    .insert(index, currentItem);
                              },
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field must not be empty';
                                }
                              },
                              items: currentItem.value
                                  .map<DropdownMenuItem<String>>(
                                      (dynamic value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            );
                          } else if (currentItem.fieldType == 'Date') {
                            return InputDatePickerFormField(
                              initialDate: currentItem.value is String
                                  ? DateTime.tryParse(currentItem.value)
                                  : currentItem.value,
                              fieldLabelText: currentItem.labelName,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                              onDateSaved: (DateTime? date) {
                                final int index =
                                    controller.formFields!.indexOf(currentItem);
                                currentItem = currentItem.copyWith(
                                    value:
                                        DateFormat('yyyy-MM-dd').format(date!));
                                controller.formFields!.removeAt(index);
                                controller.formFields!
                                    .insert(index, currentItem);
                              },
                            );
                          } else if (currentItem.fieldType == 'Time') {
                            DateFormat format = DateFormat.jm();
                            TimeOfDay time = currentItem.value is String
                                ? TimeOfDay.fromDateTime(
                                    format.parse(currentItem.value!))
                                : currentItem.value;
                            return TextFormField(
                              autovalidateMode: AutovalidateMode.always,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field must not be empty';
                                }
                              },
                              onSaved: (String? value) {
                                final int index =
                                    controller.formFields!.indexOf(currentItem);
                                currentItem =
                                    currentItem.copyWith(value: value);
                                controller.formFields!.removeAt(index);
                                controller.formFields!
                                    .insert(index, currentItem);
                              },
                              controller: TextEditingController(
                                  text: time.format(context)),
                              keyboardType: TextInputType.datetime,
                              decoration: InputDecoration(
                                  labelText: currentItem.labelName),
                              readOnly: true,
                              onTap: () {
                                _updateTime(context, currentItem);
                              },
                            );
                          } else if (currentItem.fieldType == 'Switch') {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  currentItem.labelName,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                                CupertinoSwitch(
                                    value: currentItem.value,
                                    onChanged: (bool value) {
                                      final int index = controller.formFields!
                                          .indexOf(currentItem);
                                      currentItem =
                                          currentItem.copyWith(value: value);
                                      controller.formFields!.removeAt(index);
                                      controller.formFields!
                                          .insert(index, currentItem);
                                      controller.update();
                                    })
                              ],
                            );
                          } else if (currentItem.fieldType == 'CheckBox') {
                            return CheckboxListTile(
                                value: currentItem.value,
                                title: Text(
                                  currentItem.labelName,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                                onChanged: (dynamic value) {
                                  final int index = controller.formFields!
                                      .indexOf(currentItem);
                                  currentItem =
                                      currentItem.copyWith(value: value);
                                  controller.formFields!.removeAt(index);
                                  controller.formFields!
                                      .insert(index, currentItem);
                                  controller.update();
                                });
                          } else if (currentItem.fieldType == 'RadioButton') {
                            return RadioListTile(
                              value: true,
                              groupValue: currentItem.value,
                              toggleable: true,
                              title: Text(
                                currentItem.labelName,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                              onChanged: (dynamic value) {
                                final int index =
                                    controller.formFields!.indexOf(currentItem);
                                currentItem =
                                    currentItem.copyWith(value: value ?? false);
                                controller.formFields!.removeAt(index);
                                controller.formFields!
                                    .insert(index, currentItem);
                                controller.update();
                              },
                            );
                          } else if (currentItem.fieldType == 'Photo') {
                            return Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: Image.file(
                                              File(currentItem.value.path))
                                          .image)),
                              child: GestureDetector(
                                onTap: () async {
                                  final XFile? image = await controller
                                      .imagePicker
                                      .pickImage(source: ImageSource.gallery);
                                  if (image != null) {
                                    final int index = controller.formFields!
                                        .indexOf(currentItem);
                                    currentItem =
                                        currentItem.copyWith(value: image);
                                    controller.formFields!.removeAt(index);
                                    controller.formFields!
                                        .insert(index, currentItem);
                                    controller.update();
                                  }
                                },
                              ),
                            );
                          }

                          return Container();
                        });
                  }

                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _updateTime(BuildContext context, DynamicFormField currentItem) async {
    final TimeOfDay? date =
        await showTimePicker(context: context, initialTime: currentItem.value);
    currentItem.copyWith(value: date);
  }
}
