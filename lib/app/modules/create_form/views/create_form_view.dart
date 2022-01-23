import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_forms/app/data/models/formfield.dart';
import 'package:flutter_app_forms/app/data/util/storage_manager.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../controllers/create_form_controller.dart';

class CreateFormView extends GetView<CreateFormController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateFormController>(
      init: CreateFormController(),
      builder: (CreateFormController controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Create Form'),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _showAddFieldDialog(context);
                },
              ),
              IconButton(
                icon: Icon(Icons.done),
                onPressed: () {
                  if (controller.formKey.currentState!.validate()) {
                    controller.formKey.currentState!.save();
                    Get.snackbar('Success', 'Form Saved');
                    StorageManager.writeForm(controller.formFields);
                  }
                },
              )
            ],
          ),
          body: Form(
            key: controller.formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Container(
              margin: EdgeInsets.all(5.0),
              height: Get.height,
              child: controller.formFields.isEmpty
                  ? Container()
                  : GridView.builder(
                      itemCount: controller.formFields.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 5,
                              childAspectRatio: 2.5,
                              crossAxisSpacing: 5),
                      itemBuilder: (BuildContext context, int index) {
                        DynamicFormField currentItem =
                            controller.formFields[index];
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
                                  controller.formFields.indexOf(currentItem);
                              currentItem = currentItem.copyWith(value: value);
                              controller.formFields.removeAt(index);
                              controller.formFields.insert(index, currentItem);
                            },
                            autovalidateMode: AutovalidateMode.always,
                            controller:
                                TextEditingController(text: currentItem.value),
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
                                  controller.formFields.indexOf(currentItem);
                              currentItem = currentItem.copyWith(value: value);
                              controller.formFields.removeAt(index);
                              controller.formFields.insert(index, currentItem);
                            },
                            controller:
                                TextEditingController(text: currentItem.value),
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
                              bool hasDigits = value.contains(RegExp(r'[0-9]'));
                              bool hasLowercase =
                                  value.contains(RegExp(r'[a-z]'));
                              bool hasSpecialCharacters = value
                                  .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

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
                                  controller.formFields.indexOf(currentItem);
                              currentItem = currentItem.copyWith(value: value);
                              controller.formFields.removeAt(index);
                              controller.formFields.insert(index, currentItem);
                            },
                            autovalidateMode: AutovalidateMode.always,
                            controller:
                                TextEditingController(text: currentItem.value),
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                                labelText: currentItem.labelName),
                          );
                        } else if (currentItem.fieldType == 'Email') {
                          return TextFormField(
                            onSaved: (String? value) {
                              final int index =
                                  controller.formFields.indexOf(currentItem);
                              currentItem = currentItem.copyWith(value: value);
                              controller.formFields.removeAt(index);
                              controller.formFields.insert(index, currentItem);
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
                            controller:
                                TextEditingController(text: currentItem.value),
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
                                  controller.formFields.indexOf(currentItem);
                              currentItem =
                                  currentItem.copyWith(selectedValue: value);
                              controller.formFields.removeAt(index);
                              controller.formFields.insert(index, currentItem);
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'This field must not be empty';
                              }
                            },
                            items: currentItem.value
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          );
                        } else if (currentItem.fieldType == 'Date') {
                          return InputDatePickerFormField(
                            initialDate: currentItem.value,
                            fieldLabelText: currentItem.labelName,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                            onDateSaved: (DateTime? date) {
                              final int index =
                                  controller.formFields.indexOf(currentItem);
                              currentItem = currentItem.copyWith(value: date);
                              controller.formFields.removeAt(index);
                              controller.formFields.insert(index, currentItem);
                            },
                          );
                        } else if (currentItem.fieldType == 'Time') {
                          return TextFormField(
                            autovalidateMode: AutovalidateMode.always,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'This field must not be empty';
                              }
                            },
                            onSaved: (String? value) {
                              DateFormat format = DateFormat.jm();
                              TimeOfDay time =
                                  TimeOfDay.fromDateTime(format.parse(value!));
                              final int index =
                                  controller.formFields.indexOf(currentItem);
                              currentItem = currentItem.copyWith(value: time);
                              controller.formFields.removeAt(index);
                              controller.formFields.insert(index, currentItem);
                            },
                            controller: TextEditingController(
                                text: currentItem.value.format(context)),
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
                                  activeColor: Color(0XFFF59297),
                                  value: currentItem.value,
                                  onChanged: (bool value) {
                                    final int index = controller.formFields
                                        .indexOf(currentItem);
                                    currentItem =
                                        currentItem.copyWith(value: value);
                                    controller.formFields.removeAt(index);
                                    controller.formFields
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
                                final int index =
                                    controller.formFields.indexOf(currentItem);
                                currentItem =
                                    currentItem.copyWith(value: value);
                                controller.formFields.removeAt(index);
                                controller.formFields
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
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                            onChanged: (dynamic value) {
                              final int index =
                                  controller.formFields.indexOf(currentItem);
                              currentItem =
                                  currentItem.copyWith(value: value ?? false);
                              controller.formFields.removeAt(index);
                              controller.formFields.insert(index, currentItem);
                              controller.update();
                            },
                          );
                        } else if (currentItem.fieldType == 'Photo') {
                          return Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        Image.file(File(currentItem.value.path))
                                            .image)),
                            child: GestureDetector(
                              onTap: () async {
                                final XFile? image = await controller
                                    .imagePicker
                                    .pickImage(source: ImageSource.gallery);
                                if (image != null) {
                                  final int index = controller.formFields
                                      .indexOf(currentItem);
                                  currentItem =
                                      currentItem.copyWith(value: image);
                                  controller.formFields.removeAt(index);
                                  controller.formFields
                                      .insert(index, currentItem);
                                  controller.update();
                                }
                              },
                            ),
                          );
                        }

                        return Container();
                      }),
            ),
          ),
        );
      },
    );
  }

  // void _updateDate(BuildContext context, DynamicFormField currentItem) async {
  //   final DateTime? date = await showDatePicker(
  //       context: context,
  //       initialDate: DateTime.parse(currentItem.value),
  //       firstDate: DateTime(1990),
  //       lastDate: DateTime(2100));
  //   currentItem.copyWith(value: date);
  // }

  void _updateTime(BuildContext context, DynamicFormField currentItem) async {
    final TimeOfDay? date =
        await showTimePicker(context: context, initialTime: currentItem.value);
    currentItem.copyWith(value: date);
  }

  Widget _addTextField(String type) {
    String labelName = '', labelValue = '';
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        TextFormField(
          onChanged: (String? value) {
            labelName = value!;
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: 'Add Label Name'),
        ),
        TextFormField(
          onChanged: (String? value) {
            labelValue = value!;
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: 'Label Value'),
        ),
        ElevatedButton(
          onPressed: () {
            DynamicFormField field =
                DynamicFormField(labelName, labelValue, type, null);
            controller.formFields.add(field);
            controller.update();
            Get.close(2);
          },
          child: Text(
            'Okay',
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
              primary: Colors.red,
              minimumSize: Size(Get.width / 2, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)))),
        ),
      ],
    );
  }

  Widget _addDropDown(String type) {
    String labelName = '', labelValue = '';
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        TextFormField(
          onChanged: (String? value) {
            labelName = value!;
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: 'Add Label Name'),
        ),
        TextFormField(
          onChanged: (String? value) {
            labelValue = value!;
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: 'Add values'),
        ),
        ElevatedButton(
          onPressed: () {
            DynamicFormField field = DynamicFormField(labelName,
                labelValue.split(','), type, labelValue.split(',')[0]);
            controller.formFields.add(field);
            controller.update();
            Get.close(2);
          },
          child: Text(
            'Okay',
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
              primary: Colors.red,
              minimumSize: Size(Get.width / 2, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)))),
        ),
      ],
    );
  }

  Widget _addDate(String type, BuildContext context) {
    String labelName = '';
    DateTime? date;
    TextEditingController textEditingController = TextEditingController();
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        TextFormField(
          onChanged: (String? value) {
            labelName = value!;
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: 'Add Label Name'),
        ),
        TextFormField(
          readOnly: true,
          controller: textEditingController,
          onTap: () async {
            date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100));

            if (date != null) {
              textEditingController.text =
                  DateFormat('dd-MM-yyyy').format(date!);
            }
          },
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: 'Date Value'),
        ),
        ElevatedButton(
          onPressed: () {
            DynamicFormField field =
                DynamicFormField(labelName, date, type, null);
            controller.formFields.add(field);
            controller.update();
            Get.close(2);
          },
          child: Text(
            'Okay',
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
              primary: Colors.red,
              minimumSize: Size(Get.width / 2, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)))),
        ),
      ],
    );
  }

  Widget _addTime(String type, BuildContext context) {
    String labelName = '';
    TimeOfDay? time;
    TextEditingController textEditingController = TextEditingController();
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        TextFormField(
          onChanged: (String? value) {
            labelName = value!;
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: 'Add Label Name'),
        ),
        TextFormField(
          readOnly: true,
          controller: textEditingController,
          onTap: () async {
            time = await showTimePicker(
                context: context, initialTime: TimeOfDay.now());
            if (time != null) {
              textEditingController.text = time!.format(context);
            }
          },
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: 'Date Value'),
        ),
        ElevatedButton(
          onPressed: () {
            DynamicFormField field =
                DynamicFormField(labelName, time, type, null);
            controller.formFields.add(field);
            controller.update();
            Get.close(2);
          },
          child: Text(
            'Okay',
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
              primary: Colors.red,
              minimumSize: Size(Get.width / 2, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)))),
        ),
      ],
    );
  }

  Widget _addBoolFields(String type) {
    String labelName = '';
    bool labelValue = controller.addSwitchValue.value;
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        TextFormField(
          onChanged: (String? value) {
            labelName = value!;
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: 'Add Label Name'),
        ),
        Obx(() => type == 'Switch'
            ? CupertinoSwitch(
                value: controller.addSwitchValue.value,
                onChanged: (bool value) {
                  labelValue = value;
                  controller.addSwitchValue.value = value;
                })
            : type == 'CheckBox'
                ? CheckboxListTile(
                    value: controller.addCheckBoxValue.value,
                    onChanged: (bool? value) {
                      labelValue = value!;
                      controller.addCheckBoxValue.value = value;
                    })
                : Radio(
                    value: true,
                    groupValue: controller.addRadioValue.value,
                    toggleable: true,
                    onChanged: (bool? value) {
                      labelValue = value ?? false;
                      controller.addRadioValue.value = value ?? false;
                    },
                  )),
        ElevatedButton(
          onPressed: () {
            DynamicFormField field =
                DynamicFormField(labelName, labelValue, type, labelValue);
            controller.formFields.add(field);
            controller.update();
            Get.close(2);
          },
          child: Text(
            'Okay',
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
              primary: Colors.red,
              minimumSize: Size(Get.width / 2, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)))),
        ),
      ],
    );
  }

  Widget _addImage(String type) {
    String labelName = '';
    XFile? image;
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        TextFormField(
          onChanged: (String? value) {
            labelName = value!;
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: 'Add Label Name'),
        ),
        TextFormField(
          readOnly: true,
          onTap: () async {
            image = await controller.imagePicker
                .pickImage(source: ImageSource.gallery);
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: 'Upload Image'),
        ),
        ElevatedButton(
          onPressed: () {
            DynamicFormField field =
                DynamicFormField(labelName, image, type, null);
            controller.formFields.add(field);
            controller.update();
            Get.close(2);
          },
          child: Text(
            'Okay',
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
              primary: Colors.red,
              minimumSize: Size(Get.width / 2, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)))),
        ),
      ],
    );
  }

  Future<Widget?> _showAddFieldDialog(BuildContext context) async {
    return await showDialog<Widget>(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: Center(
              child: Container(
                width: Get.width * 0.8,
                height: Get.height * 0.55,
                child: Card(
                  color: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(10.0),
                    width: Get.width * 0.8,
                    height: Get.height * 0.55,
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10),
                        itemCount: controller.formTypes.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String currentType =
                              controller.formTypes[index];
                          return TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return WillPopScope(
                                        onWillPop: () async {
                                          return true;
                                        },
                                        child: Center(
                                          child: Container(
                                            width: Get.width * 0.8,
                                            height: Get.height * 0.35,
                                            child: Card(
                                                color: Colors.white,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    4))),
                                                child: Container(
                                                  width: Get.width * 0.8,
                                                  height: Get.height * 0.35,
                                                  margin: EdgeInsets.all(10),
                                                  padding: EdgeInsets.all(10),
                                                  child: currentType ==
                                                              'Text' ||
                                                          currentType ==
                                                              'Number' ||
                                                          currentType ==
                                                              'Email' ||
                                                          currentType ==
                                                              'Password'
                                                      ? _addTextField(
                                                          currentType)
                                                      : currentType ==
                                                              'DropDown'
                                                          ? _addDropDown(
                                                              currentType)
                                                          : currentType ==
                                                                  'Date'
                                                              ? _addDate(
                                                                  currentType,
                                                                  context)
                                                              : currentType ==
                                                                      'Time'
                                                                  ? _addTime(
                                                                      currentType,
                                                                      context)
                                                                  : currentType ==
                                                                          'Photo'
                                                                      ? _addImage(
                                                                          currentType)
                                                                      : _addBoolFields(
                                                                          currentType),
                                                )),
                                          ),
                                        ));
                                  });
                            },
                            style: TextButton.styleFrom(
                                primary: Colors.red,
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)))),
                            child: Text(
                              currentType,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          );
                        }),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
