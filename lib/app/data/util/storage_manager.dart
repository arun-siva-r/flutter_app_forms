import 'dart:convert';
import 'dart:io';
import 'package:flutter_app_forms/app/data/models/formfield.dart';
import 'package:path_provider/path_provider.dart';

class StorageManager {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/form.json');
  }

  static Future<List<DynamicFormField>?> readForm() async {
    try {
      final file = await _localFile;
      List<DynamicFormField> formFields = <DynamicFormField>[];
      final contents = await file.readAsString();
      final List<dynamic> entriesDeserialized = json.decode(contents);
      formFields = entriesDeserialized
          .map((dynamic json) => DynamicFormField.fromJson(json))
          .toList();

      return formFields;
    } catch (e) {
      return null;
    }
  }

  static Future<File> writeForm(List<DynamicFormField> details) async {
    final file = await _localFile;
    return file.writeAsString(jsonEncode(details));
  }
}
