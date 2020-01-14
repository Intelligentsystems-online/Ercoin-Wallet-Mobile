import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StandardTextFormField extends StatefulWidget {
  final Function(String) validator;
  final Function(String) onSaved;
  final Function() onFocusLost;
  final TextEditingController controller;
  final String initialValue;
  final String hintText;
  final Icon icon;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final int maxLength;

  const StandardTextFormField({
    this.validator,
    this.onSaved,
    this.onFocusLost,
    this.controller,
    this.initialValue,
    this.hintText,
    this.icon,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
  });

  @override
  _StandardTextFormFieldState createState() => _StandardTextFormFieldState(
      validator, onSaved, onFocusLost, controller, initialValue,
      hintText, icon, keyboardType, inputFormatters, maxLength
  );
}

class _StandardTextFormFieldState extends State<StandardTextFormField> {
  final Function(String) validator;
  final Function(String) onSaved;
  final Function() onFocusLost;
  final TextEditingController controller;
  final String initialValue;
  final String hintText;
  final Icon icon;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final int maxLength;

  String _error;

  final _focusNode = FocusNode();

  _StandardTextFormFieldState(
    this.validator,
    this.onSaved,
    this.onFocusLost,
    this.controller,
    this.initialValue,
    this.hintText,
    this.icon,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
  );

  @override
  initState() {
    super.initState();
    _focusNode.addListener(() {
      if(!_focusNode.hasFocus && onFocusLost != null) {
        onFocusLost();
      }
    });
  }

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
        focusNode: _focusNode,
        validator: _validate,
        initialValue: initialValue,
        onSaved: onSaved,
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
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
