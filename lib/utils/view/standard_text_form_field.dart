import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:flutter/material.dart';

class StandardTextFormField extends StatefulWidget {
  final Function(String) validator;
  final Function(String) onSaved;
  final TextEditingController controller;
  final String initialValue;
  final String hintText;
  final Icon icon;
  final TextInputType keyboardType;
  final int maxLength;

  const StandardTextFormField({
    this.validator,
    this.onSaved,
    this.controller,
    this.initialValue,
    this.hintText,
    this.icon,
    this.keyboardType,
    this.maxLength,
  });

  @override
  _StandardTextFormFieldState createState() => _StandardTextFormFieldState(
      validator, onSaved, controller, initialValue, hintText, icon, keyboardType, maxLength
  );
}

class _StandardTextFormFieldState extends State<StandardTextFormField> {
  final Function(String) validator;
  final Function(String) onSaved;
  final TextEditingController controller;
  final String initialValue;
  final String hintText;
  final Icon icon;
  final TextInputType keyboardType;
  final int maxLength;

  String _error;

  _StandardTextFormFieldState(
    this.validator,
    this.onSaved,
    this.controller,
    this.initialValue,
    this.hintText,
    this.icon,
    this.keyboardType,
    this.maxLength,
  );

  @override
  Widget build(BuildContext ctx) => TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: icon,
          labelText: _error ?? hintText,
          labelStyle: TextStyle(
            color: _error == null ? null : Theme.of(ctx).errorColor,
            fontSize: standardTextFieldLabelFontSize,
          ),
          border: OutlineInputBorder(borderRadius: standardBorderRadius, borderSide: BorderSide()),
          contentPadding: standardTextFieldContentPadding,
        ),
        validator: _validate,
        initialValue: initialValue,
        onSaved: onSaved,
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
      );

  String _validate(String value) {
    if (validator == null) {
      return null;
    }
    final result = validator(value);
    setState(() => _error = result);
    return result == null ? null : "";
  }
}
