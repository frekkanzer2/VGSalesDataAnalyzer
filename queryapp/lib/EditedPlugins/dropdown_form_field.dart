library dropdown_formfield;

import 'package:flutter/material.dart';
import 'package:queryapp/Utils/custom_colors.dart';

class DropDownFormField extends FormField<dynamic> {
  final String titleText;
  final String hintText;
  final bool required;
  final String errorText;
  final dynamic value;
  final List dataSource;
  final String textField;
  final String valueField;
  final Function onChanged;
  final bool filled;
  final EdgeInsets contentPadding;

  DropDownFormField(
      {
        required FormFieldSetter<dynamic> onSaved,
        bool autovalidate = false,
        this.titleText = 'Title',
        this.hintText = 'Select one option',
        this.required = false,
        this.errorText = 'Please select one option',
        this.value,
        required this.dataSource,
        required this.textField,
        required this.valueField,
        required this.onChanged,
        this.filled = true,
        this.contentPadding = const EdgeInsets.fromLTRB(12, 12, 8, 0)})
      : super(
    onSaved: onSaved,
    autovalidate: autovalidate,
    initialValue: value == '' ? null : value,
    builder: (FormFieldState<dynamic> state) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InputDecorator(
              decoration: InputDecoration(
                contentPadding: contentPadding,
                labelText: titleText,
                filled: filled,
                prefixStyle: TextStyle(
                  color: custom_Black_100,
                  fontSize: 18,
                ),
                helperStyle: TextStyle(
                  color: custom_Black_100,
                  fontSize: 18,
                ),
                suffixStyle: TextStyle(
                  color: custom_Black_100,
                  fontSize: 18,
                ),
                counterStyle: TextStyle(
                  color: custom_Black_100,
                  fontSize: 18,
                ),
                labelStyle: TextStyle(
                  color: custom_White_70,
                  fontSize: 18,
                ),
                hintStyle: TextStyle(
                  color: custom_Black_100,
                  fontSize: 24,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<dynamic>(
                  isExpanded: true,
                  hint: Text(
                    hintText,
                    style: TextStyle(color: custom_White_70),
                  ),
                  value: value == '' ? null : value,
                  style: TextStyle(
                    color: custom_White_70,
                    fontSize: 20,
                  ),
                  dropdownColor: custom_Black_100,
                  onChanged: (dynamic newValue) {
                    state.didChange(newValue);
                    onChanged(newValue);
                  },
                  items: dataSource.map((item) {
                    return DropdownMenuItem<dynamic>(
                      value: item[valueField],
                      child: Text(item[textField],
                          overflow: TextOverflow.ellipsis),

                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
