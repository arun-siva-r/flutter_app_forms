import 'package:get/get.dart';

import 'package:flutter_app_forms/app/modules/create_form/bindings/create_form_binding.dart';
import 'package:flutter_app_forms/app/modules/create_form/views/create_form_view.dart';
import 'package:flutter_app_forms/app/modules/home/bindings/home_binding.dart';
import 'package:flutter_app_forms/app/modules/home/views/home_view.dart';
import 'package:flutter_app_forms/app/modules/load_form/bindings/load_form_binding.dart';
import 'package:flutter_app_forms/app/modules/load_form/views/load_form_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_FORM,
      page: () => CreateFormView(),
      binding: CreateFormBinding(),
    ),
    GetPage(
      name: _Paths.LOAD_FORM,
      page: () => LoadFormView(),
      binding: LoadFormBinding(),
    ),
  ];
}
