import 'package:flutter/material.dart';
import 'package:flutter_app_forms/app/modules/create_form/views/create_form_view.dart';
import 'package:flutter_app_forms/app/modules/load_form/views/load_form_view.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Get.to(() => CreateFormView());
              },
              child: Text(
                'Create Form',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  minimumSize: Size(Get.width / 2, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(() => LoadFormView());
              },
              child: Text(
                'Load Form',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  minimumSize: Size(Get.width / 2, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            ),
          ],
        ),
      ),
    );
  }
}
