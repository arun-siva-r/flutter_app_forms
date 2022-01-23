class DynamicFormField {
  late String labelName;
  late String fieldType;
  late dynamic value;
  late dynamic selectedValue;

  DynamicFormField(
      this.labelName, this.value, this.fieldType, this.selectedValue);

  DynamicFormField.fromJson(Map<String, dynamic> json) {
    labelName = json['labelName'];
    value = json['value'];
    fieldType = json['fieldType'];
    selectedValue = json['selectedValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['labelName'] = labelName;
    data['value'] = value;
    data['fieldType'] = fieldType;
    data['selectedValue'] = selectedValue;
    return data;
  }

  DynamicFormField copyWith(
      {String? labelName,
      dynamic value,
      String? fieldType,
      dynamic selectedValue}) {
    return DynamicFormField(labelName ?? this.labelName, value ?? this.value,
        fieldType ?? this.fieldType, selectedValue ?? this.selectedValue);
  }
}
