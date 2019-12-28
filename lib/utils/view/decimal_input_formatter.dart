import 'package:flutter/services.dart';

class DecimalInputFormatter extends TextInputFormatter {
  final int decimalRange;

  DecimalInputFormatter({this.decimalRange = 2}) : assert(decimalRange >= 0) {
    _regExp = new RegExp("^([0-9]*([.][0-9]{0,$decimalRange}){0,1}){0,1}\$");
  }

  RegExp _regExp;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) =>
    _regExp.hasMatch(newValue.text) ? newValue : oldValue;
}